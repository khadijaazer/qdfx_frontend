import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../l10n/translations.dart'; // Import Translations

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = appState.isDarkMode;
    final langCode = appState.currentLocale.languageCode;

    // Helper to get text
    String t(String key) => AppTranslations.get(langCode, key);

    return Container(
      width: 260,
      color: Theme.of(context).cardTheme.color,
      child: Column(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(24.0), // Adjusted padding
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/logo.png',
              height: 60, // Adjust height to fit your sidebar
              fit: BoxFit.contain,
            ),
          ),
          
          // Menu Items (Translated)
          _MenuItem(
            icon: Icons.dashboard_outlined, 
            title: t('dashboard'), 
            isActive: appState.selectedIndex == 0,
            onTap: () => appState.setIndex(0),
          ),
          _MenuItem(
            icon: Icons.cloud_upload_outlined, 
            title: t('upload'), 
            isActive: false, onTap: () {},
          ),
          _MenuItem(
            icon: Icons.video_call_outlined, 
            title: t('realtime'), 
            isActive: false, onTap: () {},
          ),
           _MenuItem(
            icon: Icons.history, 
            title: t('history'), 
            isActive: false, onTap: () {},
          ),
          const Divider(height: 40),
          _MenuItem(
            icon: Icons.credit_card, 
            title: t('billing'), 
            isActive: appState.selectedIndex == 1,
            onTap: () => appState.setIndex(1),
          ),
          _MenuItem(
            icon: Icons.code, 
            title: t('api'), 
            isActive: appState.selectedIndex == 2,
            onTap: () => appState.setIndex(2),
          ),

          const Spacer(),
          
          // SETTINGS AREA
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.black26 : Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Dark Mode Toggle
                Row(
                  children: [
                    Text(t('darkMode'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    const Spacer(),
                    Switch(
                      value: isDark,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (val) => appState.toggleTheme(),
                    )
                  ],
                ),
                const Divider(),
                // Language Dropdown
                Row(
                  children: [
                    Text(t('language'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    const Spacer(),
                    DropdownButton<String>(
                      value: langCode,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down, size: 20),
                      items: const [
                        DropdownMenuItem(value: 'en', child: Text("🇺🇸 EN")),
                        DropdownMenuItem(value: 'fr', child: Text("🇫🇷 FR")),
                        DropdownMenuItem(value: 'ar', child: Text("🇩🇿 AR")),
                      ],
                      onChanged: (val) {
                        if (val != null) appState.changeLanguage(val);
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _MenuItem({super.key, required this.icon, required this.title, required this.onTap, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    Color textCol = Theme.of(context).textTheme.bodyMedium!.color!;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: isActive 
          ? BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border(left: BorderSide(color: primary, width: 4)),
            ) 
          : null,
        child: ListTile(
          leading: Icon(icon, color: isActive ? primary : textCol.withOpacity(0.6), size: 22),
          title: Text(
            title, 
            style: TextStyle(
              color: isActive ? primary : textCol.withOpacity(0.8),
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}