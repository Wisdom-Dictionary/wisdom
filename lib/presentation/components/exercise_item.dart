import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/data/model/exercise_model.dart';

import '../../config/constants/app_colors.dart';

class ExerciseItem extends StatelessWidget {
  const ExerciseItem({
    Key? key,
    required this.isSelected,
    required this.isEven,
    required this.model,
    required this.onTap,
  }) : super(key: key);

  final bool isSelected;
  final bool isEven;
  final ExerciseModel model;
  final Function(int id) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: isEven
              ? isDarkTheme
                  ? AppColors.darkBottomBar
                  : AppColors.borderWhite
              : isDarkTheme
                  ? AppColors.darkForm
                  : AppColors.white,
          border: isSelected ? const Border.fromBorderSide(BorderSide(color: AppColors.accentLight, width: 2)) : null,
          borderRadius: isSelected ? BorderRadius.circular(5.r) : null),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(5.r),
          onTap: () => onTap(model.tableId!),
          child: Container(
            height: 52.h,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(vertical: 8.h).copyWith(left: 5.w),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                  child: Text(
                    model.word,
                    style:
                        AppTextStyle.font15W600Normal.copyWith(color: isDarkTheme ? AppColors.white : AppColors.darkGray),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
