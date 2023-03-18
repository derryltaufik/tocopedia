import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
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
import 'package:tocopedia/presentation/providers/review_provider.dart';
import 'package:tocopedia/presentation/providers/user_provider.dart';
import 'package:tocopedia/presentation/providers/local_settings_provider.dart';

import 'package:tocopedia/injection.dart' as di;
import 'package:tocopedia/presentation/providers/wishlist_provider.dart';
import 'package:tocopedia/routing.dart';

// TODO flutter web refresh page causing null check failed -> use suitable routing solution for web https://github.com/flutter/flutter/issues/59277
// TODO change cloud file storage to S3 https://aws.amazon.com/blogs/compute/uploading-to-amazon-s3-directly-from-a-web-or-mobile-application/
// TODO enable avatar for user & seller
// TODO use dartz Either for exception handling if necessary
// TODO implement shimmer loading for better UX
// TODO implement lazy loading (front end) & pagination (backend)
// TODO https://stackoverflow.com/questions/55879550/how-to-fix-httpexception-connection-closed-before-full-header-was-received

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
        ChangeNotifierProxyProvider<UserProvider, ReviewProvider>(
          create: (_) => di.locator<ReviewProvider>(),
          update: (_, value, previousAddressProvider) =>
              di.locator<ReviewProvider>(param1: value.user?.token),
        ),
      ],
      child: Consumer2<UserProvider, LocalSettingsProvider>(
          builder: (context, userProvider, localSettingsProvider, child) {
        final user = userProvider.user;
        Widget currentWidget;
        final isLoggedIn =
            user != null && user.token != null && user.token!.isNotEmpty;

        if (localSettingsProvider.appMode == AppMode.buyer) {
          if (isLoggedIn) {
            currentWidget = const BuyerNavBar();
          } else {
            currentWidget = const AuthPage();
          }
        } else if (localSettingsProvider.appMode == AppMode.guest) {
          currentWidget = const BuyerNavBar();
        } else if (localSettingsProvider.appMode == AppMode.seller) {
          if (isLoggedIn) {
            currentWidget = const SellerNavBar();
          } else {
            currentWidget = const AuthPage();
          }
        } else {
          currentWidget = const BuyerNavBar();
        }

        return FlutterWebFrame(
          builder: (context) => MaterialApp(
            title: 'Tocopedia',
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
          ),
          maximumSize: const Size(475.0, 812.0),
          enabled: kIsWeb,
          backgroundColor: Colors.grey,
        );
      }),
    );
  }
}
