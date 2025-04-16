import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/core/services/contacts_service.dart';
import 'package:wisdom/data/model/roadmap/ranking_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/my_contacts_repository.dart';
import 'package:wisdom/domain/repositories/ranking_repository.dart';
import 'package:wisdom/presentation/routes/routes.dart';

import '../../../../core/di/app_locator.dart';

class RankingViewModel extends BaseViewModel {
  RankingViewModel({required super.context});

  final myContactsRepository = locator<MyContactsRepository>();
  final roadMapRepository = locator<RankingRepository>();
  final localViewModel = locator<LocalViewModel>();

  final String getUserDetailsByIdTag = "getUserDetailsByIdTag",
      getRankingGlobalTag = "getRankingGlobalTag",
      getRankingGlobalMoreTag = "getRankingGlobalMoreTag",
      getRankingContactTag = "getRankingContactTag",
      getRankingContactMoreTag = "getRankingContactMoreTag";
  int page = 1;
  bool hasContactsPermission = false;
  void contactPermission() async {
    hasContactsPermission = await CustomContactService.requestContactPermission(context!);
    notifyListeners();
  }

  RankingModel? selectedItem;

  void getUserDetails(RankingModel item) {
    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        selectedItem = item;
        setBusy(true, tag: getUserDetailsByIdTag);
        await myContactsRepository.postMyContactsSearch(item.userId.toString());
        setSuccess(tag: getUserDetailsByIdTag);
        selectedItem = null;
        final userData = myContactsRepository.searchResultList.firstOrNull;

        if (userData != null) {
          Navigator.pushNamed(context!, Routes.contactDetailsPage, arguments: userData.toMap());
        }
      } else {
        callBackError(LocaleKeys.no_internet.tr());
      }
    }, callFuncName: 'getUserById', tag: getUserDetailsByIdTag, inProgress: false);
  }

  void getRankingGlobal() {
    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        page = 1;
        setBusy(true, tag: getRankingGlobalTag);
        await roadMapRepository.getRankingGlobal(page);
        setSuccess(tag: getRankingGlobalTag);
      } else {
        callBackError(LocaleKeys.no_internet.tr());
      }
    }, callFuncName: 'getRankingGlobal', tag: getRankingGlobalTag, inProgress: false);
  }

  void getRankingGlobalMore() {
    if (roadMapRepository.hasMoreGlobalRankingData) {
      page++;
      safeBlock(() async {
        if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
          setBusy(true, tag: getRankingGlobalMoreTag);
          await roadMapRepository.getRankingGlobal(page);
          setSuccess(tag: getRankingGlobalMoreTag);
        } else {
          callBackError(LocaleKeys.no_internet.tr());
        }
      }, callFuncName: 'getRankingGlobalMore', tag: getRankingGlobalMoreTag, inProgress: false);
    }
  }

  void getRankingContact() {
    hasContactsPermission = true;
    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        page = 1;
        setBusy(true, tag: getRankingContactTag);
        await roadMapRepository.getRankingContactsFromCache();
        if (roadMapRepository.rankingContactList.isNotEmpty) {
          setSuccess(tag: getRankingContactTag);
        }
        await roadMapRepository.getRankingContacts(page);
        setSuccess(tag: getRankingContactTag);
      } else {
        callBackError(LocaleKeys.no_internet.tr());
      }
    }, callFuncName: 'getRankingContact', tag: getRankingContactTag, inProgress: false);
  }

  void getRankingContactMore() {
    if (roadMapRepository.hasMoreContactRankingData) {
      page++;
      safeBlock(() async {
        if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
          setBusy(true, tag: getRankingContactMoreTag);
          await roadMapRepository.getRankingContacts(page);
          setSuccess(tag: getRankingContactMoreTag);
        } else {
          callBackError(LocaleKeys.no_internet.tr());
        }
      }, callFuncName: 'getRankingContactMore', tag: getRankingContactMoreTag, inProgress: false);
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
