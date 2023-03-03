import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:tocopedia/data/data_sources/address_remote_data_source.dart';
import 'package:tocopedia/data/data_sources/cart_remote_data_source.dart';
import 'package:tocopedia/data/data_sources/category_remote_data_source.dart';
import 'package:tocopedia/data/data_sources/order_item_remote_data_source.dart';
import 'package:tocopedia/data/data_sources/order_remote_data_source.dart';
import 'package:tocopedia/data/data_sources/product_remote_data_source.dart';
import 'package:tocopedia/data/data_sources/remote_storage_service.dart';
import 'package:tocopedia/data/data_sources/user_local_data_source.dart';
import 'package:tocopedia/data/data_sources/user_remote_data_source.dart';
import 'package:tocopedia/data/data_sources/wishlist_remote_data_source.dart';
import 'package:tocopedia/data/repositories/address_repository_impl.dart';
import 'package:tocopedia/data/repositories/cart_repository_impl.dart';
import 'package:tocopedia/data/repositories/category_repository_impl.dart';
import 'package:tocopedia/data/repositories/order_item_repository_impl.dart';
import 'package:tocopedia/data/repositories/order_repository_impl.dart';
import 'package:tocopedia/data/repositories/product_repository_impl.dart';
import 'package:tocopedia/data/repositories/user_repository_impl.dart';
import 'package:tocopedia/data/repositories/wishlist_repository_impl.dart';
import 'package:tocopedia/domains/repositories/address_repository.dart';
import 'package:tocopedia/domains/repositories/cart_repository.dart';
import 'package:tocopedia/domains/repositories/category_repository.dart';
import 'package:tocopedia/domains/repositories/order_item_repository.dart';
import 'package:tocopedia/domains/repositories/order_repository.dart';
import 'package:tocopedia/domains/repositories/product_repository.dart';
import 'package:tocopedia/domains/repositories/user_repository.dart';
import 'package:tocopedia/domains/repositories/wishlist_repository.dart';
import 'package:tocopedia/domains/use_cases/address/add_address.dart';
import 'package:tocopedia/domains/use_cases/address/delete_address.dart';
import 'package:tocopedia/domains/use_cases/address/get_address.dart';
import 'package:tocopedia/domains/use_cases/address/get_user_addresses.dart';
import 'package:tocopedia/domains/use_cases/address/update_address.dart';
import 'package:tocopedia/domains/use_cases/cart/add_to_cart.dart';
import 'package:tocopedia/domains/use_cases/cart/clear_cart.dart';
import 'package:tocopedia/domains/use_cases/cart/get_cart.dart';
import 'package:tocopedia/domains/use_cases/cart/remove_from_cart.dart';
import 'package:tocopedia/domains/use_cases/cart/select_cart_item.dart';
import 'package:tocopedia/domains/use_cases/cart/select_seller.dart';
import 'package:tocopedia/domains/use_cases/cart/unselect_cart_item.dart';
import 'package:tocopedia/domains/use_cases/cart/unselect_seller.dart';
import 'package:tocopedia/domains/use_cases/cart/update_cart.dart';
import 'package:tocopedia/domains/use_cases/category/get_all_categories.dart';
import 'package:tocopedia/domains/use_cases/category/get_category.dart';
import 'package:tocopedia/domains/use_cases/order/cancel_order.dart';
import 'package:tocopedia/domains/use_cases/order/checkout.dart';
import 'package:tocopedia/domains/use_cases/order/get_order.dart';
import 'package:tocopedia/domains/use_cases/order/get_user_orders.dart';
import 'package:tocopedia/domains/use_cases/order/pay_order.dart';
import 'package:tocopedia/domains/use_cases/order_item/cancel_order_item.dart';
import 'package:tocopedia/domains/use_cases/order_item/complete_order_item.dart';
import 'package:tocopedia/domains/use_cases/order_item/get_buyer_order_items.dart';
import 'package:tocopedia/domains/use_cases/order_item/get_order_item.dart';
import 'package:tocopedia/domains/use_cases/order_item/get_seller_order_items.dart';
import 'package:tocopedia/domains/use_cases/order_item/process_order_item.dart';
import 'package:tocopedia/domains/use_cases/order_item/send_order_item.dart';
import 'package:tocopedia/domains/use_cases/product/add_product.dart';
import 'package:tocopedia/domains/use_cases/product/get_popular_products.dart';
import 'package:tocopedia/domains/use_cases/product/get_product.dart';
import 'package:tocopedia/domains/use_cases/product/search_product.dart';
import 'package:tocopedia/domains/use_cases/user/auto_login.dart';
import 'package:tocopedia/domains/use_cases/user/get_user.dart';
import 'package:tocopedia/domains/use_cases/user/login.dart';
import 'package:tocopedia/domains/use_cases/user/logout.dart';
import 'package:tocopedia/domains/use_cases/user/save_user.dart';
import 'package:tocopedia/domains/use_cases/user/sign_up.dart';
import 'package:tocopedia/domains/use_cases/user/update_user.dart';
import 'package:tocopedia/domains/use_cases/wishlist/add_wishlist.dart';
import 'package:tocopedia/domains/use_cases/wishlist/get_wishlist.dart';
import 'package:tocopedia/domains/use_cases/wishlist/remove_wishlist.dart';
import 'package:tocopedia/presentation/providers/address_provider.dart';
import 'package:tocopedia/presentation/providers/category_provider.dart';
import 'package:tocopedia/presentation/providers/cart_provider.dart';
import 'package:tocopedia/presentation/providers/order_item_provider.dart';
import 'package:tocopedia/presentation/providers/order_provider.dart';
import 'package:tocopedia/presentation/providers/product_provider.dart';
import 'package:tocopedia/presentation/providers/user_provider.dart';
import 'package:tocopedia/presentation/providers/wishlist_provider.dart';

