import 'package:wisdom/data/model/my_contacts/contact_follow_model.dart';
import 'package:wisdom/data/model/my_contacts/contact_model.dart';

enum Contacts {
  getMyContacts,
  getMyContactsFollowed,
}

abstract class MyContactsRepository {
  Future<void> getMyContactsFollowed(Contacts contactType);
  
  Future<void> postMyContactsSearch(String searchKeyWord);

  Future<ContactFollowModel> postFollow(int userId);

  Future<ContactFollowModel> postUnFollow(int userId);

  List<ContactModel> get contactsList;

  List<ContactModel> get searchResultList;
}
