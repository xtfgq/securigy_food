
import 'package:amap_base_navi/amap_base_navi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_warehouse/custom_widget/function_group.widget.dart';
import 'package:flutter_food_warehouse/custom_widget/function_item.widget.dart';
import 'package:flutter_food_warehouse/map/create_map/show_indoor_map.screen.dart';
import 'package:flutter_food_warehouse/map/create_map/show_map.screen.dart';
import 'package:flutter_food_warehouse/map/create_map/switch_map_layer.screen.dart';
import 'package:flutter_food_warehouse/map/draw_on_map/draw_point.screen.dart';
import 'package:flutter_food_warehouse/map/draw_on_map/draw_polyline.screen.dart';
import 'package:flutter_food_warehouse/map/interact_with_map/code_interaction.screen.dart';
import 'package:flutter_food_warehouse/map/interact_with_map/control_interaction.screen.dart';
import 'package:flutter_food_warehouse/map/interact_with_map/gesture_interaction.screen.dart';
import 'package:flutter_food_warehouse/map/tools/coordinate_transformation_screen.dart';
import 'package:flutter_food_warehouse/res/ids.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        FunctionGroup(
          headLabel: '创建地图',
          children: <Widget>[
            FunctionItem(
              label: '显示地图',
              sublabel: 'CreateMapScreen',
              target: ShowMapScreen(),
            ),
            FunctionItem(
              label: '显示室内地图',
              sublabel: 'ShowsIndoorMapScreen',
              target: ShowsIndoorMapScreen(),
            ),
            FunctionItem(
              label: '切换地图图层',
              sublabel: 'SwitchMapLayerScreen',
              target: SwitchMapLayerScreen(),
            ),
            Column(
              children: <Widget>[
                ListTile(
                  title: Text('使用离线地图'),
                  subtitle: Text('使用离线地图'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () => OfflineManager().openOfflineManager(),
                ),
                Divider(height: 1, indent: 16),
              ],
            ),
          ],
        ),
        Ids.SPACE_BIG,
        FunctionGroup(
          headLabel: '与地图交互',
          children: <Widget>[
            FunctionItem(
              label: '控件交互',
              sublabel: 'ControlInteractionScreen',
              target: ControlInteractionScreen(),
            ),
            FunctionItem(
              label: '手势交互',
              sublabel: 'GestureInteractionScreen',
              target: GestureInteractionScreen(),
            ),
            FunctionItem(
              label: '调用方法交互',
              sublabel: 'CodeInteractionScreen',
              target: CodeInteractionScreen(),
            ),
          ],
        ),
        Ids.SPACE_BIG,
        FunctionGroup(
          headLabel: '在地图上绘制',
          children: <Widget>[
            FunctionItem(
              label: '绘制点标记',
              sublabel: 'DrawPointScreen',
              target: DrawPointScreen(),
            ),
            FunctionItem(
              label: '绘制线',
              sublabel: 'DrawPolylineScreen',
              target: DrawPolylineScreen(),
            ),
          ],
        ),
        Ids.SPACE_BIG,
        FunctionGroup(
          headLabel: "工具",
          children: <Widget>[
            FunctionItem(
              label: "坐标转换",
              sublabel: "CoordinateTransformationScreen",
              target: CoordinateTransformationScreen(),
            ),
          ],
        ),
      ],
    );
  }
}
