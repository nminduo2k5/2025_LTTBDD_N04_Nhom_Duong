import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/screens/settings/profile_screen.dart';
import 'package:vi_dien_tu/screens/authentication/login_screen.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';
import 'package:vi_dien_tu/utils/translations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showLogoutConfirmation(
      BuildContext context) {
    final settings =
        Provider.of<SettingsProvider>(context,
            listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Translations.get(
              'logout', settings.isEnglish)),
          content: Text(settings.isEnglish
              ? 'Are you sure you want to logout?'
              : 'Bạn có chắc chắn muốn đăng xuất?'),
          actions: <Widget>[
            TextButton(
              child: Text(settings.isEnglish
                  ? 'Cancel'
                  : 'Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(Translations.get(
                  'logout', settings.isEnglish)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8DC),
      appBar: AppBar(
        title: Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return Text(Translations.get(
                'settings', settings.isEnglish));
          },
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFDA020E),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFDA020E), Color(0xFFFF6B6B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return ListView(
              children: [
                ListTile(
                  leading:
                      const Icon(Icons.dark_mode),
                  title: Text(Translations.get(
                      'dark_mode',
                      settings.isEnglish)),
                  trailing: Switch(
                    value: settings.isDarkMode,
                    activeColor:
                        const Color(0xFFDA020E),
                    onChanged: (value) =>
                        settings.toggleTheme(),
                  ),
                ),
                ListTile(
                  leading:
                      const Icon(Icons.language),
                  title: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(Translations.get(
                          'language',
                          settings.isEnglish)),
                      Text(
                        settings.isEnglish
                            ? 'English'
                            : 'Tiếng Việt',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color: Theme.of(
                                      context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                  trailing: Switch(
                    value: settings.isEnglish,
                    activeColor:
                        const Color(0xFFDA020E),
                    onChanged: (value) =>
                        settings.toggleLanguage(),
                  ),
                ),
                ListTile(
                  leading:
                      const Icon(Icons.person),
                  title: Text(Translations.get(
                      'profile',
                      settings.isEnglish)),
                  trailing: const Icon(
                      Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ProfileScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Theme.of(context)
                        .colorScheme
                        .error,
                  ),
                  title: Text(
                    Translations.get('logout',
                        settings.isEnglish),
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .error),
                  ),
                  onTap: () =>
                      _showLogoutConfirmation(
                          context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
