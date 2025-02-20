import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/urls.dart';
import 'package:wisdom/core/domain/http_is_success.dart';
import 'package:wisdom/core/services/custom_client.dart';
import 'package:wisdom/data/model/my_contacts/contact_follow_model.dart';
import 'package:wisdom/data/model/my_contacts/user_details_model.dart';
import 'package:wisdom/domain/repositories/my_contacts_repository.dart';

class MyContactsRepositoryImpl extends MyContactsRepository {
  MyContactsRepositoryImpl(this.customClient);

  final CustomClient customClient;

  List<UserDetailsModel> _contactsList = [];
  List<UserDetailsModel> _searchResultList = [];

  @override
  List<UserDetailsModel> get contactsList => _contactsList;

  @override
  Future<void> getMyContactsFollowed(Contacts contactType) async {
    _contactsList = [];
    if (contactType == Contacts.getMyContacts) {
      return;
    }
    var response = await customClient.get(
      contactType == Contacts.getMyContacts ? Urls.myContacts : Urls.myContactsFollowed,
    );
    if (response.isSuccessful) {
      final responseData = jsonDecode(response.body);
      for (var item in responseData['users']) {
        _contactsList.add(UserDetailsModel.fromJson(item));
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
}
