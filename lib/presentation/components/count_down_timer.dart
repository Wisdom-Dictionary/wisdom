import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/assets.dart';

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({
    Key? key,
    required this.secondsRemaining,
    required this.whenTimeExpires,
    this.initialValue,
    this.countDownFormatter,
    this.countDownTimerStyle,
  }) : super(key: key);

  final int secondsRemaining;
  final int? initialValue;
  final VoidCallback whenTimeExpires;
  final TextStyle? countDownTimerStyle;
  final Function(int seconds)? countDownFormatter;

  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> with TickerProviderStateMixin {
  late AnimationController _controller;

  String get timerDisplayString {
    final duration = _controller.duration! * _controller.value;
    return widget.countDownFormatter?.call(duration.inSeconds) ?? formatHHMMSS(duration.inSeconds);
  }

  String formatHHMMSS(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secondsLeft = seconds % 60;

    final hoursStr = hours.toString().padLeft(2, '0');
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = secondsLeft.toString().padLeft(2, '0');

    return hours > 0 ? '$hoursStr:$minutesStr:$secondsStr' : '$minutesStr:$secondsStr';
  }

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    final duration = Duration(seconds: widget.secondsRemaining);
    _controller = AnimationController(vsync: this, duration: duration);

    final initialProgress =
        (widget.initialValue ?? widget.secondsRemaining) / widget.secondsRemaining;
    _controller.reverse(from: initialProgress);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        widget.whenTimeExpires();
      }
    });
  }

  @override
  void didUpdateWidget(CountDownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.secondsRemaining != oldWidget.secondsRemaining ||
        widget.initialValue != oldWidget.initialValue) {
      _controller.dispose();
      _initController();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.lavender,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2.5),
                  child: LinearPercentIndicator(
                    lineHeight: 7,
                    progressColor: AppColors.green,
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    fillColor: Colors.transparent,
                    barRadius: const Radius.circular(6),
                    percent: (_controller.duration! * _controller.value).inSeconds /
                        widget.secondsRemaining,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: AppColors.lavender,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(Assets.icons.clock),
                    const SizedBox(width: 4),
                    Text(timerDisplayString, style: widget.countDownTimerStyle),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
