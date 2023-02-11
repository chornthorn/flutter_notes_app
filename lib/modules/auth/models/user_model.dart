class UserModel {
  // column names
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String EMAIL = 'email';
  static const String PASSWORD = 'password';
  static const String PHONE = 'phone';

  // table name
  static const String TABLE_NAME = 'user';

  // user properties
  late int? id;
  late String? name;
  late String email;
  late String password;
  late String? phone;

  UserModel({
    this.id,
    this.name,
    required this.email,
    required this.password,
    this.phone,
  });

  // fromMap
  UserModel.fromMap(Map<String, dynamic> map) {
    id = map[ID];
    name = map[NAME];
    email = map[EMAIL];
    password = map[PASSWORD];
    phone = map[PHONE];
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};
    data[NAME] = name; // data['name'] = name;
    data[EMAIL] = email;
    data[PASSWORD] = password;
    data[PHONE] = phone;
    return data;
  }
}
