import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/config/constants/urls.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/extensions/datetime_extension.dart';
import 'package:wisdom/core/services/custom_client.dart';
import 'package:wisdom/core/services/dio_client.dart';
import 'package:wisdom/data/model/contact_model.dart';
import 'package:wisdom/data/model/contacts_model.dart';
import 'package:wisdom/data/model/my_contacts/user_details_model.dart';
import 'package:wisdom/data/model/subscribe_model.dart';
import 'package:wisdom/data/model/tariffs_model.dart';
import 'package:wisdom/data/model/user/user_model.dart';
import 'package:wisdom/data/model/verify_model.dart';
import 'package:wisdom/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  ProfileRepositoryImpl(this._dioClient, this.netWorkChecker, this.preferenceHelper);

  final DioClient _dioClient;
  final NetWorkChecker netWorkChecker;
  final SharedPreferenceHelper preferenceHelper;

  final List<TariffsModel> _tariffsModel = [];
  late TariffsModel? _currentTariff;
  UserDetailsModel? _userDetailsModel;

  @override
  Future<void> getTariffs() async {
    _tariffsModel.clear();
    var response = await _dioClient.get(Urls.getTariffs.path);
    if (response.isSuccessful) {
      for (var item in jsonDecode(response.data)['tariffs']) {
        _tariffsModel.add(TariffsModel.fromJson(item));
      }
      preferenceHelper.putString(Constants.KEY_TARIFFS, jsonEncode(_tariffsModel.first));
    }
  }

  @override
  Future<bool> login(String phoneNumber) async {
    var response = await _dioClient.post(Urls.login.path, data: {'phone': phoneNumber});
    if (response.isSuccessful) {
      return jsonDecode(response.data)['status'];
    }
    return false;
  }

  @override
  List<TariffsModel> get tariffsModel => _tariffsModel;

  @override
  Future<VerifyModel?> verify(String phoneNumber, String smsCode, String deviceId) async {
    var response = await _dioClient.post(
      Urls.verify.path,
      data: jsonEncode(
        {
          'phone': phoneNumber,
          'verify_code': smsCode,
          'device_id': deviceId,
        },
      ),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    if (response.isSuccessful) {
      return VerifyModel.fromJson(jsonDecode(response.data));
    } else {
      throw VMException(
        response.data,
        callFuncName: 'verify',
      );
    }
  }

  @override
  Future<bool> applyFirebaseId(String token) async {
    var response = await _dioClient.post(
      Urls.applyFirebaseId.path,
      data: {'token': token},
    );
    if (response.statusCode != 404) {
      // return jsonDecode(response.body)['status'];
      return true;
    } else {
      throw VMException(response.data, callFuncName: 'applyFirebaseId');
    }
  }

  @override
  Future<SubscribeModel> subscribe(int id) async {
    var response = await _dioClient.post(Urls.subscribe(id).path);
    if (response.isSuccessful) {
      return SubscribeModel.fromJson(jsonDecode(response.data));
    } else {
      throw VMException(response.data, callFuncName: 'subscribe');
    }
  }

  @override
  Future<bool> logOut() async {
    try {
      final response = await _dioClient.post(Urls.logOut.path);
      return response.isSuccessful;
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  @override
  Future<UserModel> getUser() async {
    if (await netWorkChecker.isNetworkAvailable()) {
      var response = await _dioClient.get(Urls.showUser.path);
      if (response.isSuccessful) {
        final data = jsonDecode(response.data);
        final user = UserModel.fromJson(data['user']);
        _currentTariff = data['tariff'] != null ? TariffsModel.fromJson(data['tariff']) : null;
        preferenceHelper.putString(
          Constants.KEY_USER,
          jsonEncode(user.toJson()),
        );
        return user;
      }
    } else {
      final userStorage = preferenceHelper.getString(Constants.KEY_USER, '');
      if (userStorage != '') {
        return UserModel.fromJson(jsonDecode(userStorage));
      }
    }
    return const UserModel();
  }

  @override
  Future<UserDetailsModel> getUserCabinet() async {
    if (await netWorkChecker.isNetworkAvailable()) {
      var response = await _dioClient.get(Urls.showUser.path);
      if (response.isSuccessful) {
        final data = jsonDecode(response.data);
        final user = UserDetailsModel.fromJson(data);

        preferenceHelper.putString(
          Constants.KEY_USER_CABINET,
          jsonEncode(user.toMap()),
        );
        _userDetailsModel = user;
        return user;
      } else {
        throw VMException(response.data, callFuncName: 'getUser');
      }
    } else {
      final userStorage = preferenceHelper.getString(Constants.KEY_USER_CABINET, '');
      if (userStorage != '') {
        return UserDetailsModel.fromJson(jsonDecode(userStorage));
      }
    }
    return UserDetailsModel();
  }

  @override
  Future<UserModel> updateUser(UserModel userModel) async {
    final response = await _dioClient.post(
      Urls.profileUpdate.path,
      data: {
        "name": userModel.name,
        "birthdate": userModel.birthDate?.toFullDate,
        "gender": userModel.gender?.name,
        "email": userModel.email,
      },
    );
    log(response.data);
    if (response.isSuccessful) {
      final user = UserModel.fromJson(jsonDecode(response.data)['user']);
      return user;
    } else {
      throw VMException(response.data, callFuncName: 'updateUser');
    }
  }

  @override
  Future uploadImage(XFile file) async {
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(file.path),
    });
    final response = await _dioClient.post(
      Urls.profileImage.path,
      data: formData,
      options: Options(
        headers: {
          "Content-Type": "multipart/form-data",
        },
      ),
    );
    if (response.isSuccessful) {
      return true;
    }
    return false;
  }

  @override
  Future<AdContactsModel?> getAdContacts() async {
    final response = await _dioClient.get(Urls.contacts.path);
    if (response.isSuccessful) {
      final contacts = AdContactsModel.fromJson(jsonDecode(response.data));
      preferenceHelper.putString(Constants.KEY_CONTACTS, jsonEncode(contacts.toJson()));
      return contacts;
    }
    return null;
  }

  @override
  Future<List<ContactModel>> getAllContacts(String target) async {
    final response = await _dioClient.get(Urls.contactsWithTarget(target).path);
    if (response.isSuccessful) {
      return (jsonDecode(response.data)['contacts'] as List<dynamic>)
          .map((e) => ContactModel.fromJson(e))
          .toList();
    }
    return [];
  }

  @override
  TariffsModel? get currentTariff => _currentTariff;

  @override
  UserDetailsModel get userCabinet => _userDetailsModel ?? UserDetailsModel();
}
