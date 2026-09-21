import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../data/camera_capture_gateway.dart';
import '../domain/document_import.dart';

enum _CameraStage { capture, review }

/// Focused camera flow. A capture becomes an Analyze draft only after Review.
class CameraCapturePage extends ConsumerStatefulWidget {
  const CameraCapturePage({super.key, this.initialSelection});

  /// A camera selection re-enters Review through camera-owned working copies.
  final DocumentImportSelection? initialSelection;

  @override
  ConsumerState<CameraCapturePage> createState() => _CameraCapturePageState();
}

class _CameraCapturePageState extends ConsumerState<CameraCapturePage>
    with WidgetsBindingObserver {
  late final CameraCaptureSession _session;
  CameraCaptureState _state = CameraCaptureState.permissionNotRequested;
  final List<CameraCaptureCandidate> _acceptedPages = [];
  CameraCaptureCandidate? _currentCandidate;
  var _selectedPageIndex = 0;
  int? _replacementTargetIndex;
  _CameraStage _stage = _CameraStage.capture;
  String? _reviewMessage;
  var _takingPicture = false;
  var _editing = false;
  var _restoringInitialDraft = false;
  var _disposed = false;
  var _ownershipTransferred = false;
  final List<CameraCaptureCandidate> _initialDraftPages = [];
  Future<void>? _startup;
  var _transitionGeneration = 0;
  var _captureRestartRequired = false;
  var _resumeRequested = false;
  var _startupInvalidatedByPause = false;
  var _pauseQueued = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _session = ref.read(cameraCaptureGatewayProvider).createSession();
    final initialSelection = widget.initialSelection;
    if (initialSelection == null) {
      unawaited(_startCamera(resume: false));
    } else {
      _stage = _CameraStage.review;
      _restoringInitialDraft = true;
      unawaited(_restoreInitialDraft(initialSelection));
    }
  }

  Future<void> _restoreInitialDraft(DocumentImportSelection selection) async {
    final originals = [
      for (final file in selection.files)
        CameraCaptureCandidate(
          localUri: file.localUri,
          capturedAt: file.importedAt,
        ),
    ];
    final workingPages = <CameraCaptureCandidate>[];
    try {
      for (final candidate in originals) {
        workingPages.add(await _session.duplicate(candidate));
      }
      if (!mounted || _disposed) {
        await Future.wait(workingPages.map(_session.discard));
        return;
      }
      setState(() {
        _initialDraftPages.addAll(originals);
        _acceptedPages.addAll(workingPages);
        _selectedPageIndex = 0;
        _restoringInitialDraft = false;
      });
    } catch (_) {
      await Future.wait(workingPages.map(_session.discard));
      if (!mounted || _disposed) return;
      setState(() {
        _restoringInitialDraft = false;
        _stage = _CameraStage.capture;
        _state = CameraCaptureState.failed;
      });
    }
  }

  Future<void> _startCamera({required bool resume}) async {
    if (_disposed || !mounted || _stage != _CameraStage.capture) return;
    if (_state == CameraCaptureState.ready && !_captureRestartRequired) return;
    final activeStartup = _startup;
    if (activeStartup != null) return activeStartup;

    final generation = _transitionGeneration;
    final completion = Completer<void>();
    _startup = completion.future;
    try {
      final state = resume
          ? await _session.resume()
          : await _session.initialize();
      if (!mounted ||
          _disposed ||
          _stage != _CameraStage.capture ||
          generation != _transitionGeneration) {
        return;
      }
      setState(() => _state = state);
      _captureRestartRequired = state != CameraCaptureState.ready;
      _startupInvalidatedByPause = false;
    } catch (_) {
      if (!mounted ||
          _disposed ||
          _stage != _CameraStage.capture ||
          generation != _transitionGeneration) {
        return;
      }
      setState(() => _state = CameraCaptureState.failed);
      _captureRestartRequired = true;
    } finally {
      completion.complete();
      if (identical(_startup, completion.future)) _startup = null;
      final shouldResumeAfterPause =
          _resumeRequested && _startupInvalidatedByPause;
      _resumeRequested = false;
      if (shouldResumeAfterPause &&
          mounted &&
          !_disposed &&
          _stage == _CameraStage.capture) {
        unawaited(_startCamera(resume: true));
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_disposed || _stage == _CameraStage.review) return;
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        unawaited(_pauseCaptureForLifecycle());
        return;
      case AppLifecycleState.resumed:
        if (_state == CameraCaptureState.ready && !_captureRestartRequired) {
          return;
        }
        _resumeRequested = true;
        unawaited(_startCamera(resume: true));
        return;
    }
  }

  Future<void> _pauseCaptureForLifecycle() async {
    if (_pauseQueued || _disposed || _stage != _CameraStage.capture) return;
    _pauseQueued = true;
    _transitionGeneration++;
    _captureRestartRequired = true;
    _startupInvalidatedByPause = true;
    if (mounted && _state == CameraCaptureState.ready) {
      setState(() => _state = CameraCaptureState.permissionNotRequested);
    }
    try {
      await _session.pause();
    } finally {
      _pauseQueued = false;
    }
  }

  Future<void> _resumeCapture() async {
    _captureRestartRequired = true;
    await _startCamera(resume: true);
  }

  Future<void> _capture() async {
    if (_state != CameraCaptureState.ready || _takingPicture) return;
    setState(() => _takingPicture = true);
    try {
      final candidate = await _session.capture();
      if (!mounted || _disposed) {
        await _session.discard(candidate);
        return;
      }
      setState(() {
        _currentCandidate = candidate;
        _selectedPageIndex = _currentCandidateIndex;
        _stage = _CameraStage.review;
        _reviewMessage = null;
      });
      // The capture build contains CameraPreview. Let the Review build remove
      // it before releasing the controller it references.
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted || _disposed || _stage != _CameraStage.review) return;
      await _session.pause();
    } catch (_) {
      if (!mounted || _disposed) return;
      setState(() => _state = CameraCaptureState.failed);
    } finally {
      if (mounted && !_disposed) setState(() => _takingPicture = false);
    }
  }

  List<CameraCaptureCandidate> get _reviewPages {
    final pages = List<CameraCaptureCandidate>.of(_acceptedPages);
    final candidate = _currentCandidate;
    if (candidate == null) return pages;
    final replacementTargetIndex = _replacementTargetIndex;
    if (replacementTargetIndex != null) {
      pages[replacementTargetIndex] = candidate;
    } else {
      pages.add(candidate);
    }
    return pages;
  }

  int get _currentCandidateIndex =>
      _replacementTargetIndex ?? _acceptedPages.length;

  CameraCaptureCandidate? get _selectedCandidate {
    final pages = _reviewPages;
    return pages.isEmpty ? null : pages[_selectedPageIndex];
  }

  bool get _selectedIsCurrentCandidate =>
      _currentCandidate != null && _selectedPageIndex == _currentCandidateIndex;

  Future<void> _retake() async {
    if (_editing) return;
    if (_selectedIsCurrentCandidate) {
      final candidate = _currentCandidate;
      if (candidate != null) await _session.discard(candidate);
      if (!mounted || _disposed) return;
      setState(() {
        _currentCandidate = null;
        _stage = _CameraStage.capture;
        _state = CameraCaptureState.permissionNotRequested;
        _reviewMessage = null;
      });
      await _resumeCapture();
      return;
    }
    if (_selectedPageIndex < 0 || _selectedPageIndex >= _acceptedPages.length) {
      return;
    }
    setState(() {
      _replacementTargetIndex = _selectedPageIndex;
      _stage = _CameraStage.capture;
      _state = CameraCaptureState.permissionNotRequested;
      _reviewMessage = null;
    });
    await _resumeCapture();
  }

  Future<void> _rotateRight() async {
    final candidate = _selectedCandidate;
    if (candidate == null || _editing) return;
    setState(() {
      _editing = true;
      _reviewMessage = null;
    });
    try {
      final rotated = await _session.rotateRight(candidate);
      if (!mounted || _disposed || _stage != _CameraStage.review) return;
      setState(() {
        if (_selectedIsCurrentCandidate) {
          _currentCandidate = rotated;
        } else {
          _acceptedPages[_selectedPageIndex] = rotated;
        }
      });
    } catch (_) {
      if (!mounted || _disposed) return;
      setState(() => _reviewMessage = context.l10n.cameraRotateFailed);
    } finally {
      if (mounted && !_disposed) setState(() => _editing = false);
    }
  }

  Future<void> _crop() async {
    final candidate = _selectedCandidate;
    if (candidate == null || _editing) return;
    final region = await Navigator.of(context).push<CameraCropRegion>(
      MaterialPageRoute(builder: (_) => _CameraCropPage(candidate: candidate)),
    );
    if (region == null || !mounted || _disposed) return;
    setState(() {
      _editing = true;
      _reviewMessage = null;
    });
    try {
      final cropped = await _session.crop(candidate, region);
      if (!mounted || _disposed || _stage != _CameraStage.review) return;
      setState(() {
        if (_selectedIsCurrentCandidate) {
          _currentCandidate = cropped;
        } else {
          _acceptedPages[_selectedPageIndex] = cropped;
        }
      });
    } catch (_) {
      if (!mounted || _disposed) return;
      setState(() => _reviewMessage = context.l10n.cameraCropFailed);
    } finally {
      if (mounted && !_disposed) setState(() => _editing = false);
    }
  }

  Future<void> _addAnotherPage() async {
    if (_editing || _reviewPages.length >= 10) return;
    await _acceptCurrentCandidate();
    if (!mounted || _disposed) return;
    setState(() {
      _stage = _CameraStage.capture;
      _state = CameraCaptureState.permissionNotRequested;
      _reviewMessage = null;
    });
    await _resumeCapture();
  }

  Future<void> _acceptCurrentCandidate() async {
    final candidate = _currentCandidate;
    if (candidate == null || !mounted || _disposed) return;
    final replacementTargetIndex = _replacementTargetIndex;
    CameraCaptureCandidate? replaced;
    setState(() {
      _currentCandidate = null;
      _replacementTargetIndex = null;
      if (replacementTargetIndex == null) {
        _acceptedPages.add(candidate);
      } else {
        replaced = _acceptedPages[replacementTargetIndex];
        _acceptedPages[replacementTargetIndex] = candidate;
        _selectedPageIndex = replacementTargetIndex;
      }
    });
    if (replaced != null) await _session.discard(replaced!);
  }

  Future<void> _removePage(int index) async {
    final pages = [..._acceptedPages, ?_currentCandidate];
    if (_editing || index < 0 || index >= pages.length) return;
    if (_currentCandidate != null && index == _currentCandidateIndex) {
      final candidate = _currentCandidate!;
      await _session.discard(candidate);
      if (!mounted || _disposed) return;
      setState(() {
        _currentCandidate = null;
        _replacementTargetIndex = null;
        if (_acceptedPages.isEmpty) {
          _selectedPageIndex = 0;
          _stage = _CameraStage.capture;
          _state = CameraCaptureState.permissionNotRequested;
        } else {
          _selectedPageIndex = _selectedPageIndex
              .clamp(0, _acceptedPages.length - 1)
              .toInt();
        }
        _reviewMessage = null;
      });
      if (_acceptedPages.isEmpty) await _resumeCapture();
      return;
    }
    final candidate = _acceptedPages[index];
    await _session.discard(candidate);
    if (!mounted || _disposed) return;
    setState(() {
      _acceptedPages.removeAt(index);
      if (_acceptedPages.isEmpty && _currentCandidate == null) {
        _selectedPageIndex = 0;
        _stage = _CameraStage.capture;
        _state = CameraCaptureState.permissionNotRequested;
      } else if (index < _selectedPageIndex) {
        _selectedPageIndex--;
      } else if (index == _selectedPageIndex) {
        _selectedPageIndex = _selectedPageIndex
            .clamp(0, _reviewPages.length - 1)
            .toInt();
      }
      _reviewMessage = null;
    });
    if (_acceptedPages.isEmpty && _currentCandidate == null) {
      await _resumeCapture();
    }
  }

  void _selectPage(int index) {
    final pages = _reviewPages;
    if (_editing || index < 0 || index >= pages.length) return;
    if (_currentCandidate != null && index != _currentCandidateIndex) {
      unawaited(_acceptCurrentCandidate());
    }
    setState(() => _selectedPageIndex = index);
  }

  Future<void> _continueToAnalyze() async {
    if (_reviewPages.isEmpty || _editing) return;
    await _continueAfterAcceptingCandidate();
  }

  Future<void> _continueAfterAcceptingCandidate() async {
    await _acceptCurrentCandidate();
    if (!mounted || _disposed || _acceptedPages.isEmpty) return;
    final navigator = Navigator.of(context);
    final selection = DocumentImportSelection([
      for (final candidate in _acceptedPages)
        DocumentImportCandidate(
          localUri: candidate.localUri,
          mediaType: ImportedMediaType.image,
          source: ImportSource.camera,
          originalFilename:
              'camera-${candidate.capturedAt.millisecondsSinceEpoch}.jpg',
          importedAt: candidate.capturedAt,
        ),
    ]);
    // The incoming Analyze draft remains intact until this deliberate handoff.
    // Review works with duplicate files, so cancel/back can retain that draft.
    await Future.wait(_initialDraftPages.map(_session.discard));
    _initialDraftPages.clear();
    if (!mounted || _disposed) return;
    // Keep the route's current render state through its pop animation. File
    // cleanup ownership transfers to the Analyze session draft immediately.
    _ownershipTransferred = true;
    navigator.pop(selection);
  }

  Future<void> _back() async {
    if (_stage == _CameraStage.capture &&
        _replacementTargetIndex != null &&
        _currentCandidate == null) {
      setState(() {
        _selectedPageIndex = _replacementTargetIndex!;
        _replacementTargetIndex = null;
        _stage = _CameraStage.review;
      });
      return;
    }
    if (_stage == _CameraStage.capture && _reviewPages.isEmpty) {
      if (mounted) Navigator.of(context).maybePop();
      return;
    }
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.cameraDiscardPagesTitle),
        content: Text(context.l10n.cameraDiscardPagesMessage),
        actions: [
          TextButton(
            key: const Key('camera-review-keep-editing'),
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.cameraKeepEditing),
          ),
          FilledButton(
            key: const Key('camera-review-discard-pages'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.l10n.cameraDiscardPages),
          ),
        ],
      ),
    );
    if (discard != true || !mounted || _disposed) return;
    final pages = [..._acceptedPages, ?_currentCandidate];
    _acceptedPages.clear();
    _currentCandidate = null;
    await Future.wait(pages.map(_session.discard));
    if (mounted && !_disposed) Navigator.of(context).maybePop();
  }

  Future<void> _toggleFlash() async {
    await _session.toggleFlash();
    if (mounted && !_disposed) setState(() {});
  }

  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    if (!_ownershipTransferred) {
      for (final candidate in [..._acceptedPages, ?_currentCandidate]) {
        unawaited(_session.discard(candidate));
      }
    }
    unawaited(_session.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _stage == _CameraStage.review
      ? _restoringInitialDraft
            ? Scaffold(
                key: const Key('camera-review-page'),
                backgroundColor: AppColors.background,
                body: const Center(child: CircularProgressIndicator()),
              )
            : _CameraReviewSurface(
                pages: _reviewPages,
                selectedPageIndex: _selectedPageIndex,
                editing: _editing,
                message: _reviewMessage,
                onBack: _back,
                onRetake: _retake,
                onRotate: _rotateRight,
                onCrop: _crop,
                onAddAnotherPage: _addAnotherPage,
                onSelectPage: _selectPage,
                onRemovePage: _removePage,
                onContinue: _continueToAnalyze,
              )
      : _buildCapture(context);

  Widget _buildCapture(BuildContext context) {
    final ready = _state == CameraCaptureState.ready;
    return Scaffold(
      key: const Key('camera-capture-page'),
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (ready)
            _session.buildPreview()
          else
            _CameraStateView(state: _state),
          if (ready) ...[
            const _DocumentGuide(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  AppSpacing.sm,
                  AppSpacing.sm,
                  AppSpacing.sm,
                  0,
                ),
                child: Row(
                  children: [
                    IconButton.filledTonal(
                      key: const Key('camera-capture-back'),
                      tooltip: MaterialLocalizations.of(context)
                          .backButtonTooltip,
                      onPressed: _back,
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Spacer(),
                    if (_session.isFlashControlAvailable)
                      IconButton.filledTonal(
                        key: const Key('camera-capture-flash'),
                        tooltip: context.l10n.cameraFlash,
                        onPressed: _toggleFlash,
                        icon: Icon(
                          _session.isFlashOn ? Icons.flash_on : Icons.flash_off,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                  child: Semantics(
                    button: true,
                    label: context.l10n.captureDocument,
                    child: SizedBox(
                      width: 76,
                      height: 76,
                      child: FilledButton(
                        key: const Key('camera-capture-shutter'),
                        onPressed: _takingPicture ? null : _capture,
                        style: FilledButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          padding: EdgeInsets.zero,
                        ),
                        child: _takingPicture
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.camera_alt, size: 32),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ] else
            SafeArea(
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: IconButton.filledTonal(
                    key: const Key('camera-capture-back'),
                    tooltip: MaterialLocalizations.of(context)
                        .backButtonTooltip,
                    onPressed: _back,
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CameraReviewSurface extends StatelessWidget {
  const _CameraReviewSurface({
    required this.pages,
    required this.selectedPageIndex,
    required this.editing,
    required this.message,
    required this.onBack,
    required this.onRetake,
    required this.onRotate,
    required this.onCrop,
    required this.onAddAnotherPage,
    required this.onSelectPage,
    required this.onRemovePage,
    required this.onContinue,
  });

  final List<CameraCaptureCandidate> pages;
  final int selectedPageIndex;
  final bool editing;
  final String? message;
  final Future<void> Function() onBack;
  final Future<void> Function() onRetake;
  final Future<void> Function() onRotate;
  final Future<void> Function() onCrop;
  final Future<void> Function() onAddAnotherPage;
  final ValueChanged<int> onSelectPage;
  final Future<void> Function(int) onRemovePage;
  final Future<void> Function() onContinue;

  @override
  Widget build(BuildContext context) {
    final candidate = pages[selectedPageIndex];
    final canAdd = pages.length < 10;
    return Scaffold(
      key: const Key('camera-review-page'),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: IconButton(
                  key: const Key('camera-review-back'),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  onPressed: editing ? null : onBack,
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File.fromUri(candidate.localUri),
                      key: Key('camera-review-preview-$selectedPageIndex'),
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: AppSpacing.sm,
                children: [
                  TextButton.icon(
                    key: const Key('camera-review-rotate'),
                    onPressed: editing ? null : onRotate,
                    icon: const Icon(Icons.rotate_right),
                    label: Text(context.l10n.cameraRotate),
                  ),
                  TextButton.icon(
                    key: const Key('camera-review-crop'),
                    onPressed: editing ? null : onCrop,
                    icon: const Icon(Icons.crop),
                    label: Text(context.l10n.cameraCrop),
                  ),
                ],
              ),
              if (pages.length > 1) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  context.l10n.cameraPagesForAnalysis,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: AppSpacing.xs),
                SizedBox(
                  height: 76,
                  child: ListView.separated(
                    key: const Key('camera-review-thumbnails'),
                    scrollDirection: Axis.horizontal,
                    itemCount: pages.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, index) => _CameraPageThumbnail(
                      candidate: pages[index],
                      index: index,
                      selected: index == selectedPageIndex,
                      onSelect: editing ? null : () => onSelectPage(index),
                      onRemove: editing ? null : () => onRemovePage(index),
                    ),
                  ),
                ),
              ],
              if (message != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  message!,
                  key: const Key('camera-review-message'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      key: const Key('camera-review-retake'),
                      onPressed: editing ? null : onRetake,
                      child: Text(context.l10n.cameraRetake),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: OutlinedButton.icon(
                      key: const Key('camera-review-add-page'),
                      onPressed: editing || !canAdd ? null : onAddAnotherPage,
                      icon: const Icon(Icons.add_photo_alternate_outlined),
                      label: Text(context.l10n.cameraAddAnotherPage),
                    ),
                  ),
                ],
              ),
              if (!canAdd) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  context.l10n.cameraMaximumPages,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              FilledButton(
                key: const Key('camera-review-continue'),
                onPressed: editing || pages.isEmpty ? null : onContinue,
                child: Text(context.l10n.cameraContinue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CameraPageThumbnail extends StatelessWidget {
  const _CameraPageThumbnail({
    required this.candidate,
    required this.index,
    required this.selected,
    required this.onSelect,
    required this.onRemove,
  });

  final CameraCaptureCandidate candidate;
  final int index;
  final bool selected;
  final VoidCallback? onSelect;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    label: '${context.l10n.images} ${index + 1}',
    child: SizedBox(
      width: 76,
      child: Stack(
        fit: StackFit.expand,
        children: [
          OutlinedButton(
            key: Key('camera-review-thumbnail-$index'),
            onPressed: onSelect,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              side: BorderSide(
                color: selected ? AppColors.primary : AppColors.surfaceAlt,
                width: selected ? 2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File.fromUri(candidate.localUri),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(Icons.image_outlined),
              ),
            ),
          ),
          PositionedDirectional(
            top: 0,
            end: 0,
            child: IconButton.filledTonal(
              key: Key('camera-review-remove-page-$index'),
              tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
              onPressed: onRemove,
              iconSize: 16,
              constraints: const BoxConstraints.tightFor(width: 30, height: 30),
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    ),
  );
}

class _CameraCropPage extends StatefulWidget {
  const _CameraCropPage({required this.candidate});

  final CameraCaptureCandidate candidate;

  @override
  State<_CameraCropPage> createState() => _CameraCropPageState();
}

class _CameraCropPageState extends State<_CameraCropPage> {
  var _left = 0.08;
  var _top = 0.08;
  var _right = 0.92;
  var _bottom = 0.92;

  CameraCropRegion get _region =>
      CameraCropRegion(left: _left, top: _top, right: _right, bottom: _bottom);

  @override
  Widget build(BuildContext context) => Scaffold(
    key: const Key('camera-crop-page'),
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      title: Text(context.l10n.cameraCrop),
      leading: IconButton(
        key: const Key('camera-crop-cancel'),
        tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.close),
      ),
    ),
    body: SafeArea(
      top: false,
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    File.fromUri(widget.candidate.localUri),
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  Positioned(
                    left: constraints.maxWidth * _left,
                    top: constraints.maxHeight * _top,
                    width: constraints.maxWidth * (_right - _left),
                    height: constraints.maxHeight * (_bottom - _top),
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: AppColors.background,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                _CropSlider(
                  label: '←',
                  value: _left,
                  min: 0,
                  max: _right - 0.1,
                  onChanged: (value) => setState(() => _left = value),
                ),
                _CropSlider(
                  label: '↑',
                  value: _top,
                  min: 0,
                  max: _bottom - 0.1,
                  onChanged: (value) => setState(() => _top = value),
                ),
                _CropSlider(
                  label: '→',
                  value: _right,
                  min: _left + 0.1,
                  max: 1,
                  onChanged: (value) => setState(() => _right = value),
                ),
                _CropSlider(
                  label: '↓',
                  value: _bottom,
                  min: _top + 0.1,
                  max: 1,
                  onChanged: (value) => setState(() => _bottom = value),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: const Key('camera-crop-apply'),
                    onPressed: () => Navigator.of(context).pop(_region),
                    child: Text(context.l10n.cameraCrop),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _CropSlider extends StatelessWidget {
  const _CropSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      SizedBox(width: 24, child: Text(label, textAlign: TextAlign.center)),
      Expanded(
        child: Slider(
          value: value.clamp(min, max).toDouble(),
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ),
    ],
  );
}

class _DocumentGuide extends StatelessWidget {
  const _DocumentGuide();

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Center(
      child: FractionallySizedBox(
        widthFactor: 0.82,
        heightFactor: 0.68,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white70, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    ),
  );
}

class _CameraStateView extends StatelessWidget {
  const _CameraStateView({required this.state});

  final CameraCaptureState state;

  @override
  Widget build(BuildContext context) {
    final (icon, message) = switch (state) {
      CameraCaptureState.permissionNotRequested => (
        Icons.camera_alt_outlined,
        context.l10n.cameraPreparing,
      ),
      CameraCaptureState.permissionDenied => (
        Icons.no_photography_outlined,
        context.l10n.cameraPermissionDenied,
      ),
      CameraCaptureState.permissionPermanentlyDenied => (
        Icons.settings_outlined,
        context.l10n.cameraPermissionSettingsRequired,
      ),
      CameraCaptureState.permissionRestricted => (
        Icons.lock_outline,
        context.l10n.cameraPermissionRestricted,
      ),
      CameraCaptureState.unavailable => (
        Icons.videocam_off_outlined,
        context.l10n.cameraUnavailable,
      ),
      CameraCaptureState.failed => (
        Icons.error_outline,
        context.l10n.cameraInitializationFailed,
      ),
      CameraCaptureState.ready => (Icons.camera_alt_outlined, ''),
    };
    return ColoredBox(
      color: AppColors.background,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state == CameraCaptureState.permissionNotRequested)
                const CircularProgressIndicator()
              else
                Icon(icon, color: AppColors.primary, size: 40),
              const SizedBox(height: AppSpacing.md),
              Text(
                message,
                key: const Key('camera-capture-state-message'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
