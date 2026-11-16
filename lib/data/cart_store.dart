import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/product.dart';

class CartStore {
  const CartStore(this._box);

  final Box<dynamic> _box;

  ValueListenable<Box<dynamic>> listenable() => _box.listenable();

  List<CartItem> itemsFor(String username) {
    return _box
        .toMap()
        .entries
        .where(
          (entry) =>
              entry.value is Map &&
              (entry.value as Map)['username'] == username,
        )
        .map(
          (entry) => CartItem.fromRecord(
            entry.key as String,
            Map<String, dynamic>.from(entry.value as Map),
          ),
        )
        .toList();
  }

  Future<void> add({
    required String username,
    required Product product,
    required int quantity,
  }) async {
    if (quantity < 1 || quantity > product.stock) {
      throw ArgumentError.value(quantity, 'quantity', 'Jumlah di luar stok.');
    }

    final key = jsonEncode([username, product.id]);
    final previous = _box.get(key);
    final previousQuantity = previous is Map
        ? (previous['quantity'] as int? ?? 0)
        : 0;
    final totalQuantity = (previousQuantity + quantity).clamp(0, product.stock);
    await _box.put(key, {
      'username': username,
      'productId': product.id,
      'title': product.title,
      'price': product.price,
      'thumbnail': product.thumbnail,
      'stock': product.stock,
      'quantity': totalQuantity,
    });
  }

  Future<void> remove(String key) => _box.delete(key);
}

class CartItem {
  const CartItem({
    required this.key,
    required this.productId,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.stock,
    required this.quantity,
  });

  final String key;
  final int productId;
  final String title;
  final double price;
  final String thumbnail;
  final int stock;
  final int quantity;

  factory CartItem.fromRecord(String key, Map<String, dynamic> record) {
    return CartItem(
      key: key,
      productId: record['productId'] as int? ?? 0,
      title: record['title'] as String? ?? 'Produk',
      price: (record['price'] as num? ?? 0).toDouble(),
      thumbnail: record['thumbnail'] as String? ?? '',
      stock: record['stock'] as int? ?? 0,
      quantity: record['quantity'] as int? ?? 0,
    );
  }
}
