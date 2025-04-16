import 'dart:async';

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

class _CountDownTimerState extends State<CountDownTimer> with WidgetsBindingObserver {
  late DateTime _startTime;
  late Duration _totalDuration;
  late Timer _timer;
  bool _hasExpired = false;

  int _secondsLeft = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _totalDuration = Duration(seconds: widget.secondsRemaining);

    _startTime = DateTime.now().subtract(
      Duration(seconds: widget.secondsRemaining - (widget.initialValue ?? widget.secondsRemaining)),
    );

    _startTicker();
  }

  void _startTicker() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSecondsLeft(); // start immediately
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateSecondsLeft();
    });
  }

  // void _updateSecondsLeft() {
  //   final elapsed = DateTime.now().difference(_startTime);
  //   final remaining = _totalDuration - elapsed;

  //   final seconds = remaining.inSeconds;

  //   if (seconds <= 0) {
  //     _timer.cancel();
  //     setState(() {
  //       _secondsLeft = 0;
  //     });
  //     widget.whenTimeExpires();
  //   } else {
  //     setState(() {
  //       _secondsLeft = seconds;
  //     });
  //   }
  // }

  void _updateSecondsLeft() {
    final elapsed = DateTime.now().difference(_startTime);
    final remaining = _totalDuration - elapsed;

    final seconds = remaining.inSeconds;

    if (seconds <= 0) {
      if (!_hasExpired && mounted) {
        _hasExpired = true;
        _timer.cancel();

        setState(() {
          _secondsLeft = 0;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          // parent widget build tugagandan keyin ishlaydi
          if (mounted) widget.whenTimeExpires();
        });
      }
    } else {
      if (!_hasExpired && mounted) {
        setState(() {
          _secondsLeft = seconds;
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updateSecondsLeft(); // update when resumed
    }
  }

  @override
  void didUpdateWidget(CountDownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.secondsRemaining != oldWidget.secondsRemaining ||
        widget.initialValue != oldWidget.initialValue) {
      if (_timer.isActive) {
        _timer.cancel();
      }

      _hasExpired = false;

      _totalDuration = Duration(seconds: widget.secondsRemaining);
      _startTime = DateTime.now().subtract(
        Duration(
          seconds: widget.secondsRemaining - (widget.initialValue ?? widget.secondsRemaining),
        ),
      );

      _startTicker();
    }
  }

  // @override
  // void didUpdateWidget(CountDownTimer oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.secondsRemaining != oldWidget.secondsRemaining ||
  //       widget.initialValue != oldWidget.initialValue) {
  //     _timer.cancel();

  //     _totalDuration = Duration(seconds: widget.secondsRemaining);
  //     _startTime = DateTime.now().subtract(
  //       Duration(
  //           seconds: widget.secondsRemaining - (widget.initialValue ?? widget.secondsRemaining)),
  //     );

  //     _startTicker();
  //   }
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  String get timerDisplayString {
    return widget.countDownFormatter?.call(_secondsLeft) ?? formatHHMMSS(_secondsLeft);
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
  Widget build(BuildContext context) {
    final percent = _secondsLeft / _totalDuration.inSeconds;

    return Center(
      child: Row(
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
                percent: percent.clamp(0.0, 1.0),
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
      ),
    );
  }
}
