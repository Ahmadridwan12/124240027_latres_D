import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nim_latres_d/data/cart_store.dart';
import 'package:nim_latres_d/models/product.dart';

void main() {
  late Directory directory;
  late Box<dynamic> box;
  late CartStore cartStore;

  setUpAll(() async {
    directory = await Directory.systemTemp.createTemp('latres-cart-test');
    Hive.init(directory.path);
    box = await Hive.openBox<dynamic>('cart-test');
    cartStore = CartStore(box);
  });

  setUp(() async {
    await box.clear();
  });

  tearDownAll(() async {
    await box.close();
    await Hive.close();
    await directory.delete(recursive: true);
  });

  test('cart items are isolated by username', () async {
    final product = _product(stock: 5);
    await cartStore.add(username: 'alice', product: product, quantity: 2);
    await cartStore.add(username: 'bob', product: product, quantity: 1);

    expect(cartStore.itemsFor('alice').single.quantity, 2);
    expect(cartStore.itemsFor('bob').single.quantity, 1);
  });

  test('repeated additions cannot exceed product stock', () async {
    final product = _product(stock: 3);
    await cartStore.add(username: 'alice', product: product, quantity: 2);
    await cartStore.add(username: 'alice', product: product, quantity: 2);

    expect(cartStore.itemsFor('alice').single.quantity, 3);
  });

  test('rejects a selected quantity outside the stock limit', () async {
    expect(
      () => cartStore.add(
        username: 'alice',
        product: _product(stock: 2),
        quantity: 3,
      ),
      throwsArgumentError,
    );
  });
}

Product _product({required int stock}) {
  return Product(
    id: 42,
    title: 'Produk Uji',
    description: '',
    category: 'test',
    price: 10,
    discountPercentage: 0,
    rating: 5,
    stock: stock,
    brand: 'Tes',
    sku: 'TEST-42',
    warrantyInformation: '-',
    shippingInformation: '-',
    returnPolicy: '-',
    thumbnail: '',
    images: const [],
    tags: const [],
    reviews: const [],
  );
}
