import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/data/model/my_contacts/user_details_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/my_contacts_repository.dart';
import 'package:wisdom/presentation/components/dialog_background.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/sign_in_dialog.dart';

import '../../../../core/di/app_locator.dart';

class ContactDetailsViewModel extends BaseViewModel {
  ContactDetailsViewModel({required super.context});

  final myContactsRepository = locator<MyContactsRepository>();
  final sharedPref = locator<SharedPreferenceHelper>();
  final localViewModel = locator<LocalViewModel>();

  final String getMyContactFollowTag = "getMyContactFollowTag";
  bool isFollowed = false;
  bool isCurrentUser = false;

  void setFollowStatus(bool followed) {
    isFollowed = followed;
  }

  void setIsCurrentUserValue(bool value) {
    isCurrentUser = value;
  }

  void setIsCurrentUser(UserDetailsModel contactItemData) {
    final userStorage = sharedPref.getString(Constants.KEY_USER_CABINET, "");
    if (userStorage != '') {
      final UserDetailsModel user = UserDetailsModel.fromJson(jsonDecode(userStorage));
      if (user.user != null && contactItemData.user != null) {
        isCurrentUser = user.user!.id == contactItemData.user!.id;
      }
    }
  }

  void postFollowAction(
    int userId,
  ) {
    setBusy(true, tag: getMyContactFollowTag);
    safeBlock(() async {
      try {
        if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
          String details = "";
          if (isFollowed) {
            details = await myContactsRepository.postUnFollow(userId);
          } else {
            details = await myContactsRepository.postFollow(userId);
          }
          isFollowed = !isFollowed;
          setSuccess(tag: getMyContactFollowTag);
          showTopSnackBar(
            Overlay.of(context!),
            CustomSnackBar.success(
              message: details,
            ),
          );
        } else {
          callBackError(LocaleKeys.no_internet.tr());
        }
      } catch (e) {
        if (e is VMException) {
          if (e.response != null) {
            if (e.response!.statusCode == 403) {
              showDialog(
                context: context!,
                builder: (context) => const DialogBackground(
                  child: SignInDialog(),
                ),
              );
            }
          }
        }
      }
    }, callFuncName: 'getMyContactFollow', tag: getMyContactFollowTag, inProgress: false);
  }

  @override
  callBackError(String text) {
    log(text);
    showTopSnackBar(
      Overlay.of(context!),
      CustomSnackBar.error(
        message: text,
      ),
    );
  }
}
