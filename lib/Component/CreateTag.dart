import 'package:flutter/material.dart';

class CreateTag extends StatefulWidget {
  CreateTag({
    Key key,
    this.addTag,
    this.addTagText,
  }) : super(key: key);

  final Function addTag;
  final String addTagText;

  @override
  _CreateTagState createState() => _CreateTagState();
}

class _CreateTagState extends State<CreateTag> {
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
            onPressed:() {
              _controller.text = '';
              setState(() {
                _tag = '';
              });
            },
            icon: Icon(
              Icons.close,
              color: Colors.grey
            )
          ),
          suffixIcon: IconButton(
            onPressed:() {
              if(_tag.length > 0) {
                widget.addTag(_tag);
              }
              setState(() {
                _changeStyle = false;
              });
              _controller.text = '';
            },
            icon: Icon(
              Icons.check,
            )
          ),
          hintText: "创建新标签",
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
              color: Colors.grey, //边线颜色为黄色
              width: 1,
            ),
          ),
        ),
        focusNode: _commentFocus,
        autofocus: true,
        controller: _controller,
      )
      :
      InkWell(
        onTap: () {
          if(widget.addTagText == null){
            setState(() {
              _changeStyle = true;
            });
            Future.delayed(Duration(milliseconds: 100), (){
              FocusScope.of(context).requestFocus(_commentFocus);
            }); 
          } else {
            widget.addTag(widget.addTagText);
          }
        },
        child: Container(
          height: 48.0,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 12.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.add,
                color: Colors.lightBlueAccent,
              ),
              SizedBox(width: 12.0,),
              Text(
                widget.addTagText == null ? "创建新标签" : '创建 “${widget.addTagText}”',
                style: TextStyle(fontSize: 16.0)
              )
            ],
          ),
        ),
      );
      
  }
}
