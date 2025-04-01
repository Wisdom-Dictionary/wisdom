import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/core/services/contacts_service.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/ranking_repository.dart';
import 'package:wisdom/presentation/components/dialog_background.dart';
import 'package:wisdom/presentation/components/no_internet_connection_dialog.dart';

import '../../../../core/di/app_locator.dart';

class RankingViewModel extends BaseViewModel {
  RankingViewModel({required super.context});

  final roadMapRepository = locator<RankingRepository>();
  final localViewModel = locator<LocalViewModel>();

  final String getRankingGlobalTag = "getRankingGlobalTag",
      getRankingGlobalMoreTag = "getRankingGlobalMoreTag",
      getRankingContactTag = "getRankingContactTag",
      getRankingContactMoreTag = "getRankingContactMoreTag";
  int page = 1;
  bool hasContactsPermission = false;
  void contactPermission() async {
    hasContactsPermission = await CustomContactService.requestContactPermission(context!);
    notifyListeners();
  }

  void getRankingGlobal() {
    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        page = 1;
        setBusy(true, tag: getRankingGlobalTag);
        await roadMapRepository.getRankingGlobal(page);
        setSuccess(tag: getRankingGlobalTag);
      } else {
        showDialog(
          context: context!,
          builder: (context) => const DialogBackground(
            child: NoInternetConnectionDialog(),
          ),
        );
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
          showDialog(
            context: context!,
            builder: (context) => const DialogBackground(
              child: NoInternetConnectionDialog(),
            ),
          );
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
        showDialog(
          context: context!,
          builder: (context) => const DialogBackground(
            child: NoInternetConnectionDialog(),
          ),
        );
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
          showDialog(
            context: context!,
            builder: (context) => const DialogBackground(
              child: NoInternetConnectionDialog(),
            ),
          );
        }
      }, callFuncName: 'getRankingContactMore', tag: getRankingContactMoreTag, inProgress: false);
    }
  }
}
