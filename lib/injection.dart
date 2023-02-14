import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:tocopedia/data/data_sources/cart_remote_data_source.dart';
import 'package:tocopedia/data/data_sources/product_remote_data_source.dart';
import 'package:tocopedia/data/data_sources/user_local_data_source.dart';
import 'package:tocopedia/data/data_sources/user_remote_data_source.dart';
import 'package:tocopedia/data/repositories/cart_repository_impl.dart';
import 'package:tocopedia/data/repositories/product_repository_impl.dart';
import 'package:tocopedia/data/repositories/user_repository_impl.dart';
import 'package:tocopedia/domains/repositories/cart_repository.dart';
import 'package:tocopedia/domains/repositories/product_repository.dart';
import 'package:tocopedia/domains/repositories/user_repository.dart';
import 'package:tocopedia/domains/use_cases/cart/add_to_cart.dart';
import 'package:tocopedia/domains/use_cases/cart/clear_cart.dart';
import 'package:tocopedia/domains/use_cases/cart/get_cart.dart';
import 'package:tocopedia/domains/use_cases/cart/remove_from_cart.dart';
import 'package:tocopedia/domains/use_cases/cart/update_cart.dart';
import 'package:tocopedia/domains/use_cases/product/get_product.dart';
import 'package:tocopedia/domains/use_cases/product/search_product.dart';
import 'package:tocopedia/domains/use_cases/user/auto_login.dart';
import 'package:tocopedia/domains/use_cases/user/get_user.dart';
import 'package:tocopedia/domains/use_cases/user/login.dart';
import 'package:tocopedia/domains/use_cases/user/save_user.dart';
import 'package:tocopedia/domains/use_cases/user/sign_up.dart';
import 'package:tocopedia/domains/use_cases/user/update_user.dart';
import 'package:tocopedia/presentation/providers/cart_provider.dart';
import 'package:tocopedia/presentation/providers/product_provider.dart';
import 'package:tocopedia/presentation/providers/user_provider.dart';

final locator = GetIt.instance;

void init() {
  locator.registerLazySingleton<Client>(() => Client());

  locator.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<UserLocalDataSource>(
      () => UserLocalDataSourceImpl());
  locator.registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<CartRemoteDataSource>(
      () => CartRemoteDataSourceImpl(client: locator()));

  locator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      remoteDataSource: locator(),
    ),
  );

  locator.registerLazySingleton(() => SignUp(locator()));
  locator.registerLazySingleton(() => Login(locator()));
  locator.registerLazySingleton(() => SaveUser(locator()));
  locator.registerLazySingleton(() => GetUser(locator()));
  locator.registerLazySingleton(() => AutoLogin(locator()));
  locator.registerLazySingleton(() => UpdateUser(locator()));

  locator.registerLazySingleton(() => GetProduct(locator()));
  locator.registerLazySingleton(() => SearchProduct(locator()));

  locator.registerLazySingleton(() => GetCart(locator()));
  locator.registerLazySingleton(() => AddToCart(locator()));
  locator.registerLazySingleton(() => RemoveFromCart(locator()));
  locator.registerLazySingleton(() => UpdateCart(locator()));
  locator.registerLazySingleton(() => ClearCart(locator()));

  locator.registerFactory(
    () => UserProvider(
      signUp: locator(),
      login: locator(),
      saveUser: locator(),
      autoLogin: locator(),
      getUser: locator(),
      updateUser: locator(),
    ),
  );
  locator.registerFactoryParam(
    (String? param1, _) => ProductProvider(
      getProduct: locator(),
      searchProduct: locator(),
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
      getProduct: locator(),
      authToken: param1,
    ),
  );
}
