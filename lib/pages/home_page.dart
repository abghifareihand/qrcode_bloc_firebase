import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_bloc_firebase/bloc/auth/auth_bloc.dart';
import 'package:qrcode_bloc_firebase/bloc/product/product_bloc.dart';
import 'package:qrcode_bloc_firebase/routes/router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          late String title;
          late IconData icon;
          late VoidCallback onTap;

          switch (index) {
            case 0:
              title = 'Add Product';
              icon = Icons.post_add_rounded;
              onTap = () => context.goNamed(Routes.addProduct);
              break;
            case 1:
              title = 'List Product';
              icon = Icons.list_alt_rounded;
              onTap = () => context.goNamed(Routes.products);
              break;
            case 2:
              title = 'QR Code';
              icon = Icons.qr_code;
              onTap = () async {
                String barcode = await FlutterBarcodeScanner.scanBarcode(
                  "#000000",
                  "CANCEL",
                  true,
                  ScanMode.QR,
                );

                print(barcode);
              };
              break;
            case 3:
              title = 'Print PDF';
              icon = Icons.document_scanner_rounded;
              onTap = () {
                context.read<ProductBloc>().add(ExportProductEvent());
              };
              break;
            default:
          }
          return Material(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (index == 3)
                      ? BlocConsumer<ProductBloc, ProductState>(
                          listener: (context, state) {},
                          builder: (context, state) {
                            if (state is ProductLoadingExport) {
                              return const CircularProgressIndicator();
                            }
                            return SizedBox(
                              height: 50,
                              width: 50,
                              child: Icon(
                                icon,
                                size: 50,
                              ),
                            );
                          },
                        )
                      : SizedBox(
                          height: 50,
                          width: 50,
                          child: Icon(
                            icon,
                            size: 50,
                          ),
                        ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(title),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AuthBloc>().add(AuthEventLogout());
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
