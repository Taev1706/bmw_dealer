# BMW Дилерский центр

CLI-приложение на Dart для управления данными BMW дилерского центра.

## Предметная область

BMW дилерский центр — система для учёта клиентов, автомобилей, менеджеров, тест-драйвов и заказов.

## Структура папок

```
bmw_dealer/
├── pubspec.yaml
├── bin/
│   └── main.dart             # Только запуск: создаёт BmwDatabase и вызывает runMenu()
├── lib/
│   └── bmw_dealer.dart       # Экспорт всех публичных частей
│   └── src/
│       ├── domain/
│       │   ├── models/       # Сущности: Client, Car, Manager, TestDrive, Order, Identity
│       │   └── validators/   # Валидаторы: text_validator.dart, number_validator.dart
│       ├── data/
│       │   ├── database.dart          # Открытие SQLite, создание таблиц
│       │   └── repositories/          # CRUD: client_repository.dart и т.д.
│       └── cli/
│           ├── menu.dart              # Главное меню, switch-case, вызов репозиториев
│           └── input_helper.dart      # Ввод с валидацией и повторным запросом
└── test/
    ├── domain_test.dart       # Тесты моделей (toMap / fromMap)
    ├── data_test.dart         # Тесты репозиториев (CRUD через SQLite в памяти)
    └── validation_test.dart   # Тесты валидаторов
```

## Что вынесено в каждый слой и почему

### domain
Модели (Client, Car, Manager, TestDrive, Order) с методами toMap() / fromMap() и чистые функции-валидаторы. Никакого SQL и stdin. Вынесено сюда, чтобы ядро приложения можно было тестировать независимо от базы данных и интерфейса.

### data
Открытие SQLite, создание таблиц и репозитории с CRUD-операциями. Импортирует domain, но не cli. Вынесено сюда, чтобы при смене способа хранения данных менять только этот слой.

### cli
Меню, ввод и вывод. Импортирует domain и data, но не содержит SQL и бизнес-логики. Вынесено сюда, чтобы при смене интерфейса (например на веб) domain и data остались нетронутыми.

## Сущности

| Сущность  | Поля                                         |
|-----------|----------------------------------------------|
| Client    | id, name, phone                              |
| Car       | id, model, price, year                       |
| Manager   | id, name, phone                              |
| TestDrive | id, clientId, carId, managerId, time         |
| Order     | id, clientId, carId, managerId, totalPrice   |

## Валидации

1. **Текстовое поле** (`text_validator.dart`) — строка не пустая после `trim()`. Используется для имён, телефонов, моделей.
2. **Числовое поле** (`number_validator.dart`) — число корректно парсится и больше 0. Используется для цены и года.

Оба валидатора вызываются в `input_helper.dart` с повторным запросом при ошибке.

## Перечень тестов

### domain_test.dart — тесты моделей
- `Client toMap / fromMap` — проверка сериализации и восстановления клиента
- `Car toMap / fromMap` — проверка сериализации и восстановления автомобиля
- `Manager fromMap` — восстановление менеджера из Map
- `TestDrive toMap / fromMap` — корректное сохранение и парсинг DateTime
- `Order toMap` — корректное сохранение цены

### data_test.dart — тесты репозиториев
- `ClientRepository` — create, readAll, readById, update, delete
- `CarRepository` — create, readAll, readById, update, delete
- `ManagerRepository` — create, readAll, delete
- `TestDriveRepository` — create, readAll, delete
- `OrderRepository` — create, readAll, delete

### validation_test.dart — тесты валидаторов
- `validateText` — пустая строка, строка из пробелов, нормальная строка
- `validatePositiveNumber` — отрицательное, ноль, не число, положительное, с запятой
