import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
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
      getRankingGlobalMoreTag = "getRankingGlobalMoreTag";
  int page = 1;

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
    if (roadMapRepository.hasMoreData) {
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
}
