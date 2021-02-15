import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final List<Color> gradientColors;
  final String label;
  final Function onPress;
  final bool loading;

  const GradientButton({
    @required this.gradientColors,
    @required this.label,
    @required this.onPress,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 8,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              if (loading) ...[
                SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
