import 'package:flutter/material.dart';
import 'package:flutter_catalog_example/features/catalog/reposity/catalog_reposity.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'common/theme.dart';
import 'features/cart/presentation/cart_screen.dart';
import 'features/cart/service/cart_model.dart';
import 'features/catalog/screen/catalog_screen.dart';
import 'features/login/presentation/login_screen.dart';

void main() {
  runApp(const MyApp());
}

GoRouter router() {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/catalog',
        builder: (context, state) => const CatalogScreen(),
        routes: [
          GoRoute(
            path: 'cart',
            builder: (context, state) => const CartScreen(),
          ),
        ],
      ),
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => CatalogReposity()),
        //因為cartModel 依賴CatalogReposity
        ChangeNotifierProxyProvider<CatalogReposity, CartModel>(
          create: (context) => CartModel(),
          update: (context, catalog, cart) {
            if (cart == null) throw ArgumentError.notNull('cart');
            cart.catalog = catalog;
            return cart;
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'Provider Demo',
        theme: appTheme,
        routerConfig: router(),
      ),
    );
  }
}
