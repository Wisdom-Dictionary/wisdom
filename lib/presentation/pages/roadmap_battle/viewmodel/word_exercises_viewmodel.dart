import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/domain/entities/def_enum.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/data/model/roadmap/answer_entity.dart';
import 'package:wisdom/data/model/roadmap/test_question_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/level_test_repository.dart';
import 'package:wisdom/presentation/components/dialog_background.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/cancel_level_exercises_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/life_countdown_provider.dart';
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
  final String answerAddedTag = "answerAddedTag", answerUpdatedTag = "answerUpdatedTag";
  int page = 0;
  List<AnswerEntity> answers = [];

  bool get hasUserLives => context!.read<CountdownProvider>().hasUserLives;

  bool get isLevelTest => levelTestRepository.exerciseType == TestExerciseType.levelExercise;

  goBackFromExercisesResultPage() async {
    Navigator.pop(context!);
  }

  goRoadmapPage() {
    locator<LocalViewModel>().changePageIndex(3);
  }

  goBack() async {
    if (isLevelTest) {
      final value = await showDialog<bool>(
        context: context!,
        builder: (context) => const DialogBackground(
          child: CancelLevelExercisesDialog(),
        ),
      );

      if (value != null) {
        if (!value) {
          final resultText = await levelTestRepository.postCancelTest();
          if (resultText != null) {
            showTopSnackBar(
              Overlay.of(context!),
              CustomSnackBar.success(
                message: resultText,
              ),
            );
          }
          await context!.read<CountdownProvider>().getLives();
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

  int get spendTimeForExercises {
    if (!hasTimer) {
      return 0;
    }
    DateTime startDate = DateTime.parse(levelTestRepository.startDate);
    DateTime endDate = DateTime.now();

    // Calculate the difference in seconds
    return endDate.difference(startDate).inMilliseconds;
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
      if (answers.any(
        (element) =>
            element.questionId == levelTestRepository.testQuestionsList[tabControllerIndex].id,
      )) {
        return true;
      } else {
        return false;
      }
    }
    if (levelTestRepository.testQuestionsList.length > answers.length) {
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
    setBusy(true, tag: postWordExercisesCheckTag);
    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        if (!isLevelTest) {
          await levelTestRepository.postWordQuestionsCheck(answers);
        } else {
          final time = spendTimeForExercises > (givenTimeForExercise * 1000)
              ? (givenTimeForExercise * 1000)
              : spendTimeForExercises;
          await levelTestRepository.postTestQuestionsCheck(answers, time);
          if (!levelTestRepository.pass) {
            await context!.read<CountdownProvider>().getLives();
          }
        }
        Navigator.popUntil(
          context!,
          (route) => route.isFirst ? true : false,
        );
        Navigator.pushNamed(context!, Routes.wordExercisesCheckPage)
            // .then((onValue) {
            //   Navigator.pop(context!);
            // })
            ;
        setSuccess(tag: postWordExercisesCheckTag);
      } else {
        callBackError(LocaleKeys.no_internet.tr());
        setBusy(false, tag: postWordExercisesCheckTag);
      }
    }, callFuncName: 'postWordExercisesCheck', tag: postWordExercisesCheckTag, inProgress: false);
  }

  retryWordQuestions() async {
    Navigator.popUntil(
      context!,
      (route) => route.isFirst ? true : false,
    );
    Navigator.pushNamed(context!, Routes.wordExercisesPage);
  }

  Future<void> getTestQuestions() async {
    safeBlock(() async {
      if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
        setBusy(true, tag: getWordExercisesTag);
        if (!isLevelTest) {
          await levelTestRepository.getWordQuestions();
        } else {
          await levelTestRepository.getTestQuestions();
        }
        setSuccess(tag: getWordExercisesTag);
      } else {
        setBusy(false, tag: getWordExercisesTag);
        callBackError(LocaleKeys.no_internet.tr());
      }
    }, callFuncName: 'getWordExercises', tag: getWordExercisesTag, inProgress: false);
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
