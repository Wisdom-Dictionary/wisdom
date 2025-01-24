import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/data/model/phrases_with_all.dart';
import 'package:wisdom/presentation/components/custom_expandable_widget.dart';

import '../../config/constants/assets.dart';
import '../../config/constants/constants.dart';
import '../pages/word_detail/viewmodel/word_detail_page_viewmodel.dart';

class ParentWidget extends ViewModelWidget<WordDetailPageViewModel> {
  ParentWidget({
    super.key,
    required this.model,
    required this.orderNum,
  });

  final ParentsWithAll model;
  final String orderNum;

  final ExpandableController controller = ExpandableController();
  ValueNotifier<bool> expanded = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context, viewModel) {
    controller.addListener(() {
      expanded.value = controller.value;
    });
    GlobalKey widgetKey = GlobalKey();
    return Container(
      padding: const EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              width: 1,
              color: isDarkTheme ? AppColors.darkForm : AppColors.borderWhite,
              style: BorderStyle.solid),
        ),
      ),
      child: model.parents!.linkWord != null && model.parents!.linkWord!.isNotEmpty
          ? Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      text: (viewModel.parentsWithAllList.length != 1) ? "$orderNum. " : "",
                      style: AppTextStyle.font15W700Normal.copyWith(
                          color: isDarkTheme ? AppColors.white : AppColors.darkGray,
                          fontSize: viewModel.fontSize! - 2),
                      children: [
                        TextSpan(
                          text: orderNum == "1"
                              ? "${model.parents!.wordClassBodyMeaning ?? ""} "
                              : "${model.parents!.wordClassBody ?? ""} ",
                          style: AppTextStyle.font15W400Normal.copyWith(
                              color: AppColors.paleGray, fontSize: viewModel.fontSize! - 2),
                        ),
                        viewModel.conductAndHighlightUzWords(model.wordsUz, null, null),
                      ],
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () => viewModel.localViewModel.goByLink(model.parents!.linkWord ?? ""),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        model.parents!.wordClassBodyMeaning ?? "",
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
                        model.parents!.linkWord ?? "",
                        style: AppTextStyle.font13W500Normal.copyWith(
                          color: isDarkTheme ? AppColors.white : AppColors.blue,
                          fontSize: (viewModel.fontSize! - 4),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          : ValueListenableBuilder(
              valueListenable: expanded,
              builder: (BuildContext context, bool value, Widget? child) {
                return ExpandablePanel(
                  controller: controller,
                  theme: const ExpandableThemeData(
                    tapHeaderToExpand: true,
                    tapBodyToCollapse: false,
                    tapBodyToExpand: false,
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    iconColor: AppColors.blue,
                    iconSize: 32,
                    iconPadding: EdgeInsets.zero,
                  ),
                  header: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () =>
                              viewModel.addToWordBankFromParent(model, orderNum, widgetKey),
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 6.w, right: 16.w, top: 14.h, bottom: 14.h),
                            child: SvgPicture.asset(
                              Assets.icons.saveWord,
                              color: AppColors.blue,
                            ),
                          ),
                        ),
                        model.parents!.star != "0"
                            ? Padding(
                                padding: EdgeInsets.only(right: 10.w),
                                child: SvgPicture.asset(viewModel.findRank(model.parents!.star!)))
                            : const SizedBox.shrink(),
                        Flexible(
                          child: Text.rich(TextSpan(
                            text: (viewModel.parentsWithAllList.length != 1) ? "$orderNum. " : "",
                            style: AppTextStyle.font15W700Normal.copyWith(
                                color: isDarkTheme ? AppColors.white : AppColors.darkGray,
                                fontSize: viewModel.fontSize! - 2),
                            children: [
                              TextSpan(
                                text: orderNum == "1"
                                    ? "${model.parents!.wordClassBodyMeaning ?? ""} "
                                    : "${model.parents!.wordClassBody ?? ""} ",
                                style: AppTextStyle.font15W400Normal.copyWith(
                                    color: AppColors.paleGray, fontSize: viewModel.fontSize! - 2),
                              ),
                              viewModel.conductAndHighlightUzWords(model.wordsUz, null, null),
                            ],
                          )),
                        )
                      ],
                    ),
                  ),
                  expanded: value
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Example
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10.w),
                                  child: HtmlWidget(
                                    (model.parents!.example ?? "")
                                        .replaceAll("<br>", "")
                                        .replaceAll("<p>", "")
                                        .replaceAll("</p>", "<br>"),
                                    textStyle: AppTextStyle.font15W400ItalicHtml.copyWith(
                                        fontSize: viewModel.fontSize! - 2,
                                        color: isDarkTheme
                                            ? AppColors.lightBackground
                                            : AppColors.gray),
                                  ),
                                ),
                              ),
                              // examples
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10.w),
                                  child: HtmlWidget(
                                    (model.parents!.examples ?? "")
                                        .replaceAll("<br>", "")
                                        .replaceAll("<p>", "")
                                        .replaceAll("</p>", "<br>"),
                                    textStyle: AppTextStyle.font15W400ItalicHtml.copyWith(
                                        fontSize: viewModel.fontSize! - 2,
                                        color: isDarkTheme
                                            ? AppColors.lightBackground
                                            : AppColors.gray),
                                  ),
                                ),
                              ),
                              // Synonyms
                              CustomExpandableWidget(
                                title: "synonyms".tr(),
                                body: HtmlWidget(
                                  (model.parents!.synonyms ?? "")
                                      .replaceAll("<br>", "")
                                      .replaceAll("<p>", "")
                                      .replaceAll("</p>", "<br>"),
                                  textStyle: AppTextStyle.font13W400ItalicHtml.copyWith(
                                      color:
                                          isDarkTheme ? AppColors.lightBackground : AppColors.gray,
                                      fontSize: viewModel.fontSize! - 2),
                                ),
                                visible: model.parents!.synonyms != null,
                                viewModel: viewModel,
                              ),
                              // Antonym
                              CustomExpandableWidget(
                                title: "antonims".tr(),
                                body: HtmlWidget(
                                  (model.parents!.anthonims ?? "")
                                      .replaceAll("<br>", "")
                                      .replaceAll("<p>", "")
                                      .replaceAll("</p>", "<br>"),
                                  textStyle: AppTextStyle.font13W400ItalicHtml.copyWith(
                                      color:
                                          isDarkTheme ? AppColors.lightBackground : AppColors.gray,
                                      fontSize: viewModel.fontSize! - 2),
                                ),
                                visible: model.parents!.anthonims != null,
                                viewModel: viewModel,
                              ),
                              // Grammar
                              CustomExpandableWidget(
                                title: "grammar".tr(),
                                body: HtmlWidget(
                                  (model.grammar != null ? model.grammar!.first.body ?? "" : "")
                                      .replaceAll("<br>", "")
                                      .replaceAll("<p>", "")
                                      .replaceAll("</p>", "<br>"),
                                  textStyle: AppTextStyle.font13W400ItalicHtml.copyWith(
                                      color:
                                          isDarkTheme ? AppColors.lightBackground : AppColors.gray,
                                      fontSize: viewModel.fontSize! - 2),
                                ),
                                visible: model.grammar != null && model.grammar!.isNotEmpty,
                                viewModel: viewModel,
                              ),
                              //Difference
                              CustomExpandableWidget(
                                title: "difference".tr(),
                                body: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      (model.difference != null
                                          ? model.difference!.first.word ?? ""
                                          : ""),
                                      style: AppTextStyle.font15W400Normal.copyWith(
                                          color: isDarkTheme ? AppColors.white : AppColors.darkGray,
                                          fontSize: viewModel.fontSize! - 2),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.h),
                                      child: HtmlWidget(
                                        (model.difference != null
                                                ? model.difference!.first.body ?? ""
                                                : "")
                                            .replaceAll("<br>", "")
                                            .replaceAll("<p>", "")
                                            .replaceAll("</p>", "<br>"),
                                        textStyle: AppTextStyle.font13W400ItalicHtml.copyWith(
                                            color: isDarkTheme
                                                ? AppColors.lightBackground
                                                : AppColors.gray,
                                            fontSize: viewModel.fontSize! - 2),
                                      ),
                                    )
                                  ],
                                ),
                                visible: model.difference != null && model.difference!.isNotEmpty,
                                viewModel: viewModel,
                              ),
                              // Collocations
                              CustomExpandableWidget(
                                title: "collocations".tr(),
                                body: HtmlWidget(
                                  (model.collocation != null
                                          ? model.collocation!.first.body ?? ""
                                          : "")
                                      .replaceAll("<br>", "")
                                      .replaceAll("<p>", "")
                                      .replaceAll("</p>", "<br>"),
                                  textStyle: AppTextStyle.font13W400ItalicHtml.copyWith(
                                      color:
                                          isDarkTheme ? AppColors.lightBackground : AppColors.gray,
                                      fontSize: viewModel.fontSize! - 2),
                                ),
                                visible: model.collocation != null && model.collocation!.isNotEmpty,
                                viewModel: viewModel,
                              ),
                              // Thesaurus
                              CustomExpandableWidget(
                                title: "thesaurus".tr(),
                                body: HtmlWidget(
                                  (model.thesaurus != null ? model.thesaurus!.first.body ?? "" : "")
                                      .replaceAll("<br>", "")
                                      .replaceAll("<p>", "")
                                      .replaceAll("</p>", "<br>"),
                                  textStyle: AppTextStyle.font13W400ItalicHtml.copyWith(
                                      color:
                                          isDarkTheme ? AppColors.lightBackground : AppColors.gray,
                                      fontSize: viewModel.fontSize! - 2),
                                ),
                                visible: model.thesaurus != null && model.thesaurus!.isNotEmpty,
                                viewModel: viewModel,
                              ),
                              // Metaphors
                              CustomExpandableWidget(
                                title: "metaphor".tr(),
                                body: HtmlWidget(
                                  (model.metaphor != null ? model.metaphor!.first.body ?? "" : "")
                                      .replaceAll("<br>", "")
                                      .replaceAll("<p>", "")
                                      .replaceAll("</p>", "<br>"),
                                  textStyle: AppTextStyle.font13W400ItalicHtml.copyWith(
                                      color:
                                          isDarkTheme ? AppColors.lightBackground : AppColors.gray,
                                      fontSize: viewModel.fontSize! - 2),
                                ),
                                visible: model.metaphor != null && model.metaphor!.isNotEmpty,
                                viewModel: viewModel,
                              ),
                              // Culture
                              CustomExpandableWidget(
                                title: "culture".tr(),
                                body: HtmlWidget(
                                  (model.culture != null ? model.culture!.first.body ?? "" : "")
                                      .replaceAll("<br>", "")
                                      .replaceAll("<p>", "")
                                      .replaceAll("</p>", "<br>"),
                                  textStyle: AppTextStyle.font13W400ItalicHtml.copyWith(
                                      color:
                                          isDarkTheme ? AppColors.lightBackground : AppColors.gray,
                                      fontSize: viewModel.fontSize! - 2),
                                ),
                                visible: model.culture != null && model.culture!.isNotEmpty,
                                viewModel: viewModel,
                              ),
                              // More examples
                              CustomExpandableWidget(
                                title: "more_example".tr(),
                                body: HtmlWidget(
                                  (model.parents!.moreExamples != null
                                          ? model.parents!.moreExamples ?? ""
                                          : "")
                                      .replaceAll("<br>", "")
                                      .replaceAll("<p>", "")
                                      .replaceAll("</p>", "<br>"),
                                  textStyle: AppTextStyle.font13W400ItalicHtml.copyWith(
                                      color:
                                          isDarkTheme ? AppColors.lightBackground : AppColors.gray,
                                      fontSize: viewModel.fontSize! - 2),
                                ),
                                visible: model.parents!.moreExamples != null &&
                                    model.parents!.moreExamples!.isNotEmpty,
                                viewModel: viewModel,
                              ),
                              // Phrases and Idioms
                              // CustomExpandableWidget(
                              //   title: "words_phrases".tr(),
                              //   viewModel: viewModel,
                              //   isExpanded: viewModel.hasToBeExpanded(model.phrasesWithAll),
                              //   body: (model.phrasesWithAll != null && model.phrasesWithAll!.isNotEmpty)
                              //       ? ListView.builder(
                              //           shrinkWrap: true,
                              //           physics: const NeverScrollableScrollPhysics(),
                              //           itemCount: model.phrasesWithAll!.length,
                              //           itemBuilder: (context, index) {
                              //             var phraseModel = model.phrasesWithAll![index];
                              //             bool isSelected = viewModel.isWordEqual(phraseModel.phrases!.pWord ?? "") &&
                              //                 viewModel.getFirstPhrase;
                              //             if (viewModel.localViewModel.isSearchByUz) {
                              //               isSelected = viewModel.isWordContained(
                              //                       viewModel.conductToStringPhrasesTranslate(
                              //                           phraseModel.phrasesTranslate ?? [])) &&
                              //                   viewModel.getFirstPhrase;
                              //             }
                              //             if (isSelected) {
                              //               viewModel.firstAutoScroll();
                              //             }
                              //             return Container(
                              //               key: isSelected ? viewModel.scrollKey : null,
                              //               child: PhrasesWidget(model: phraseModel, orderNum: '1', index: index),
                              //             );
                              //           },
                              //         )
                              //       : const SizedBox.shrink(),
                              //   visible: model.phrasesWithAll != null && model.phrasesWithAll!.isNotEmpty,
                              // ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                  collapsed: const SizedBox.shrink(),
                );
              },
            ),
    );
  }
}
