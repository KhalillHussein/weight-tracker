import 'package:bmi_calculator/providers/chips.dart';
import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:provider/provider.dart';

import '../utils/index.dart';

class ChipsSelector extends StatelessWidget {
  final List<String> options = ['Все', '30 дней', '60 дней', '90 дней', 'год'];

  @override
  Widget build(BuildContext context) {
    return Consumer<ChipsProvider>(
      builder: (ctx, chips, _) => Transform(
        transform: Matrix4.identity()..scale(0.8),
        child: ChipsChoice<int>.single(
          scrollPhysics: NeverScrollableScrollPhysics(),
          mainAxisSize: MainAxisSize.min,
          clipBehavior: Clip.none,
          value: chips.currentIndex,
          onChanged: (val) => chips.currentIndex = val,
          choiceStyle: C2ChoiceStyle(showCheckmark: false, borderWidth: 2.0),
          choiceActiveStyle: C2ChoiceStyle(color: kAccentColor),
          choiceItems: C2Choice.listFrom<int, String>(
            source: options,
            value: (i, v) => i,
            label: (i, v) => v,
          ),
        ),
      ),
    );
  }
}
