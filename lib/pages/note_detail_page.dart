import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/notes_database.dart';
import '../model/note.dart';
import 'edit_note_page.dart';

class NoteDetail extends StatefulWidget {
  const NoteDetail({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  final int noteId;

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    note = await NotesDatabase.instance.readNote(widget.noteId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          editButton(),
          deleteButton(),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat.yMMMd().format(note.createdTime),
                    style: const TextStyle(color: Colors.white38),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 18),
                  )
                ],
              ),
            ),
    );
  }

  Widget editButton() {
    return IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddEditNotePage(note: note),
          ),
        );

        refreshNote();
      },
    );
  }

  Widget deleteButton() {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        NotesDatabase.instance.delete(widget.noteId);

        Navigator.of(context).pop();
      },
    );
  }
}
