import 'package:flutter/material.dart';
import 'package:wisdom/config/constants/app_colors.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.percent,
    required this.ctx,
  });

  final num percent;
  final BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    final barWidth = (MediaQuery.of(context).size.width) * 0.7;
    const double barHeight = 6.0;

    return Stack(
      children: <Widget>[
        Container(
          height: barHeight,
          width: barWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: AppColors.lightBackground,
          ),
        ),
        Container(
          height: barHeight,
          width: barWidth * percent / 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: AppColors.blue,
          ),
        ),
      ],
    );
  }
}
