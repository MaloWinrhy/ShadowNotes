import 'package:flutter/material.dart';

class BackupExportView extends StatelessWidget {
  const BackupExportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Export Backup'), backgroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Export Encrypted Backup', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              'This will generate a .shadownotes file containing all your notes in encrypted form. Make sure to keep this file safe.',
              style: TextStyle(color: Colors.white70),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // TODO: Call actual export function
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Export Now', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}