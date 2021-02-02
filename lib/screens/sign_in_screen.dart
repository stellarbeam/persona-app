import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_bloc/auth_bloc.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/sign-in';

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // ignore: close_sinks
  AuthBloc _authBloc;

  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthUnauthorized) {
            return SignInForm(_authBloc);
          } else if (state is AuthInitial) {
            return Container(
              child: Center(
                child: Text("Waiting for firestore"),
              ),
            );
          } else if (state is AuthCodeSent) {
            return Container(
              child: Center(
                child: Text("Auth Code sent."),
              ),
            );
          } else if (state is AuthAuthorized) {
            return Container(
              child: Center(
                child: Text("Name" + state.user.userName),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  final AuthBloc _authBloc;

  SignInForm(this._authBloc);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  TextEditingController phoneNumController = TextEditingController();

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
                String number = "+91" + phoneNumController.text;
                print(number);
                widget._authBloc.add(AuthSendOTP(number));
                print("SendOTP Event added.");
              },
            ),
          ],
        ),
      ),
    );
  }
}
