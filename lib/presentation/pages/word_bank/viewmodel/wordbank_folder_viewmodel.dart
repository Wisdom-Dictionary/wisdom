import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jbaza/jbaza.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/core/domain/entities/def_enum.dart';
import 'package:wisdom/data/model/word_bank_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/entities/word_bank_folder_entity.dart';
import 'package:wisdom/domain/repositories/word_entity_repository.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_text_style.dart';
import '../../../../config/constants/assets.dart';
import '../../../../config/constants/constants.dart';
import '../../../../core/services/purchase_observer.dart';
import '../../../routes/routes.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/loading_widget.dart';

class WordBankFolderViewModel extends BaseViewModel {
  WordBankFolderViewModel({
    required super.context,
    required this.wordEntityRepository,
    required this.localViewModel,
  });

  final WordEntityRepository wordEntityRepository;
  final LocalViewModel localViewModel;
  final TextEditingController folderTextController = TextEditingController();
  final TextEditingController uzTextController = TextEditingController();
  final TextEditingController engTextController = TextEditingController();
  final String getWordBankFoldersListTag = 'getWordBankFoldersListTag';
  Future? dialog;

  getWordBankFolders() {
    safeBlock(
      () async {
        await wordEntityRepository.getWordBankFolders();
        await wordEntityRepository.getWordBankCount();
        setSuccess(tag: getWordBankFoldersListTag);
      },
      callFuncName: 'getWordBankFolders',
    );
  }

  goBackToMain() {
    localViewModel.changePageIndex(0);
  }

  goToBankList(WordBankFolderEntity model) {
    if (model.id == 1) {
      localViewModel.folderId = null;
    } else {
      localViewModel.folderId = model.id;
    }
    localViewModel.changePageIndex(1);
  }

