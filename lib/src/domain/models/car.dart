import 'identity.dart';

class Car implements Identity {
  @override
  final String id;
  final String model;
  final double price;
  final int year;

  const Car({
    required this.id,
    required this.model,
    required this.price,
    required this.year,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'model': model,
        'price': price,
        'year': year,
      };

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'] as String,
      model: map['model'] as String,
      price: _asDouble(map['price']),
      year: _asInt(map['year']),
    );
  }

  static double _asDouble(Object? value) {
    if (value is num) return value.toDouble();
    throw FormatException('Ожидали число', value);
  }

  static int _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    throw FormatException('Ожидали целое число', value);
  }

  @override
  String toString() => '$model ($year) — $price ₽';
}
