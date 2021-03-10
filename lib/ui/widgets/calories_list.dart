import 'package:bmi_calculator/models/calories.dart';
import 'package:bmi_calculator/repositories/calories.dart';
import 'package:bmi_calculator/ui/widgets/components/index.dart';
import 'package:bmi_calculator/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

/// Food stats for the day
class CaloriesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            kPrimaryColor.withOpacity(0.9),
            Colors.transparent,
            Colors.transparent,
            kPrimaryColor,
          ],
          stops: const [0.0, 0.02, 0.8, 1.0],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Consumer<CaloriesRepository>(builder: (ctx, cal, _) {
        final List<Calories> calories = cal.parameters.reversed.toList();
        return ListView.builder(
          shrinkWrap: true,
          itemCount: calories.length,
          itemBuilder: (ctx, index) => Dismissible(
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => cal.deleteData(calories[index].id),
            key: Key(calories[index].id.toString()),
            background: slideLeftBackground(),
            child: ReusableCard(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            DateFormat('dd').format(calories[index].date),
                            style: kInactiveLabelTextStyle.copyWith(
                                fontWeight: FontWeight.bold),
                            textScaleFactor: 1.5,
                          ),
                          Text(
                            DateFormat('MMM', 'Ru')
                                .format(calories[index].date)
                                .toUpperCase(),
                            style: kInactiveLabelTextStyle,
                            textScaleFactor: 0.6,
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            calories[index].name,
                            style: kNumberTextStyle.copyWith(
                                fontWeight: FontWeight.w700),
                            textScaleFactor: 0.47,
                          ),
                          SizedBox(height: 6),
                          Text(
                            'x${calories[index].count}',
                            style: kInactiveLabelTextStyle.copyWith(
                                fontWeight: FontWeight.w600),
                            textScaleFactor: 0.8,
                          ),
                        ],
                      ),
                      const Spacer(flex: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            calories[index].calories.toStringAsFixed(0),
                            style: kNumberTextStyle,
                            textScaleFactor: 0.7,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'cal',
                            style: kNumberTextStyle,
                            textScaleFactor: 0.35,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Color(0xFF080b1c),
      margin: const EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            MdiIcons.deleteSweep,
            color: Colors.white.withOpacity(0.9),
            size: 30,
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
