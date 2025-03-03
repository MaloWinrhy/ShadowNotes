import 'package:flutter/material.dart';
import 'package:shadow_notes/src/notes/controller/note_editor_controller.dart';
import '../models/note_model.dart';

Future<NoteItem?> showNoteEditor(BuildContext context) async {
  final controller = NoteEditorController();
  return await showModalBottomSheet<NoteItem>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.black,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => NoteEditorView(controller: controller),
  );
}

class NoteEditorView extends StatelessWidget {
  final NoteEditorController controller;

  const NoteEditorView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildTextField(controller: controller.titleController, label: "Title"),
            _buildTextField(controller: controller.tagsController, label: "Tags (comma separated)"),
            _buildTextField(controller: controller.noteController, label: "Note content", maxLines: 5),
            _buildTextField(controller: controller.passwordController, label: "Password", obscureText: true),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "New Note",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () => controller.saveNote(context),
          child: const Text("Save", style: TextStyle(color: Colors.green)),
        )
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        maxLines: maxLines,
        cursorColor: Colors.green,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white54),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white30),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
        ),
      ),
    );
  }
}