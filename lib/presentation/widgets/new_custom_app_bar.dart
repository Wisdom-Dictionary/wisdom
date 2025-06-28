import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisdom/config/constants/constants.dart';

import '../../config/constants/app_colors.dart';
import '../../config/constants/app_text_style.dart';
import '../../config/constants/assets.dart';

// ignore: must_be_immutable
class NewCustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  NewCustomAppBar({
    super.key,
    this.height,
    this.title,
    this.child,
    this.bottom,
    this.onTap,
    this.focusNode,
    this.isSearch = false,
    this.hasLeading = true,
    this.isTitle = true,
    this.leading,
    this.onChange,
    this.keyboardType,
    this.focus = false,
    this.actions = const [],
  });

  final double? height;
  final String? title;
  final Widget? child;
  final PreferredSizeWidget? bottom;
  final Function()? onTap;
  final Function(String text)? onChange;
  final Widget? leading;
  FocusNode? focusNode;
  bool isSearch;
  bool hasLeading;
  bool isTitle;
  bool focus;
  TextInputType? keyboardType;
  final List<Widget>? actions;

  @override
  State<NewCustomAppBar> createState() => _NewCustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height ??
      (isTitle
          ? isSearch
              ? 111.h
              : 75.h
          : 75.h));
}

class _NewCustomAppBarState extends State<NewCustomAppBar> {
  TextEditingController controller = TextEditingController();
  ValueNotifier<bool> hasText = ValueNotifier<bool>(false);
  Timer? _debounce;

  @override
  void initState() {
    controller.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 800), () {
      final query = controller.text.trim();
      if (query.isNotEmpty) {
        onChanged(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: (isDarkTheme ? AppColors.darkForm : AppColors.blue).withValues(alpha: 0.95),
      shadowColor: isDarkTheme ? null : const Color(0xFF6D8DAD).withValues(alpha: 0.15),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      actions: widget.actions,
      leading: widget.leading ??
          (widget.hasLeading
              ? InkResponse(
                  onTap: () {
                    if (widget.onTap != null) {
                      widget.onTap!();
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 5.w,
                      right: 5.w,
                      top: 15.h,
                    ),
                    child: SvgPicture.asset(
                      Assets.icons.arrowLeft,
                      height: 24.h,
                      width: 24.h,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                )
              : null),
      centerTitle: true,
      title: widget.isTitle && widget.title != null
          ? Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Text(widget.title!, style: AppTextStyle.font15W500Normal),
            )
          : widget.child,
      toolbarHeight: widget.height,
      bottom: widget.isSearch
          ? PreferredSize(
              preferredSize: Size.fromHeight(50.h),
              child: Container(
                height: 47.h,
                margin: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                    color: (isDarkTheme ? AppColors.darkBackground : AppColors.white)
                        .withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(23.5.r)),
                child: TextField(
                  autofocus: widget.focus,
                  style: AppTextStyle.font15W400Normal.copyWith(color: AppColors.blue),
                  cursorHeight: 19.h,
                  controller: controller,
                  onChanged: (value) {},
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  keyboardType: widget.keyboardType,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 8.0.w),
                      child: SvgPicture.asset(
                        Assets.icons.searchText,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    suffixIcon: ValueListenableBuilder(
                      valueListenable: hasText,
                      builder: (context, value, child) {
                        return Visibility(
                          visible: hasText.value,
                          child: Padding(
                            padding: EdgeInsets.only(right: 8.0.w),
                            child: InkResponse(
                              onTap: () {
                                controller.clear();
                                onChanged("");
                              },
                              child: SvgPicture.asset(
                                Assets.icons.crossClose,
                                height: 10.h,
                                width: 10.h,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    hintText: 'search_hint'.tr(),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                    hintStyle: AppTextStyle.font15W400Normal.copyWith(
                      color: AppColors.paleBlue.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            )
          : widget.bottom,
    );
  }

  onChanged(String text) {
    if (controller.text.isEmpty) {
      hasText.value = false;
    } else {
      hasText.value = true;
    }
    setState(() {});
    if (widget.onChange != null) {
      widget.onChange!(text);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    controller.removeListener(_onSearchChanged);
    controller.dispose();
    super.dispose();
  }
}
