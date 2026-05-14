import 'package:test/test.dart';
import 'package:bmw_dealer/bmw_dealer.dart';

void main() {
  group('Client toMap / fromMap', () {
    test('toMap возвращает правильные ключи', () {
      final client = Client(id: '1', name: 'Иван', phone: '+79001234567');
      final map = client.toMap();
      expect(map['id'], '1');
      expect(map['name'], 'Иван');
      expect(map['phone'], '+79001234567');
    });

    test('fromMap восстанавливает объект', () {
      final map = {'id': '2', 'name': 'Анна', 'phone': '+79007654321'};
      final client = Client.fromMap(map);
      expect(client.id, '2');
      expect(client.name, 'Анна');
      expect(client.phone, '+79007654321');
    });
  });

  group('Car toMap / fromMap', () {
    test('toMap возвращает правильные ключи', () {
      final car = Car(id: 'c1', model: 'BMW X5', price: 5000000, year: 2023);
      final map = car.toMap();
      expect(map['model'], 'BMW X5');
      expect(map['price'], 5000000.0);
      expect(map['year'], 2023);
    });

    test('fromMap восстанавливает объект', () {
      final map = {
        'id': 'c2',
        'model': 'BMW M3',
        'price': 7000000,
        'year': 2024,
      };
      final car = Car.fromMap(map);
      expect(car.model, 'BMW M3');
      expect(car.year, 2024);
    });
  });

  group('Manager toMap / fromMap', () {
    test('fromMap восстанавливает объект', () {
      final map = {'id': 'm1', 'name': 'Сергей', 'phone': '+79001111111'};
      final manager = Manager.fromMap(map);
      expect(manager.name, 'Сергей');
    });
  });

  group('TestDrive toMap / fromMap', () {
    test('время сохраняется и восстанавливается', () {
      final time = DateTime(2026, 5, 10, 12, 0);
      final td = TestDrive(
        id: 'td1',
        clientId: 'cl1',
        carId: 'c1',
        managerId: 'm1',
        time: time,
      );
      final restored = TestDrive.fromMap(td.toMap());
      expect(restored.time, time);
    });
  });

  group('Order toMap / fromMap', () {
    test('цена сохраняется корректно', () {
      final order = Order(
        id: 'o1',
        clientId: 'cl1',
        carId: 'c1',
        managerId: 'm1',
        totalPrice: 4500000,
      );
      final map = order.toMap();
      expect(map['totalPrice'], 4500000.0);
    });
  });
}
