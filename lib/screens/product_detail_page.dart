import 'package:flutter/material.dart';

import '../data/cart_store.dart';
import '../models/product.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    super.key,
    required this.product,
    required this.username,
    required this.cartStore,
  });

  final Product product;
  final String username;
  final CartStore cartStore;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;
  bool _isAdding = false;

  Future<void> _addToCart() async {
    setState(() => _isAdding = true);
    try {
      await widget.cartStore.add(
        username: widget.username,
        product: widget.product,
        quantity: _quantity,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil ditambahkan ke cart.')),
      );
    } finally {
      if (mounted) setState(() => _isAdding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final images = product.images.isEmpty
        ? [product.thumbnail]
        : product.images;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          SizedBox(
            height: 260,
            child: PageView(
              children: images
                  .map(
                    (url) => ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const ColoredBox(
                              color: Color(0xFFE7ECE9),
                              child: Icon(Icons.image_not_supported_outlined),
                            ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            product.title,
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text('${product.category}  ·  ${product.brand}'),
          const SizedBox(height: 10),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(product.rating.toStringAsFixed(1)),
              const SizedBox(width: 12),
              Text('${product.stock} tersedia'),
              if (product.discountPercentage > 0) ...[
                const SizedBox(width: 12),
                Text('${product.discountPercentage}% diskon'),
              ],
            ],
          ),
          const SizedBox(height: 20),
          _InfoSection(title: 'Deskripsi', child: Text(product.description)),
          _InfoSection(
            title: 'Informasi Produk',
            child: Column(
              children: [
                _InfoRow(label: 'SKU', value: product.sku),
                _InfoRow(label: 'Merek', value: product.brand),
                _InfoRow(label: 'Garansi', value: product.warrantyInformation),
                _InfoRow(
                  label: 'Pengiriman',
                  value: product.shippingInformation,
                ),
                _InfoRow(label: 'Pengembalian', value: product.returnPolicy),
                _InfoRow(
                  label: 'Tag',
                  value: product.tags.isEmpty ? '-' : product.tags.join(', '),
                ),
              ],
            ),
          ),
          _InfoSection(
            title: 'Ulasan (${product.reviews.length})',
            child: product.reviews.isEmpty
                ? const Text('Belum ada ulasan.')
                : Column(
                    children: product.reviews
                        .map(
                          (review) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(review.reviewerName),
                            subtitle: Text(review.comment),
                            trailing: Text('★ ${review.rating}'),
                          ),
                        )
                        .toList(),
                  ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Jumlah'),
              const Spacer(),
              IconButton(
                onPressed: _quantity > 1
                    ? () => setState(() => _quantity--)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text(
                '$_quantity',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                onPressed: _quantity < product.stock
                    ? () => setState(() => _quantity++)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          FilledButton.icon(
            onPressed: product.stock < 1 || _isAdding ? null : _addToCart,
            icon: _isAdding
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add_shopping_cart),
            label: Text(product.stock < 1 ? 'Stok habis' : 'Add to Cart'),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
