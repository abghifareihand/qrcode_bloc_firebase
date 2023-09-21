import 'package:flutter/material.dart';
import 'package:qrcode_bloc_firebase/routes/router.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
              ),
              onPressed: () {
                context.goNamed(Routes.home);
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
