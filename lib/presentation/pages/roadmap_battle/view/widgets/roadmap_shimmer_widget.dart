import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/roadmap_custom_painter.dart';

class RoadmapShimmerWidget extends StatelessWidget {
  const RoadmapShimmerWidget({super.key});

  static const iconSize = 100.0;
  static const pathCornerRad = 80.0;
  static const layoutSize = 370.0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: SafeArea(
        child: SizedBox(
          height: 900,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  Assets.images.roadmapBattleBackground1,
                  repeat: ImageRepeat.repeat,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade400,
                highlightColor: Colors.grey.shade300,
                enabled: true,
                direction: ShimmerDirection.btt,
                period: const Duration(seconds: 5),
                child: CustomPaint(
                  painter: DashedPathPainter(
                    originalPath: (size) {
                      return _customPath(size, pathCornerRad, iconSize, 6);
                    },
                    pathColors: [],
                    pathColor: AppColors.white,
                    strokeWidth: 40,
                    dashGapLength: 0.01,
                    dashLength: 7.0,
                  ),
                  child: Center(),
                ),
              ),
              CustomPaint(
                painter: DashedPathPainter(
                  originalPath: (size) {
                    return _customPath(size, pathCornerRad, iconSize, 6);
                  },
                  pathColors: [],
                  pathColor: AppColors.blue,
                  strokeWidth: 1,
                  dashGapLength: 10.0,
                  dashLength: 8.0,
                ),
                child: Center(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Path> _customPath(Size size, double painterCornerRad, double iconSize, int iconCount) {
    final width = size.width;

    List<Path> paths = [];
    iconCount = iconCount < 6 ? 6 : iconCount;

    final path = Path();

    final startX = iconSize / 2;
    final startY = ((iconCount - 2) * painterCornerRad * 2) + (iconSize / 2);
    path.moveTo(startX, startY);
    path
      ..arcToPoint(
        Offset(startX + painterCornerRad, startY + painterCornerRad),
        clockwise: false,
        radius: Radius.circular(painterCornerRad),
      )
      ..relativeLineTo(width - (painterCornerRad * 2) - iconSize, 0)
      ..relativeArcToPoint(
        Offset(painterCornerRad + iconSize / 2, 0),
        clockwise: true,
        radius: const Radius.circular(0),
      );

    // paths.add(path.shift(Offset(0, -(pathCornerRad*2))));
    paths.add(path);

    for (int i = 0; i < iconCount - 2; i++) {
      final path = Path();

      if (i % 2 == 0) {
        final startX = iconSize / 2;
        final startY = (i * painterCornerRad * 2) + (iconSize / 2);
        path.moveTo(startX, startY);
        path
          ..arcToPoint(
            Offset(startX + painterCornerRad, startY + painterCornerRad),
            clockwise: false,
            radius: Radius.circular(painterCornerRad),
          )
          ..relativeLineTo(width - (painterCornerRad * 2) - iconSize, 0)
          ..relativeArcToPoint(
            Offset(painterCornerRad, painterCornerRad),
            clockwise: true,
            radius: Radius.circular(painterCornerRad),
          );
      } else {
        final startX = width - iconSize / 2;
        final startY = (i * painterCornerRad * 2) + (iconSize / 2);
        path.moveTo(startX, startY);
        path
          ..arcToPoint(
            Offset(-painterCornerRad + startX, startY + painterCornerRad),
            clockwise: true,
            radius: Radius.circular(painterCornerRad),
          )
          ..relativeLineTo(-width + (painterCornerRad * 2) + iconSize, 0)
          ..relativeArcToPoint(
            Offset(-painterCornerRad, painterCornerRad),
            clockwise: false,
            radius: Radius.circular(painterCornerRad),
          );
      }

      // paths.add(path.shift(Offset(0, -(pathCornerRad*2))));
      paths.add(path);
    }

    return paths;
  }
}
