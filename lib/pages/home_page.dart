import 'package:fluro/fluro.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_food_warehouse/common/common.dart';
import 'package:flutter_food_warehouse/http/services_http.dart';
import 'package:flutter_food_warehouse/res/colors.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter_food_warehouse/res/dimens.dart';
import 'package:flutter_food_warehouse/routers/application.dart';
import 'package:flutter_food_warehouse/utils/utils.dart';
import 'home_bean.dart';

import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  HttpUtils _httpUtils = HttpUtils();
  List<HomeBean> homeBeans;
  Map<String, String> weatherHeaders = {'method': 'weatherForecast'};
  Map<String, String> weatherParams = {'city': Constant.base_city};
  Map<String, String> newHeaders = {'method': 'cmsListByTypeId'};
  Map<String, String> newParams = {'typeId': '1'};

  @override
  void initState() {
    // TODO: implement initState

    _httpUtils.request(weatherHeaders, weatherParams).then((data) {
      try {
        Map<String, dynamic> resultrMap = new Map<String, dynamic>.from(data);
        if (int.parse(resultrMap['rtnCode'].toString()) == 0) {
          HomeBean homeBean = HomeBean.fromJsonWeahter(
              resultrMap['res']['weather'], resultrMap['res']['air']);
          if (homeBeans == null) {
            homeBeans = List();
          }
          homeBeans.add(homeBean);
          _httpUtils.request(newHeaders, newParams).then((dataNews) {
            Map<String, dynamic> resultrNewsMap =
                new Map<String, dynamic>.from(dataNews);
            if (int.parse(resultrNewsMap['rtnCode'].toString()) == 0) {
              final originList = resultrNewsMap['res'] as List;
              setState(() {
                homeBeans.addAll(originList
                    .map((value) => HomeBean.fromJson(value))
                    .toList());
              });
            } else {
              print(resultrNewsMap['rtnMsg']);
            }
          });
        } else {
          print(resultrMap['rtnMsg']);
        }
      } catch (e) {
        print(e);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return homeBeans == null
        ? Center(child: CircularProgressIndicator())
        : Container(
            child: ListView.builder(
                itemCount: homeBeans.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return _buildWeatherWidget(homeBeans[index]);
                  } else {
                    return _buildNewsWidget(homeBeans[index]);
                  }
                }));
  }

  ///加载天气UI
  Widget _buildWeatherWidget(HomeBean bean) {
    return Container(
      width: double.infinity,
      height: 180.0,
      child: Stack(children: <Widget>[
        Image(
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
            image: AssetImage("images/air.png")),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: 86,
            margin: EdgeInsets.only(bottom: 5.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 35.0),
                          child: Text(
                            Constant.base_city + '市',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colours.text_dark,
                                fontSize: Dimens.font_sp16,
                                decoration: TextDecoration.none),
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 25.0, top: 15.0),
                          child: Text(
                            bean.tmp + '°C',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colours.text_dark,
                                fontSize: Dimens.font_sp24,
                                decoration: TextDecoration.none),
                          ),
                        ),
                        flex: 3,
                      )
                    ],
                  )),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              bean.cond_txt,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colours.text_dark,
                                  fontSize: Dimens.font_sp16,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              bean.wind_dir + bean.wind_sc + '级',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colours.text_dark,
                                  fontSize: Dimens.font_sp16,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              DateUtil.formatDateStr(bean.ctime,
                                  format: 'yyyy年MM月dd日'),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colours.text_dark,
                                  fontSize: Dimens.font_sp16,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              'pm2.5:' +
                                  bean.pm25 +
                                  Utils.getPm25Rank(int.parse(bean.pm25)),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colours.text_dark,
                                  fontSize: Dimens.font_sp16,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                          flex: 1,
                        )
                      ],
                    ),
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }

  ///加载储粮知识
  Widget _buildNewsWidget(HomeBean bean) {
    return InkWell(
        onTap: () {
          var jsonUrl =
              jsonEncode(Utf8Encoder().convert(json.encode(bean.webUrl)));
          var jsonTitle =
              jsonEncode(Utf8Encoder().convert(json.encode(bean.title)));
          Application.router.navigateTo(
              context, "/web?url=${jsonUrl}&title=${jsonTitle}",
              transition: TransitionType.inFromRight);
        },
        child: Container(
          width: double.infinity,
          height: ScreenUtil.getInstance().getHeight(76),
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 1, color: Colours.divider))),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                      margin: EdgeInsets.only(left: 20.0, top: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            bean.title,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colours.text_dark,
                                fontSize: Dimens.font_sp16,
                                decoration: TextDecoration.none),
                          ),
                          Text(
                            bean.ctime,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colours.text_normal,
                                fontSize: Dimens.font_sp14,
                                decoration: TextDecoration.none),
                          ),
                        ],
                      )),
                  flex: 3),
              Expanded(
                  child: Container(
                    width: ScreenUtil.getInstance().getWidth(80),
                    height: ScreenUtil.getInstance().getHeight(55),
                    margin: EdgeInsets.only(right: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: FadeInImage.assetNetwork(
                        image: bean.picUrl,
                        fit: BoxFit.fill,
                        placeholder: "images/ic_launcher.png",
                      ),
                    ),
                  ),
                  flex: 1),
            ],
          ),
        ));
  }


}
