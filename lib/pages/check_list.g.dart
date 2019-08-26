// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckList _$CheckListFromJson(Map<String, dynamic> json) {
  return CheckList(
    (json['res'] as List)
        ?.map((e) => e == null ? null : Res.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['rtnMsg'] as String,
    json['rtnCode'] as int,
  );
}

Map<String, dynamic> _$CheckListToJson(CheckList instance) => <String, dynamic>{
      'res': instance.res,
      'rtnMsg': instance.rtnMsg,
      'rtnCode': instance.rtnCode,
    };

Res _$ResFromJson(Map<String, dynamic> json) {
  return Res(
    (json['children'] as List)
        ?.map((e) =>
            e == null ? null : Children.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['name'] as String,
    json['tip'] as String,
    json['id'] as int,
  );
}

Map<String, dynamic> _$ResToJson(Res instance) => <String, dynamic>{
      'children': instance.children,
      'name': instance.name,
      'tip': instance.tip,
      'id': instance.id,
    };

Children _$ChildrenFromJson(Map<String, dynamic> json) {
  return Children(
    json['data'] as String,
    json['valueDesc'] as String,
    json['dataType'] as int,
    json['name'] as String,
    json['lable'] as String,
    json['tip'] as String,
    json['id'] as int,
    json['sort'] as int,
    json['checkId'] as int,
  );
}

Map<String, dynamic> _$ChildrenToJson(Children instance) => <String, dynamic>{
      'data': instance.data,
      'valueDesc': instance.valueDesc,
      'dataType': instance.dataType,
      'name': instance.name,
      'lable': instance.lable,
      'tip': instance.tip,
      'id': instance.id,
      'sort': instance.sort,
      'checkId': instance.checkId,
    };
