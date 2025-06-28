import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/core/extensions/num_extension.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/data/model/tariffs_model.dart';

import '../../../../config/constants/app_text_style.dart';

class ProVersionButton extends StatelessWidget {
  final Function onTap;
  final bool isVisible;
  final TariffsModel? tariffsModel;

  const ProVersionButton({
    required this.onTap,
    this.isVisible = true,
    required this.tariffsModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Material(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(25),
        child: Ink(
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: () {
              onTap.call();
            },
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    Assets.icons.proIc,
                    height: 17,
                    width: 20,
                    fit: BoxFit.scaleDown,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          LocaleKeys.pro_version.tr(),
                          style: AppTextStyle.font15W400Normal,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          LocaleKeys.sum.tr(
                            args: [tariffsModel?.price?.toMoneyFormat ?? '--'],
                          ),
                          style: AppTextStyle.font15W400Normal,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
          .animate(
            onPlay: (controller) => controller.repeat(reverse: true),
          )
          .shimmer(
            duration: 1.seconds,
            delay: 1.seconds,
          ),
    );
  }
}
