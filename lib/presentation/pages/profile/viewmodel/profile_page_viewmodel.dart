import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jbaza/jbaza.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/app.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/config/constants/urls.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/core/services/custom_client.dart';
import 'package:wisdom/data/enums/gender.dart';
import 'package:wisdom/data/model/tariffs_model.dart';
import 'package:wisdom/data/model/user/user_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/profile_repository.dart';
import 'package:wisdom/domain/repositories/word_entity_repository.dart';

import '../../../routes/routes.dart';

class ProfilePageViewModel extends BaseViewModel {
  ProfilePageViewModel({
    required super.context,
    required this.profileRepository,
    required this.localViewModel,
    required this.sharedPreferenceHelper,
    required this.wordEntityRepository,
    required this.netWorkChecker,
  });

  final ProfileRepository profileRepository;
  final LocalViewModel localViewModel;
  final SharedPreferenceHelper sharedPreferenceHelper;
  final WordEntityRepository wordEntityRepository;
  final NetWorkChecker netWorkChecker;

  TariffsModel? tariffsModel;
  TariffsModel? currentTariff;
  UserModel userModel = const UserModel();
  UserModel editedUser = const UserModel();
  String getTariffsTag = 'getTariffs';
  String getGetUserTag = 'getGetUser';
  String restoreTag = 'restoreTag';
  String onSaveChangesTag = 'onSaveChangesTag';
  bool saveButtonsActive = false, validate = false;
  Future? dialog;

  String? get imageUrl => userModel.image != null ? '${Urls.baseUrl}${userModel.image!}' : null;

  int get averageTime => profileRepository.userCabinet!.averageTime;

  int get averageTimeValue => averageTime > 60 ? (averageTime / 60).toInt() : averageTime;

  String get averageTimeSymbol => averageTime > 60 ? " m" : " s";

  int get gameAccuracy => profileRepository.userCabinet!.gameAccuracy;

  int get winRate => profileRepository.userCabinet?.statistics?.winRate ?? 1;

  int get bestTime => profileRepository.userCabinet?.statistics?.bestTime ?? 1;

  bool get hasUser => profileRepository.userCabinet?.user != null;

  bool get hasUserPhoto => profileRepository.userCabinet?.user?.profilePhotoUrl != null;

  String get userPhoto => "${profileRepository.userCabinet?.user?.profilePhotoUrl}&format=png";

  String get userName => profileRepository.userCabinet?.user?.name ?? "";

  int get userCurrentLevel => profileRepository.userCabinet?.userCurrentLevel ?? 0;

  int get userStars => profileRepository.userCabinet?.userStarsValue ?? 0;

  int get threeStarWins => profileRepository.userCabinet?.statistics?.threeStarWins ?? 0;

  int get dailyRecord => profileRepository.userCabinet?.statistics?.dailyRecord ?? 0;

  int get weeklyRecord => profileRepository.userCabinet?.statistics?.weeklyRecord ?? 0;

  int get monthlyRecord => profileRepository.userCabinet?.statistics?.monthlyRecord ?? 0;

  void saveButtonActive() {
    saveButtonsActive = !saveButtonsActive;
    notifyListeners();
  }

  getUser() {
    setBusy(true, tag: getGetUserTag);
    safeBlock(
      () async {
        userModel = await profileRepository.getUser();
        editedUser = UserModel.fromJson(userModel.toJson());
        currentTariff = profileRepository.currentTariff;
        setSuccess(tag: getGetUserTag);
      },
      callFuncName: 'getUser',
      inProgress: false,
    );
  }

  getUserDetails() {
    setBusy(true, tag: getGetUserTag);
    safeBlock(
      () async {
        try {
          await profileRepository.getUserCabinet();
          setSuccess(tag: getGetUserTag);
        } catch (e) {
          if (e is DioException) {
            if (e.response!.statusCode == 401) {
              await resetLocator();
              await navigateTo(Routes.mainPage, isRemoveStack: true);
            }
          }
          setSuccess(tag: getGetUserTag);
        }
      },
      callFuncName: 'getUser',
      inProgress: false,
    );
  }

  getTariffs() {
    safeBlock(
      () async {
        try {
          if (await netWorkChecker.isNetworkAvailable()) {
            await profileRepository.getTariffs();
            tariffsModel = profileRepository.tariffsModel.firstOrNull;
          } else {
            final tariff = sharedPreferenceHelper.getString(Constants.KEY_TARIFFS, '');
            if (tariff.isNotEmpty) {
              tariffsModel = TariffsModel.fromJson(jsonDecode(tariff));
            }
          }
          setSuccess(tag: getTariffsTag);
        } catch (e) {
          setSuccess(tag: getTariffsTag);
        }
      },
      callFuncName: 'getTariffs',
      tag: getTariffsTag,
      inProgress: false,
    );
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

  Future<void> restore() async {
    setBusy(true, tag: restoreTag);
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      await Future.delayed(const Duration(milliseconds: 100), () => MyApp.restartApp(context!));
      // if (PurchasesObserver().isPro()) {}
      setSuccess(tag: restoreTag);
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

  void onEmailChanged(String value) {
    editedUser = editedUser.copyWith(email: value);
    checkUpdate();
  }

  void setBirthday(DateTime value) {
    editedUser = editedUser.copyWith(birthDate: value);
    notifyListeners();
    checkUpdate();
  }

  void onLastNameChanged(String value) {
    editedUser = editedUser.copyWith(name: value);
    checkUpdate();
  }

  void onFirstNameChanged(String value) {
    editedUser = editedUser.copyWith(name: value);
    checkUpdate();
  }

  void checkUpdate() {
    saveButtonsActive = !(editedUser == userModel);
    notifyListeners();
  }

  Future onSaveChanges() async {
    safeBlock(
      () async {
        final user = await profileRepository.updateUser(editedUser);
        sharedPreferenceHelper.putString(Constants.KEY_USER, jsonEncode(user.toJson()));
        setSuccess(tag: onSaveChangesTag);
        showTopSnackBar(
          Overlay.of(context!),
          CustomSnackBar.success(
            message: LocaleKeys.saved.tr(),
          ),
        );
        saveButtonsActive = false;
        await getUser();
      },
      tag: onSaveChangesTag,
    );
  }

  Future logOut() async {
    try {
      await profileRepository.logOut().then((value) async {
        await wordEntityRepository.clearWordBank();
        sharedPreferenceHelper.clear();
        sharedPreferenceHelper.putBoolean(Constants.APP_STATE, false);
        if (Platform.isWindows || Platform.isMacOS) {
          navigateTo(Routes.loginPage, isRemoveStack: true);
        } else {
          navigateTo(Routes.mainPage, isRemoveStack: true);
        }
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void setGender(Gender value) {
    editedUser = editedUser.copyWith(gender: value);
    checkUpdate();
  }

  void onCancelChanges() {
    editedUser = userModel;
    saveButtonsActive = false;
    notifyListeners();
  }

  Future onEditImage(XFile v) async {
    try {
      setBusy(true, tag: 'onEditImage');
      final uploaded = await profileRepository.uploadImage(v);
      if (uploaded) {
        await getUser();
      } else {
        setError(
          VMException(LocaleKeys.something_went_wrong.tr(), tag: 'onEditImage'),
        );
      }
      setSuccess(tag: 'onEditImage');
    } catch (e) {
      setError(VMException(LocaleKeys.something_went_wrong.tr()), tag: 'onEditImage');
    }
  }
}
