import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../localization/app_localization.dart';

import '../widgets/language_changer_icon.dart';
import '../widgets/curve_clipper.dart';
import '../widgets/phone_number_form.dart';
import '../widgets/gradient_button.dart';
import '../widgets/brand_label.dart';
import '../widgets/theme_switcher_icon.dart';

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
            content:
                Text(AppLocalizations.of(context).translate('invalid_number')),
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
    double paddingDistance = MediaQuery.of(context).size.height * 0.10;
    const curvedDistance = 80.0;

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height,
          color: state.themeData.brandLabelBackground,
          child: SafeArea(
            child: Stack(
              children: [
                _buildThemeSwitcherIcon(),
                _buildLanguageChangerIcon(),
                _buildClippedBackground(paddingDistance, curvedDistance),
                Positioned(
                  child: BrandLabel(
                      paddingDistance + curvedDistance), // 10% height
                  top: 0,
                ),
                _buildMainView(
                  context,
                  state,
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

  Positioned _buildLanguageChangerIcon() {
    return Positioned(
      top: 12,
      right: 50,
      child: LanguageSwitcherIcon(),
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
                label: AppLocalizations.of(context).translate('next'),
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
    double paddingDistance,
    double curvedDistance,
  ) {
    final _appLocalizations = AppLocalizations.of(context);
    return Positioned(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildMainText(_appLocalizations, state), // 30% height
            _buildPhoneNumberForm(context), // 20% height
            _buildSupplementaryText(_appLocalizations, state), // 10% height
            _buildSubmitButton(),
          ],
        ),
      ),
      top: paddingDistance + curvedDistance,
    );
  }

  Container _buildPhoneNumberForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.18,
      child: PhoneNumberForm(
        _formKey,
        _validator,
        _onPhoneChanged,
      ),
    );
  }

  Widget _buildMainText(AppLocalizations appLocalizations, ThemeState state) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            appLocalizations.translate('welcome'),
            style: TextStyle(
              color: state.themeData.helpText,
              fontSize: 30,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 15),
          Text(
            appLocalizations.translate('verify_headline'),
            style: TextStyle(
              color: state.themeData.helpText,
              fontSize: 20,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplementaryText(
      AppLocalizations appLocalizations, ThemeState state) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.10,
      child: Text(
        appLocalizations.translate('verify_info'),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: state.themeData.helpText,
          fontSize: 12,
          fontFamily: 'Poppins',
        ),
      ),
      // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 35),
    );
  }

  Positioned _buildThemeSwitcherIcon() {
    return Positioned(
      top: 12,
      right: 12,
      child: ThemeSwitcherIcon(),
    );
  }
}
