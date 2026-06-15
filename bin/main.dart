import 'dart:io';
import 'package:bmw_dealer/bmw_dealer.dart';

Future<void> main(List<String> arguments) async {
  Process.runSync('chcp', ['65001'], runInShell: true);

  await AppLogger.init();

  final db = BmwDatabase.inApp();
  try {
    await runMenuAsync(db);
  } finally {
    db.close();
    await AppLogger().close();
  }
}
