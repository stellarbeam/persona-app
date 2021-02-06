import 'package:intl_phone_field/phone_number.dart';
import '../widgets/curve_clipper.dart';
import '../widgets/phone_number_field.dart';

import 'package:flutter/material.dart';
import '../blocs/auth_bloc/auth_bloc.dart';

class PhoneInputScreen extends StatefulWidget {
  final AuthBloc _authBloc;

  PhoneInputScreen(this._authBloc);

  @override
  _PhoneInputScreenState createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  GlobalKey<FormState> _formKey;
  String _completeNumber;
  bool _phoneNumberValid;

  /// Always returns [null] so as to not show errors in form itself.
  String _validator(value) {
    setState(() {
      _phoneNumberValid = (value.length == 10) ? true : false;
    });

    return null;
  }

  void _onPhoneChanged(PhoneNumber number) {
    _completeNumber = number.completeNumber;
    // print("Changed to: $_completeNumber");
  }

  void _onSubmit() {
    print(_completeNumber);
    _formKey.currentState.validate();
    if (_phoneNumberValid) {
      widget._authBloc.add(AuthSendOTP(_completeNumber));
    } else {
      Scaffold.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Invalid phone number! Please try again.'),
            duration: Duration(seconds: 1),
          ),
        );
    }
  }

  @override
  void initState() {
    _formKey = GlobalKey();
    _completeNumber = "";
    _phoneNumberValid = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const paddingDistance = 100.0;
    const curvedDistance = 80.0;

    Widget _buildSubmitButton() {
      return RaisedButton(
        onPressed: _onSubmit,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            'Submit',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
        color: Theme.of(context).primaryColor,
      );
    }

    Widget _buildClippedBackground() {
      return ClipPath(
        clipper: CurveClipper(
          paddingDistance: paddingDistance,
          curvedDistance: curvedDistance,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Color(0xFF93B8FB),
        ),
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.deepPurple,
      child: SafeArea(
        child: Stack(
          children: [
            _buildClippedBackground(),
            Positioned(
              child: BrandLabel(paddingDistance + curvedDistance),
              top: 0,
            ),
            Positioned(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    const Text(
                      'Welcome, user!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 15),
                    const Text(
                      "Let's verify you.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 40),
                    PhoneNumberField(_formKey, _validator, _onPhoneChanged),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Text(
                        'This will help us confirm your idenity and secure your account.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildSubmitButton(),
                  ],
                ),
              ),
              top: paddingDistance + curvedDistance,
            ),
          ],
        ),
      ),
    );
  }
}
