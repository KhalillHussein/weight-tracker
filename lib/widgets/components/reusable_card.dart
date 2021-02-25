import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;
  final VoidCallback pressedFunction;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  const ReusableCard({
    @required this.backgroundColor,
    @required this.child,
    this.pressedFunction,
    this.margin,
    this.padding = const EdgeInsets.all(15.0),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pressedFunction,
      child: Container(
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: child,
      ),
    );
  }
}
