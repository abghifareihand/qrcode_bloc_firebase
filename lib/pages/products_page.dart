import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products Page'),
      ),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              context.go('/products/${index + 1}');
            },
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text('Product ${index + 1}'),
          );
        },
      ),
    );
  }
}
