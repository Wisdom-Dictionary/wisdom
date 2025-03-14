import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/presentation/components/w_button.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/life_countdown_provider.dart';

class OutOfLivesDialog extends StatelessWidget {
  const OutOfLivesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(18.0)),
              child: ListView(
                physics: ClampingScrollPhysics(),
                padding: const EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 24),
                shrinkWrap: true,
                children: [
                  Text(
                    "you_did_not_start_the_battle".tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyle.font17W600Normal
                        .copyWith(fontSize: 18, color: AppColors.orange),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Text(
                    "you_do_not_have_enough_lives".tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyle.font13W500Normal
                        .copyWith(fontSize: 14, color: AppColors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ValueListenableBuilder(
                    valueListenable:
                        ValueNotifier<int>(context.watch<CountdownProvider>().remainingSeconds),
                    builder: (context, value, child) {
                      return Text.rich(
                        textAlign: TextAlign.center,
                        style: AppTextStyle.font13W500Normal.copyWith(color: AppColors.gray),
                        TextSpan(
                          children: [
                            TextSpan(text: "lives_timer_leading_text".tr()),
                            TextSpan(
                                text: CountdownProvider.timerString(value),
                                style:
                                    AppTextStyle.font13W500Normal.copyWith(color: AppColors.blue)),
                            TextSpan(text: 'lives_timer_trailing_text'.tr()),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  WButton(
                    title: "got_it".tr(),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
