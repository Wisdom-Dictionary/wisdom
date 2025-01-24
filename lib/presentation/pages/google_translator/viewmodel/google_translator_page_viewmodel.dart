import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jbaza/jbaza.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:translator/translator.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/word_entity_repository.dart';
import '../../../../config/constants/app_colors.dart';
import '../../../../core/services/purchase_observer.dart';
import '../../../../data/model/word_bank_model.dart';
import '../../../routes/routes.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/loading_widget.dart';

class GoogleTranslatorPageViewModel extends BaseViewModel {
  GoogleTranslatorPageViewModel({
    required super.context,
    required this.localViewModel,
    required this.wordEntityRepository,
  });

  final translator = GoogleTranslator();
  final LocalViewModel localViewModel;
  final WordEntityRepository wordEntityRepository;
  FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;
  bool isListening = false;
  bool topUzbek = true;

  Future? dialog;
  final TextEditingController folderTextController = TextEditingController();
  ValueNotifier<int> changer = ValueNotifier<int>(1);

  void exchangeLanguages() {
    topUzbek = !topUzbek;
    notifyListeners();
  }

  translate(String text, TextEditingController controller) async {
    if (text.isNotEmpty) {
      int count = localViewModel.preferenceHelper.getInt(Constants.KEY_TRANSLATE_COUNT, 0);
      String dateString = localViewModel.preferenceHelper.getString(Constants.KEY_DATE, "");
      DateTime dateTime = DateTime.now();
      bool isNextDay = false;
      if (dateString.isNotEmpty) {
        dateTime = DateTime.parse(dateString);
        isNextDay = (dateTime.day < DateTime.now().day) &&
            (dateTime.month < DateTime.now().month) &&
            (dateTime.year < DateTime.now().year);
      }
      if (count != 1 || isNextDay || PurchasesObserver().isPro()) {
        safeBlock(
          () async {
            var translated = "";
            if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
              translated = await translator
                  .translate(text, from: topUzbek ? "uz" : "en", to: topUzbek ? "en" : "uz")
                  .then((value) => value.text);
              controller.text = translated;
              localViewModel.preferenceHelper
                  .putString(Constants.KEY_DATE, DateTime.now().toString());
              if (!PurchasesObserver().isPro()) {
                localViewModel.preferenceHelper.putInt(Constants.KEY_TRANSLATE_COUNT, 1);
              } else {
                localViewModel.preferenceHelper.putInt(Constants.KEY_TRANSLATE_COUNT, 0);
              }
              setSuccess();
            } else {
              callBackError("no_internet".tr());
              setSuccess();
            }
          },
          callFuncName: 'translate',
          // inProgress: true,
        );
      } else {
        showCustomDialog(
          context: context!,
          icon: Assets.icons.translateOutline,
          iconColor: AppColors.accentLight,
          iconBackgroundColor: AppColors.error,
          contentWidget: Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Text(
              'translate_inform'.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyle.font15W600Normal
                  .copyWith(color: isDarkTheme ? AppColors.lightGray : AppColors.darkGray),
            ),
          ),
          positive: "buy_pro".tr(),
          onPositiveTap: () {
            navigateTo(Routes.gettingProPage);
          },
          negative: "watch_ad".tr(),
          onNegativeTap: () async {
            if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
              localViewModel.showInterstitialAd();
              localViewModel.preferenceHelper.putInt(Constants.KEY_TRANSLATE_COUNT, 0);
              pop();
            } else {
              callBackError('no_internet'.tr());
            }
          },
        );
      }
    }
  }

  goMain() {
    FocusScope.of(context!).unfocus();
    localViewModel.changePageIndex(0);
  }

  Future<void> readText(String text) async {
    if (isSpeaking) {
      flutterTts.stop();
    } else {
      await flutterTts.setLanguage("en-US");
      await flutterTts.speak(text);
    }
  }

  Future<String> voiceToText() async {
    String resultText = "";
    Duration duration = const Duration(seconds: 5);
    SpeechToText speech = SpeechToText();
    bool available = await speech.initialize();
    if (available) {
      await speech.listen(
        listenFor: duration,
        onResult: (result) {
          resultText = result.recognizedWords;
        },
      );
    } else {
      log("The user has denied the use of speech recognition.");
    }
    await Future.delayed(duration);
    return resultText;
  }

  void startListening() {
    isListening = true;
    notifyListeners();
  }

  void stopListening() {
    isListening = false;
    notifyListeners();
  }

  funAddToWordBank(String wordEng, String wordUz, GlobalKey? key) async {
    safeBlock(() async {
      int dbCount = await wordEntityRepository.getWordBankCount();
      if (dbCount > 29 && !PurchasesObserver().isPro()) {
        showCountOutOfBound();
        return;
      } else {
        return showCustomDialog(
          icon: Assets.icons.saveWord,
          iconColor: AppColors.blue,
          iconBackgroundColor: AppColors.borderWhite,
          context: context!,
          contentWidget: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              changer.addListener(() {
                setState(() {});
              });
              return SizedBox(
                width: 300.h,
                height: 300.h,
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: wordEntityRepository.wordBankFoldersList.length,
                    itemBuilder: (context, index) {
                      var item = wordEntityRepository.wordBankFoldersList[index];
                      if (item.id != 2) {
                        return Container(
                          decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.borderWhite))),
                          child: ListTile(
                            title: Text(item.folderName,
                                style:
                                    AppTextStyle.font15W600Normal.copyWith(color: AppColors.blue)),
                            onTap: () async {
                              var bankModel = WordBankModel(
                                  word: wordEng, translation: wordUz, folderId: item.id);

                              await wordEntityRepository.saveWordBank(bankModel);
                              if (key != null) {
                                localViewModel.runAddToCartAnimation(key);
                              }
                              localViewModel.changeBadgeCount(1);

                              notifyListeners();
                              pop();
                            },
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
              );
            },
          ),
          negative: "new_word_bank_type".tr(),
          onNegativeTap: () async {
            if (!PurchasesObserver().isPro() &&
                wordEntityRepository.wordBankFoldersList.length >= 3) {
              showFolderCountOutOfBound();
            } else {
              addNewFolder();
            }
          },
        );
      }
    }, callFuncName: 'funAddToWordBank', inProgress: false);
  }

  void addNewFolder() {
    showCustomDialog(
      context: context!,
      icon: Assets.icons.addFolder,
      iconColor: AppColors.blue,
      iconBackgroundColor: AppColors.borderWhite,
      contentWidget: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: TextField(
          controller: folderTextController,
          decoration: InputDecoration(
            hintText: "folder_name_hint".tr(),
            border: const OutlineInputBorder(),
          ),
          style: AppTextStyle.font15W600Normal.copyWith(color: AppColors.blue),
        ),
      ),
      positive: "add".tr(),
      onPositiveTap: () async {
        if (folderTextController.text.isNotEmpty) {
          await wordEntityRepository.addNewWordBankFolder(folderTextController.text);
          changer.value++;
          pop();
        }
      },
      negative: "cancel".tr(),
      onNegativeTap: () async {
        pop();
      },
    );
  }

  showFolderCountOutOfBound() {
    showCustomDialog(
      context: context!,
      icon: Assets.icons.addFolder,
      iconColor: AppColors.accentLight,
      iconBackgroundColor: AppColors.error,
      contentWidget: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: Text(
          'new_folder_bound_info'.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyle.font15W600Normal
              .copyWith(color: isDarkTheme ? AppColors.lightGray : AppColors.darkGray),
        ),
      ),
      positive: "buy_pro".tr(),
      onPositiveTap: () {
        navigateTo(Routes.gettingProPage);
      },
      // negative: "watch_ad".tr(),
      // onNegativeTap: () async {
      //   if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
      //     localViewModel.showInterstitialAd();
      //     localViewModel.boundException = true;
      //     // localViewModel.preferenceHelper.putInt(Constants.KEY_TRANSLATE_COUNT, 0);
      //     pop();
      //   } else {
      //     callBackError('no_internet'.tr());
      //   }
      // },
    );
  }

  showCountOutOfBound() {
    showCustomDialog(
      context: context!,
      icon: Assets.icons.saveWord,
      iconColor: AppColors.accentLight,
      iconBackgroundColor: AppColors.error,
      contentWidget: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: Text(
          'word_bank_add_info'.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyle.font15W600Normal
              .copyWith(color: isDarkTheme ? AppColors.lightGray : AppColors.darkGray),
        ),
      ),
      positive: "buy_pro".tr(),
      onPositiveTap: () {
        navigateTo(Routes.gettingProPage);
      },
    );
  }

  @override
  callBackBusy(bool value, String? tag) {
    if (dialog == null && isBusy(tag: tag)) {
      Future.delayed(Duration.zero, () {
        dialog = showLoadingDialog(context!);
      });
    }
  }

  @override
  callBackSuccess(value, String? tag) {
    if (dialog != null) {
      pop();
      dialog = null;
    }
  }

  @override
  callBackError(String text) {
    Future.delayed(Duration.zero, () {
      if (dialog != null) pop();
    });
    showTopSnackBar(
      Overlay.of(context!),
      CustomSnackBar.error(
        message: text,
      ),
    );
  }
}
