import 'package:flutter/material.dart';
import '../screens/sign_in_screen.dart';
import '../widgets/role_button.dart';
import '../models/user.dart';

class RolePickerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _chooseRole(Role role) {
      Navigator.of(context).pushNamed(SignInScreen.routeName, arguments: role);
    }

    return Scaffold(
      body: Container(
        color: Color(0xFF0E5597),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 20),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  "Welcome To PERSONA",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontFamily: 'Pacifico',
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Text(
                    "I am :",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Lato',
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(height: 25),
                  RoleButton(
                    role: Role.Admin,
                    onPressed: _chooseRole,
                  ),
                  SizedBox(height: 15),
                  RoleButton(
                    role: Role.Boss,
                    onPressed: _chooseRole,
                  ),
                  SizedBox(height: 15),
                  RoleButton(
                    role: Role.Employee,
                    onPressed: _chooseRole,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
