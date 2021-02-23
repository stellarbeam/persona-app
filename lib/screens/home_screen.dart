import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Persona"),
      ),
      body: Container(
        child: Center(
          child: Text("This will be home screen"),
        ),
      ),
    );
  }
}
