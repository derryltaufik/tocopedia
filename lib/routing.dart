import 'package:flutter/material.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/domains/entities/review.dart';
import 'package:tocopedia/presentation/helper_variables/search_arguments.dart';
import 'package:tocopedia/presentation/pages/common_widgets/images/images_gallery_page.dart';
import 'package:tocopedia/presentation/pages/features/address/add_address_page.dart';
import 'package:tocopedia/presentation/pages/features/address/edit_address_page.dart';
import 'package:tocopedia/presentation/pages/features/address/view_all_addresses_page.dart';
import 'package:tocopedia/presentation/pages/features/auth/auth_page.dart';
import 'package:tocopedia/presentation/pages/features/cart/cart_page.dart';
import 'package:tocopedia/presentation/pages/features/cart/checkout_page.dart';
import 'package:tocopedia/presentation/pages/features/home/home_page.dart';
import 'package:tocopedia/presentation/pages/features/order/view_all_orders_page.dart';
import 'package:tocopedia/presentation/pages/features/order/view_order_page.dart';
import 'package:tocopedia/presentation/pages/features/product/search_product_page.dart';
import 'package:tocopedia/presentation/pages/features/product/view_product_page.dart';
import 'package:tocopedia/presentation/pages/features/review/add_review_page.dart';
import 'package:tocopedia/presentation/pages/features/review/edit_review_page.dart';
import 'package:tocopedia/presentation/pages/features/review/product_reviews_page.dart';
import 'package:tocopedia/presentation/pages/features/review/view_review_page.dart';
import 'package:tocopedia/presentation/pages/features/user/edit_user_page.dart';
import 'package:tocopedia/presentation/pages/features/user/user_page.dart';
import 'package:tocopedia/presentation/pages/features/transaction/view_order_item_page.dart';
import 'package:tocopedia/presentation/pages/features/seller_product/seller_add_product_page.dart';
import 'package:tocopedia/presentation/pages/features/seller_product/seller_edit_product_page.dart';

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
    case AddAddressPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const AddAddressPage(),
      );
    case EditAddressPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) {
          EditAddressPageArguments arguments =
              routeSettings.arguments as EditAddressPageArguments;

          return EditAddressPage(
            address: arguments.address,
            isDefault: arguments.isDefault,
          );
        },
      );
    case SearchProductPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => SearchProductPage(
            searchArguments: routeSettings.arguments as SearchArguments),
      );
    case SellerAddProductPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const SellerAddProductPage(),
      );
    case SellerEditProductPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) =>
            SellerEditProductPage(product: routeSettings.arguments as Product),
      );
    case ViewProductPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) =>
            ViewProductPage(productId: routeSettings.arguments as String),
      );
    case ProductReviewsPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) =>
            ProductReviewsPage(product: routeSettings.arguments as Product),
      );
    case AddReviewPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) {
          AddReviewPageArguments arguments =
              routeSettings.arguments as AddReviewPageArguments;

          return AddReviewPage(
            review: arguments.review,
            initialRating: arguments.initialRating,
          );
        },
      );
    case EditReviewPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) =>
            EditReviewPage(review: routeSettings.arguments as Review),
      );

    case ViewReviewPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) =>
            ViewReviewPage(reviewId: routeSettings.arguments as String),
      );
    case CartPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const CartPage(),
      );
    case CheckoutPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const CheckoutPage(),
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
        builder: (context) => const ViewAllOrdersPage(),
      );

    case ViewOrderItemPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) =>
            ViewOrderItemPage(orderItemId: routeSettings.arguments as String),
      );
    case ImagesGalleryPage.routeName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) {
            final ImagesGalleryPageArguments args =
                routeSettings.arguments as ImagesGalleryPageArguments;
            return ImagesGalleryPage(
              images: args.images,
              startingIndex: args.startingIndex ?? 0,
            );
          });
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
