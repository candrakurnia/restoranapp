// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restoranapp/ui/page/homescreen_page.dart';

class SplashScreenPage extends StatefulWidget {
  static const routeName = '/SplashScreen';
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  startsplashscreen() {
    var duration = const Duration(seconds: 3);

    return Timer(
      duration,
      () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreenPage()));
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startsplashscreen();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: SvgPicture.asset(
          'assets/images/logo_restogo.svg',
        ),
      ),
    );
  }
}
