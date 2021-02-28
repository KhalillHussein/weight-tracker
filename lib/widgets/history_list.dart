import 'package:bmi_calculator/repositories/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../models/parameters.dart';
import '../providers/index.dart';
import '../utils/index.dart';
import '../widgets/components/index.dart';

class HistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<OverviewProvider>(builder: (ctx, overview, _) {
      final List<Parameters> historyList =
          overview.parameters.reversed.toList();
      if (historyList.isEmpty) {
        Navigator.pop(context);
      }
      return ListView.builder(
        shrinkWrap: true,
        itemCount: historyList.length,
        itemBuilder: (ctx, index) => Dismissible(
          direction: DismissDirection.endToStart,
          onDismissed: (direction) => overview
              .removeFromList(historyList[index].date.millisecondsSinceEpoch),
          key: Key(historyList[index].date.millisecondsSinceEpoch.toString()),
          background: slideLeftBackground(),
          child: ReusableCard(
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: Column(
              children: [
                _buildTop(historyList, index),
                _buildBottom(historyList, index, overview),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTop(List<Parameters> historyList, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('dd-MM-yyyy h:mm', 'RU').format(historyList[index].date),
          style: kActiveLabelTextStyle.copyWith(
              color: Colors.white.withOpacity(0.9)),
          textScaleFactor: 0.9,
        ),
        _buildCurrentWeight(historyList, index),
      ],
    );
  }

  Widget _buildBottom(
      List<Parameters> historyList, int index, OverviewProvider overview) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildSubtitle(historyList, index),
        _buildDifference(historyList, index, overview),
      ],
    );
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

  Widget _buildCurrentWeight(List<Parameters> historyList, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: [
        Text(
          historyList[index].weight.toStringAsFixed(1),
          style: kNumberTextStyle,
          textScaleFactor: 0.8,
        ),
        const SizedBox(width: 2),
        Text(
          'кг',
          style: kNumberTextStyle.copyWith(fontWeight: FontWeight.w500),
          textScaleFactor: 0.4,
        )
      ],
    );
  }

  Widget _buildDifference(
      List<Parameters> historyList, int index, OverviewProvider overview) {
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
                    ? Icons.trending_down
                    : Icons.trending_up
                : weightDifference < 0
                    ? Icons.trending_up
                    : Icons.trending_down,
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
            '${weightDifference.abs().toStringAsFixed(1)} кг',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: kInactiveLabelTextStyle.color),
          ),
        if (weightDifference != 0)
          Text(
            '${weightDifference.abs().toStringAsFixed(1)} кг',
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
      margin: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 5.0),
      color: kObeseResultColor,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Icon(
            MdiIcons.deleteSweep,
            color: Colors.white,
            size: 30,
          ),
          SizedBox(width: 20)
        ],
      ),
    );
  }
}
