class DisplayHelper {
  static void showHeader(String title) {
    print(title);
  }

  static void showSuccess(String message) {
    print('Да $message');
  }

  static void showError(String message) {
    print('Нет $message');
  }

  static void showInfo(String message) {
    print('Ошибка $message');
  }
}