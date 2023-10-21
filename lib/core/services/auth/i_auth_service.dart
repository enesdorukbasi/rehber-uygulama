abstract class IAuthService {
  Future<dynamic?> login({required String email, required String password});
}
