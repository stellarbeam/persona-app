import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/theme_bloc/theme_bloc.dart';

import '../widgets/gradient_button.dart';
import '../widgets/verification_code_form.dart';
import '../widgets/theme_switcher_icon.dart';
import '../widgets/language_changer_icon.dart';

import '../localization/app_localization.dart';

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
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return GradientButton(
                gradientColors: state.themeData.buttonGradient,
                label: widget._authBloc.waitingForVerification
                    ? AppLocalizations.of(context).translate('verifying')
                    : AppLocalizations.of(context).translate('verify'),
                onPress: _onSubmit,
                loading: widget._authBloc.waitingForVerification,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _appLocalizations = AppLocalizations.of(context);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: state.themeData.backgroundGradient,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                _buildThemeSwitcherIcon(state, context),
                _buildLanguageChangerIcon(),
                Column(
                  children: <Widget>[
                    SizedBox(height: 70),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        _appLocalizations.translate('phone_verification_title'),
                        style: TextStyle(
                          color: state.themeData.helpText,
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
                          text: _appLocalizations.translate('enter_code'),
                          children: [
                            TextSpan(
                              text: widget.phoneNumber,
                              style: TextStyle(
                                color: state.themeData.helpText,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                          style: TextStyle(
                              color: state.themeData.helpText, fontSize: 15),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    VerificationCodeForm(
                      formKey: formKey,
                      hasError: hasError,
                      errorController: errorController,
                      textEditingController: textEditingController,
                      setCurrentText: setCurrentText,
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: _appLocalizations.translate('did_not_receive'),
                        style: TextStyle(
                          color: state.themeData.helpText,
                          fontSize: 15,
                        ),
                        children: [
                          TextSpan(
                            text: _appLocalizations.translate('resend'),
                            recognizer: resendCode,
                            style: TextStyle(
                              color: state.themeData.helpTextHighlighted,
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
              ],
            ),
          ),
        );
      },
    );
  }

  Positioned _buildLanguageChangerIcon() {
    return Positioned(
      top: 12,
      right: 50,
      child: LanguageSwitcherIcon(),
    );
  }

  Positioned _buildThemeSwitcherIcon(ThemeState state, BuildContext context) {
    return Positioned(
      top: 12,
      right: 12,
      child: ThemeSwitcherIcon(state),
    );
  }
}
