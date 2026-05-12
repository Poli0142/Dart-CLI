import 'package:test/test.dart';
import 'package:clothing_store/src/domain/validators/validators.dart';

void main() {
  group('RequiredStringValidator Tests', () {
    test('Valid string', () {
      expect(RequiredStringValidator.validate('Hello', 'Field'), null);
    });
    
    test('Empty string', () {
      expect(RequiredStringValidator.validate('', 'Field'), isNotNull);
    });
    
    test('Whitespace only', () {
      expect(RequiredStringValidator.validate('   ', 'Field'), isNotNull);
    });
    
    test('Null value', () {
      expect(RequiredStringValidator.validate(null, 'Field'), isNotNull);
    });
  });
  
  group('PositiveNumberValidator Tests', () {
    test('Positive double', () {
      expect(PositiveNumberValidator.validate(10.5, 'Price'), null);
    });
    
    test('Zero double', () {
      expect(PositiveNumberValidator.validate(0, 'Price'), isNotNull);
    });
    
    test('Negative double', () {
      expect(PositiveNumberValidator.validate(-5, 'Price'), isNotNull);
    });
    
    test('Positive int', () {
      expect(PositiveNumberValidator.validateInt(10, 'Quantity'), null);
    });
    
    test('Zero int', () {
      expect(PositiveNumberValidator.validateInt(0, 'Quantity'), isNotNull);
    });
  });
}