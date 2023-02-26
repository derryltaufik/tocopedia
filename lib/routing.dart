import 'package:flutter/material.dart';
import 'package:tocopedia/presentation/helper_variables/search_arguments.dart';
import 'package:tocopedia/presentation/pages/features/address/view_all_addresses_page.dart';
import 'package:tocopedia/presentation/pages/features/auth/auth_page.dart';
import 'package:tocopedia/presentation/pages/features/cart/cart_page.dart';
import 'package:tocopedia/presentation/pages/features/cart/checkout_page.dart';
import 'package:tocopedia/presentation/pages/features/home/home_page.dart';
import 'package:tocopedia/presentation/pages/features/order/view_all_orders_page.dart';
import 'package:tocopedia/presentation/pages/features/order/view_order_page.dart';
import 'package:tocopedia/presentation/pages/features/product/search_product_page.dart';
import 'package:tocopedia/presentation/pages/features/product/view_product_page.dart';
import 'package:tocopedia/presentation/pages/features/user/edit_user_page.dart';
import 'package:tocopedia/presentation/pages/features/user/user_page.dart';
import 'package:tocopedia/presentation/pages/features/transaction/view_order_item_page.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const AuthPage(),
      );
    case HomePage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const HomePage(),
      );
    case UserPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const UserPage(),
      );
    case EditUserPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const EditUserPage(),
      );
    case ViewAllAddressesPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const ViewAllAddressesPage(),
      );
    case SearchProductPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => SearchProductPage(
            searchArguments: routeSettings.arguments as SearchArguments),
      );
    case ViewProductPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) =>
            ViewProductPage(productId: routeSettings.arguments as String),
      );
    case CartPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => CartPage(),
      );
    case CheckoutPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => CheckoutPage(),
      );
    case ViewOrderPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) =>
            ViewOrderPage(orderId: routeSettings.arguments as String),
      );
    case ViewAllOrdersPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => ViewAllOrdersPage(),
      );

    case ViewOrderItemPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) =>
            ViewOrderItemPage(orderItemId: routeSettings.arguments as String),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: Text("Invalid Route"),
          ),
        ),
      );
  }
}
