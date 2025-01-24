import 'package:flutter/material.dart';
import 'package:wisdom/presentation/components/about_unit_item_page.dart';
import 'package:wisdom/presentation/pages/abbreviation/abbreviation_page.dart';
import 'package:wisdom/presentation/pages/about_wisdom/about_wisdom.dart';
import 'package:wisdom/presentation/pages/adversitment/giving_ad_page.dart';
import 'package:wisdom/presentation/pages/home/view/home_page.dart';
import 'package:wisdom/presentation/pages/profile/view/getting_pro_page.dart';
import 'package:wisdom/presentation/pages/profile/view/input_number_page.dart';
import 'package:wisdom/presentation/pages/profile/view/payment_page.dart';
import 'package:wisdom/presentation/pages/profile/view/profile_page.dart';
import 'package:wisdom/presentation/pages/profile/view/verify_page.dart';
import 'package:wisdom/presentation/pages/setting/view/setting_page.dart';
import 'package:wisdom/presentation/pages/grammar/view/grammar_page.dart';

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

  static Route<dynamic> generateRoutes(RouteSettings routeSettings) {
    try {
      final Map<String, dynamic>? args = routeSettings.arguments as Map<String, dynamic>?;
      args ?? <String, dynamic>{};
      switch (routeSettings.name) {
        case mainPage:
          return MaterialPageRoute(
            builder: (_) => HomePage(),
          );
        case grammarPage:
          return MaterialPageRoute(
            builder: (_) => GrammarPage(),
          );
        case gettingProPage:
          return MaterialPageRoute(
            builder: (_) => GettingProPage(),
          );
        case profilePage:
          return MaterialPageRoute(
            builder: (_) => ProfilePage(),
          );
        case registrationPage:
          return MaterialPageRoute(
            builder: (_) => InputNumberPage(),
          );
        case givingAdPage:
          return MaterialPageRoute(
            builder: (_) => const GivingAdPage(),
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
            builder: (_) =>
                PaymentPage(verifyModel: args!['verifyModel'], phoneNumber: args['phoneNumber']),
          );
        case grammarPageabout:
          return MaterialPageRoute(
            builder: (_) => AboutUnitItemPage(title: args!['title']),
          );
        case aboutUsPage:
          return MaterialPageRoute(
            builder: (_) => const AboutWisdomPage(),
          );
        default:
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
