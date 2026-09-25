import 'dart:ui' show Rect;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

class AppMetadata {
  const AppMetadata({required this.version, required this.buildNumber});

  final String version;
  final String buildNumber;

  String get displayVersion {
    final normalizedVersion = version.trim();
    if (normalizedVersion.isEmpty) {
      throw StateError('Application version metadata is unavailable.');
    }
    final normalizedBuild = buildNumber.trim();
    return normalizedBuild.isEmpty
        ? normalizedVersion
        : '$normalizedVersion ($normalizedBuild)';
  }
}

abstract interface class AppMetadataReader {
  Future<AppMetadata> read();
}

class PackageInfoAppMetadataReader implements AppMetadataReader {
  const PackageInfoAppMetadataReader();

  @override
  Future<AppMetadata> read() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return AppMetadata(
      version: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
    );
  }
}

abstract interface class AboutShareService {
  Future<void> share({
    required String text,
    required String title,
    required Rect sharePositionOrigin,
  });
}

class NativeAboutShareService implements AboutShareService {
  const NativeAboutShareService();

  @override
  Future<void> share({
    required String text,
    required String title,
    required Rect sharePositionOrigin,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        text: text,
        title: title,
        subject: title,
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }
}

final appMetadataReaderProvider = Provider<AppMetadataReader>(
  (ref) => const PackageInfoAppMetadataReader(),
);

final appVersionProvider = FutureProvider.autoDispose<String>((ref) async {
  final metadata = await ref.watch(appMetadataReaderProvider).read();
  return metadata.displayVersion;
});

final aboutShareServiceProvider = Provider<AboutShareService>(
  (ref) => const NativeAboutShareService(),
);