  goToExercisePage() {
    if (wordEntityRepository.wordBankList.isNotEmpty) {
      var tryCount = localViewModel.preferenceHelper.getInt(Constants.EXERCISE_COUNT, 3);
      String dateString = localViewModel.preferenceHelper
          .getString(Constants.EXERCISE_DATE, DateTime.now().toString());
      DateTime dateTime = DateTime.now();
      bool isToday = true;
      if (dateString.isNotEmpty) {
        dateTime = DateTime.parse(dateString);
        isToday = (dateTime.day == DateTime.now().day) &&
            (dateTime.month == DateTime.now().month) &&
            (dateTime.year == DateTime.now().year);
      }
      if (!isToday) tryCount = 3;
      if (tryCount != 0 || PurchasesObserver().isPro()) {
        tryCount--;
        localViewModel.preferenceHelper.putInt(Constants.EXERCISE_COUNT, tryCount);
        localViewModel.preferenceHelper
            .putString(Constants.EXERCISE_DATE, DateTime.now().toString());
        showExerciseOption();
      } else {
        showCustomDialog(
          icon: Assets.icons.exercise,
          iconColor: AppColors.accentLight,
          iconBackgroundColor: AppColors.error,
          context: context!,
          contentWidget: Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Text(
              'exercise_info'.tr(),
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
              pop();
              showExerciseOption();
            } else {}
          },
        );
      }
    } else {
      showTopSnackBar(
        Overlay.of(context!),
        const CustomSnackBar.info(
          message: "No words to train",
        ),
      );
    }
  }

  void addNewFolder() {
    if (!PurchasesObserver().isPro() && wordEntityRepository.wordBankFoldersList.length >= 3) {
      showFolderCountOutOfBound();
    } else {
      showCustomDialog(
        context: context!,
        icon: Assets.icons.addFolder,
        iconColor: AppColors.blue,
        iconBackgroundColor: AppColors.borderWhite,
        contentWidget: Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: TextField(
            controller: folderTextController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "folder_name_hint".tr(),
              hintStyle: AppTextStyle.font15W600Normal
                  .copyWith(color: isDarkTheme ? AppColors.gray : AppColors.blue),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isDarkTheme ? AppColors.white : AppColors.blue,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isDarkTheme ? AppColors.white : AppColors.blue,
                ),
              ),
            ),
            style: AppTextStyle.font15W600Normal.copyWith(color: AppColors.blue),
          ),
        ),
        positive: "add".tr(),
        onPositiveTap: () async {
          if (folderTextController.text.isNotEmpty) {
            await wordEntityRepository.addNewWordBankFolder(folderTextController.text);
            notifyListeners();
            pop();
          }
        },
        negative: "cancel".tr(),
        onNegativeTap: () async {
          pop();
        },
      );
    }
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
    );
  }

  void addNewWord() {
    showCustomDialog(
      context: context!,
      icon: Assets.icons.saveWord,
      iconColor: AppColors.blue,
      iconBackgroundColor: AppColors.borderWhite,
      contentWidget: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: engTextController,
              decoration: InputDecoration(
                hintText: "new_word_eng".tr(),
                hintStyle: AppTextStyle.font15W600Normal
                    .copyWith(color: isDarkTheme ? AppColors.gray : AppColors.blue),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkTheme ? AppColors.white : AppColors.blue,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkTheme ? AppColors.white : AppColors.blue,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkTheme ? AppColors.white : AppColors.blue,
                  ),
                ),
              ),
              style: AppTextStyle.font15W600Normal.copyWith(color: AppColors.blue),
            ),
            SizedBox(
              height: 10.h,
            ),
            TextField(
              controller: uzTextController,
              decoration: InputDecoration(
                hintText: "new_word_uz".tr(),
                hintStyle: AppTextStyle.font15W600Normal
                    .copyWith(color: isDarkTheme ? AppColors.gray : AppColors.blue),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkTheme ? AppColors.white : AppColors.blue,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkTheme ? AppColors.white : AppColors.blue,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkTheme ? AppColors.white : AppColors.blue,
                  ),
                ),
              ),
              style: AppTextStyle.font15W600Normal.copyWith(color: AppColors.blue),
            ),
          ],
        ),
      ),
      positive: "add".tr(),
      onPositiveTap: () async {
        if (uzTextController.text.isNotEmpty && engTextController.text.isNotEmpty) {
          funAddToWordBank(engTextController.text, uzTextController.text);
        }
      },
      negative: "cancel".tr(),
      onNegativeTap: () async {
        pop();
      },
    );
  }

  funAddToWordBank(String wordEng, String wordUz) async {
    safeBlock(() async {
      int dbCount = await wordEntityRepository.getWordBankCount();
      if (dbCount > 29 && !PurchasesObserver().isPro()) {
        showFolderCountOutOfBound();
        return;
      } else {
        return showCustomDialog(
          icon: Assets.icons.saveWord,
          iconColor: AppColors.blue,
          iconBackgroundColor: AppColors.borderWhite,
          context: context!,
          contentWidget: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              addListener(() {
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
                              localViewModel.changeBadgeCount(1);

                              notifyListeners();
                              pop();
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

  void showExerciseOption() {
    showCustomDialog(
      context: context!,
      icon: Assets.icons.exercise,
      iconColor: AppColors.blue,
      iconBackgroundColor: AppColors.borderWhite,
      contentWidget: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: Text(
          'exercise_option'.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyle.font15W600Normal
              .copyWith(color: isDarkTheme ? AppColors.lightGray : AppColors.darkGray),
        ),
      ),
      positive: "flashcard".tr(),
      onPositiveTap: () {
        pop();
        localViewModel.exerciseType = ExerciseType.flipCard;
      },
      negative: "matching".tr(),
      onNegativeTap: () async {
        pop();
        localViewModel.exerciseType = ExerciseType.matching;
        localViewModel.changePageIndex(19);
      },
    );
  }

  deleteWordBankFolder(WordBankFolderEntity model) {
    showCustomDialog(
      context: context!,
      icon: Assets.icons.trash,
      iconColor: AppColors.accentLight,
      iconBackgroundColor: AppColors.error,
      contentWidget: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: Text(
          'delete_folder_info'.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyle.font15W600Normal
              .copyWith(color: isDarkTheme ? AppColors.lightGray : AppColors.darkGray),
        ),
      ),
      positive: "delete".tr(),
      onPositiveTap: () {
        safeBlock(
          () async {
            wordEntityRepository.wordBankList
                .where((element) => element.folderId == model.id)
                .forEach((element) {
              localViewModel.changeBadgeCount(-1);
            });
            await wordEntityRepository.deleteWordBankFolder(model.id);
            notifyListeners();
          },
          callFuncName: 'deleteWordBankModel',
          inProgress: false,
        );
        pop();
      },
      negative: "cancel".tr(),
      onNegativeTap: () async {
        pop();
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
