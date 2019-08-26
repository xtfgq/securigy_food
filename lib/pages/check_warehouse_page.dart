import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_warehouse/common/bottom_dialog.dart';
import 'package:flutter_food_warehouse/http/services_http.dart';
import 'package:flutter_food_warehouse/res/colors.dart';
import 'package:flutter_food_warehouse/res/dimens.dart';
import 'package:flutter_food_warehouse/res/ids.dart';
import 'package:flutter_food_warehouse/routers/application.dart';
import 'package:flutter_food_warehouse/routers/routers.dart';
import 'warse_house_bean.dart';

class CheckWarehousePage extends StatefulWidget {
  @override
  _CheckWarehousePageState createState() => _CheckWarehousePageState();
}

class _CheckWarehousePageState extends State<CheckWarehousePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initData();
  }

  List<WareHouse> wareHouseList = List();
  HttpUtils _httpUtils = HttpUtils();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: ListView(
        children: <Widget>[
          _cell(0, "仓号", "请选择仓号"),
          _cell(1, "检查类型", "请选择检查类型"),
          _buildContainerLogin(context)
        ],
      ),
    );
  }

  Container _buildContainerLogin(BuildContext context) {
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
                  '下一步',
                  style: new TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                onPressed: () {
                  Application.router.navigateTo(context, Routes.securityPage);
                })));
  }

  Widget _cell(int index, String title, String hint) {
    var list = List();
    list.add('定项检查');
    list.add('入仓检查');
    String changeIndexText() {
      if (index == 0) {
        if (_sindex >= 0 && wareHouseList.length > 0)
          return wareHouseList[_sindex].name;
        else {
          return hint;
        }
      } else {
        if (_sindex2 >= 0)
          return list[_sindex2];
        else {
          return hint;
        }
      }
    }

    return GestureDetector(
        onTap: () {
          switch (index) {
            case 0:
              if (wareHouseList.length > 0) {
                showMyCupertinoDialog(context);
              }

              break;
            case 1:
              showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (BuildContext context) {
                    return CommonBottomSheet(
                      //uses the custom alert dialog
                      list: list,
                      onItemClickListener: (index) {
                        if (index == 0) {
                          setState(() {
                            _sindex2 = 0;
                          });
                          Navigator.pop(context);
                        } else if (index == 2) {
                          setState(() {
                            _sindex2 = 1;
                          });
                          Navigator.pop(context);
                        }
                      },
                    );
                  });
              break;
          }
        },
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(title),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text(
                  changeIndexText(),
                  style: TextStyle(color: Colors.grey, fontSize: 14.0),
                ),
                Icon(
                  Icons.navigate_next,
                  color: Colors.grey,
                ),
              ]),
            ),
            Container(
                margin: EdgeInsets.all(0.0),
                child: Divider(height: 1.0, color: Colors.black),
                padding: EdgeInsets.only(left: 15.0, right: 15.0))
          ],

        ));
  }

  int _sindex = -1;
  int _sindex2 = -1;

  void showMyCupertinoDialog(BuildContext context) {
    Color getColorStype(int indexPage) {
      if (_sindex == indexPage) {
        return Colours.gray_99;
      } else {
        return Colours.white;
      }
    }

    ///没有选中效果
    var itemTextStyle =
        TextStyle(fontSize: Dimens.font_sp16, color: Colours.text_normal);

    ///选中效果
    var itemTextSelStyle =
        TextStyle(fontSize: Dimens.font_sp16, color: Colours.white);
    TextStyle _getTextStype(int indexPage) {
      if (_sindex == indexPage) {
        return itemTextSelStyle;
      } else {
        return itemTextStyle;
      }
    }

    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("选择仓号"),
            content: Container(
              width: ScreenUtil.getInstance().getWidth(100),
              height: ScreenUtil.getInstance().getHeight(90),
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _sindex = index;
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                          height: ScreenUtil.getInstance().getHeight(40),
                          width: double.infinity,
                          color: getColorStype(index),
                          child: Center(
                            child: Text(
                              wareHouseList[index].name,
                              textAlign: TextAlign.center,
                              style: _getTextStype(index),
                            ),
                          )),
                    );
                  },
                  itemCount: wareHouseList.length,
                  shrinkWrap: true),
            ),
          );
        });
  }



  void _initData() async {
    await SpUtil.getInstance();
    Map<String, String> wareHourseHeaders = {
      'method': 'grainStoreroomList',
      'token': SpUtil.getString(Ids.tokenUser)
    };
    Map<String, String> wareHourseParams = {
      'userId': SpUtil.getString(Ids.userId)
    };
    _httpUtils.request(wareHourseHeaders, wareHourseParams).then((data) {
      try {
        Map<String, dynamic> resultrMap = new Map<String, dynamic>.from(data);
        if (int.parse(resultrMap['rtnCode'].toString()) == 0) {
          final originList = resultrMap['res'] as List;
          setState(() {
            wareHouseList.addAll(
                originList.map((value) => WareHouse.fromJson(value)).toList());
          });

        } else {
          print(resultrMap['rtnMsg']);
        }
      } catch (e) {
        print(e);
      }
    });
  }
}
