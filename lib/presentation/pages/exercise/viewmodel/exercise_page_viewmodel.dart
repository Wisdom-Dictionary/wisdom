import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jbaza/jbaza.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/domain/entities/def_enum.dart';
import 'package:wisdom/core/utils/text_reader.dart';
import 'package:wisdom/data/model/exercise_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/presentation/pages/exercise/view/exercise_crosword_page.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_text_style.dart';
import '../../../../config/constants/assets.dart';
import '../../../../config/constants/constants.dart';
import '../../../../data/model/word_bank_model.dart';
import '../../../../domain/repositories/word_entity_repository.dart';
import '../../../widgets/custom_dialog.dart';

class ExercisePageViewModel extends BaseViewModel {
  ExercisePageViewModel({
    required super.context,
    required this.localViewModel,
    required this.wordEntityRepository,
  });

  FlipCardController flipCardController = FlipCardController();

  final LocalViewModel localViewModel;
  final WordEntityRepository wordEntityRepository;
  String gettingReadyTag = "gettingReadyTag";
  TextReader textReader = locator.get();

  List<ExerciseModel> uzbList = [];
  List<ExerciseModel> englishList = [];
  List<WordBankModel> wordBankList = [];
  List<WordBankModel> setList = [];
  late List<String> emptyList = [];
  late List<String> shuffledList = [];
  String isCorrect = '';

  int minLength = 0;

  int flipIndex = 0;

  int engSelectedIndex = -1;
  int uzSelectedIndex = -1;

  int listEngIndex = -1;
  int listUzIndex = -1;

  int tryNumber = 3;

  init() {
    safeBlock(() async {
      if (localViewModel.exerciseType == ExerciseType.matching) {
        await getMinLength();
        await splitting();
      } else {
        minLength = wordEntityRepository.wordBankList.length;
        wordBankList.addAll(wordEntityRepository.wordBankList);
        splittingForFlip();
      }
      shuffledList.addAll(englishList.first.word.shuffled.split(''));
      // emptyList.fillRange(0, englishList.first.word.length, '');
      localViewModel.finalList = {};
      setSuccess(tag: gettingReadyTag);
    }, callFuncName: 'init', tag: gettingReadyTag);
  }

  splitting() async {
    if (minLength > 10) minLength = 10;
    while (minLength > englishList.length) {
      var randomIndexEng = Random.secure().nextInt(wordBankList.length);
      var randomIndexUz = Random.secure().nextInt(wordBankList.length);
      var elementEng = wordBankList[randomIndexEng];
      var elementUz = wordBankList[randomIndexUz];
      if (await checkToSameEng(elementEng.word ?? "_") &&
          await checkToSameUz(elementUz.translation ?? "_") &&
          englishList.length <= minLength) {
        englishList.add(ExerciseModel(
            tableId: elementEng.tableId,
            id: elementEng.id,
            word: elementEng.word ?? "",
            wordClass: elementEng.wordClass,
            wordClassBody: elementEng.wordClassBody,
            translation: elementEng.translation!,
            example: elementEng.example));
        uzbList.add(ExerciseModel(
            tableId: elementUz.tableId,
            id: elementUz.id,
            word: elementUz.translation ?? "",
            wordClass: elementUz.wordClass,
            wordClassBody: elementUz.wordClassBody,
            translation: elementUz.translation!,
            example: elementUz.example));
      }
    }
  }

  splittingForFlip() async {
    // while (minLength > englishList.length) {
    //   var randomIndexEng = Random.secure().nextInt(wordBankList.length);
    //   var elementEng = wordBankList[randomIndexEng];
    //   var engModel = ExerciseModel(
    //       tableId: elementEng.tableId,
    //       id: elementEng.id,
    //       word: elementEng.word ?? "",
    //       wordClass: elementEng.wordClass,
    //       wordClassBody: elementEng.wordClassBody,
    //       translation: elementEng.translation!,
    //       example: elementEng.example);
    //   if (!englishList.contains(engModel)) { }}
    wordBankList.shuffle();
    for (var value in wordBankList) {
      var engModel = ExerciseModel(
          tableId: value.tableId,
          id: value.id,
          word: value.word ?? "",
          wordClass: value.wordClass,
          wordClassBody: value.wordClassBody,
          translation: value.translation!,
          example: value.example);
      englishList.add(engModel);
    }
    wordBankList.shuffle();
    for (var value in wordBankList) {
      var uzModel = ExerciseModel(
          tableId: value.tableId,
          id: value.id,
          word: value.translation ?? "",
          wordClass: value.wordClass,
          wordClassBody: value.wordClassBody,
          translation: value.translation!,
          example: value.example);
      uzbList.add(uzModel);
    }
    // while (minLength > uzbList.length) {
    //   var randomIndexUz = Random.secure().nextInt(wordBankList.length);
    //   var elementUz = wordBankList[randomIndexUz];
    //   var uzModel = ExerciseModel(
    //       tableId: elementUz.tableId,
    //       id: elementUz.id,
    //       word: elementUz.translation ?? "",
    //       wordClass: elementUz.wordClass,
    //       wordClassBody: elementUz.wordClassBody,
    //       translation: elementUz.translation!,
    //       example: elementUz.example);
    // if (!uzbList.contains(uzModel)) {
    //   uzbList.add(uzModel);
    // }
    // }
  }

