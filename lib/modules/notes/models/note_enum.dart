enum NotePriority {
  low,
  medium,
  high,
}

extension NotePriorityExtension on NotePriority {
  String get name {
    switch (this) {
      case NotePriority.low:
        return 'Low';
      case NotePriority.medium:
        return 'Medium';
      case NotePriority.high:
        return 'High';
      default:
        return '';
    }
  }
}

enum NoteStatus {
  draft,
  pending,
  completed,
}

extension NoteStatusExtension on NoteStatus {
  String get name {
    switch (this) {
      case NoteStatus.draft:
        return 'Draft';
      case NoteStatus.pending:
        return 'Pending';
      case NoteStatus.completed:
        return 'Completed';
      default:
        return '';
    }
  }
}
