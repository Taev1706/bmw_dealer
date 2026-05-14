String? validatePositiveNumber(String value) {
  final number = double.tryParse(value.replaceAll(',', '.'));
  if (number == null) return 'Введите корректное число';
  if (number <= 0) return 'Число должно быть больше 0';
  return null;
}
