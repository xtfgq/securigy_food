import 'dart:io';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_food_warehouse/res/colors.dart';
import 'package:flutter_food_warehouse/routers/routers.dart';
import 'package:flutter_food_warehouse/splash_page.dart';
import 'common/common.dart';
import 'routers/application.dart';


void main() async{

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    }
  });
} 

class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router=router;
    Color _themeColor = Colours.green_1;


    return MaterialApp(
      title: AppConfig.appName,
      theme: ThemeData.light().copyWith(
        primaryColor: _themeColor,
        accentColor: _themeColor,
        indicatorColor: Colors.white,
      ),
      home: SplashPage()
    );
  }

}


