import 'package:flutter/material.dart';
import './HomeNote.dart';
import './OthenNote.dart';
import './Tags.dart';
import './SplashPage.dart';
import './SendFeedBack.dart';
import 'package:flutter/rendering.dart';

void main(){
  debugPaintSizeEnabled=false;
  runApp(MyNote());
}

class MyNote extends StatefulWidget {
  @override
  _MyNoteState createState() => new _MyNoteState();
}
class _MyNoteState extends State<MyNote> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Note',
      theme: ThemeData(
        platform: TargetPlatform.iOS,
      ),
      initialRoute: '/splash',
      routes: <String, WidgetBuilder>{
        '/splash': (BuildContext context) => SplashPage(),
        '/': (BuildContext context) => HomeNote(title: 'Flutter Demo Home Page'),
        '/finished': (BuildContext context) => OthenNote(title: '归档'),
        '/recycled': (BuildContext context) => OthenNote(title: '回收站'),
        '/tags': (BuildContext context) => Tags(title: '创建/修改标签'),
        '/feedback': (BuildContext context) => SendFeedBack(title: '发送反馈'),
      },
    );
  }
}