import 'package:flutter/material.dart';
import 'package:frontend/models/note.dart';
import 'package:frontend/models/todo.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';
import '../providers/todos_provider.dart';

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
  List<Todo> todos = [];

  void addNewNote() async {
    List<String> newTodoIds = [];

    // If the note should include any todos, create them first.
    if (todos.isNotEmpty) {
      for (var todo in todos) {
        Todo createdTodo =
            await Provider.of<TodoProvider>(context, listen: false)
                .addTodo(todo);
        newTodoIds.add(createdTodo.id!);
      }
    }

    Note newNote = Note(
      title: titleController.text,
      content: contentController.text,
      tags: tags,
      todos: newTodoIds,
      sharedto: [], // TODO: SHARING NOTES
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    Note createdNote = await Provider.of<NotesProvider>(context, listen: false)
        .addNote(newNote);

    // Update todos with the created note's id
    for (String todoId in newTodoIds) {
      Todo todo = await Provider.of<TodoProvider>(context, listen: false)
          .fetchTodoByTodoId(todoId);
      todo.notes ??= [];
      todo.notes!.add(createdNote.id!);
      await Provider.of<TodoProvider>(context, listen: false).updateTodo(todo);
    }

    Navigator.pop(context);
  }

  void updateNote() {
    Note updatedNote = Note(
      id: widget.note!.id,
      title: titleController.text,
      content: contentController.text,
      tags: tags,
      todos: widget.note!.todos,
      sharedto: widget.note!.sharedto,
      createdAt: widget.note!.createdAt,
      updatedAt: DateTime.now(),
    );

    Provider.of<NotesProvider>(context, listen: false).updateNote(updatedNote);
    Navigator.pop(context);
  }

  Future<Todo> createTodo(Todo todo) async {
    return await Provider.of<TodoProvider>(context, listen: false)
        .addTodo(todo);
  }

  void addTag() {
    setState(() {
      if (tagController.text.isNotEmpty) {
        tags.add(tagController.text);
        tagController.clear();
      }
    });
  }

  void newTodo() {
    setState(() {
      todos.add(Todo(
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
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 1,
                  child: Text("Add Tag"),
                ),
              ],
              onSelected: (value) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Add Tag'),
                    content: Row(
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
                  ),
                );
              },
              icon: const Icon(Icons.add),
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
                const SizedBox(height: 10),
                if (todos.isNotEmpty)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Column(
                        children: todos.map((todo) {
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
                      )),
                if (tags.isNotEmpty)
                  Wrap(
                    children: tags
                        .map((tag) => Padding(
                              padding: const EdgeInsets.only(bottom: 40),
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
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          height: 50,
          color: const Color(0xFFE7E7E7),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  newTodo();
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
