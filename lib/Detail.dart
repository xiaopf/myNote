import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/animation.dart';
import 'package:to_do_list/ChooseTags.dart';

class Detail extends StatefulWidget {
  Detail({Key key, this.id}) : super(key: key);

  final int id;

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> with SingleTickerProviderStateMixin{
  List _noteList = [];
  List _tagList = [];
  int _chooseColorIndex = 0;
  bool _isFixed= false;
  int _status = 0; // 0 正常 1 完成，归档 2 删除
  String _type = 'text';
  String _title = '';
  String _content = '';
  String _lastEditTime = '';
  bool _showBottomMenu = false;
  List _choosedTagList = [];
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerContent = TextEditingController();
  final FocusNode _inputFocus = FocusNode();
  Animation<double> animation;
  AnimationController controllerBottomMenu;
  List<int> preSetColors = [
    0xFFffffff,
    0xFFe39185,
    0xFFf0be42,
    0xFFfbf587,
    0xFFd4fd9e,
    0xFFb9fcec,
    0xFFd1eff7,
    0xFFb2cbf5,
    0xFFcfb0f5,
    0xFFf4d1e7,
    0xFFdfcaac,
    0xFFe6eaed
  ];

  @override
  void initState(){ 
    super.initState();
    _updateDetailPageData();
    _updateTagList();
    _controllerTitle.text = widget.id is int ? '_title' : '';

    controllerBottomMenu = new AnimationController(
      duration: const Duration(milliseconds: 200), 
      vsync: this
    );
    animation = new Tween(begin: -100.0, end: 70.0).animate(controllerBottomMenu)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    
  }

  void _updateDetailPageData() async{
    List list = await _readData('noteList');
    setState((){
        _noteList = list;
        _type = widget.id is int ? list[widget.id]['type'] : _type;
        _isFixed = widget.id is int ? list[widget.id]['fixed'] : _isFixed;
        _status = widget.id is int ? list[widget.id]['status'] : _status;
        _title = widget.id is int ? list[widget.id]['title'] : _title;
        _chooseColorIndex = widget.id is int ? preSetColors.indexWhere((element)=>(element == list[widget.id]['bgColor'])) : _chooseColorIndex;
        _content = widget.id is int ? list[widget.id]['content'] : _content;
        _choosedTagList = widget.id is int ? list[widget.id]['tags'] : _choosedTagList;
        _lastEditTime = widget.id is int ? list[widget.id]['lastEditTime'] : _lastEditTime;
    });
    _controllerTitle.text = widget.id is int ? _title : '';
    _controllerTitle.selection = TextSelection.collapsed(offset: _controllerTitle.text.length);
    _controllerContent.text = widget.id is int ? _content : '';
    _controllerContent.selection = TextSelection.collapsed(offset: _controllerContent.text.length);
  }

  void _updateTagList() async{
    List list = await _readData('tagList');
    setState((){
        _tagList = list;
    });
  }

  String _getTime() {
    var date = new DateTime.now();
    return "${date.year.toString()}/${date.month.toString().padLeft(2,'0')}/${date.day.toString().padLeft(2,'0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  Future<File> _getLocalFile(fileName) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/$fileName.json');
  }

  Future<List> _readData(fileName) async{
    try {
      File file = await _getLocalFile(fileName);
      String data = await file.readAsString();
      List list = json.decode(data);
      return list;
    } on FileSystemException {
      return [];
    }
  }
  
  Future<Null> _addNote() async {
    Map note = {};
    note['type'] = _type;
    note['fixed'] = _isFixed;
    note['status'] = _status;
    note['title'] = _title;
    note['bgColor'] = preSetColors[_chooseColorIndex];
    note['content'] = _content;
    note['tags'] = _choosedTagList;
    note['lastEditTime'] = _getTime();
    setState(() {
      _noteList.add(note);
      _lastEditTime = _getTime();
    });
    await (await _getLocalFile('noteList')).writeAsString(json.encode(_noteList));
    Navigator.pop(context);
  }

  Future<Null> _modifyNote() async {
    Map note = {};
    note['type'] = _type;
    note['fixed'] = _isFixed;
    note['status'] = _status;
    note['title'] = _title;
    note['bgColor'] = preSetColors[_chooseColorIndex];
    note['content'] = _content;
    note['tags'] = _choosedTagList;
    note['lastEditTime'] = _getTime();
    setState(() {
      _noteList[widget.id] = note;
      _lastEditTime = _getTime();
    });
    await (await _getLocalFile('noteList')).writeAsString(json.encode(_noteList));
    Navigator.pop(context);
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('确定离开本页面?'),
        actions: <Widget>[
          FlatButton(
              child: Text('暂不'),
              onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
              child: Text('确定'),
              onPressed: () => Navigator.pop(context, true),
          ),
        ],
      )
    );
  }

  List<Widget> _colorPicker(chooseColorIndex) {
    List<Widget> list = [];
    for (var i = 0; i < preSetColors.length; i++) {
      int color = preSetColors[i];
      list.add(
        InkWell(
          onTap: (){
            setState(() {
              _chooseColorIndex = i;
            });
          },
          child: Container(
            height: 30.0,
            width: 30.0,
            margin: EdgeInsets.only(left:5.0, right:5.0),
            decoration: BoxDecoration(
              color: Color(color),
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(0xFFc5ded8),
                width: 1.0,
              )
            ),
            child: Center(
              child: Icon(
                Icons.check,
                size: 22.0,
                color: chooseColorIndex == i ? Color(0xFF516260) : Color(color),
              ),
            )
          ),
        ),
      );
      list.add(SizedBox(width: 10.0,));
    }
    return list;
  }

  List<Widget> _tagListBuilder() {
    List<Widget> list = [];
    for (var i = 0; i < _choosedTagList.length; i++) {
      if(_tagList[_choosedTagList[i]].length == 0){
        continue;
      }
      list.add(
        InkWell(
          onTap: () async{
            List choosedTagList = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChooseTags(choosedTagList: _choosedTagList))
            );
            setState(() {
              _choosedTagList = choosedTagList;
            });
          },
          child: Container(
            height:40.0,
            padding: EdgeInsets.only(left: 0),
            child: Transform(
              alignment: Alignment.centerLeft,
              transform: new Matrix4.identity()..scale(0.9),
              child: Chip(
                padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                labelPadding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                label: Text(_tagList[_choosedTagList[i]]),
              ),
            ),
          )
        )
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    _controllerTitle.addListener((){
      setState((){
        _title = _controllerTitle.text.trim();
      });
    });
    _controllerContent.addListener((){
      setState((){
        _content = _controllerContent.text.trim();
      });
    });
    return WillPopScope(
      onWillPop:() async{
        bool leave = await _onBackPressed();
        if (leave) {
          Navigator.pop(context);
        }
      },
      child:Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () async{
              bool leave = await _onBackPressed();
              if (leave) {
                Navigator.pop(context);
              }
            },
          ),
          backgroundColor: Color(preSetColors[_chooseColorIndex]),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                _isFixed ? Icons.turned_in : Icons.turned_in_not ,
                color: Colors.black
              ),
              onPressed: (){
                setState((){
                  _isFixed = !_isFixed;
                });
                widget.id is int ? _modifyNote() : _addNote();
              },
            ),
            IconButton(
              icon: Icon(
                _status == 0 ? Icons.unarchive : Icons.archive,
                color: Colors.black
              ),
              onPressed: (){
                setState((){
                  _status = _status == 0 ? 1 : 0; // 完成，归档
                });
                widget.id is int ? _modifyNote() : _addNote();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.save,
                color: Colors.black
              ),
              onPressed: widget.id is int ? _modifyNote : _addNote,
            )
          ],
        ),
        backgroundColor: Color(preSetColors[_chooseColorIndex]),
        body: Container(
          padding:EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              TextField(
                style: TextStyle(
                  fontSize:22.0,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: "标题",
                  hintStyle: TextStyle(fontSize:20.0),
                  contentPadding: EdgeInsets.all(10.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      style: BorderStyle.none
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      style: BorderStyle.none
                      // color: Colors.amber, //边线颜色为黄色
                      // width: 1,
                    ),
                  ),
                ),
                controller: _controllerTitle,
              ),
              TextField(
                style: TextStyle(
                  fontSize:18.0,
                ),
                decoration: InputDecoration(
                  hintText: "记事",
                  hintStyle: TextStyle(fontSize:20.0),
                  contentPadding: EdgeInsets.all(10.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      style: BorderStyle.none
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      style: BorderStyle.none
                      // color: Colors.amber, //边线颜色为黄色
                      // width: 1,
                    ),
                  ),
                ),
                maxLines: null,
                minLines: _choosedTagList.length > 0 ? 6 : 50,
                autofocus: true,
                controller: _controllerContent,
                focusNode: _inputFocus
              ),
              Wrap(
                children: _tagListBuilder()
              )
            ]
          )
        ),
        bottomSheet: Container(
          color: Color(preSetColors[_chooseColorIndex]),
          height: _showBottomMenu ? 160.0 : 70.0,
          child: Stack(
            textDirection: TextDirection.ltr,
            children: <Widget>[
              Positioned(
                bottom: animation.value,
                left: 0,
                right: 0,
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () async{
                        List choosedTagList = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChooseTags(choosedTagList: []))
                        );
                        setState(() {
                          _choosedTagList = choosedTagList;
                        });
                      },
                      child: Container(
                        height: 50.0,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 12.0, top: 5.0, right: 12.0),
                        decoration: BoxDecoration(
                          border: Border(
                            top:BorderSide(
                              color: Colors.grey, 
                              width: 1,
                            )
                          )
                        ),
                        child: Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.label,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: 12.0,),
                                Text(
                                  '标签',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 40.0,
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: ListView(
                        shrinkWrap: true,
                        key: PageStorageKey(1),
                        scrollDirection: Axis.horizontal,
                        children: _colorPicker(_chooseColorIndex),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Color(preSetColors[_chooseColorIndex]),
                  // color: Colors.red,
                  padding: EdgeInsets.only(bottom: 20.0),
                  height: 60.0,
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.add_box,
                          color: Color(preSetColors[_chooseColorIndex]), // 暂时注释掉
                        ),
                        onPressed: (){

                        }
                      ),
                      Text( _lastEditTime.length > 0 ? '上次编辑时间：$_lastEditTime' : ''),
                      IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: (){
                          _inputFocus.unfocus(); 
                          setState((){
                            _showBottomMenu = !_showBottomMenu;
                          });
                          if(_showBottomMenu){
                            controllerBottomMenu.forward();
                          }else{
                            controllerBottomMenu.reverse();
                          }
                        }
                      ),
                    ],
                  )
                )
              ),
            ],
          ),
        )
      )
    );
  }
}
