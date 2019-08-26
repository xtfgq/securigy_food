class WareHouse{
  int id;
  String name;
  WareHouse(
      {this.id,
        this.name
      });
  factory WareHouse.fromJson(Map<String, dynamic> json) {
    return WareHouse(
        id: json['id'] as int,
        name: json['name'] as String

    );
  }
}
