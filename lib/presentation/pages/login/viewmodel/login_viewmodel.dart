import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jbaza/jbaza.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/services/purchase_observer.dart';
import 'package:wisdom/data/model/login_response.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/auth_repository.dart';
import 'package:wisdom/domain/repositories/home_repository.dart';
import 'package:wisdom/domain/repositories/profile_repository.dart';
import 'package:wisdom/domain/repositories/word_entity_repository.dart';
import 'package:wisdom/main.dart';
import 'package:wisdom/presentation/routes/routes.dart';
import 'package:wisdom/presentation/widgets/loading_widget.dart';

class LoginViewModel extends BaseViewModel {
  final AuthRepository authRepository;
  final SharedPreferenceHelper preference;
  final ProfileRepository profileRepository;
  final HomeRepository homeRepository;
  final WordEntityRepository wordEntityRepository;
  final inputFormatter = MaskTextInputFormatter(
    mask: '(##) ### ## ##',
  );
  Future? dialog;
  String phone = '';

  LoginViewModel({
    required super.context,
    required this.authRepository,
    required this.preference,
    required this.profileRepository,
    required this.homeRepository,
    required this.wordEntityRepository,
  });

  Future login() async {
    if (!_phoneIsCorrect) {
      callBackError('Phone is not correct');
      return;
    }
    safeBlock(() async {
      final String number = '998$phone';
      final bool login = await authRepository.login(number);
      if (login) {
        setSuccess();
        navigateTo(Routes.verifyPage, arg: {'number': number});
      }
    });
  }

  Future loginWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      if (credential.identityToken != null) {
        final deviceId = await PlatformDeviceId.getDeviceId;
        if (deviceId == null) {
          callBackError("Device Id not found");
          return;
        }
        final login = await authRepository.loginWithApple(credential.identityToken!, deviceId);
        if (login?.status == true) {
          await _getUserData(login!);
          setSuccess();
        }
      } else {
        log('identity token is null');
      }
    } catch (e) {
      log(e.toString(), error: e.toString());
      callBackError('Login with Apple error');
    }
  }

  Future loginWithGoogle() async {
    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final deviceId = await PlatformDeviceId.getDeviceId;
        if (deviceId == null) {
          callBackError("Device Id not found");
          return;
        }
        setBusy(true);
        final login = await authRepository.loginWithGoogle(googleAuth.accessToken!, deviceId);
        if (login?.status == true) {
          await _getUserData(login!);
          setSuccess();
        }
      } else {
        log('google user is null');
      }
    } catch (_) {
      rethrow;
    } finally {
      setBusy(false);
    }
  }

  Future loginWithFacebook() async {
    // try {
    //   await FacebookAuth.instance.logOut();
    //   final LoginResult result = await FacebookAuth.instance.login();
    //   if (result.status == LoginStatus.success) {
    //     final deviceId = await PlatformDeviceId.getDeviceId;
    //     if (deviceId == null) {
    //       callBackError("Device Id not found");
    //       return;
    //     }
    //     final login = await authRepository.loginWithFacebook(result.accessToken!.token, deviceId);
    //     if (login?.status == true) {
    //       await _getUserData(login!);
    //       setSuccess();
    //     }
    //   }
    // } catch (e) {
    //   log('facebook login error $e');
    // }
  }

  Future _getUserData(LoginResponse loginResponse) async {
    preference.putString(Constants.KEY_TOKEN, loginResponse.token!);
    await profileRepository.getUser();
    await _addDeviceToFirebase(loginResponse);
    await _updateWordBank();
    await locator.get<LocalViewModel>().changeBadgeCount(0);
  }

  Future _updateWordBank() async {
    await wordEntityRepository.updateWordBank();
  }

  Future _addDeviceToFirebase(LoginResponse loginResponse) async {
    final fmcToken = await FirebaseMessaging.instance.getToken();
    final status = await profileRepository.applyFirebaseId(fmcToken!);
    if (status) {
      final subscribeModel = await homeRepository.checkSubscription();
      if (subscribeModel?.status == true) {
        if (subscribeModel?.expiryStatus == true) {
          final tariffId = preference.getInt(Constants.KEY_TARIFID, 0);
          await profileRepository.subscribe(tariffId).then((value) {
            preference.putString(Constants.KEY_SUBSCRIBE, jsonEncode(subscribeModel));
            PurchasesObserver().profileState = Constants.STATE_ACTIVE;
            preference.putInt(Constants.KEY_PROFILE_STATE, Constants.STATE_ACTIVE);
            navigateTo(Routes.mainPage, isRemoveStack: true);
          });
        } else {
          PurchasesObserver().profileState = Constants.STATE_INACTIVE;
          preference.putInt(Constants.KEY_PROFILE_STATE, Constants.STATE_INACTIVE);
          navigateTo(Routes.mainPage, isRemoveStack: true);
          await Future.delayed(const Duration(seconds: 1));
          getProBottomSheetController.add(true);
        }
      }
    }
  }

  @override
  callBackBusy(bool value, String? tag) {
    if (dialog == null && isBusy(tag: tag)) {
      Future.delayed(Duration.zero, () {
        dialog = showLoadingDialog(context!);
      });
    }
  }

  @override
  callBackSuccess(value, String? tag) {
    if (dialog != null) {
      pop();
      dialog = null;
    }
  }

  @override
  callBackError(String text) {
    if (dialog != null) {
      pop();
      dialog = null;
    }
    showTopSnackBar(
      Overlay.of(context!),
      CustomSnackBar.error(
        message: text,
      ),
    );
  }

  void setPhone(String value) {
    log(value);
    phone = inputFormatter.getUnmaskedText();
  }

  bool get _phoneIsCorrect => phone.length == 9;
}
