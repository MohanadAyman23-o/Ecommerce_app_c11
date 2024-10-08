import 'dart:async';

import 'package:e_commerce_app_c11/core/resources/image_assets.dart';
import 'package:e_commerce_app_c11/core/routes_manager/routes.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, Routes.signInRoute);
    });
    return Scaffold(
      body: Image.asset(
        ImageAssets.splashScreen,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
