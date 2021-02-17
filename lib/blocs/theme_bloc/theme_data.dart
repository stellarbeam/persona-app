import 'package:flutter/material.dart';

enum Theme {
  Light,
  Dark,
}

class ThemeData {
  final List<Color> backgroundGradient;

  final Color helpText;
  final Color helpTextHighlighted;

  final Color brandLabelBackground;
  final Color brandLabelText;

  final Color formFieldFill;
  final Color formFieldHintText;
  final Color formFieldText;

  final List<Color> buttonGradient;
  final Color buttonText;

  final Color roleTabBackground;
  final Color roleTabBackgroundSelected;
  final Color roleTabText;

  final Color pinActiveFill;
  final Color pinSelectedFill;
  final Color pinActive;
  final Color pinInactive;

  ThemeData({
    @required this.backgroundGradient,
    @required this.helpText,
    @required this.helpTextHighlighted,
    @required this.brandLabelBackground,
    @required this.brandLabelText,
    @required this.formFieldFill,
    @required this.formFieldHintText,
    @required this.formFieldText,
    @required this.buttonGradient,
    @required this.buttonText,
    @required this.roleTabBackground,
    @required this.roleTabBackgroundSelected,
    @required this.roleTabText,
    @required this.pinActiveFill,
    @required this.pinSelectedFill,
    @required this.pinActive,
    @required this.pinInactive,
  });
}

final themeData = <Theme, ThemeData>{
  Theme.Light: ThemeData(
    backgroundGradient: const [Color(0xFF01CCB4), Color(0xFF006CEC)],
    helpText: Colors.white,
    helpTextHighlighted: const Color(0xFF91D3B3),
    brandLabelBackground: const Color(0xFF4EE5F0),
    brandLabelText: Colors.white,
    formFieldFill: Colors.white.withAlpha(40),
    formFieldHintText: Colors.white.withAlpha(40),
    formFieldText: Colors.white,
    buttonGradient: const [Color(0xFF00C2DC), Color(0xFF0094FF)],
    buttonText: Colors.white,
    roleTabBackground: Colors.white.withAlpha(40),
    roleTabBackgroundSelected: Colors.white.withAlpha(80),
    roleTabText: Colors.white,
    pinSelectedFill: Colors.transparent,
    pinInactive: Colors.white30,
    pinActive: Colors.white.withAlpha(40),
    pinActiveFill: Colors.white.withAlpha(40),
  ),
};
