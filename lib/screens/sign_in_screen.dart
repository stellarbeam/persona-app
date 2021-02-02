import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_bloc/auth_bloc.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/sign-in';

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  AuthBloc authBloc;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
    authBloc.add(AuthUninitialized());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthUnauthorized) {
            return SignInForm();
          } else if (state is AuthInitial) {
            return Container(
              child: Center(
                child: Text("Waiting for firestore"),
              ),
            );
          } else {
            return Container(
              child: Center(
                child: Text("Waiting ..."),
              ),
            );
          }
        },
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController phoneNumController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: phoneNumController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Enter your phone number",
                prefixText: "+91",
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
            FlatButton(
              child: Text("Send code"),
              onPressed: () {
                print("+91" + phoneNumController.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
