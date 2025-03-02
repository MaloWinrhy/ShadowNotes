import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shadow_notes/src/settings/controllers/setting_controller.dart';
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
          _buildSettingTile(LucideIcons.shieldAlert, 'Panic Mode Settings', () => controller.openPanicSettings(context)),
          _buildSettingTile(LucideIcons.download, 'Export Encrypted Backup', () => controller.exportBackup(context)),

          const SizedBox(height: 24),
          _buildSectionTitle('Support & Info'),
          _buildSettingTile(LucideIcons.helpCircle, 'FAQ & Documentation', () => _openLink('https://shadownotes.app/docs', context)),
          _buildSettingTile(LucideIcons.coffee, 'Support Development', subtitle: 'Buy me a coffee', () => _openLink('https://buymeacoffee.com/winrhy', context)),
          _buildSettingTile(LucideIcons.info, 'About ShadowNotes', () => _showAboutDialog(context)),
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

  Widget _buildSettingTile(IconData icon, String title, VoidCallback onTap, {String? subtitle}) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Colors.white54)) : null,
      trailing: const Icon(LucideIcons.chevronRight, color: Colors.white54),
      onTap: onTap,
    );
  }

  Future<void> _openLink(String url, context) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }

  Future<void> _showAboutDialog(BuildContext context) async {
    showAboutDialog(
      context: context,
      applicationName: 'ShadowNotes',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2025 Winrhy',
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text(
            'ShadowNotes is your encrypted note app designed for privacy enthusiasts. Each note is individually encrypted, ensuring maximum security.',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }
}