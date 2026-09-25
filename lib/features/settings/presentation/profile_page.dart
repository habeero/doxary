import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/notifications/reminder_scheduler.dart';
import '../../document_analysis/domain/analysis_output_language.dart';
import '../application/about_services.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = ref.watch(languageProvider);
    final currentLanguage = locale.languageCode == 'ar'
        ? l10n.arabic
        : l10n.german;
    final explanationLanguage = ref.watch(analysisLanguageProvider);
    final currentExplanationLanguage = _explanationLanguageLabel(
      l10n,
      explanationLanguage,
    );
    final themeMode = ref.watch(themeModeProvider);
    final currentAppearance = _appearanceThemeLabel(l10n, themeMode);
    final appVersion = ref.watch(appVersionProvider);
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
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
                      _SettingsSelectionRow(
                        rowKey: const Key('settings-explanation-language'),
                        icon: Icons.translate_outlined,
                        label: l10n.analysisLanguageLabel,
                        value: currentExplanationLanguage,
                        onTap: () => _showExplanationLanguageSelection(context),
                      ),
                    ],
                  ),
                  _SettingsSection(
                    title: l10n.notifications,
                    children: [
                      _SettingsSelectionRow(
                        rowKey: const Key('settings-analysis-notifications'),
                        label: l10n.analysisNotifications,
                        icon: Icons.analytics_outlined,
                        deferred: true,
                      ),
                      const _TaskRemindersSettingRow(),
                    ],
                  ),
                  _SettingsSection(
                    title: l10n.appearance,
                    children: [
                      _SettingsSelectionRow(
                        rowKey: const Key('settings-appearance'),
                        label: l10n.appearance,
                        icon: Icons.dark_mode_outlined,
                        value: currentAppearance,
                        onTap: () => _showAppearanceSelection(context),
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
                        rowKey: const Key('settings-rate-app'),
                        label: l10n.rateApp,
                        icon: Icons.star_outline,
                        deferred: true,
                        value: l10n.rateAppUnavailable,
                        showChevron: false,
                      ),
                      _SettingsSelectionRow(
                        rowKey: const Key('settings-share-app'),
                        label: l10n.shareApp,
                        icon: Icons.share_outlined,
                        onTap: () => _shareApp(context, ref, l10n),
                      ),
                      _SettingsSelectionRow(
                        rowKey: const Key('settings-app-version'),
                        label: l10n.appVersion,
                        icon: Icons.info_outline,
                        value: appVersion.when(
                          data: (value) => value,
                          loading: () => l10n.versionLoading,
                          error: (_, _) => l10n.versionUnavailable,
                        ),
                        isButton: false,
                        showChevron: false,
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
    final theme = Theme.of(context);
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
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color:
                  theme.dividerTheme.color ?? theme.colorScheme.outlineVariant,
            ),
          ),
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
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Icon(
                    Icons.description_outlined,
                    color: theme.colorScheme.onPrimary,
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

class _TaskRemindersSettingRow extends ConsumerWidget {
  const _TaskRemindersSettingRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final preference = ref.watch(taskRemindersEnabledProvider);
    final permission = ref.watch(taskReminderPermissionStatusProvider);
    final enabled = preference.asData?.value ?? true;
    final permissionLabel = switch (permission.asData?.value) {
      ReminderPermissionStatus.allowed => l10n.taskReminderPermissionAllowed,
      ReminderPermissionStatus.notAllowed =>
        l10n.taskReminderPermissionNotAllowed,
      _ => null,
    };

    return SwitchListTile(
      key: const Key('settings-task-reminders'),
      contentPadding: EdgeInsets.zero,
      secondary: const Icon(Icons.notifications_outlined),
      title: Text(
        l10n.taskNotifications,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: permissionLabel == null
          ? null
          : Text(permissionLabel, maxLines: 1, overflow: TextOverflow.ellipsis),
      value: enabled,
      onChanged: preference.asData == null
          ? null
          : (value) => _setEnabled(context, ref, value),
    );
  }

  Future<void> _setEnabled(
    BuildContext context,
    WidgetRef ref,
    bool enabled,
  ) async {
    try {
      final reconciliationHadNoPlatformFailures = await ref
          .read(taskRemindersEnabledProvider.notifier)
          .setEnabled(enabled);
      if (!context.mounted || reconciliationHadNoPlatformFailures) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.taskReminderUpdateIncomplete)),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.taskReminderPreferenceSaveFailed)),
      );
    }
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
    this.isButton = true,
    this.showChevron = true,
  });

  final Key? rowKey;
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;
  final bool deferred;
  final bool isButton;
  final bool showChevron;

  @override
  Widget build(BuildContext context) => Semantics(
    button: isButton,
    enabled: isButton ? !deferred : null,
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
                if (showChevron) const Icon(Icons.chevron_right),
              ] else if (deferred) ...[
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    context.l10n.notAvailableYet,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> _shareApp(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
) async {
  final screenSize = MediaQuery.sizeOf(context);
  final origin = Rect.fromCenter(
    center: Offset(screenSize.width / 2, screenSize.height / 2),
    width: 1,
    height: 1,
  );
  try {
    await ref
        .read(aboutShareServiceProvider)
        .share(
          text: '${l10n.productName}\n${l10n.shareAppMessage}',
          title: l10n.shareApp,
          sharePositionOrigin: origin,
        );
  } catch (_) {
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger != null && Scaffold.maybeOf(context) != null) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.shareUnavailable)));
    }
  }
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

