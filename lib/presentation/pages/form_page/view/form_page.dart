import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/extensions/app_extension.dart';
import 'package:wisdom/data/model/user/user_model.dart';
import 'package:wisdom/presentation/pages/form_page/viewmodel/form_page_viewmodel.dart';
import 'package:wisdom/presentation/pages/login/view/login_page.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/assets.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/social_button.dart';
import '../../profile/widgets/profile_image_widget.dart';

// ignore: must_be_immutable
class FormPage extends ViewModelBuilderWidget<FormPageViewModel> {
  final UserModel? userModel;
  Future? dialog;

  FormPage({
    this.userModel,
    super.key,
  });

  @override
  Widget builder(
    BuildContext context,
    FormPageViewModel viewModel,
    Widget? child,
  ) {
    viewModel.setUser(userModel ?? const UserModel());

    return Scaffold(
      backgroundColor:
          isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: "User Information".tr(),
        onTap: () => viewModel.pop(),
        leadingIcon: Assets.icons.arrowLeft,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Stack(
            children: [
              CardContentWidget(
                children: [
                  ProfileImageWidget(
                    imageUrl: userModel?.image,
                    onEdit: (){},
                  ),
                  AppInputTextField(
                    hint: 'Ism'.tr(),
                    borderRadius: 40,
                    textInputAction: TextInputAction.next,
                    controller: viewModel.firstNameController,
                    hintStyle: AppTextStyle.font13W400Normal
                        .copyWith(color: AppColors.gray),
                  ).paddingOnly(top: 10),
                  AppInputTextField(
                    hint: 'Familiya'.tr(),
                    borderRadius: 40,
                    textInputAction: TextInputAction.next,
                    controller: viewModel.lastNameController,
                    hintStyle: AppTextStyle.font17W400Normal
                        .copyWith(color: AppColors.gray),
                  ).paddingOnly(top: 10),
                  AppInputTextField(
                    textInputAction: TextInputAction.next,
                    // controller: viewModel.phoneController,
                    initialText: viewModel.phone,
                    onChanged: viewModel.onChangePhone,
                    prefix: Text(
                      "+998",
                      style: AppTextStyle.font17W400Normal.copyWith(
                        color: AppColors.blue,
                      ),
                    ).paddingOnly(right: 10, top: 5),
                    hint: '(--) --- -- --',
                    inputFormatter: viewModel.maskFormatter,
                    borderRadius: 40,
                  ).paddingOnly(top: 10),
                  AppInputTextField(
                    hint: 'email'.tr(),
                    borderRadius: 40,
                    textInputAction: TextInputAction.next,
                    controller: viewModel.emailController,
                  ).paddingOnly(top: 10),
                  AppButtonWidget(
                    onTap: () {
                      viewModel.submit();
                    },
                    title: "Davom etish",
                    margin: EdgeInsets.symmetric(vertical: 10.w),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  FormPageViewModel viewModelBuilder(BuildContext context) {
    return FormPageViewModel(
      context: context,
      profileRepository: locator.get(),
    );
  }
}
