import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
// import './OthenNote.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  // List _tagList = [];

  // @override
  // void initState() { 
  //   super.initState();
  //   _updateTagList();
  // }

  Future<void> shareApp() async {
    await FlutterShare.share(
      title: 'TO-DO记事本',
      text: '下载TO-DO记事本',
      linkUrl: 'itms-apps://itunes.apple.com/us/app/id1498750095',
      chooserTitle: 'TO-DO记事本'
    );
  }
  
  // void _updateTagList() async{
  //   List list = await _readData();
  //   setState((){
  //       _tagList = list;
  //   });
  // }

  // Future<File> _getLocalFile() async {
  //   String dir = (await getApplicationDocumentsDirectory()).path;
  //   return new File('$dir/tagList.json');
  // }

  // Future<List> _readData() async{
  //   try {
  //     File file = await _getLocalFile();
  //     String data = await file.readAsString();
  //     List tagList = json.decode(data);
  //     return tagList;
  //   } on FileSystemException {
  //     return [];
  //   }
  // }

  List<Widget> _drawerListBuilder() {
    List<Widget> listTop = [
      Container(
        height: 160.0,
        child: DrawerHeader(
          padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
          decoration: BoxDecoration(
            color: Colors.amber,
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 60.0,
                height: 60.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage('assets/icon.png'),
                      fit: BoxFit.cover,
                    )
                  ),
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                'TO-DO记事本',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0,
                )
              )
            ],
          )
        ),
      ),
      ListTile(
        leading: Icon(Icons.lightbulb_outline),
        title: Text(
          '记事',
          style: TextStyle(
            fontSize: 16.0,
          )
        ),
        onTap:(){
          Navigator.of(context).pushNamed('/');
        }
      ),
      ListTile(
        leading: Icon(Icons.archive),
        title: Text(
          '归档',
          style: TextStyle(
            fontSize: 16.0,
          )
        ),
        onTap:(){
          Navigator.of(context).pushNamed('/finished');
        }
      ),
      ListTile(
        leading: Icon(Icons.delete_outline),
        title: Text(
          '回收站',
          style: TextStyle(
            fontSize: 16.0,
          )
        ),
        onTap:(){
          Navigator.of(context).pushNamed('/recycled');
        }
      ),
      Divider(
        height:1.0,
        indent: 72.0,
        thickness: 1.0,
        color: Colors.grey[350]
      ),
      Container(
        padding: EdgeInsets.fromLTRB(18.0, 10.0, 0, 0),
        child: Text(
          '标签',
          style: TextStyle(
            fontSize: 15.0,
          )
        ),
      ),
    ];

    List<Widget> listBottom = [
      ListTile(
        leading: Icon(Icons.edit),
        title: Text(
          '创建/修改标签',
          style: TextStyle(
            fontSize: 16.0,
          )
        ),
        onTap:() async{
          await Navigator.of(context).pushNamed('/tags');
          // 编辑完了更新list
          // _updateTagList();
        }
        ),
        Divider(
          height:1.0,
          indent: 72.0,
          thickness: 1.0,
          color: Colors.grey[350]
        ),
        ListTile(
          leading: Icon(Icons.share),
          title: Text(
            '应用分享',
            style: TextStyle(
              fontSize: 16.0,
            )
          ),
          onTap: shareApp
        ),
        ListTile(
          leading: Icon(Icons.announcement),
          title: Text(
            '发送反馈',
            style: TextStyle(
              fontSize: 16.0,
            )
          ),
          onTap:(){
            Navigator.of(context).pushNamed('/feedback');
          }
        ),
      ];

      // for (var i = 0; i < _tagList.length; i++) {
      //   listTop.add(
      //     ListTile(
      //       leading: Icon(Icons.label),
      //       title: Text(
      //         _tagList[i],
      //         style: TextStyle(
      //           fontSize: 16.0,
      //         )
      //       ),
      //       onTap:() async{
      //         await Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => OthenNote(title: _tagList[i]))
      //         );
      //       }
      //     )
      //   );
      // }
      listTop.addAll(listBottom);
      return listTop;
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: _drawerListBuilder()
      )
    );
  }
}
