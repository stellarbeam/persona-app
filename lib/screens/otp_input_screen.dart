import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpInputScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpInputScreen(this.phoneNumber);

  @override
  _OtpInputScreenState createState() => _OtpInputScreenState();
}

class _OtpInputScreenState extends State<OtpInputScreen> {
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      key: scaffoldKey,
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Phone Number Verification',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
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
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 30,
                  ),
                  child: PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: hasError ? Colors.orange : Colors.white,
                    ),
                    cursorColor: Colors.white,
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.blue.shade50,
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      return true;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Didn't receive the code? ",
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                  children: [
                    TextSpan(
                      text: " RESEND",
                      recognizer: onTapRecognizer,
                      style: TextStyle(
                          color: Color(0xFF91D3B3),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                width: 200,
                child: RaisedButton(
                  onPressed: () {
                    formKey.currentState.validate();
                    // conditions for validating
                    if (currentText.length != 6 || currentText != "towtow") {
                      errorController.add(ErrorAnimationType
                          .shake); // Triggering error shake animation
                      setState(() {
                        hasError = true;
                      });
                    } else {
                      setState(() {
                        hasError = false;
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("Aye!!"),
                          duration: Duration(seconds: 2),
                        ));
                      });
                    }
                  },
                  child: Center(
                    child: Text(
                      "VERIFY".toUpperCase(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
