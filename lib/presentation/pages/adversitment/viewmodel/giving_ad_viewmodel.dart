import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:jbaza/jbaza.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/core/services/custom_client.dart';
import 'package:wisdom/data/model/contact_model.dart';
import 'package:wisdom/domain/repositories/profile_repository.dart';

class GivingAdViewModel extends BaseViewModel {
  GivingAdViewModel({
    required super.context,
    required this.netWorkChecker,
    required this.profileRepository,
    required this.preferenceHelper,
  });

  final NetWorkChecker netWorkChecker;
  final ProfileRepository profileRepository;
  final SharedPreferenceHelper preferenceHelper;
  final String getContactsTag = 'getAdContactsTag';
  List<ContactModel> adContacts = [];
  List<ContactModel> supportContacts = [];

  Future getAdContacts() async {
    safeBlock(
      () async {
        if (await netWorkChecker.isNetworkAvailable()) {
          adContacts = await profileRepository.getAllContacts('ad');
          supportContacts = await profileRepository.getAllContacts('support');
          if (supportContacts.isNotEmpty || adContacts.isNotEmpty) {
            setSuccess(tag: getContactsTag);
          }
        } else {
          callBackError(LocaleKeys.no_internet.tr());
        }
      },
      tag: getContactsTag,
    );
  }

  @override
  callBackSuccess(dynamic value, String? tag) async {
    // showInfo('text');
  }

  @override
  callBackError(String text) {
    log(text);
    showTopSnackBar(
      Overlay.of(context!),
      CustomSnackBar.error(
        message: text,
      ),
    );
  }

  @override
  bool isError({String? tag}) {
    return false;
  }
}
