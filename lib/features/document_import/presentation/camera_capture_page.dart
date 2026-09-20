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
  const CameraCapturePage({super.key});

  @override
  ConsumerState<CameraCapturePage> createState() => _CameraCapturePageState();
}

class _CameraCapturePageState extends ConsumerState<CameraCapturePage>
    with WidgetsBindingObserver {
  late final CameraCaptureSession _session;
  CameraCaptureState _state = CameraCaptureState.permissionNotRequested;
  CameraCaptureCandidate? _candidate;
  _CameraStage _stage = _CameraStage.capture;
  String? _reviewMessage;
  var _takingPicture = false;
  var _editing = false;
  var _disposed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _session = ref.read(cameraCaptureGatewayProvider).createSession();
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    final state = await _session.initialize();
    if (!mounted || _disposed) return;
    setState(() => _state = state);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_disposed || _stage == _CameraStage.review) return;
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        unawaited(_session.pause());
        return;
      case AppLifecycleState.resumed:
        unawaited(_resumeCapture());
        return;
    }
  }

  Future<void> _resumeCapture() async {
    final state = await _session.resume();
    if (!mounted || _disposed || _stage != _CameraStage.capture) return;
    setState(() => _state = state);
  }

  Future<void> _capture() async {
    if (_state != CameraCaptureState.ready || _takingPicture) return;
    setState(() => _takingPicture = true);
    try {
      final candidate = await _session.capture();
      await _session.pause();
      if (!mounted || _disposed) {
        await _session.discard(candidate);
        return;
      }
      setState(() {
        _candidate = candidate;
        _stage = _CameraStage.review;
        _reviewMessage = null;
      });
    } catch (_) {
      if (!mounted || _disposed) return;
      setState(() => _state = CameraCaptureState.failed);
    } finally {
      if (mounted && !_disposed) setState(() => _takingPicture = false);
    }
  }

  Future<void> _retake() async {
    final candidate = _candidate;
    if (candidate != null) await _session.discard(candidate);
    if (!mounted || _disposed) return;
    setState(() {
      _candidate = null;
      _stage = _CameraStage.capture;
      _state = CameraCaptureState.permissionNotRequested;
      _reviewMessage = null;
    });
    await _resumeCapture();
  }

  Future<void> _rotateRight() async {
    final candidate = _candidate;
    if (candidate == null || _editing) return;
    setState(() {
      _editing = true;
      _reviewMessage = null;
    });
    try {
      final rotated = await _session.rotateRight(candidate);
      if (!mounted || _disposed || _stage != _CameraStage.review) return;
      setState(() => _candidate = rotated);
    } catch (_) {
      if (!mounted || _disposed) return;
      setState(() => _reviewMessage = context.l10n.cameraRotateFailed);
    } finally {
      if (mounted && !_disposed) setState(() => _editing = false);
    }
  }

  void _usePhoto() {
    final candidate = _candidate;
    if (candidate == null || _editing) return;
    final selection = DocumentImportSelection([
      DocumentImportCandidate(
        localUri: candidate.localUri,
        mediaType: ImportedMediaType.image,
        source: ImportSource.camera,
        originalFilename:
            'camera-${candidate.capturedAt.millisecondsSinceEpoch}.jpg',
        importedAt: candidate.capturedAt,
      ),
    ]);
    // Ownership transfers to the Analyze session draft.
    _candidate = null;
    Navigator.of(context).pop(selection);
  }

  Future<void> _back() async {
    if (_stage == _CameraStage.capture) {
      if (mounted) Navigator.of(context).maybePop();
      return;
    }
    await _retake();
  }

  Future<void> _toggleFlash() async {
    await _session.toggleFlash();
    if (mounted && !_disposed) setState(() {});
  }

  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    final candidate = _candidate;
    if (candidate != null && _stage == _CameraStage.review) {
      unawaited(_session.discard(candidate));
    }
    unawaited(_session.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _stage == _CameraStage.review
      ? _CameraReviewSurface(
          candidate: _candidate!,
          editing: _editing,
          message: _reviewMessage,
          onBack: _back,
          onRetake: _retake,
          onRotate: _rotateRight,
          onUse: _usePhoto,
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
              child: Directionality(
                textDirection: TextDirection.ltr,
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
                            _session.isFlashOn
                                ? Icons.flash_on
                                : Icons.flash_off,
                          ),
                        ),
                    ],
                  ),
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
    required this.candidate,
    required this.editing,
    required this.message,
    required this.onBack,
    required this.onRetake,
    required this.onRotate,
    required this.onUse,
  });

  final CameraCaptureCandidate candidate;
  final bool editing;
  final String? message;
  final Future<void> Function() onBack;
  final Future<void> Function() onRetake;
  final Future<void> Function() onRotate;
  final VoidCallback onUse;

  @override
  Widget build(BuildContext context) => Scaffold(
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
            Directionality(
              textDirection: TextDirection.ltr,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: IconButton(
                  key: const Key('camera-review-back'),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  onPressed: editing ? null : onBack,
                  icon: const Icon(Icons.arrow_back),
                ),
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
                    key: const Key('camera-review-preview'),
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
            const SizedBox(height: AppSpacing.md),
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
              ],
            ),
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
                  child: FilledButton(
                    key: const Key('camera-review-use'),
                    onPressed: editing ? null : onUse,
                    child: Text(context.l10n.cameraUsePhoto),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
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
