import 'package:flutter/material.dart';
import 'package:flutter_notes_app/modules/notes/controllers/note_controller.dart';
import 'package:flutter_notes_app/modules/notes/view/add_note_view.dart';
import 'package:provider/provider.dart';

import 'note_item_card.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {

  late NoteController _noteController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _noteController = context.read<NoteController>();
      _noteController.getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _noteController.getAll();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notes'),
        ),
        body: Consumer(
            builder: (context, NoteController noteController, child) {
              if (noteController.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (noteController.errorMessages.isNotEmpty) {
                return Center(
                  child: Text(noteController.errorMessages),
                );
              }

              if (noteController.notes.isEmpty) {
                return const Center(
                  child: Text('No notes found'),
                );
              }

              return ListView.builder(
                itemCount: noteController.notes.length,
                itemBuilder: (context, index) {
                  final note = noteController.notes[index];
                  return NoteItemCard(
                    note: note,
                  );
                },
              );
            }
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AddNoteView.routePath);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}


