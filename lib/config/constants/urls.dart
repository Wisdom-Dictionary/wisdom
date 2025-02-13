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

  static var lives = Uri.parse('${baseUrl}api/lives');

  static var claimlives = Uri.parse('${baseUrl}api/lives/claim');

  static var testQuestionsCheck =
      Uri.parse('${baseUrl}api/levels/test-questions-check');
  static var myContactsFollowed =
      Uri.parse('${baseUrl}api/my-contacts/followed');
  static var myContacts = Uri.parse('${baseUrl}api/my-contacts/contacts');
  static var myContactsFollow = Uri.parse('${baseUrl}api/my-contacts/follow');
  static var myContactsUnFollow =
      Uri.parse('${baseUrl}api/my-contacts/unfollow');
  static var myContactsSearch = Uri.parse('${baseUrl}api/my-contacts/search');

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
  static var showUser = Uri.parse('${baseUrl}api/profile/show');
  static var profileUpdate = Uri.parse('${baseUrl}api/profile/update');
  static var profileImage = Uri.parse('${baseUrl}api/profile/image');
  static var loginSocial = Uri.parse('${baseUrl}api/auth/login/social');
  static var logOut = Uri.parse('${baseUrl}api/auth/logout');
 
  //wordbank
  static var wordBankList = Uri.parse('${baseUrl}api/wordbank/list');
  static var createFolder = Uri.parse('${baseUrl}api/wordbank/folder/create');
  static var deleteFolder = Uri.parse('${baseUrl}api/wordbank/folder/delete');
  static var createWordBank = Uri.parse('${baseUrl}api/wordbank/create');
  static var deleteWordBank = Uri.parse('${baseUrl}api/wordbank/delete');
  static var moveWordBank = Uri.parse('${baseUrl}api/wordbank/move');

  //contacts
  static var contacts = Uri.parse('${baseUrl}api/contacts');

  static Uri contactsWithTarget(String target) => Uri.parse('${baseUrl}api/contacts/$target');
}
