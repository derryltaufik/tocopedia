import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tocopedia/presentation/pages/features/auth/auth_page.dart';
import 'package:tocopedia/presentation/pages/common_widgets/buyer_navigation_bar.dart';
import 'package:tocopedia/presentation/providers/cart_provider.dart';
import 'package:tocopedia/presentation/providers/order_provider.dart';
import 'package:tocopedia/presentation/providers/product_provider.dart';
import 'package:tocopedia/presentation/providers/user_provider.dart';

import 'package:tocopedia/injection.dart' as di;
import 'package:tocopedia/routing.dart';

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<UserProvider>(),
        ),
        ChangeNotifierProxyProvider<UserProvider, ProductProvider>(
          create: (_) => di.locator<ProductProvider>(),
          update: (_, value, __) =>
              di.locator<ProductProvider>(param1: value.user?.token),
        ),
        ChangeNotifierProxyProvider<UserProvider, CartProvider>(
          create: (_) => di.locator<CartProvider>(),
          update: (_, value, __) {
            final cartProvider =
                di.locator<CartProvider>(param1: value.user?.token);
            cartProvider.init(); //fetch cart immediately
            return cartProvider;
          },
        ),
        ChangeNotifierProxyProvider<UserProvider, OrderProvider>(
          create: (_) => di.locator<OrderProvider>(),
          update: (_, value, __) =>
              di.locator<OrderProvider>(param1: value.user?.token),
        ),
      ],
      child: Consumer<UserProvider>(builder: (context, userProvider, child) {
        final user = userProvider.user;
        print(user?.token);

        Widget currentWidget;

        if (user != null && user.token!.isNotEmpty) {
          currentWidget = BuyerNavBar();
        } else {
          currentWidget = AuthPage();
        }

        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.lightGreen,

            // colorSchemeSeed: const Color.fromRGBO(17, 164, 94, 1),
          ),
          home: currentWidget,
          onGenerateRoute: generateRoute,
        );
      }),
    );
  }
}
