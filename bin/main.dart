import 'package:bmw_dealer/bmw_dealer.dart';

void main(List<String> arguments) {
  final db = BmwDatabase.inApp();
  try {
    runMenu(db);
  } finally {
    db.close();
  }
}
