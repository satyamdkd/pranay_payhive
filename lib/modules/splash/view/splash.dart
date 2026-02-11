import 'dart:io';

import 'package:flutter/material.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (val, result) {
        exit(0);
      },
      child: Scaffold(
        backgroundColor: appColors.white,
        body: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage("assets/images/splash_bg.png"),
            //   fit: BoxFit.cover,
            // ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: SizedBox(
            height: height / 2,
            width: height / 2,
            child: Image.asset(
              "assets/icons/payhive_logo.png",
              fit: BoxFit.contain,
            ),
          ).animate().fade(duration: 500.ms).scale(delay: 600.ms),
        ),
      ),
    );
  }
}
