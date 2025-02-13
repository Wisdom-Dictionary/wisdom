import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/data/model/tariffs_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/profile_repository.dart';
import 'package:wisdom/presentation/widgets/loading_widget.dart';

import '../../../routes/routes.dart';

class GettingProPageViewModel extends BaseViewModel {
  GettingProPageViewModel({
    required super.context,
    required this.profileRepository,
    required this.localViewModel,
    required this.sharedPreferenceHelper,
  });

  Future? dialog;
  final ProfileRepository profileRepository;
  final LocalViewModel localViewModel;
  final SharedPreferenceHelper sharedPreferenceHelper;
  String getTariffsTag = 'getTariffsTag';
  String restoreTag = 'restoreTag';
  TariffsModel? tariffsModel;
  String tariffsValue = '';

  getTariffs() {
    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        await profileRepository.getTariffs();
        tariffsValue = profileRepository.tariffsModel.first.id.toString();
        tariffsModel = profileRepository.tariffsModel.firstOrNull;
        setSuccess(tag: getTariffsTag);
      } else {
        callBackError("no_internet".tr());
        setSuccess();
      }
    }, callFuncName: 'getTariffs', tag: getTariffsTag);
  }

  bool haveAccount() => sharedPreferenceHelper.getString(Constants.KEY_TOKEN, "").isNotEmpty;

  bool subscribed() => sharedPreferenceHelper.getString(Constants.KEY_SUBSCRIBE, "") == "";

  void onBuyPremiumPressed() {
    if (haveAccount()) {
      if (tariffsValue != '') {
        sharedPreferenceHelper.putInt(Constants.KEY_TARIFID, int.parse(tariffsValue));
        sharedPreferenceHelper.putString(
            Constants.KEY_TARIFFS, jsonEncode(profileRepository.tariffsModel.first));
        navigateTo(Routes.paymentPage, arg: {'verifyModel': null, 'phoneNumber': null});
      }
    } else {
      navigateTo(Routes.loginPage);
      // navigateTo(Routes.paymentPage, arg: {'verifyModel': null, 'phoneNumber': null});
    }
  }

  void onRegistrationPressed() {
    navigateTo(Routes.registrationPage);
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
