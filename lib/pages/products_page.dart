import 'package:flutter/material.dart';
import 'package:qrcode_bloc_firebase/routes/router.dart';

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
              context.goNamed(
                Routes.detailProduct,
                pathParameters: {
                  'productId': '${index + 1}',
                },
              );
            },
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text('Product ${index + 1}'),
            subtitle: Text('Description product ${index + 1}'),
          );
        },
      ),
    );
  }
}
