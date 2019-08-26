import 'package:fluro/fluro.dart';
import 'package:flutter_food_warehouse/pages/change_pwd_page.dart';
import 'package:flutter_food_warehouse/pages/home_page.dart';
import 'package:flutter_food_warehouse/pages/index_page.dart';
import 'package:flutter_food_warehouse/pages/login_page.dart';
import 'package:flutter_food_warehouse/pages/msg_page.dart';
import 'package:flutter_food_warehouse/pages/peron_info.dart';
import 'package:flutter_food_warehouse/pages/security_check_page.dart';
import 'package:flutter_food_warehouse/pages/webview.dart';
import 'dart:convert';

Handler homeHandler = Handler(handlerFunc: (_, params) {
  return HomePage();
});
Handler webHandler = Handler(handlerFunc: (_, params) {
  var list = List<int>();
  jsonDecode(params['url'].first).forEach(list.add);
  String valueUrl = Utf8Decoder().convert(list).trim();
  //因为使用这种方法会产生前后各一个引号，顾去掉
  valueUrl = valueUrl.substring(1, valueUrl.length - 1);
  var listTitle = List<int>();
  jsonDecode(params['title'].first).forEach(listTitle.add);
  String valueTitle = Utf8Decoder().convert(listTitle).trim();
  valueTitle = valueTitle.substring(1, valueTitle.length - 1);
  return WebViewPage(url: valueUrl, title: valueTitle);
});
Handler indexHandler = Handler(handlerFunc: (_, params) {
  return IndexPage();
});
Handler loginHandler = Handler(handlerFunc: (_, params) {
  String tag=params['tag'].first;
  return LoginPage(tag);
});
Handler personHandler = Handler(handlerFunc: (_, params) {
  return PersonInfoPage();
});
Handler changPwdPageHandler = Handler(handlerFunc: (_, params) {
  return ChangePwdPage();
});
Handler securityPageHandler = Handler(handlerFunc: (_, params) {
  return SecurityCheckPage();
});
Handler msgPageHandler = Handler(handlerFunc: (_, params) {
  return MsgPage();
});