import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class AppHelper{
  /*
  Pop and removed current page, and push with new page
   */
  static void popAndPushReplacement(context, String dest){
    try {
      Navigator.of(context).pushReplacementNamed(dest);
    }
    catch(error){
      print(error);
    }
  }

  /*
  Pop current page
   */
  static void pop(context){
    try {
      Navigator.of(context).pop();
    }
    catch(error){
      print(error);
    }
  }

  /*
  Pop and just pushed new page without removing it.
   */
  static void push(context, String dest){
    try {
      Navigator.of(context).pushNamed(dest);
    }
    catch(error){
      print(error);
    }
  }

  /*
  Go to new page.
   */
 static void goToPage(context, bool removePage, String destPage){
    if(removePage == true) {
      popAndPushReplacement(context, destPage);
    }
    if(removePage == false){
     push(context, destPage);
    }
  }

  /*
  String to int conversion
   */
  static int stringToIntConversion(String value)
  {
    int intValue = 0;
    try{
      intValue = int.parse(value);
    }
    catch(error){
      intValue = 0;
      print(error);
    }
    return intValue;
  }

  /***
   * Email validation
   */
  static String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  /*
  validate name
   */
 static String validateName(String value) {
   if(value.isEmpty){
     return 'Enter valid name';
   }
    if (value.length < 3)
      return 'Name must be more than 2 character';
    else
      return null;
  }

  /*
  Show Snackbar
   */
  static void showSnackBar(String value, GlobalKey<ScaffoldState> scaffoldKey){
    scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
  }

  /*
  Text with icon
   */
 static Widget textWithIcon(IconData icon, String text, double padding, double textSize,  Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, color: color),
        Padding(
          padding:  EdgeInsets.only(left: padding),
          child: Text(
            text,
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: textSize,
                color: color),
          ),
        ),
      ],
    );
  }

  static DateTime convertToDateTime(time){
   DateTime convertedDateTime;
      try{
        Timestamp timestamp = time;
        convertedDateTime = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
      }
      catch(error) {
        print("DATE TIME CONVERSION ERROR: " + convertedDateTime.toString());
      }
      return convertedDateTime;
  }

  static String dateToReadableString(DateTime time){
   return time.year.toString() + "-" + time.month.toString() + "-" + time.day.toString()
       + " " + time.hour.toString() + ":" + addLeadZeroToNumber(time.minute);
  }

  static String addLeadZeroToNumber(int time){
   String readableTime = time.toString();
   if(time < 9){
     return readableTime.padLeft(2,"0");
   }
   return readableTime;
  }
}