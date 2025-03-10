import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/data/model/roadmap/level_model.dart';
import 'package:wisdom/domain/repositories/roadmap_repository.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/widgets/roadmap_shimmer_widget.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/widgets/task_level_indicator_widget.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/roadmap_viewmodel.dart';

class ExampleRoadMap extends StatefulWidget {
  const ExampleRoadMap({super.key, required this.viewModel});

  final RoadMapViewModel viewModel;
  @override
  State<ExampleRoadMap> createState() => _ExampleRoadMapState();
}

class _ExampleRoadMapState extends State<ExampleRoadMap> {
  Container backgroundGradient(LinearGradient gradient) {
    return Container(
      height: 137,
      decoration: BoxDecoration(gradient: gradient),
    );
  }

  LinearGradient topGradient() {
    return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        tileMode: TileMode.clamp,
        colors: [
          Color(0xFFE2F2F8),
          Color(0x00F0F8FB),
        ]);
  }

  LinearGradient bottomGradient() {
    return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        tileMode: TileMode.clamp,
        colors: [
          Color(0x00F0F8FB),
          Color(0xFFE2F2F8),
        ]);
  }

  static const iconSize = 100.0;
  static const pathCornerRad = 80.0;
  static const layoutSize = 370.0;

  List<Positioned> levelItems(RoadmapRepository repository) {
    List positions = [
      {"left": null, "right": 83, "bottom": 1},
      {"left": 82, "right": null, "bottom": 1.05},
      {"left": 20, "right": null, "bottom": 1.7},
      {"left": null, "right": 126, "bottom": 2},
      {"left": null, "right": 14, "bottom": 2.8},
      {"left": 120, "right": null, "bottom": 3},
      {"left": 10, "right": null, "bottom": 3.5},
      {"left": 100, "right": null, "bottom": 4},
      {"left": null, "right": 14, "bottom": 4.2},
      {"left": null, "right": 50, "bottom": 5},
      {"left": 82, "right": null, "bottom": 5.1},
      {"left": 20, "right": null, "bottom": 5.8},
      {"left": null, "right": 100, "bottom": 6},
      {"left": null, "right": 14, "bottom": 6.6},
      {"left": 120, "right": null, "bottom": 7},
      {"left": 14, "right": null, "bottom": 7.5},
      {"left": 150, "right": null, "bottom": 8},
      {"left": null, "right": 30, "bottom": 8.3},
      {"left": null, "right": 20, "bottom": 9},
      {"left": 80, "right": null, "bottom": 9.05},
      {"left": 20, "right": null, "bottom": 9.8},
      {"left": null, "right": 110, "bottom": 10},
      {"left": null, "right": 20, "bottom": 10.6},
      {"left": null, "right": 100, "bottom": 11},
      {"left": 60, "right": null, "bottom": 11.1},
      {"left": 14, "right": null, "bottom": 11.8},
      {"left": 0, "right": 0, "bottom": 12},
      {"left": null, "right": 20, "bottom": 12.3},
      {"left": null, "right": 50, "bottom": 13},
      {"left": 80, "right": null, "bottom": 13},
      {"left": 20, "right": null, "bottom": 13.7},
      {"left": 115, "right": null, "bottom": 14},
      {"left": null, "right": 30, "bottom": 14.3},
      {"left": null, "right": 30, "bottom": 15},
      {"left": 0, "right": 0, "bottom": 15.1},
      {"left": 10, "right": null, "bottom": 15.3},
      {"left": 50, "right": null, "bottom": 16},
      {"left": null, "right": 100, "bottom": 16.1},
      {"left": null, "right": 20, "bottom": 16.7},
      {"left": null, "right": 130, "bottom": 17},
      {"left": 10, "right": null, "bottom": 17.3},
      // Backenddan kelgan ma'lumotlar soni o'zgaradi
    ];
    return List.generate(repository.levelsList.length, (index) {
      int positionIndex = index;
      if (index >= positions.length) {
        positionIndex = positions.length - 1;
      }

      double? left = (positions[positionIndex]["left"] as int?)?.toDouble();
      double? right = (positions[positionIndex]["right"] as int?)?.toDouble();
      double? bottom = ((positions[positionIndex]["bottom"] ?? 1) * pathCornerRad * 2).toDouble();
      bool activeLevel = repository.levelsList[index].userCurrentLevel ?? false;

      return Positioned(
          left: left,
          right: right,
          bottom: activeLevel && bottom != null ? bottom - 80 : (bottom! - 50),
          child: GestureDetector(
              onTap: () => widget.viewModel.selectLevel(repository.levelsList[index]),
              child: repository.levelsList[index].itemWidget

              // InactiveLevelIndicator(
              //   activeLevel: activeLevel,
              //   item: repository.levelsList[index],
              // ),
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.viewModel.isBusy(tag: widget.viewModel.getLevelsTag))
          const RoadmapShimmerWidget(),
        if (widget.viewModel.isSuccess(tag: widget.viewModel.getLevelsTag))
          Center(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              reverse: true,
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              Assets.images.roadmapBattleBackground,
                              alignment: Alignment.bottomCenter,
                              repeat: ImageRepeat.repeat,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          Positioned.fill(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              backgroundGradient(topGradient()),
                              backgroundGradient(bottomGradient())
                            ],
                          ))
                        ],
                      ),
                    ),
                    CustomPaint(
                      painter: DashedPathPainter(
                        originalPath: (size) {
                          return _customPath(size, pathCornerRad, iconSize,
                                  widget.viewModel.roadMapRepository.levelsList.length)
                              .reversed
                              .toList();
                        },
                        pathColors: [],
                        pathColor: AppColors.white,
                        strokeWidth: 40,
                        dashGapLength: 0.01,
                        dashLength: 7.0,
                      ),
                      child: const Center(),
                    ),
                    CustomPaint(
                      painter: DashedPathPainter(
                        originalPath: (size) {
                          return _customPath(size, pathCornerRad, iconSize,
                              widget.viewModel.roadMapRepository.levelsList.length);
                        },
                        pathColors: [],
                        pathColor: AppColors.blue,
                        strokeWidth: 1,
                        dashGapLength: 10.0,
                        dashLength: 8.0,
                      ),
                      child: SizedBox(
                          width: iconSize * 70,
                          height: (pathCornerRad * 2) *
                              (widget.viewModel.roadMapRepository.levelsList.length < 6
                                  ? 6
                                  : widget.viewModel.roadMapRepository.levelsList.length),
                          child: Stack(children: levelItems(widget.viewModel.roadMapRepository))),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Positioned(
            top: 90,
            right: 5,
            child: SafeArea(
              child: FlagIndicatorWidget(
                userLevel: widget.viewModel.roadMapRepository.userCurrentLevel,
              ),
            ))
      ],
    );
  }

  List<Path> _customPath(Size size, double painterCornerRad, double iconSize, int iconCount) {
    final width = size.width;

    List<Path> paths = [];
    iconCount = iconCount < 6 ? 6 : iconCount;

    final path = Path();

    final startX = iconSize / 2;
    final startY = ((iconCount - 2) * painterCornerRad * 2) + (iconSize);
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

    paths.add(path);

    for (int i = 0; i < iconCount - 2; i++) {
      final path = Path();

      if (i % 2 == 0) {
        final startX = iconSize / 2;
        final startY = (i * painterCornerRad * 2) + (iconSize);
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
        final startY = (i * painterCornerRad * 2) + (iconSize);
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

      paths.add(path);
    }

    return paths;
  }
}

