import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wisdom/app.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/services/custom_client.dart';
import 'package:wisdom/core/services/purchase_observer.dart';
import 'package:wisdom/data/model/subscribe_model.dart';
import 'package:wisdom/data/model/verify_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/profile_repository.dart';

import '../../../../config/constants/constants.dart';
import '../../../../data/model/tariffs_model.dart';
import '../../../routes/routes.dart';
import '../../../widgets/loading_widget.dart';

class PaymentPageViewModel extends BaseViewModel {
  PaymentPageViewModel({
    required super.context,
    required this.profileRepository,
    required this.localViewModel,
    required this.sharedPreferenceHelper,
    required this.phoneNumber,
    required this.verifyModel,
  });

  final ProfileRepository profileRepository;
  final LocalViewModel localViewModel;
  final SharedPreferenceHelper sharedPreferenceHelper;

  String? phoneNumber;
  VerifyModel? verifyModel;

  String? radioValue = '';
  String subscribeSuccessfulTag = 'subscribeSuccessfulTag';
  String restoreTag = 'restoreTag';
  String applePayTag = 'ApplePay';
  TariffsModel tariffsList = TariffsModel();
  SubscribeModel subscribeModel = SubscribeModel();
  Future? dialog;

  Future init() async {
    safeBlock(
      () async {
        if (await locator<NetWorkChecker>().isNetworkAvailable()) {
          var tariffId = sharedPreferenceHelper.getInt(Constants.KEY_TARIFID, 0);
          subscribeModel = await profileRepository.subscribe(tariffId);
          sharedPreferenceHelper.putString(Constants.KEY_SUBSCRIBE, jsonEncode(subscribeModel));
          tariffsList = TariffsModel.fromJson(
              jsonDecode(sharedPreferenceHelper.getString(Constants.KEY_TARIFFS, "")));
          // verifyModel ??= VerifyModel.fromJson(
          //     jsonDecode(sharedPreferenceHelper.getString(Constants.KEY_VERIFY, "")));
          setSuccess(tag: subscribeSuccessfulTag);
        } else {
          callBackError('Connection lost');
        }
      },
      callFuncName: 'init',
      tag: subscribeSuccessfulTag,
    );
  }

  Future<void> restore() async {
    setBusy(true, tag: restoreTag);
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      setSuccess(tag: restoreTag);
      if (PurchasesObserver().isPro()) {
        await Future.delayed(const Duration(milliseconds: 100), () => goToProfile());
      }
    } catch (e) {
      setError(VMException(e.toString()), tag: restoreTag);
    }
  }

  Future onPayPressed() async {
    switch (radioValue) {
      case "click":
        await openClick();
        break;
      case "payme":
        await openPayme();
        break;
      case "applePay":
        await applePay();
        break;
    }
    await resetLocator();
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

  goToProfile() {
    Navigator.canPop(context!) ? pop() : navigateTo(Routes.mainPage, isRemoveStack: true);
  }

  Future<void> openClick() async {
    await launchUrl(Uri.parse('${subscribeModel.click}'), mode: LaunchMode.externalApplication);
  }

  Future<void> openPayme() async {
    log(subscribeModel.payme.toString());
    await launchUrl(Uri.parse('${subscribeModel.payme}'), mode: LaunchMode.externalApplication);
  }

  Future<void> applePay() async {
    setBusy(true, tag: applePayTag);
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      // final product = await PurchasesObserver().callGetLastProduct('pay_once');
      // await PurchasesObserver().callMakePurchase(product!);
      if (PurchasesObserver().isPro()) {
        MyApp.restartApp(context!);
      } else {
        setSuccess(tag: applePayTag);
      }
    } catch (e) {
      setError(VMException(e.toString(), callFuncName: 'applePay', tag: applePayTag));
    }
  }
}
