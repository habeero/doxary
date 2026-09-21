import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = ref.watch(languageProvider);
    final currentLanguage = locale.languageCode == 'ar'
        ? l10n.arabic
        : l10n.german;
    return Material(
      color: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            const _SettingsHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                children: [
                  _SettingsSection(
                    title: l10n.account,
                    children: [
                      _SettingsSelectionRow(
                        label: l10n.profile,
                        icon: Icons.person_outline,
                        deferred: true,
                      ),
                      _SettingsSelectionRow(
                        label: l10n.planAccount,
                        icon: Icons.workspace_premium_outlined,
                        deferred: true,
                      ),
                    ],
                  ),
                  _SettingsSection(
                    title: l10n.language,
                    children: [
                      _SettingsSelectionRow(
                        rowKey: const Key('settings-app-language'),
                        icon: Icons.language_outlined,
                        label: l10n.applicationLanguage,
                        value: currentLanguage,
                        onTap: () => _showLanguageSelection(context),
                      ),
                    ],
                  ),
                  _SettingsSection(
                    title: l10n.notifications,
                    children: [
                      _SettingsSelectionRow(
                        label: l10n.analysisNotifications,
                        icon: Icons.analytics_outlined,
                        deferred: true,
                      ),
                      _SettingsSelectionRow(
                        label: l10n.taskNotifications,
                        icon: Icons.notifications_outlined,
                        deferred: true,
                      ),
                    ],
                  ),
                  _SettingsSection(
                    title: l10n.appearance,
                    children: [
                      _SettingsSelectionRow(
                        label: l10n.darkAppearance,
                        icon: Icons.dark_mode_outlined,
                        deferred: true,
                      ),
                    ],
                  ),
                  _SettingsSection(
                    title: l10n.privacyAndData,
                    children: [
                      _SettingsSelectionRow(
                        label: l10n.localDocuments,
                        icon: Icons.folder_outlined,
                        deferred: true,
                      ),
                      _SettingsSelectionRow(
                        label: l10n.dataManagement,
                        icon: Icons.storage_outlined,
                        deferred: true,
                      ),
                    ],
                  ),
                  _SettingsSection(
                    title: l10n.legal,
                    children: [
                      _SettingsSelectionRow(
                        label: l10n.privacyPolicy,
                        icon: Icons.privacy_tip_outlined,
                        deferred: true,
                      ),
                      _SettingsSelectionRow(
                        label: l10n.terms,
                        icon: Icons.description_outlined,
                        deferred: true,
                      ),
                    ],
                  ),
                  _SettingsSection(
                    title: l10n.about,
                    children: [
                      _SettingsSelectionRow(
                        label: l10n.rateApp,
                        icon: Icons.star_outline,
                        deferred: true,
                      ),
                      _SettingsSelectionRow(
                        label: l10n.shareApp,
                        icon: Icons.share_outlined,
                        deferred: true,
                      ),
                      _SettingsSelectionRow(
                        label: l10n.appVersion,
                        icon: Icons.info_outline,
                        deferred: true,
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

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Semantics(
      header: true,
      label: l10n.settings,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsetsDirectional.fromSTEB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffE2E8F0))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: Colors.white,
                    size: 17,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  l10n.productName,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.settings,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSelectionRow extends StatelessWidget {
  const _SettingsSelectionRow({
    this.rowKey,
    required this.icon,
    required this.label,
    this.value,
    this.onTap,
    this.deferred = false,
  });

  final Key? rowKey;
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;
  final bool deferred;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    enabled: !deferred,
    label: value == null ? label : '$label: $value',
    child: Material(
      color: Theme.of(context).colorScheme.surface
          .withValues(alpha: deferred ? .72 : 1),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        key: rowKey,
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: deferred
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              if (value != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    value!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                const Icon(Icons.chevron_right),
              ] else if (deferred)
                Text(
                  context.l10n.notAvailableYet,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...children.expand(
          (child) => [child, const SizedBox(height: AppSpacing.xs)],
        ),
      ],
    ),
  );
}

Future<void> _showLanguageSelection(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _LanguageSelectionSheet(),
    );

class _LanguageSelectionSheet extends ConsumerWidget {
  const _LanguageSelectionSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final current = ref.watch(languageProvider);
    return Material(
      key: const Key('settings-language-modal'),
      color: Theme.of(context).colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.productName,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  key: const Key('settings-language-close'),
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.applicationLanguage,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.md),
            _LanguageOption(
              optionKey: const Key('settings-language-de'),
              label: l10n.german,
              selected: current.languageCode == 'de',
              onTap: () => _selectLanguage(context, ref, const Locale('de')),
            ),
            const Divider(),
            _LanguageOption(
              optionKey: const Key('settings-language-ar'),
              label: l10n.arabic,
              selected: current.languageCode == 'ar',
              onTap: () => _selectLanguage(context, ref, const Locale('ar')),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _selectLanguage(
  BuildContext context,
  WidgetRef ref,
  Locale locale,
) async {
  final navigator = Navigator.of(context);
  await ref.read(languageProvider.notifier).setLocale(locale);
  if (!context.mounted) return;
  navigator.pop();
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.optionKey,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final Key optionKey;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    key: optionKey,
    contentPadding: EdgeInsets.zero,
    title: Text(label),
    trailing: selected
        ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
        : null,
    onTap: onTap,
  );
}
