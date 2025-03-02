import 'package:flutter/material.dart';
import 'package:shadow_notes/src/home/views/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupNameController {
  final TextEditingController nameController = TextEditingController();

  Future<void> saveNameAndGoHome(BuildContext context) async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enter a name!"),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', name);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeContainer()),
    );
  }
}