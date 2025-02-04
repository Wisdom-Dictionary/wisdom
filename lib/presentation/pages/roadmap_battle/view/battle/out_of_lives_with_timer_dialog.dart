import 'package:flutter/material.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/presentation/components/w_button.dart';

class OutOfLivesWithTimerDialog extends StatelessWidget {
  const OutOfLivesWithTimerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: ClampingScrollPhysics(),
      padding: const EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 24),
      shrinkWrap: true,
      children: [
        Text(
          "You didn’t start the battle!",
          textAlign: TextAlign.center,
          style: AppTextStyle.font17W600Normal.copyWith(fontSize: 18, color: AppColors.orange),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              Text(
                "We couldn't find you an opponent.",
                textAlign: TextAlign.center,
                style: AppTextStyle.font13W500Normal.copyWith(color: AppColors.black, fontSize: 14),
              ),
              SizedBox(
                height: 16,
              ),
              Text.rich(
                textAlign: TextAlign.center,
                style: AppTextStyle.font13W500Normal.copyWith(color: AppColors.gray),
                TextSpan(
                  children: [
                    TextSpan(
                        text:
                            "Please wait a bit and don't forget to collect your lives when the time is right! You will get your next lives after "),
                    TextSpan(
                      text: '10:59',
                      style: AppTextStyle.font13W500Normal.copyWith(color: AppColors.blue),
                    ),
                    TextSpan(text: ' minutes'),
                  ],
                ),
              )
            ],
          ),
        ),
        WButton(
          title: "Got it",
          onTap: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
