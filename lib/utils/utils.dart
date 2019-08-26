import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
class Utils{
  static String getPm25Rank(int pm25) {
    String res="";
    if(pm25<=100){
      res="优秀";
    }else if(pm25>100&&pm25<=150){
      res="轻度";
    }else if(pm25>150&&pm25<=200){
      res="中度";
    }else if(pm25>250&&pm25<=300){
      res="重度";
    }else {
      res="严重";
    }
    return res;

  }
  static String getImageBase64(File image) {
    var bytes = image.readAsBytesSync();
    var base64 = base64Encode(bytes);
    return base64;
  }

  static File getImageFile(String base64) {
    var bytes = base64Decode(base64);
    return File.fromRawPath(bytes);
  }

  static Uint8List getImageByte(String base64) {
    return base64Decode(base64);
  }

  static const RollupSize_Units = ["GB", "MB", "KB", "B"];

  static String getRollupSize(int size) {
    int idx = 3;
    int r1 = 0;
    String result = "";
    while (idx >= 0) {
      int s1 = size % 1024;
      size = size >> 10;
      if (size == 0 || idx == 0) {
        r1 = (r1 * 100) ~/ 1024;
        if (r1 > 0) {
          if (r1 >= 10)
            result = "$s1.$r1${RollupSize_Units[idx]}";
          else
            result = "$s1.0$r1${RollupSize_Units[idx]}";
        } else
          result = s1.toString() + RollupSize_Units[idx];
        break;
      }
      r1 = s1;
      idx--;
    }
    return result;
  }
}