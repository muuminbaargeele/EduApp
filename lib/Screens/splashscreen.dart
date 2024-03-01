import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:edu_app/Screens/home.dart';
import 'package:edu_app/Screens/login.dart';
import 'package:edu_app/const.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Box box;
  @override
  void initState() {
    super.initState();
    box = Hive.box('local_storage');
    bool isLogin = box.get('isLogin', defaultValue: false);
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => isLogin ? const HomeScreen() : const LoginScreen()));
    });
  }

  sizes(type, size) {
    if (type == "width") {
      double converted = size / 183;
      return MediaQuery.of(context).size.width * converted;
    }
    if (type == "height") {
      double converted = size / 901;
      return MediaQuery.of(context).size.height * converted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Text(
          "EduApp",
          style: GoogleFonts.openSans(
              fontSize: sizes("height", 30),
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
    );
  }
}
