import 'package:flutter/material.dart';
import '../models/user.dart';

class RoleButton extends StatelessWidget {
  final Role role;
  final Function onPressed;
  const RoleButton({@required this.role, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: RawMaterialButton(
        child: Text(
          role.toString().split('.').last,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Lato',
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 20,
        ),
        fillColor: Color(0xFF6B3DD8),
        splashColor: Colors.deepPurple,
        onPressed: () => onPressed(role),
        shape: StadiumBorder(),
        elevation: 7,
      ),
    );
  }
}
