import 'package:Surprize/Dashboard.dart';
import 'package:Surprize/Helper/AppHelper.dart';
import 'package:Surprize/LoginPage.dart';
import 'package:Surprize/Memory/UserMemory.dart';
import 'package:Surprize/Models/NoNetwork.dart';
import 'package:Surprize/NoInternetConnectionPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:Surprize/Resources/ImageResources.dart';

class SplashScreen extends StatefulWidget {

  SplashScreen();

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  Image logoImage;
  var subscription;
  bool noInternetConnection = false;

  @override
  initState() {
    super.initState();
    logoImage = Image.asset(ImageResources.appMainLogo);
    Firestore.instance.settings(persistenceEnabled: false);
    checkIfUserLoggedIn(context);
    checkNetworkConnection();
  }


  /// Check if user is logged in
  checkIfUserLoggedIn(context){
    FirebaseAuth.instance.currentUser().then((user){
      if(user == null) {
        AppHelper.cupertinoRouteWithPushReplacement(context, LoginPage());
      } else{
          UserMemory().firebaseUser = user;
          Dashboard(context).nav();
      }
    });
  }


  @override
  void dispose() {
    if(subscription != null){
      subscription.cancel();
      subscription= null;
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(logoImage.image, context);
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              color: Colors.purple[800],
                image:DecorationImage(image: AssetImage(ImageResources.appBackgroundImage), fit: BoxFit.cover)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                logoImage,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Visibility(visible: noInternetConnection, child: Text("No internet connection",style: TextStyle(fontFamily: 'Raleway', color: Colors.white),)),
                  )
                ],
              ),
            ),
          )),
    );
  }

  /// Check for network connection
  checkNetworkConnection(){
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {

      if(result == ConnectivityResult.none){
        setState(() {
          noInternetConnection = true;
        });
      }
      else if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
        AppHelper.checkInternetConnection().then((val){
          if(val){
           // checkIfUserLoggedIn(context);
          }
        });
      }
      else{
        setState(() {
          noInternetConnection = true;
        });
      }
    });
  }
}
