import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_warehouse/custom_widget/MXPicker.dart';

import 'package:flutter_food_warehouse/http/services_http.dart';
import 'package:flutter_food_warehouse/pages/check_list.dart';
import 'package:flutter_food_warehouse/res/colors.dart';
import 'package:flutter_food_warehouse/res/dimens.dart';
import 'package:flutter_food_warehouse/res/ids.dart';
import 'package:flutter_tableview/flutter_tableview.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'check_bean.dart';


///入仓检查
class SecurityCheckPage extends StatefulWidget {
  @override
  SecurityCheckPageState createState() => new SecurityCheckPageState();
}

class SecurityCheckPageState extends State<SecurityCheckPage> {
  int count = 0;

  // Section header widget builder.
  Widget _sectionHeaderBuilder(BuildContext context, int section) {
    return InkWell(
      onTap: () {
        print('click section header. -> section:$section');
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16.0),
        color: Colours.text_normal,
        height: 100,
        child: Text(
          (cashList[section])[0].parentTitle,
          style: TextStyle(
              color: Colours.white,
              fontSize: Dimens.font_sp14,
              decoration: TextDecoration.none),
        ),
      ),
    );
  }

  Widget _cellBuilder(BuildContext context, int section, int row) {
    return InkWell(
        onTap: () {
          print('click cell item. -> section:$section row:$row');
//          String content=(cashList[section])[row].value=='选择'?'':(cashList[section])[row].value;
//          showDiaglog(content,section,row);
          String data =
              '[{\"item\":\"-15\",\"value\":\"-15\"},{\"item\":\"-14\",\"value\"'
              ':\"-14\"},{\"item\":\"-13\",\"value\":\"-13\"},{\"item\":\"-12\",\"value\":\"-12\"}'
              ',{\"item\":\"-11\",\"value\":\"-11\"},{\"item\":\"-10\",\"value\":\"-10\"},'
              '{\"item\":\"-9\",\"value\":\"-9\"},{\"item\":\"-8\",\"value\":\"-8\"},'
              '{\"item\":\"-7\",\"value\":\"-7\"},{\"item\":\"-6\",\"value\":\"-6\"},'
              '{\"item\":\"-5\",\"value\":\"-5\"},{\"item\":\"-4\",\"value\":\"-4\"},'
              '{\"item\":\"-3\",\"value\":\"-3\"},{\"item\":\"-2\",\"value\":\"-2\"},'
              '{\"item\":\"-1\",\"value\":\"-1\"},{\"item\":\"0\",\"value\":\"0\"},{\"item\":\"1\",\"value\":\"1\"},{\"item\":\"2\",\"value\":\"2\"},{\"item\":\"3\",\"value\":\"3\"},{\"item\":\"4\",\"value\":\"4\"},{\"item\":\"5\",\"value\":\"5\"},{\"item\":\"6\",\"value\":\"6\"},{\"item\":\"7\",\"value\":\"7\"},{\"item\":\"8\",\"value\":\"8\"},{\"item\":\"9\",\"value\":\"9\"},{\"item\":\"10\",\"value\":\"10\"},{\"item\":\"11\",\"value\":\"11\"},{\"item\":\"12\",\"value\":\"12\"},{\"item\":\"13\",\"value\":\"13\"},{\"item\":\"14\",\"value\":\"14\"},{\"item\":\"15\",\"value\":\"15\"},{\"item\":\"16\",\"value\":\"16\"},{\"item\":\"17\",\"value\":\"17\"},{\"item\":\"18\",\"value\":\"18\"},{\"item\":\"19\",\"value\":\"19\"},{\"item\":\"20\",\"value\":\"20\"},{\"item\":\"21\",\"value\":\"21\"},{\"item\":\"22\",\"value\":\"22\"},{\"item\":\"23\",\"value\":\"23\"},{\"item\":\"24\",\"value\":\"24\"},{\"item\":\"25\",\"value\":\"25\"},{\"item\":\"26\",\"value\":\"26\"},{\"item\":\"27\",\"value\":\"27\"},{\"item\":\"28\",\"value\":\"28\"},{\"item\":\"29\",\"value\":\"29\"},{\"item\":\"30\",\"value\":\"30\"},{\"item\":\"31\",\"value\":\"31\"},{\"item\":\"32\",\"value\":\"32\"},{\"item\":\"33\",\"value\":\"33\"},{\"item\":\"34\",\"value\":\"34\"},{\"item\":\"35\",\"value\":\"35\"},{\"item\":\"36\",\"value\":\"36\"},{\"item\":\"37\",\"value\":\"37\"},{\"item\":\"38\",\"value\":\"38\"},{\"item\":\"39\",\"value\":\"39\"},{\"item\":\"40\",\"value\":\"40\"},{\"item\":\"41\",\"value\":\"41\"},{\"item\":\"42\",\"value\":\"42\"},{\"item\":\"43\",\"value\":\"43\"},{\"item\":\"44\",\"value\":\"44\"},{\"item\":\"45\",\"value\":\"45\"}]\n';
          List datas = json.decode(data);
          _showCupertinoPicker(context, datas, (cashList[section])[row].name,section,row);
        },
        child: Container(
            padding: EdgeInsets.only(left: 16.0),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                      color: Color.fromRGBO(240, 240, 240, 1),
                    ))),
            height: 50.0,
            child: ListTile(
              title: Text((cashList[section])[row].name,
                  style: TextStyle(
                      color: Colours.text_normal,
                      fontSize: Dimens.font_sp14,
                      decoration: TextDecoration.none)),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text(
                  (cashList[section])[row].childHints,
                  style: TextStyle(color: Colours.text_normal, fontSize: 14.0),
                ),
                Icon(
                  Icons.navigate_next,
                  color: Colors.grey,
                ),
              ]),
            )));
  }

  // Each section header height;
  double _sectionHeaderHeight(BuildContext context, int section) {
    return 50.0;
  }

  // Each cell item widget height.
  double _cellHeight(BuildContext context, int section, int row) {
    return 50.0;
  }

  int _rowCountAtSection(int section) {
    return count == 0 ? 0 : cashList[section].length;
  }


  ///单选为文本或者是数字2（文本）7（数字）
  void _showCupertinoPicker(BuildContext cxt, List list, String title,
      int section, int row) {

    List <String> items=List();
    list.forEach((value) {
      items.add(value['item']);
    });
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return new MXPicker(items, (selected) {
          }, (int selected) {
            this.setState(() {
              (cashList[section])[row].value = list[selected]['value'];
              (cashList[section])[row].childHints = list[selected]['item'];

            });

          });
        });
