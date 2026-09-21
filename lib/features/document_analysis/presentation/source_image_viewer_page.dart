import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../documents/domain/source_document_opener.dart';

/// Read-only, path-free presentation of locally resolved image source pages.
class SourceImageViewerPage extends StatefulWidget {
  const SourceImageViewerPage({required this.pages, super.key});

  final List<SourceDocumentImagePage> pages;

  @override
  State<SourceImageViewerPage> createState() => _SourceImageViewerPageState();
}

class _SourceImageViewerPageState extends State<SourceImageViewerPage> {
  var _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.originalDocument),
        bottom: widget.pages.length > 1
            ? PreferredSize(
                preferredSize: const Size.fromHeight(28),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    l10n.originalDocumentPageCount(
                      _pageIndex + 1,
                      widget.pages.length,
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: PageView.builder(
        key: const Key('original-image-pages'),
        itemCount: widget.pages.length,
        onPageChanged: (index) => setState(() => _pageIndex = index),
        itemBuilder: (context, index) {
          final page = widget.pages[index];
          if (!page.isAvailable) {
            return Center(
              child: Text(
                l10n.originalDocumentPageUnavailable(index + 1),
                key: Key('original-image-page-unavailable-$index'),
              ),
            );
          }
          return InteractiveViewer(
            child: Center(
              child: Image.memory(
                page.bytes!,
                key: Key('original-image-page-$index'),
                fit: BoxFit.contain,
                matchTextDirection: false,
              ),
            ),
          );
        },
      ),
    );
  }
}
