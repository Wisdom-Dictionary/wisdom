import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/data/model/verify_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/home_repository.dart';
import 'package:wisdom/domain/repositories/profile_repository.dart';
import 'package:wisdom/domain/repositories/word_entity_repository.dart';
import 'package:wisdom/main.dart';

import '../../../../config/constants/constants.dart';
import '../../../../core/services/purchase_observer.dart';
import '../../../routes/routes.dart';
import '../../../widgets/loading_widget.dart';

class VerifyPageViewModel extends BaseViewModel {
  VerifyPageViewModel({
    required super.context,
    required this.profileRepository,
    required this.localViewModel,
    required this.sharedPreferenceHelper,
    required this.homeRepository,
    required this.phoneNumber,
    required this.wordEntityRepository,
  });

  final ProfileRepository profileRepository;
  final LocalViewModel localViewModel;
  final SharedPreferenceHelper sharedPreferenceHelper;
  final HomeRepository homeRepository;
  final WordEntityRepository wordEntityRepository;
  String verifyTag = 'verifyTag';
  final String phoneNumber;
  Future? dialog;
  String codeSMS = '';

  void onNextPressed() {
    safeBlock(
      () async {
        try {
          String? deviceId = await PlatformDeviceId.getDeviceId;
          if (deviceId == null) {
            callBackError("Device Id not found");
          } else {
            var verifyModel = await profileRepository.verify(
              phoneNumber
                  .replaceAll('+', '')
                  .replaceAll(' ', '')
                  .replaceAll('(', '')
                  .replaceAll(')', ''),
              codeSMS,
              deviceId,
            );
            if (verifyModel != null && verifyModel.status!) {
              sharedPreferenceHelper.putString(Constants.KEY_TOKEN, verifyModel.token!);
              sharedPreferenceHelper.putString(Constants.KEY_PHONE, phoneNumber);
              sharedPreferenceHelper.putInt(Constants.KEY_PROFILE_STATE, Constants.STATE_INACTIVE);
              sharedPreferenceHelper.putString(Constants.KEY_VERIFY, jsonEncode(verifyModel));
              final user = await profileRepository.getUser();
              sharedPreferenceHelper.putString(
                Constants.KEY_USER,
                jsonEncode(user.copyWith(phone: phoneNumber)),
              );

              if (!(Platform.isWindows || Platform.isMacOS)) {
                var tokenF = await FirebaseMessaging.instance.getToken();
                await _addFirebase(tokenF!);
              }
              final isPro = await _checkSubscription();
              await _updateWordBank();
              await resetLocator();
              setSuccess();
              if (isPro) {
                navigateTo(Routes.mainPage, isRemoveStack: true);
              } else {
                navigateTo(Routes.mainPage, isRemoveStack: true);
                await Future.delayed(Duration(milliseconds: 500));
                getProBottomSheetController.add(true);
              }
            } else {
              callBackError("error_code_entered".tr());
            }
          }
        } catch (e) {
          if (e is DioException) {
            final responseMessage = jsonDecode(e.response!.data);
            throw VMException(
              responseMessage["message"] ?? responseMessage,
              callFuncName: 'verify',
            );
          }
        }
      },
      callFuncName: 'onNextPressed',
      inProgress: true,
    );
  }

  Future _updateWordBank() async {
    await wordEntityRepository.updateWordBank();
  }

  Future _addFirebase(String tokenF) async {
    var status = await profileRepository.applyFirebaseId(tokenF);
    return status;
  }

  Future<bool> _checkSubscription() async {
    var subscribeModel = await homeRepository.checkSubscription();
    if (subscribeModel?.status == true) {
      if (subscribeModel?.expiryStatus == true) {
        final tariffId = sharedPreferenceHelper.getInt(Constants.KEY_TARIFID, 0);
        await profileRepository.subscribe(tariffId).then((value) {
          sharedPreferenceHelper.putString(Constants.KEY_SUBSCRIBE, jsonEncode(subscribeModel));
          PurchasesObserver().profileState = Constants.STATE_ACTIVE;
          sharedPreferenceHelper.putInt(Constants.KEY_PROFILE_STATE, Constants.STATE_ACTIVE);
        });
        return true;
      } else {
        PurchasesObserver().profileState = Constants.STATE_INACTIVE;
        sharedPreferenceHelper.putInt(Constants.KEY_PROFILE_STATE, Constants.STATE_INACTIVE);
        return false;
      }
    }
    return false;
  }

  Future addDeviceToFirebase(VerifyModel verifyModel, String? tokenF) async {
    safeBlock(
      () async {
        var status = await profileRepository.applyFirebaseId(tokenF!);
        if (status) {
          var subscribeModel = await homeRepository.checkSubscription();
          if (subscribeModel != null && subscribeModel.status!) {
            if (subscribeModel.expiryStatus == true) {
              var tariffId = sharedPreferenceHelper.getInt(Constants.KEY_TARIFID, 0);
              await profileRepository.subscribe(tariffId).then(
                (value) {
                  sharedPreferenceHelper.putString(
                    Constants.KEY_SUBSCRIBE,
                    jsonEncode(subscribeModel),
                  );
                  PurchasesObserver().profileState = Constants.STATE_ACTIVE;
                  sharedPreferenceHelper.putInt(
                    Constants.KEY_PROFILE_STATE,
                    Constants.STATE_ACTIVE,
                  );
                  navigateTo(Routes.mainPage, isRemoveStack: true);
                },
              );
            } else {
              PurchasesObserver().profileState = Constants.STATE_INACTIVE;
              sharedPreferenceHelper.putInt(Constants.KEY_PROFILE_STATE, Constants.STATE_INACTIVE);
              // await PurchasesObserver().callGetProfile();
              navigateTo(Routes.mainPage, isRemoveStack: true);
              navigateTo(Routes.gettingProPage);
            }
          }
        }
        setSuccess();
      },
      callFuncName: 'addDeviceToFirebase',
      inProgress: true,
    );
  }

  void onReSendPressed() {
    safeBlock(
      () async {
        await profileRepository.login(phoneNumber
            .replaceAll('+', '')
            .replaceAll(' ', '')
            .replaceAll('(', '')
            .replaceAll(')', ''));
      },
      callFuncName: 'onReSendPressed',
      inProgress: false,
    );
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
