import 'package:flutter/material.dart';
import 'package:qrcode_bloc_firebase/routes/router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.goNamed(Routes.login);
              },
              child: const Text('Login Page'),
            ),
            ElevatedButton(
              onPressed: () {
                context.goNamed(Routes.products);
              },
              child: const Text('Product Page'),
            ),
          ],
        ),
      ),
    );
  }
}
