import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:jbaza/jbaza.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/presentation/pages/home/viewmodel/home_viewmodel.dart';
import 'package:wisdom/presentation/routes/routes.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/assets.dart';
import '../../../../config/constants/constants.dart';
import '../../../../core/di/app_locator.dart';
import '../../../../core/services/purchase_observer.dart';
import '../../../components/drawer_menu_item.dart';

class DrawerScreen extends ViewModelWidget<HomeViewModel> {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    final bool isLoggedIn =
        locator.get<SharedPreferenceHelper>().getString(Constants.KEY_TOKEN, '') != '';
    log('isLoggedIn: $isLoggedIn');
    return Scaffold(
      backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: InkWell(
            onTap: () => ZoomDrawer.of(context)!.toggle(),
            child: SvgPicture.asset(
              Assets.icons.crossClose,
              height: 24.h,
              width: 24.h,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 0, top: 40.h, bottom: 50.h),
              child: SvgPicture.asset(
                isDarkTheme ? Assets.icons.logoWhiteText : Assets.icons.logoBlueText,
                fit: BoxFit.scaleDown,
                height: 45.h,
                width: 152.w,
              ),
            ),
            Visibility(
              visible: !PurchasesObserver().isPro(),
              child: DrawerMenuItem(
                title: LocaleKeys.subscribe.tr(),
                imgAssets: Assets.icons.proVersion,
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.gettingProPage);
                  // var phone = viewModel.localViewModel.preferenceHelper.getString(Constants.KEY_PHONE, "");
                  // if (phone.isNotEmpty) {
                  //   Navigator.of(context).pushNamed(Routes.verifyPage, arguments: {'number': phone});
                  // } else {
                  //   Navigator.of(context).pushNamed(Routes.gettingProPage);
                  // }
                },
              ),
            ),
            DrawerMenuItem(
              title: isLoggedIn ? LocaleKeys.personal_cabinet.tr() : LocaleKeys.login.tr(),
              imgAssets: Assets.icons.person,
              onTap: () {
                isLoggedIn
                    ? Navigator.of(context).pushNamed(Routes.profilePage)
                    : viewModel.navigateTo(Routes.loginPage);
                ZoomDrawer.of(context)!.toggle();
              },
            ),
            DrawerMenuItem(
              title: LocaleKeys.contacts.tr(),
              imgAssets: Assets.icons.giveAd,
              onTap: () => Navigator.of(context).pushNamed(Routes.givingAdPage),
            ),
            DrawerMenuItem(
              title: 'settings'.tr(),
              imgAssets: Assets.icons.setting,
              onTap: () => Navigator.of(context).pushNamed(Routes.settingPage).then(
                    (value) => viewModel.notifyListeners(),
                  ),
            ),
            DrawerMenuItem(
              title: 'for_desk'.tr(),
              imgAssets: Assets.icons.desktop,
              onTap: () => launchUrl(Uri.parse('http://Wisdomlugati.uz')),
            ),
            DrawerMenuItem(
              title: 'abbreviations'.tr(),
              imgAssets: Assets.icons.abbreviations,
              onTap: () => Navigator.of(context).pushNamed(Routes.abbreviationPage),
            ),
            DrawerMenuItem(
              title: 'rate_app'.tr(),
              imgAssets: Assets.icons.rate,
              onTap: () => viewModel.rateApp(),
            ),
            DrawerMenuItem(
              title: 'share_app'.tr(),
              imgAssets: Assets.icons.share,
              onTap: () => viewModel.shareApp(),
            ),
            DrawerMenuItem(
              title: 'about'.tr(),
              imgAssets: Assets.icons.info,
              onTap: () {
                Navigator.of(context).pushNamed(Routes.aboutUsPage);
              },
            ),
          ],
        ),
      ),
    );
  }
}
