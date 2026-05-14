import 'identity.dart';

class Order implements Identity {
  @override
  final String id;
  final String clientId;
  final String carId;
  final String managerId;
  final double totalPrice;

  const Order({
    required this.id,
    required this.clientId,
    required this.carId,
    required this.managerId,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'clientId': clientId,
        'carId': carId,
        'managerId': managerId,
        'totalPrice': totalPrice,
      };

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      clientId: map['clientId'] as String,
      carId: map['carId'] as String,
      managerId: map['managerId'] as String,
      totalPrice: _asDouble(map['totalPrice']),
    );
  }

  static double _asDouble(Object? value) {
    if (value is num) return value.toDouble();
    throw FormatException('Ожидали число', value);
  }
}
