import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/app.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/data/model/tariffs_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/profile_repository.dart';
import 'package:wisdom/presentation/widgets/loading_widget.dart';

import '../../../../core/services/purchase_observer.dart';
import '../../../routes/routes.dart';

class ProfilePageViewModel extends BaseViewModel {
  ProfilePageViewModel({
    required super.context,
    required this.profileRepository,
    required this.localViewModel,
    required this.sharedPreferenceHelper,
  });

  Future? dialog;
  final ProfileRepository profileRepository;
  final LocalViewModel localViewModel;
  final SharedPreferenceHelper sharedPreferenceHelper;
  TariffsModel tariffsModel = TariffsModel();
  String getTariffsTag = 'getTariffsTag';
  String restoreTag = 'restoreTag';

  getTariffs() {
    safeBlock(() async {
      try {
        tariffsModel = TariffsModel.fromJson(
            jsonDecode(sharedPreferenceHelper.getString(Constants.KEY_TARIFFS, '')));
        setSuccess(tag: getTariffsTag);
      } catch (e) {
        setSuccess(tag: getTariffsTag);
      }
    }, callFuncName: 'getTariffs', inProgress: false);
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
  }

  Future<void> restore() async {
    setBusy(true, tag: restoreTag);
    try {
      await PurchasesObserver().callRestorePurchases();
      setSuccess(tag: restoreTag);
      if (PurchasesObserver().isPro()) {
        Future.delayed(const Duration(milliseconds: 100), () => MyApp.restartApp(context!));
      }
    } catch (e) {
      setError(VMException(e.toString()), tag: restoreTag);
    }
  }

  onPaymentPressed() {
    navigateTo(Routes.paymentPage, arg: {'verifyModel': null, 'phoneNumber': null});
  }

  goBackToMenu() {
    navigateTo(Routes.mainPage, isRemoveStack: true);
  }
}
