import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/my_contacts_repository.dart';

import '../../../../core/di/app_locator.dart';

class MyContactSearchViewModel extends BaseViewModel {
  MyContactSearchViewModel({required super.context});

  final myContactsRepository = locator<MyContactsRepository>();
  final localViewModel = locator<LocalViewModel>();

  final String getMyContactSearchTag = "getMyContactSearchTag";

  void searchMyContacts(String searchKeyWord) {
    if (searchKeyWord.isNotEmpty) {
      setBusy(true, tag: getMyContactSearchTag);
      safeBlock(() async {
        if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
          await myContactsRepository.postMyContactsSearch(searchKeyWord);
          setSuccess(tag: getMyContactSearchTag);
        } else {
          setBusy(false, tag: getMyContactSearchTag);
          callBackError(LocaleKeys.no_internet.tr());
        }
      }, callFuncName: 'getMyContactSearch', tag: getMyContactSearchTag, inProgress: false);
    } else {
      myContactsRepository.searchResultListClear();
      notifyListeners();
    }
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
