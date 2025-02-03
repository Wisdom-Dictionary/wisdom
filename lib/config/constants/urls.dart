class Urls {
  static const baseAddress = 'wisdom.yangixonsaroy.uz';
  static const baseUrl = 'https://wisdom.yangixonsaroy.uz/';
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

  static var testQuestionsCheck = Uri.parse('${baseUrl}api/levels//test-questions-check');

  static Uri testQuestions(int id) => Uri.https(
        Urls.baseAddress,
        "/api/levels/$id/test-questions",
      );

  static Uri levelWords(int id) => Uri.https(
        Urls.baseAddress,
        "/api/levels/$id",
      );

  static Uri wordQuestions(int wordId) => Uri.https(
        Urls.baseAddress,
        "/api/word/$wordId/word-questions",
      );

  static Uri wordQuestionsCheck(int wordId) => Uri.https(
        Urls.baseAddress,
        "/api/word/$wordId/word-questions-check",
      );

  static subscribe(int id) => Uri.parse('${baseUrl}api/subscribe/set/$id');

  static getSpeakingView(int id) => Uri.parse("${baseUrl}api/catalogue/speaking/word/view/$id");
}
