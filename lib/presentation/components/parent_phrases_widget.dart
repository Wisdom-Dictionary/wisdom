import 'package:easy_localization/easy_localization.dart';
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

class ParentPhrasesWidget extends ViewModelWidget<WordDetailPageViewModel> {
  ParentPhrasesWidget({
    super.key,
    required this.model,
    required this.orderNum,
  });

  final ParentPhrasesWithAll model;
  final String orderNum;

  @override
  Widget build(BuildContext context, viewModel) {
    GlobalKey widgetKey = GlobalKey();
    return Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   "${model.parentPhrases!.word ?? ""} ",
          //   style: AppTextStyle.font15W700Normal
          //       .copyWith(color: isDarkTheme ? AppColors.white : AppColors.blue, fontSize: viewModel.fontSize! - 2),
          // ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.h, top: 10.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  key: widgetKey,
                  child: Visibility(
                    visible: (model.parentPhrasesTranslate != null &&
                        model.parentPhrasesTranslate!.isNotEmpty),
                    child: InkWell(
                        onTap: () =>
                            viewModel.addToWordBankFromParentPhrase(model, orderNum, widgetKey),
                        child: Padding(
                            padding: EdgeInsets.only(right: 10.w),
                            child: SvgPicture.asset(Assets.icons.saveWord))),
                  ),
                ),
                (model.parentPhrases!.star ?? 0).toString() != "0"
                    ? Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: SvgPicture.asset(
                            viewModel.findRank(model.parentPhrases!.star!.toString())))
                    : const SizedBox.shrink(),
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      text: "$orderNum. ",
                      style: AppTextStyle.font15W700Normal.copyWith(
                          color: isDarkTheme ? AppColors.lightGray : AppColors.gray,
                          fontSize: viewModel.fontSize! - 2),
                      children: [
                        TextSpan(
                          text: "${model.parentPhrases!.wordClassComment ?? ""} ",
                          style: AppTextStyle.font15W400Normal.copyWith(
                              color: isDarkTheme ? AppColors.lightGray : AppColors.gray,
                              fontSize: viewModel.fontSize! - 2),
                        ),
                        viewModel.conductAndHighlightUzWords(
                            null, null, model.parentPhrasesTranslate)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          // Example
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Text(
                (viewModel.conductToStringParentPhrasesExamples(model.phrasesExample)),
                style: AppTextStyle.font15W400ItalicHtml.copyWith(
                    color: isDarkTheme ? AppColors.lightGray : null,
                    fontSize: viewModel.fontSize! - 2),
              ),
            ),
          ),
          // Synonyms
          CustomExpandableWidget(
            title: "synonyms".tr(),
            viewModel: viewModel,
            containerColor: isDarkTheme ? AppColors.darkBackground : AppColors.paleGray,
            body: HtmlWidget(
              (model.parentPhrases!.symonyms ?? "")
                  .replaceAll("<br>", "")
                  .replaceAll("<p>", "")
                  .replaceAll("</p>", "<br>"),
              textStyle: AppTextStyle.font13W400ItalicHtml.copyWith(
                  fontSize: viewModel.fontSize! - 4,
                  color: isDarkTheme ? AppColors.lightBackground : AppColors.white),
            ),
            visible: model.parentPhrases!.symonyms != null,
          ),
        ],
      ),
    );
  }
}
