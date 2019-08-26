import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_food_warehouse/routers/rooter_handler.dart';

class Routes{
  static String root='/';
  static String homePage = '/home';
  static String webPage = '/web';
  static String indexPage = '/index';
  static String loginPage = '/login';
  static String personPage = '/person';
  static String changPwdPage = '/pwd';
  static String securityPage = '/security';
  static String msgPage = '/msg';
  static void configureRoutes(Router router){
    router.notFoundHandler= new Handler(
        handlerFunc: (BuildContext context,Map<String,List<String>> params){
          print('ERROR====>ROUTE WAS NOT FONUND!!!');
        }
    );

    router.define(homePage,handler:homeHandler);
    router.define(webPage,handler:webHandler);
    router.define(indexPage,handler:indexHandler);
    router.define(loginPage,handler:loginHandler);
    router.define(personPage,handler:personHandler);
    router.define(changPwdPage,handler:changPwdPageHandler);
    router.define(securityPage,handler:securityPageHandler);
    router.define(msgPage,handler:msgPageHandler);
  }

}