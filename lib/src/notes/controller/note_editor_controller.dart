import 'package:flutter/material.dart';
import 'package:shadow_notes/src/rust/api/encryption.dart';
import '../models/note_model.dart';

class NoteEditorController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> saveNote(BuildContext context) async {
    final title = titleController.text.trim();
    final tags = tagsController.text.trim().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    final content = noteController.text.trim();
    final password = passwordController.text.trim();

    if (title.isEmpty || content.isEmpty || password.isEmpty) {
      _showSnackBar(context, "All fields are required!");
      return;
    }

    try {
      final (nonce, encrypted) = await encryptNote(
        note: content,
        password: password,
      );

      final newNote = NoteItem(
        nonce: nonce,
        encrypted: encrypted,
        date: DateTime.now(),
        title: title,
        tags: tags,
      );

      if (context.mounted) {
        Navigator.pop(context, newNote);
      }
    } catch (e) {
      _showSnackBar(context, "Error: $e");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }
}