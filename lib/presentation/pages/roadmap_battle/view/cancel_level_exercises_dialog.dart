import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/presentation/components/w_button.dart';
import 'package:wisdom/presentation/routes/routes.dart';

class CancelLevelExercisesDialog extends StatelessWidget {
  const CancelLevelExercisesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "cancel_level_exercises_content".tr(),
            textAlign: TextAlign.center,
            style: AppTextStyle.font15W500Normal.copyWith(fontSize: 14, color: AppColors.darkGray),
          ),
          SizedBox(
            height: 32,
          ),
          Row(
            children: [
              Expanded(
                child: WButton(
                  titleColor: AppColors.blue,
                  color: AppColors.lavender,
                  title: "exit".tr(),
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: WButton(
                  title: "continue".tr(),
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
