import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/design_system/app_widgets.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final current =
        ref.watch(languageProvider)?.languageCode ??
        Localizations.localeOf(context).languageCode;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.profile)),
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            AppSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.language,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: [
                      ChoiceChip(
                        label: Text(l10n.german),
                        selected: current == 'de',
                        onSelected: (_) => ref
                            .read(languageProvider.notifier)
                            .setLocale(const Locale('de')),
                      ),
                      ChoiceChip(
                        label: Text(l10n.arabic),
                        selected: current == 'ar',
                        onSelected: (_) => ref
                            .read(languageProvider.notifier)
                            .setLocale(const Locale('ar')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