final locator = GetIt.instance;

void init() {
  locator.registerLazySingleton<Client>(() => Client());

  locator.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<UserLocalDataSource>(
      () => UserLocalDataSourceImpl());
  locator.registerLazySingleton<CategoryRemoteDataSource>(
      () => CategoryRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<CartRemoteDataSource>(
      () => CartRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<OrderRemoteDataSource>(
      () => OrderRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<OrderItemRemoteDataSource>(
      () => OrderItemRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<AddressRemoteDataSource>(
      () => AddressRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<WishlistRemoteDataSource>(
      () => WishlistRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<RemoteStorageService>(
      () => RemoteStorageServiceImpl());

  locator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      remoteDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: locator(),
      remoteStorageService: locator(),
    ),
  );
  locator.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      remoteDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
      remoteDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<OrderItemRepository>(
    () => OrderItemRepositoryImpl(
      remoteDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(
      remoteDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<WishlistRepository>(
    () => WishlistRepositoryImpl(
      remoteDataSource: locator(),
    ),
  );

  locator.registerLazySingleton(() => SignUp(locator()));
  locator.registerLazySingleton(() => Login(locator()));
  locator.registerLazySingleton(() => Logout(locator()));
  locator.registerLazySingleton(() => SaveUser(locator()));
  locator.registerLazySingleton(() => GetUser(locator()));
  locator.registerLazySingleton(() => AutoLogin(locator()));
  locator.registerLazySingleton(() => UpdateUser(locator()));

  locator.registerLazySingleton(() => GetCategory(locator()));
  locator.registerLazySingleton(() => GetAllCategories(locator()));

  locator.registerLazySingleton(() => AddProduct(locator()));
  locator.registerLazySingleton(() => GetProduct(locator()));
  locator.registerLazySingleton(() => SearchProduct(locator()));
  locator.registerLazySingleton(() => GetPopularProducts(locator()));

  locator.registerLazySingleton(() => GetCart(locator()));
  locator.registerLazySingleton(() => AddToCart(locator()));
  locator.registerLazySingleton(() => RemoveFromCart(locator()));
  locator.registerLazySingleton(() => UpdateCart(locator()));
  locator.registerLazySingleton(() => SelectCartItem(locator()));
  locator.registerLazySingleton(() => UnselectCartItem(locator()));
  locator.registerLazySingleton(() => SelectSeller(locator()));
  locator.registerLazySingleton(() => UnselectSeller(locator()));
  locator.registerLazySingleton(() => ClearCart(locator()));

  locator.registerLazySingleton(() => GetOrder(locator()));
  locator.registerLazySingleton(() => GetUserOrders(locator()));
  locator.registerLazySingleton(() => Checkout(locator()));
  locator.registerLazySingleton(() => PayOrder(locator()));
  locator.registerLazySingleton(() => CancelOrder(locator()));

  locator.registerLazySingleton(() => GetBuyerOrderItems(locator()));
  locator.registerLazySingleton(() => GetSellerOrderItems(locator()));
  locator.registerLazySingleton(() => GetOrderItem(locator()));
  locator.registerLazySingleton(() => CancelOrderItem(locator()));
  locator.registerLazySingleton(() => ProcessOrderItem(locator()));
  locator.registerLazySingleton(() => SendOrderItem(locator()));
  locator.registerLazySingleton(() => CompleteOrderItem(locator()));

  locator.registerLazySingleton(() => AddAddress(locator()));
  locator.registerLazySingleton(() => UpdateAddress(locator()));
  locator.registerLazySingleton(() => GetUserAddresses(locator()));
  locator.registerLazySingleton(() => GetAddress(locator()));
  locator.registerLazySingleton(() => DeleteAddress(locator()));

  locator.registerLazySingleton(() => GetWishlist(locator()));
  locator.registerLazySingleton(() => AddWishlist(locator()));
  locator.registerLazySingleton(() => DeleteWishlist(locator()));

  locator.registerFactory(
    () => UserProvider(
      signUp: locator(),
      login: locator(),
      logout: locator(),
      saveUser: locator(),
      autoLogin: locator(),
      getUser: locator(),
      updateUser: locator(),
    ),
  );

  locator.registerFactory(
    () => CategoryProvider(
      getAllCategories: locator(),
      getCategory: locator(),
    ),
  );

  locator.registerFactoryParam(
    (String? param1, _) => ProductProvider(
      getProduct: locator(),
      searchProduct: locator(),
      getPopularProducts: locator(),
      addProduct: locator(),
      authToken: param1,
    ),
  );

  locator.registerFactoryParam(
    (String? param1, _) => CartProvider(
      addToCart: locator(),
      clearCart: locator(),
      getCart: locator(),
      removeFromCart: locator(),
      updateCart: locator(),
      selectCartItem: locator(),
      unselectCartItem: locator(),
      selectSeller: locator(),
      unselectSeller: locator(),
      getProduct: locator(),
      authToken: param1,
    ),
  );

  locator.registerFactoryParam(
    (String? param1, _) => OrderProvider(
      cancelOrder: locator(),
      checkout: locator(),
      getOrder: locator(),
      getUserOrders: locator(),
      payOrder: locator(),
      authToken: param1,
    ),
  );

  locator.registerFactoryParam(
    (String? param1, _) => OrderItemProvider(
      cancelOrderItem: locator(),
      completeOrderItem: locator(),
      getBuyerOrderItems: locator(),
      getOrderItem: locator(),
      getSellerOrderItems: locator(),
      processOrderItem: locator(),
      sendOrderItem: locator(),
      authToken: param1,
    ),
  );

  locator.registerFactoryParam(
    (String? param1, _) => AddressProvider(
      addAddress: locator(),
      deleteAddress: locator(),
      getAddress: locator(),
      getUserAddresses: locator(),
      updateAddress: locator(),
      authToken: param1,
    ),
  );

  locator.registerFactoryParam(
    (String? param1, _) => WishlistProvider(
      addWishlist: locator(),
      deleteWishlist: locator(),
      getWishlist: locator(),
      authToken: param1,
    ),
  );
}
