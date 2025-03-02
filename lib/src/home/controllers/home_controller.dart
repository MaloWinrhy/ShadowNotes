import 'package:flutter/material.dart';
import 'package:shadow_notes/src/notes/views/notes_view.dart';
import 'package:shadow_notes/src/settings/views/setting_view.dart';

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

  void changePage(int index) {
    currentIndex.value = index;
  }
}