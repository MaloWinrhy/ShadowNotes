import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum ShadowSnackbarType { success, error, info, comingSoon }

class ShadowSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    ShadowSnackbarType type = ShadowSnackbarType.info,
  }) {
    final color = _getColor(type);
    final icon = _getIcon(type);

    final snackBar = SnackBar(
      backgroundColor: Colors.black,
      content: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.8), width: 1),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Color _getColor(ShadowSnackbarType type) {
    switch (type) {
      case ShadowSnackbarType.success:
        return Colors.green;
      case ShadowSnackbarType.error:
        return Colors.red;
      case ShadowSnackbarType.info:
        return Colors.blueAccent;
      case ShadowSnackbarType.comingSoon:
        return Colors.orange;
    }
  }

  static IconData _getIcon(ShadowSnackbarType type) {
    switch (type) {
      case ShadowSnackbarType.success:
        return LucideIcons.checkCircle;
      case ShadowSnackbarType.error:
        return LucideIcons.alertTriangle;
      case ShadowSnackbarType.info:
        return LucideIcons.info;
      case ShadowSnackbarType.comingSoon:
        return LucideIcons.hourglass;
    }
  }
}