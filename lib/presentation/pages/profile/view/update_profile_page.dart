import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/services/purchase_observer.dart';
import 'package:wisdom/presentation/components/w_button.dart';
import 'package:wisdom/presentation/widgets/custom_app_bar.dart';

import '../viewmodel/profile_page_viewmodel.dart';

// ignore: must_be_immutable
class UpdateProfilePage extends ViewModelBuilderWidget<ProfilePageViewModel> {
  UpdateProfilePage({super.key});

  final purchaseObserver = PurchasesObserver();
  final _formKey = GlobalKey<FormState>();

  @override
  void onViewModelReady(ProfilePageViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.getTariffs();
    viewModel.getUser();
    // resetLocator();
  }

  @override
  Widget builder(
    BuildContext context,
    ProfilePageViewModel viewModel,
    Widget? child,
  ) {
    return PopScope(
      canPop: true,
      onPopInvoked: (_) {
        log('onPopInvoked');
        // viewModel.goBackToMenu();
      },
      child: Scaffold(
          backgroundColor: isDarkTheme
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          appBar: CustomAppBar(
              title: "Update Cabinet",
              onTap: () {
                Navigator.pop(context);
              },
              leadingIcon: Assets.icons.arrowLeft),
          body: viewModel.isSuccess(tag: viewModel.getGetUser)
              ? _buildUserData(viewModel, context)
              : const Center(child: CircularProgressIndicator.adaptive())),
    );
  }

  bool isEmail(String value) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
  }

  Widget _buildUserData(ProfilePageViewModel viewModel, BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              children: [
                Text(
                  "Edit",
                  style: AppTextStyle.font17W600Normal
                      .copyWith(color: AppColors.blue, fontSize: 18),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextInputBackground(
                  child: TextFormField(
                    controller:
                        TextEditingController(text: viewModel.editedUser.name),
                    onChanged: (String value) {
                      viewModel.onFirstNameChanged(value);
                    },
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    style: AppTextStyle.font13W500Normal
                        .copyWith(fontSize: 14, color: AppColors.blue),
                    decoration: InputDecoration(
                        hintText: "Ism",
                        hintStyle: AppTextStyle.font13W500Normal.copyWith(
                            fontSize: 14,
                            color: AppColors.blue.withValues(alpha: 0.5)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18)),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextInputBackground(
                  child: TextFormField(
                    controller:
                        TextEditingController(text: viewModel.editedUser.name),
                    onChanged: (String value) {
                      viewModel.onLastNameChanged(value);
                    },
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    style: AppTextStyle.font13W500Normal
                        .copyWith(fontSize: 14, color: AppColors.blue),
                    decoration: InputDecoration(
                        hintText: "Familiya",
                        hintStyle: AppTextStyle.font13W500Normal.copyWith(
                            fontSize: 14,
                            color: AppColors.blue.withValues(alpha: 0.5)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18)),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextInputBackground(
                  child: TextFormField(
                    onChanged: (String value) {
                      viewModel.onEmailChanged(value);
                    },
                    validator: (value) {
                      if(value==null){
                        return null;
                      }
                      if(isEmail(value)){
                        return "Email manzilni to'g'ri kiriting";
                      }
                    },
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.emailAddress,
                    style: AppTextStyle.font13W500Normal
                        .copyWith(fontSize: 14, color: AppColors.blue),
                    decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: AppTextStyle.font13W500Normal.copyWith(
                            fontSize: 14,
                            color: AppColors.blue.withValues(alpha: 0.5)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18)),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () async {
                    await _selectDate(context).then(
                      (value) {
                        if (value != null) {
                          viewModel.setBirthday(value);
                        }
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15.5),
                    decoration: BoxDecoration(
                        color: AppColors.bgLightBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(32)),
                    child: Row(
                      children: [
                        SvgPicture.asset(Assets.icons.calendar),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          viewModel.editedUser.birthDateString,
                          style: AppTextStyle.font13W500Normal
                              .copyWith(fontSize: 14, color: AppColors.blue),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: WButton(
                        height: 41,
                        title: "Male",
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: WButton(
                        height: 41,
                        title: "Female",
                        titleColor: AppColors.blue,
                        color: AppColors.bgLightBlue.withValues(alpha: 0.1),
                        onTap: () {},
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        WButton(
          margin: const EdgeInsets.all(16),
          title: "save".tr(),
          onTap: () async {
            if(_formKey.currentState!.validate()) {
              await viewModel.onSaveChanges();
            }else{
              
            }
          },
        )
      ],
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            useMaterial3: false,
            colorScheme: ColorScheme.dark(
              primary: isDarkTheme ? AppColors.blue : AppColors.blue,
              onPrimary: isDarkTheme ? Colors.white : Colors.blue,
              background:
                  isDarkTheme ? AppColors.darkBackground : AppColors.white,
              surface:
                  isDarkTheme ? AppColors.darkBackground : AppColors.darkForm,
              onSurface: Colors.blue,
              onBackground: Colors.blue,
            ),
            dialogBackgroundColor:
                isDarkTheme ? AppColors.darkBackground : AppColors.darkForm,
          ),
          child: child!,
        );
      },
    );
    return newSelectedDate;
  }

  @override
  ProfilePageViewModel viewModelBuilder(BuildContext context) {
    return ProfilePageViewModel(
      context: context,
      profileRepository: locator.get(),
      localViewModel: locator.get(),
      sharedPreferenceHelper: locator.get(),
      wordEntityRepository: locator.get(),
      netWorkChecker: locator.get(),
    );
  }
}

class TextInputBackground extends StatelessWidget {
  TextInputBackground({super.key, this.child});
  Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.bgLightBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(32)),
      child: child,
    );
  }
}

class UserInputDataWidget extends StatefulWidget {
  final String title;
  final String? data;
  final ValueChanged<String> onChanged;
  final String hintText;
  final bool readOnly;
  final TextStyle? dataTextStyle;
  final bool isVisible;
  final Function? onTap;

  const UserInputDataWidget({
    super.key,
    required this.title,
    this.data,
    required this.onChanged,
    this.hintText = '',
    this.readOnly = false,
    this.dataTextStyle,
    this.isVisible = true,
    this.onTap,
  });

  @override
  State<UserInputDataWidget> createState() => _UserInputDataWidgetState();
}

class _UserInputDataWidgetState extends State<UserInputDataWidget> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.data ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible,
      child: Container(
        height: 40.dg,
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: (isDarkTheme
                  ? AppColors.darkBackground
                  : AppColors.lightBackground)
              .withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          onTap: () {
            widget.onTap?.call();
          },
          controller: controller,
          readOnly: widget.readOnly,
          onChanged: widget.onChanged,
          textAlign: TextAlign.end,
          style: widget.dataTextStyle ??
              AppTextStyle.font12W600Normal.copyWith(
                color: AppColors.blue,
                fontSize: 12.sp,
              ),
          decoration: InputDecoration.collapsed(
            hintText: widget.hintText,
            hintStyle: AppTextStyle.font12W400Normal.copyWith(
              color: AppColors.lightGray,
              fontSize: 12.sp,
            ),
          ),
        ),
      ),
    );
  }
}
