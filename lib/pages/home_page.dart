import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_bloc_firebase/bloc/auth/auth_bloc.dart';
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
              onTap = () {};
              break;
            case 2:
              title = 'QR Code';
              icon = Icons.qr_code;
              onTap = () {};
              break;
            case 3:
              title = 'Catalog';
              icon = Icons.document_scanner_rounded;
              onTap = () {};
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
                  SizedBox(
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
