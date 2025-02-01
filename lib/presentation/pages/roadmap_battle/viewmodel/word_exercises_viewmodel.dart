import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/data/model/roadmap/answer_entity.dart';
import 'package:wisdom/data/model/roadmap/test_question_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/roadmap_repository.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/word_exercises_check_page.dart';
import 'package:wisdom/presentation/routes/routes.dart';

import '../../../../core/di/app_locator.dart';

class WordExercisesViewModel extends BaseViewModel {
  WordExercisesViewModel({required super.context});

  final homeRepository = locator<RoadmapRepository>();
  final dbHelper = locator<DBHelper>();
  final sharedPref = locator<SharedPreferenceHelper>();
  final localViewModel = locator<LocalViewModel>();

  final String getWordExercisesTag = "getWordExercisesTag";
  final String postWordExercisesCheckTag = "postWordExercisesCheckTag";
  int page = 0;
  List<AnswerEntity> answers = [];

  goBack() {
    Navigator.pop(context!);
  }

  int? get validateAnswers {
    for (int i = 0; i < homeRepository.wordQuestionsList.length; i++) {
      TestQuestionModel question = homeRepository.wordQuestionsList[i];
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
    if (homeRepository.wordQuestionsList.length == tabControllerIndex + 1) {
      return true;
    }
    if (homeRepository.wordQuestionsList.length > answers.length) {
      return false;
    }
    return true;
  }

  setAnswer(AnswerEntity answer) {
    if (!answers.contains(answer)) {
      answers.add(answer);
    }
  }

  void postTestQuestionsCheck() {
    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        await homeRepository.postWordQuestionsCheck(answers);
        Navigator.pop(context!);
        Navigator.pushNamed(context!, Routes.wordExercisesCheckPage);
        setSuccess(tag: postWordExercisesCheckTag);
      }
    }, callFuncName: 'postWordExercisesCheck', tag: postWordExercisesCheckTag, inProgress: false);
  }

  retryWordQuestions() {
    Navigator.pop(context!);
    Navigator.pushNamed(context!, Routes.wordExercisesPage);
  }

  void getTestQuestions() {
    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        await homeRepository.getWordQuestions();
        setSuccess(tag: getWordExercisesTag);
      }
    }, callFuncName: 'getWordExercises', tag: getWordExercisesTag, inProgress: false);
  }
}
