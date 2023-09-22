import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_bloc_firebase/bloc/product/product_bloc.dart';
import 'package:qrcode_bloc_firebase/models/product_model.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode_bloc_firebase/routes/router.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProductBloc productBloc = context.read<ProductBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Products'),
      ),
      body: StreamBuilder<QuerySnapshot<ProductModel>>(
        stream: productBloc.streamProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text('Tidak ada data'),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error data'),
            );
          }

          List<ProductModel> allProducts = [];

          for (var element in snapshot.data!.docs) {
            allProducts.add(element.data());
          }

          if (allProducts.isEmpty) {
            return const Center(
              child: Text('Tidak ada data'),
            );
          }
          return ListView.builder(
            itemCount: allProducts.length,
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) {
              final product = allProducts[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                margin: const EdgeInsets.only(bottom: 20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    context.goNamed(
                      Routes.detailProduct,
                      pathParameters: {
                        'productId': product.productId!,
                      },
                      extra: product,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    height: 100,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.code!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(product.name!),
                              Text('Jumlah : ${product.qty}'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: QrImageView(
                            data: product.code!,
                            size: 200,
                            version: QrVersions.auto,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
