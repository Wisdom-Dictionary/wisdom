import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wisdom/config/constants/app_colors.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.bgLightBlue.withValues(alpha: 0.3),
      highlightColor: AppColors.bgLightBlue.withValues(alpha: 0.7),
      enabled: true,
      period: const Duration(seconds: 2),
      child: child,
    );
  }
}
