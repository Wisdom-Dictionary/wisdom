import 'dart:convert';
import 'dart:developer';

import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/config/constants/urls.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/domain/http_is_success.dart';
import 'package:wisdom/core/services/contacts_service.dart';
import 'package:wisdom/core/services/custom_client.dart';
import 'package:wisdom/data/model/my_contacts/user_details_model.dart';
import 'package:wisdom/domain/repositories/my_contacts_repository.dart';

class MyContactsRepositoryImpl extends MyContactsRepository {
  MyContactsRepositoryImpl(this.customClient, this.preferenceHelper);

  final CustomClient customClient;

  final SharedPreferenceHelper preferenceHelper;

  List<UserDetailsModel> _myContactsList = [];
  List<UserDetailsModel> _followedList = [];
  List<UserDetailsModel> _searchResultList = [];

  @override
  List<UserDetailsModel> get followedList => _followedList;

  @override
  List<UserDetailsModel> get myContactsList => _myContactsList;

  @override
  Future<void> getMyFollowedUsers() async {
    _followedList = [];

    var response = await customClient.get(
      Urls.myContactsFollowed,
    );
    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);
      for (var item in responseData['users']) {
        _followedList.add(UserDetailsModel.fromJson(item));
      }
    } else {
      throw VMException(response.body, callFuncName: 'getMyContactsFollowed', response: response);
    }
  }

  @override
  Future<void> getMyContactUsers() async {
    // _myContactsList = [];

    final requestBody = {
      'contacts': await CustomContactService.pickContact(),
    };
    var response = await customClient.post(Urls.myContacts,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody));

    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);
      var contactsData = responseData['contacts'];
      if (contactsData is Map<String, dynamic>) {
        // Value’larni listga aylantiramiz
        contactsData = responseData['contacts'].values.cast<Map<String, dynamic>>().toList();
      }
      preferenceHelper.putString(
        Constants.KEY_CONTACTS_DATA,
        jsonEncode(contactsData),
      );
      _myContactsList = [];
      for (var item in contactsData) {
        _myContactsList.add(UserDetailsModel.fromJson(item));
      }
    } else {
      throw VMException(response.body, callFuncName: 'getMyContactsFollowed', response: response);
    }
  }

  @override
  Future<String> postFollow(int userId) async {
    final requestBody = {
      'user_id': "$userId",
    };

    var response = await customClient.post(Urls.myContactsFollow,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody));

    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);
      return responseData['message'];
    } else {
      throw VMException(response.body, callFuncName: 'getMyContactsFollowed', response: response);
    }
  }

  @override
  Future<String> postUnFollow(int userId) async {
    final requestBody = {
      'user_id': "$userId",
    };

    var response = await customClient.post(Urls.myContactsUnFollow,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody));

    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);
      return responseData['message'];
    } else {
      throw VMException(response.body, callFuncName: 'getMyContactsFollowed', response: response);
    }
  }

  @override
  Future<void> postMyContactsSearch(String searchKeyWord) async {
    _searchResultList = [];
    final requestBody = {
      'search': searchKeyWord,
    };
    var response = await customClient.post(Urls.myContactsSearch,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody));
    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);
      if (responseData['users'] != null) {
        for (var item in responseData['users']) {
          _searchResultList.add(UserDetailsModel.fromJson(item));
        }
      }
    } else if (response.statusCode == 404) {
      return;
    } else {
      throw VMException(response.body, callFuncName: 'postMyContactsSearch', response: response);
    }
  }

  @override
  List<UserDetailsModel> get searchResultList => _searchResultList;

  @override
  void searchResultListClear() {
    _searchResultList = [];
  }

  @override
  Future<void> getMyContactUsersFromCache() async {
    _myContactsList = [];
    String data = preferenceHelper.getString(Constants.KEY_CONTACTS_DATA, "");
    if (data.isNotEmpty) {
      final contactsData = jsonDecode(data);
      for (var item in contactsData) {
        _myContactsList.add(UserDetailsModel.fromJson(item));
      }
    }
  }
}
