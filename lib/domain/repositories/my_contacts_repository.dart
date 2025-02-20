import 'package:wisdom/data/model/my_contacts/user_details_model.dart';

enum Contacts {
  getMyContacts,
  getMyContactsFollowed,
}

abstract class MyContactsRepository {
  Future<void> getMyContactsFollowed(Contacts contactType);

  Future<void> postMyContactsSearch(String searchKeyWord);

  Future<String> postFollow(int userId);

  Future<String> postUnFollow(int userId);

  List<UserDetailsModel> get contactsList;

  List<UserDetailsModel> get searchResultList;
}
