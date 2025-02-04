import 'package:flutter/material.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/presentation/components/w_button.dart';

class OpponentWasNotFoundDialog extends StatelessWidget {
  const OpponentWasNotFoundDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: ClampingScrollPhysics(),
      padding: const EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 24),
      shrinkWrap: true,
      children: [
        Text(
          "Oops...",
          textAlign: TextAlign.center,
          style: AppTextStyle.font17W600Normal.copyWith(fontSize: 18, color: AppColors.orange),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Text(
            "We couldn't find you an opponent.",
            textAlign: TextAlign.center,
            style: AppTextStyle.font13W500Normal.copyWith(color: AppColors.black, fontSize: 14),
          ),
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
                title: "Try again",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
