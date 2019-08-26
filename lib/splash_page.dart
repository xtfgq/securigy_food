import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_food_warehouse/res/colors.dart';
import 'package:flutter_food_warehouse/res/dimens.dart';
import 'package:flutter_food_warehouse/routers/application.dart';
import 'package:flustars/flustars.dart';
import 'common/common.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    countDown();
  }
  void countDown() {
    var _duration = Duration(seconds: 3);
    Future.delayed(_duration, _go2HomePage);
  }
  @override
  Widget build(BuildContext context) {

    return Stack(children: <Widget>[
      Image(
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
          image: AssetImage("images/welcome.jpg")),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(bottom: ScreenUtil.getInstance().getHeight(200)),
          child: Text( '中储粮'+Constant.base_city+'直属库有限公司',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colours.text_dark,
                  fontSize: Dimens.font_sp16,
                  decoration: TextDecoration.none)),
        ),
      )
    ]);
  }
  void _go2HomePage() {
   Application.router.navigateTo(context,"/index",replace: true);

  }

}
