
import 'package:flutter/material.dart';
import 'package:flutter_food_warehouse/map/map.screen.dart';
import 'package:flutter_food_warehouse/map/navi.screen.dart';
import 'package:flutter_food_warehouse/res/ids.dart';
class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          Flexible(
            child: TabBarView(children: [
              MapScreen(),
              NaviScreen(),
            ]),
          ),
          Ids.SPACE_TINY,
          Container(
            color: Colors.white,
            height: 48,
            child: TabBar(
              tabs: [
                Text('地图', style: TextStyle(color: Colors.black)),
                Text('导航', style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );

  }



}