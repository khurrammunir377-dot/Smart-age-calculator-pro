import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_age_calculator_pro/core/services/birthday_notification_service.dart';
import 'package:smart_age_calculator_pro/core/theme/app_theme.dart';
import 'package:smart_age_calculator_pro/presentation/providers/birthday_provider.dart';
import 'package:smart_age_calculator_pro/presentation/providers/theme_provider.dart';
import 'package:smart_age_calculator_pro/presentation/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationService = BirthdayNotificationService();
  await notificationService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        birthdayNotificationServiceProvider.overrideWithValue(notificationService),
      ],
      child: const SmartAgeCalculatorApp(),
    ),
  );
}

class SmartAgeCalculatorApp extends ConsumerWidget {
  const SmartAgeCalculatorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Smart Age Calculator Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const HomeScreen(),
    );
  }
}
