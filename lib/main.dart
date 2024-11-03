import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_expenses/providers/auth_provider.dart';
import 'package:my_expenses/screens/authentication_screen.dart';
import 'package:my_expenses/screens/home_screen.dart';
import 'firebase_options.dart';
import 'package:my_expenses/themes/dark_theme.dart';
import 'package:my_expenses/themes/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider);
    return MaterialApp(
      darkTheme: darktheme,
      theme: lightTheme,
      themeMode: ThemeMode.system,
      home: user.when(
          data: (data) {
            if (data != null) {
              return const HomeScreen();
            } else {
              return LoginScreen();
            }
          },
          error: (error, stack) {
            return Center(child: Text('Error $error'));
          },
          loading: () => const CircularProgressIndicator()),
    );
  }
}
