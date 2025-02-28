import 'package:flutter/material.dart';
import 'package:shadow_notes/src/rust/api/encryption.dart';
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

class NoteEditorView extends StatefulWidget {
  const NoteEditorView({super.key});

  @override
  State<NoteEditorView> createState() => _NoteEditorViewState();
}

class _NoteEditorViewState extends State<NoteEditorView> {
  final _titleController = TextEditingController();
  final _tagsController = TextEditingController();
  final _noteController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final tags = _tagsController.text.trim().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    final content = _noteController.text.trim();
    final password = _passwordController.text.trim();

    if (title.isEmpty || content.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tous les champs sont obligatoires !")),
      );
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
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur de chiffrement: $e")),
        );
      }
    }
  }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "New Note",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _saveNote,
                  child: const Text("Save", style: TextStyle(color: Colors.green)),
                )
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(controller: _titleController, label: "Title"),
            _buildTextField(controller: _tagsController, label: "Tags (separated by commas)"),
            _buildTextField(controller: _noteController, label: "Content of the note", maxLines: 5),
            _buildTextField(controller: _passwordController, label: "Password", obscureText: true),
          ],
        ),
      ),
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