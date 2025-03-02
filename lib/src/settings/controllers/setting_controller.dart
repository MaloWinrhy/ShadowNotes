import 'package:flutter/material.dart';
import 'package:shadow_notes/src/settings/views/panic_mode_view.dart';
import 'package:shadow_notes/src/settings/views/backup_export_view.dart';

class SettingsController {
  Future<void> openPanicSettings(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PanicModeView()),
    );
  }

  Future<void> exportBackup(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BackupExportView()),
    );
    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup exported successfully!')),
      );
    }
  }
}