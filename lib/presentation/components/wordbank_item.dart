import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/data/model/word_bank_model.dart';
import 'package:wisdom/presentation/pages/word_bank/viewmodel/wordbank_viewmodel.dart';

class WordBankItem extends ViewModelWidget<WordBankViewModel> {
  WordBankItem({
    required this.model,
  });

  final WordBankModel model;
  final ExpandableController expandableController = ExpandableController(initialExpanded: false);

  @override
  Widget build(BuildContext context, WordBankViewModel viewModel) {
    return GestureDetector(
      onTap: () => expandableController.value = !expandableController.value,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                width: 1, color: isDarkTheme ? AppColors.darkForm : AppColors.borderWhite, style: BorderStyle.solid),
          ),
        ),
        child: ExpandablePanel(
          theme: const ExpandableThemeData(
            hasIcon: false,
            tapHeaderToExpand: true,
            tapBodyToCollapse: true,
            tapBodyToExpand: true,
          ),
          controller: expandableController,
          header: Padding(
            padding: EdgeInsets.only(left: 30.w, right: 25.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyle.font15W500Normal
                          .copyWith(color: isDarkTheme ? AppColors.borderWhite : AppColors.darkGray),
                      text: model.word ?? "",
                      children: [
                        TextSpan(
                          text: '   ${model.number ?? ""}',
                          style: AppTextStyle.font15W400Normal
                              .copyWith(color: isDarkTheme ? AppColors.white : AppColors.paleGray),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    model.id != null
                        ? SizedBox(
                            height: 48.h,
                            width: 48.h,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => viewModel.goToDetail(model),
                                borderRadius: BorderRadius.circular(24.r),
                                child: SvgPicture.asset(
                                  Assets.icons.arrowCircleRight,
                                  height: 24.h,
                                  width: 24.h,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    viewModel.localViewModel.folderId != null
                        ? SizedBox(
                            height: 48.h,
                            width: 48.h,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => viewModel.moveToFolder(model),
                                borderRadius: BorderRadius.circular(24.r),
                                child: SvgPicture.asset(
                                  Assets.icons.move,
                                  height: 24.h,
                                  width: 24.h,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    SizedBox(
                      height: 48.h,
                      width: 48.h,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => viewModel.deleteWordBank(model),
                          borderRadius: BorderRadius.circular(24.r),
                          child: SvgPicture.asset(
                            Assets.icons.trash,
                            height: 24.h,
                            width: 24.h,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          expanded: Padding(
            padding: EdgeInsets.only(left: 30.w, right: 25.w, bottom: 10),
            child: Text(
              model.translation ?? "",
              style: AppTextStyle.font15W400Normal.copyWith(color: AppColors.paleGray),
              overflow: TextOverflow.clip,
            ),
          ),
          collapsed: const SizedBox.shrink(),
        ),
      ),
    );
  }
}
