import 'package:tocopedia/domains/repositories/user_repository.dart';

class Logout {
  final UserRepository repository;

  Logout(this.repository);

  Future<void> execute() {
    return repository.logout();
  }
}
