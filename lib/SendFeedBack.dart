import 'package:flutter/material.dart';

class SendFeedBack extends StatefulWidget {
  SendFeedBack({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SendFeedBackState createState() => _SendFeedBackState();
}

class _SendFeedBackState extends State<SendFeedBack> {
  String _content = '';
  final TextEditingController _controllerContent = TextEditingController();


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
  @override
  Widget build(BuildContext context) {
     _controllerContent.addListener((){
      setState((){
        _content = _controllerContent.text.trim();
      });
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
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
        backgroundColor: Colors.white,
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(
                  Icons.send ,
                  color: _content.length > 0 ? Colors.black : Colors.grey
                ),
                onPressed: () {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('反馈内容已发送！'),
                      duration: Duration(milliseconds: 1500)
                    )
                  );           
                  Future.delayed(Duration(milliseconds: 1500), (){
                    Navigator.pop(context);
                  }); 
                },
              );
            }
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding:EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextField(
              style: TextStyle(
                fontSize:18.0,
              ),
              decoration: InputDecoration(
                hintText: "反馈内容",
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
              minLines: 20,
              autofocus: true,
              controller: _controllerContent,
            ),
          ]
        )
      ),
    );
  }
}