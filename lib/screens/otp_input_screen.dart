import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:persona/blocs/auth_bloc/auth_bloc.dart';
import 'package:persona/widgets/gradient_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../widgets/verification_code_form.dart';

class OtpInputScreen extends StatefulWidget {
  final AuthBloc _authBloc;
  final String phoneNumber;
  const OtpInputScreen(this._authBloc, this.phoneNumber);

  @override
  _OtpInputScreenState createState() => _OtpInputScreenState();
}

class _OtpInputScreenState extends State<OtpInputScreen> {
  TapGestureRecognizer resendCode;
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  void setCurrentText(text) {
    setState(() {
      currentText = text;
    });
  }

  @override
  void initState() {
    resendCode = TapGestureRecognizer()
      ..onTap = () {
        widget._authBloc.add(RequestResendOtp());
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  void _onSubmit() {
    formKey.currentState.validate();
    if (currentText.length != 6) {
      errorController.add(ErrorAnimationType.shake);
      setState(() {
        hasError = true;
      });
    } else {
      setState(() {
        hasError = false;
      });
      widget._authBloc.add(EnterVerificationCode(currentText, _onIncorrectOtp));
    }
  }

  void _onIncorrectOtp() {
    errorController.add(ErrorAnimationType.shake);
    setState(() {});
  }

  Widget _buildSubmitButton() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          GradientButton(
            gradientColors: [
              Color(0xFF00C2DC),
              Color(0xFF0094FF),
            ],
            label: widget._authBloc.waitingForVerification
                ? "Verifying"
                : "Verify",
            onPress: _onSubmit,
            loading: widget._authBloc.waitingForVerification,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF01CCB4), Color(0xFF006CEC)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Phone Number Verification',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 8,
              ),
              child: RichText(
                text: TextSpan(
                  text: "Enter the code sent to ",
                  children: [
                    TextSpan(
                      text: widget.phoneNumber,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            VerificationCodeForm(
              formKey: formKey,
              hasError: hasError,
              errorController: errorController,
              textEditingController: textEditingController,
              setCurrentText: setCurrentText,
            ),
            SizedBox(
              height: 20,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Didn't receive the code? ",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 15,
                ),
                children: [
                  TextSpan(
                    text: "RESEND",
                    recognizer: resendCode,
                    style: TextStyle(
                      color: Color(0xFF91D3B3),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }
}
