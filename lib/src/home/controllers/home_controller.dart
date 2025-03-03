import 'package:flutter/material.dart';
import 'package:shadow_notes/src/notes/views/notes_view.dart';
import 'package:shadow_notes/src/settings/views/setting_view.dart';
import 'package:shadow_notes/src/utils/widgets/shadow_snackbar.dart';

class HomeController {
  final ValueNotifier<int> currentIndex = ValueNotifier(0);

  final List<Widget> pages = const [
    NotesView(),
    NotesView(),
    NotesView(),
    SettingsView(),
  ];

  final List<String> pageTitles = [
    "Notes",
    "Vault",
    "QR Scanner",
    "Settings"
  ];

  void changePage(BuildContext context, int index) {
    if (index == 1 || index == 2) {
      ShadowSnackbar.show(
        context,
        message: '${pageTitles[index]} is under development!',
        type: ShadowSnackbarType.comingSoon,
      );
    } else {
      currentIndex.value = index;
    }
  }
}