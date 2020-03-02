import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import './Component/CreateTag.dart';

class ChooseTags extends StatefulWidget {
  ChooseTags({Key key, this.choosedTagList}) : super(key: key);
  final List choosedTagList;
  @override
  _ChooseTagsState createState() => _ChooseTagsState();
}

class _ChooseTagsState extends State<ChooseTags> {
  List _tagList = [];
  List _choosedTagList = [];
  String _queryTag = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() { 
    super.initState();
    _updateTagList();
    setState(() {
      _choosedTagList = widget.choosedTagList;
    });
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
      _choosedTagList.add(_tagList.length-1);
    });
    _controller.text = '';
    await (await _getLocalFile()).writeAsString(json.encode(_tagList));
  }


  List<Widget> _tagWidgetList() {
    List<Widget> list = [];
    for (var i = 0; i < _tagList.length; i++) {
      if((!_tagList[i].contains(_queryTag) && _queryTag.length > 0) || _tagList[i].length == 0){
        continue;
      }
      list.add(
        Container(
          color: Colors.white10,
          child: ListTile(
            onTap: (){
              setState(() {
                if(_choosedTagList.contains(i)){
                  _choosedTagList.remove(i);
                } else {
                  _choosedTagList.add(i);
                }
              });
            },
            leading: Icon(Icons.label),
            title: Text(_tagList[i]),
            trailing: Checkbox(
              value: _choosedTagList.contains(i),
              onChanged: (value) {
                setState(() {
                if(_choosedTagList.contains(i)){
                  _choosedTagList.remove(i);
                } else {
                  _choosedTagList.add(i);
                }
              });
              }
            )
          )
        )
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    _controller.addListener((){
      setState(() {
        _queryTag = _controller.text;
      });
    });
    return WillPopScope(
      onWillPop:(){
        Navigator.pop(context, _choosedTagList);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: (){
              Navigator.pop(context, _choosedTagList);
            },
          ),
          title: TextField(
            autofocus: true,
            controller: _controller,
            decoration: InputDecoration(
              hintText: "输入标签名称",
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
        body: Column(
          children: _queryTag.length == 0 || _tagList.contains(_queryTag)?
          [
            Expanded(
              child: ListView(
                key: PageStorageKey(1),
                shrinkWrap: true,
                children: _tagWidgetList(),
              ),
            ),
          ]
          :
          [
            CreateTag(
              addTag: _addTag,
              addTagText: _queryTag
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
      ),
    );
  }
}
