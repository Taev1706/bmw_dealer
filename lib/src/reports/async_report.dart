import 'dart:isolate';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

class _ReportRequest {
  final SendPort replyPort;
  final String dbPath;
  _ReportRequest(this.replyPort, this.dbPath);
}

class ReportResult {
  final int clientCount;
  final int carCount;
  final int managerCount;
  final int testDriveCount;
  final int orderCount;
  final double totalRevenue;
  final double avgOrderPrice;
  final String? topModel;
  final String? topManager;

  const ReportResult({
    required this.clientCount,
    required this.carCount,
    required this.managerCount,
    required this.testDriveCount,
    required this.orderCount,
    required this.totalRevenue,
    required this.avgOrderPrice,
    this.topModel,
    this.topManager,
  });
}

void _reportIsolateEntry(_ReportRequest req) {
  try {
    final db = sqlite3.open(req.dbPath, mode: OpenMode.readOnly);

    int count(String table) =>
        (db.select('SELECT COUNT(*) AS c FROM $table').first['c'] as int?) ?? 0;

    final clients = count('clients');
    final cars = count('cars');
    final managers = count('managers');
    final testDrives = count('test_drives');
    final orders = count('orders');

    final revenueRow = db
        .select(
          'SELECT COALESCE(SUM(totalPrice),0) AS s, COALESCE(AVG(totalPrice),0) AS a FROM orders',
        )
        .first;
    final totalRevenue = (revenueRow['s'] as num).toDouble();
    final avgPrice = (revenueRow['a'] as num).toDouble();

    String? topModel;
    final topModelRows = db.select(
      'SELECT c.model, COUNT(*) AS cnt '
      'FROM orders o JOIN cars c ON c.id = o.carId '
      'GROUP BY c.model ORDER BY cnt DESC LIMIT 1',
    );
    if (topModelRows.isNotEmpty)
      topModel = topModelRows.first['model'] as String?;

    String? topManager;
    final topMgrRows = db.select(
      'SELECT m.name, COUNT(*) AS cnt '
      'FROM orders o JOIN managers m ON m.id = o.managerId '
      'GROUP BY m.name ORDER BY cnt DESC LIMIT 1',
    );
    if (topMgrRows.isNotEmpty) topManager = topMgrRows.first['name'] as String?;

    db.dispose();

    req.replyPort.send(
      ReportResult(
        clientCount: clients,
        carCount: cars,
        managerCount: managers,
        testDriveCount: testDrives,
        orderCount: orders,
        totalRevenue: totalRevenue,
        avgOrderPrice: avgPrice,
        topModel: topModel,
        topManager: topManager,
      ),
    );
  } catch (e) {
    req.replyPort.send('ERROR: $e');
  }
}

Future<ReportResult> generateReportAsync() async {
  final dbPath = p.join(Directory.current.path, 'bmw.db');
  final receivePort = ReceivePort();

  await Isolate.spawn(
    _reportIsolateEntry,
    _ReportRequest(receivePort.sendPort, dbPath),
  );

  final result = await receivePort.first;
  receivePort.close();

  if (result is ReportResult) return result;
  throw Exception(result.toString());
}
