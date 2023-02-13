import 'package:flutter/material.dart';
import 'package:tocopedia/presentation/pages/features/auth/auth_page.dart';
import 'package:tocopedia/presentation/pages/features/home/home_page.dart';
import 'package:tocopedia/presentation/pages/features/product/search_product_page.dart';
import 'package:tocopedia/presentation/pages/features/product/view_product_page.dart';
import 'package:tocopedia/presentation/pages/features/user/edit_user_page.dart';
import 'package:tocopedia/presentation/pages/features/user/user_page.dart';

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
    // case AddProductPage.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (context) => const AddProductPage(),
    //   );
    // case CategoryPage.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (context) =>
    //         CategoryPage(category: routeSettings.arguments as String),
    //   );
    case SearchProductPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) =>
            SearchProductPage(searchQuery: routeSettings.arguments as String),
      );
    case ViewProductPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) =>
            ViewProductPage(productId: routeSettings.arguments as String),
      );
    // case ProductDetailsPage.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (context) =>
    //         ProductDetailsPage(product: routeSettings.arguments as Product),
    //   );
    // case CartPage.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (context) => const CartPage(),
    //   );
    // case AddressPage.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (context) =>
    //         AddressPage(totalAmount: routeSettings.arguments as double),
    //   );
    // case OrderDetailsPage.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (context) =>
    //         OrderDetailsPage(order: routeSettings.arguments as Order),
    //   );
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
