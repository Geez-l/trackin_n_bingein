import 'package:flutter/material.dart';
import 'package:trackin_n_bingein/buttons/buttons.dart';
import 'package:trackin_n_bingein/styling/styling.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: BackgroundColor.bColor1,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // for splash screen sizing
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 370,
              left: 0,
              bottom: 0,
              child: Image.asset(
                "lib/assets/splash.png",
              ),
            ),
            // for logo
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 320,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  "lib/assets/logofin.png",
                  width: 80,
                  height: 90,
                ),
              ),
            ),
            // app text
            const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 180.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Trackin n Bingein',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Styling.textColor3,
                      ),
                    ),
                    SizedBox(height: 1.0),
                    Text(
                      'Track what you binge',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Styling.textColor3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // button placement
            Positioned(
              bottom: MediaQuery.of(context).size.height / 2 - 300,
              left: 0,
              right: 0,
              child: Center(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Buttons.getStartedButton(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
