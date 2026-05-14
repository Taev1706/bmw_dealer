import 'identity.dart';

class Client implements Identity {
  @override
  final String id;
  final String name;
  final String phone;

  const Client({
    required this.id,
    required this.name,
    required this.phone,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'phone': phone,
      };

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
    );
  }

  @override
  String toString() => '$name ($phone)';
}
