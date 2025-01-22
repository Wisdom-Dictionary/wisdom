import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';

import '../../../app.dart';
import '../../../config/constants/app_decoration.dart';
import '../../../config/constants/assets.dart';
import '../../../config/constants/constants.dart';
import '../../../core/services/purchase_observer.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/my_url.dart';

class AboutWisdomPage extends StatelessWidget {
  const AboutWisdomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CustomAppBar(
        title: 'about'.tr(),
        onTap: () => Navigator.of(context).pop(),
        leadingIcon: Assets.icons.arrowLeft,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 20.h),
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(top: 30.h, left: 18.w, right: 18.w),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  isDarkTheme ? Assets.icons.logoWhiteText : Assets.icons.logoBlueText,
                  height: 52.h,
                  fit: BoxFit.scaleDown,
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.h),
                  padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 20.w),
                  decoration: isDarkTheme ? AppDecoration.bannerDarkDecor : AppDecoration.bannerDecor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HtmlWidget(
                        "about_content".tr(),
                        textStyle:
                            AppTextStyle.font15W400NormalHtml.copyWith(color: isDarkTheme ? AppColors.white : null),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RichText(
                              text: myUrl('Restore Purchase', '', textColor: AppColors.blue, underline: false,
                                  onTap: () async {
                                try {
                                  await PurchasesObserver().callRestorePurchases();
                                  if (PurchasesObserver().isPro()) {
                                    Future.delayed(const Duration(milliseconds: 100), () => MyApp.restartApp(context));
                                  }
                                } catch (e) {
                                  log(e.toString());
                                }
                              }),
                            ),
                            RichText(
                              text:
                                  myUrl('Privacy', Constants.PRIVACY_URL, textColor: AppColors.blue, underline: false),
                            ),
                            RichText(
                              text: myUrl('Terms', Constants.TERMS_URL, textColor: AppColors.blue, underline: false),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
