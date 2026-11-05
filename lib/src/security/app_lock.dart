import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Locks Memoir behind the phone's own screen lock: PIN, pattern, password,
/// fingerprint or face, whatever the device uses.
class AppLock {
  AppLock._();
  static final instance = AppLock._();

  static const _key = 'app_lock_enabled';

  /// Leaving the app for less than this (file picker, Google sign-in, the
  /// lock prompt itself) does not lock it again.
  static const grace = Duration(seconds: 30);

  final _auth = LocalAuthentication();
  final enabled = ValueNotifier(false);
  final locked = ValueNotifier(false);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    enabled.value = prefs.getBool(_key) ?? false;
    locked.value = enabled.value;
  }

  /// Shows the system prompt. Returns null on success, otherwise a message.
  Future<String?> authenticate(String reason) async {
    try {
      if (!await _auth.isDeviceSupported()) {
        return 'Set a screen lock (PIN, pattern or fingerprint) on this phone first.';
      }
      final ok = await _auth.authenticate(
        localizedReason: reason,
        persistAcrossBackgrounding: true,
      );
      return ok ? null : 'Not unlocked.';
    } on LocalAuthException catch (error) {
      return switch (error.code) {
        LocalAuthExceptionCode.noCredentialsSet => 'Set a screen lock (PIN, pattern or fingerprint) on this phone first.',
        LocalAuthExceptionCode.userCanceled ||
        LocalAuthExceptionCode.systemCanceled => 'Not unlocked.',
        LocalAuthExceptionCode.temporaryLockout ||
        LocalAuthExceptionCode.biometricLockout =>
          'Too many attempts. Try again later or use your PIN.',
        _ => 'Could not unlock: ${error.code.name}',
      };
    }
  }

  Future<String?> setEnabled(bool value) async {
    // Turning the lock on or off both require proving it is your phone.
    final error = await authenticate(
      value ? 'Confirm to lock Memoir' : 'Confirm to remove the lock',
    );
    if (error != null) return error;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
    enabled.value = value;
    return null;
  }

  Future<void> unlock() async {
    if (await authenticate('Unlock Memoir') == null) locked.value = false;
  }
}

/// Covers the app with a lock screen while [AppLock.locked] is true and locks
/// again after the app has been in the background longer than the grace.
class AppLockGate extends StatefulWidget {
  const AppLockGate({required this.child, super.key});
  final Widget child;

  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends State<AppLockGate> with WidgetsBindingObserver {
  final _lock = AppLock.instance;
  DateTime? _leftAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (_lock.locked.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _lock.unlock());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_lock.enabled.value) return;
    if (state == AppLifecycleState.hidden) {
      _leftAt ??= DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      final leftAt = _leftAt;
      _leftAt = null;
      if (!_lock.locked.value &&
          leftAt != null &&
          DateTime.now().difference(leftAt) > AppLock.grace) {
        _lock.locked.value = true;
        _lock.unlock();
      }
    }
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
    valueListenable: _lock.locked,
    builder: (context, locked, child) => Stack(
      children: [
        child!,
        if (locked) const Positioned.fill(child: _LockScreen()),
      ],
    ),
    child: widget.child,
  );
}

class _LockScreen extends StatelessWidget {
  const _LockScreen();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: scheme.primaryContainer,
                child: Icon(
                  Icons.lock_rounded,
                  size: 38,
                  color: scheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Memoir is locked',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text('Use your phone\'s PIN, pattern or fingerprint'),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: AppLock.instance.unlock,
                icon: const Icon(Icons.fingerprint),
                label: const Text('Unlock'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
