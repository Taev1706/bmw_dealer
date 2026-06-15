import 'dart:convert';
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
import '../logger/app_logger.dart';
import '../reports/async_report.dart';
import 'input_helper.dart';

Future<void> runMenuAsync(BmwDatabase db) async {
  stdout.encoding = utf8;
  final log = AppLogger();
  log.start('Приложение запущено');

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
20 — асинхронный отчёт
 0 — выход
Выберите пункт:''');

    final choice = stdin.readLineSync()?.trim() ?? '';
    switch (choice) {
      case '1':
        log.read('Запрос списка клиентов');
        _printClients(clients);
      case '2':
        _addClient(clients, log);
      case '3':
        _updateClient(clients, log);
      case '4':
        _deleteClient(clients, log);
      case '5':
        log.read('Запрос списка автомобилей');
        _printCars(cars);
      case '6':
        _addCar(cars, log);
      case '7':
        _updateCar(cars, log);
      case '8':
        _deleteCar(cars, log);
      case '9':
        log.read('Запрос списка менеджеров');
        _printManagers(managers);
      case '10':
        _addManager(managers, log);
      case '11':
        _updateManager(managers, log);
      case '12':
        _deleteManager(managers, log);
      case '13':
        log.read('Запрос списка тест-драйвов');
        _printTestDrives(testDrives);
      case '14':
        _addTestDrive(testDrives, clients, cars, managers, log);
      case '15':
        _deleteTestDrive(testDrives, log);
      case '16':
        log.read('Запрос списка заказов');
        _printOrders(orders);
      case '17':
        _addOrder(orders, clients, cars, managers, log);
      case '18':
        _deleteOrder(orders, log);
      case '19':
        log.read('Запрос всех данных из БД');
        _printAll(clients, cars, managers, testDrives, orders);
      case '20':
        await _runAsyncReport(log);
      case '0':
        log.exit_('Приложение завершено');
        stdout.writeln('До свидания.');
        return;
      default:
        log.error('Неизвестная команда: $choice');
        stdout.writeln('Неизвестная команда.');
    }
    stdout.writeln();
  }
}

Future<void> _runAsyncReport(AppLogger log) async {
  stdout.writeln('Отчёт генерируется...');
  log.report('Запущена генерация асинхронного отчёта');

  try {
    final r = await generateReportAsync();

    stdout.writeln(' ОТЧЁТ ПО BMW ДИЛЕРСКОМУ ЦЕНТРУ');
    stdout.writeln('   Клиентов:       ${r.clientCount.toString().padLeft(5)}');
    stdout.writeln('   Автомобилей:    ${r.carCount.toString().padLeft(5)}');
    stdout.writeln(
      '   Менеджеров:     ${r.managerCount.toString().padLeft(5)}',
    );
    stdout.writeln(
      '   Тест-драйвов:   ${r.testDriveCount.toString().padLeft(5)}',
    );
    stdout.writeln('   Заказов:        ${r.orderCount.toString().padLeft(5)}');
    stdout.writeln(
      '   Выручка:    ${r.totalRevenue.toStringAsFixed(2).padLeft(12)} ₽',
    );
    stdout.writeln(
      '   Средний чек: ${r.avgOrderPrice.toStringAsFixed(2).padLeft(11)} ₽',
    );
    if (r.topModel != null) {
      stdout.writeln('   Топ-модель:  ${r.topModel!.padRight(23)}');
    }
    if (r.topManager != null) {
      stdout.writeln('   Топ-менеджер: ${r.topManager!.padRight(22)}');
    }

    log.report(
      'Отчёт готов: клиентов=${r.clientCount}, авто=${r.carCount}, '
      'заказов=${r.orderCount}, выручка=${r.totalRevenue.toStringAsFixed(2)}',
    );
  } catch (e) {
    stdout.writeln('Ошибка генерации отчёта: $e');
    log.error('Ошибка асинхронного отчёта: $e');
  }
}

void _printClients(ClientRepository repo) {
  final list = repo.readAll();
  if (list.isEmpty) {
    stdout.writeln('Клиентов нет.');
    return;
  }
  for (final c in list) stdout.writeln('id: ${c.id} | ${c.name} | ${c.phone}');
}

void _addClient(ClientRepository repo, AppLogger log) {
  final id = readText('id клиента: ');
  final name = readText('имя: ');
  final phone = readText('телефон: ');
  repo.create(Client(id: id, name: name, phone: phone));
  stdout.writeln('Клиент добавлен.');
  log.add('Добавлен клиент id=$id, имя=$name');
}

void _updateClient(ClientRepository repo, AppLogger log) {
  final id = readRaw('id клиента для обновления: ');
  final name = readText('новое имя: ');
  final phone = readText('новый телефон: ');
  repo.update(Client(id: id, name: name, phone: phone));
  stdout.writeln('Клиент обновлён.');
  log.update('Обновлён клиент id=$id, имя=$name');
}

void _deleteClient(ClientRepository repo, AppLogger log) {
  final id = readRaw('id клиента для удаления: ');
  repo.delete(id);
  stdout.writeln('Готово.');
  log.delete('Удалён клиент id=$id');
}

void _printCars(CarRepository repo) {
  final list = repo.readAll();
  if (list.isEmpty) {
    stdout.writeln('Автомобилей нет.');
    return;
  }
  for (final c in list)
    stdout.writeln('id: ${c.id} | ${c.model} | ${c.year} | ${c.price} ₽');
}

void _addCar(CarRepository repo, AppLogger log) {
  final id = readText('id автомобиля: ');
  final model = readText('модель (например BMW X5): ');
  final price = readPositiveDouble('цена: ');
  final year = readPositiveInt('год выпуска: ');
  repo.create(Car(id: id, model: model, price: price, year: year));
  stdout.writeln('Автомобиль добавлен.');
  log.add('Добавлен автомобиль id=$id, модель=$model, год=$year, цена=$price');
}

void _updateCar(CarRepository repo, AppLogger log) {
  final id = readRaw('id автомобиля для обновления: ');
  final model = readText('новая модель: ');
  final price = readPositiveDouble('новая цена: ');
  final year = readPositiveInt('новый год выпуска: ');
  repo.update(Car(id: id, model: model, price: price, year: year));
  stdout.writeln('Автомобиль обновлён.');
  log.update('Обновлён автомобиль id=$id, модель=$model');
}

void _deleteCar(CarRepository repo, AppLogger log) {
  final id = readRaw('id автомобиля для удаления: ');
  repo.delete(id);
  stdout.writeln('Готово.');
  log.delete('Удалён автомобиль id=$id');
}

void _printManagers(ManagerRepository repo) {
  final list = repo.readAll();
  if (list.isEmpty) {
    stdout.writeln('Менеджеров нет.');
    return;
  }
  for (final m in list) stdout.writeln('id: ${m.id} | ${m.name} | ${m.phone}');
}

void _addManager(ManagerRepository repo, AppLogger log) {
  final id = readText('id менеджера: ');
  final name = readText('имя: ');
  final phone = readText('телефон: ');
  repo.create(Manager(id: id, name: name, phone: phone));
  stdout.writeln('Менеджер добавлен.');
  log.add('Добавлен менеджер id=$id, имя=$name');
}

void _updateManager(ManagerRepository repo, AppLogger log) {
  final id = readRaw('id менеджера для обновления: ');
  final name = readText('новое имя: ');
  final phone = readText('новый телефон: ');
  repo.update(Manager(id: id, name: name, phone: phone));
  stdout.writeln('Менеджер обновлён.');
  log.update('Обновлён менеджер id=$id, имя=$name');
}

void _deleteManager(ManagerRepository repo, AppLogger log) {
  final id = readRaw('id менеджера для удаления: ');
  repo.delete(id);
  stdout.writeln('Готово.');
  log.delete('Удалён менеджер id=$id');
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
  AppLogger log,
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
  log.add('Добавлен тест-драйв id=$id, клиент=$clientId, авто=$carId');
}

void _deleteTestDrive(TestDriveRepository repo, AppLogger log) {
  final id = readRaw('id тест-драйва для удаления: ');
  repo.delete(id);
  stdout.writeln('Готово.');
  log.delete('Удалён тест-драйв id=$id');
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
  AppLogger log,
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
  log.add(
    'Добавлен заказ id=$id, клиент=$clientId, авто=$carId, цена=$totalPrice',
  );
}

void _deleteOrder(OrderRepository repo, AppLogger log) {
  final id = readRaw('id заказа для удаления: ');
  repo.delete(id);
  stdout.writeln('Готово.');
  log.delete('Удалён заказ id=$id');
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
