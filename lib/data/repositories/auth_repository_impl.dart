import 'dart:convert';
import 'dart:developer';

import 'package:jbaza/jbaza.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:wisdom/core/services/custom_client.dart';
import 'package:wisdom/data/model/login_response.dart';
import 'package:wisdom/data/model/verify_model.dart';

import '../../config/constants/urls.dart';
import '../../core/services/dio_client.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final CustomClient client;
  final DioClient _dioClient;

  AuthRepositoryImpl(this.client, this._dioClient);

  @override
  Future<bool> login(String phone) async {
    var response = await _dioClient.post(
      Urls.login.path,
      data: {'phone': phone},
    );
    if (response.isSuccessful) {
      return jsonDecode(response.data)['status'];
    }
    return false;
  }

  @override
  Future<LoginResponse?> loginWithApple(String oAuthToken, String deviceId) async {
    final response = await _dioClient.post(
      Urls.loginSocial.path,
      data: {
        "provider": "apple",
        "oauth_token": oAuthToken,
        "device_id": deviceId,
      },
    );
    if (response.isSuccessful) {
      return LoginResponse.fromJson(jsonDecode(response.data));
    } else {
      throw VMException(jsonDecode(response.data));
    }
  }

  @override
  Future<LoginResponse?> loginWithFacebook(String oAuthToken, String deviceId) async {
    return LoginResponse();
  }

  @override
  Future<LoginResponse?> loginWithGoogle(String oAuthToken, String deviceId) async {
    log('loginWithGoogle: $deviceId token: $oAuthToken');

    final response = await _dioClient.post(
      Urls.loginSocial.path,
      data: {
        "provider": "google",
        "oauth_token": oAuthToken,
        "device_id": deviceId,
      },
    );
    if (response.isSuccessful) {
      return LoginResponse.fromJson(jsonDecode(response.data));
    } else {
      throw VMException(jsonDecode(response.data));
    }
  }

  @override
  Future<VerifyModel?> verify(
    String phoneNumber,
    String smsCode,
  ) async {
    final deviceId = await PlatformDeviceId.getDeviceId;
    if (deviceId == null) {
      throw Exception('Device Id not found');
    }
    final response = await _dioClient.post(
      Urls.verify.path,
      data: {
        'phone': phoneNumber,
        'verify_code': smsCode,
        'device_id': deviceId,
      },
    );
    if (response.isSuccessful) {
      return VerifyModel.fromJson(jsonDecode(response.data));
    } else {
      throw VMException(
        response.data.toString(),
        callFuncName: 'verify',
      );
    }
  }

  @override
  Future<bool> applyFirebase(String token) async {
    final response = await _dioClient.post(
      Urls.applyFirebaseId.path,
      data: {'token': token},
    );
    if (response.isSuccessful) {
      return jsonDecode(response.data)['status'];
    }
    return false;
  }
}
