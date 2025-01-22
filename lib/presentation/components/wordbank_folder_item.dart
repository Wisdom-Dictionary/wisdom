import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/domain/entities/word_bank_folder_entity.dart';
import 'package:wisdom/presentation/pages/word_bank/viewmodel/wordbank_folder_viewmodel.dart';

class WordBankFolderItem extends ViewModelWidget<WordBankFolderViewModel> {
  const WordBankFolderItem({
    required this.model,
    required this.wordCount,
  });

  final WordBankFolderEntity model;
  final int wordCount;

  @override
  Widget build(BuildContext context, WordBankFolderViewModel viewModel) {
    return InkWell(
      onTap: () => viewModel.goToBankList(model),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                width: 1, color: isDarkTheme ? AppColors.darkForm : AppColors.borderWhite, style: BorderStyle.solid),
          ),
        ),
        child: Padding(
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
                    text: model.folderName,
                    children: [
                      TextSpan(
                          text: "  ($wordCount)",
                          style: AppTextStyle.font15W500Normal
                              .copyWith(color: isDarkTheme ? AppColors.borderWhite : AppColors.paleGray)),
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
                              onTap: () => viewModel.goToBankList(model),
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
                  Visibility(
                    visible: model.id != 1 && model.id != 2,
                    child: SizedBox(
                      height: 48.h,
                      width: 48.h,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => viewModel.deleteWordBankFolder(model),
                          borderRadius: BorderRadius.circular(24.r),
                          child: SvgPicture.asset(
                            Assets.icons.trash,
                            height: 24.h,
                            width: 24.h,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
