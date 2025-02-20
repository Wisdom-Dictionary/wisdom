import 'package:image_picker/image_picker.dart';
import 'package:wisdom/data/model/contact_model.dart';
import 'package:wisdom/data/model/contacts_model.dart';
import 'package:wisdom/data/model/my_contacts/user_details_model.dart';
import 'package:wisdom/data/model/subscribe_model.dart';
import 'package:wisdom/data/model/user/user_model.dart';
import 'package:wisdom/data/model/verify_model.dart';

import '../../data/model/tariffs_model.dart';

abstract class ProfileRepository {
  Future<void> getTariffs();

  Future<bool> login(String phoneNumber);

  Future<VerifyModel?> verify(String phoneNumber, String smsCode, String deviceId);

  Future<bool> applyFirebaseId(String token);

  Future<SubscribeModel> subscribe(int id);

  List<TariffsModel> get tariffsModel;

  TariffsModel? get currentTariff;

  Future<bool> logOut();

  Future<UserModel> getUser();

  Future<UserDetailsModel> getUserCabinet();

  UserDetailsModel? get userCabinet;

  Future<UserModel> updateUser(UserModel userModel);

  Future uploadImage(XFile file);

  Future<AdContactsModel?> getAdContacts();

  Future<List<ContactModel>> getAllContacts(String target);
}