class DashedPathPainter extends CustomPainter {
  final List<Path> Function(Size) originalPath;
  final List<Color> pathColors;
  final Color pathColor;
  final double strokeWidth;
  final double dashGapLength;
  final double dashLength;

  DashedPathPainter({
    required this.originalPath,
    required this.pathColors,
    required this.pathColor,
    this.strokeWidth = 3.0,
    this.dashGapLength = 5.0,
    this.dashLength = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paths = originalPath.call(size);

    for (int i = 0; i < paths.length; i++) {
      final dashedPath = _getDashedPath(
          DashedPathProperties(
            path: Path(),
            dashLength: dashLength,
            dashGapLength: dashGapLength,
          ),
          paths[i],
          dashLength,
          dashGapLength);

      Color color = pathColor;
      if (i < pathColors.length) {
        color = pathColors[i];
      }

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..color = color
        ..strokeWidth = strokeWidth;
      canvas.drawPath(dashedPath, paint);
    }
  }

  @override
  bool shouldRepaint(DashedPathPainter oldDelegate) =>
      oldDelegate.originalPath != originalPath ||
      oldDelegate.pathColor != pathColor ||
      oldDelegate.pathColors != pathColors ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.dashGapLength != dashGapLength ||
      oldDelegate.dashLength != dashLength;

  Path _getDashedPath(
    DashedPathProperties pathProps,
    Path originalPath,
    double dashLength,
    double dashGapLength,
  ) {
    final metricsIterator = originalPath.computeMetrics().iterator;
    while (metricsIterator.moveNext()) {
      final metric = metricsIterator.current;
      pathProps.extractedPathLength = 0.0;
      while (pathProps.extractedPathLength < metric.length) {
        if (pathProps.addDashNext) {
          pathProps.addDash(metric, dashLength);
        } else {
          pathProps.addDashGap(metric, dashGapLength);
        }
      }
    }
    return pathProps.path;
  }
}

class DashedPathProperties {
  double extractedPathLength;
  Path path;

