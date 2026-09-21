import 'dart:typed_data';

import 'package:doxary/app/localization/app_localizations.dart';
import 'package:doxary/app/providers.dart';
import 'package:doxary/features/document_analysis/domain/analysis_repository.dart';
import 'package:doxary/features/document_analysis/presentation/document_detail_page.dart';
import 'package:doxary/features/document_analysis/presentation/source_image_viewer_page.dart';
import 'package:doxary/features/documents/domain/entities/domain_entities.dart';
import 'package:doxary/features/documents/domain/source_document_opener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Document route connects Open original to the typed opener', (
    tester,
  ) async {
    final opener = _RecordingOpener(const SourceDocumentUnavailable());
    final file = _file();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          documentProvider('document')
              .overrideWithValue(AsyncValue.data(_document())),
          documentFilesProvider('document')
              .overrideWithValue(AsyncValue.data([file])),
          latestAnalysisProvider('document')
              .overrideWithValue(AsyncValue.data(_analysis())),
          analysisHistoryProvider('document')
              .overrideWithValue(const AsyncValue.data(<AnalysisAttempt>[])),
          organizationsProvider.overrideWithValue(const AsyncValue.data([])),
          casesProvider.overrideWithValue(const AsyncValue.data([])),
          sourceDocumentOpenerProvider.overrideWithValue(opener),
        ],
        child: _app(const DocumentDetailPage(clientDocumentId: 'document')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('open-original-document')), findsOneWidget);
    expect(find.text(file.localUri.toString()), findsNothing);
    expect(find.text(file.id), findsNothing);
    await tester.ensureVisible(find.byKey(const Key('open-original-document')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('open-original-document')));
    await tester.pump();

    expect(opener.openedFiles, [file]);
    expect(
      find.text('Das Originaldokument ist nicht verfügbar.'),
      findsOneWidget,
    );
  });

  testWidgets('Arabic source page viewer keeps image content unmirrored', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        SourceImageViewerPage(
          pages: [
            SourceDocumentImagePage(
              pageOrder: 0,
              bytes: Uint8List.fromList(_onePixelPng),
            ),
          ],
        ),
        locale: const Locale('ar'),
      ),
    );
    await tester.pumpAndSettle();

    final image = tester.widget<Image>(
      find.byKey(const Key('original-image-page-0')),
    );
    expect(image.matchTextDirection, isFalse);
    expect(
      Directionality.of(tester.element(find.byType(SourceImageViewerPage))),
      TextDirection.rtl,
    );
    expect(find.text('المستند الأصلي'), findsOneWidget);
  });
}

LocalDocument _document() => LocalDocument(
  clientDocumentId: 'document',
  classificationState: ClassificationState.unclassified,
  status: DocumentStatus.analyzed,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

DocumentFile _file() => DocumentFile(
  id: 'internal-file-id',
  clientDocumentId: 'document',
  localUri: Uri.file('/private/document.pdf'),
  mediaType: 'application/pdf',
  importedAt: DateTime(2026),
);

DocumentAnalysis _analysis() => DocumentAnalysis(
  id: 'analysis',
  clientDocumentId: 'document',
  schemaVersion: 'analysis_result.v1',
  targetLanguage: 'de',
  createdAt: DateTime(2026),
  summary: 'Summary',
  actionRequired: ActionRequirement.no,
);

Widget _app(Widget home, {Locale locale = const Locale('de')}) => MaterialApp(
  locale: locale,
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  home: home,
);

class _RecordingOpener implements SourceDocumentOpener {
  _RecordingOpener(this.outcome);

  final SourceDocumentOpenOutcome outcome;
  List<DocumentFile>? openedFiles;

  @override
  Future<SourceDocumentOpenOutcome> open(List<DocumentFile> files) async {
    openedFiles = files;
    return outcome;
  }
}

const _onePixelPng = <int>[
  137,
  80,
  78,
  71,
  13,
  10,
  26,
  10,
  0,
  0,
  0,
  13,
  73,
  72,
  68,
  82,
  0,
  0,
  0,
  1,
  0,
  0,
  0,
  1,
  8,
  6,
  0,
  0,
  0,
  31,
  21,
  196,
  137,
  0,
  0,
  0,
  13,
  73,
  68,
  65,
  84,
  8,
  215,
  99,
  248,
  207,
  192,
  240,
  31,
  0,
  5,
  0,
  1,
  255,
  137,
  153,
  61,
  29,
  0,
  0,
  0,
  0,
  73,
  69,
  78,
  68,
  174,
  66,
  96,
  130,
];
