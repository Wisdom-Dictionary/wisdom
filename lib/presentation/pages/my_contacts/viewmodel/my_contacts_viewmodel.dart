import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/app.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/core/services/contacts_service.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/my_contacts_repository.dart';
import 'package:wisdom/presentation/components/dialog_background.dart';
import 'package:wisdom/presentation/pages/my_contacts/view/my_contacts_page.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/sign_in_dialog.dart';

import '../../../../core/di/app_locator.dart';

class MyContactsViewModel extends BaseViewModel {
  MyContactsViewModel({required super.context});

  final myContactsRepository = locator<MyContactsRepository>();
  final localViewModel = locator<LocalViewModel>();

  final String getMyContactsTag = "getMyContactsTag";
  bool hasContactsPermission = false;

  void getMyContactUsers() {
    setBusy(true, tag: getMyContactsTag);
    safeBlock(() async {
      try {
        if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
          if (await CustomContactService.requestContactPermission(context!)) {
            hasContactsPermission = true;
            await myContactsRepository.getMyContactUsersFromCache();
            if (myContactsRepository.myContactsList.isNotEmpty) {
              setSuccess(tag: getMyContactsTag);
            }

            await myContactsRepository.getMyContactUsers();
          } else {
            showDialog(
              context: navigatorKey.currentContext!,
              builder: (context) => ContactsPermissionDialog(),
            );
            hasContactsPermission = false;
          }
          setSuccess(tag: getMyContactsTag);
        } else {
          callBackError(LocaleKeys.no_internet.tr());
          setBusy(false, tag: getMyContactsTag);
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
    }, callFuncName: 'getMyContactUsers', tag: getMyContactsTag, inProgress: false);
  }

  void getMyFollowedUsers() {
    setBusy(true, tag: getMyContactsTag);
    safeBlock(() async {
      try {
        if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
          await myContactsRepository.getMyFollowedUsers();
          setSuccess(tag: getMyContactsTag);
        } else {
          setBusy(false, tag: getMyContactsTag);
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
    }, callFuncName: 'getMyFollowedUsers', tag: getMyContactsTag, inProgress: true);
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
