import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/screens/authentication/login_screen.dart';
import 'package:vi_dien_tu/screens/home_screen.dart';
import 'package:vi_dien_tu/providers/expense_provider.dart';
import 'package:vi_dien_tu/providers/user_provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';
import 'package:vi_dien_tu/providers/wallet_provider.dart';
import 'package:vi_dien_tu/providers/transaction_provider.dart';
import 'package:vi_dien_tu/providers/notification_provider.dart';
import 'package:vi_dien_tu/utils/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) =>
                ExpenseProvider()),
        ChangeNotifierProvider(
            create: (context) => UserProvider()),
        ChangeNotifierProvider(
            create: (context) =>
                SettingsProvider()),
        ChangeNotifierProvider(
            create: (context) =>
                WalletProvider()),
        ChangeNotifierProvider(
            create: (context) =>
                TransactionProvider()),
        ChangeNotifierProvider(
            create: (context) =>
                NotificationProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: const Locale('vi', 'VN'),
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                brightness: Brightness.light,
              ),
              primaryColor: AppColors.primary,
              appBarTheme: const AppBarTheme(
                backgroundColor:
                    AppColors.primary,
                foregroundColor: Colors.white,
              ),
              elevatedButtonTheme:
                  ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                brightness: Brightness.dark,
              ),
              primaryColor: AppColors.primary,
              appBarTheme: const AppBarTheme(
                backgroundColor:
                    AppColors.primary,
                foregroundColor: Colors.white,
              ),
              elevatedButtonTheme:
                  ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            themeMode: settings.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: const LoginScreen(),
            routes: {
              '/home': (context) =>
                  const HomeScreen(),
              '/login': (context) =>
                  const LoginScreen(),
            },
            onGenerateRoute: (routeSettings) {
              if (routeSettings.name == '/home') {
                return MaterialPageRoute(
                    builder: (context) =>
                        const HomeScreen());
              } else if (routeSettings.name ==
                  '/login') {
                return MaterialPageRoute(
                    builder: (context) =>
                        const LoginScreen());
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
