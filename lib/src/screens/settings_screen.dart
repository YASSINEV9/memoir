import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../security/app_lock.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _openSocialLink(BuildContext context, String link) async {
    final opened = await launchUrl(
      Uri.parse(link),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open this link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Settings')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: const Text('Appearance'),
            subtitle: const Text('Choose system, light, or dark theme'),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode.value,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System'),
                ),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
              onChanged: (value) {
                if (value != null) themeMode.value = value;
              },
            ),
          ),
        ),
        Card(
          child: ValueListenableBuilder<bool>(
            valueListenable: AppLock.instance.enabled,
            builder: (context, enabled, _) => SwitchListTile(
              secondary: const Icon(Icons.lock_outline_rounded),
              title: const Text('App lock'),
              subtitle: const Text(
                "Unlock Memoir with your phone's PIN, pattern or fingerprint",
              ),
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
            title: const Text('Google Drive backup'),
            subtitle: const Text(
              'Connect your account to organize and browse your copies',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/cloud'),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.storage_outlined),
            title: Text('On-device archive'),
            subtitle: Text(
              'Your memories remain available offline on this device.',
            ),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text('Privacy'),
            subtitle: Text(
              'Imports happen only when you choose content to save. Memoir does not read messaging app databases.',
            ),
          ),
        ),
        Card(
          child: Column(
            children: [
              const ListTile(
                leading: Icon(Icons.person_outline_rounded),
                title: Text('Developer'),
                subtitle: Text('Yassine Mahmoud'),
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: const Icon(
                  Icons.facebook_rounded,
                  color: Color(0xff1877f2),
                ),
                title: const Text('Facebook'),
                subtitle: const Text('Open developer profile'),
                trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                onTap: () => _openSocialLink(
                  context,
                  'https://www.facebook.com/yassine.mahmoud.562',
                ),
              ),
              ListTile(
                leading: const Icon(Icons.telegram, color: Color(0xff229ed9)),
                title: const Text('Telegram'),
                subtitle: const Text('@SatoruJogo'),
                trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                onTap: () =>
                    _openSocialLink(context, 'https://t.me/SatoruJogo'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            'Memoir · 1.0.0',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      ],
    ),
    bottomNavigationBar: const VaultNavigation(location: '/settings'),
  );
}
