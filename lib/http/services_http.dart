
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter_food_warehouse/common/common.dart';
class HttpUtils{
  factory HttpUtils() =>_getInstance();
  static HttpUtils get instance => _getInstance();
  static HttpUtils _instance;
  HttpUtils._internal() {
  }
  static HttpUtils _getInstance() {
    if (_instance == null) {
      _instance = new HttpUtils._internal();
    }
    return _instance;
  }

  Future request(Map<String, String> headers,Map<String, String> params) async{
    try{
      Response response;
      Dio dio = new Dio();
      dio.options.contentType=ContentType.parse("application/x-www-form-urlencoded");
      dio.options.connectTimeout=60*1000;
      dio.options.receiveTimeout=30*1000;
      dio.options.responseType = ResponseType.json;
      dio.options.headers={'v':AppConfig.api_version};
      dio.options.headers.addAll(headers);
      Map<String, dynamic> body={"param":json.encode(params)};
      response = await dio.post(Constant.base_url,data:body);
      if(response.statusCode==200){
        print("接口结果数据:"+response.data.toString());
        return response.data;
      }else{
        throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
      }
    }catch(e){
      return print('ERROR:======>${e}');
    }
  }


}