import 'package:tocopedia/domains/entities/address.dart';
import 'package:tocopedia/domains/entities/user.dart';
import 'package:tocopedia/domains/repositories/user_repository.dart';

class UpdateUser {
  final UserRepository repository;

  UpdateUser(this.repository);

  Future<User> execute(String token,
      {String? name, String? password, Address? defaultAddress}) {
    return repository.updateUser(token,
        password: password, defaultAddress: defaultAddress, name: name);
  }
}
