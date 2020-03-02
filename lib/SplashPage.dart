import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushNamed('/');
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Image.asset("splash.png", fit: BoxFit.cover),
    );
  }
}
