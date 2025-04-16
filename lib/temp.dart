import 'dart:async';

import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    home: CountdownTimer(
      totalDuration: Duration(seconds: 160),
    ),
  ));
}

class CountdownTimer extends StatefulWidget {
  final Duration totalDuration;

  const CountdownTimer({super.key, required this.totalDuration});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> with WidgetsBindingObserver {
  late DateTime _startTime;
  late Duration _totalDuration;
  Duration _remaining = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startTime = DateTime.now();
    _totalDuration = widget.totalDuration;
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      final passed = DateTime.now().difference(_startTime);
      final remaining = _totalDuration - passed;

      setState(() {
        _remaining = remaining.isNegative ? Duration.zero : remaining;
      });

      if (_remaining == Duration.zero) {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Resume bo'lsa, vaqt yangilanadi
      final passed = DateTime.now().difference(_startTime);
      final remaining = _totalDuration - passed;
      setState(() {
        _remaining = remaining.isNegative ? Duration.zero : remaining;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return Scaffold(body: Center(child: Text('$minutes:$seconds', style: TextStyle(fontSize: 32))));
  }
}
