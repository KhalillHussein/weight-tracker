import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../models/index.dart';
import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../utils/index.dart';
import '../widgets/components/index.dart';

class HistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final unit =
        context.watch<RadioProvider>().getMeasureWeightInterpretation()['abbr'];
    return Consumer<OverviewRepository>(builder: (ctx, overview, _) {
      final List<Parameters> historyList =
          overview.parameters.reversed.toList();
      if (historyList.isEmpty) {
        Navigator.pop(context);
      }
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: historyList.length,
          itemBuilder: (ctx, index) => Dismissible(
            direction: DismissDirection.endToStart,
            onDismissed: (direction) =>
                overview.deleteData(historyList[index].id),
            key: Key(historyList[index].id.toString()),
            background: slideLeftBackground(),
            child: ReusableCard(
              backgroundColor: kActiveCardColor,
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('d MMMM yyyy, h:mm', 'RU')
                            .format(historyList[index].date),
                        style: kActiveLabelTextStyle.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w700),
                        textScaleFactor: 0.9,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            historyList[index].weight.toStringAsFixed(1),
                            style: kNumberTextStyle,
                            textScaleFactor: 0.8,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            unit,
                            style: kNumberTextStyle.copyWith(
                                fontWeight: FontWeight.w500),
                            textScaleFactor: 0.4,
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildSubtitle(historyList, index),
                      _buildDifference(unit, historyList, index, overview),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSubtitle(List<Parameters> historyList, int index) {
    return Column(
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ИМТ',
                  style: kInactiveLabelTextStyle.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  textScaleFactor: 0.7,
                ),
                const SizedBox(height: 4),
                Text(
                  historyList[index].bmi.toStringAsFixed(1),
                  style: kActiveLabelTextStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textScaleFactor: 0.9,
                ),
              ],
            ),
            const SizedBox(width: 55),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Телесный жир',
                  style: kInactiveLabelTextStyle.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  textScaleFactor: 0.7,
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      historyList[index].fatPercent.toStringAsFixed(1),
                      style: kActiveLabelTextStyle.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      textScaleFactor: 0.9,
                    ),
                    Text(
                      '%',
                      style: kActiveLabelTextStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      textScaleFactor: 0.8,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDifference(String unit, List<Parameters> historyList, int index,
      OverviewRepository overview) {
    final weightDifference = index != historyList.length - 1
        ? (historyList[index].weight - historyList[index + 1].weight)
        : 0.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (weightDifference != 0)
          Icon(
            overview.isLoseWeight
                ? weightDifference > 0
                    ? Icons.trending_up
                    : Icons.trending_down
                : weightDifference < 0
                    ? Icons.trending_down
                    : Icons.trending_up,
            color: overview.isLoseWeight
                ? weightDifference > 0
                    ? kObeseResultColor
                    : kNormalResultColor
                : weightDifference < 0
                    ? kObeseResultColor
                    : kNormalResultColor,
          ),
        const SizedBox(width: 4),
        if (weightDifference == 0)
          Text(
            '${weightDifference.abs().toStringAsFixed(1)} $unit',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: kInactiveLabelTextStyle.color),
          ),
        if (weightDifference != 0)
          Text(
            '${weightDifference.abs().toStringAsFixed(1)} $unit',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: overview.isLoseWeight
                  ? weightDifference > 0
                      ? kObeseResultColor
                      : kNormalResultColor
                  : weightDifference < 0
                      ? kObeseResultColor
                      : kNormalResultColor,
            ),
          ),
      ],
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