  final double _dashLength;
  double _remainingDashLength;
  double _remainingDashGapLength;
  bool _previousWasDash;

  DashedPathProperties({
    required this.path,
    required double dashLength,
    required double dashGapLength,
  })  : assert(dashLength > 0.0, 'dashLength must be > 0.0'),
        assert(dashGapLength > 0.0, 'dashGapLength must be > 0.0'),
        _dashLength = dashLength,
        _remainingDashLength = dashLength,
        _remainingDashGapLength = dashGapLength,
        _previousWasDash = false,
        extractedPathLength = 0.0;

  bool get addDashNext {
    if (!_previousWasDash || _remainingDashLength != _dashLength) {
      return true;
    }
    return false;
  }

  void addDash(ui.PathMetric metric, double dashLength) {
    // Calculate lengths (actual + available)
    final end = _calculateLength(metric, _remainingDashLength);
    final availableEnd = _calculateLength(metric, dashLength);
    // Add path
    final pathSegment = metric.extractPath(extractedPathLength, end);
    path.addPath(pathSegment, Offset.zero);
    // Update
    final delta = _remainingDashLength - (end - extractedPathLength);
    _remainingDashLength = _updateRemainingLength(
      delta: delta,
      end: end,
      availableEnd: availableEnd,
      initialLength: dashLength,
    );
    extractedPathLength = end;
    _previousWasDash = true;
  }

  void addDashGap(ui.PathMetric metric, double dashGapLength) {
    // Calculate lengths (actual + available)
    final end = _calculateLength(metric, _remainingDashGapLength);
    final availableEnd = _calculateLength(metric, dashGapLength);
    // Move path's end point
    ui.Tangent tangent = metric.getTangentForOffset(end)!;
    path.moveTo(tangent.position.dx, tangent.position.dy);
    // Update
    final delta = end - extractedPathLength;
    _remainingDashGapLength = _updateRemainingLength(
      delta: delta,
      end: end,
      availableEnd: availableEnd,
      initialLength: dashGapLength,
    );
    extractedPathLength = end;
    _previousWasDash = false;
  }

  double _calculateLength(ui.PathMetric metric, double addedLength) {
    return math.min(extractedPathLength + addedLength, metric.length);
  }

  double _updateRemainingLength({
    required double delta,
    required double end,
    required double availableEnd,
    required double initialLength,
  }) {
    return (delta > 0 && availableEnd == end) ? delta : initialLength;
  }
}
