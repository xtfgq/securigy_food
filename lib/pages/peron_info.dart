import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_food_warehouse/common/sp_help.dart';
import 'package:flutter_food_warehouse/http/services_http.dart';
import 'package:flutter_food_warehouse/receiver/event_bus.dart';
import 'package:flutter_food_warehouse/res/colors.dart';
import 'package:flutter_food_warehouse/res/dimens.dart';
import 'package:flutter_food_warehouse/res/ids.dart';
import 'package:flutter_food_warehouse/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_warehouse/common/bottom_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_luban/flutter_luban.dart';

import 'login_bean.dart';

class PersonInfoPage extends StatefulWidget {
  @override
  _PersonInfoPageState createState() => _PersonInfoPageState();
}

class _PersonInfoPageState extends State<PersonInfoPage> {
  LoginBean model;
  File primaryFile;
  File compressedFile;
  String _inputText='';
  String _headStr='';
  HttpUtils _httpUtils = HttpUtils();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initInfo();


  }
 void  _initInfo() async{
   await SpUtil.getInstance();

   setState(() {
     _inputText=  SpUtil.getString(Ids.realName);
     _headStr=SpUtil.getString(Ids.portrait);
   });

  }
  ///获取个人信息
//  void _getPersonInfo() async{
//
//    Map<String, String> infoHeaders = {'token':model.token,'method':'findUserById'};
//    Map<String, String> infoParams = {'id': model.userId.toString()};
//    _httpUtils.request(infoHeaders, infoParams).then((data) {
//      Map<String, dynamic> resultrMap = new Map<String, dynamic>.from(data);
//      if (int.parse(resultrMap['rtnCode'].toString()) == 0) {
//
//        LoginBean loginBean = LoginBean.fromInfoJson(resultrMap['res']);
//        setState(() {
//
//          _headStr=loginBean.portrait;
//
//          SpUtil.putString(Ids.portrait, _headStr);
//          SpUtil.putString(Ids.realName, _inputText);
//        });
//
//      }
//    });
//  }

  @override
  Widget build(BuildContext context) {
    model = SpHelper.getObject<LoginBean>(Ids.loginModel);
    return Scaffold(
      appBar: MyAppBar(
        title: Text('个人信息'),
      ),
      body:  Container(
          margin: EdgeInsets.only(top: 20),
          child: ListView(
            children: <Widget>[_buildContainerHeader(), _buildName(),_buildContainerLogin(context)],
          )),
    );
  }

  ///修改个人信息
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
              '确定',
              style: new TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            onPressed: () async {
              //按钮点击事件
              await SpUtil.getInstance();
              FocusScope.of(context).requestFocus(FocusNode());
              Map<String, String> _tmpUpParams = {
                'realName': _inputText,
                'id':SpUtil.getString(Ids.userId)
              };
              Map<String, String> userHeaders = {'method': 'userUpdate','token': SpUtil.getString(Ids.tokenUser)};

              _httpUtils.request(userHeaders, _tmpUpParams).then((data) async {
                try {
                  Map<String, dynamic> resultrMap =
                  new Map<String, dynamic>.from(data);

                  if (int.parse(resultrMap['rtnCode'].toString()) == 0) {
                    SpUtil.putString(Ids.realName, _inputText);
                    Fluttertoast.showToast(
                        fontSize: ScreenUtil.getInstance().getSp(13),
                        gravity: ToastGravity.CENTER,
                        msg: "修改成功~");
                    eventBus.fire( UserLoggedInEvent("sucuss"));
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
  ///头像
  Container _buildContainerHeader() {
    return Container(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                var list = List();
                list.add('拍照');
                list.add('相册');

                return CommonBottomSheet(
                  //uses the custom alert dialog
                  list: list,
                  onItemClickListener: (index) {
                    if (index == 0) {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    } else if (index == 2) {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    }
                  },
                );
              });
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('头像',
                style: TextStyle(
                    color: Colours.text_dark,
                    fontSize: Dimens.font_sp14,
                    decoration: TextDecoration.none),
              ),
                        flex: 1,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child:_buildIsHasHead(),
                      ),
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
      ),
    );
  }
  ///头像是否为空
 Widget _buildIsHasHead(){
    if(_headStr==null||_headStr.isEmpty){
      return Image.asset(
        "images/icon_user.png",
        width: 28.0,
        height: 28.0,
      );
    }else{
      var bytes = base64.decode(_headStr);
      return CircleAvatar(radius: 16, backgroundImage: MemoryImage(bytes));
    }
  }

  Widget _buildName() {
    return Container(
      color: Colors.white,
      child: new Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
            Expanded(
            child: Text('姓名',  style: TextStyle(
                color: Colours.text_dark,
                fontSize: Dimens.font_sp14,
                decoration: TextDecoration.none),
            ),
      flex: 1,
    ),


                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign:TextAlign.end,
                        controller: TextEditingController.fromValue(
                            TextEditingValue(
                                text: _inputText,
                                // 保持光标在最后
                                selection: TextSelection.fromPosition(
                                    TextPosition(
                                        affinity: TextAffinity.downstream,
                                        offset: _inputText.length)))),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "请输入姓名",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 15.0),
                        ),
                        onChanged: (inputStr) {
                          print("name  " + inputStr);
                          _inputText = inputStr;
                        },
                      ),
                    ),
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

  ///上传头像
  _pickImage(ImageSource type) async {
    File imageFile = await ImagePicker.pickImage(source: type);
    setState(() {
      primaryFile = imageFile;
    });
    if (imageFile == null) return;
    final tempDir = await getTemporaryDirectory();

    CompressObject compressObject = CompressObject(
      imageFile: imageFile, //image
      path: tempDir.path, //compress to path
      quality: 85, //first compress quality, default 80
      step:
          6, //compress quality step, The bigger the fast, Smaller is more accurate, default 6
    );
    Luban.compressImage(compressObject).then((_path) {
      setState(() {
        compressedFile = File(_path);
        String strContent=Utils.getImageBase64(compressedFile);
        Map<String, String> upOtherParam = {
          'id': SpUtil.getString(Ids.userId),
          'portrait':strContent
        };
        Map<String, String> uploadHeaders = {
          'method': 'userUpdate',
          'token':SpUtil.getString(Ids.tokenUser),
        };

        _httpUtils.request(uploadHeaders, upOtherParam).then((data) {
          Map<String, dynamic> resultrMap = new Map<String, dynamic>.from(data);
          if (int.parse(resultrMap['rtnCode'].toString()) == 0) {
            _headStr= strContent;
            SpUtil.putString(Ids.portrait, _headStr);
            Fluttertoast.showToast(
                fontSize: ScreenUtil.getInstance().getSp(13),
                gravity: ToastGravity.CENTER,
                msg: "修改成功");
            eventBus.fire(new UserLoggedInEvent("sucuss"));
            _initInfo();
          } else {
            Fluttertoast.showToast(
                fontSize: ScreenUtil.getInstance().getSp(13),
                gravity: ToastGravity.CENTER,
                msg: resultrMap['rtnMsg'].toString());
          }
        });
      });
    });
  }

}
