import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_food_warehouse/receiver/event_bus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_warehouse/http/services_http.dart';
import 'package:flutter_food_warehouse/res/colors.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_food_warehouse/res/ids.dart';
import 'package:flutter_getuuid/flutter_getuuid.dart';
import 'login_bean.dart';

class LoginPage extends StatefulWidget {
  String tag;

  LoginPage(this.tag);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ///用户账号
  String _userName = "";

  ///用户密码
  String _pwd = "";
  HttpUtils _httpUtils = HttpUtils();

//  List<HomeBean> homeBeans;
  Map<String, String> loginHeaders = {
    'method': 'userLoginByNameAndPassword',
  };

  Map<String, String> userHeaders = {'method': 'findUserById'};
  Map<String, String> userParams = Map();

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  void _initAsync() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    await SpUtil.getInstance();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print(androidInfo.androidId);
      SpUtil.putString(Ids.deviceId, androidInfo.androidId);
    } else {
      // e.g. "iPod7,1"
      String uuid = await FlutterGetuuid.platformUid;
      SpUtil.putString(Ids.deviceId, uuid);
    }
  }

  DateTime lastPopTime;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: WillPopScope(
        onWillPop: () async {
        if ("Exit" == widget.tag) {
          if (lastPopTime == null ||
              DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
            lastPopTime = DateTime.now();
            Fluttertoast.showToast(
                fontSize: ScreenUtil.getInstance().getSp(13),
                gravity: ToastGravity.CENTER,
                msg: "再按一次退出~");
          } else {
            lastPopTime = DateTime.now();
            // 退出app
            await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
          return false;
        }
        if ("ToLogin" == widget.tag) {
          Navigator.of(context).pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: MyAppBar(
          title: Text('登录'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            margin:
                const EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 20),
            child: Column(
              children: <Widget>[
                _buildContainerUserName(),
                _buildContainerPwd(),
                _buildContainerLogin(context),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('温馨提示'),
          content: Text('确定要退出应用吗？'),
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
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }

  Container _buildContainerLogin(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 24.0),
        child: new CupertinoButton(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width / 2.0 - 48.0,
                8.0,
                MediaQuery.of(context).size.width / 2.0 - 48.0,
                8.0),
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
            color: Colours.green_1,
            child: Text(
              '登录',
              style: new TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            onPressed: () {
              //按钮点击事件
              FocusScope.of(context).requestFocus(FocusNode());

              ///输入合法性检查
              if (_userName == null || _userName.length == 0) {
                Fluttertoast.showToast(
                    fontSize: ScreenUtil.getInstance().getSp(13),
                    gravity: ToastGravity.CENTER,
                    msg: "用户名为空~");
                return;
              }
              if (_pwd == null || _pwd.length == 0) {
                Fluttertoast.showToast(
                    fontSize: ScreenUtil.getInstance().getSp(13),
                    gravity: ToastGravity.CENTER,
                    msg: "密码为空~");
                return;
              }

              Map<String, String> _tmpLoginParams = {
                'userName': _userName,
                'password': _pwd,
                'deviceId': SpUtil.getString(Ids.deviceId),
                'token': SpUtil.getString(Ids.token)
              };
//              Map<String, String> _tmpLoginParams = {
//                'userName': "13603913313",
//                'password': "12345678",
//                'deviceId': "865563046496684",
//                'token': "f4eac347445a9e324e939fe8af5d0d214f04c522"
//              };

              Map<String, String> loginParams = {};
              loginParams.addAll(_tmpLoginParams);
              _httpUtils.request(loginHeaders, loginParams).then((data) async {
                try {
                  Map<String, dynamic> resultrMap =
                      new Map<String, dynamic>.from(data);

                  if (int.parse(resultrMap['rtnCode'].toString()) == 0) {
                    LoginBean loginBean = LoginBean.fromJson(resultrMap['res']);
                    await SpUtil.getInstance();
                    SpUtil.putString(Ids.tokenUser, loginBean.token);
                    SpUtil.putString(Ids.userId, loginBean.userId.toString());
                    String id = loginBean.userId.toString();
                    Map<String, String> _tmpUserParams = {
                      'id': id,
                    };
                    userParams.addAll(_tmpUserParams);
                    Map<String, String> _tmpUserHeader = {
                      'token': loginBean.token
                    };
                    userHeaders.addAll(_tmpUserHeader);
                    _httpUtils
                        .request(userHeaders, userParams)
                        .then((dataUser) {
                      Map<String, dynamic> resultrUserMap =
                          Map<String, dynamic>.from(dataUser);

                      if (int.parse(resultrUserMap['rtnCode'].toString()) ==
                          0) {
                        loginBean.portrait = resultrUserMap['res']['portrait'];
                        SpUtil.putString(Ids.portrait, loginBean.portrait);
                        SpUtil.putString(Ids.realName, loginBean.realName);

                        SpUtil.putString(
                            Ids.roleId, loginBean.roleId.toString());
                        Fluttertoast.showToast(
                            fontSize: ScreenUtil.getInstance().getSp(13),
                            gravity: ToastGravity.CENTER,
                            msg: "登录成功");
                        eventBus.fire(new UserLoggedInEvent("sucuss"));
                        Navigator.pop(context);
                      }
                    });
                  } else {
                    Fluttertoast.showToast(
                        fontSize: ScreenUtil.getInstance().getSp(13),
                        gravity: ToastGravity.CENTER,
                        msg: resultrMap['rtnMsg']);
                  }
                } catch (e) {
                  Fluttertoast.showToast(
                      fontSize: ScreenUtil.getInstance().getSp(13),
                      gravity: ToastGravity.CENTER,
                      msg: Ids.error);
                }
              });
            }),
      ),
    );
  }

  Container _buildContainerUserName() {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Image.asset(
                        "images/icon_user.png",
                        width: 28.0,
                        height: 28.0,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "请输入用户",
                          hintStyle:
                              new TextStyle(color: Colors.grey, fontSize: 15.0),
                        ),
                        onChanged: (inputStr) {
                          print("username   " + inputStr);
                          _userName = inputStr;
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey[200],
            height: 1.0,
            margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          )
        ],
      ),
    );
  }

  Container _buildContainerPwd() {
    return Container(
      color: Colors.white,
      child: new Column(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
            child: new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Image.asset(
                        "images/icon_key.png",
                        width: 28.0,
                        height: 28.0,
                      ),
                    ),
                    new Expanded(
                      child: new TextField(
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "请输入密码",
                          hintStyle:
                              new TextStyle(color: Colors.grey, fontSize: 15.0),
                        ),
                        onChanged: (inputStr) {
                          print("password   " + inputStr);
                          _pwd = inputStr;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          new Container(
            color: Colors.grey[200],
            height: 1.0,
            margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          )
        ],
      ),
    );
  }
}
