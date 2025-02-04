import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/presentation/components/w_button.dart';
import 'package:wisdom/presentation/routes/routes.dart';

class StartBattleDialog extends StatelessWidget {
  const StartBattleDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: ClampingScrollPhysics(),
      padding: const EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 24),
      shrinkWrap: true,
      children: [
        Text(
          "Battle",
          textAlign: TextAlign.center,
          style: AppTextStyle.font17W600Normal.copyWith(fontSize: 18, color: AppColors.blue),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: SizedBox(
              height: 164,
              width: 164,
              child: Image.asset(
                Assets.icons.crossSwords,
                fit: BoxFit.contain,
              )),
        ),
        Text(
          "Word Battleda qatnashish",
          textAlign: TextAlign.center,
          style: AppTextStyle.font13W500Normal.copyWith(fontSize: 14, color: AppColors.black),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          "Siz keyingi bosqichga o’tish uchun Word Battleda g’olib bo’lishingiz kerakBattle qonuniga ko’ra savollar 20tadaniborat bo’ladi hamda opponent onlinetarzda random belgilab beriladi.",
          textAlign: TextAlign.center,
          style: AppTextStyle.font13W500Normal.copyWith(fontSize: 12, color: AppColors.gray),
        ),
        SizedBox(
          height: 32,
        ),
        Row(
          children: [
            Expanded(
              child: WButton(
                titleStyle: AppTextStyle.font15W500Normal.copyWith(color: AppColors.blue),
                color: AppColors.lavender,
                title: "Cancel",
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
                title: "Start",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, Routes.searchingOpponentPage);
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
