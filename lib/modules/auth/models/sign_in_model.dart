class SignInModel {
  late String email;
  late String password;

  SignInModel({required this.email, required this.password});

  SignInModel.fromMap(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}
