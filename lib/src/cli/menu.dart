import 'dart:io';

import '../data/database.dart';
import '../data/repositories/client_repository.dart';
import '../data/repositories/car_repository.dart';
import '../data/repositories/manager_repository.dart';
import '../data/repositories/test_drive_repository.dart';
import '../data/repositories/order_repository.dart';
import '../domain/models/client.dart';
import '../domain/models/car.dart';
import '../domain/models/manager.dart';
import '../domain/models/test_drive.dart';
import '../domain/models/order.dart';
import 'input_helper.dart';

void runMenu(BmwDatabase db) {
  final clients = ClientRepository(db);
  final cars = CarRepository(db);
  final managers = ManagerRepository(db);
  final testDrives = TestDriveRepository(db);
  final orders = OrderRepository(db);

  while (true) {
    stdout.writeln('''
--- BMW Дилерский центр ---
 1 — список клиентов
 2 — добавить клиента
 3 — обновить клиента
 4 — удалить клиента

 5 — список автомобилей
 6 — добавить автомобиль
 7 — обновить автомобиль
 8 — удалить автомобиль

 9 — список менеджеров
10 — добавить менеджера
11 — обновить менеджера
12 — удалить менеджера

13 — список тест-драйвов
14 — добавить тест-драйв
15 — удалить тест-драйв

16 — список заказов
17 — добавить заказ
18 — удалить заказ

19 — показать всё из БД
 0 — выход
Выберите пункт:''');

    final choice = stdin.readLineSync()?.trim() ?? '';
    switch (choice) {
      case '1':
        _printClients(clients);
        break;
      case '2':
        _addClient(clients);
        break;
      case '3':
        _updateClient(clients);
        break;
      case '4':
        _deleteClient(clients);
        break;
      case '5':
        _printCars(cars);
        break;
      case '6':
        _addCar(cars);
        break;
      case '7':
        _updateCar(cars);
        break;
      case '8':
        _deleteCar(cars);
        break;
      case '9':
        _printManagers(managers);
        break;
      case '10':
        _addManager(managers);
        break;
      case '11':
        _updateManager(managers);
        break;
      case '12':
        _deleteManager(managers);
        break;
      case '13':
        _printTestDrives(testDrives);
        break;
      case '14':
        _addTestDrive(testDrives, clients, cars, managers);
        break;
      case '15':
        _deleteTestDrive(testDrives);
        break;
      case '16':
        _printOrders(orders);
        break;
      case '17':
        _addOrder(orders, clients, cars, managers);
        break;
      case '18':
        _deleteOrder(orders);
        break;
      case '19':
        _printAll(clients, cars, managers, testDrives, orders);
        break;
      case '0':
        stdout.writeln('До свидания.');
        return;
      default:
        stdout.writeln('Неизвестная команда.');
    }
    stdout.writeln();
  }
}

void _printClients(ClientRepository repo) {
  final list = repo.readAll();
  if (list.isEmpty) {
    stdout.writeln('Клиентов нет.');
    return;
  }
  for (final c in list) {
    stdout.writeln('id: ${c.id} | ${c.name} | ${c.phone}');
  }
}

void _addClient(ClientRepository repo) {
  final id = readText('id клиента: ');
  final name = readText('имя: ');
  final phone = readText('телефон: ');
  repo.create(Client(id: id, name: name, phone: phone));
  stdout.writeln('Клиент добавлен.');
}

void _updateClient(ClientRepository repo) {
  final id = readRaw('id клиента для обновления: ');
  final name = readText('новое имя: ');
  final phone = readText('новый телефон: ');
  repo.update(Client(id: id, name: name, phone: phone));
  stdout.writeln('Клиент обновлён.');
}

void _deleteClient(ClientRepository repo) {
  final id = readRaw('id клиента для удаления: ');
  repo.delete(id);
  stdout.writeln('Готово (если id был в базе).');
}

void _printCars(CarRepository repo) {
  final list = repo.readAll();
  if (list.isEmpty) {
    stdout.writeln('Автомобилей нет.');
    return;
  }
  for (final c in list) {
    stdout.writeln('id: ${c.id} | ${c.model} | ${c.year} | ${c.price} ₽');
  }
}

void _addCar(CarRepository repo) {
  final id = readText('id автомобиля: ');
  final model = readText('модель (например BMW X5): ');
  final price = readPositiveDouble('цена (число): ');
  final year = readPositiveInt('год выпуска: ');
  repo.create(Car(id: id, model: model, price: price, year: year));
  stdout.writeln('Автомобиль добавлен.');
}

void _updateCar(CarRepository repo) {
  final id = readRaw('id автомобиля для обновления: ');
  final model = readText('новая модель: ');
  final price = readPositiveDouble('новая цена: ');
  final year = readPositiveInt('новый год выпуска: ');
  repo.update(Car(id: id, model: model, price: price, year: year));
  stdout.writeln('Автомобиль обновлён.');
}

