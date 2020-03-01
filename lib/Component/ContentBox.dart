import 'package:flutter/material.dart';
import './SingleContent.dart';


class ContentBox extends StatefulWidget {
  ContentBox({
    Key key,
    this.noteList,
    this.tagList,
    this.viewListStyle,
    this.updateNoteList,
    this.finishedNote,
    this.deleteNote,
    this.recoveryNote,
    this.status,
  }) : super(key: key);
  
  final List noteList;
  final List tagList;
  final bool viewListStyle;
  final Function updateNoteList;
  final Function finishedNote;
  final Function deleteNote;
  final Function recoveryNote;
  int status;

  @override
  _ContentBoxState createState() => _ContentBoxState();
}

class _ContentBoxState extends State<ContentBox> {
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
          tagList: widget.tagList,
          finishedNote: widget.finishedNote,
          deleteNote: widget.deleteNote,
          recoveryNote: widget.recoveryNote,
          updateNoteList: widget.updateNoteList,
          disable: false
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
        title.length > 0 ?
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

    List filterList(status,fixed) {
      List list = [];
      for(int i = 0; i < widget.noteList.length; i ++) {
        if((fixed == null || widget.noteList[i]['fixed'] == fixed) && widget.noteList[i]['status'] == status){
          // 把note原本的顺序放进note自己身上暂存，其他地方不用，只有删除，归档的时候会用到
          widget.noteList[i]['index'] = i;
          list.add(widget.noteList[i]);
        }
      }
      return list;
    }

    List<Widget> listViewList = [];
    bool showMsg = false;

    if(widget.status != null && widget.status > 0){
      List list = filterList(widget.status, null);
      showMsg = list.length == 0;
      listViewList.add(_mainContent(list, ''));
    } else {
      List list1 = filterList(0 ,true,);
      List list2 = filterList(0 ,false,);
      showMsg = list1.length == 0 && list2.length == 0;
      listViewList.add(_mainContent(list1, '已固定'));
      listViewList.add(_mainContent(list2, '其他'));
    }

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
