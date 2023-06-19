class Contact {
  int id;
  String name;
  String email;

  Contact({required this.id, required this.name, required this.email});

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    id: json['id'],
    name: json['name'],
    email: json['email'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
  };
}
