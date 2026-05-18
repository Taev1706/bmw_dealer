import 'dart:convert';
import 'dart:io';

import '../domain/validators/text_validator.dart';
import '../domain/validators/number_validator.dart';

String readText(String label) {
  while (true) {
    stdout.write(label);
    final value = stdin.readLineSync(encoding: utf8)?.trim() ?? '';
    final error = validateText(value);
    if (error == null) return value;
    stdout.writeln('Ошибка: $error');
  }
}

double readPositiveDouble(String label) {
  while (true) {
    stdout.write(label);
    final value = stdin.readLineSync(encoding: utf8)?.trim() ?? '';
    final error = validatePositiveNumber(value);
    if (error == null) return double.parse(value.replaceAll(',', '.'));
    stdout.writeln('Ошибка: $error');
  }
}

int readPositiveInt(String label) {
  while (true) {
    stdout.write(label);
    final value = stdin.readLineSync(encoding: utf8)?.trim() ?? '';
    final number = int.tryParse(value);
    if (number != null && number > 0) return number;
    stdout.writeln('Ошибка: введите целое число больше 0');
  }
}

DateTime readDateTime(String label) {
  while (true) {
    stdout.write(label);
    final value = stdin.readLineSync(encoding: utf8)?.trim() ?? '';
    try {
      return DateTime.parse(value);
    } catch (_) {
      stdout.writeln('Ошибка: введите дату в формате 2026-05-07T14:30:00');
    }
  }
}

String readRaw(String label) {
  stdout.write(label);
  return stdin.readLineSync(encoding: utf8)?.trim() ?? '';
}
