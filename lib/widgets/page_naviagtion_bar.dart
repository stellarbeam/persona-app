import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/theme_bloc/theme_bloc.dart';

class PageNavigationBar extends StatelessWidget {
  final int length;
  final int currentIndex;
  final PageController pageController;
  final Function onDone;

  const PageNavigationBar(
    this.length,
    this.currentIndex,
    this.pageController,
    this.onDone,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                print("Skip");
                onDone();
              },
              child: Container(
                width: 70,
                child: Text(
                  'Skip',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: state.themeData.helpText),
                ),
              ),
            ),
            AbsorbPointer(child: _buildIndexDots()),
            currentIndex == length - 1
                ? GestureDetector(
                    onTap: () {
                      print("Done");
                      onDone();
                    },
                    child: Container(
                      width: 70,
                      child: Text(
                        'Done',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: state.themeData.helpText),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                      print("Next");
                    },
                    child: Container(
                      width: 70,
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: state.themeData.helpText,
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }

  Row _buildIndexDots() {
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
            color: isSelected ? Colors.white : Colors.grey,
          ),
          duration: Duration(milliseconds: 300),
          width: isSelected ? 2 * size : size,
          height: size,
        );
      }),
    );
  }
}
