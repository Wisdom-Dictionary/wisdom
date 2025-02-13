import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wisdom/data/model/user/user_model.dart';
import 'package:wisdom/presentation/components/about_unit_item_page.dart';
import 'package:wisdom/presentation/pages/abbreviation/abbreviation_page.dart';
import 'package:wisdom/presentation/pages/about_wisdom/about_wisdom.dart';
import 'package:wisdom/presentation/pages/adversitment/giving_ad_page.dart';
import 'package:wisdom/presentation/pages/grammar/view/grammar_page.dart';
import 'package:wisdom/presentation/pages/home/view/home_page.dart';
import 'package:wisdom/presentation/pages/login/login_with_phone_page.dart';
import 'package:wisdom/presentation/pages/login/view/login_page.dart';
import 'package:wisdom/presentation/pages/profile/view/getting_pro_page.dart';
import 'package:wisdom/presentation/pages/profile/view/input_number_page.dart';
import 'package:wisdom/presentation/pages/profile/view/payment_page.dart';
import 'package:wisdom/presentation/pages/profile/view/profile_page.dart';
import 'package:wisdom/presentation/pages/profile/view/verify_page.dart';
import 'package:wisdom/presentation/pages/setting/view/setting_page.dart';

import '../pages/form_page/view/form_page.dart';

class Routes {
  static const mainPage = '/';
  static const grammarPage = '/unit/grammar';
  static const grammarPageabout = '/unit/grammar/about';
  static const gettingProPage = '/profile';
  static const profilePage = '/profile2';
  static const registrationPage = '/profile/registration';
  static const verifyPage = '/profile/registration/verify';
  static const paymentPage = '/profile/payment';
  static const givingAdPage = '/givingAd';
  static const abbreviationPage = '/abbreviation';
  static const settingPage = '/setting';
  static const aboutUsPage = '/aboutUsPage';
  static const loginPage = '/loginPage';
  static const loginWithPhonePage = '/loginWithPhonePage';
  static const formPage = '/formPage';

  static _showRouteName(String routeName) {
    log(routeName);
  }
  static Route<dynamic> generateRoutes(RouteSettings routeSettings) {
    try {
      final Map<String, dynamic>? args =
          routeSettings.arguments as Map<String, dynamic>?;
      args ?? <String, dynamic>{};
      switch (routeSettings.name) {
        case mainPage:
          _showRouteName(mainPage);
          return MaterialPageRoute(
            builder: (_) => HomePage(),
          );
        case grammarPage:
          _showRouteName(grammarPage);
          return MaterialPageRoute(
            builder: (_) => GrammarPage(),
          );
        case gettingProPage:
          _showRouteName(gettingProPage);
          return MaterialPageRoute(
            builder: (_) => GettingProPage(),
          );
        case profilePage:
          _showRouteName(profilePage);
          return MaterialPageRoute(
            builder: (_) => ProfilePage(),
          );
        case registrationPage:
          return MaterialPageRoute(
            builder: (_) => InputNumberPage(),
          );
        case givingAdPage:
          return MaterialPageRoute(
            builder: (_) =>  GivingAdPage(),
          );
        case settingPage:
          return MaterialPageRoute(
            builder: (_) => SettingPage(),
          );
        case abbreviationPage:
          return MaterialPageRoute(
            builder: (_) => const AbbreviationPage(),
          );
        case verifyPage:
          return MaterialPageRoute(
            builder: (_) => VerifyPage(phoneNumber: args!['number']),
          );
        case paymentPage:
          return MaterialPageRoute(
            builder: (_) => PaymentPage(
                verifyModel: args!['verifyModel'],
                phoneNumber: args['phoneNumber']),
          );
        case grammarPageabout:
          _showRouteName(grammarPageabout);
          return MaterialPageRoute(
            builder: (_) => AboutUnitItemPage(title: args!['title']),
          );
        case aboutUsPage:
          return MaterialPageRoute(
            builder: (_) => const AboutWisdomPage(),
          );
        case loginPage:
          return MaterialPageRoute(
            builder: (_) => LoginPage(),
          );
        case formPage:
          return MaterialPageRoute(
            builder: (_) => FormPage(
              userModel: args!['userModel'] as UserModel,
            ),
          );
        case loginWithPhonePage:
          return MaterialPageRoute(
            builder: (_) => LoginWithPhonePage(),
          );
        default:
          _showRouteName(mainPage);
          return MaterialPageRoute(
            builder: (_) => HomePage(),
          );
      }
    } catch (e) {
      return MaterialPageRoute(
        builder: (_) => HomePage(),
      );
    }
  }

}
