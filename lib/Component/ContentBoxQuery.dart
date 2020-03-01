import 'package:flutter/material.dart';
import './SingleContent.dart';


class ContentBoxQuery extends StatefulWidget {
  ContentBoxQuery({
    Key key,
    this.noteList,
    this.viewListStyle,
    this.updateNoteList,
  }) : super(key: key);
  
  final List noteList;
  final bool viewListStyle;
  final Function updateNoteList;
  int status;

  @override
  _ContentBoxQueryState createState() => _ContentBoxQueryState();
}

class _ContentBoxQueryState extends State<ContentBoxQuery> {
  Widget _noteColumnBuilder(List filteList, String limit) {
    List<Widget> list = [];

    for(int i = 0; i < filteList.length; i ++) {
      Map note = filteList[i];

      if((limit == 'fisrt' && i % 2 == 1) || (limit == 'second' && i % 2 == 0)){
        continue;
      }
      list.add(
        SingleContent(
          index: note['index'],
          note: note,
          updateNoteList: widget.updateNoteList,
          finishedNote: (){},
          deleteNote: (){},
          recoveryNote: (){},
          disable: true,
        )
      );
      list.add(SizedBox(height: 8.0),);
    }
    return Column(
      children: list,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start
    );
  }

  Widget _mainContent(list, title) {
    return Column(
      children: <Widget>[
        list.length > 0 ?
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: 10.0, left:4.0),
            height: 34.0,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ): SizedBox(width: 0, height: 0,),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: widget.viewListStyle ?
          [
            Expanded(
              child: _noteColumnBuilder(list, 'fisrt')
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: _noteColumnBuilder(list, 'second')
            )
          ]
          :
          [
            Expanded(
              child: _noteColumnBuilder(list, 'all')
            ),
          ]
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listViewList = [];
    bool showMsg = false;
    List list1 = [];
    List list2 = [];
    List list3 = [];

    for(int i = 0; i < widget.noteList.length; i ++) {
      switch(widget.noteList[i]['status']){
        case 0:
          list1.add(widget.noteList[i]);
        break;
        case 1:
          list2.add(widget.noteList[i]);
        break;
        case 2:
          list3.add(widget.noteList[i]);
        break;
      }
    }
    
    showMsg = list1.length == 0 && list2.length == 0 && list3.length == 0;

    listViewList.add(_mainContent(list1, '记事'));
    listViewList.add(_mainContent(list2, '归档'));
    listViewList.add(_mainContent(list3, '回收站'));

    return showMsg ?
      Column(
        children: <Widget>[
          Center(
            heightFactor: 2.0,
            child: Text('暂无内容', style: TextStyle(color: Colors.blueGrey,fontSize: 16.0),)
          ),
          Divider(
            indent: 20.0,
            endIndent: 20.0,
            height: 0.0,
            thickness:1.5,
          ),
        ],
      )
      :
      ListView(
        padding: EdgeInsets.fromLTRB(0, 4.0, 0, 66.0),
        shrinkWrap: true,
        children: listViewList
      );
  }
}
