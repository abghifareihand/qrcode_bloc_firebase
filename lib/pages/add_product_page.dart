import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_bloc_firebase/bloc/product/product_bloc.dart';
import 'package:qrcode_bloc_firebase/routes/router.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: codeController,
            keyboardType: TextInputType.number,
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
              labelText: 'Product Name',
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
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Product Qty',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (codeController.text.length == 5) {
                context.read<ProductBloc>().add(
                      AddProductEvent(
                        code: codeController.text,
                        name: nameController.text,
                        qty: int.parse(qtyController.text),
                      ),
                    );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Code product wajib 5 karakter'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductLoaded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Success add product'),
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
                    state is ProductLoading ? 'Loading...' : 'Add Product');
              },
            ),
          ),
        ],
      ),
    );
  }
}
