import 'package:flutter/material.dart';
import 'package:frontend/models/note.dart';
import 'package:frontend/models/todo.dart';
import 'package:frontend/models/contact.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';
import '../providers/todos_provider.dart';
import '../providers/contact_provider.dart';

class AddNotePage extends StatefulWidget {
  final bool isUpdate;
  final Note? note;

  const AddNotePage({Key? key, required this.isUpdate, this.note})
      : super(key: key);

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
  List<Contact> linkedContacts = [];

  void addNewNote() async {
    List<String> newTodoIds = [];

    // Include the ids of linked contacts in the note
    List<String> linkedContactIds =
        linkedContacts.map((contact) => contact.id!).toList();

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
      contacts: linkedContactIds,
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
    // Include the ids of linked contacts in the note
    List<String> linkedContactIds =
        linkedContacts.map((contact) => contact.id!).toList();

    Note updatedNote = Note(
      id: widget.note!.id,
      title: titleController.text,
      content: contentController.text,
      tags: tags,
      todos: widget.note!.todos,
      sharedto: widget.note!.sharedto,
      contacts: linkedContactIds,
      createdAt: widget.note!.createdAt,
      updatedAt: DateTime.now(),
    );

    Provider.of<NotesProvider>(context, listen: false).updateNote(updatedNote);
    Navigator.pop(context);
  }

  void addContact() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add Contact'),
        content: FutureBuilder<List<Contact>>(
          future: Provider.of<ContactProvider>(context, listen: false)
              .fetchContacts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.error != null) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (ctx, i) => ListTile(
                      title: Text(snapshot.data![i].firstname),
                      onTap: () {
                        setState(() {
                          linkedContacts.add(snapshot.data![i]);
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ));
            }
          },
        ),
      ),
    );
  }

  Future<Todo> createTodo(Todo todo) async {
    return await Provider.of<TodoProvider>(context, listen: false)
        .addTodo(todo);
  }

  void updateTodo(todo) async {
    await Provider.of<TodoProvider>(context, listen: false).updateTodo(todo);
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
        controller: TextEditingController(),
        focusNode: FocusNode(),
        key: UniqueKey(),
      ));
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
      if (widget.note!.tags != null) {
        tags = widget.note!.tags!;
      }

      if (widget.note!.contacts != null) {
        for (var contactId in widget.note!.contacts!) {
          Provider.of<ContactProvider>(context, listen: false)
              .fetchContact(contactId)
              .then((value) {
            setState(() {
              linkedContacts.add(value);
            });
          }).catchError((error) {
            print(error);
          });
        }
      }

      if (widget.note!.id != null) {
        Provider.of<TodoProvider>(context, listen: false)
            .fetchTodosByNoteId(widget.note!.id!)
            .then((value) {
          print('fetchTodosByNoteId: $value');
          setState(() {
            todos = value;
          });
        }).catchError((error) {
          print(error);
        });
      }
    }
  }

  @override
  void dispose() {
    // dispose todos controllers and focus nodes
    for (var todo in todos) {
      todo.controller?.dispose();
      todo.focusNode?.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            const IconButton(
              onPressed: null,
              icon: Icon(Icons.push_pin),
            ),
            IconButton(
              onPressed: () {
                // title and content should not be empty
                if (titleController.text == '' ||
                    contentController.text == '') {
                  return;
                }
                if (widget.isUpdate) {
                  // update todos first if any
                  for (var todo in todos) {
                    if (todo.id != null) {
                      updateTodo(todo);
                    } else {
                      createTodo(todo).then((value) {
                        todo.id = value.id;
                        updateTodo(todo);
                      });
                    }
                  }
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
                const PopupMenuItem(
                  value: 2,
                  child: Text("Add Contact"),
                ),
              ],
              onSelected: (value) {
                if (value == 1) {
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
                } else if (value == 2) {
                  addContact();
                }
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
                Expanded(
                  child: ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      todo.controller ??=
                          TextEditingController(text: todo.name);
                      return Row(
                        children: [
                          Checkbox(
                            value: todo.isChecked,
                            onChanged: (value) {
                              setState(() {
                                todo.isChecked = value ?? false;
                              });
                            },
                          ),
                          Expanded(
                            child: TextField(
                              key: todos[index].key,
                              controller: todo.controller,
                              focusNode: todo.focusNode,
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
                    },
                  ),
                ),
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
                Expanded(
                    child: ListView.builder(
                  itemCount: linkedContacts.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(linkedContacts[index].firstname),
                      subtitle: Text(linkedContacts[index].lastname ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            linkedContacts.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ))
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
              if (linkedContacts.isNotEmpty)
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Linked Contacts'),
                        content: Column(
                          children: linkedContacts
                              .map((contact) => ListTile(
                                    title: Text(contact.firstname),
                                    subtitle: Text(contact.phone),
                                    trailing: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          linkedContacts.remove(contact);
                                        });
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person),
                ),
            ],
          ),
        ));
  }
}
