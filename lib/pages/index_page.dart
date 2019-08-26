import 'dart:convert';
import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_warehouse/common/sp_help.dart';
import 'package:flutter_food_warehouse/pages/check_warehouse_page.dart';
import 'package:flutter_food_warehouse/pages/map_page.dart';
import 'package:flutter_food_warehouse/pages/setting_page.dart';
import 'package:flutter_food_warehouse/receiver/event_bus.dart';

import 'package:flutter_food_warehouse/res/colors.dart';
import 'package:flutter_food_warehouse/res/dimens.dart';
import 'package:flutter_food_warehouse/res/ids.dart';
import 'package:flutter_food_warehouse/routers/application.dart';
import 'package:flutter_food_warehouse/routers/routers.dart';
import 'package:flutter_food_warehouse/res/ids.dart';
import 'dart:convert' as convert;
import 'package:flutter/services.dart';
import 'about_page.dart';
import 'home_page.dart';
import 'login_bean.dart';
import 'msg_page.dart';

//import 'package:flutter_jpush/flutter_jpush.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _sindex = 0;
  List<String> menus = [Ids.titleHome];
  int userid;
  int roleId = -1;

  String debugLable = 'Unknown';

  /*错误信息*/
  final JPush jpush = new JPush();
  LoginBean loginBean = new LoginBean();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sindex = 0;
    _initAsync();
    jpush.setup(
      appKey: "35becd8f3809e29457cc8140",
      channel: "developer-default",
      production: false,
      debug: true,
    );

    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    // Platform messages may fail, so we use a try/catch PlatformException.
    jpush.getRegistrationID().then((rid) {
      setState(() {
        debugLable = "flutter getRegistrationID: $rid";
        loginBean.token = rid;
      });
    });

    jpush.setup(
      appKey: "35becd8f3809e29457cc8140",
      channel: "theChannel",
      production: false,
      debug: true,
    );
    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));

    try {
      jpush.addEventHandler(
        onReceiveNotification: (Map<String, dynamic> message) async {
          print("flutter onReceiveNotification: $message");
          setState(() {
            debugLable = "flutter onReceiveNotification: $message";
          });
        },
        onOpenNotification: (Map<String, dynamic> message) async {
          print("flutter onOpenNotification: $message");
          setState(() {
            debugLable = "flutter onOpenNotification: $message";
          });
        },
        onReceiveMessage: (Map<String, dynamic> message) async {
          print("flutter onReceiveMessage: $message");
          setState(() {
            debugLable = "flutter onReceiveMessage: $message";
          });
        },
      );
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      debugLable = platformVersion;
    });
  }

  ///监听Bus events
  void _listen() {
    eventBus.on<UserLoggedInEvent>().listen((event) {
 setState(() {
   portrait = SpUtil.getString(Ids.portrait);

   _buildMenu(int.parse(SpUtil.getString(Ids.roleId)));
   Scaffold.of(context).openDrawer();
 });
    });
  }


