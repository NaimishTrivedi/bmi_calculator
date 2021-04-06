import 'dart:async';

import 'package:bmi_calculator/bmicalculator.dart';
import 'package:bmi_calculator/colors/colors.dart';
import 'package:bmi_calculator/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'transitions/enter_exit_route.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.app_name,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: AppColors.colorPrimary,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}

class SplashState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.colorPrimary,
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: initScreen(context),
    );
  }

  startTime() async {
    var duration = new Duration(seconds: 2);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => BMICalculatorPage()));
  }

  initScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorPrimary,
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 36.0, top: 0.0, right: 36.0, bottom: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 200.0,
                width: 200.0,
                child: Image.asset(
                  "assets/app_logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                Strings.app_name,
                style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 30.0,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }
}
