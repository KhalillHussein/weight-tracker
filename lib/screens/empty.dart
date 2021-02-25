import 'package:bmi_calculator/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EmptyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            MdiIcons.pulse,
            color: kInactiveCardColor,
            size: 200,
          ),
          Text('Нет данных', style: kBodyTextStyle),
        ],
      ),
    );
  }
}
