import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shadow_notes/src/notes/controller/note_controller.dart';
import 'package:shadow_notes/src/notes/models/note_model.dart';


class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = NotesController();
    controller.init();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: ValueListenableBuilder<String>(
          valueListenable: controller.username,
          builder: (_, username, __) => Row(
            children: [
              Icon(LucideIcons.penTool, color: Colors.green, size: 22),
              const SizedBox(width: 8),
              Text(
                'Hello, $username',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: ValueListenableBuilder<List<NoteItem>>(
        valueListenable: controller.notes,
        builder: (context, notes, _) {
          if (notes.isEmpty) {
            return const Center(
              child: Text(
                'No notes yet',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }
          return ListView.builder(
            itemCount: notes.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                tileColor: Colors.white10,
                leading: const Icon(LucideIcons.fileLock, color: Colors.green),
                title: Text(note.title, style: const TextStyle(color: Colors.white)),
                subtitle: Text(
                  'Created on ${_formatDate(note.date)}',
                  style: const TextStyle(color: Colors.white54),
                ),
                onTap: () => controller.showNotePasswordDialog(context, note),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.addNewNote(context),
        backgroundColor: Colors.green,
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}