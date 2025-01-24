class Urls {
  static const baseUrl = 'http://wisdev.uz/';
  // static const baseUrl = 'http://api.wisdomedu.uz/';

  static var getWordsPaths = Uri.parse('${baseUrl}api/download/words');
  static var getLenta = Uri.parse('${baseUrl}api/lenta');
  static var getTariffs = Uri.parse('${baseUrl}api/subscribe/tariffs');

  static var login = Uri.parse('${baseUrl}api/auth/login');
  static var verify = Uri.parse('${baseUrl}api/auth/verify');
  static var applyFirebaseId = Uri.parse('${baseUrl}api/auth/firebase');
  static var subscribeCheck = Uri.parse('${baseUrl}api/subscribe/check');

  static var getWordsVersionAndPath = Uri.parse('${baseUrl}api/download/words');

  static var levels = Uri.parse('${baseUrl}api/levels');

  static subscribe(int id) => Uri.parse('${baseUrl}api/subscribe/set/$id');

  static getSpeakingView(int id) => Uri.parse("${baseUrl}api/catalogue/speaking/word/view/$id");
}