Future<void> _showAppearanceSelection(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AppearanceSelectionSheet(),
    );

Future<void> _showExplanationLanguageSelection(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ExplanationLanguageSelectionSheet(),
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
            _SettingsOption(
              optionKey: const Key('settings-language-de'),
              label: l10n.german,
              selected: current.languageCode == 'de',
              onTap: () => _selectLanguage(context, ref, const Locale('de')),
            ),
            const Divider(),
            _SettingsOption(
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

class _AppearanceSelectionSheet extends ConsumerWidget {
  const _AppearanceSelectionSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final current = ref.watch(themeModeProvider);
    return Material(
      key: const Key('settings-appearance-modal'),
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
                  key: const Key('settings-appearance-close'),
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.appearance,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.md),
            _SettingsOption(
              optionKey: const Key('settings-theme-system'),
              label: l10n.appearanceSystem,
              selected: current == ThemeMode.system,
              onTap: () => _selectThemeMode(context, ref, ThemeMode.system),
            ),
            const Divider(),
            _SettingsOption(
              optionKey: const Key('settings-theme-light'),
              label: l10n.appearanceLight,
              selected: current == ThemeMode.light,
              onTap: () => _selectThemeMode(context, ref, ThemeMode.light),
            ),
            const Divider(),
            _SettingsOption(
              optionKey: const Key('settings-theme-dark'),
              label: l10n.appearanceDark,
              selected: current == ThemeMode.dark,
              onTap: () => _selectThemeMode(context, ref, ThemeMode.dark),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExplanationLanguageSelectionSheet extends ConsumerWidget {
  const _ExplanationLanguageSelectionSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final current = ref.watch(analysisLanguageProvider);
    return Material(
      key: const Key('settings-explanation-language-modal'),
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
                  key: const Key('settings-explanation-language-close'),
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.analysisLanguageLabel,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.md),
            _SettingsOption(
              optionKey: const Key('settings-explanation-language-ar'),
              label: l10n.analysisLanguageArabic,
              selected: current == AnalysisOutputLanguage.arabic,
              onTap: () => _selectExplanationLanguage(
                context,
                ref,
                AnalysisOutputLanguage.arabic,
              ),
            ),
            const Divider(),
            _SettingsOption(
              optionKey: const Key('settings-explanation-language-de'),
              label: l10n.analysisLanguageSimpleGerman,
              selected: current == AnalysisOutputLanguage.simpleGerman,
              onTap: () => _selectExplanationLanguage(
                context,
                ref,
                AnalysisOutputLanguage.simpleGerman,
              ),
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

Future<void> _selectThemeMode(
  BuildContext context,
  WidgetRef ref,
  ThemeMode mode,
) async {
  final navigator = Navigator.of(context);
  await ref.read(themeModeProvider.notifier).setThemeMode(mode);
  if (!context.mounted) return;
  navigator.pop();
}

Future<void> _selectExplanationLanguage(
  BuildContext context,
  WidgetRef ref,
  AnalysisOutputLanguage language,
) async {
  final navigator = Navigator.of(context);
  await ref.read(analysisLanguageProvider.notifier).setLanguage(language);
  if (!context.mounted) return;
  navigator.pop();
}

String _explanationLanguageLabel(
  AppLocalizations l10n,
  AnalysisOutputLanguage language,
) => switch (language) {
  AnalysisOutputLanguage.arabic => l10n.analysisLanguageArabic,
  AnalysisOutputLanguage.simpleGerman => l10n.analysisLanguageSimpleGerman,
};

String _appearanceThemeLabel(AppLocalizations l10n, ThemeMode mode) =>
    switch (mode) {
      ThemeMode.system => l10n.appearanceSystem,
      ThemeMode.light => l10n.appearanceLight,
      ThemeMode.dark => l10n.appearanceDark,
    };

class _SettingsOption extends StatelessWidget {
  const _SettingsOption({
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
  Widget build(BuildContext context) => Semantics(
    container: true,
    button: true,
    selected: selected,
    label: label,
    child: ListTile(
      key: optionKey,
      contentPadding: EdgeInsets.zero,
      selected: selected,
      title: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: selected
          ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: onTap,
    ),
  );
}
