import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_decoration.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/presentation/components/w_button.dart';
import 'package:wisdom/presentation/widgets/new_custom_app_bar.dart';

class SearchingOpponentPage extends StatelessWidget {
  const SearchingOpponentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: NewCustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.5, horizontal: 16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: AppDecoration.resultDecor
                  .copyWith(color: AppColors.bgLightBlue.withValues(alpha: 0.1)),
              child: Row(
                children: [
                  SvgPicture.asset(Assets.icons.userAvatar),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Ali Kamilov",
                          style: AppTextStyle.font17W600Normal
                              .copyWith(fontSize: 18, color: AppColors.blue),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "You",
                          style: AppTextStyle.font13W500Normal
                              .copyWith(fontSize: 12, color: AppColors.blue),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: AppDecoration.battleComponentDecor,
                    child: Row(
                      children: [
                        Text(
                          "1200",
                          style: AppTextStyle.font13W500Normal
                              .copyWith(fontSize: 14, color: AppColors.yellow),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        SvgPicture.asset(Assets.icons.verify)
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: AppDecoration.resultDecor
                  .copyWith(borderRadius: BorderRadius.circular(1000.r), color: AppColors.blue),
              margin: EdgeInsets.symmetric(vertical: 24),
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: Text(
                "VS",
                style: AppTextStyle.font28W600Normal.copyWith(fontSize: 24, color: AppColors.white),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: AppDecoration.resultDecor.copyWith(
                  gradient: LinearGradient(colors: [
                Color(0xFFEB9898),
                Color(0xFFCD0000),
              ])),
              child: Row(
                children: [
                  SvgPicture.asset(Assets.icons.searchingOpponentAvatar),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Text(
                      "Searching\nOpponent...",
                      style: AppTextStyle.font17W600Normal
                          .copyWith(fontSize: 18, color: AppColors.blue),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: AppDecoration.battleComponentDecor,
                    child: Text(
                      "00:03",
                      style: AppTextStyle.font13W500Normal
                          .copyWith(color: AppColors.white, fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: Center(
              child: SvgPicture.asset(
                Assets.icons.searchText,
                height: 96.h,
                width: 96.w,
                colorFilter:
                    ColorFilter.mode(AppColors.blue.withValues(alpha: 0.15), BlendMode.srcIn),
              ),
            )),
            WButton(
              titleStyle:
                  AppTextStyle.font15W500Normal.copyWith(color: AppColors.blue, fontSize: 14),
              color: AppColors.blue.withValues(alpha: 0.15),
              title: "Stop",
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
