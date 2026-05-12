// вал. обяз. текстовое поле (не пустое после trim)
class RequiredStringValidator {
  static String? validate(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName не может быть пустым";
    }
    return null;
  }
}

// вал. числа больше 0
class PositiveNumberValidator {
  static String? validate(double? value, String fieldName) {
    if (value == null) {
      return "$fieldName обязательно";
    }
    if (value <= 0) {
      return "$fieldName должно быть больше 0";
    }
    return null;
  }
  
  static String? validateInt(int? value, String fieldName) {
    if (value == null) {
      return "$fieldName обязательно";
    }
    if (value <= 0) {
      return "$fieldName должно быть больше 0";
    }
    return null;
  }
}

// вал. даты
class DateValidator {
  static String? validate(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName не может быть пустым";
    }
    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return "$fieldName должен быть в формате ГГГГ-ММ-ДД";
    }
  }
}