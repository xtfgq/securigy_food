class HomeBean {
  String cloud;
  String cond_code;
  String cond_txt;
  String fl;
  String hum;
  String pcpn;
  String pres;
  String tmp;
  String vis;
  String wind_deg;
  String wind_dir;
  String wind_sc;
  String wind_spd;
  String city;
  String ctime;
  String pm25;
  String title;
  String description;
  String picUrl;
  String webUrl;

  HomeBean(
      {this.cloud,
      this.cond_code,
      this.cond_txt,
      this.fl,
      this.hum,
      this.pcpn,
      this.pres,
      this.tmp,
      this.vis,
      this.wind_deg,
      this.wind_dir,
      this.wind_sc,
      this.wind_spd,

      this.ctime,
      this.pm25,
      this.title,

      this.picUrl,
      this.webUrl});

  factory HomeBean.fromJsonWeahter(Map<String, dynamic> jsonWeahter,Map<String, dynamic> jsonAir) {
    return HomeBean(
      cloud: jsonWeahter['cloud'] as String,
      cond_code: jsonWeahter['cond_code'] as String,
      cond_txt: jsonWeahter['cond_txt'] as String,
      fl: jsonWeahter['fl'] as String,
      hum: jsonWeahter['hum'] as String,
      tmp: jsonWeahter['tmp'] as String,
      vis: jsonWeahter['vis'] as String,
      wind_deg: jsonWeahter['wind_deg'] as String,
      wind_dir: jsonWeahter['wind_dir'] as String,
      wind_sc: jsonWeahter['wind_sc'] as String,
      wind_spd: jsonWeahter['wind_spd'] as String,
      ctime: jsonAir['pub_time'] as String,
      pm25: jsonAir['pm25'] as String,
    );
  }
  factory HomeBean.fromJson(Map<String, dynamic> json) {
    return HomeBean(
      ctime: json['createTime'] as String,
      picUrl: json['img'] as String,
      title: json['title'] as String,
      webUrl: json['url'] as String
    );
  }
}
