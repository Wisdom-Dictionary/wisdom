import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/data/model/roadmap/level_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/level_test_repository.dart';
import 'package:wisdom/domain/repositories/roadmap_repository.dart';
import 'package:wisdom/presentation/components/dialog_background.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/opponent_was_found_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/opponent_was_not_found_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/out_of_lives_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/out_of_lives_with_timer_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/start_battle_dialog.dart';

import '../../../../core/di/app_locator.dart';

class RoadMapViewModel extends BaseViewModel {
  RoadMapViewModel({required super.context});

  final roadMapRepository = locator<RoadmapRepository>();
  final levelTestRepository = locator<LevelTestRepository>();
  final dbHelper = locator<DBHelper>();
  final sharedPref = locator<SharedPreferenceHelper>();
  final localViewModel = locator<LocalViewModel>();

  final String getLevelsTag = "getLevelsTag";
  int page = 0;

  void getLevels() {
    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        await roadMapRepository.getLevels(++page);
        setSuccess(tag: getLevelsTag);
      }
    }, callFuncName: 'getLevels', tag: getLevelsTag, inProgress: false);
  }

  void selectLevel(LevelModel item) {
    if (item.type == "battle") {
      showDialog(
        context: context!,
        builder: (context) => DialogBackground(
          child: StartBattleDialog(),
        ),
      );
      return;
    }
    roadMapRepository.setSelectedLevel(item);
    levelTestRepository.setSelectedLevel(item);
    locator<LocalViewModel>().changePageIndex(25);
  }
}
