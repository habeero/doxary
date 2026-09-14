import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/design_system/app_widgets.dart';
import '../domain/document_import.dart';

class ImportPage extends ConsumerWidget {
  const ImportPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    Future<void> select(ImportSource source) async {
      final result = await ref.read(importGatewayProvider).pick(source);
      if (!context.mounted) return;
      result.when(
        success: (_) {},
        failure: (_) =>
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(l10n.importUnavailable))),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.importDocument)),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.foundationMessage,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppSectionCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.photo_camera_outlined),
                      title: Text(l10n.camera),
                      onTap: () => select(ImportSource.camera),
                    ),
                    ListTile(
                      leading: const Icon(Icons.image_outlined),
                      title: Text(l10n.image),
                      onTap: () => select(ImportSource.imageLibrary),
                    ),
                    ListTile(
                      leading: const Icon(Icons.picture_as_pdf_outlined),
                      title: Text(l10n.pdf),
                      onTap: () => select(ImportSource.pdfFile),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
