import '../models/user_model.dart';
import '../repositories/guard_repository.dart';

class GuardService {
  final GuardRepository guardRepository;

  GuardService({required this.guardRepository});

  Future<List<UserModel>> getGuardList() async {
    try {
      return await guardRepository.fetchGuards();
    } catch (e) {
      // Handle errors appropriately in your app
      rethrow;
    }
  }
}
