import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart';
import '../../utils/index.dart';
import '../widgets/components/index.dart';

class GenderCard extends StatelessWidget {
  final double angle;
  final IconData icon;
  final Gender gender;
  final String label;

  const GenderCard({
    this.angle,
    @required this.icon,
    @required this.gender,
    @required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<InputProvider>(
      builder: (ctx, calcData, _) => ReusableCard(
        margin: const EdgeInsets.all(3.0),
        padding: const EdgeInsets.only(top: 6.0, bottom: 15.0),
        backgroundColor: kActiveCardColor,
        pressedFunction: () => calcData.setGender(gender),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 14,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Transform.rotate(
                  angle: pi * angle,
                  child: Icon(
                    icon,
                    size: 100.0,
                    color: calcData.gender == gender
                        ? Colors.white
                        : Color(0xFF8D8E98),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Expanded(
              flex: 3,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: calcData.gender == gender
                      ? kActiveLabelTextStyle
                      : kInactiveLabelTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
