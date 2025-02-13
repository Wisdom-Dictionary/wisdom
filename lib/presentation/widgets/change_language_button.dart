import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisdom/presentation/pages/search/viewmodel/search_page_viewmodel.dart';

import '../../config/constants/app_colors.dart';
import '../../config/constants/assets.dart';

class ChangeLanguageButton extends StatefulWidget {
  const ChangeLanguageButton(this.viewModel, {super.key});

  final SearchPageViewModel viewModel;

  @override
  State<ChangeLanguageButton> createState() => _ChangeLanguageButtonState();
}

class _ChangeLanguageButtonState extends State<ChangeLanguageButton> {
  bool isRotate = true;
  double rotate = 0;

  @override
  Widget build(BuildContext context) {
    bool isEn = widget.viewModel.searchLangMode == 'en';
    return AnimationButton(
      onEnd: () {
        if (isRotate) {
          widget.viewModel.setSearchLanguageMode();
        }
        setState(() {
          isRotate = false;
          rotate = 0;
        });
      },
      isEn: isEn,
      rotate: rotate,
      onTap: () {
        setState(() {
          isRotate = true;
          rotate = .25;
        });
      },
      isRotate: isRotate,
    );
  }
}

class AnimationButton extends StatefulWidget {
  const AnimationButton(
      {Key? key,
      required this.onEnd,
      required this.isEn,
      required this.onTap,
      required this.rotate,
      required this.isRotate})
      : super(key: key);
  final Function() onEnd;
  final bool isEn;
  final Function onTap;
  final double rotate;
  final bool isRotate;

  @override
  State<AnimationButton> createState() => _AnimationButtonState();
}

class _AnimationButtonState extends State<AnimationButton> {
  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: widget.rotate,
      duration: Duration(milliseconds: widget.isRotate ? 150 : 0),
      onEnd: () {
        widget.onEnd();
      },
      child: Container(
        decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(26.r)),
        height: 52.h,
        width: 52.h,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => widget.onTap(),
            borderRadius: BorderRadius.circular(26.r),
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: SvgPicture.asset(
                widget.isEn ? Assets.icons.enToUz : Assets.icons.uzToEn,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
