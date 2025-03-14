import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/app.dart';
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
  final localViewModel = locator<LocalViewModel>();

  final String postExercisesCheckTag = "postWordExercisesCheckTag";

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
        Navigator.of(context!).pop();
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
      return true;
    }
    if (battleRepository.battleQuestionsList.value.length > answers.length) {
      return false;
    }
    return true;
  }

  setAnswer(AnswerEntity answer) {
    if (!answers.any(
      (element) => element.questionId == answer.questionId,
    )) {
      answers.add(answer);
    }
  }

  void postTestQuestionsResult() {
    setBusy(true, tag: postExercisesCheckTag);
    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        await battleRepository.checkBattleQuestions(answers, spendTimeForExercises);

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
