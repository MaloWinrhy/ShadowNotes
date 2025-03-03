import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shadow_notes/src/settings/controllers/setting_controller.dart';
import 'package:shadow_notes/src/utils/widgets/shadow_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SettingsController();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Security'),
          _buildSettingTile(
            LucideIcons.shieldAlert,
            'Panic Mode Settings',
            () => _showComingSoon(context, 'Panic Mode'),
          ),
          _buildSettingTile(
            LucideIcons.download,
            'Export Encrypted Backup',
            () => _showComingSoon(context, 'Backup Export'),
          ),

          const SizedBox(height: 24),
          _buildSectionTitle('Support & Info'),
          _buildSettingTile(
            LucideIcons.helpCircle,
            'FAQ & Documentation',
            () => _openLink('https://shadownotes.app/docs', context),
          ),
          _buildSettingTile(
            LucideIcons.coffee,
            'Support Development',
            subtitle: 'Buy me a coffee',
            () => _openLink('https://buymeacoffee.com/winrhy', context),
          ),
          _buildSettingTile(
            LucideIcons.palette,
            'Dark Mode & Theme',
            () => _showComingSoon(context, 'Theme Customization'),
          ),
          _buildSettingTile(
            LucideIcons.info,
            'About ShadowNotes',
            () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _buildSettingTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    String? subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Colors.white54)) : null,
      trailing: const Icon(LucideIcons.chevronRight, color: Colors.white54),
      onTap: onTap,
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ShadowSnackbar.show(
      context,
      message: '$feature is under development!',
      type: ShadowSnackbarType.comingSoon,
    );
  }

  Future<void> _openLink(String url, BuildContext context) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ShadowSnackbar.show(
        context,
        message: 'Could not open link',
        type: ShadowSnackbarType.error,
      );
    }
  }

 Future<void> _showAboutDialog(BuildContext context) async {
  final packageInfo = await PackageInfo.fromPlatform();

  showDialog(
    // ignore: use_build_context_synchronously
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          'About ShadowNotes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version: ${packageInfo.version}',
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'ShadowNotes is your encrypted note app designed for privacy enthusiasts. Each note is individually encrypted, ensuring maximum security.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            const Text(
              '© 2025 Winrhy',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.green)),
          ),
        ],
      );
    },
  );
}
}