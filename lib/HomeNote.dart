import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import './Detail.dart';
import './MyDrawer.dart';
import './Component/ContentBox.dart';
import './QueryNote.dart';


class HomeNote extends StatefulWidget {
  HomeNote({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeNoteState createState() => _HomeNoteState();
}

class _HomeNoteState extends State<HomeNote> {
  bool viewListStyle = true;
  List _noteList = [];
  List _tagList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() { 
    super.initState();
    // _addNote();
    // _delNote('noteList');
    // _delNote('tagList');
    _updateNoteList();
    _updateTagList();
  }

  void _updateNoteList() async{
    List list = await _readData('noteList');
    setState((){
        _noteList = list;
    });
  }

  void _updateTagList() async{
    List list = await _readData('tagList');
    setState((){
        _tagList = list;
    });
  }

  Future<File> _getLocalFile(fileName) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/$fileName.json');
  }

  Future<List> _readData(fileName) async{
    try {
      File file = await _getLocalFile(fileName);
      String data = await file.readAsString();
      List noteList = json.decode(data);
      return noteList;
    } on FileSystemException {
      return [];
    }
  }

  Future<Null> _finishedNote(id) async {
    setState(() {
      _noteList[id]['status'] = 1; // 归档
    });
    await (await _getLocalFile('noteList')).writeAsString(json.encode(_noteList));
  }

  // Future<Null> _addNote() async {
  //   Map note = {};
   
  //   note['type'] = "text";
  //   note['fixed'] = false;
  //   note['finished'] = false;
  //   note['title'] = "记事格式";
  //   note['bgColor'] = 0xFFd4fd9e;
  //   note['content'] = "最近一直在做数组的题目，这种题一眼就想到了计数排序，唯一的不同就是在排序的时候要按arr2的顺序排。我的代码是遍历了两边，第一遍是遍历arr2，第二遍遍历整个排序，如果你有更好的计数排序方法，欢迎你告诉我。";
  //   setState(() {
  //     _noteList.add(note);
  //   });
  //   await (await _getLocalFile('noteList')).writeAsString(json.encode(_noteList));
  // }
  Future<Null> _delNote(fileName) async {
    await (await _getLocalFile(fileName)).writeAsString(json.encode([]));
  }

  @override
  Widget build(BuildContext context) {
    _searchController.addListener((){

    });
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: MyDrawer(),
      body: Container(
        padding:EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(8.0, 50.0, 8.0, 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                border: Border.all(
                  color: Colors.amber,
                  width: 1,
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () => _scaffoldKey.currentState.openDrawer()
                  ),
                  Expanded(
                    child: TextField(
                      enableInteractiveSelection: false,
                      onTap: () async{ 
                        FocusScope.of(context).requestFocus(new FocusNode());
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QueryNote(viewListStyle: viewListStyle))
                        );
                        // _updateNoteList();
                      },
                      decoration: InputDecoration(
                        labelText: '搜索您的记事',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      controller: _searchController,
                    )
                  ),
                  IconButton(
                    icon: viewListStyle ? Icon(Icons.view_list) : Icon(Icons.view_module),
                    onPressed: (){
                      setState((){
                        viewListStyle = !viewListStyle;
                      });
                    }
                  ),
                ],
              )
            ),
            Expanded(
              child: ContentBox(
                noteList: _noteList,
                tagList: _tagList,
                viewListStyle: viewListStyle,
                finishedNote: _finishedNote,
                updateNoteList: _updateNoteList
              )
            )
          ],
        ),
      ),
      // 暂时注释掉
      // bottomSheet: Container(
      //   padding: EdgeInsets.only(bottom: 20.0),
      //   child:  SizedBox(
      //   height: 50.0,
      //   child: Row(
      //       children: <Widget>[
      //         IconButton(
      //           icon: Icon(Icons.check_box),
      //           onPressed: () => _scaffoldKey.currentState.openDrawer()
      //         ),
      //         IconButton(
      //           icon: Icon(Icons.mic),
      //           onPressed: () => _scaffoldKey.currentState.openDrawer()
      //         ),
      //         IconButton(
      //           icon: Icon(Icons.photo_size_select_actual),
      //           onPressed: () => _scaffoldKey.currentState.openDrawer()
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: 15.0, right: 15.0),
        child: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async{
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Detail())
          );
          _updateNoteList();
        },
        tooltip: 'newContent',
        child: Icon(
          Icons.add,
          color: Colors.amber,
          size: 40.0
        ),
      ), 
      )
    );
  }
}
