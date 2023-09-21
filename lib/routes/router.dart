import 'package:go_router/go_router.dart';
import 'package:qrcode_bloc_firebase/pages/detail_page.dart';
import 'package:qrcode_bloc_firebase/pages/error_page.dart';
import 'package:qrcode_bloc_firebase/pages/home_page.dart';
import 'package:qrcode_bloc_firebase/pages/login_page.dart';
import 'package:qrcode_bloc_firebase/pages/products_page.dart';

// GoRouter configuration
final router = GoRouter(
  errorBuilder: (context, state) => const ErrorPage(),
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'products',
          builder: (context, state) => const ProductsPage(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) => DetailPage(
                id: state.pathParameters['id'].toString(),
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
  ],
);
