import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/theme.dart';
import 'package:client/features/home/view/home_page.dart';
// import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
// import 'package:client/features/auth/view/pages/upload_song_page.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  // Wait for shared preferences initialization
  await container.read(authViewModelProvider.notifier).initSharedPreferences();
  await container.read(authViewModelProvider.notifier).getData();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    return MaterialApp(
        title: 'Spotify',
        theme: AppTheme.darkThemeMode,
        home: currentUser == null ? const SignupPage() : const HomePage());
  }
}
