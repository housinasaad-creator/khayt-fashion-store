import 'package:flutter_test/flutter_test.dart';
import 'package:khayt_store/data/products.dart';

void main() {
  test('catalogue is consistent', () {
    final ids = kProducts.map((p) => p.id).toSet();
    expect(ids.length, kProducts.length, reason: 'product ids must be unique');
    for (final p in kProducts) {
      expect(p.price, greaterThan(0));
      expect(productById(p.id), isNotNull);
    }
  });
}
