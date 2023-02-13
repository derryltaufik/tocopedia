import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:tocopedia/data/data_sources/product_remote_data_source.dart';
import 'package:tocopedia/data/data_sources/user_local_data_source.dart';
import 'package:tocopedia/data/data_sources/user_remote_data_source.dart';
import 'package:tocopedia/data/repositories/product_repository_impl.dart';
import 'package:tocopedia/data/repositories/user_repository_impl.dart';
import 'package:tocopedia/domains/repositories/product_repository.dart';
import 'package:tocopedia/domains/repositories/user_repository.dart';
import 'package:tocopedia/domains/use_cases/product/get_product.dart';
import 'package:tocopedia/domains/use_cases/product/search_product.dart';
import 'package:tocopedia/domains/use_cases/user/auto_login.dart';
import 'package:tocopedia/domains/use_cases/user/get_user.dart';
import 'package:tocopedia/domains/use_cases/user/login.dart';
import 'package:tocopedia/domains/use_cases/user/save_user.dart';
import 'package:tocopedia/domains/use_cases/user/sign_up.dart';
import 'package:tocopedia/domains/use_cases/user/update_user.dart';
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

  locator.registerLazySingleton(() => SignUp(locator()));
  locator.registerLazySingleton(() => Login(locator()));
  locator.registerLazySingleton(() => SaveUser(locator()));
  locator.registerLazySingleton(() => GetUser(locator()));
  locator.registerLazySingleton(() => AutoLogin(locator()));
  locator.registerLazySingleton(() => UpdateUser(locator()));

  locator.registerLazySingleton(() => GetProduct(locator()));
  locator.registerLazySingleton(() => SearchProduct(locator()));

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
  locator.registerFactory(
    () => ProductProvider(
      getProduct: locator(),
      searchProduct: locator(),
    ),
  );
}
