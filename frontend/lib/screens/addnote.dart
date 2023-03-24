import 'package:flutter/material.dart';
import 'package:frontend/models/note.dart';
import 'package:provider/provider.dart';

import '../providers/notes_provider.dart';

class AddNotePage extends StatefulWidget {
  final bool isUpdate;
  final Note? note;
  const AddNotePage({super.key, required this.isUpdate, this.note});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  final FocusNode noteFocus = FocusNode();

  void addNewNote() {
    Note newNote = Note(
      title: titleController.text,
      content: contentController.text,
    );

    Provider.of<NotesProvider>(context, listen: false).addNote(newNote);
    Navigator.pop(context);
  }

  void updateNote() {
    Note updatedNote = Note(
      id: widget.note!.id,
      title: titleController.text,
      content: contentController.text,
    );

    Provider.of<NotesProvider>(context, listen: false).updateNote(updatedNote);
    Navigator.pop(context);
  }

  @override
  void initState() {
    if (widget.isUpdate) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                if (widget.isUpdate) {
                  updateNote();
                } else {
                  addNewNote();
                }
              },
              icon: const Icon(Icons.save),
            ),
          ],
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                autofocus: (widget.isUpdate) ? false : true,
                onSubmitted: (val) {
                  if (val != '') {
                    noteFocus.requestFocus();
                  }
                },
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                ),
              ),
              Expanded(
                  child: TextField(
                focusNode: noteFocus,
                controller: contentController,
                maxLines: null,
                style: const TextStyle(
                  fontSize: 20,
                ),
                decoration: const InputDecoration(
                  hintText: 'Note',
                  border: InputBorder.none,
                ),
              )),
            ],
          ),
        )));
  }
}
