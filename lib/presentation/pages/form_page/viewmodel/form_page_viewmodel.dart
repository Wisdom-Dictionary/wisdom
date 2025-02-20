import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/data/model/user/user_model.dart';
import 'package:wisdom/domain/repositories/profile_repository.dart';

import '../../../routes/routes.dart';
import '../../../widgets/loading_widget.dart';

class FormPageViewModel extends BaseViewModel {
  late UserModel _userModel;
  final ProfileRepository profileRepository;
  final phoneController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final maskFormatter = MaskTextInputFormatter(mask: '(##) ### ## ##');
  String phone = '';
  Future? dialog;
  final String formSubmit = 'formSubmitted';

  @override
  void dispose() {
    phoneController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  FormPageViewModel({
    required super.context,
    required this.profileRepository,
  });

  void setUser(UserModel userModel) {
    _userModel = userModel;
    emailController.text = _userModel.email ?? '';
    firstNameController.text = _userModel.name?.split(' ').first ?? '';
    lastNameController.text = _userModel.name?.split(' ').last ?? '';
    phoneController.text = '${_userModel.phone ?? ''}';
    log(_userModel.toString());
  }

  Future submit() async {
    if (_checkFields()) {
      callBackError('Fill all fields');
      return;
    }
    safeBlock(
      () async {
        final userModel = _makeUserModel();
        log(userModel.toString(), level: 1);
        var status = await profileRepository.login(userModel.phone!);
        if (status) {
          setSuccess();
          navigateTo(Routes.verifyPage, arg: {'number': userModel.phone});
        } else {
          callBackError('Error');
        }
      },
      callFuncName: 'submit',
      tag: formSubmit,
    );
  }

  bool _checkFields() {
    return phone.isEmpty || maskFormatter.getUnmaskedText().length != 9;
  }

  void onChangePhone(String value) {
    phone = value;
  }

  UserModel _makeUserModel() {
    return UserModel(
      name: firstNameController.text,
      email: emailController.text,
      phone: "998${maskFormatter.getUnmaskedText()}",
      image: _userModel.image,
    );
  }

  @override
  callBackBusy(bool value, String? tag) {
    if (dialog == null && isBusy(tag: tag)) {
      Future.delayed(Duration.zero, () {
        dialog = showLoadingDialog(context!);
      });
    }
  }

  @override
  callBackSuccess(value, String? tag) {
    if (dialog != null) {
      pop();
      dialog = null;
    }
  }

  @override
  callBackError(String text) {
    if (dialog != null) {
      pop();
      dialog = null;
    }
    showTopSnackBar(
      Overlay.of(context!),
      CustomSnackBar.error(
        message: text,
      ),
    );
  }
}
