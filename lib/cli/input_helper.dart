import 'dart:io';
import '../domain/validators/validators.dart';

class InputHelper {
  static String getInput(String prompt) {
    print(prompt);
    return stdin.readLineSync() ?? '';
  }

  static String getRequiredInput(String prompt, String fieldName) {
    while (true) {
      String input = getInput(prompt);
      String? error = RequiredStringValidator.validate(input, fieldName);
      if (error == null) {
        return input.trim();
      }
      print('Ошибка: $error');
    }
  }

  static double getPositiveDouble(String prompt, String fieldName) {
    while (true) {
      String input = getInput(prompt);
      try {
        double value = double.parse(input);
        String? error = PositiveNumberValidator.validate(value, fieldName);
        if (error == null) {
          return value;
        }
        print('Ошибка: $error');
      } catch (e) {
        print('Ошибка: Введите число');
      }
    }
  }

  static int getPositiveInt(String prompt, String fieldName) {
    while (true) {
      String input = getInput(prompt);
      try {
        int value = int.parse(input);
        if (value > 0) {
          return value;
        }
        print('Ошибка: $fieldName должно быть больше 0');
      } catch (e) {
        print('Ошибка: Введите целое число');
      }
    }
  }

  static DateTime getDate(String prompt) {
    while (true) {
      String input = getInput(prompt);
      String? error = DateValidator.validate(input, 'Дата');
      if (error == null) {
        return DateTime.parse(input);
      }
      print('Ошибка: $error');
    }
  }
}