void _deleteCar(CarRepository repo) {
  final id = readRaw('id автомобиля для удаления: ');
  repo.delete(id);
  stdout.writeln('Готово (если id был в базе).');
}

void _printManagers(ManagerRepository repo) {
  final list = repo.readAll();
  if (list.isEmpty) {
    stdout.writeln('Менеджеров нет.');
    return;
  }
  for (final m in list) {
    stdout.writeln('id: ${m.id} | ${m.name} | ${m.phone}');
  }
}

void _addManager(ManagerRepository repo) {
  final id = readText('id менеджера: ');
  final name = readText('имя: ');
  final phone = readText('телефон: ');
  repo.create(Manager(id: id, name: name, phone: phone));
  stdout.writeln('Менеджер добавлен.');
}

void _updateManager(ManagerRepository repo) {
  final id = readRaw('id менеджера для обновления: ');
  final name = readText('новое имя: ');
  final phone = readText('новый телефон: ');
  repo.update(Manager(id: id, name: name, phone: phone));
  stdout.writeln('Менеджер обновлён.');
}

void _deleteManager(ManagerRepository repo) {
  final id = readRaw('id менеджера для удаления: ');
  repo.delete(id);
  stdout.writeln('Готово (если id был в базе).');
}

void _printTestDrives(TestDriveRepository repo) {
  final list = repo.readAll();
  if (list.isEmpty) {
    stdout.writeln('Тест-драйвов нет.');
    return;
  }
  for (final t in list) {
    stdout.writeln(
      'id: ${t.id} | клиент: ${t.clientId} | авто: ${t.carId} | менеджер: ${t.managerId} | ${t.time.toLocal()}',
    );
  }
}

void _addTestDrive(
  TestDriveRepository repo,
  ClientRepository clients,
  CarRepository cars,
  ManagerRepository managers,
) {
  stdout.writeln('Доступные клиенты:');
  _printClients(clients);
  stdout.writeln('Доступные автомобили:');
  _printCars(cars);
  stdout.writeln('Доступные менеджеры:');
  _printManagers(managers);

  final id = readText('id тест-драйва: ');
  final clientId = readText('id клиента: ');
  final carId = readText('id автомобиля: ');
  final managerId = readText('id менеджера: ');
  final time = readDateTime('дата и время (например 2026-05-07T14:30:00): ');

  repo.create(
    TestDrive(
      id: id,
      clientId: clientId,
      carId: carId,
      managerId: managerId,
      time: time,
    ),
  );
  stdout.writeln('Тест-драйв записан.');
}

void _deleteTestDrive(TestDriveRepository repo) {
  final id = readRaw('id тест-драйва для удаления: ');
  repo.delete(id);
  stdout.writeln('Готово (если id был в базе).');
}

void _printOrders(OrderRepository repo) {
  final list = repo.readAll();
  if (list.isEmpty) {
    stdout.writeln('Заказов нет.');
    return;
  }
  for (final o in list) {
    stdout.writeln(
      'id: ${o.id} | клиент: ${o.clientId} | авто: ${o.carId} | менеджер: ${o.managerId} | ${o.totalPrice} ₽',
    );
  }
}

void _addOrder(
  OrderRepository repo,
  ClientRepository clients,
  CarRepository cars,
  ManagerRepository managers,
) {
  stdout.writeln('Доступные клиенты:');
  _printClients(clients);
  stdout.writeln('Доступные автомобили:');
  _printCars(cars);
  stdout.writeln('Доступные менеджеры:');
  _printManagers(managers);

  final id = readText('id заказа: ');
  final clientId = readText('id клиента: ');
  final carId = readText('id автомобиля: ');
  final managerId = readText('id менеджера: ');
  final totalPrice = readPositiveDouble('итоговая цена: ');

  repo.create(
    Order(
      id: id,
      clientId: clientId,
      carId: carId,
      managerId: managerId,
      totalPrice: totalPrice,
    ),
  );
  stdout.writeln('Заказ оформлен.');
}

void _deleteOrder(OrderRepository repo) {
  final id = readRaw('id заказа для удаления: ');
  repo.delete(id);
  stdout.writeln('Готово (если id был в базе).');
}

void _printAll(
  ClientRepository clients,
  CarRepository cars,
  ManagerRepository managers,
  TestDriveRepository testDrives,
  OrderRepository orders,
) {
  stdout.writeln('=== Клиенты ===');
  _printClients(clients);
  stdout.writeln('=== Автомобили ===');
  _printCars(cars);
  stdout.writeln('=== Менеджеры ===');
  _printManagers(managers);
  stdout.writeln('=== Тест-драйвы ===');
  _printTestDrives(testDrives);
  stdout.writeln('=== Заказы ===');
  _printOrders(orders);
}
