import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/domain/entities/def_enum.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/level_test_repository.dart';

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
        callBackError(LocaleKeys.no_internet.tr());
        setBusy(false, tag: postWordExercisesResultTag);
      }
    }, callFuncName: 'postWordExercisesResult', tag: postWordExercisesResultTag, inProgress: false);
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
