import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../data/cart_store.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key, required this.username, required this.cartStore});

  final String username;
  final CartStore cartStore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang')),
      body: ValueListenableBuilder<Box<dynamic>>(
        valueListenable: cartStore.listenable(),
        builder: (context, box, child) {
          final items = cartStore.itemsFor(username);
          if (items.isEmpty) {
            return const Center(child: Text('Keranjang kamu masih kosong.'));
          }

          final total = items.fold<double>(
            0,
            (sum, item) => sum + item.price * item.quantity,
          );
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: SizedBox(
                          width: 58,
                          height: 58,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.thumbnail,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const ColoredBox(
                                    color: Color(0xFFE7ECE9),
                                    child: Icon(Icons.image_not_supported),
                                  ),
                            ),
                          ),
                        ),
                        title: Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '\$${item.price.toStringAsFixed(2)} × ${item.quantity}',
                        ),
                        trailing: IconButton(
                          tooltip: 'Hapus dari cart',
                          onPressed: () => cartStore.remove(item.key),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: Row(
                    children: [
                      const Text('Total'),
                      const Spacer(),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
