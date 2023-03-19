import 'package:flutter/material.dart';
import 'package:frontend/providers/notes_provider.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import 'addnote.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
        ),
        body: (notesProvider.isLoading == false)
            ? SafeArea(
                child: (notesProvider.notes.isNotEmpty)
                    ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
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
                                          )));
                            },
                            onLongPress: () {
                              notesProvider.deleteNote(currentNote);
                            },
                            child: Container(
                              color: Colors.blue,
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    currentNote.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(currentNote.content,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis),
                                  Text(currentNote.date.toString()),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text('No notes found'),
                      ))
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
                        )));
          },
          child: const Icon(Icons.add),
        ));
  }
}
