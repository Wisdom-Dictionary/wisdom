abstract class Assets {
  const Assets._();

  static _Icons get icons => const _Icons();

  static _Images get images => const _Images();
}

abstract class _AssetsHolder {
  final String basePath;

  const _AssetsHolder(this.basePath);
}

class _Icons extends _AssetsHolder {
  const _Icons() : super("assets/icons");

  String get global => '$basePath/global.svg';

  String get contacts => '$basePath/contacts.svg';

  String get union => '$basePath/union.svg';

  String get battleItem => '$basePath/battle-item.svg';

  String get calendarOutlined => '$basePath/calendar-outlined.svg';

  String get wifi => '$basePath/wifi.svg';

  String get note => '$basePath/note.svg';

  String get followed => '$basePath/followed.svg';

  String get people => '$basePath/people.svg';

  String get calendar => '$basePath/calendar.svg';

  String get logOut => '$basePath/log-out.svg';

  String get edit3 => '$basePath/edit-3.svg';

  String get popupMenu => '$basePath/popup-menu.svg';

  String get documentCopy => '$basePath/document-copy.svg';

  String get wifiOff => '$basePath/wifi-off.svg';

  String get clock => '$basePath/clock.svg';

  String get outOfLives => '$basePath/out-of-lives.svg';

  String get searchingOpponentAvatar => '$basePath/searching-opponent-avatar.svg';

  String get crossSwords => '$basePath/cross-swords.png';

  String get crossSwordsSvg => '$basePath/cross-swords.svg';

  String get flag => '$basePath/flag.svg';

  String get failureIcon => '$basePath/failure-icon.svg';

  String get incorrectAnswer => '$basePath/incorrect-answer.svg';

  String get battle => '$basePath/battle.svg';

  String get medalStar => '$basePath/medal-star.svg';

  String get doubleCheck => '$basePath/double-check.svg';

  String get userAvatar => '$basePath/user-avatar.svg';

  String get profileAvatar => '$basePath/profile-avatar.svg';

  String get starActive => '$basePath/star-active.svg';

  String get starInactive => '$basePath/star-inactive.svg';

  String get starInactiveTest => '$basePath/star-test.svg';

  String get lock => '$basePath/lock.svg';

  String get star => '$basePath/star.svg';

  String get verify => '$basePath/verify.svg';

  String get heart => '$basePath/heart.svg';

  String get heartSlash => '$basePath/heart-slash.svg';

  String get abbreviations => '$basePath/abbrev.svg';

  String get addFolder => '$basePath/add_folder.svg';

  String get move => '$basePath/move.svg';

  String get plus => '$basePath/plus.svg';

  String get desktop => '$basePath/desktop.svg';

  String get giveAd => '$basePath/ad.svg';

  String get arrowCircleRight => '$basePath/arrow_circle_right.svg';

  String get arrowLeft => '$basePath/arrow_left.svg';

  String get bookFilled => '$basePath/book_filled.svg';

  String get bookOutline => '$basePath/book_outline.svg';

  String get uzToEn => '$basePath/uz_to_en.svg';

  String get enToUz => '$basePath/en_to_uz.svg';

  String get crossClean => '$basePath/clear.svg';

  String get crossClose => '$basePath/close.svg';

  String get copy => '$basePath/copy.svg';

  String get download => '$basePath/download.svg';

  String get exercise => '$basePath/exercise.svg';

  String get fontIncrease => '$basePath/font_increase.svg';

  String get fontReduce => '$basePath/font_reduce.svg';

  String get homeFilled => '$basePath/home_filled.svg';

  String get homeOutline => '$basePath/home_outline.svg';

  String get logoBlueText => '$basePath/logo_blue_text.svg';

  String get logoWhite => '$basePath/logo_white.svg';

  String get logoWhiteText => '$basePath/logo_white_text.svg';

  String get menu => '$basePath/menu.svg';

  String get microphone => '$basePath/microfon.svg';

  String get moon => '$basePath/moon.svg';

  String get more => '$basePath/more.svg';

  String get person => '$basePath/person.svg';

  String get collapsed => '$basePath/collapsed.svg';

  String get expanded => '$basePath/expanded.svg';

  String get proVersion => '$basePath/pro_version.svg';

  String get rate => '$basePath/rate.svg';

  String get searchFilled => '$basePath/search_filled.svg';

  String get searchOutline => '$basePath/search_outline.svg';

  String get searchText => '$basePath/search_text.svg';

  String get send => '$basePath/send.svg';

  String get setting => '$basePath/setting.svg';

  String get share => '$basePath/share.svg';

  String get sound => '$basePath/sound.svg';

  String get sun => '$basePath/sun.svg';

  String get changeLangTranslate => '$basePath/swap_lang.svg';

  String get translateFilled => '$basePath/translate_filled.svg';

  String get translateOutline => '$basePath/translate_outline.svg';

  String get trash => '$basePath/trash.svg';

  String get unitsFilled => '$basePath/vertical_row_filled.svg';

  String get unitsOutline => '$basePath/vertical_row_outline.svg';

  String get cup => '$basePath/cup.svg';

  String get cupOutlined => '$basePath/cup_outlined.svg';

  String get saveWord => '$basePath/word_save.svg';

  String get starFull => '$basePath/rank_full.svg';

  String get starHalf => '$basePath/rank_half.svg';

  String get starLow => '$basePath/rank_low.svg';

  String get info => '$basePath/info.svg';

  String get inform => '$basePath/inform.svg';

  String get tick => '$basePath/tick.svg';

  String get cross => '$basePath/cros.svg';

  String get googleIc => '$basePath/google_ic.svg';

  String get facebookIc => '$basePath/facebook_ic.svg';

  String get appleIc => '$basePath/apple_ic.svg';

  String get exitIc => '$basePath/exit_ic.svg';

  String get proIc => '$basePath/pro_icon.svg';
}

class _Images extends _AssetsHolder {
  const _Images() : super("assets/images");

  String get contactPermissionIos => '$basePath/contact-permission-ios.png';

  String get contactPermissionAndroid => '$basePath/contact-permission-android.png';

  String get goldMedal => '$basePath/003-gold medal.png';

  String get profile => '$basePath/profile_img.svg';

  String get click => '$basePath/click_img.svg';

  String get dicEmpty => '$basePath/empty_img.svg';

  String get payme => '$basePath/payme_img.svg';

  String get paynet => '$basePath/paynet_img.svg';

  String get applePay => '$basePath/apple_pay_img.svg';

  String get diamond => '$basePath/diamond.png';

  String get noInternet => '$basePath/no-wifi.png';

  String get roadmapBattleBackground1 => '$basePath/roadmap_background-1.png';
  String get roadmapBattleBackground2 => '$basePath/roadmap_background-2.png';
  String get roadmapBattleBackground3 => '$basePath/roadmap_background-3.png';
  String get roadmapBattleBackground4 => '$basePath/roadmap_background-4.png';
  String get roadmapBattleBackground5 => '$basePath/roadmap_background-5.png';
  String get roadmapBattleBackground6 => '$basePath/roadmap_background-6.png';
  String get roadmapBattleBackground7 => '$basePath/roadmap_background-7.png';
  String get roadmapBattleBackground8 => '$basePath/roadmap_background-8.png';

  String get roadmapWay => '$basePath/roadmap_way.svg';

  String get roadmapWay2 => '$basePath/roadmap_way-2.svg';

  String get roadmapWay3 => '$basePath/roadmap_way-3.svg';
}
