import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../blocs/theme_bloc/theme_bloc.dart';
import '../models/onboarding_page.dart';

import '../screens/home_screen.dart';
import '../widgets/page_naviagtion_bar.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({Key key}) : super(key: key);

  static const routeName = '/onboard';

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<OnboardingPage> _pageInfo;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    initPageInfo();
  }

  @override
  void dispose() {
    disposePageControllers();
    super.dispose();
  }

  void _onDone() {
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (_, state) {
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
                  PageView(
                    onPageChanged: (index) {
                      print('Called');
                      setState(() {
                        _currentIndex = index;
                      });
                      print("Current index: $index");
                    },
                    controller: _pageController,
                    physics: BouncingScrollPhysics(),
                    children: _pageInfo
                        .map((page) => _buildPage(context, page))
                        .toList(),
                  ),
                  Positioned(
                    bottom: 20,
                    child: PageNavigationBar(
                      _pageInfo.length,
                      _currentIndex,
                      _pageController,
                      _onDone,
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Container _buildPage(BuildContext context, OnboardingPage page) {
    return Container(
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.60,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Lottie.asset(
                  page.lottieFilePath,
                  controller: page.animationController,
                  onLoaded: (composition) {
                    // This function is called everytime the page containing
                    // this animation is opened.
                    // Hence, reset the animation if already finished
                    // and start it again.
                    page.animationController
                      ..duration = composition.duration
                      ..reset()
                      ..forward();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    page.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: state.themeData.helpText),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  page.description,
                  textAlign: TextAlign.justify,
                  style:
                      TextStyle(color: state.themeData.helpText, fontSize: 16),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void initPageInfo() {
    _pageInfo = [
      OnboardingPage(
        lottieFilePath: 'assets/lottie/working-online.json',
        title: 'Work Online',
        description:
            'Nemo aut corporis et dolor recusandae aut. Voluptate sit error et dolorem et rem esse numquam. Et nulla libero est ut tempora modi.',
        animationController: AnimationController(vsync: this),
      ),
      OnboardingPage(
        lottieFilePath: 'assets/lottie/working-together.json',
        title: 'Collaborate',
        description:
            'Nemo aut corporis et dolor recusandae aut. Voluptate sit error et dolorem et rem esse numquam. Et nulla libero est ut tempora modi..',
        animationController: AnimationController(vsync: this),
      ),
      OnboardingPage(
        lottieFilePath: 'assets/lottie/workplace.json',
        title: 'Discuss',
        description:
            'Nemo aut corporis et dolor recusandae aut. Voluptate sit error et dolorem et rem esse numquam. Et nulla libero est ut tempora modi..',
        animationController: AnimationController(vsync: this),
      ),
    ];
  }

  void disposePageControllers() {
    for (var page in _pageInfo) {
      page.animationController.dispose();
    }
  }
}
