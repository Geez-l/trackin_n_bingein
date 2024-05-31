import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trackin_n_bingein/screens/media_pages/details.dart';
import 'package:trackin_n_bingein/screens/navigation.dart';
import 'package:trackin_n_bingein/screens/splash.dart';
import 'package:trackin_n_bingein/screens/user_authentication_pages/signin.dart';
import 'package:trackin_n_bingein/screens/user_authentication_pages/signup.dart';
// import 'package:trackin_n_bingein/screens/interests.dart';
import 'package:trackin_n_bingein/screens/homepage.dart';
import 'package:trackin_n_bingein/screens/statistics.dart';
import 'package:trackin_n_bingein/screens/profile_pages/profile.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    theme: ThemeData(
      scaffoldBackgroundColor: Color.fromARGB(255, 235, 235, 235)
      ),    
    debugShowCheckedModeBanner: false,
    routes: {
      "/": (context) => Splash(),
      '/signin': (context) => Signin(),
      '/signup': (context) => Signup(),
      '/details': (context) => Details(title: '',),
      // '/interests': (context) => Interests(username: '',), // Placeholder
      '/navigation': (context) => Navigation(email: '',), // Placeholder
      '/homepage': (context) => Homepage(email: '',), // Placeholder
      '/statistic': (context) => Statistics(),
      // '/media': (context) => Media(),
    },
  ));
}