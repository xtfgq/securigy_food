import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
class WorkLogPage extends StatefulWidget {
  @override
  WorkLogPageState createState() => new WorkLogPageState();
}

class WorkLogPageState extends State<WorkLogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text('工作日志'),
      ),
      body: Container(
        ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(WorkLogPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}
