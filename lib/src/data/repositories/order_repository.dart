import '../database.dart';
import '../../domain/models/order.dart';

class OrderRepository {
  final BmwDatabase db;

  OrderRepository(this.db);

  void create(Order order) {
    db.sqlite.execute(
      'INSERT OR REPLACE INTO orders(id, clientId, carId, managerId, totalPrice) VALUES(?, ?, ?, ?, ?)',
      [order.id, order.clientId, order.carId, order.managerId, order.totalPrice],
    );
  }

  List<Order> readAll() {
    final rows = db.sqlite.select(
      'SELECT id, clientId, carId, managerId, totalPrice FROM orders',
    );
    return rows.map((row) => Order.fromMap(row)).toList();
  }

  Order? readById(String id) {
    final rows = db.sqlite.select(
      'SELECT id, clientId, carId, managerId, totalPrice FROM orders WHERE id = ?',
      [id],
    );
    return rows.isNotEmpty ? Order.fromMap(rows.first) : null;
  }

  void delete(String id) {
    db.sqlite.execute('DELETE FROM orders WHERE id = ?', [id]);
  }
}
