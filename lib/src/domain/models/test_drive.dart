import 'identity.dart';

class TestDrive implements Identity {
  @override
  final String id;
  final String clientId;
  final String carId;
  final String managerId;
  final DateTime time;

  const TestDrive({
    required this.id,
    required this.clientId,
    required this.carId,
    required this.managerId,
    required this.time,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'clientId': clientId,
        'carId': carId,
        'managerId': managerId,
        'time': time.toIso8601String(),
      };

  factory TestDrive.fromMap(Map<String, dynamic> map) {
    return TestDrive(
      id: map['id'] as String,
      clientId: map['clientId'] as String,
      carId: map['carId'] as String,
      managerId: map['managerId'] as String,
      time: DateTime.parse(map['time'] as String),
    );
  }
}
