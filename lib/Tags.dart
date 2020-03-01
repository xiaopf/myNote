import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import './Component/CreateTag.dart';
import './Component/EditTag.dart';

class Tags extends StatefulWidget {
  Tags({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TagsState createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  List _tagList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() { 
    super.initState();
    _updateTagList();
  }

  void _updateTagList() async{
    List list = await _readData();
    setState((){
        _tagList = list;
    });
  }

  Future<File> _getLocalFile() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/tagList.json');
  }

  Future<List> _readData() async{
    try {
      File file = await _getLocalFile();
      String data = await file.readAsString();
      List tagList = json.decode(data);
      return tagList;
    } on FileSystemException {
      return [];
    }
  }

  Future<Null> _addTag(tag) async {
    setState(() {
      _tagList.add(tag);
    });
    await (await _getLocalFile()).writeAsString(json.encode(_tagList));
  }

  Future<Null> _deleteTag(index) async {
  setState(() {
      _tagList[index] = '';
    });
    await (await _getLocalFile()).writeAsString(json.encode(_tagList));
  }
  
  Future<Null> _editTag(index, tag) async {
    setState(() {
      _tagList[index] = tag;
    });
    await (await _getLocalFile()).writeAsString(json.encode(_tagList));
  }

  List<Widget> _tagWidgetList() {
    List<Widget> list = [];
    for(int i = 0; i < _tagList.length; i ++) {
      if(_tagList[i].length == 0){
        continue;
      }
      list.add(
        Container(
          color: Colors.white10,
          child: EditTag(
            text: _tagList[i],
            index: i,
            deleteTag: _deleteTag,
            editTag: _editTag
          ),
        )
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    _searchController.addListener((){

    });
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          CreateTag(
            addTag: _addTag,
          ),
          SizedBox(height: 10.0,),
          Expanded(
            child: ListView(
              key: PageStorageKey(1),
              shrinkWrap: true,
              children: _tagWidgetList(),
            ),
          ),
        ]
      )
    );
  }
}
