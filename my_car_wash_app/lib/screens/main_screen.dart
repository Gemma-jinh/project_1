import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메인 화면'),
      ),
      body: Center(
        child: Text('환영합니다! 여기는 메인 화면입니다.'),
      ),
    );
  }
}
