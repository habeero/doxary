import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as image;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// The presentation-safe states for a device camera session.
///
/// Permission is requested only by [initialize]. A captured image is a
/// temporary handoff to the upcoming review stage, never an imported Document.
enum CameraCaptureState {
  permissionNotRequested,
  ready,
  permissionDenied,
  permissionPermanentlyDenied,
  permissionRestricted,
  unavailable,
  failed,
}

class CameraCaptureCandidate {
  const CameraCaptureCandidate({
    required this.localUri,
    required this.capturedAt,
  });

  final Uri localUri;
  final DateTime capturedAt;
}

/// Platform camera boundary for the focused capture surface.
///
/// Keeping this boundary separate from [DocumentImportGateway] ensures camera
/// capture cannot create a local Document or analysis operation by itself.
abstract interface class CameraCaptureGateway {
  CameraCaptureSession createSession();
}

abstract interface class CameraCaptureSession {
  CameraCaptureState get state;
  bool get isFlashControlAvailable;
  bool get isFlashOn;

  Future<CameraCaptureState> initialize();
  Widget buildPreview();
  Future<void> toggleFlash();
  Future<CameraCaptureCandidate> capture();
  Future<CameraCaptureCandidate> rotateRight(CameraCaptureCandidate candidate);
  Future<void> discard(CameraCaptureCandidate candidate);
  Future<void> pause();
  Future<CameraCaptureState> resume();
  Future<void> dispose();
}

class DeviceCameraCaptureGateway implements CameraCaptureGateway {
  DeviceCameraCaptureGateway({DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;

  @override
  CameraCaptureSession createSession() => _DeviceCameraCaptureSession(_clock);
}

class _DeviceCameraCaptureSession implements CameraCaptureSession {
  _DeviceCameraCaptureSession(this._clock);

  final DateTime Function() _clock;
  CameraController? _controller;
  CameraDescription? _description;
  CameraCaptureState _state = CameraCaptureState.permissionNotRequested;
  var _flashAvailable = false;
  var _flashOn = false;

  @override
  CameraCaptureState get state => _state;

  @override
  bool get isFlashControlAvailable => _flashAvailable;

  @override
  bool get isFlashOn => _flashOn;

  @override
  Future<CameraCaptureState> initialize() async {
    await _disposeController();
    _state = CameraCaptureState.permissionNotRequested;
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        return _state = CameraCaptureState.unavailable;
      }
      _description = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        _description!,
        ResolutionPreset.high,
        enableAudio: false,
      );
      _controller = controller;
      await controller.initialize();
      _flashAvailable = true;
      _flashOn = false;
      return _state = CameraCaptureState.ready;
    } on CameraException catch (error) {
      await _disposeController();
      return _state = switch (error.code) {
        'CameraAccessDenied' ||
        'cameraPermission' => CameraCaptureState.permissionDenied,
        'CameraAccessDeniedWithoutPrompt' =>
          CameraCaptureState.permissionPermanentlyDenied,
        'CameraAccessRestricted' => CameraCaptureState.permissionRestricted,
        _ => CameraCaptureState.unavailable,
      };
    } catch (_) {
      await _disposeController();
      return _state = CameraCaptureState.failed;
    }
  }

  @override
  Widget buildPreview() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const SizedBox.expand();
    }
    return CameraPreview(controller);
  }

  @override
  Future<void> toggleFlash() async {
    final controller = _controller;
    if (controller == null || !_flashAvailable) return;
    try {
      _flashOn = !_flashOn;
      await controller.setFlashMode(_flashOn ? FlashMode.torch : FlashMode.off);
    } on CameraException {
      _flashAvailable = false;
      _flashOn = false;
    }
  }

  @override
  Future<CameraCaptureCandidate> capture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      throw StateError('Camera capture was requested before initialization.');
    }
    final image = await controller.takePicture();
    return CameraCaptureCandidate(
      localUri: Uri.file(image.path),
      capturedAt: _clock(),
    );
  }

  @override
  Future<CameraCaptureCandidate> rotateRight(
    CameraCaptureCandidate candidate,
  ) async {
    final source = File.fromUri(candidate.localUri);
    final bytes = await source.readAsBytes();
    final decoded = image.decodeImage(bytes);
    if (decoded == null) {
      throw StateError('The captured image could not be decoded.');
    }
    final directory = await getTemporaryDirectory();
    final filename =
        'doxary_capture_${DateTime.now().microsecondsSinceEpoch}.jpg';
    final destination = File(path.join(directory.path, filename));
    await destination.writeAsBytes(
      image.encodeJpg(image.copyRotate(decoded, angle: 90)),
      flush: true,
    );
    await discard(candidate);
    return CameraCaptureCandidate(
      localUri: destination.uri,
      capturedAt: candidate.capturedAt,
    );
  }

  @override
  Future<void> discard(CameraCaptureCandidate candidate) async {
    if (candidate.localUri.scheme != 'file') return;
    final file = File.fromUri(candidate.localUri);
    if (await file.exists()) await file.delete();
  }

  @override
  Future<void> pause() => _disposeController();

  @override
  Future<CameraCaptureState> resume() => initialize();

  @override
  Future<void> dispose() => _disposeController();

  Future<void> _disposeController() async {
    final controller = _controller;
    _controller = null;
    _flashAvailable = false;
    _flashOn = false;
    if (controller != null) await controller.dispose();
  }
}
