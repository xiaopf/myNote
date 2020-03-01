import 'package:flutter/material.dart';

class EditTag extends StatefulWidget {
  EditTag({
    Key key,
    this.text,
    this.index,
    this.deleteTag,
    this.editTag
  }) : super(key: key);

  final String text;
  final int index;
  final Function deleteTag;
  final Function editTag;

  @override
  _EditTagState createState() => _EditTagState();
}

class _EditTagState extends State<EditTag> {
  bool _changeStyle = false;
  String _tag = '';
  final TextEditingController _controller = TextEditingController();
  final FocusNode _commentFocus = FocusNode();


  @override
  void initState(){ 
    super.initState();
    // 监听失去焦点事件
    _commentFocus.addListener(() {
      if (!_commentFocus.hasFocus) {
        // TextField has lost focus
        setState(() {
          _changeStyle = !_changeStyle;
        });
      }
    });
  }

  Future<bool> _showAlertDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('要删除这个标签么？'),
        actions: <Widget>[
          FlatButton(
              child: Text('取消'),
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

  @override
  Widget build(BuildContext context) {
    _controller.addListener((){
      setState((){
        _tag = _controller.text.trim();
      });
    });

    return _changeStyle ?
      TextField(
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed:() async{
              bool delete = await _showAlertDialog();
              if(delete) {
                widget.deleteTag(widget.index);
              }
            },
            icon: Icon(
              Icons.delete_forever,
              color: Colors.grey[600]
            )
          ),
          suffixIcon: IconButton(
            onPressed:() {
              widget.editTag(widget.index, _tag);
              setState(() {
                _changeStyle = false;
              });
            },
            icon: Icon(
              Icons.check,
            )
          ),
          hintText: "创建新标签",
          contentPadding: EdgeInsets.all(12.0),
          focusedBorder: widget.index > 0 ?
            UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
              borderSide: BorderSide(
                color: Colors.grey, 
                width: 1,
              ),
            )
            :
            OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
              borderSide: BorderSide(
                color: Colors.grey, 
                width: 1,
              ),
            ),
        ),
        onEditingComplete: (){
          widget.editTag(widget.index, _tag);
          setState(() {
            _changeStyle = false;
          });
        },
        focusNode: _commentFocus,
        autofocus: true,
        controller: _controller,
      )
      :
      InkWell(
        onTap: () {
          setState(() {
            _changeStyle = true;
          });
          _controller.text = widget.text;
          Future.delayed(Duration(milliseconds: 100), (){
            FocusScope.of(context).requestFocus(_commentFocus);
          });  
        },
        child: Container(
          height: 48.0,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 12.0, right: 12.0),
          decoration: BoxDecoration(
            border: Border(
              bottom:BorderSide(
                color: Colors.grey, 
                width: 1,
              )
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.label,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 12.0,),
                  Text(
                    widget.text,
                    style: TextStyle(fontSize: 16.0)
                  ),
                ],
              ),
              Icon(
                Icons.edit,
                color: Colors.grey[600]
              )
            ],
          ),
        ),
      );
      
  }
}
