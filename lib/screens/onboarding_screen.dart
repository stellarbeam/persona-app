import 'package:flutter/material.dart';
import 'package:persona/models/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({Key key}) : super(key: key);

  static const routeName = '/onboard';

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<OnboardingPage> pageInfo = [
    OnboardingPage(
      imagePath:
          'assets/images/creativity-concept-illustration_114360-1083.jpg',
      title: 'Creativity',
      description:
          'Nemo aut corporis et dolor recusandae aut. Voluptate sit error et dolorem et rem esse numquam. Et nulla libero est ut tempora modi.',
    ),
    OnboardingPage(
      imagePath:
          'assets/images/startup-life-concept-illustration_114360-1068.jpg',
      title: 'Organization',
      description:
          'Nemo aut corporis et dolor recusandae aut. Voluptate sit error et dolorem et rem esse numquam. Et nulla libero est ut tempora modi..',
    ),
    OnboardingPage(
      imagePath:
          'assets/images/usability-testing-concept-illustration_114360-1571.jpg',
      title: 'Conversation',
      description:
          'Nemo aut corporis et dolor recusandae aut. Voluptate sit error et dolorem et rem esse numquam. Et nulla libero est ut tempora modi..',
    ),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
                print("Current index: $index");
                // pageInfo[index].animationController.forward();
              },
              physics: BouncingScrollPhysics(),
              children:
                  pageInfo.map((page) => _buildPage(context, page)).toList(),
            ),
            Positioned(
              bottom: 20,
              child: PageNavigation(pageInfo.length, _currentIndex),
              width: MediaQuery.of(context).size.width,
            ),
          ],
        ),
      ),
    );
  }

  Container _buildPage(BuildContext context, OnboardingPage page) {
    return Container(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.60,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Image.asset(
              page.imagePath,
              fit: BoxFit.fill,
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
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(page.description),
          )
        ],
      ),
    );
  }
}

class PageNavigation extends StatelessWidget {
  final int length;
  final int currentIndex;

  const PageNavigation(this.length, this.currentIndex);

  @override
  Widget build(BuildContext context) {
    const double size = 12;
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        bool isSelected = index == currentIndex;
        return AnimatedContainer(
          margin: EdgeInsets.all(size / 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size),
            color: isSelected ? Colors.red : Colors.grey,
          ),
          duration: Duration(milliseconds: 300),
          width: isSelected ? 2 * size : size,
          height: size,
        );
      }),
    );
  }
}
