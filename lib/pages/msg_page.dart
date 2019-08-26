import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_warehouse/pages/read_page.dart';
import 'package:flutter_food_warehouse/pages/un_read_page.dart';
import 'package:flutter_food_warehouse/res/colors.dart';

class MsgPage extends StatefulWidget {
  @override
  _MsgPageState createState() => _MsgPageState();
}

class _MsgPageState extends State<MsgPage> with SingleTickerProviderStateMixin {
  TabController mTabController;
  PageController mPageController = PageController(initialPage: 0);
  List<TabTitle> tabList;
  var currentPage = 0;
  var isPageCanChanged = true;

  @override
  void initState() {
    super.initState();
    initTabData();
    mTabController = TabController(
      length: tabList.length,
      vsync: this,
    );
    mTabController.addListener(() {
      //TabBar的监听
      if (mTabController.indexIsChanging) {
        //判断TabBar是否切换
        print(mTabController.index);
        onPageChange(mTabController.index, p: mPageController);
      }
    });
  }

  initTabData() {
    tabList = [
      TabTitle('已读', 1),
      TabTitle('未读', 2),
    ];
  }

  onPageChange(int index, {PageController p, TabController t}) async {
    if (p != null) {
      //判断是哪一个切换
      isPageCanChanged = false;
      await mPageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
      //等待pageview切换完毕,再释放pageivew监听
      isPageCanChanged = true;
    } else {
      mTabController.animateTo(index); //切换Tabbar
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Container(
          color: Color(0xfff4f5f6),
          height: 38.0,
          width: double.infinity,
          child: TabBar(
            isScrollable: true,
            controller: mTabController,
            labelColor: Colours.green_1,
            indicatorColor: Colours.green_1,
            unselectedLabelColor: Color(0xff666666),
            labelStyle: TextStyle(fontSize: 16.0),
            tabs: tabList.map((item) {
              return Container(
                  width: ScreenUtil.getInstance().getWidth(156),
                  height: 38.0,
                  child: Tab(
                    text: item.title,
                  ));
            }).toList(),
          ),
        ),
        Expanded(
            child: PageView.builder(
                itemCount: tabList.length,
                onPageChanged: (index) {
                  if (isPageCanChanged) {
                    //由于pageview切换是会回调这个方法,又会触发切换tabbar的操作,
                    // 所以定义一个flag,控制pageview的回调
                    onPageChange(index);
                  }
                },
                controller: mPageController,
                itemBuilder: (BuildContext context, int index) {
                  return _allPages[index];
                }))
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    mTabController.dispose();
  }
}
final List<Widget> _allPages = [ReadPage(), UnReadPage()];
class TabTitle {
  String title;
  int id;
  TabTitle(this.title, this.id);
}
