import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/domain/repositories/auth_repository.dart';
import 'package:wisdom/domain/repositories/home_repository.dart';
import 'package:wisdom/presentation/widgets/loading_widget.dart';

class VerificationPageViewModel extends BaseViewModel {
  final AuthRepository authRepository;
  final SharedPreferenceHelper preference;
  final HomeRepository homeRepository;
  Future? dialog;
  late String phoneNumber;

  VerificationPageViewModel({
    required super.context,
    required this.authRepository,
    required this.preference,
    required this.homeRepository,
  });

  Future next(String phoneNumber, String smsCode) async {
    safeBlock(() async {
      this.phoneNumber = phoneNumber;
      final verifyModel = await authRepository.verify(phoneNumber, smsCode);

      if (verifyModel?.status == true) {
        preference.putString(Constants.KEY_PHONE, phoneNumber);
        preference.putString(Constants.KEY_TOKEN, verifyModel!.token!);
      } else {
        callBackError("error_code_entered".tr());
      }
    });
  }

  Future resendCode() async {
    safeBlock(
      () async {
        await authRepository.login(phoneNumber);
      },
      callFuncName: 'onReSendPressed',
      inProgress: false,
    );
  }

  Future _registerFirebase() async {
    try {
      final fmsToken = await FirebaseMessaging.instance.getToken();
      final isRegistered = await authRepository.applyFirebase(fmsToken ?? '');
      log('register firebase $isRegistered');

      final subscribeModel = await homeRepository.checkSubscription();

      if (subscribeModel?.status == true) {
        if (subscribeModel?.expiryStatus == true) {
          // var tariffId = preference.getInt(Constants.KEY_TARIFID, 0);
        }
      }
    } catch (e) {
      log(e.toString());
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
    showTopSnackBar(
      Overlay.of(context!),
      CustomSnackBar.error(
        message: text,
      ),
    );
    if (dialog != null) {
      pop();
      dialog = null;
    }
  }
}
