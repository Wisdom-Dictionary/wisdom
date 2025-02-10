import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/presentation/components/w_button.dart';
import 'package:wisdom/presentation/routes/routes.dart';

class SignInDialog extends StatelessWidget {
  const SignInDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 18, top: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "unlock_your_learning_journey".tr(),
            style: AppTextStyle.font17W600Normal.copyWith(fontSize: 18, color: AppColors.green),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Text(
              "sign_in_content".tr(),
              textAlign: TextAlign.center,
              style: AppTextStyle.font13W500Normal.copyWith(color: AppColors.black, fontSize: 14),
            ),
          ),
          WButton(
            title: "sign_in".tr(),
            onTap: () {
              Navigator.pushNamed(context, Routes.registrationPage);
            },
          ),
          const SizedBox(
            height: 13,
          ),
          WButton(
            titleColor: AppColors.blue,
            color: AppColors.lavender,
            title: "later".tr(),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
