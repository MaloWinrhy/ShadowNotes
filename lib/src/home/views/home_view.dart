import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shadow_notes/src/rust/api/encryption.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note_model.dart';
import 'note_editor_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String username = '';
  final List<NoteItem> notes = [];

@override
void initState() {
  super.initState();
  _init();
}

void _init() {
  _loadUsername();
  Future.delayed(Duration.zero, _loadNotes);
}

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'User';
    });
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesString = prefs.getString('notes');
    if (notesString != null) {
      final List<dynamic> decoded = jsonDecode(notesString);
      setState(() {
        notes.clear();
        notes.addAll(decoded.map((e) => NoteItem.fromJson(e as Map<String, dynamic>)));
      });
    }
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = notes.map((n) => n.toJson()).toList();
    await prefs.setString('notes', jsonEncode(notesJson));
  }

  Future<void> _showNotePasswordDialog(NoteItem note) async {
  final passwordController = TextEditingController();

  final result = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.black,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              '🔐 Enter Password',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: passwordController,
            obscureText: true,
            cursorColor: Colors.green,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Password',
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context, passwordController.text.trim()),
                child: const Text('Decrypt', style: TextStyle(color: Colors.white)),
              ),
            ],
          )
        ],
      ),
    ),
  );

  if (result != null && result.isNotEmpty) {
    _decryptAndShowNote(note, result);
  }
}

  Future<void> _decryptAndShowNote(NoteItem note, String password) async {
    try {
      final decrypted = await decryptNote(
        nonce: note.nonce.toList(),
        encryptedNote: note.encrypted.toList(),
        password: password,
      );
      _showDecryptedNote(note, decrypted);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bad Password')),
      );
    }
  }

  void _showDecryptedNote(NoteItem note, String decryptedContent) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.black,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              note.title,
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "📎 Tags: ${note.tags.join(', ')}",
            style: const TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              decryptedContent,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Colors.green)),
            ),
          ),
        ],
      ),
    ),
  );
}

  Future<void> _addNewNote() async {
    final newNote = await showModalBottomSheet<NoteItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const NoteEditorView(),
    );

    if (newNote != null) {
      setState(() {
        notes.add(newNote);
        _saveNotes();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Hello, $username 👋', style: const TextStyle(color: Colors.white)),
      ),
      body: notes.isEmpty
          ? const Center(
              child: Text(
                'No notes yet',
                style: TextStyle(color: Colors.white54),
              ),
            )
            : ListView.separated(
              itemCount: notes.length,
              padding: const EdgeInsets.all(16),
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                tileColor: Colors.white10,
                leading: const Icon(Icons.lock, color: Colors.green),
                title: Text(note.title, style: const TextStyle(color: Colors.white)),
                subtitle: Text(
                "Created at ${_formatDate(note.date)}",
                style: const TextStyle(color: Colors.white54),
                ),
                onTap: () => _showNotePasswordDialog(note),
              );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: _addNewNote,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}