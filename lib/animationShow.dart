import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class showAnimation extends StatefulWidget {
  const showAnimation({super.key});

  @override
  State<showAnimation> createState() => _showAnimationState();
}

class _showAnimationState extends State<showAnimation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Lottie.asset('assets/noQuestion.json'),
    );
  }
}
