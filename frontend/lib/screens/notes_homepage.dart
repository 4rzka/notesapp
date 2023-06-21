import 'package:flutter/material.dart';
import 'package:frontend/providers/notes_provider.dart';
import 'package:frontend/screens/addcontact.dart';
import 'package:frontend/screens/addtag.dart';
import 'package:frontend/screens/contacts.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import 'addnote.dart';

class NotesHomePage extends StatefulWidget {
  static const routeName = '/notes';
  const NotesHomePage({Key? key}) : super(key: key);

  @override
  State<NotesHomePage> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    List<Note> filteredNotes = notesProvider.notes
        .where((note) => note.title.contains(_searchQuery))
        .toList(); // Filter notes based on search query
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            onPressed: () async {
              String? result = await showSearch(
                context: context,
                delegate: NoteSearchDelegate(notesProvider.notes),
              );
              if (result != null) {
                setState(() {
                  _searchQuery = result;
                });
              }
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Notes'),
            ),
            ListTile(
              title: const Text('All Notes'),
              onTap: () {
                setState(() {
                  _searchQuery = '';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Add tag'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const AddTagPage(isUpdate: false);
                }));
              },
            ),
            ListTile(
              title: const Text('All contacts'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ContactsPage();
                }));
              },
            ),
            ListTile(
              title: const Text('Add contact'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const AddContact();
                }));
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: (notesProvider.isLoading == false)
          ? SafeArea(
              child: (notesProvider.notes.isNotEmpty)
                  ? GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio:
                            0.75, // Adjust the aspect ratio for the cards
                      ),
                      itemCount: notesProvider.notes.length,
                      itemBuilder: (context, index) {
                        Note currentNote = notesProvider.notes[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => AddNotePage(
                                  isUpdate: true,
                                  note: currentNote,
                                ),
                              ),
                            );
                          },
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Delete Note'),
                                    content: const Text(
                                        'Are you sure you want to delete this note?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          notesProvider.deleteNote(currentNote);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Container(
                            color: Colors.blue,
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    currentNote.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    currentNote.content,
                                    style: const TextStyle(fontSize: 14),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('No notes found'),
                    ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => const AddNotePage(
                isUpdate: false,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteSearchDelegate extends SearchDelegate<String> {
  final List<Note> notes;

  NoteSearchDelegate(this.notes);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear search query
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Close search delegate with empty result
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Note> filteredNotes = notes
        .where((note) => note.title.contains(query))
        .toList(); // Filter notes based on search query
    return ListView.builder(
      itemCount: filteredNotes.length,
      itemBuilder: (context, index) {
        Note currentNote = filteredNotes[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => AddNotePage(
                  isUpdate: true,
                  note: currentNote,
                ),
              ),
            );
          },
          child: Container(
            color: Colors.blue,
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    currentNote.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    currentNote.content,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions based on search query
    List<Note> filteredNotes =
        notes.where((note) => note.title.contains(query)).toList();
    return ListView.builder(
      itemCount: filteredNotes.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(filteredNotes[index].title),
        onTap: () {
          close(context, filteredNotes[index].title);
        },
      ),
    );
  }
}
