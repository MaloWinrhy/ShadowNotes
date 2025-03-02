import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shadow_notes/src/rust/api/encryption.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/note_model.dart';
import '../views/note_editor_view.dart';

class NotesController {
  final ValueNotifier<List<NoteItem>> notes = ValueNotifier([]);
  final ValueNotifier<String> username = ValueNotifier('User');

  Future<void> init() async {
    await _loadUsername();
    await _loadNotes();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString('username') ?? 'User';
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesString = prefs.getString('notes');
    if (notesString != null) {
      final List<dynamic> decoded = jsonDecode(notesString);
      notes.value = decoded.map((e) => NoteItem.fromJson(e as Map<String, dynamic>)).toList();
    }
  }

  Future<void> saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = notes.value.map((n) => n.toJson()).toList();
    await prefs.setString('notes', jsonEncode(notesJson));
  }

  Future<void> addNewNote(BuildContext context) async {
    final newNote = await showNoteEditor(context);
    if (newNote != null) {
      notes.value = [...notes.value, newNote];
      saveNotes();
    }
  }

  Future<void> showNotePasswordDialog(BuildContext context, NoteItem note) async {
    final password = await _askForPassword(context);
    if (password != null && password.isNotEmpty) {
      _decryptAndShowNote(context, note, password);
    }
  }

  Future<String?> _askForPassword(BuildContext context) async {
    final controller = TextEditingController();
    return await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.lock, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            const Text('Enter Password', style: TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              obscureText: true,
              cursorColor: Colors.green,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("Password"),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.green),
                  ),
                  onPressed: () => Navigator.pop(context, controller.text.trim()),
                  child: const Text('Decrypt'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _decryptAndShowNote(BuildContext context, NoteItem note, String password) async {
    try {
      final decrypted = await decryptNote(
        nonce: note.nonce.toList(),
        encryptedNote: note.encrypted.toList(),
        password: password,
      );
      _showDecryptedNote(context, note, decrypted);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect password')),
      );
    }
  }

  void _showDecryptedNote(BuildContext context, NoteItem note, String content) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note.title, style: const TextStyle(color: Colors.white, fontSize: 22)),
            Text("📎 Tags: ${note.tags.join(', ')}", style: const TextStyle(color: Colors.white54)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
              child: Text(content, style: const TextStyle(color: Colors.white)),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
    );
  }
}