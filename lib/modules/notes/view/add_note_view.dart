import 'package:flutter/material.dart';
import 'package:flutter_notes_app/modules/notes/controllers/note_controller.dart';
import 'package:flutter_notes_app/modules/notes/models/note_enum.dart';
import 'package:provider/provider.dart';

import '../models/note_model.dart';

class AddNoteView extends StatefulWidget {
  const AddNoteView({Key? key}) : super(key: key);

  static const routePath = '/notes/add';

  @override
  _AddNoteViewState createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  late NotePriority _priority;
  late NoteStatus _status;
  late NoteController _noteController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _priority = NotePriority.low;
    _status = NoteStatus.draft;
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _noteController = context.read<NoteController>();
      _noteController.addListener(_onCreateNotes);
    });
  }

  //_onCreateNotes
  void _onCreateNotes() {
    if (_noteController.createNoteStatus == CreateNoteStatus.success) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _noteController.removeListener(_onCreateNotes);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<NotePriority>(
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: NotePriority.values
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                _priority = value!;
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a priority';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // radio button
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Status: '),
                ...NoteStatus.values
                    .map(
                      (e) => Row(
                        children: [
                          Consumer(
                            builder: (_, NoteController noteController, __) {
                              return Expanded(
                                child: RadioListTile<NoteStatus>(
                                  title: Text(e.name),
                                  value: e,
                                  groupValue: noteController.noteStatus,
                                  onChanged: (value) {
                                    print(value);
                                    noteController.noteStatus = value!;
                                    _status = value;
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _onSubmit,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  // on submit
  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final noteModel = NoteModel(
        title: _titleController.text,
        description: _descriptionController.text,
        priority: _priority.name,
        status: _status.name,
      );

      _noteController.create(noteModel);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
