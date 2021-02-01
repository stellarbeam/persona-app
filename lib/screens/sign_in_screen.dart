import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  static const routeName = '/sign-in';

  @override
  Widget build(BuildContext context) {
    var role = ModalRoute.of(context).settings.arguments;
    print(role);
    return Scaffold(
      body: Center(
        child: Text(role.toString().split('.').last),
      ),
    );
  }
}
