import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import './MyDrawer.dart';
import './Component/ContentBox.dart';

class OthenNote extends StatefulWidget {
  OthenNote({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _OthenNoteState createState() => _OthenNoteState();
}

class _OthenNoteState extends State<OthenNote> {
  bool viewListStyle = true;
  List _noteList = [];
  List _tagList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() { 
    super.initState();
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
  
  Future<Null> _clearDeleted() async {
    List list = [];
    for(Map note in _noteList){
      if(note['status'] < 2) {
        list.add(note);
      }
    }
    setState(() {
      _noteList = list;
    });
    await (await _getLocalFile('noteList')).writeAsString(json.encode(_noteList));
  }
  Future<Null> _deleteCompletelyNote(id) async {
    setState(() {
      _noteList.removeAt(id);
    });
    await (await _getLocalFile('noteList')).writeAsString(json.encode(_noteList));
  }
  Future<Null> _finishedNote(id) async {
    setState(() {
      _noteList[id]['status'] = 2; // 归档
    });
    await (await _getLocalFile('noteList')).writeAsString(json.encode(_noteList));
  }
  Future<Null> _recoveryNote(id, status) async {
    setState(() {
      _noteList[id]['status'] = status; // 恢复
    });
    await (await _getLocalFile('noteList')).writeAsString(json.encode(_noteList));
  }

  @override
  Widget build(BuildContext context) {
    _searchController.addListener((){

    });
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        actions: [
           IconButton(
            icon: Icon(
              viewListStyle ? Icons.view_list : Icons.view_module,
              color: Colors.black
            ),
            onPressed: (){
              setState(() {
                viewListStyle = !viewListStyle;
              });
            },
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: Container(
        padding:EdgeInsets.all(8.0),
        child: Column(
          children: widget.title == '回收站' ? [
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: InkWell(
                onTap: () async{
                  await _clearDeleted();
                  // Scaffold.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text('回收站已清空！'),
                  //     duration: Duration(milliseconds: 1500)
                  //   )
                  // ); 
                },
                child: Text(
                  '清空回收站',
                  style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontWeight: FontWeight.w500,
                  )
                )
              ),
            ),
            Expanded(
              child: ContentBox(
                noteList: _noteList,
                tagList: _tagList,
                viewListStyle: viewListStyle,
                deleteNote: _deleteCompletelyNote,
                recoveryNote: (id){_recoveryNote(id, 1);},
                updateNoteList: _updateNoteList,
                status: 2,
              )
            )
          ]
          :
          [
            Expanded(
              child: ContentBox(
                noteList: _noteList,
                tagList: _tagList,
                viewListStyle: viewListStyle,
                deleteNote: _finishedNote,
                recoveryNote: (id){_recoveryNote(id, 0);},
                updateNoteList: _updateNoteList,
                status: 1,
              )
            )
          ],
        ),
      ),
    );
  }
}
