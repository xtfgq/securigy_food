//realName: 刘伟, roleId: 1, mobile: 13937188968, userId: 43, token: 28bda683-a553-4b32-980c-c88577c84723
class LoginBean {
  String realName;
  int roleId;
  String mobile;
  int userId;
  String token;
  String portrait;

  LoginBean({this.realName, this.roleId, this.mobile, this.userId, this.token,this.portrait});

  factory LoginBean.fromJson(Map<String, dynamic> json) {
    return LoginBean(
        realName: json['realName'] as String,
        roleId: json['roleId'] as int,
        mobile: json['mobile'] as String,
        userId: json['userId'] as int,
        token: json['token'] as String,
    portrait:json['portrait'] as String);
  }
  factory LoginBean.fromUserJson(Map<String, dynamic> json) {
    return LoginBean(
        portrait: json['portrait'] as String,
        realName: json['realName'] as String);

  }
  factory LoginBean.fromInfoJson(Map<String, dynamic> json) {
    return LoginBean(
        realName: json['realName'] as String,
        mobile: json['mobile'] as String,
        userId: json['id'] as int,
        portrait:json['portrait'] as String);
  }

}
