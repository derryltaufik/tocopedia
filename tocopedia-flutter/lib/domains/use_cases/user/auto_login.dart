import 'package:tocopedia/domains/entities/user.dart';
import 'package:tocopedia/domains/repositories/user_repository.dart';

class AutoLogin {
  final UserRepository repository;

  AutoLogin(this.repository);

  Future<User> execute() {
    return repository.autoLogin();
  }
}
