import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../blocs/theme_bloc/theme_bloc.dart';

class VerificationCodeForm extends StatelessWidget {
  const VerificationCodeForm({
    Key key,
    @required this.formKey,
    @required this.hasError,
    @required this.errorController,
    @required this.textEditingController,
    @required this.setCurrentText,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final bool hasError;
  final StreamController<ErrorAnimationType> errorController;
  final TextEditingController textEditingController;
  final Function setCurrentText;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 30,
        ),
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return PinCodeTextField(
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
                selectedFillColor: state.themeData.pinSelectedFill,
                inactiveColor: state.themeData.pinInactive,
                activeColor: state.themeData.pinActive,
                activeFillColor: state.themeData.pinActiveFill,
              ),
              textStyle: TextStyle(
                color: state.themeData.formFieldText,
              ),
              cursorColor: state.themeData.formFieldText,
              animationDuration: Duration(milliseconds: 300),
              backgroundColor: Colors.transparent,
              errorAnimationController: errorController,
              controller: textEditingController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setCurrentText(value);
              },
              beforeTextPaste: (text) {
                return true;
              },
            );
          },
        ),
      ),
    );
  }
}
