import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class OnboardingPage {
  final String lottieFilePath;
  final String title;
  final String description;
  final AnimationController animationController;

  OnboardingPage({
    @required this.lottieFilePath,
    @required this.title,
    @required this.description,
    @required this.animationController,
  });
}
