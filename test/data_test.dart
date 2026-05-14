import 'package:test/test.dart';
import 'package:bmw_dealer/bmw_dealer.dart';

void main() {
  late BmwDatabase db;
  late ClientRepository clients;
  late CarRepository cars;
  late ManagerRepository managers;
  late TestDriveRepository testDrives;
  late OrderRepository orders;

  setUp(() {
    db = BmwDatabase(':memory:');
    clients = ClientRepository(db);
    cars = CarRepository(db);
    managers = ManagerRepository(db);
    testDrives = TestDriveRepository(db);
    orders = OrderRepository(db);
  });

  tearDown(() {
    db.close();
  });

  group('ClientRepository', () {
    test('create и readAll', () {
      clients.create(Client(id: '1', name: 'Иван', phone: '+79001234567'));
      final list = clients.readAll();
      expect(list.length, 1);
      expect(list.first.name, 'Иван');
    });

    test('readById возвращает нужного клиента', () {
      clients.create(Client(id: '1', name: 'Иван', phone: '+79001234567'));
      final client = clients.readById('1');
      expect(client, isNotNull);
      expect(client!.phone, '+79001234567');
    });

    test('update обновляет данные', () {
      clients.create(Client(id: '1', name: 'Иван', phone: '+79001234567'));
      clients.update(Client(id: '1', name: 'Пётр', phone: '+79009999999'));
      final client = clients.readById('1');
      expect(client!.name, 'Пётр');
    });

    test('delete удаляет клиента', () {
      clients.create(Client(id: '1', name: 'Иван', phone: '+79001234567'));
      clients.delete('1');
      expect(clients.readAll(), isEmpty);
    });
  });

  group('CarRepository', () {
    test('create и readAll', () {
      cars.create(Car(id: 'c1', model: 'BMW X5', price: 5000000, year: 2023));
      final list = cars.readAll();
      expect(list.length, 1);
      expect(list.first.model, 'BMW X5');
    });

    test('readById возвращает нужный автомобиль', () {
      cars.create(Car(id: 'c1', model: 'BMW X5', price: 5000000, year: 2023));
      final car = cars.readById('c1');
      expect(car, isNotNull);
      expect(car!.year, 2023);
    });

    test('update обновляет данные', () {
      cars.create(Car(id: 'c1', model: 'BMW X5', price: 5000000, year: 2023));
      cars.update(Car(id: 'c1', model: 'BMW M5', price: 8000000, year: 2024));
      final car = cars.readById('c1');
      expect(car!.model, 'BMW M5');
    });

    test('delete удаляет автомобиль', () {
      cars.create(Car(id: 'c1', model: 'BMW X5', price: 5000000, year: 2023));
      cars.delete('c1');
      expect(cars.readAll(), isEmpty);
    });
  });

  group('ManagerRepository', () {
    test('create и readAll', () {
      managers.create(Manager(id: 'm1', name: 'Сергей', phone: '+79001111111'));
      final list = managers.readAll();
      expect(list.length, 1);
      expect(list.first.name, 'Сергей');
    });

    test('delete удаляет менеджера', () {
      managers.create(Manager(id: 'm1', name: 'Сергей', phone: '+79001111111'));
      managers.delete('m1');
      expect(managers.readAll(), isEmpty);
    });
  });

  group('TestDriveRepository', () {
    setUp(() {
      clients.create(Client(id: 'cl1', name: 'Иван', phone: '+79001234567'));
      cars.create(Car(id: 'c1', model: 'BMW X5', price: 5000000, year: 2023));
      managers.create(Manager(id: 'm1', name: 'Сергей', phone: '+79001111111'));
    });

    test('create и readAll', () {
      testDrives.create(TestDrive(
        id: 'td1',
        clientId: 'cl1',
        carId: 'c1',
        managerId: 'm1',
        time: DateTime(2026, 5, 10, 12, 0),
      ));
      final list = testDrives.readAll();
      expect(list.length, 1);
      expect(list.first.clientId, 'cl1');
    });

    test('delete удаляет тест-драйв', () {
      testDrives.create(TestDrive(
        id: 'td1',
        clientId: 'cl1',
        carId: 'c1',
        managerId: 'm1',
        time: DateTime(2026, 5, 10, 12, 0),
      ));
      testDrives.delete('td1');
      expect(testDrives.readAll(), isEmpty);
    });
  });

  group('OrderRepository', () {
    setUp(() {
      clients.create(Client(id: 'cl1', name: 'Иван', phone: '+79001234567'));
      cars.create(Car(id: 'c1', model: 'BMW X5', price: 5000000, year: 2023));
      managers.create(Manager(id: 'm1', name: 'Сергей', phone: '+79001111111'));
    });

    test('create и readAll', () {
      orders.create(Order(
        id: 'o1',
        clientId: 'cl1',
        carId: 'c1',
        managerId: 'm1',
        totalPrice: 4500000,
      ));
      final list = orders.readAll();
      expect(list.length, 1);
      expect(list.first.totalPrice, 4500000.0);
    });

    test('delete удаляет заказ', () {
      orders.create(Order(
        id: 'o1',
        clientId: 'cl1',
        carId: 'c1',
        managerId: 'm1',
        totalPrice: 4500000,
      ));
      orders.delete('o1');
      expect(orders.readAll(), isEmpty);
    });
  });
}
