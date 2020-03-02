import 'package:flutter/material.dart';
import '../Detail.dart';

class SingleContent extends StatefulWidget {
  SingleContent({
    Key key,
    this.index,
    this.note,
    this.tagList,
    this.finishedNote,
    this.deleteNote,
    this.recoveryNote,
    this.updateNoteList,
    this.disable,
    this.viewListStyle,
  }) : super(key: key);
  
  final int index;
  final Map note;
  final List tagList;
  final Function finishedNote;
  final Function deleteNote;
  final Function recoveryNote;
  final Function updateNoteList;
  final bool disable;
  final bool viewListStyle;

  @override
  _SingleContentState createState() => _SingleContentState();
}

class _SingleContentState extends State<SingleContent> {
  bool _showTips = false;
  List<Widget> _tagListBuilder(tags) {
    List<Widget> list = [];
    int j = 0;
    for (var i = 0; i < tags.length; i++) {
      String tag = widget.tagList[tags[i]];
      //如果tag是空值，则跳过，因为没有删除，只是把tag置空
      if(tag.length == 0) {
        continue;
      }
      if(j == 2) {
        tag = '+${tags.length - 2}';
      }
      if(j > 2) {
        break;
      }
      j ++;
      list.add(
        Container(
          height:30.0,
          margin: EdgeInsets.only(top: 6.0, right: 6.0),
          child: Chip(
            padding: EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
            labelPadding: EdgeInsets.fromLTRB(6.0, 0, 6.0, 0),
            label: Text(tag),
          ),
        ),
      );
    }
    return list;
  }

  List<Widget> _detailContentBuilder() {
    List<Widget> list = [
      Container(
        alignment: Alignment.centerLeft,
        child: Text(
          widget.note['content'].length == 0 && widget.note['title'].length == 0  ? '空内容' : '${widget.note['content']}',
          style: TextStyle(fontSize: 16.0),
          maxLines: widget.viewListStyle ? 4 : 6,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        child: Transform(
          alignment: Alignment.centerLeft,
          transform: new Matrix4.identity()..scale(0.8),
          child: Wrap(
            alignment: WrapAlignment.start,
            children: _tagListBuilder(widget.note['tags'])
          ),
        )
      ),
    ];
    if(widget.note['title'].length > 0) {
      list.insert(0,
        Center(
          child: Text(
            widget.note['title'],
            style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0)
          ),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    var thisInstant = new DateTime.now();
    return !widget.disable ?
      Dismissible(
        key: Key(thisInstant.toString()),
        direction: widget.note['status'] == 0 ? DismissDirection.endToStart : DismissDirection.horizontal,
        onDismissed: (direction) async{
          if(widget.note['status'] == 0){
            widget.finishedNote(widget.index);
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('已归档！'),
                duration: Duration(milliseconds: 1500)
              )
            );      
          }

          if(widget.deleteNote != null && widget.recoveryNote != null && widget.note['status'] > 0){
            if(direction == DismissDirection.endToStart){
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(widget.note['status'] == 1 ? '已删除到回收站！' : '已彻底删除！'),
                  duration: Duration(milliseconds: 1500)
                )
              ); 
              widget.deleteNote(widget.index);
            }else{
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(widget.note['status'] == 2 ? '已恢复到归档！' : '已恢复到记事！'),
                  duration: Duration(milliseconds: 1500)
                )
              ); 
              widget.recoveryNote(widget.index);
            }
          }

        },
        child: Stack(
            textDirection: TextDirection.ltr,
            children: <Widget>[
            InkWell(
              onLongPress: (){
                setState(() {
                  _showTips = !_showTips;
                });
                Future.delayed(Duration(seconds: 2), () {
                  setState(() {
                    _showTips = !_showTips;
                  });
                });
              },
              onTap:() async{
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Detail(id: widget.index))
                );
                // 更新home页面数据列表
                widget.updateNoteList();
              },
              child: Container(
                constraints: BoxConstraints(
                  minHeight: widget.viewListStyle ? 110.0 : 0,
                ),
                padding: EdgeInsets.all(6.0),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  // 从数据中读取出来的颜色
                  color: Color(widget.note['bgColor']),
                  border: Border.all(
                    // color: widget.note['bgColor'] == 0xFFffffff ? Colors.grey : Color(widget.note['bgColor']),
                    color: Colors.grey,
                    width: 1.50,
                  ),
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: Column(
                  children: _detailContentBuilder(),
                )
              )
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: _showTips ? 0 : -25.0,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xaa000000),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)
                  )
                ),
                height: 25.0,
                child: Text(
                  widget.note['status'] == 0 ? '左滑归档' : '左滑删除,右滑恢复',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ]
        )
      )
      :
      InkWell(
        onTap:() async{
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Detail(id: widget.index))
          );
          // 更新home页面数据列表
          widget.updateNoteList();
        },
        child: Container(
          constraints: BoxConstraints(
            minHeight: widget.viewListStyle ? 110.0 : 0,
          ),
          padding: EdgeInsets.all(6.0),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            // 从数据中读取出来的颜色
            color: Color(widget.note['bgColor']),
            border: Border.all(
              // color: widget.note['bgColor'] == 0xFFffffff ? Colors.grey : Color(widget.note['bgColor']),
              color: Colors.grey,
              width: 1.50,
            ),
            borderRadius: BorderRadius.circular(10.0)
          ),
          child: Column(
            children: _detailContentBuilder(),
          )
        )
      );
  }
}
