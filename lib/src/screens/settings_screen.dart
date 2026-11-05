import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../l10n.dart';
import '../security/app_lock.dart';
import '../update/update_prompt.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _openSocialLink(BuildContext context, String link) async {
    final opened = await launchUrl(
      Uri.parse(link),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.linkFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.brightness_6_outlined),
              title: Text(l10n.appearance),
              subtitle: Text(l10n.appearanceSubtitle),
              trailing: DropdownButton<ThemeMode>(
                value: themeMode.value,
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text(l10n.themeSystem),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text(l10n.themeLight),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text(l10n.themeDark),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) themeMode.value = value;
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.translate_rounded),
              title: Text(l10n.language),
              trailing: DropdownButton<String?>(
                value: appLocale.value?.languageCode,
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(l10n.languageSystem),
                  ),
                  for (final MapEntry(:key, :value) in appLanguages.entries)
                    DropdownMenuItem(value: key, child: Text(value)),
                ],
                onChanged: setAppLocale,
              ),
            ),
          ),
          Card(
            child: ValueListenableBuilder<bool>(
              valueListenable: AppLock.instance.enabled,
              builder: (context, enabled, _) => SwitchListTile(
                secondary: const Icon(Icons.lock_outline_rounded),
                title: Text(l10n.appLock),
                subtitle: Text(l10n.appLockSubtitle),
                value: enabled,
                onChanged: (value) async {
                  final error = await AppLock.instance.setEnabled(value);
                  if (error != null && context.mounted) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(error)));
                  }
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.add_to_drive_outlined),
              title: Text(l10n.driveBackup),
              subtitle: Text(l10n.driveBackupSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/cloud'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_outline_rounded),
              title: Text(l10n.recentlyDeleted),
              subtitle: Text(l10n.recentlyDeletedSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/trash'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.storage_outlined),
              title: Text(l10n.onDeviceArchive),
              subtitle: Text(l10n.onDeviceArchiveSubtitle),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: Text(l10n.privacy),
              subtitle: Text(l10n.privacySubtitle),
            ),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline_rounded),
                  title: Text(l10n.developer),
                  subtitle: const Text('Yassine Mahmoud'),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(
                    Icons.facebook_rounded,
                    color: Color(0xff1877f2),
                  ),
                  title: const Text('Facebook'),
                  subtitle: Text(l10n.openProfile),
                  trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                  onTap: () => _openSocialLink(
                    context,
                    'https://www.facebook.com/yassine.mahmoud.562',
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.telegram, color: Color(0xff229ed9)),
                  title: const Text('Telegram'),
                  subtitle: const Text('‎@SatoruJogo'),
                  trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                  onTap: () =>
                      _openSocialLink(context, 'https://t.me/SatoruJogo'),
                ),
              ],
            ),
          ),
          Card(
            child: FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) => ListTile(
                leading: const Icon(Icons.system_update_rounded),
                title: Text(l10n.checkForUpdates),
                subtitle: Text(
                  l10n.currentVersion(snapshot.data?.version ?? '…'),
                ),
                onTap: () => checkForUpdateNow(context),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const VaultNavigation(location: '/settings'),
    );
  }
}
