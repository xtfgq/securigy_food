import 'package:json_annotation/json_annotation.dart'; 
  
part 'check_list.g.dart';
@JsonSerializable()
  class CheckList extends Object {

  @JsonKey(name: 'res')
  List<Res> res;

  @JsonKey(name: 'rtnMsg')
  String rtnMsg;

  @JsonKey(name: 'rtnCode')
  int rtnCode;

  CheckList(this.res,this.rtnMsg,this.rtnCode,);

  factory CheckList.fromJson(Map<String, dynamic> srcJson) => _$CheckListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CheckListToJson(this);

}

  
@JsonSerializable()
  class Res extends Object {

  @JsonKey(name: 'children')
  List<Children> children;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'tip')
  String tip;

  @JsonKey(name: 'id')
  int id;

  Res(this.children,this.name,this.tip,this.id,);

  factory Res.fromJson(Map<String, dynamic> srcJson) => _$ResFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ResToJson(this);

}

  
@JsonSerializable()
  class Children extends Object {

  @JsonKey(name: 'data')
  String data;

  @JsonKey(name: 'valueDesc')
  String valueDesc;

  @JsonKey(name: 'dataType')
  int dataType;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'lable')
  String lable;

  @JsonKey(name: 'tip')
  String tip;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'sort')
  int sort;

  @JsonKey(name: 'checkId')
  int checkId;

  Children(this.data,this.valueDesc,this.dataType,this.name,this.lable,this.tip,this.id,this.sort,this.checkId,);

  factory Children.fromJson(Map<String, dynamic> srcJson) => _$ChildrenFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ChildrenToJson(this);

}

  
