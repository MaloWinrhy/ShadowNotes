import 'package:flutter/material.dart';
import 'package:shadow_notes/src/notes/controller/note_editor_controller.dart';
import '../models/note_model.dart';

Future<NoteItem?> showNoteEditor(BuildContext context) async {
  return await showModalBottomSheet<NoteItem>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.black,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => const NoteEditorView(),
  );
}

class NoteEditorView extends StatelessWidget {
  const NoteEditorView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = NoteEditorController();

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
            _buildHeader(context, controller),
            const SizedBox(height: 16),
            _buildTextField(controller: controller.titleController, label: "Titre"),
            _buildTextField(controller: controller.tagsController, label: "Tags (séparés par des virgules)"),
            _buildTextField(controller: controller.noteController, label: "Contenu de la note", maxLines: 5),
            _buildTextField(controller: controller.passwordController, label: "Mot de passe", obscureText: true),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, NoteEditorController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Nouvelle Note",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () => controller.saveNote(context),
          child: const Text("Enregistrer", style: TextStyle(color: Colors.green)),
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