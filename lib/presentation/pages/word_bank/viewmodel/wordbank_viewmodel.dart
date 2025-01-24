import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jbaza/jbaza.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/core/domain/entities/def_enum.dart';
import 'package:wisdom/data/model/word_bank_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/word_entity_repository.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_text_style.dart';
import '../../../../config/constants/assets.dart';
import '../../../../config/constants/constants.dart';
import '../../../../core/services/purchase_observer.dart';
import '../../../../data/model/recent_model.dart';
import '../../../routes/routes.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/loading_widget.dart';

class WordBankViewModel extends BaseViewModel {
  WordBankViewModel({
    required super.context,
    required this.wordEntityRepository,
    required this.localViewModel,
  });

  final WordEntityRepository wordEntityRepository;
  final LocalViewModel localViewModel;
  final String getWordBankListTag = 'getWordBankListTag';
  Future? dialog;

  ValueNotifier<int> changer = ValueNotifier<int>(1);
  final TextEditingController folderTextController = TextEditingController();

  getWordBankList() {
    safeBlock(
      () async {
        await wordEntityRepository.getWordBankList(localViewModel.folderId);
        setSuccess(tag: getWordBankListTag);
      },
      callFuncName: 'getWordBankList',
    );
  }

  goBackToMain() {
    localViewModel.changePageIndex(23);
  }

  moveToFolder(WordBankModel model) {
    safeBlock(
      () async {
        showCustomDialog(
          icon: Assets.icons.move,
          iconColor: AppColors.blue,
          iconBackgroundColor: AppColors.borderWhite,
          context: context!,
          title: 'folder_move'.tr(),
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
                            onTap: () {
                              wordEntityRepository
                                  .moveToFolder(item.id, model.tableId!, model.id!)
                                  .then((value) {
                                if (value) {
                                  wordEntityRepository.wordBankList
                                      .removeWhere((element) => element.tableId == model.tableId);
                                } else {
                                  showTopSnackBar(
                                    Overlay.of(context),
                                    CustomSnackBar.info(
                                      message: "move_info".tr(),
                                    ),
                                  );
                                }
                                notifyListeners();
                                pop();
                              });
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
                wordEntityRepository.wordBankFoldersList.length <= 3) {
              showFolderCountOutOfBound();
            } else {
              addNewFolder();
            }
          },
        );
      },
      callFuncName: 'moveToFolder',
      inProgress: false,
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
    );
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
          context: context!,
          icon: Assets.icons.exercise,
          iconColor: AppColors.accentLight,
          iconBackgroundColor: AppColors.error,
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
              tryCount++;
              localViewModel.preferenceHelper.putInt(Constants.EXERCISE_COUNT, tryCount);
              localViewModel.preferenceHelper
                  .putString(Constants.EXERCISE_DATE, DateTime.now().toString());
              pop();
              showExerciseOption();
            } else {
              callBackError('no_internet'.tr());
            }
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
        // localViewModel.changePageIndex(24);
        showLanguageOption();
      },
      negative: "matching".tr(),
      onNegativeTap: () async {
        pop();
        localViewModel.exerciseType = ExerciseType.matching;
        localViewModel.changePageIndex(19);
      },
    );
  }

  void showLanguageOption() {
    showCustomDialog(
      context: context!,
      icon: Assets.icons.changeLangTranslate,
      iconColor: AppColors.blue,
      iconBackgroundColor: AppColors.borderWhite,
      contentWidget: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: Text(
          'exercise_language_option'.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyle.font15W600Normal
              .copyWith(color: isDarkTheme ? AppColors.lightGray : AppColors.darkGray),
        ),
      ),
      positive: "EN->UZ",
      onPositiveTap: () {
        pop();
        localViewModel.exerciseLangOption = "en";
        localViewModel.changePageIndex(21);
      },
      negative: "UZ->EN",
      onNegativeTap: () async {
        pop();
        localViewModel.exerciseLangOption = "uz";
        localViewModel.changePageIndex(21);
      },
    );
  }

  deleteWordBank(WordBankModel model) {
    showCustomDialog(
      context: context!,
      icon: Assets.icons.trash,
      iconColor: AppColors.accentLight,
      iconBackgroundColor: AppColors.error,
      contentWidget: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: Text(
          'delete_word_info'.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyle.font15W600Normal
              .copyWith(color: isDarkTheme ? AppColors.lightGray : AppColors.darkGray),
        ),
      ),
      positive: "delete".tr(),
      onPositiveTap: () {
        safeBlock(
          () async {
            await wordEntityRepository.deleteWorkBank(model);
            localViewModel.changeBadgeCount(-1);
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

  goToDetail(WordBankModel model) {
    localViewModel.isFromMain = false;
    localViewModel.detailToFromBank = true;
    RecentModel recentModel = RecentModel();
    recentModel = RecentModel(
        id: model.parentId,
        word: model.word,
        wordClass: model.translation,
        type: model.type,
        same: "");
    localViewModel.isSearchByUz = true;
    localViewModel.wordDetailModel = recentModel;
    localViewModel.changePageIndex(18);
  }
}
