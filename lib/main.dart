import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/presentation/pages/common_widgets/seller_navigation_bar.dart';

import 'package:tocopedia/presentation/pages/features/auth/auth_page.dart';
import 'package:tocopedia/presentation/pages/common_widgets/buyer_navigation_bar.dart';
import 'package:tocopedia/presentation/providers/address_provider.dart';
import 'package:tocopedia/presentation/providers/category_provider.dart';
import 'package:tocopedia/presentation/providers/cart_provider.dart';
import 'package:tocopedia/presentation/providers/order_item_provider.dart';
import 'package:tocopedia/presentation/providers/order_provider.dart';
import 'package:tocopedia/presentation/providers/product_provider.dart';
import 'package:tocopedia/presentation/providers/user_provider.dart';
import 'package:tocopedia/presentation/providers/local_settings_provider.dart';

import 'package:tocopedia/injection.dart' as di;
import 'package:tocopedia/presentation/providers/wishlist_provider.dart';
import 'package:tocopedia/routing.dart';

//TODO https://stackoverflow.com/questions/55879550/how-to-fix-httpexception-connection-closed-before-full-header-was-received

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
        ChangeNotifierProvider(
          create: (_) => di.locator<CategoryProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocalSettingsProvider(),
        ),
        ChangeNotifierProxyProvider<UserProvider, ProductProvider>(
          create: (_) => di.locator<ProductProvider>(),
          update: (_, value, __) =>
              di.locator<ProductProvider>(param1: value.user?.token),
        ),
        ChangeNotifierProxyProvider<UserProvider, CartProvider>(
          create: (_) => di.locator<CartProvider>(),
          update: (_, value, previousCartProvider) {
            final cartProvider =
                di.locator<CartProvider>(param1: value.user?.token);
            cartProvider.cart = previousCartProvider?.cart;
            if (cartProvider.cart == null) {
              cartProvider.init(); //fetch cart immediately
            }
            return cartProvider;
          },
        ),
        ChangeNotifierProxyProvider<UserProvider, OrderProvider>(
          create: (_) => di.locator<OrderProvider>(),
          update: (_, value, __) =>
              di.locator<OrderProvider>(param1: value.user?.token),
        ),
        ChangeNotifierProxyProvider<UserProvider, WishlistProvider>(
          create: (_) => di.locator<WishlistProvider>(),
          update: (_, value, __) =>
              di.locator<WishlistProvider>(param1: value.user?.token),
        ),
        ChangeNotifierProxyProvider<UserProvider, OrderItemProvider>(
          create: (_) => di.locator<OrderItemProvider>(),
          update: (_, value, __) =>
              di.locator<OrderItemProvider>(param1: value.user?.token),
        ),
        ChangeNotifierProxyProvider<UserProvider, AddressProvider>(
          create: (_) => di.locator<AddressProvider>(),
          update: (_, value, previousAddressProvider) =>
              di.locator<AddressProvider>(param1: value.user?.token)
                ..addressesList = previousAddressProvider?.addressesList,
        ),
      ],
      child: Consumer2<UserProvider, LocalSettingsProvider>(
          builder: (context, userProvider, localSettingsProvider, child) {
        final user = userProvider.user;
        print(localSettingsProvider.appMode);

        Widget currentWidget;

        if (user != null && user.token!.isNotEmpty) {
          if (localSettingsProvider.appMode == AppMode.buyer) {
            currentWidget = BuyerNavBar();
          } else {
            currentWidget = SellerNavBar();
          }
        } else {
          currentWidget = AuthPage();
        }

        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.lightGreen,
            ),
            // colorSchemeSeed: Colors.lightGreen,

            // colorSchemeSeed: const Color.fromRGBO(17, 164, 94, 1),
          ),
          home: currentWidget,
          onGenerateRoute: generateRoute,
        );
      }),
    );
  }
}
