// home_page.dart
import 'package:flutter/material.dart';
import 'add_note_page.dart';
import 'view_note_page.dart';
import 'edit_note_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final List<String>? initialNotes;
  
  const HomePage({super.key, this.initialNotes});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<String> notes;

  @override
  void initState() {
    super.initState();
    notes = widget.initialNotes ?? [];
  }

  void _addNote(String note) {
    setState(() {
      notes.add(note);
    });
  }

  void _updateNoteAt(int index, String updatedNote) {
    setState(() {
      notes[index] = updatedNote;
    });
  }

  void _deleteNoteAt(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: notes.isEmpty
          ? const Center(child: Text('No notes yet. Add some!'))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notes[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final updatedNote = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditNotePage(
                                note: notes[index],
                              ),
                            ),
                          );
                          if (updatedNote != null) {
                            _updateNoteAt(index, updatedNote);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteNoteAt(index),
                      ),
                    ],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewNotePage(note: notes[index]),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newNote = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNotePage(),
            ),
          );
          if (newNote != null) _addNote(newNote);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
