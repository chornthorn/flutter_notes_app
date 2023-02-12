class NoteModel {
  static const String TABLE_NAME = 'notes';
  static const String ID = 'id';
  static const String TITLE = 'title';
  static const String DESCRIPTION = 'description';
  static const String PRIORITY = 'priority';
  static const String STATUS = 'status';
  static const String CREATED_AT = 'created_at';
  static const String UPDATED_AT = 'updated_at';

  late int? id;
  late String title;
  late String? description;
  late String? priority;
  late String? status;
  late String? createdAt;
  late String? updatedAt;


  // constructor
  NoteModel({
    this.id,
    required this.title,
    this.description,
    this.priority,
    this.status,
    this.createdAt,
    this.updatedAt,
  });


  // from Map
  NoteModel.fromMap(Map<String, dynamic> map) {
    id = map[ID];
    title = map[TITLE];
    description = map[DESCRIPTION];
    priority = map[PRIORITY];
    status = map[STATUS];
    createdAt = map[CREATED_AT];
    updatedAt = map[UPDATED_AT];
  }

  // to Map
  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};
    data[TITLE] = title;
    data[DESCRIPTION] = description;
    data[PRIORITY] = priority;
    data[STATUS] = status;
    data[CREATED_AT] = createdAt;
    data[UPDATED_AT] = updatedAt;
    return data;
  }
}
