import 'package:wisdom/data/model/my_contacts/user_details_model.dart';

enum Contacts {
  getMyContacts,
  getMyContactsFollowed,
}

abstract class MyContactsRepository {
  Future<void> getMyFollowedUsers();

  Future<void> getMyContactUsers();

  Future<void> getMyContactUsersFromCache();

  Future<void> postMyContactsSearch(String searchKeyWord);

  Future<String> postFollow(int userId);

  Future<String> postUnFollow(int userId);

  List<UserDetailsModel> get followedList;

  List<UserDetailsModel> get myContactsList;

  List<UserDetailsModel> get searchResultList;

  void searchResultListClear();
}
