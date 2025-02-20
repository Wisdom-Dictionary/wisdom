import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/domain/entities/def_enum.dart';
import 'package:wisdom/data/model/roadmap/answer_entity.dart';
import 'package:wisdom/data/model/roadmap/test_question_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/level_test_repository.dart';
import 'package:wisdom/presentation/components/dialog_background.dart';
import 'package:wisdom/presentation/components/no_internet_connection_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/cancel_level_exercises_dialog.dart';
import 'package:wisdom/presentation/routes/routes.dart';

import '../../../../core/di/app_locator.dart';

class WordExercisesViewModel extends BaseViewModel {
  WordExercisesViewModel({required super.context});

  final levelTestRepository = locator<LevelTestRepository>();
  final dbHelper = locator<DBHelper>();
  final sharedPref = locator<SharedPreferenceHelper>();
  final localViewModel = locator<LocalViewModel>();

  final String getWordExercisesTag = "getWordExercisesTag";
  final String postWordExercisesCheckTag = "postWordExercisesCheckTag";
  final String postWordExercisesResultTag = "postWordExercisesResultTag";
  int page = 0;
  List<AnswerEntity> answers = [];

  goBack() async {
    if (levelTestRepository.exerciseType == TestExerciseType.levelExercise) {
      final value = await showDialog<bool>(
        context: context!,
        builder: (context) => const DialogBackground(
          child: CancelLevelExercisesDialog(),
        ),
      );

      if (value != null) {
        if (!value) {
          Navigator.pop(context!);
        }
      }
      return;
    }
    Navigator.pop(context!);
  }

  bool get hasTimer =>
      levelTestRepository.startDate.isNotEmpty || levelTestRepository.endDate.isNotEmpty;

  int get givenTimeForExercise {
    if (!hasTimer) {
      return 0;
    }
    DateTime startDate = DateTime.parse(levelTestRepository.startDate);
    DateTime endDate = DateTime.parse(levelTestRepository.endDate);

    // Calculate the difference in seconds
    return endDate.difference(startDate).inSeconds;
  }

  int? get validateAnswers {
    for (int i = 0; i < levelTestRepository.testQuestionsList.length; i++) {
      TestQuestionModel question = levelTestRepository.testQuestionsList[i];
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
    if (levelTestRepository.testQuestionsList.length == tabControllerIndex + 1) {
      return true;
    }
    if (levelTestRepository.testQuestionsList.length > answers.length) {
      return false;
    }
    return true;
  }

  setAnswer(AnswerEntity answer) {
    if (!answers.contains(answer)) {
      answers.add(answer);
    }
  }

  void postTestQuestionsResult() {
    setBusy(true, tag: postWordExercisesCheckTag);
    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        if (levelTestRepository.exerciseType == TestExerciseType.wordExercise) {
          await levelTestRepository.postWordQuestionsCheck(answers);
        } else {
          await levelTestRepository.postTestQuestionsCheck(answers, 100);
        }
        Navigator.pop(context!);
        Navigator.pushNamed(context!, Routes.wordExercisesCheckPage);
        setSuccess(tag: postWordExercisesCheckTag);
      } else {
        showDialog(
          context: context!,
          builder: (context) => const DialogBackground(
            child: NoInternetConnectionDialog(),
          ),
        );
        setBusy(false, tag: postWordExercisesCheckTag);
      }
    }, callFuncName: 'postWordExercisesCheck', tag: postWordExercisesCheckTag, inProgress: false);
  }

  retryWordQuestions() {
    Navigator.pop(context!);
    Navigator.pushNamed(context!, Routes.wordExercisesPage);
  }

  void getTestQuestions() {
    safeBlock(() async {
      try {
        if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
          setBusy(true, tag: getWordExercisesTag);
          if (levelTestRepository.exerciseType == TestExerciseType.wordExercise) {
            await levelTestRepository.getWordQuestions();
          } else {
            await levelTestRepository.getTestQuestions();
          }
          setSuccess(tag: getWordExercisesTag);
        }
      } catch (e) {
        setError(VMException(e.toString()), tag: getWordExercisesTag);
      }
    }, callFuncName: 'getWordExercises', tag: getWordExercisesTag, inProgress: false);
  }
}
