import '../database.dart';
import '../../domain/models/car.dart';

class CarRepository {
  final BmwDatabase db;

  CarRepository(this.db);

  void create(Car car) {
    db.sqlite.execute(
      'INSERT OR REPLACE INTO cars(id, model, price, year) VALUES(?, ?, ?, ?)',
      [car.id, car.model, car.price, car.year],
    );
  }

  List<Car> readAll() {
    final rows = db.sqlite.select('SELECT id, model, price, year FROM cars');
    return rows.map((row) => Car.fromMap(row)).toList();
  }

  Car? readById(String id) {
    final rows = db.sqlite.select(
      'SELECT id, model, price, year FROM cars WHERE id = ?',
      [id],
    );
    return rows.isNotEmpty ? Car.fromMap(rows.first) : null;
  }

  void update(Car car) {
    db.sqlite.execute(
      'UPDATE cars SET model = ?, price = ?, year = ? WHERE id = ?',
      [car.model, car.price, car.year, car.id],
    );
  }

  void delete(String id) {
    db.sqlite.execute('DELETE FROM cars WHERE id = ?', [id]);
  }
}
