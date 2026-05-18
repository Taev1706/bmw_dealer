import 'dart:io';
import 'package:bmw_dealer/bmw_dealer.dart';

void main(List<String> arguments) {
  Process.runSync('chcp', ['65001'], runInShell: true);
  final db = BmwDatabase.inApp();
  try {
    runMenu(db);
  } finally {
    db.close();
  }
}
