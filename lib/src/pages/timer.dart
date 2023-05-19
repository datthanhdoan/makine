import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Timer extends StatefulWidget {
  const Timer({super.key});

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> with SingleTickerProviderStateMixin {
  // controller
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  bool already = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/music.json'),
      ),
    );
  }
}
