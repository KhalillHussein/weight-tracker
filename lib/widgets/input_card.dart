import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../utils/index.dart';
import '../widgets/components/index.dart';

class InputCard extends StatelessWidget {
  final String label;

  final int value;

  final VoidCallback incFunction;

  final VoidCallback decFunction;

  const InputCard({
    this.label,
    this.value,
    this.incFunction,
    this.decFunction,
  });

  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      margin: const EdgeInsets.all(3.0),
      backgroundColor: kInactiveCardColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: kInactiveLabelTextStyle,
              ),
            ),
          ),
          //Spacer(),
          Expanded(
            flex: 6,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(
                '$value',
                style: kNumberTextStyle,
              ),
            ),
          ),
          Spacer(),
          Expanded(
            flex: 7,
            child: FittedBox(
              child: Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RoundIconButton(
                    icon: MdiIcons.minus,
                    onPressed: decFunction,
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  RoundIconButton(
                    icon: MdiIcons.plus,
                    onPressed: incFunction,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