String  userId;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _listen();

    return Scaffold(
        appBar: MyAppBar(
            title: Text(menus[_sindex]),
            leading: Builder(
              builder: (context) => IconButton(
                icon: new Icon(Icons.menu),
                onPressed: () {
                  userId = SpUtil.getString(Ids.userId);

                  setState(() {
                    SpUtil.putString(Ids.token, loginBean.token);
                    if (userId != null&&userId.isNotEmpty) {
                      portrait = SpUtil.getString(Ids.portrait);
                      _buildMenu(int.parse(SpUtil.getString(Ids.roleId)));
                      Scaffold.of(context).openDrawer();
                    } else {
                      String tag="ToLogin";
                      Application.router.navigateTo(
                          context, "/login?tag=${tag}",
                          transition: TransitionType.inFromRight);

                    }
                  });
                },
              ),
            )),
        body: _changePage(menus[_sindex]),
        drawer: Drawer(
          semanticLabel: "vvv",
          child: ListView(
            children: <Widget>[
              Container(
                  color: Colours.green_1,
                  padding: EdgeInsets.only(
                      top: ScreenUtil.getInstance().bottomBarHeight,
                      left: 10.0),
                  child: Stack(
                    children: <Widget>[_buildUserInfoText()],
                  )),
              _buildNewsWidget(menus)
            ],
          ),
        ));
  }

  Widget _buildUserInfoText() {
    if (userId == null||userId.isEmpty) {
      return Container();
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildUserHearder(),
          Container(
              width: 64.0,
              height: 64.0,
              margin: EdgeInsets.only(top: 20.0, left: 10.0, bottom: 10.0),
              child: Column(
                children: <Widget>[
                  Text(SpUtil.getString(Ids.realName),
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: Dimens.font_sp14,
                          fontWeight: FontWeight.bold)),
                  Text(roleStr,
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: Dimens.font_sp14,
                          fontWeight: FontWeight.bold))
                ],
              )),
        ],
      );
    }
  }

  ///没有选中效果
  static var itemTextStyle =
      TextStyle(fontWeight: FontWeight.w600, color: Colors.black54);

  ///选中效果
  static var itemTextSelStyle =
      TextStyle(fontWeight: FontWeight.w600, color: Colors.blue);

  TextStyle _getTextStype(int indexPage) {
    if (_sindex == indexPage) {
      return itemTextSelStyle;
    } else {
      return itemTextStyle;
    }
  }

  Widget _buildUserHearder() {
    return portrait.isEmpty
        ? _buildContainerDefaultHeader()
        : _buildContainerUserHeader();
  }

  Widget _buildContainerDefaultHeader() {
    return InkWell(
      onTap: () {
        Application.router.navigateTo(context, Routes.personPage);
      },
      child: Container(
          width: 64.0,
          height: 64.0,
          margin: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
          child: Image.asset(
            "images/icon_user_tx1.png",
            width: 28.0,
            height: 28.0,
          )),
    );
  }

  Widget _buildContainerUserHeader() {
    var bytes = base64.decode(portrait);
    return InkWell(
      onTap: () {
        Application.router.navigateTo(context, Routes.personPage);
      },
      child: Container(
        width: 64.0,
        height: 64.0,
        margin: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
        child: CircleAvatar(radius: 36, backgroundImage: MemoryImage(bytes)),
      ),
    );
  }

  Widget _buildNewsWidget(List menu) {
    List<Widget> tiles = [];
    Widget content;
    for (int i = 0; i < menu.length; i++) {
      tiles.add(InkWell(
          onTap: () {
//            if(menus[i]==Ids.titleMsg){
//
//              Application.router.navigateTo(context, Routes.msgPage);
//              return;
//            }
            setState(() {
//              if (_sindex == i) return;
              _sindex = i;
            });

            Navigator.pop(context);
          },
          child: Container(
            width: double.infinity,
            height: ScreenUtil.getInstance().getHeight(36),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Colours.divider))),
            child: ListTile(
                title: Text(
                  menus[i],
                  style: _getTextStype(i),
                ),
                leading: Icon(Icons.adjust,color: Colours.green_1,)),
          )));
    }
    content = Column(
      children: tiles,
    );
    return content;
  }

  Widget _changePage(String id) {
    switch (id) {
      case Ids.titleHome:
        return HomePage();
        break;
      case Ids.titleMsg:

        return MsgPage();
        break;
      case Ids.titleAbout:
        return AboutPage();
        break;
      case Ids.titleCheck:
        return CheckWarehousePage();
        break;
      case Ids.setting:
        return SettingPage();
      case Ids.houseManager:
        return MapPage();
        break;
      default:
        return Container(
          child: Text('在开发'),
        );
        break;
    }
  }

  void _initAsync() async {
    await SpUtil.getInstance();
  }

  String portrait;
  String roleStr;

  void _buildMenu(int role) {
   menus.removeRange(1, menus.length);
    switch (role) {
      case 0:
        menus.add(Ids.titleMsg);
        menus.add(Ids.titleCheck);
        menus.add(Ids.workManager);
        menus.add(Ids.houseManager);
        menus.add(Ids.areaManager);
        menus.add(Ids.censorship);
        menus.add(Ids.repairManager);
        menus.add(Ids.entrustManager);
        menus.add(Ids.workLoge);
        menus.add(Ids.taskReminder);
        menus.add(Ids.setting);
        menus.add(Ids.titleAbout);
        roleStr = '管理员';
        break;
      case 1:
        menus.add(Ids.titleMsg);
        menus.add(Ids.titleCheck);
        menus.add(Ids.workManager);
        menus.add(Ids.censorship);
        menus.add(Ids.repairManager);
        menus.add(Ids.entrustManager);
        menus.add(Ids.workLoge);
        menus.add(Ids.taskReminder);
        menus.add(Ids.setting);
        menus.add(Ids.titleAbout);
        roleStr = '保管员';
        break;
      case 2:
        menus.add(Ids.titleMsg);
        menus.add(Ids.censorship);
        menus.add(Ids.entrustManager);
        menus.add(Ids.taskReminder);
        menus.add(Ids.setting);
        menus.add(Ids.titleAbout);
        roleStr = '检验员';
        break;
      case 3:
        menus.add(Ids.titleMsg);
        menus.add(Ids.repairManager);
        menus.add(Ids.entrustManager);
        menus.add(Ids.taskReminder);
        menus.add(Ids.setting);
        menus.add(Ids.titleAbout);
        roleStr = '维修员';
        break;
      case 4:
        menus.add(Ids.titleMsg);
        menus.add(Ids.move);
        menus.add(Ids.entrustManager);
        menus.add(Ids.taskReminder);
        menus.add(Ids.setting);
        menus.add(Ids.titleAbout);
        roleStr = '总经理';
        break;
      case 5:
        menus.add(Ids.titleMsg);
        menus.add(Ids.workManager);
        menus.add(Ids.move);
        menus.add(Ids.entrustManager);
        menus.add(Ids.taskReminder);
        menus.add(Ids.setting);
        menus.add(Ids.titleAbout);
        roleStr = '科长';
        break;

      case 7:
        menus.add(Ids.titleMsg);
        menus.add(Ids.workManager);
        menus.add(Ids.entrustManager);
        menus.add(Ids.move);

        menus.add(Ids.taskReminder);
        menus.add(Ids.setting);
        menus.add(Ids.titleAbout);
        roleStr = '副科长';
        break;
      case 8:
        menus.add(Ids.titleMsg);
        menus.add(Ids.move);
        menus.add(Ids.workManager);
        menus.add(Ids.entrustManager);
        menus.add(Ids.taskReminder);
        menus.add(Ids.setting);
        menus.add(Ids.titleAbout);
        roleStr = '副总经理';
        break;
    }
  }
}
