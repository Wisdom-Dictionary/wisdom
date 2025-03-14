import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/presentation/components/w_button.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/battle_result_viewmodel.dart';

class OpponentWasNotFoundDialog extends StatelessWidget {
  const OpponentWasNotFoundDialog({super.key, required this.viewmodel});

  final BattleResultViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Material(
            borderRadius: BorderRadius.circular(18),
            color: isDarkTheme ? AppColors.darkGray : AppColors.white,
            child: ListView(
              physics: ClampingScrollPhysics(),
              padding: const EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 24),
              shrinkWrap: true,
              children: [
                Text(
                  "Oops...",
                  textAlign: TextAlign.center,
                  style:
                      AppTextStyle.font17W600Normal.copyWith(fontSize: 18, color: AppColors.orange),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    "we_could_not_find_you_an_opponent".tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyle.font13W500Normal
                        .copyWith(color: AppColors.black, fontSize: 14),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: WButton(
                        titleStyle: AppTextStyle.font15W500Normal.copyWith(color: AppColors.blue),
                        color: AppColors.lavender,
                        title: "cancel".tr(),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: WButton(
                        title: "try_again".tr(),
                        onTap: () {
                          Navigator.pop(context);
                          viewmodel.showRematchDialog();
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
