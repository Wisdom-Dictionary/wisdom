import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jbaza/jbaza.dart';
import 'package:selectable/selectable.dart';
import 'package:wisdom/config/constants/app_decoration.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/urls.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/presentation/components/parent_widget.dart';
import 'package:wisdom/presentation/components/phrases_widget.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/word_details_page_viewmodel.dart';
import 'package:wisdom/presentation/pages/word_detail/viewmodel/word_detail_page_viewmodel.dart';
import 'package:wisdom/presentation/routes/routes.dart';
import 'package:wisdom/presentation/widgets/custom_app_bar.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/assets.dart';
import '../../../../config/constants/constants.dart';
import '../../../widgets/loading_widget.dart';

class WordDetailsPage extends ViewModelBuilderWidget<WordDetailPageViewModel> {
  WordDetailsPage({super.key});

  SelectableController textSelectionControls = SelectableController();
  ExpandableController controller = ExpandableController();

  @override
  void onViewModelReady(WordDetailPageViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  void onDestroy(WordDetailPageViewModel model) {
    super.onDestroy(model);
  }

  @override
  Widget builder(BuildContext context, WordDetailPageViewModel viewModel, Widget? child) {
    GlobalKey globalKey = GlobalKey();
    return Selectable(
      selectionController: textSelectionControls,
      popupMenuItems: [
        SelectableMenuItem(
            title: "Search",
            isEnabled: (controller) => controller!.isTextSelected,
            icon: Icons.search_rounded,
            handler: (controller) {
              if (controller != null && (controller.getSelection()!.text ?? "").isNotEmpty) {
                viewModel.localViewModel.goByLink(controller.getSelection()!.text ?? "");
              }
              return true;
            }),
        const SelectableMenuItem(type: SelectableMenuItemType.copy, icon: Icons.copy_outlined),
        SelectableMenuItem(
            title: "Share",
            isEnabled: (controller) => controller!.isTextSelected,
            icon: Icons.share_rounded,
            handler: (controller) {
              if (controller != null && (controller.getSelection()!.text ?? "").isNotEmpty) {
                viewModel.localViewModel.shareWord(controller.getSelection()!.text!);
              }
              return true;
            }),
      ],
      child: WillPopScope(
        onWillPop: () async {
          if (textSelectionControls.isTextSelected) {
            textSelectionControls.deselect();
          } else {
            Navigator.of(context).pop();
          }
          return false;
        },
        child: Scaffold(
          backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
          resizeToAvoidBottomInset: true,
          appBar: CustomAppBar(
            title: viewModel.localViewModel.wordDetailModel.word ?? "unknown",
            onTap: () => Navigator.of(context).pop(),
            leadingIcon: Assets.icons.arrowLeft,
          ),
          body: viewModel.isSuccess(tag: viewModel.initTag)
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    (viewModel.wordEntityRepository.requiredWordWithAllModel.word!.linkWord !=
                                null &&
                            viewModel.wordEntityRepository.requiredWordWithAllModel.word!.linkWord!
                                .isNotEmpty)
                        // Link words
                        ? ListView(
                            padding:
                                EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w, bottom: 70.h),
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              Container(
                                decoration: isDarkTheme
                                    ? AppDecoration.bannerDarkDecor
                                    : AppDecoration.bannerDecor,
                                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 28.h),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 25.w),
                                            child: Text(
                                              viewModel.wordEntityRepository
                                                      .requiredWordWithAllModel.word!.word ??
                                                  "unknown",
                                              style: AppTextStyle.font17W700Normal.copyWith(
                                                  color: isDarkTheme
                                                      ? AppColors.white
                                                      : AppColors.darkGray,
                                                  fontSize: viewModel.fontSize),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () => viewModel.textToSpeech(),
                                            child: SvgPicture.asset(Assets.icons.sound,
                                                color: AppColors.blue)),
                                        viewModel.wordEntityRepository.requiredWordWithAllModel
                                                    .word!.star !=
                                                "0"
                                            ? Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                                child: SvgPicture.asset(viewModel.findRank(viewModel
                                                    .wordEntityRepository
                                                    .requiredWordWithAllModel
                                                    .word!
                                                    .star!)),
                                              )
                                            : SizedBox(width: 10.w),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 15.h, right: 75.w),
                                      child: Flex(
                                        direction: Axis.horizontal,
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  viewModel
                                                          .wordEntityRepository
                                                          .requiredWordWithAllModel
                                                          .word!
                                                          .wordClasswordClass ??
                                                      "",
                                                  style: AppTextStyle.font15W500Normal.copyWith(
                                                      color: isDarkTheme
                                                          ? AppColors.white
                                                          : AppColors.darkGray,
                                                      fontSize: (viewModel.fontSize! - 2)),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 5.w),
                                                  child: HtmlWidget(
                                                    "  ${viewModel.wordEntityRepository.requiredWordWithAllModel.word!.wordClassBody ?? ""}",
                                                    textStyle: AppTextStyle.font15W400NormalHtml
                                                        .copyWith(
                                                            color: AppColors.paleGray,
                                                            fontSize: viewModel.fontSize),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () => viewModel.localViewModel.goByLink(viewModel
                                              .wordEntityRepository
                                              .requiredWordWithAllModel
                                              .word!
                                              .linkWord ??
                                          ""),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            viewModel.wordEntityRepository.requiredWordWithAllModel
                                                    .word!.wordClassBodyMeaning ??
                                                "",
                                            style: AppTextStyle.font13W500Normal.copyWith(
                                              color: isDarkTheme ? AppColors.gray : AppColors.gray,
                                              fontSize: (viewModel.fontSize! - 4),
                                            ),
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 18,
                                            color: AppColors.blue,
                                          ),
                                          Text(
                                            viewModel.wordEntityRepository.requiredWordWithAllModel
                                                    .word!.linkWord ??
                                                "",
                                            style: AppTextStyle.font13W500Normal.copyWith(
                                              color: isDarkTheme
                                                  ? AppColors.white
                                                  : AppColors.darkGray,
                                              fontSize: (viewModel.fontSize! - 4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ValueListenableBuilder(
                                valueListenable: viewModel.localViewModel.isNetworkAvailable,
                                builder: (BuildContext context, value, Widget? child) {
                                  return viewModel.localViewModel.banner != null && value as bool
                                      ? Container(
                                          margin: EdgeInsets.only(top: 16.h),
                                          decoration: isDarkTheme
                                              ? AppDecoration.bannerDarkDecor
                                              : AppDecoration.bannerDecor,
                                          height:
                                              viewModel.localViewModel.banner!.size.height * 1.0,
                                          child: AdWidget(
                                            ad: viewModel.localViewModel.banner!..load(),
                                          ))
                                      : const SizedBox.shrink();
                                },
                              ),
                            ],
                          )
                        // for regular words
                        : ListView(
                            padding:
                                EdgeInsets.only(top: 14.h, left: 14.w, right: 14.w, bottom: 70.h),
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              Container(
                                decoration: isDarkTheme
                                    ? AppDecoration.bannerDarkDecor
                                    : AppDecoration.bannerDecor,
                                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 28.h),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 10.w),
                                            child: Text(
                                              viewModel.wordEntityRepository
                                                      .requiredWordWithAllModel.word!.word ??
                                                  "unknown",
                                              style: AppTextStyle.font17W700Normal.copyWith(
                                                  color: isDarkTheme
                                                      ? AppColors.white
                                                      : AppColors.darkGray,
                                                  fontSize: viewModel.fontSize),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => viewModel.textToSpeech(),
                                          child: Container(
                                            height: 52.h,
                                            width: 52.w,
                                            padding: EdgeInsets.all(14.w),
                                            child: SvgPicture.asset(
                                              Assets.icons.sound,
                                              color: AppColors.blue,
                                            ),
                                          ),
                                        ),
                                        viewModel.wordEntityRepository.requiredWordWithAllModel
                                                    .word!.star !=
                                                "0"
                                            ? Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                                child: SvgPicture.asset(
                                                  viewModel.findRank(viewModel.wordEntityRepository
                                                      .requiredWordWithAllModel.word!.star!),
                                                ),
                                              )
                                            : SizedBox(width: 10.w),
                                        InkWell(
                                          onTap: () => viewModel.addAllWords(globalKey),
                                          child: Container(
                                            height: 52.h,
                                            width: 52.w,
                                            padding: EdgeInsets.all(14.w),
                                            key: globalKey,
                                            child: SvgPicture.asset(
                                              Assets.icons.saveWord,
                                              color: AppColors.blue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 75.w),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  viewModel
                                                          .wordEntityRepository
                                                          .requiredWordWithAllModel
                                                          .word!
                                                          .wordClasswordClass ??
                                                      "",
                                                  style: AppTextStyle.font15W500Normal.copyWith(
                                                      color: isDarkTheme
                                                          ? AppColors.white
                                                          : AppColors.darkGray,
                                                      fontSize: viewModel.fontSize),
                                                ),
                                                Flexible(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(left: 5.w),
                                                    child: Text(
                                                      "  ${viewModel.wordEntityRepository.requiredWordWithAllModel.word!.wordClassBody ?? ""}",
                                                      style: AppTextStyle.font15W400NormalHtml
                                                          .copyWith(
                                                              color: AppColors.paleGray,
                                                              fontSize: viewModel.fontSize! - 2),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: viewModel.wordEntityRepository
                                                  .requiredWordWithAllModel.word!.image !=
                                              null,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: InkWell(
                                              onTap: () => viewModel.showPhotoView(),
                                              child: Container(
                                                height: 66.h,
                                                padding: EdgeInsets.all(2.r),
                                                width: 66.h,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(9.r),
                                                  // color: AppColors.lightBlue,
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(9.r),
                                                  child: viewModel
                                                              .wordEntityRepository
                                                              .requiredWordWithAllModel
                                                              .word!
                                                              .image !=
                                                          null
                                                      ? Image.network(
                                                          Urls.baseUrl +
                                                              viewModel
                                                                  .wordEntityRepository
                                                                  .requiredWordWithAllModel
                                                                  .word!
                                                                  .image!,
                                                          fit: BoxFit.scaleDown,
                                                        )
                                                      : const SizedBox.shrink(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: viewModel.parentsWithAllList.length,
                                      padding: EdgeInsets.only(bottom: 15.h),
                                      itemBuilder: (context, index) {
                                        var item = viewModel.parentsWithAllList[index];
                                        bool isSelected = false;
                                        if (!viewModel.localViewModel.isSearchByUz) {
                                          isSelected = viewModel.isWordContained(
                                                  viewModel.conductToString(item.wordsUz ?? [])) &&
                                              viewModel.getFirstPhrase;
                                        }
                                        if (isSelected) {
                                          viewModel.firstAutoScroll();
                                        }
                                        return Container(
                                          key: isSelected ? viewModel.scrollKey : null,
                                          child: ParentWidget(
                                            model: item,
                                            orderNum: "${index + 1}",
                                          ),
                                        );
                                      },
                                    ),
                                    Visibility(
                                      visible: viewModel.parentsWithAllList.last.phrasesWithAll !=
                                              null &&
                                          viewModel
                                              .parentsWithAllList.last.phrasesWithAll!.isNotEmpty,
                                      child: ExpandablePanel(
                                        theme: const ExpandableThemeData(
                                          tapHeaderToExpand: true,
                                          tapBodyToCollapse: false,
                                          tapBodyToExpand: false,
                                          headerAlignment: ExpandablePanelHeaderAlignment.center,
                                          iconColor: AppColors.blue,
                                          iconSize: 32,
                                          iconPadding: EdgeInsets.zero,
                                        ),
                                        controller: ExpandableController(
                                            initialExpanded: controller.expanded =
                                                viewModel.hasToBeExpanded(viewModel
                                                    .parentsWithAllList.last.phrasesWithAll)),
                                        header: Center(
                                          child: Text(
                                            "words_phrases".tr(),
                                            style: AppTextStyle.font18W500Normal.copyWith(
                                                color: AppColors.blue,
                                                fontSize: viewModel.fontSize! + 2,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        expanded: (viewModel
                                                        .parentsWithAllList.last.phrasesWithAll !=
                                                    null &&
                                                viewModel.parentsWithAllList.last.phrasesWithAll!
                                                    .isNotEmpty)
                                            ? ListView.builder(
                                                shrinkWrap: true,
                                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount: viewModel
                                                    .parentsWithAllList.last.phrasesWithAll!.length,
                                                itemBuilder: (context, index) {
                                                  var phraseModel = viewModel.parentsWithAllList
                                                      .last.phrasesWithAll![index];
                                                  bool isSelected = viewModel.isWordEqual(
                                                          phraseModel.phrases!.pWord ?? "") &&
                                                      viewModel.getFirstPhrase;
                                                  if (viewModel.localViewModel.isSearchByUz) {
                                                    isSelected = viewModel.isWordContained(viewModel
                                                            .conductToStringPhrasesTranslate(
                                                                phraseModel.phrasesTranslate ??
                                                                    [])) &&
                                                        viewModel.getFirstPhrase &&
                                                        viewModel.isWordEqual(
                                                            phraseModel.phrases!.pWord ?? "");
                                                  }
                                                  if (phraseModel.parentPhrasesWithAll != null &&
                                                      phraseModel
                                                          .parentPhrasesWithAll!.isNotEmpty) {
                                                    bool subSelected = false;
                                                    for (var model
                                                        in phraseModel.parentPhrasesWithAll!) {
                                                      subSelected = viewModel.isWordContained(viewModel
                                                              .conductToStringParentPhrasesTranslate(
                                                                  model.parentPhrasesTranslate ??
                                                                      [])) &&
                                                          viewModel.getFirstPhrase &&
                                                          viewModel.isWordEqual(
                                                              phraseModel.phrases!.pWord ?? "");
                                                    }
                                                    if (subSelected) {
                                                      isSelected = subSelected;
                                                    }
                                                  }
                                                  if (isSelected) {
                                                    viewModel.firstAutoScroll();
                                                  }
                                                  return Container(
                                                    key: isSelected ? viewModel.scrollKey : null,
                                                    child: PhrasesWidget(
                                                        model: phraseModel,
                                                        orderNum: '1',
                                                        index: index,
                                                        isSelected: isSelected),
                                                  );
                                                },
                                              )
                                            : const SizedBox.shrink(),
                                        collapsed: const SizedBox.shrink(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ValueListenableBuilder(
                                valueListenable: viewModel.localViewModel.isNetworkAvailable,
                                builder: (BuildContext context, value, Widget? child) {
                                  return viewModel.localViewModel.banner != null && value as bool
                                      ? Container(
                                          margin: EdgeInsets.only(top: 16.h),
                                          decoration: isDarkTheme
                                              ? AppDecoration.bannerDarkDecor
                                              : AppDecoration.bannerDecor,
                                          height:
                                              viewModel.localViewModel.banner!.size.height * 1.0,
                                          child: AdWidget(
                                            ad: viewModel.localViewModel.banner!..load(),
                                          ))
                                      : const SizedBox.shrink();
                                },
                              ),
                            ],
                          ),
                    Positioned(
                        bottom: 31,
                        left: 16,
                        right: 16,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.r), color: AppColors.blue),
                          height: 45.h,
                          margin: EdgeInsets.only(top: 40.h, bottom: 12.h),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, Routes.wordExercisesPage);
                              },
                              borderRadius: BorderRadius.circular(40.r),
                              child: Center(
                                child: Flexible(
                                  child: Text(
                                    'start_the_exercises'.tr(),
                                    style: AppTextStyle.font15W500Normal,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
                  ],
                )
              : const Center(
                  child: LoadingWidget(),
                ),
        ),
      ),
    );
  }

  @override
  WordDetailPageViewModel viewModelBuilder(BuildContext context) {
    return WordDetailPageViewModel(
        context: context,
        // searchRepository: locator.get(),
        localViewModel: locator.get(),
        wordEntityRepository: locator.get(),
        wordMapper: locator.get(),
        preferenceHelper: locator.get());
  }
}
