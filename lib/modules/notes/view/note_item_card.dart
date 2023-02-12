import 'package:flutter/material.dart';
import 'package:flutter_notes_app/modules/notes/view/add_note_view.dart';

import '../models/note_model.dart';

class NoteItemCard extends StatelessWidget {
  const NoteItemCard({
    super.key,
    required this.note,
  });

  final NoteModel note;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            note.description ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Priority: ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Text(note.priority ?? '', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  Text(
                    'Status: ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color:  note.status == 'Completed' ? Colors.green : note.status == 'Pending' ? Colors.indigo : Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.all(4),
                    child:   Text(note.status ?? '',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  final route = MaterialPageRoute(
                    builder: (context) => const AddNoteView(),
                  );
                  Navigator.of(context).push(route);
                },
                child: const Text('Edit'),
              ),
              TextButton(
                onPressed: () {
                  // alert confirm dialog
                  showDialog(
                    context: context,
                    builder: (context) {
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
                              Navigator.of(context).pop();
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
