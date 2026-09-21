import 'dart:io';

import 'package:drift/native.dart';
import 'package:doxary/core/database/app_database.dart' hide DocumentFile;
import 'package:doxary/features/document_analysis/data/local_analysis_repository.dart';
import 'package:doxary/features/documents/data/repositories/local_document_repository.dart';
import 'package:doxary/features/documents/data/source_document_opener.dart';
import 'package:doxary/features/documents/domain/entities/domain_entities.dart';
import 'package:doxary/features/documents/domain/source_document_opener.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'PDF-backed DocumentFile resolves through the platform opener',
    () async {
      final directory = await Directory.systemTemp.createTemp('doxary-source-');
      addTearDown(() => directory.delete(recursive: true));
      final source = File(
        '${directory.path}${Platform.pathSeparator}source.pdf',
      );
      await source.writeAsBytes([1, 2, 3]);
      final platform = _FakePlatformSourceFileOpener();
      final opener = LocalSourceDocumentOpener(platformFileOpener: platform);
      final file = _file(source, mediaType: 'application/pdf');

      final outcome = await opener.open([file]);

      expect(outcome, isA<SourceDocumentOpened>());
      expect(platform.openedPaths, [source.path]);
      expect(file.localUri, source.uri);
    },
  );

  test('single image resolves into one read-only source page', () async {
    final directory = await Directory.systemTemp.createTemp('doxary-source-');
    addTearDown(() => directory.delete(recursive: true));
    final source = File('${directory.path}${Platform.pathSeparator}page.jpg');
    await source.writeAsBytes([1, 2, 3]);
    final opener = LocalSourceDocumentOpener();

    final outcome = await opener.open([_file(source, mediaType: 'image/jpeg')]);

    final opened = outcome as SourceDocumentImagesOpened;
    expect(opened.pages, hasLength(1));
    expect(opened.pages.single.pageOrder, 0);
    expect(opened.pages.single.bytes, [1, 2, 3]);
  });

  test('multiple images preserve persisted page order', () async {
    final directory = await Directory.systemTemp.createTemp('doxary-source-');
    addTearDown(() => directory.delete(recursive: true));
    final first = File('${directory.path}${Platform.pathSeparator}first.jpg');
    final second = File('${directory.path}${Platform.pathSeparator}second.jpg');
    await first.writeAsBytes([1]);
    await second.writeAsBytes([2]);
    final opener = LocalSourceDocumentOpener();

    final outcome = await opener.open([
      _file(second, mediaType: 'image/jpeg', pageOrder: 1),
      _file(first, mediaType: 'image/jpeg', pageOrder: 0),
    ]);

    final opened = outcome as SourceDocumentImagesOpened;
    expect(opened.pages.map((page) => page.pageOrder), [0, 1]);
    expect(opened.pages.map((page) => page.bytes?.single), [1, 2]);
  });

  test('a missing source is unavailable without changing persisted metadata', () async {
    final missing = File(
      '${Directory.systemTemp.path}${Platform.pathSeparator}missing-source.pdf',
    );
    final file = _file(missing, mediaType: 'application/pdf');
    final opener = LocalSourceDocumentOpener();

    final outcome = await opener.open([file]);

    expect(outcome, isA<SourceDocumentUnavailable>());
    expect(file.localUri, missing.uri);
    expect(file.clientDocumentId, 'document');
    expect(file.pageOrder, 0);
  });

  test('a platform PDF failure maps to a typed safe failure', () async {
    final directory = await Directory.systemTemp.createTemp('doxary-source-');
    addTearDown(() => directory.delete(recursive: true));
    final source = File('${directory.path}${Platform.pathSeparator}source.pdf');
    await source.writeAsBytes([1]);
    final opener = LocalSourceDocumentOpener(
      platformFileOpener: _FakePlatformSourceFileOpener(
        result: PlatformSourceFileOpenResult.failed,
      ),
    );

    final outcome = await opener.open([
      _file(source, mediaType: 'application/pdf'),
    ]);

    expect(outcome, isA<SourceDocumentOpenFailed>());
  });

  test('a missing page stays in its ordered multi-image position', () async {
    final directory = await Directory.systemTemp.createTemp('doxary-source-');
    addTearDown(() => directory.delete(recursive: true));
    final available = File(
      '${directory.path}${Platform.pathSeparator}available.jpg',
    );
    await available.writeAsBytes([1]);
    final missing = File(
      '${directory.path}${Platform.pathSeparator}missing.jpg',
    );
    final opener = LocalSourceDocumentOpener();

    final outcome = await opener.open([
      _file(available, mediaType: 'image/jpeg', pageOrder: 0),
      _file(missing, mediaType: 'image/jpeg', pageOrder: 1),
    ]);

    final opened = outcome as SourceDocumentImagesOpened;
    expect(opened.pages.map((page) => page.pageOrder), [0, 1]);
    expect(opened.pages[0].isAvailable, isTrue);
    expect(opened.pages[1].isAvailable, isFalse);
  });

  test(
    'analysis deletion and reanalysis retain original source access',
    () async {
      final directory = await Directory.systemTemp.createTemp('doxary-source-');
      addTearDown(() => directory.delete(recursive: true));
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final source = File(
        '${directory.path}${Platform.pathSeparator}source.pdf',
      );
      await source.writeAsBytes([1]);
      final document = LocalDocument(
        clientDocumentId: 'document',
        classificationState: ClassificationState.unclassified,
        status: DocumentStatus.analyzed,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );
      final sourceFile = _file(source, mediaType: 'application/pdf');
      final documents = LocalDocumentRepository(database);
      final analyses = LocalAnalysisRepository(database);
      await documents.saveImportedDocument(document, sourceFile);
      await analyses.saveCompleted(_analysis('analysis-one'));
      await analyses.deleteAnalysis('analysis-one');
      await analyses.saveCompleted(_analysis('analysis-two'));

      final persistedFiles = await documents.getFiles('document');
      final opener = LocalSourceDocumentOpener(
        platformFileOpener: _FakePlatformSourceFileOpener(),
      );
      final outcome = await opener.open(persistedFiles);

      expect(persistedFiles, hasLength(1));
      expect(persistedFiles.single.localUri, source.uri);
      expect(outcome, isA<SourceDocumentOpened>());
    },
  );
}

DocumentFile _file(
  File source, {
  required String mediaType,
  int pageOrder = 0,
}) => DocumentFile(
  id: 'file-$pageOrder',
  clientDocumentId: 'document',
  localUri: source.uri,
  mediaType: mediaType,
  importedAt: DateTime(2026),
  pageOrder: pageOrder,
);

DocumentAnalysis _analysis(String id) => DocumentAnalysis(
  id: id,
  clientDocumentId: 'document',
  schemaVersion: 'analysis_result.v1',
  targetLanguage: 'de',
  createdAt: DateTime(2026),
);

class _FakePlatformSourceFileOpener implements PlatformSourceFileOpener {
  _FakePlatformSourceFileOpener({
    this.result = PlatformSourceFileOpenResult.opened,
  });

  final PlatformSourceFileOpenResult result;
  final openedPaths = <String>[];

  @override
  Future<PlatformSourceFileOpenResult> openPdf(
    String path, {
    required String mediaType,
  }) async {
    openedPaths.add(path);
    return result;
  }
}
