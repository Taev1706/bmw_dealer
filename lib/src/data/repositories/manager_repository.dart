import '../database.dart';
import '../../domain/models/manager.dart';

class ManagerRepository {
  final BmwDatabase db;

  ManagerRepository(this.db);

  void create(Manager manager) {
    db.sqlite.execute(
      'INSERT OR REPLACE INTO managers(id, name, phone) VALUES(?, ?, ?)',
      [manager.id, manager.name, manager.phone],
    );
  }

  List<Manager> readAll() {
    final rows = db.sqlite.select('SELECT id, name, phone FROM managers');
    return rows.map((row) => Manager.fromMap(row)).toList();
  }

  Manager? readById(String id) {
    final rows = db.sqlite.select(
      'SELECT id, name, phone FROM managers WHERE id = ?',
      [id],
    );
    return rows.isNotEmpty ? Manager.fromMap(rows.first) : null;
  }

  void update(Manager manager) {
    db.sqlite.execute(
      'UPDATE managers SET name = ?, phone = ? WHERE id = ?',
      [manager.name, manager.phone, manager.id],
    );
  }

  void delete(String id) {
    db.sqlite.execute('DELETE FROM managers WHERE id = ?', [id]);
  }
}
