class User {
  int id;
  String name;
  String? email;

  User({
    required this.id,
    required this.name,
    this.email,
  });
}
