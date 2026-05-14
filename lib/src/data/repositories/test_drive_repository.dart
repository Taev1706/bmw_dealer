import '../database.dart';
import '../../domain/models/test_drive.dart';

class TestDriveRepository {
  final BmwDatabase db;

  TestDriveRepository(this.db);

  void create(TestDrive testDrive) {
    db.sqlite.execute(
      'INSERT OR REPLACE INTO test_drives(id, clientId, carId, managerId, time) VALUES(?, ?, ?, ?, ?)',
      [
        testDrive.id,
        testDrive.clientId,
        testDrive.carId,
        testDrive.managerId,
        testDrive.time.toIso8601String(),
      ],
    );
  }

  List<TestDrive> readAll() {
    final rows = db.sqlite.select(
      'SELECT id, clientId, carId, managerId, time FROM test_drives',
    );
    return rows.map((row) => TestDrive.fromMap(row)).toList();
  }

  TestDrive? readById(String id) {
    final rows = db.sqlite.select(
      'SELECT id, clientId, carId, managerId, time FROM test_drives WHERE id = ?',
      [id],
    );
    return rows.isNotEmpty ? TestDrive.fromMap(rows.first) : null;
  }

  void delete(String id) {
    db.sqlite.execute('DELETE FROM test_drives WHERE id = ?', [id]);
  }
}
