import 'package:flutter/material.dart';
import 'package:frontend/models/note.dart';
import 'package:frontend/models/todo.dart';
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
  TextEditingController tagController = TextEditingController();

  final FocusNode noteFocus = FocusNode();
  List<String> tags = [];
  List<Todo> checkboxes = [];

  void addNewNote() {
    Note newNote = Note(
      title: titleController.text,
      content: contentController.text,
      tags: tags,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    Provider.of<NotesProvider>(context, listen: false).addNote(newNote);
    Navigator.pop(context);
  }

  void updateNote() {
    Note updatedNote = Note(
      id: widget.note!.id,
      title: titleController.text,
      content: contentController.text,
      tags: tags,
      createdAt: widget.note!.createdAt,
      updatedAt: DateTime.now(),
    );

    Provider.of<NotesProvider>(context, listen: false).updateNote(updatedNote);
    Navigator.pop(context);
  }

  void addTag() {
    setState(() {
      if (tagController.text.isNotEmpty) {
        tags.add(tagController.text);
        tagController.clear();
      }
    });
  }

  void addTodo() {
    setState(() {
      checkboxes.add(Todo(
        name: '',
        isChecked: false,
      ));
    });
  }

  @override
  void initState() {
    if (widget.isUpdate) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
      if (widget.note!.tags != null) {
        tags = widget.note!.tags!;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            const IconButton(onPressed: null, icon: Icon(Icons.push_pin)),
            IconButton(
              onPressed: () {
                // title and content should not be empty
                if (titleController.text == '' ||
                    contentController.text == '') {
                  return;
                }
                if (widget.isUpdate) {
                  updateNote();
                } else {
                  addNewNote();
                }
              },
              icon: const Icon(Icons.save),
            ),
            const IconButton(onPressed: null, icon: Icon(Icons.more_vert)),
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
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: tagController,
                      onSubmitted: (val) {
                        if (val != '') {
                          setState(() {
                            tags.add(val);
                          });
                          tagController.clear();
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'Add Tag',
                        border: InputBorder.none,
                      ),
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: (() {
                        if (tagController.text != '') {
                          addTag();
                        }
                      }),
                      child: const Text('Add'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (tags.isNotEmpty)
                  Wrap(
                    children: tags
                        .map((tag) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Chip(
                                label: Text(tag),
                                onDeleted: () {
                                  setState(() {
                                    tags.remove(tag);
                                  });
                                },
                              ),
                            ))
                        .toList(),
                  ),
                if (checkboxes.isNotEmpty)
                  Column(
                    children: checkboxes.map((todo) {
                      return Row(
                        children: [
                          Checkbox(
                            value: todo.isChecked,
                            onChanged: (value) {
                              setState(() {
                                todo.isChecked = value!;
                              });
                            },
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  todo.name = value;
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'Todo',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          height: 50,
          width: double.infinity,
          color: Colors.blueAccent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  addTodo();
                },
                icon: const Icon(Icons.check_box_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.mic),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.photo),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.attach_file),
              ),
            ],
          ),
        ));
  }
}
