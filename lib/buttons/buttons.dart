import 'package:flutter/material.dart';
import 'package:trackin_n_bingein/screens/media_pages/details.dart';
import 'package:trackin_n_bingein/styling/styling.dart';
import 'package:trackin_n_bingein/screens/user_authentication_pages/signin.dart';

class Buttons {
  // Get Started button
  static Widget getStartedButton(BuildContext context) {
    return ElevatedButton(
      child: const Text('Get Started'),
      style: ElevatedButton.styleFrom(
        foregroundColor: ButtonStyling.primaryColor, 
        backgroundColor: ButtonStyling.buttonTextColor,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        textStyle: TextStyle(fontSize: 18),
        elevation: 3,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Signin(),
          ),
        );
      },
    );
  }

  //marked as finished button
  static Widget finishButton(BuildContext context) {
    return ElevatedButton(
      child: const Text('Mark as finished'),
      style: ElevatedButton.styleFrom(
        foregroundColor: ButtonStyling.primaryColor,
        backgroundColor: ButtonStyling.buttonTextColor,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        textStyle: TextStyle(fontSize: 18),
        elevation: 3,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Details(title: '',),
          ),
        );
      },
    );
  }

  // cancel button
  static Widget cancelButton(BuildContext context) {
    return ElevatedButton(
      child: const Text('Cancel'),
      style: ElevatedButton.styleFrom(
        foregroundColor: ButtonStyling.buttonTextColor,
        backgroundColor: ButtonStyling.buttonColor1,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        textStyle: TextStyle(fontSize: 18),
        elevation: 3,
      ),
      onPressed: () {
        Navigator.pop(context);
    
      },
    );
  }

  //save button
  static Widget saveButton(BuildContext context) {
    return ElevatedButton(
      child: const Text('Save'),
      style: ElevatedButton.styleFrom(
        foregroundColor: ButtonStyling.primaryColor,
        backgroundColor: ButtonStyling.buttonTextColor,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 25),
        textStyle: TextStyle(fontSize: 20),
        elevation: 3,
      ),
      onPressed: () {
      },
    );
  }

  //add media button
    static Widget addButton(BuildContext context, VoidCallback onPressed) {
    return ElevatedButton(
      child: const Text('Add Media'),
      style: ElevatedButton.styleFrom(
        foregroundColor: ButtonStyling.primaryColor,
        backgroundColor: ButtonStyling.buttonTextColor,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 25),
        textStyle: TextStyle(fontSize: 20),
        elevation: 3,
      ),
      onPressed: onPressed,
    );
  }
}
