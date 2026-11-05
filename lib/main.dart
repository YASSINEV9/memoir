import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:workmanager/workmanager.dart';

import 'src/archive/archive_controller.dart';
import 'src/archive/archive_database.dart';
import 'src/archive/archive_item.dart';
import 'src/archive/archive_repository.dart';
import 'src/cloud/google_drive_provider.dart';
import 'src/cloud/auto_backup.dart';
import 'src/screens/archive_screen.dart';
import 'src/screens/chat_screen.dart';
import 'src/screens/cloud_screen.dart';
import 'src/screens/settings_screen.dart';
import 'src/security/app_lock.dart';

final repositoryProvider = Provider<ArchiveRepository>(
  (ref) => ArchiveRepository(ArchiveDatabase.instance),
);
final googleDriveProvider = Provider<GoogleDriveProvider>((ref) {
  final provider = GoogleDriveProvider();
  ref.onDispose(provider.dispose);
  return provider;
});
final archiveControllerProvider =
    AsyncNotifierProvider<ArchiveController, List<ArchiveItem>>(
      ArchiveController.new,
    );
final themeMode = ValueNotifier(ThemeMode.system);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (defaultTargetPlatform == TargetPlatform.android) {
    await Workmanager().initialize(memoryVaultBackgroundDispatcher);
  }
  await AppLock.instance.load();
  runApp(const ProviderScope(child: MemoryVaultApp()));
  // Not awaited: a catch-up backup must not delay the first screen.
  unawaited(resumeAutomaticBackup().catchError((Object _) {}));
}

@pragma('vm:entry-point')
void memoryVaultBackgroundDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task != autoBackupTaskName) return true;
    DartPluginRegistrant.ensureInitialized();
    try {
      // false asks Android to retry later with backoff.
      return await runAutomaticBackup();
    } catch (_) {
      return false;
    }
  });
}

class MemoryVaultApp extends StatelessWidget {
  const MemoryVaultApp({super.key});

  static final _router = GoRouter(
    initialLocation: '/archive',
    routes: [
      GoRoute(path: '/archive', builder: (_, _) => const ArchiveScreen()),
      GoRoute(
        path: '/chat/:id',
        builder: (_, state) => ChatScreen(
          collectionId: state.pathParameters['id']!,
          name: state.extra as String? ?? 'Chat',
        ),
      ),
      GoRoute(path: '/cloud', builder: (_, _) => const CloudScreen()),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
    ],
  );

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<ThemeMode>(
    valueListenable: themeMode,
    builder: (context, mode, _) => MaterialApp.router(
      title: 'Memoir',
      debugShowCheckedModeBanner: false,
      themeMode: mode,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      routerConfig: _router,
      builder: (context, child) => AppLockGate(child: child!),
      supportedLocales: const [Locale('en'), Locale('ar')],
    ),
  );

  ThemeData _theme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xff16b8a6),
      brightness: brightness,
      surface: dark ? const Color(0xff111b2a) : Colors.white,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: dark
          ? const Color(0xff0b1421)
          : const Color(0xfff3f6fa),
      appBarTheme: AppBarTheme(
        backgroundColor: dark
            ? const Color(0xff0b1421)
            : const Color(0xfff3f6fa),
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}

class VaultNavigation extends StatelessWidget {
  const VaultNavigation({required this.location, super.key});
  final String location;

  @override
  Widget build(BuildContext context) {
    final index = location == '/cloud'
        ? 1
        : location == '/settings'
        ? 2
        : 0;
    return NavigationBar(
      selectedIndex: index,
      onDestinationSelected: (i) =>
          context.go(['/archive', '/cloud', '/settings'][i]),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline_rounded),
          label: 'Memories',
        ),
        NavigationDestination(
          icon: Icon(Icons.add_to_drive_outlined),
          label: 'Google Drive',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
    );
  }
}
