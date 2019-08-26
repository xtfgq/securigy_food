import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_warehouse/common/common.dart';
import 'package:flutter_food_warehouse/res/colors.dart';
import 'package:flutter_food_warehouse/res/dimens.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        InkWell(
          onTap: () {
            _launchURL();
          },
          child: Container(
            child: Center(
              child: Image(
                  width: ScreenUtil.getInstance().getHeight(375),
                  height: ScreenUtil.getInstance().getHeight(125),
                  image: AssetImage("images/about.png")),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: ScreenUtil.getInstance().getHeight(25),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  '当前版本是',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: Colours.text_dark,
                      fontSize: Dimens.font_sp16,
                      decoration: TextDecoration.none),
                ),
                flex: 13,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment(-1.0, -0.5),
                  child: Text(
                    AppConfig.version,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colours.text_dark,
                        fontSize: Dimens.font_sp16,
                        decoration: TextDecoration.none),
                  ),
                ),
                flex: 10,
              ),
            ],
          ),
        )
      ],
    );
  }

  _launchURL() async {
    final String number = "tel:+15537175968";
    if (await canLaunch(number)) {
      await launch(number);
    } else {
      throw 'Could not launch $number';
    }
  }
}
