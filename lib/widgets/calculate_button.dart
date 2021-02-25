import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/index.dart';
import '../screens/index.dart';
import '../widgets/components/index.dart';

class CalculateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<InputProvider>(
      builder: (ctx, calcData, _) => BottomButton(
        buttonTitle: 'РАССЧИТАТЬ ИМТ',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultsScreen(),
            ),
          );
        },
      ),
    );
  }
}
