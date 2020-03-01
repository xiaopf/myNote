import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import './Component/ContentBoxQuery.dart';

class QueryNote extends StatefulWidget {
  QueryNote({Key key, this.viewListStyle}) : super(key: key);
  final bool viewListStyle;
  @override
  _QueryNoteState createState() => _QueryNoteState();
}

class _QueryNoteState extends State<QueryNote> {
  List _noteList = [];
  String _queryText = '';
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() { 
    super.initState();
    _updateNoteList();
  }

  void _updateNoteList() async{
    List list = await _readData();
    setState((){
        _noteList = list;
    });
  }

  Future<File> _getLocalFile() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/noteList.json');
  }

  Future<List> _readData() async{
    try {
      File file = await _getLocalFile();
      String data = await file.readAsString();
      List noteList = json.decode(data);
      return noteList;
    } on FileSystemException {
      return [];
    }
  }

  List filterList() {
    List list = [];
    for(int i = 0; i < _noteList.length; i ++) {
      if(_noteList[i]['content'].contains(_queryText) || _noteList[i]['title'].contains(_queryText)){
        _noteList[i]['index'] = i;
        list.add(_noteList[i]);
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    _controller.addListener((){
      setState(() {
        _queryText = _controller.text;
      });
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: TextField(
          autofocus: true,
          controller: _controller,
          decoration: InputDecoration(
            hintText: "输入查找内容",
            contentPadding: EdgeInsets.all(10.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
              borderSide: BorderSide(
                style: BorderStyle.none
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
              borderSide: BorderSide(
                style: BorderStyle.none
              ),
            ),
          ),
        )
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding:EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ContentBoxQuery(
                noteList: filterList(),
                viewListStyle: widget.viewListStyle,
                updateNoteList:_updateNoteList
              )
            )
          ],
        ),
      ),
    );
  }
}
