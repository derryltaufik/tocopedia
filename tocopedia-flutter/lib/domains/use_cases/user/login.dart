import 'package:tocopedia/domains/entities/user.dart';
import 'package:tocopedia/domains/repositories/user_repository.dart';

class Login {
  final UserRepository repository;

  Login(this.repository);

  Future<User> execute(String email, String password) {
    return repository.login(email, password);
  }
}
