import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/app.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/data/model/roadmap/answer_entity.dart';
import 'package:wisdom/data/model/roadmap/test_question_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/battle_repository.dart';
import 'package:wisdom/presentation/components/dialog_background.dart';
import 'package:wisdom/presentation/components/no_internet_connection_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/cancel_level_exercises_dialog.dart';
import 'package:wisdom/presentation/routes/routes.dart';

import '../../../../core/di/app_locator.dart';

class BattleExercisesViewModel extends BaseViewModel {
  BattleExercisesViewModel({required super.context});
  final battleRepository = locator<BattleRepository>();

  final sharedPref = locator<SharedPreferenceHelper>();
  final localViewModel = locator<LocalViewModel>();

  final String postExercisesCheckTag = "postWordExercisesCheckTag";
  final String answerAddedTag = "answerAddedTag", answerUpdatedTag = "answerUpdatedTag";

  List<AnswerEntity> answers = [];

  goBack() async {
    final value = await showDialog<bool>(
      context: context!,
      builder: (context) => const DialogBackground(
        child: CancelLevelExercisesDialog(),
      ),
    );

    if (value != null) {
      if (!value) {
        await sharedPref.prefs.remove(Constants.KEY_USER_BATTLE_END_TIME);
        await sharedPref.prefs.remove(Constants.KEY_USER_BATTLE_ID);
        await sharedPref.prefs.remove(Constants.KEY_USER_BATTLE_OPPONENT_USER);
        // final time = spendTimeForExercises > (givenTimeForExercise * 1000)
        //     ? (givenTimeForExercise * 1000)
        //     : spendTimeForExercises;
        // await battleRepository.checkBattleQuestions(answers, time);
        await battleRepository.cancelBattle();
        Navigator.of(navigatorKey.currentContext!).pop();
      }
    }
    return;
  }

  bool get hasTimer => battleRepository.startDate != null || battleRepository.endDate != null;

  int get givenTimeForExercise {
    if (!hasTimer) {
      return 0;
    }
    DateTime startDate = DateTime.fromMillisecondsSinceEpoch(battleRepository.startDate! * 1000);
    DateTime endDate = DateTime.fromMillisecondsSinceEpoch(battleRepository.endDate! * 1000);

    // Calculate the difference in seconds
    return endDate.difference(startDate).inSeconds;
  }

  int get spendTimeForExercises {
    if (!hasTimer) {
      return 0;
    }
    DateTime startDate = DateTime.fromMillisecondsSinceEpoch(battleRepository.startDate! * 1000);
    DateTime endDate = DateTime.now();

    // Calculate the difference in seconds
    return endDate.difference(startDate).inMilliseconds;
  }

  int? get validateAnswers {
    for (int i = 0; i < battleRepository.battleQuestionsList.value.length; i++) {
      TestQuestionModel question = battleRepository.battleQuestionsList.value[i];
      if (!answers
          .map(
            (e) => e.questionId,
          )
          .contains(question.id!)) {
        // Agar ushbu savolga javob berilmagan bo'lsa, o'sha tabga o'tish
        return i;
      }
    }
    return null;
  }

  bool submitButtonStatus(int tabControllerIndex) {
    if (battleRepository.battleQuestionsList.value.length == tabControllerIndex + 1) {
      if (answers.any(
        (element) =>
            element.questionId == battleRepository.battleQuestionsList.value[tabControllerIndex].id,
      )) {
        return true;
      } else {
        return false;
      }
    }
    if (battleRepository.battleQuestionsList.value.length > answers.length) {
      return false;
    }
    return true;
  }

  String? setAnswer(AnswerEntity answer) {
    int index = answers.indexWhere(
      (element) => element.questionId == answer.questionId,
    );
    if (index == -1) {
      answers.add(answer);
      return answerAddedTag;
    } else if (answers[index].answerId != answer.answerId) {
      answers.removeAt(index);
      answers.insert(index, answer);
      return answerUpdatedTag;
    }
    return null;
  }

  void postTestQuestionsResult() {
    setBusy(true, tag: postExercisesCheckTag);
    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        final time = spendTimeForExercises > (givenTimeForExercise * 1000)
            ? (givenTimeForExercise * 1000)
            : spendTimeForExercises;
        await battleRepository.checkBattleQuestions(answers, time);

        Navigator.popAndPushNamed(
          context!,
          Routes.battleResultPage,
        );

        setSuccess(tag: postExercisesCheckTag);
      } else {
        showDialog(
          context: context!,
          builder: (context) => const DialogBackground(
            child: NoInternetConnectionDialog(),
          ),
        );
        setBusy(false, tag: postExercisesCheckTag);
      }
    }, callFuncName: 'postWordExercisesCheck', tag: postExercisesCheckTag, inProgress: false);
  }

  retryWordQuestions() {}
}
