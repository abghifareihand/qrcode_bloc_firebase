import 'package:go_router/go_router.dart';
import 'package:qrcode_bloc_firebase/pages/detail_product_page.dart';
import 'package:qrcode_bloc_firebase/pages/error_page.dart';
import 'package:qrcode_bloc_firebase/pages/home_page.dart';
import 'package:qrcode_bloc_firebase/pages/login_page.dart';
import 'package:qrcode_bloc_firebase/pages/products_page.dart';

export 'package:go_router/go_router.dart';
part 'route_name.dart';

final router = GoRouter(
  errorBuilder: (context, state) => const ErrorPage(),
  routes: [
    GoRoute(
      path: '/',
      name: Routes.home,
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'products',
          name: Routes.products,
          builder: (context, state) => const ProductsPage(),
          routes: [
            GoRoute(
              path: ':productId',
              name: Routes.detailProduct,
              builder: (context, state) => DetailProductPage(
                id: state.pathParameters['productId'].toString(),
                data: state.pathParameters,

                // Add the missing argument here
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      name: Routes.login,
      builder: (context, state) => const LoginPage(),
    ),
  ],
);
