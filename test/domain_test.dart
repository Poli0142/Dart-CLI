import 'package:test/test.dart';
import 'package:clothing_store/src/domain/models/product.dart';
import 'package:clothing_store/src/domain/models/category.dart';

void main() {
  group('Product Model Tests', () {
    test('Product toMap and fromMap', () {
      final product = Product(
        id: 'p1',
        name: 'Футболка',
        price: 999.99,
        quantity: 10,
        categoryId: 'c1',
        description: 'Хлопковая футболка',
        size: 'M',
      );
      
      final map = product.toMap();
      final restored = Product.fromMap(map);
      
      expect(restored.id, 'p1');
      expect(restored.name, 'Футболка');
      expect(restored.price, 999.99);
      expect(restored.quantity, 10);
    });
  });
  
  group('Category Model Tests', () {
    test('Category toMap and fromMap', () {
      final category = Category(
        id: 'c1',
        name: 'Одежда',
        description: 'Верхняя одежда',
      );
      
      final map = category.toMap();
      final restored = Category.fromMap(map);
      
      expect(restored.id, 'c1');
      expect(restored.name, 'Одежда');
    });
  });
}