  void textToSpeech(String text) {
    if (text.isNotEmpty) {
      textReader.readText(text);
      // FlutterTts tts = FlutterTts();
      // tts.setSharedInstance(true); // For IOS
      // tts.setLanguage('en-US');
      // tts.speak(text);
    }
  }

  void onRightClicked() async {
    if (flipIndex < minLength) {
      var item = englishList[0];
      localViewModel.finalList.add(ExerciseFinalModel(
          id: item.id, word: item.word, translation: item.translation, result: true, tableId: item.tableId));
      englishList.removeAt(0);
    }
    if (englishList.isEmpty) {
      localViewModel.changePageIndex(20);
      refreshClean();
      return;
    }
    flipCardController.toggleCardWithoutAnimation();
    flipIndex++;
    notifyListeners();
  }

  void onErrorClicked() async {
    if (flipIndex < minLength) {
      var item = englishList[0];
      localViewModel.finalList.add(ExerciseFinalModel(
          id: item.id, word: item.word, translation: item.translation, result: false, tableId: item.tableId));
      englishList.removeAt(0);
      // tryNumber--;
      // if (tryNumber == 0) {
      //   finishTheExercise();
      //   return;
      // }
    }
    if (englishList.isEmpty) {
      localViewModel.changePageIndex(20);
      refreshClean();
    }
    flipCardController.toggleCardWithoutAnimation();
    flipIndex++;
    notifyListeners();
  }

  void checkTheResult() async {
    if ((uzSelectedIndex == engSelectedIndex) && (engSelectedIndex != -1)) {
      notifyListeners();
      textToSpeech("Correct");
      var item = englishList[listEngIndex];
      localViewModel.finalList.add(ExerciseFinalModel(
          id: item.id, word: item.word, translation: item.translation, result: true, tableId: item.tableId));
      showTopSnackBar(
        Overlay.of(context!),
        CustomSnackBar.success(
          message: "correct".tr(),
        ),
      );
      Future.delayed(
        const Duration(milliseconds: 800),
        () {
          englishList.removeAt(listEngIndex);
          uzbList.removeAt(listUzIndex);
          if (englishList.isEmpty) localViewModel.changePageIndex(20);
          refreshClean();
        },
      );
    } else if (engSelectedIndex != -1 && uzSelectedIndex != -1) {
      notifyListeners();
      tryNumber--;
      if (tryNumber == 0) {
        finishTheExercise();
        return;
      }
      var item = englishList[listEngIndex];
      localViewModel.finalList.add(ExerciseFinalModel(
          id: item.id, word: item.word, translation: item.translation, result: false, tableId: item.tableId));
      textToSpeech("Incorrect \n $tryNumber ${tryNumber != 1 ? "tries" : "try"} left");

      showTopSnackBar(
        Overlay.of(context!),
        CustomSnackBar.error(
          message: "${"inCorrect".tr()}\n${"$tryNumber ${tryNumber != 1 ? "tries" : "try"}".tr()} ${"left".tr()}",
        ),
      );
      Future.delayed(
        const Duration(milliseconds: 800),
        () {
          refreshClean();
        },
      );
    }
    notifyListeners();
  }

  void refreshClean() {
    uzSelectedIndex = -1;
    engSelectedIndex = -1;
    listEngIndex = -1;
    listUzIndex = -1;
    notifyListeners();
  }

  Future<bool> checkToSameUz(String word) {
    for (var element in uzbList) {
      if (element.word == word) return Future.value(false);
    }
    return Future.value(true);
  }

  Future<bool> checkToSameEng(String word) {
    for (var element in englishList) {
      if (element.word == word) return Future.value(false);
    }
    return Future.value(true);
  }

  Future<bool> checkToSameBank(String word) {
    for (var element in wordBankList) {
      if (element.word == word) return Future.value(false);
    }
    return Future.value(true);
  }

