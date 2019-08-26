import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_warehouse/http/services_http.dart';
import 'package:flutter_food_warehouse/pages/reset_pwd_page.dart';
import 'package:flutter_food_warehouse/receiver/event_bus.dart';
import 'package:flutter_food_warehouse/res/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePwdPage extends StatefulWidget {
  @override
  _ChangePwdPageState createState() => _ChangePwdPageState();
}

class _ChangePwdPageState extends State<ChangePwdPage> {
  String _userName;
  String _smsCode;
  String _pwd;
  HttpUtils _httpUtils = HttpUtils();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: MyAppBar(
        title: Text('重置密码'),
      ),
      body: Container(
          margin: EdgeInsets.only(top: 20),
          child: ListView(
            children: <Widget>[_buildPhone(), _buildCode(),_buildPwd(),_buildChangePwd(context)],
          )),
    );
  }

  Widget _buildPhone() {
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
                          hintText: "请输入手机号码",
                          hintStyle:
                              new TextStyle(color: Colors.grey, fontSize: 15.0),
                        ),
                        onChanged: (inputStr) {
                          print("username   " + inputStr);
                          _userName = inputStr;
                          eventBus.fire(new UserNumInEvent(_userName));
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

  Widget _buildCode() {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Image.asset(
                        "images/icon_key.png",
                        width: 28.0,
                        height: 28.0,
                      ),
                    ),
                    Expanded(
                      child:Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "请输入验证码",
                          hintStyle:
                              new TextStyle(color: Colors.grey, fontSize: 15.0),
                        ),
                        onChanged: (inputStr) {
                          print("smscode   " + inputStr);
                          _smsCode = inputStr;
                        },
                      ),
                    ),flex: 1,),
                    Container(
                      width: ScreenUtil.getInstance().getWidth(96.0),
                        child: ResetCodePage(
                            onTapCallback: () {}, phoneNum: _userName))
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
  Widget _buildPwd() {
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
                        "images/icon_key.png",
                        width: 28.0,
                        height: 28.0,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "请设置新密码（6位以上）",
                          hintStyle:
                          new TextStyle(color: Colors.grey, fontSize: 15.0),
                        ),
                        onChanged: (inputStr) {
                          print("pwd   " + inputStr);
                          _pwd = inputStr;

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
  Container _buildChangePwd(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 24.0),
        child: CupertinoButton(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width / 2.0 - 48.0,
                8.0,
                MediaQuery.of(context).size.width / 2.0 - 48.0,
                8.0),
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
            color: Colours.green_1,
            child: Text(
              '提交',
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
              if (_pwd.length >= 6) {
                Fluttertoast.showToast(
                    fontSize: ScreenUtil.getInstance().getSp(13),
                    gravity: ToastGravity.CENTER,
                    msg: "密码必须6位以上~");
                return;
              }

              Map<String, String> resetPwdHeaders = {'method': 'userResetPassworldByIdentifyingCode'};
              Map<String, String> resetPwdParams = {'mobile': _userName,'identifyingCode':_smsCode,'password':_pwd};
              _httpUtils.request(resetPwdHeaders, resetPwdParams).then((data) {
                try {
                  Map<String, dynamic> resultrMap = new Map<String, dynamic>.from(data);
                  if (int.parse(resultrMap['rtnCode'].toString()) == 0) {

                    Fluttertoast.showToast(
                        fontSize: ScreenUtil.getInstance().getSp(13),
                        gravity: ToastGravity.CENTER,
                        msg: "重置密码成功~");

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
                      msg: e.toString());
                }
              });

            }),
      ),
    );
  }
}
