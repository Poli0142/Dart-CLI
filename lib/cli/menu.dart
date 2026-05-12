import 'dart:io';
import 'dart:math';
import '../data/repositories/product_repository.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/order_repository.dart';
import '../data/repositories/role_repository.dart';
import '../domain/models/product.dart';
import '../domain/models/category.dart';
import '../domain/models/order.dart';
import '../domain/models/role.dart';
import 'input_helper.dart';
import 'display_helper.dart';

class Menu {
  final ProductRepository _productRepo = ProductRepository();
  final CategoryRepository _categoryRepo = CategoryRepository();
  final OrderRepository _orderRepo = OrderRepository();
  final RoleRepository _roleRepo = RoleRepository();
  final Random _random = Random();

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           _random.nextInt(10000).toString();
  }

  Future<void> run() async {
    while (true) {
      DisplayHelper.showHeader('МАГАЗИН ОДЕЖДЫ');
      print('1. Управление товарами');
      print('2. Управление категориями');
      print('3. Управление заказами');
      print('4. Управление ролями');
      print('5. Показать всё из БД');
      print('0. Выход');
      print('\nВыберите действие:');

      String choice = stdin.readLineSync() ?? '';

      switch (choice) {
        case '1':
          await _manageProducts();
          break;
        case '2':
          await _manageCategories();
          break;
        case '3':
          await _manageOrders();
          break;
        case '4':
          await _manageRoles();
          break;
        case '5':
          await _showAll();
          break;
        case '0':
          DisplayHelper.showInfo('До свидания!');
          return;
        default:
          DisplayHelper.showError('Неверный выбор');
      }
    }
  }

  Future<void> _manageProducts() async {
    while (true) {
      DisplayHelper.showHeader('УПРАВЛЕНИЕ ТОВАРАМИ');
      print('1. Добавить товар');
      print('2. Показать все товары');
      print('3. Найти товар по ID');
      print('4. Обновить товар');
      print('5. Удалить товар');
      print('0. Назад');
      print('\nВыберите действие:');

      String choice = stdin.readLineSync() ?? '';

      switch (choice) {
        case '1':
          await _addProduct();
          break;
        case '2':
          await _viewAllProducts();
          break;
        case '3':
          await _findProduct();
          break;
        case '4':
          await _updateProduct();
          break;
        case '5':
          await _deleteProduct();
          break;
        case '0':
          return;
        default:
          DisplayHelper.showError('Неверный выбор');
      }
    }
  }

  Future<void> _addProduct() async {
    DisplayHelper.showHeader('ДОБАВЛЕНИЕ ТОВАРА');
    
    String name = InputHelper.getRequiredInput('Название товара:', 'Название');
    double price = InputHelper.getPositiveDouble('Цена:', 'Цена');
    int quantity = InputHelper.getPositiveInt('Количество:', 'Количество');
    
    List<Category> categories = await _categoryRepo.getAllCategories();
    if (categories.isEmpty) {
      DisplayHelper.showError('Сначала добавьте категорию');
      return;
    }
    
    print('Доступные категории:');
    for (var cat in categories) {
      print('  ${cat.id} - ${cat.name}');
    }
    
    String categoryId = InputHelper.getRequiredInput('ID категории:', 'ID категории');
    String description = InputHelper.getInput('Описание (необязательно):');
    String size = InputHelper.getInput('Размер (необязательно):');

    Product product = Product(
      id: _generateId(),
      name: name,
      price: price,
      quantity: quantity,
      categoryId: categoryId,
      description: description,
      size: size,
    );

    await _productRepo.insertProduct(product);
    DisplayHelper.showSuccess('Товар добавлен с ID: ${product.id}');
  }

  Future<void> _viewAllProducts() async {
    List<Product> products = await _productRepo.getAllProducts();
    DisplayHelper.showHeader('ВСЕ ТОВАРЫ');
    if (products.isEmpty) {
      DisplayHelper.showInfo('Нет товаров');
    } else {
      for (var product in products) {
        print('ID: ${product.id}');
        print('Название: ${product.name}');
        print('Цена: ${product.price}₽');
        print('Количество: ${product.quantity}');
        print('Размер: ${product.size.isNotEmpty ? product.size : "не указан"}');
        print('---');
      }
    }
    print('\nНажмите Enter для продолжения...');
    stdin.readLineSync();
  }

  Future<void> _findProduct() async {
    String id = InputHelper.getRequiredInput('Введите ID товара:', 'ID');
    Product? product = await _productRepo.getProduct(id);
    DisplayHelper.showHeader('ИНФОРМАЦИЯ О ТОВАРЕ');
    if (product != null) {
      print('ID: ${product.id}');
      print('Название: ${product.name}');
      print('Цена: ${product.price}₽');
      print('Количество: ${product.quantity}');
      print('Описание: ${product.description}');
      print('Размер: ${product.size}');
    } else {
      DisplayHelper.showError('Товар не найден');
    }
    print('\nНажмите Enter для продолжения...');
    stdin.readLineSync();
  }

  Future<void> _updateProduct() async {
    String id = InputHelper.getRequiredInput('Введите ID товара для обновления:', 'ID');
    Product? existing = await _productRepo.getProduct(id);
    if (existing == null) {
      DisplayHelper.showError('Товар не найден');
      return;
    }

    DisplayHelper.showHeader('ОБНОВЛЕНИЕ ТОВАРА');
    String name = InputHelper.getRequiredInput('Новое название (${existing.name}):', 'Название');
    double price = InputHelper.getPositiveDouble('Новая цена (${existing.price}):', 'Цена');
    int quantity = InputHelper.getPositiveInt('Новое количество (${existing.quantity}):', 'Количество');
    String categoryId = InputHelper.getRequiredInput('Новый ID категории (${existing.categoryId}):', 'ID категории');
    String description = InputHelper.getInput('Новое описание (${existing.description}):');
    String size = InputHelper.getInput('Новый размер (${existing.size}):');

    Product updated = Product(
      id: id,
      name: name,
      price: price,
      quantity: quantity,
      categoryId: categoryId,
      description: description.isNotEmpty ? description : existing.description,
      size: size.isNotEmpty ? size : existing.size,
    );

    await _productRepo.updateProduct(updated);
    DisplayHelper.showSuccess('Товар обновлен');
  }

  Future<void> _deleteProduct() async {
    String id = InputHelper.getRequiredInput('Введите ID товара для удаления:', 'ID');
    await _productRepo.deleteProduct(id);
    DisplayHelper.showSuccess('Товар удален');
  }

  Future<void> _manageCategories() async {
    while (true) {
      DisplayHelper.showHeader('УПРАВЛЕНИЕ КАТЕГОРИЯМИ');
      print('1. Добавить категорию');
      print('2. Показать все категории');
      print('3. Найти категорию по ID');
      print('4. Обновить категорию');
      print('5. Удалить категорию');
      print('0. Назад');
      print('\nВыберите действие:');

      String choice = stdin.readLineSync() ?? '';

      switch (choice) {
        case '1':
          await _addCategory();
          break;
        case '2':
          await _viewAllCategories();
          break;
        case '3':
          await _findCategory();
          break;
        case '4':
          await _updateCategory();
          break;
        case '5':
          await _deleteCategory();
          break;
        case '0':
          return;
        default:
          DisplayHelper.showError('Неверный выбор');
      }
    }
  }

  Future<void> _addCategory() async {
    String name = InputHelper.getRequiredInput('Название категории:', 'Название');
    String description = InputHelper.getInput('Описание (необязательно):');

    Category category = Category(
      id: _generateId(),
      name: name,
      description: description,
    );

    await _categoryRepo.insertCategory(category);
    DisplayHelper.showSuccess('Категория добавлена с ID: ${category.id}');
  }

  Future<void> _viewAllCategories() async {
    List<Category> categories = await _categoryRepo.getAllCategories();
    DisplayHelper.showHeader('ВСЕ КАТЕГОРИИ');
    if (categories.isEmpty) {
      DisplayHelper.showInfo('Нет категорий');
    } else {
      for (var cat in categories) {
        print('ID: ${cat.id} - ${cat.name}');
        if (cat.description != null && cat.description!.isNotEmpty) {
          print('   Описание: ${cat.description}');
        }
      }
    }
    print('\nНажмите Enter для продолжения...');
    stdin.readLineSync();
  }

  Future<void> _findCategory() async {
    String id = InputHelper.getRequiredInput('Введите ID категории:', 'ID');
    Category? category = await _categoryRepo.getCategory(id);
    if (category != null) {
      print('ID: ${category.id}');
      print('Название: ${category.name}');
      print('Описание: ${category.description}');
    } else {
      DisplayHelper.showError('Категория не найдена');
    }
    print('\nНажмите Enter для продолжения...');
    stdin.readLineSync();
  }

  Future<void> _updateCategory() async {
    String id = InputHelper.getRequiredInput('Введите ID категории для обновления:', 'ID');
    Category? existing = await _categoryRepo.getCategory(id);
    if (existing == null) {
      DisplayHelper.showError('Категория не найдена');
      return;
    }

    String name = InputHelper.getRequiredInput('Новое название (${existing.name}):', 'Название');
    String description = InputHelper.getInput('Новое описание (${existing.description}):');

    Category updated = Category(
      id: id,
      name: name,
      description: description.isNotEmpty ? description : existing.description,
    );

    await _categoryRepo.updateCategory(updated);
    DisplayHelper.showSuccess('Категория обновлена');
  }

  Future<void> _deleteCategory() async {
    String id = InputHelper.getRequiredInput('Введите ID категории для удаления:', 'ID');
    try {
      await _categoryRepo.deleteCategory(id);
      DisplayHelper.showSuccess('Категория удалена');
    } catch (e) {
      DisplayHelper.showError(e.toString());
    }
  }

  Future<void> _manageOrders() async {
    while (true) {
      DisplayHelper.showHeader('УПРАВЛЕНИЕ ЗАКАЗАМИ');
      print('1. Создать заказ');
      print('2. Показать все заказы');
      print('3. Найти заказ по ID');
      print('4. Обновить заказ');
      print('5. Удалить заказ');
      print('0. Назад');
      print('\nВыберите действие:');

      String choice = stdin.readLineSync() ?? '';

      switch (choice) {
        case '1':
          await _addOrder();
          break;
        case '2':
          await _viewAllOrders();
          break;
        case '3':
          await _findOrder();
          break;
        case '4':
          await _updateOrder();
          break;
        case '5':
          await _deleteOrder();
          break;
        case '0':
          return;
        default:
          DisplayHelper.showError('Неверный выбор');
      }
    }
  }

  Future<void> _addOrder() async {
    DisplayHelper.showHeader('СОЗДАНИЕ ЗАКАЗА');
    
    List<Product> products = await _productRepo.getAllProducts();
    if (products.isEmpty) {
      DisplayHelper.showError('Нет доступных товаров');
      return;
    }
    
    print('Доступные товары:');
    for (var product in products) {
      print('  ${product.id} - ${product.name} (${product.price}₽, в наличии: ${product.quantity})');
    }
    
    String productId = InputHelper.getRequiredInput('ID товара:', 'ID товара');
    Product? product = await _productRepo.getProduct(productId);
    if (product == null) {
      DisplayHelper.showError('Товар не найден');
      return;
    }
    
    String customerName = InputHelper.getRequiredInput('Имя покупателя:', 'Имя');
    int quantity = InputHelper.getPositiveInt('Количество:', 'Количество');
    
    if (quantity > product.quantity) {
      DisplayHelper.showError('Недостаточно товара. Доступно: ${product.quantity}');
      return;
    }
    
    double totalPrice = product.price * quantity;
    DateTime orderDate = DateTime.now();
    
    Order order = Order(
      id: _generateId(),
      productId: productId,
      customerName: customerName,
      quantity: quantity,
      orderDate: orderDate,
      status: 'Новый',
      totalPrice: totalPrice,
    );
    
    Product updatedProduct = Product(
      id: product.id,
      name: product.name,
      price: product.price,
      quantity: product.quantity - quantity,
      categoryId: product.categoryId,
      description: product.description,
      size: product.size,
    );
    await _productRepo.updateProduct(updatedProduct);
    
    await _orderRepo.insertOrder(order);
    DisplayHelper.showSuccess('Заказ создан с ID: ${order.id} на сумму ${totalPrice}₽');
  }

  Future<void> _viewAllOrders() async {
    List<Order> orders = await _orderRepo.getAllOrders();
    DisplayHelper.showHeader('ВСЕ ЗАКАЗЫ');
    if (orders.isEmpty) {
      DisplayHelper.showInfo('Нет заказов');
    } else {
      for (var order in orders) {
        print('ID: ${order.id}');
        print('Покупатель: ${order.customerName}');
        print('Количество: ${order.quantity}');
        print('Сумма: ${order.totalPrice}₽');
        print('Статус: ${order.status}');
        print('Дата: ${order.orderDate.toLocal()}');
        print('---');
      }
    }
    print('\nНажмите Enter для продолжения...');
    stdin.readLineSync();
  }

  Future<void> _findOrder() async {
    String id = InputHelper.getRequiredInput('Введите ID заказа:', 'ID');
    Order? order = await _orderRepo.getOrder(id);
    if (order != null) {
      print('ID: ${order.id}');
      print('ID товара: ${order.productId}');
      print('Покупатель: ${order.customerName}');
      print('Количество: ${order.quantity}');
      print('Сумма: ${order.totalPrice}₽');
      print('Статус: ${order.status}');
      print('Дата: ${order.orderDate.toLocal()}');
    } else {
      DisplayHelper.showError('Заказ не найден');
    }
    print('\nНажмите Enter для продолжения...');
    stdin.readLineSync();
  }

  Future<void> _updateOrder() async {
    String id = InputHelper.getRequiredInput('Введите ID заказа для обновления:', 'ID');
    Order? existing = await _orderRepo.getOrder(id);
    if (existing == null) {
      DisplayHelper.showError('Заказ не найден');
      return;
    }

    String status = InputHelper.getRequiredInput('Новый статус (${existing.status}):', 'Статус');

    Order updated = Order(
      id: id,
      productId: existing.productId,
      customerName: existing.customerName,
      quantity: existing.quantity,
      orderDate: existing.orderDate,
      status: status,
      totalPrice: existing.totalPrice,
    );

    await _orderRepo.updateOrder(updated);
    DisplayHelper.showSuccess('Заказ обновлен');
  }

  Future<void> _deleteOrder() async {
    String id = InputHelper.getRequiredInput('Введите ID заказа для удаления:', 'ID');
    await _orderRepo.deleteOrder(id);
    DisplayHelper.showSuccess('Заказ удален');
  }

  Future<void> _manageRoles() async {
    while (true) {
      DisplayHelper.showHeader('УПРАВЛЕНИЕ РОЛЯМИ');
      print('1. Добавить роль');
      print('2. Показать все роли');
      print('3. Найти роль по ID');
      print('4. Обновить роль');
      print('5. Удалить роль');
      print('0. Назад');
      print('\nВыберите действие:');

      String choice = stdin.readLineSync() ?? '';

      switch (choice) {
        case '1':
          await _addRole();
          break;
        case '2':
          await _viewAllRoles();
          break;
        case '3':
          await _findRole();
          break;
        case '4':
          await _updateRole();
          break;
        case '5':
          await _deleteRole();
          break;
        case '0':
          return;
        default:
          DisplayHelper.showError('Неверный выбор');
      }
    }
  }

  Future<void> _addRole() async {
    String name = InputHelper.getRequiredInput('Название роли:', 'Название');
    String permissions = InputHelper.getRequiredInput('Права доступа (через запятую):', 'Права');

    Role role = Role(
      id: _generateId(),
      name: name,
      permissions: permissions,
    );

    await _roleRepo.insertRole(role);
    DisplayHelper.showSuccess('Роль добавлена с ID: ${role.id}');
  }

  Future<void> _viewAllRoles() async {
    List<Role> roles = await _roleRepo.getAllRoles();
    DisplayHelper.showHeader('ВСЕ РОЛИ');
    if (roles.isEmpty) {
      DisplayHelper.showInfo('Нет ролей');
    } else {
      for (var role in roles) {
        print('ID: ${role.id} - ${role.name}');
        print('   Права: ${role.permissions}');
      }
    }
    print('\nНажмите Enter для продолжения...');
    stdin.readLineSync();
  }

  Future<void> _findRole() async {
    String id = InputHelper.getRequiredInput('Введите ID роли:', 'ID');
    Role? role = await _roleRepo.getRole(id);
    if (role != null) {
      print('ID: ${role.id}');
      print('Название: ${role.name}');
      print('Права: ${role.permissions}');
    } else {
      DisplayHelper.showError('Роль не найдена');
    }
    print('\nНажмите Enter для продолжения...');
    stdin.readLineSync();
  }

  Future<void> _updateRole() async {
    String id = InputHelper.getRequiredInput('Введите ID роли для обновления:', 'ID');
    Role? existing = await _roleRepo.getRole(id);
    if (existing == null) {
      DisplayHelper.showError('Роль не найдена');
      return;
    }

    String name = InputHelper.getRequiredInput('Новое название (${existing.name}):', 'Название');
    String permissions = InputHelper.getRequiredInput('Новые права (${existing.permissions}):', 'Права');

    Role updated = Role(
      id: id,
      name: name,
      permissions: permissions,
    );

    await _roleRepo.updateRole(updated);
    DisplayHelper.showSuccess('Роль обновлена');
  }

  Future<void> _deleteRole() async {
    String id = InputHelper.getRequiredInput('Введите ID роли для удаления:', 'ID');
    await _roleRepo.deleteRole(id);
    DisplayHelper.showSuccess('Роль удалена');
  }

  Future<void> _showAll() async {
    DisplayHelper.showHeader('ВСЕ ДАННЫЕ ИЗ БАЗЫ ДАННЫХ');
    
    print('\nТОВАРЫ');
    List<Product> products = await _productRepo.getAllProducts();
    if (products.isEmpty) {
      print('  Нет товаров');
    } else {
      for (var product in products) {
        print('  ${product.id} | ${product.name} | ${product.price}₽ | ${product.quantity} шт.');
      }
    }
    
    print('\nКАТЕГОРИИ');
    List<Category> categories = await _categoryRepo.getAllCategories();
    if (categories.isEmpty) {
      print('  Нет категорий');
    } else {
      for (var category in categories) {
        print('  ${category.id} | ${category.name}');
      }
    }
    
    print('\nЗАКАЗЫ');
    List<Order> orders = await _orderRepo.getAllOrders();
    if (orders.isEmpty) {
      print('  Нет заказов');
    } else {
      for (var order in orders) {
        print('  ${order.id} | ${order.customerName} | ${order.totalPrice}₽ | ${order.status}');
      }
    }
    
    print('\nРОЛИ');
    List<Role> roles = await _roleRepo.getAllRoles();
    if (roles.isEmpty) {
      print('  Нет ролей');
    } else {
      for (var role in roles) {
        print('  ${role.id} | ${role.name} | ${role.permissions}');
      }
    }
    
    print('\nНажмите Enter для продолжения...');
    stdin.readLineSync();
  }
}