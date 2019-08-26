import 'package:fluro/fluro.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_warehouse/res/colors.dart';
import 'package:flutter_food_warehouse/routers/application.dart';
import 'package:flutter_food_warehouse/routers/routers.dart';


class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initInfo();
  }

  void _initInfo() async {
    await SpUtil.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _cell(index, "退出登录", true, context);
          } else if (index == 1) {
            return _cell(index, "密码重置", true, context);
          }
        },
        itemCount: 2,
      ),
    );
  }
}

///显示菜单
Widget _cell(
    int row, String title, bool isShowBottomLine, BuildContext context) {
  return GestureDetector(
    onTap: () {
      switch (row) {
        case 0:
          _showExitDialog(context);
          break;
        case 1:
          Application.router.navigateTo(context, Routes.changPwdPage);
          break;
      }
    },
    child: Container(
      color: Colours.white,
      height: 50.0,
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            height: 45.0,
            child: ListTile(
              title: Text(title),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 17.0,
              ),
            ),
          ),
          _bottomLine(isShowBottomLine),
        ],
      ),
    ),
  );
}

///退出登录
Widget _showExitDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('温馨提示'),
        content: Text('确定要退出登录吗？'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('取消'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: Text('确定'),
            onPressed: () {
              SpUtil.clear();
              Navigator.of(context).pop();
              String tag = "Exit";
              Application.router.navigateTo(context, "/login?tag=${tag}",
                  transition: TransitionType.inFromRight);
            },
          ),
        ],
      );
    },
  );
}

///添加下划线
Widget _bottomLine(bool isShowBottomLine) {
  if (isShowBottomLine) {
    return new Container(
        margin: EdgeInsets.all(0.0),
        child: Divider(height: 1.0, color: Colors.black),
        padding: EdgeInsets.only(left: 15.0, right: 15.0));
  }
  return Container();
}
