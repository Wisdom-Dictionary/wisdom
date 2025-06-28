import 'package:wisdom/data/model/login_response.dart';
import 'package:wisdom/data/model/verify_model.dart';

abstract class AuthRepository {
  Future<bool> login(String phone);

  Future<VerifyModel?> verify(String phoneNumber, String smsCode);

  Future<bool> applyFirebase(String token);

  Future<LoginResponse?> loginWithApple(String oAuthToken, String deviceId);

  Future<LoginResponse?> loginWithGoogle(String oAuthToken, String deviceId);

  Future<LoginResponse?> loginWithFacebook(String oAuthToken, String deviceId);
}
