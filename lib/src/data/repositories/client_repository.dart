import '../database.dart';
import '../../domain/models/client.dart';

class ClientRepository {
  final BmwDatabase db;

  ClientRepository(this.db);

  void create(Client client) {
    db.sqlite.execute(
      'INSERT OR REPLACE INTO clients(id, name, phone) VALUES(?, ?, ?)',
      [client.id, client.name, client.phone],
    );
  }

  List<Client> readAll() {
    final rows = db.sqlite.select('SELECT id, name, phone FROM clients');
    return rows.map((row) => Client.fromMap(row)).toList();
  }

  Client? readById(String id) {
    final rows = db.sqlite.select(
      'SELECT id, name, phone FROM clients WHERE id = ?',
      [id],
    );
    return rows.isNotEmpty ? Client.fromMap(rows.first) : null;
  }

  void update(Client client) {
    db.sqlite.execute(
      'UPDATE clients SET name = ?, phone = ? WHERE id = ?',
      [client.name, client.phone, client.id],
    );
  }

  void delete(String id) {
    db.sqlite.execute('DELETE FROM clients WHERE id = ?', [id]);
  }
}
