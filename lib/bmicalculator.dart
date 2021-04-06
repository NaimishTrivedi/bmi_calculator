import 'dart:math';

import 'package:bmi_calculator/colors/colors.dart';
import 'package:bmi_calculator/strings/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class BMICalculatorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BMICalculatorState();
  }
}

class BMICalculatorState extends State<BMICalculatorPage> {
  bool isManTabSelected = true;
  bool isWoManTabSelected = false;
  double height = 0;
  double weight = 0;
  double bmiValue = 0;
  double needleValue = 0;
  String bmiType = "";
  Color bmiTypeColor = Colors.blue;
  final fieldTextWeight = TextEditingController();
  final fieldTextHeight = TextEditingController();

  TextStyle style = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: AppColors.whiteColor);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //create a man tab button
    final manButton = Material(
      elevation: 2.0,
      color: isManTabSelected
          ? AppColors.transparentWhiteColor
          : AppColors.colorPrimary,
      child: MaterialButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () {
          setState(() {
            isManTabSelected = true;
            isWoManTabSelected = false;
          });
        },
        minWidth: MediaQuery.of(context).size.width / 2,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        child: SizedBox(
          height: 30,
          width: 30,
          child: Image.asset(
            "assets/man.png",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    //create a woman tab button
    final womanButton = Material(
      elevation: 2.0,
      color: isWoManTabSelected
          ? AppColors.transparentWhiteColor
          : AppColors.colorPrimary,
      child: MaterialButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () {
          setState(() {
            isManTabSelected = false;
            isWoManTabSelected = true;
          });
        },
        minWidth: MediaQuery.of(context).size.width / 2,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        child: SizedBox(
          height: 30,
          width: 30,
          child: Image.asset(
            "assets/woman.png",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    //create a height box
    final txtFormFieldHeight = TextField(
      obscureText: false,
      style: style,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.center,
      maxLines: 1,
      maxLength: 6,
      textAlignVertical: TextAlignVertical.center,
      cursorColor: AppColors.whiteColor,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        hintText: Strings.lbl_height,
        hintStyle: style.copyWith(color: AppColors.transparentWhiteColor),
        alignLabelWithHint: true,
        counterText: '',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.whiteColor),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.transparentWhiteColor),
        ),
      ),
      onChanged: (text) {
        setState(() {
          if (text.isEmpty) {
            height = 0;
          } else {
            height = double.parse(text);
          }
          calculateBMI();
        });
      },
      controller: fieldTextHeight,
    );

    //create a weight box
    final txtFormFieldWeight = TextField(
      obscureText: false,
      style: style,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      textAlign: TextAlign.center,
      maxLines: 1,
      maxLength: 6,
      textAlignVertical: TextAlignVertical.center,
      cursorColor: AppColors.whiteColor,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        hintText: Strings.lbl_weight,
        hintStyle: style.copyWith(color: AppColors.transparentWhiteColor),
        alignLabelWithHint: true,
        counterText: '',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.whiteColor),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.transparentWhiteColor),
        ),
      ),
      onChanged: (text) {
        setState(() {
          if (text.isEmpty) {
            weight = 0;
          } else {
            weight = double.parse(text);
          }
          calculateBMI();
        });
      },
      controller: fieldTextWeight,
    );

    final radialGauge = SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
            showLabels: false,
            showAxisLine: false,
            showTicks: false,
            minimum: 0,
            maximum: 99,
            radiusFactor: 1,
            startAngle: 180,
            endAngle: 360,
            canScaleToFit: false,
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Text(
                    Strings.lbl_bmiindex,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.transparentWhiteColor),
                  ),
                  angle: 90,
                  positionFactor: 0.3),
              GaugeAnnotation(
                  widget: Text(
                    bmiValue.toStringAsFixed(1),
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 30.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.whiteColor),
                  ),
                  angle: 90,
                  positionFactor: 0.5),
              GaugeAnnotation(
                  widget: Text(
                    bmiType,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: bmiTypeColor),
                  ),
                  angle: 90,
                  positionFactor: 0.7)
            ],
            ranges: <GaugeRange>[
              GaugeRange(
                  startValue: 0,
                  endValue: 33,
                  color: Colors.blue,
                  // Added range label
                  label: Strings.lbl_underweight,
                  sizeUnit: GaugeSizeUnit.factor,
                  labelStyle: GaugeTextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.whiteColor),
                  startWidth: 0.65,
                  endWidth: 0.65),
              GaugeRange(
                startValue: 33,
                endValue: 66,
                color: Colors.green,
                // Added range label
                label: Strings.lbl_normal,
                labelStyle: GaugeTextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.whiteColor),
                startWidth: 0.65,
                endWidth: 0.65,
                sizeUnit: GaugeSizeUnit.factor,
              ),
              GaugeRange(
                startValue: 66,
                endValue: 99,
                color: Colors.red,
                // Added range label
                label: Strings.lbl_overweight,
                labelStyle: GaugeTextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.whiteColor),
                sizeUnit: GaugeSizeUnit.factor,
                startWidth: 0.65,
                endWidth: 0.65,
              ),
              // Added small height range in bottom to show shadow effect.
              GaugeRange(
                startValue: 0,
                endValue: 9,
                color: const Color.fromRGBO(155, 155, 155, 0.3),
                rangeOffset: 0.5,
                sizeUnit: GaugeSizeUnit.factor,
                startWidth: 0.15,
                endWidth: 0.15,
              ),
            ],
            pointers: <GaugePointer>[
              NeedlePointer(
                  value: needleValue,
                  needleLength: 0.5,
                  lengthUnit: GaugeSizeUnit.factor,
                  needleStartWidth: 1,
                  needleEndWidth: 10,
                  enableAnimation: true,
                  animationDuration: 2000,
                  animationType: AnimationType.linear,
                  knobStyle: KnobStyle(
                    knobRadius: 12,
                    sizeUnit: GaugeSizeUnit.logicalPixel,
                  ))
            ])
      ],
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(Strings.app_name),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: () {
              setState(() {
                clearData();
              });
            },
          )
        ],
      ),
      backgroundColor: AppColors.colorPrimary,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(
              new FocusNode()); //focus remove (softkeybord hide when outside touch)
        },
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[manButton, womanButton],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      margin: const EdgeInsets.only(left: 15.0, top: 0.0, right: 0.0, bottom: 0.0),
                      child: txtFormFieldHeight,
                    )),
                    Expanded(
                        child: Container(
                      margin: const EdgeInsets.only(
                          left: 15.0, top: 0.0, right: 15.0, bottom: 0.0),
                      child: txtFormFieldWeight,
                    ))
                  ],
                ),
                SizedBox(height: 50.0),
                radialGauge,
              ],
            ),
          ),
        ),
      ),
    );
  }

  //calculate bmi
  void calculateBMI() {
    if (height > 0 && weight > 0) {
      bmiValue = weight / pow(height / 100, 2);
    } else {
      bmiValue = 0;
    }
    if (bmiValue > 0) {
      //needleValue = (bmiValue * 100) / 40;
      double resultPer = 0;
      if (bmiValue < 18.5) {
        bmiType = Strings.lbl_underweight;
        bmiTypeColor = Colors.blue;
        resultPer = getResultPercentage(16.0, 18.5);
        needleValue = getNeedleValue(resultPer, 0, 33);
      } else if (bmiValue < 25) {
        bmiType = Strings.lbl_normal;
        bmiTypeColor = Colors.green;
        resultPer = getResultPercentage(18.5, 25.0);
        needleValue = getNeedleValue(resultPer, 33, 66);
      } else if (bmiValue < 30) {
        bmiType = Strings.lbl_overweight;
        bmiTypeColor = Colors.red;
        resultPer = getResultPercentage(25.0, 40.0);
        needleValue = getNeedleValue(resultPer, 66, 99);
      } else {
        bmiType = Strings.lbl_obese;
        bmiTypeColor = Colors.red;
        resultPer = getResultPercentage(25.0, 40.0);
        needleValue = getNeedleValue(resultPer, 66, 99);
      }
    } else {
      needleValue = 0;
      bmiType = "";
      bmiTypeColor = Colors.blue;
    }
  }

  /*
  * range = max - min (40-25) = 15
  * correctedStartValue = input - min (25.8 - 25) = 0.8
  * percentage = (correctedStartValue * 100) / range = (0.8 * 100) / 15 = 5.33%

  * If you already have the percentage and you're looking for the "input value" in a given range, then you can use the adjusted formula

  * value = (percentage * (max - min) / 100) + min

  * = (5.33 * (99 - 66) / 100) + 66
  */

  double getResultPercentage(double minRange, double maxRange) {
    double resultPer = 0;
    if (minRange > 0 && maxRange > 0) {
      resultPer = ((bmiValue - minRange) * 100) / (maxRange - minRange);
    }

    return resultPer;
  }

  double getNeedleValue(double resultPer,double minRange, double maxRange){
    double needleValue = 0;
    if(resultPer > 0){
      needleValue = (resultPer * (maxRange - minRange) / 100) + minRange;
    }
    return needleValue;
  }

  void clearData() {
    height = 0;
    weight = 0;
    bmiValue = 0;
    needleValue = 0;
    bmiType = "";
    bmiTypeColor = Colors.blue;
    fieldTextHeight.clear();
    fieldTextWeight.clear();
  }

}
