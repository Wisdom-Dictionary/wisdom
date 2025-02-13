import 'package:easy_localization/easy_localization.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';

enum Gender {
  M,
  F,
  none;

  String get localeName {
    switch (this) {
      case Gender.M:
        return LocaleKeys.male_gender.tr();
      case Gender.F:
        return LocaleKeys.female_gender.tr();
      default:
        return '';
    }
  }
}
