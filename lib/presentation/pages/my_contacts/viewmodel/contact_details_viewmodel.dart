import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/my_contacts_repository.dart';
import 'package:wisdom/presentation/components/dialog_background.dart';
import 'package:wisdom/presentation/components/no_internet_connection_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/sign_in_dialog.dart';

import '../../../../core/di/app_locator.dart';

class ContactDetailsViewModel extends BaseViewModel {
  ContactDetailsViewModel({required super.context});

  final myContactsRepository = locator<MyContactsRepository>();
  final localViewModel = locator<LocalViewModel>();

  final String getMyContactFollowTag = "getMyContactFollowTag";

  void getMyContacts(int userId) {
    setBusy(true, tag: getMyContactFollowTag);
    safeBlock(() async {
      try {
        if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
          await myContactsRepository.postFollow(userId);
          setSuccess(tag: getMyContactFollowTag);
        } else {
          showDialog(
            context: context!,
            builder: (context) => const DialogBackground(
              child: NoInternetConnectionDialog(),
            ),
          );
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
}
