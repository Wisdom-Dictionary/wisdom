import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wisdom/config/constants/app_colors.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget(
      {super.key,
      required this.child,
      this.baseColor,
      this.highlightColor,
      this.shimmerDirection,
      this.enabled,
      this.duration});
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final ShimmerDirection? shimmerDirection;
  final Duration? duration;
  final bool? enabled;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? AppColors.bgLightBlue.withValues(alpha: 0.3),
      highlightColor: highlightColor ?? AppColors.bgLightBlue.withValues(alpha: 0.7),
      enabled: enabled ?? true,
      direction: shimmerDirection ?? ShimmerDirection.ltr,
      period: duration ?? const Duration(seconds: 2),
      child: child,
    );
  }
}