//    final picker = CupertinoPicker(itemExtent: 40,
//        backgroundColor: Colours.white,
//        onSelectedItemChanged: (position) {
//          setState(() {
//            (cashList[section])[row].value = list[position]['value'];
//            (cashList[section])[row].childHints = list[position]['item'];
//          });
////          print('The position is $position');
//        }, children: _buildShwoPicker(list)
//    );
//
//    showCupertinoModalPopup(context: cxt, builder: (cxt) {
//      return CupertinoAlertDialog(
//          title: Text(title),
//          content: Container(
//            height: 200,
//            color: Colours.white,
//            child: picker,
//          ));
//    });
  }

  List<Widget> _buildShwoPicker(List list) {
    List<Widget> views = List();
    list.forEach((value) {
      views.add(
          Center(
            child: Text(
                value['item'].toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: Dimens.font_sp16, color: Colours.text_normal)),
          ));
    });
    return views;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: Text('入仓检查'),
          actions: <Widget>[
            InkWell(
              onTap: () {},
              child: Text('保存'),
            )
          ],
        ),
        body: cashList.length == 0
            ? Center(child: CircularProgressIndicator())
            : Container(
          child: FlutterTableView(
            sectionCount: count,
            rowCountAtSection: _rowCountAtSection,
            sectionHeaderBuilder: _sectionHeaderBuilder,
            cellBuilder: _cellBuilder,
            sectionHeaderHeight: _sectionHeaderHeight,
            cellHeight: _cellHeight,
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCheckList();
  }

  HttpUtils _httpUtils = HttpUtils();
  List<List<CheckBean>> cashList = List();

  /**
   * 获取检查项目
   */
  void _getCheckList() async {
    await SpUtil.getInstance();
    Map<String, String> checkListHeaders = {
      'method': 'checkList',
      'token': SpUtil.getString(Ids.tokenUser)
    };
    Map<String, String> checkParams = {'type': '1'};
    _httpUtils.request(checkListHeaders, checkParams).then((data) async {
      CheckList checkList = CheckList.fromJson(data);
      int code = checkList.rtnCode;
      if (code == 0) {
        List<List<CheckBean>> cashTmpList = List();
        checkList.res.forEach((item) {
          String parentTitle = item.name;
          String parentHead = item.tip;
          List<CheckBean> checkBeanList = List();
          item.children.forEach((itemChilden) {
            CheckBean checkBean = CheckBean(
                parentTitle: parentTitle,
                parentHead: parentHead,
                childHints: itemChilden.valueDesc,
                name: itemChilden.lable,
                checkId: itemChilden.checkId.toString(),
                tip: itemChilden.tip,
                value: '选择',
                dataType: itemChilden.dataType);
            checkBeanList.add(checkBean);
          });
          cashTmpList.add(checkBeanList);
        });
        setState(() {
          cashList.addAll(cashTmpList);
          count = cashList.length;
        });
      } else {
        Fluttertoast.showToast(
            fontSize: ScreenUtil.getInstance().getSp(13),
            gravity: ToastGravity.CENTER,
            msg: checkList.rtnMsg);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(SecurityCheckPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

///1，文本输入异常原因和措施
  void showDiaglog(String content, int section, int row) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('请输入异常原因'),
            content: Card(
              elevation: 0.0,
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: TextEditingController.fromValue(
                        TextEditingValue(
                            text: content,
                            // 保持光标在最后
                            selection: TextSelection.fromPosition(TextPosition(
                                affinity: TextAffinity.downstream,
                                offset: content.length)))),
                    decoration: InputDecoration(
                        filled: true, fillColor: Colors.grey.shade50),
                    onChanged: (inputStr) {
                      setState(() {
                        (cashList[section])[row].value = inputStr;
                        (cashList[section])[row].childHints = inputStr;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('取消'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('确定'),
              ),
            ],
          );
        });
  }

}
