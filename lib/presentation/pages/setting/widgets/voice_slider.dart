import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_decoration.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/core/utils/debouncer.dart';

class VoiceSlider extends StatefulWidget {
  const VoiceSlider({super.key});

  @override
  State<VoiceSlider> createState() => _VoiceSliderState();
}

class _VoiceSliderState extends State<VoiceSlider> {
  double value = 0.1;
  final _sharedPref = locator<SharedPreferenceHelper>();
  final _debouncer = Debouncer(milliseconds: 300);

  @override
  void initState() {
    value = _sharedPref.getDouble(Constants.VOICE_SPEED, 0.3) * 100;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isDarkTheme ? AppDecoration.bannerDarkDecor : AppDecoration.bannerDecor,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.voice_speed.tr(),
            style: AppTextStyle.font17W600Normal.copyWith(
              color: isDarkTheme ? AppColors.white : AppColors.black,
              fontSize: 17.sp,
            ),
          ),
          SliderTheme(
            data: SliderThemeData(trackShape: CustomTrackShape()),
            child: Slider(
              min: 0,
              max: 100,
              value: value,
              divisions: 10,
              activeColor: AppColors.blue,
              inactiveColor: AppColors.seekerBack.withOpacity(0.2),
              label: calculate(value / 100),
              onChanged: (v) {
                setState(() {
                  value = v;
                });
                _saveSpeed(value / 100);
              },
            ),
          ),
        ],
      ),
    );
  }

  String calculate(double v) {
    double value = 20 / 7 * v + 1 / 7;
    return '${value.toStringAsFixed(1)}x';
  }

  void _saveSpeed(double value) {
    _debouncer.run(() {
      _sharedPref.putDouble(Constants.VOICE_SPEED, value);
    });
  }
}
class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
