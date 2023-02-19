import 'package:tocopedia/data/data_sources/user_remote_data_source.dart';
import 'package:tocopedia/data/data_sources/user_local_data_source.dart';
import 'package:tocopedia/data/models/address_model.dart';
import 'package:tocopedia/domains/entities/address.dart';

import 'package:tocopedia/domains/entities/user.dart';
import 'package:tocopedia/domains/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<User> updateUser(String token,
      {String? name, String? password, Address? defaultAddress}) async {
    try {
      final userModel = await remoteDataSource.updateUser(token,
          password: password,
          defaultAddress: defaultAddress != null
              ? AddressModel.fromEntity(defaultAddress)
              : null,
          name: name);
      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveUser(User user) async {
    final token = user.token!;

    try {
      await localDataSource.saveToken(token);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> autoLogin() async {
    try {
      final token = await localDataSource.retrieveToken();
      if (token == null) throw Exception("no user data");
      final user = await getUser(token);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> getUser(String token) async {
    try {
      final result = await remoteDataSource.getUser(token);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final result = await remoteDataSource.login(email, password);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> signUp(String email, String password, String name) async {
    try {
      final result = await remoteDataSource.signUp(email, password, name);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
