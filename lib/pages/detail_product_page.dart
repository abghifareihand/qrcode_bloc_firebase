import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode_bloc_firebase/bloc/product/product_bloc.dart';
import 'package:qrcode_bloc_firebase/models/product_model.dart';
import 'package:qrcode_bloc_firebase/routes/router.dart';

class DetailProductPage extends StatelessWidget {
  final String id;
  final ProductModel product;
  DetailProductPage(
    this.id,
    this.product, {
    super.key,
  });

  final TextEditingController codeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    codeController.text = product.code!;
    nameController.text = product.name!;
    qtyController.text = product.qty!.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: QrImageView(
                  data: product.code!,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30.0,
          ),
          TextFormField(
            controller: codeController,
            keyboardType: TextInputType.number,
            readOnly: true,
            maxLength: 5,
            decoration: InputDecoration(
              labelText: 'Product Code',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: qtyController,
            decoration: InputDecoration(
              labelText: 'Quantity',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),

          /// Update product
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              context.read<ProductBloc>().add(
                    UpdateProductEvent(
                      productId: product.productId!,
                      name: nameController.text,
                      qty: int.parse(qtyController.text),
                    ),
                  );
            },
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductLoadedUpdate) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Success update product'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.blueAccent,
                    ),
                  );
                  context.pop();
                }
                if (state is ProductError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Text(
                    state is ProductLoadingUpdate ? 'Loading...' : 'Update Product');
              },
            ),
          ),

          /// Delete product
          TextButton(
            onPressed: () {
              context
                  .read<ProductBloc>()
                  .add(DeleteProductEvent(id: product.productId!));
            },
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductLoadedDelete) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Success delete product'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.blueAccent,
                    ),
                  );
                  context.pop();
                }
                if (state is ProductError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Text(
                  state is ProductLoadingDelete ? 'Loading...' : 'Delete Product',
                  style: const TextStyle(
                    color: Colors.redAccent,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
