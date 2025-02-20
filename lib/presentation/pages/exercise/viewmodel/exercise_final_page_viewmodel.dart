import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jbaza/jbaza.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/data/model/exercise_model.dart';
import 'package:wisdom/data/model/word_bank_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/word_entity_repository.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_text_style.dart';
import '../../../../config/constants/assets.dart';
import '../../../../config/constants/constants.dart';
import '../../../../core/services/purchase_observer.dart';
import '../../../routes/routes.dart';
import '../../../widgets/custom_dialog.dart';

class ExerciseFinalPageViewModel extends BaseViewModel {
  ExerciseFinalPageViewModel({
    required super.context,
    required this.localViewModel,
    required this.wordEntityRepository,
  });

  final LocalViewModel localViewModel;
  final WordEntityRepository wordEntityRepository;

  List<ExerciseFinalModel> correctList = [];
  List<ExerciseFinalModel> incorrect = [];

  init() async {
    final wrongFolderId = wordEntityRepository.wrongFolderId;
    for (var element in localViewModel.finalList) {
      element.result ? correctList.add(element) : incorrect.add(element);
    }
    for (var element in incorrect) {
      await wordEntityRepository.moveToFolder(wrongFolderId, element.tableId!, element.id);
    }
    notifyListeners();
  }

  goBack() {
    localViewModel.changePageIndex(23);
  }

  ValueNotifier<int> changer = ValueNotifier<int>(1);
  final TextEditingController folderTextController = TextEditingController();

  moveToFolder(ExerciseFinalModel model) {
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
                            title: Text(item.folderName.tr(),
                                style:
                                    AppTextStyle.font15W600Normal.copyWith(color: AppColors.blue)),
                            onTap: () async {
                              await wordEntityRepository
                                  .moveToFolder(item.id, model.tableId!, model.id)
                                  .then((value) {
                                if (value) {
                                  incorrect
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
              await addNewFolder();
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

  Future addNewFolder() async {
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
        if (!(await localViewModel.canAddWordBank(context!))) {
          return;
        }
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

  deleteWordBank(ExerciseFinalModel model) {
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
            var wordBank = WordBankModel(
                id: model.id,
                word: model.word,
                translation: model.translation,
                tableId: model.tableId);
            await wordEntityRepository.deleteWorkBank(wordBank);
            localViewModel.finalList.remove(model);
            correctList.remove(model);
            await localViewModel.changeBadgeCount(-1);
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
}
