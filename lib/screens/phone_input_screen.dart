import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:persona/blocs/theme_bloc/theme_data.dart';

import '../widgets/curve_clipper.dart';
import '../widgets/phone_number_form.dart';
import '../widgets/gradient_button.dart';
import '../widgets/brand_label.dart';

import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/theme_bloc/theme_bloc.dart';

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
    const paddingDistance = 80.0;
    const curvedDistance = 80.0;

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height,
          color: state.themeData.brandLabelBackground,
          child: SafeArea(
            child: Stack(
              children: [
                _buildThemeSwitcherIcon(state, context),
                _buildClippedBackground(paddingDistance, curvedDistance),
                Positioned(
                  child: BrandLabel(paddingDistance + curvedDistance),
                  top: 0,
                ),
                _buildMainView(
                  context,
                  state,
                  _buildSubmitButton,
                  paddingDistance,
                  curvedDistance,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildClippedBackground(
      double paddingDistance, double curvedDistance) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (_, state) {
        return ClipPath(
          clipper: CurveClipper(
            paddingDistance: paddingDistance,
            curvedDistance: curvedDistance,
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: state.themeData.backgroundGradient,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (_, state) {
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              GradientButton(
                gradientColors: state.themeData.buttonGradient,
                label: "Submit",
                onPress: _onSubmit,
              ),
            ],
          ),
        );
      },
    );
  }

  Positioned _buildMainView(
    BuildContext context,
    ThemeState state,
    Widget _buildSubmitButton(),
    double paddingDistance,
    double curvedDistance,
  ) {
    return Positioned(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Text(
              'Welcome, user!',
              style: TextStyle(
                color: state.themeData.helpText,
                fontSize: 30,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 15),
            Text(
              "Let's verify you.",
              style: TextStyle(
                color: state.themeData.helpText,
                fontSize: 20,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 40),
            PhoneNumberForm(_formKey, _validator, _onPhoneChanged),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'This will help us confirm your idenity and secure your account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: state.themeData.helpText,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildSubmitButton(),
          ],
        ),
      ),
      top: paddingDistance + curvedDistance,
    );
  }

  Positioned _buildThemeSwitcherIcon(ThemeState state, BuildContext context) {
    return Positioned(
      top: 12,
      right: 12,
      child: IconButton(
        icon: Icon(
          state.theme == AppTheme.Light
              ? Icons.wb_sunny_outlined
              : Icons.nightlight_round,
          color: Colors.white,
        ),
        onPressed: () {
          BlocProvider.of<ThemeBloc>(context).add(
            ThemeChanged(
                state.theme == AppTheme.Light ? AppTheme.Dark : AppTheme.Light),
          );
        },
      ),
    );
  }
}
