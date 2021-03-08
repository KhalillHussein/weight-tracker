import 'package:flutter/material.dart';

import '../../../utils/index.dart';

class BottomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonTitle;
  final Icon icon;

  const BottomButton({
    @required this.onTap,
    @required this.buttonTitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: kAccentColor,
        width: double.infinity,
        height: kBottomContainerHeight,
        margin: const EdgeInsets.only(top: 10.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) icon,
              Text(
                buttonTitle,
                style: kLargeButtonTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
