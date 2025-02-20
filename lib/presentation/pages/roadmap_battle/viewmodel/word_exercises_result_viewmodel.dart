import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/domain/entities/def_enum.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/level_test_repository.dart';
import 'package:wisdom/presentation/components/dialog_background.dart';
import 'package:wisdom/presentation/components/no_internet_connection_dialog.dart';

import '../../../../core/di/app_locator.dart';

class WordExercisesResultViewModel extends BaseViewModel {
  WordExercisesResultViewModel({required super.context});

  final levelTestRepository = locator<LevelTestRepository>();
  final dbHelper = locator<DBHelper>();
  final sharedPref = locator<SharedPreferenceHelper>();
  final localViewModel = locator<LocalViewModel>();

  final String postWordExercisesResultTag = "postWordExercisesResultTag";

  goBack() async {
    Navigator.pop(context!);
  }

  void postTestQuestionsResult() {
    setBusy(true, tag: postWordExercisesResultTag);
    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        if (levelTestRepository.exerciseType == TestExerciseType.wordExercise) {
          await levelTestRepository.postWordQuestionsResult();
        } else {
          await levelTestRepository.postTestQuestionsResult();
        }
        setSuccess(tag: postWordExercisesResultTag);
      } else {
        showDialog(
          context: context!,
          builder: (context) => const DialogBackground(
            child: NoInternetConnectionDialog(),
          ),
        );
        setBusy(false, tag: postWordExercisesResultTag);
      }
    }, callFuncName: 'postWordExercisesResult', tag: postWordExercisesResultTag, inProgress: false);
  }
}