  Future<bool> checkToSameSet(String word) {
    for (var element in setList) {
      if (element.word == word) return Future.value(false);
    }
    return Future.value(true);
  }

  getMinLength() async {
    minLength = 0;
    for (int i = 0; i < wordEntityRepository.wordBankList.length; i++) {
      if (await checkToSameSet(wordEntityRepository.wordBankList[i].word!)) {
        setList.add(wordEntityRepository.wordBankList[i]);
        minLength++;
      }
    }
    //
    setList.shuffle();
    wordBankList.clear();
    if (minLength > 10) minLength = 10;
    while (minLength > wordBankList.length) {
      var randomInt = Random.secure().nextInt(minLength);
      if (await checkToSameBank(setList[randomInt].word!)) {
        wordBankList.add(setList[randomInt]);
      }
    }
  }

  goBack() {
    // Navigation bardan chiqishda dialog qo'yish kerak
    if (localViewModel.finalList.isNotEmpty) {
      showCustomDialog(
        context: context!,
        icon: Assets.icons.inform,
        iconColor: AppColors.accentLight,
        iconBackgroundColor: AppColors.error,
        contentWidget: Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: Text(
            'finish_text'.tr(),
            textAlign: TextAlign.center,
            style:
                AppTextStyle.font15W600Normal.copyWith(color: isDarkTheme ? AppColors.lightGray : AppColors.darkGray),
          ),
        ),
        positive: "dialogYes".tr(),
        onPositiveTap: () => finishTheExercise(),
        negative: "dialogNo".tr(),
      );
    } else {
      localViewModel.changePageIndex(23);
    }
  }

  void finishTheExercise() {
    for (var item in englishList) {
      localViewModel.finalList.add(ExerciseFinalModel(
          id: item.id ?? 0, word: item.word, translation: item.translation, result: false, tableId: item.tableId));
    }
    localViewModel.changePageIndex(20);
  }

  goToFinish() {
    if (englishList.isNotEmpty) {
      showCustomDialog(
        context: context!,
        icon: Assets.icons.inform,
        iconColor: AppColors.accentLight,
        iconBackgroundColor: AppColors.error,
        contentWidget: Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: Text(
            'finish_text'.tr(),
            textAlign: TextAlign.center,
            style:
                AppTextStyle.font15W600Normal.copyWith(color: isDarkTheme ? AppColors.lightGray : AppColors.darkGray),
          ),
        ),
        positive: "dialogYes".tr(),
        onPositiveTap: () {
          pop(ctx: context!);
          finishTheExercise();
        },
        negative: "dialogNo".tr(),
      );
    } else {
      localViewModel.changePageIndex(20);
    }
  }

  void fillCross(int i) {
    emptyList.add(shuffledList[i]);
    shuffledList.removeAt(i);
    notifyListeners();
  }

  void removeShuffle(int i) {
    if (emptyList.length >= i) {
      shuffledList.add(emptyList[i]);
      emptyList.removeAt(i);
      isCorrect = '';
      notifyListeners();
    }
  }

  void checkCross() async {
    if (emptyList.join('') == englishList.first.word) {
      isCorrect = 't';
      textToSpeech("Correct");
      var item = englishList.first;
      localViewModel.finalList.add(ExerciseFinalModel(
          id: item.id, word: item.word, translation: item.translation, result: true, tableId: item.tableId));
      showTopSnackBar(
        Overlay.of(context!),
        CustomSnackBar.success(
          message: "correct".tr(),
        ),
      );
      notifyListeners();
      Future.delayed(
        const Duration(seconds: 1),
        () {
          if (englishList.length > 1) {
            englishList.removeAt(0);
            isCorrect = '';
            emptyList.clear();
            shuffledList.addAll(englishList.first.word.shuffled.split(''));
            notifyListeners();
          } else {
            finishTheExercise();
            return;
          }
        },
      );
    } else {
      isCorrect = 'f';
      notifyListeners();
      tryNumber--;
      if (tryNumber == 0) {
        finishTheExercise();
        return;
      }
      textToSpeech("Incorrect");
      var item = englishList.first;
      localViewModel.finalList.add(ExerciseFinalModel(
          id: item.id, word: item.word, translation: item.translation, result: false, tableId: item.tableId));
      showTopSnackBar(
        Overlay.of(context!),
        CustomSnackBar.error(
          message: "${"inCorrect".tr()}\n${"$tryNumber ${(tryNumber != 1 ? "tries" : "try").tr()}"} ${"left".tr()}",
        ),
      );
    }
  }
}
