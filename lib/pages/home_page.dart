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
      body: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthStateLogout) {
              context.goNamed(Routes.login);
            }
          },
          builder: (context, state) {
            if (state is AuthStateLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.redAccent,
                ),
              );
            }
            if (state is AuthStateError) {
              return Text(state.message);
            }
            return Column(
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
            );
          },
        ),
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
