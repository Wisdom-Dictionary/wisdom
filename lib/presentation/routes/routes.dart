import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wisdom/data/model/user/user_model.dart';
import 'package:wisdom/presentation/components/about_unit_item_page.dart';
import 'package:wisdom/presentation/pages/abbreviation/abbreviation_page.dart';
import 'package:wisdom/presentation/pages/about_wisdom/about_wisdom.dart';
import 'package:wisdom/presentation/pages/adversitment/giving_ad_page.dart';
import 'package:wisdom/presentation/pages/grammar/view/grammar_page.dart';
import 'package:wisdom/presentation/pages/home/view/home_page.dart';
import 'package:wisdom/presentation/pages/my_contacts/view/contact_details_page.dart';
import 'package:wisdom/presentation/pages/my_contacts/view/my_contacts_page.dart';
import 'package:wisdom/presentation/pages/my_contacts/view/my_contacts_search_page.dart';
import 'package:wisdom/presentation/pages/profile/view/edit_user_page.dart';
import 'package:wisdom/presentation/pages/login/login_with_phone_page.dart';
import 'package:wisdom/presentation/pages/login/view/login_page.dart';
import 'package:wisdom/presentation/pages/profile/view/getting_pro_page.dart';
import 'package:wisdom/presentation/pages/profile/view/input_number_page.dart';
import 'package:wisdom/presentation/pages/profile/view/payment_page.dart';
import 'package:wisdom/presentation/pages/profile/view/profile_page.dart';
import 'package:wisdom/presentation/pages/profile/view/update_profile_page.dart';
import 'package:wisdom/presentation/pages/profile/view/user_cabinet_page.dart';
import 'package:wisdom/presentation/pages/profile/view/verify_page.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/battle_exercises_page.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/battle_exercises_result_page.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/battle_result_page.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/searching_opponent_page.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/exercises_result/word_exercises_result_page.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/results_section/results_section_page.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/word_details_page.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/word_exercises_check_page.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/word_exercises_page.dart';
import 'package:wisdom/presentation/pages/setting/view/setting_page.dart';

import '../pages/form_page/view/form_page.dart';

class Routes {
  static const mainPage = '/';
  static const grammarPage = '/unit/grammar';
  static const grammarPageabout = '/unit/grammar/about';
  static const gettingProPage = '/profile';
  static const profilePage = '/profile2';
  static const updateProfilePage = '/update_profile';
  static const registrationPage = '/profile/registration';
  static const verifyPage = '/profile/registration/verify';
  static const paymentPage = '/profile/payment';
  static const givingAdPage = '/givingAd';
  static const abbreviationPage = '/abbreviation';
  static const settingPage = '/setting';
  static const aboutUsPage = '/aboutUsPage';
  static const wordDetailsPage = '/wordDetailsPage';
  static const wordExercisesPage = '/wordExercisesPage';
  static const wordExercisesCheckPage = '/wordExercisesCheckPage';
  static const wordExercisesResultPage = '/wordExercisesResultPage';
  static const searchingOpponentPage = '/searchingOpponentPage';
  static const battleExercisesPage = '/battleExercisesPage';
  static const battleResultPage = '/battleResultPage';
  static const battleExercisesResultPage = '/battleExercisesResultPage';
  static const userCabinetPage = '/userCabinetPage';
  static const editUserPage = '/editUserPage';
  static const myContactsPage = '/myContactsPage';
  static const myContactsSearchPage = '/myContactsSearchPage';
  static const contactDetailsPage = '/contactDetailsPage';
  static const loginPage = '/loginPage';
  static const loginWithPhonePage = '/loginWithPhonePage';
  static const formPage = '/formPage';
  static const resultsSectionPage = '/resultsSectionPage';

  static _showRouteName(String routeName) {
    log(routeName);
  }

  static Route<dynamic> generateRoutes(RouteSettings routeSettings) {
    try {
      final Map<String, dynamic>? args = routeSettings.arguments as Map<String, dynamic>?;
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
        case updateProfilePage:
          _showRouteName(updateProfilePage);
          return MaterialPageRoute(
            builder: (_) => UpdateProfilePage(),
          );
        case registrationPage:
          return MaterialPageRoute(
            builder: (_) => InputNumberPage(),
          );
        case givingAdPage:
          return MaterialPageRoute(
            builder: (_) => GivingAdPage(),
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
          _showRouteName(grammarPageabout);
          return MaterialPageRoute(
            builder: (_) => AboutUnitItemPage(title: args!['title']),
          );
        case aboutUsPage:
          return MaterialPageRoute(
            builder: (_) => const AboutWisdomPage(),
          );
        case wordDetailsPage:
          return MaterialPageRoute(
            builder: (_) => WordDetailsPage(),
          );
        case wordExercisesPage:
          return MaterialPageRoute(
            builder: (_) => WordExercisesPage(),
          );
        case wordExercisesCheckPage:
          return MaterialPageRoute(
            builder: (_) => WordExercisesCheckPage(),
          );
        case wordExercisesResultPage:
          return MaterialPageRoute(
            builder: (_) => WordExercisesResultPage(),
          );
        case searchingOpponentPage:
          return MaterialPageRoute(
            builder: (_) => SearchingOpponentPage(),
          );
        case battleExercisesPage:
          return MaterialPageRoute(
            builder: (_) => BattleExercisesPage(),
          );
        case battleResultPage:
          return MaterialPageRoute(
            builder: (_) => BattleResultPage(),
          );
        case battleExercisesResultPage:
          return MaterialPageRoute(
            builder: (_) => BattleExercisesResultPage(),
          );
        case userCabinetPage:
          return MaterialPageRoute(
            builder: (_) => UserCabinetPage(),
          );
        case editUserPage:
          return MaterialPageRoute(
            builder: (_) => const EditUserPage(),
          );
        case myContactsPage:
          return MaterialPageRoute(
            builder: (_) => const MyContactsPage(),
          );
        case myContactsSearchPage:
          return MaterialPageRoute(
            builder: (_) => MyContactsSearchPage(),
          );
        case contactDetailsPage:
          return MaterialPageRoute(
            builder: (_) => ContactDetailsPage(
              data: routeSettings.arguments,
            ),
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
        case resultsSectionPage:
          return MaterialPageRoute(
            builder: (_) => ResultsSectionPage(),
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
