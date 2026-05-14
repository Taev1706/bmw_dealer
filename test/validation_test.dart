import 'package:test/test.dart';
import 'package:bmw_dealer/bmw_dealer.dart';

void main() {
  group('validateText', () {
    test('пустая строка — ошибка', () {
      expect(validateText(''), isNotNull);
    });

    test('строка из пробелов — ошибка', () {
      expect(validateText('   '), isNotNull);
    });

    test('нормальная строка — null (ок)', () {
      expect(validateText('BMW'), isNull);
    });
  });

  group('validatePositiveNumber', () {
    test('отрицательное число — ошибка', () {
      expect(validatePositiveNumber('-100'), isNotNull);
    });

    test('ноль — ошибка', () {
      expect(validatePositiveNumber('0'), isNotNull);
    });

    test('не число — ошибка', () {
      expect(validatePositiveNumber('abc'), isNotNull);
    });

    test('положительное число — null (ок)', () {
      expect(validatePositiveNumber('5000000'), isNull);
    });

    test('число с запятой — null (ок)', () {
      expect(validatePositiveNumber('1500,50'), isNull);
    });
  });
}
