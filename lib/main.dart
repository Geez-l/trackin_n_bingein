import 'package:flutter/material.dart';
import 'package:trackin_n_bingein/screens/splash.dart';
import 'package:trackin_n_bingein/screens/signin.dart';
import 'package:trackin_n_bingein/screens/signup.dart';
import 'package:trackin_n_bingein/screens/homepage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      "/": (context) => Splash(),
      '/signin': (context) => Signin(),
      '/signup': (context) => Signup(),
      '/homepage': (context) => Homepage(), 
      // '/media': (context) => Media(),
    },
  ));
}