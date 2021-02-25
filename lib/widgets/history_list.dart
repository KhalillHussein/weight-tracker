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
            padding: const EdgeInsets.all(25.0),
            backgroundColor: kInactiveCardColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCreatedAt(historyList, index),
                const Spacer(),
                _buildCurrentWeight(historyList, index),
                const Spacer(),
                _buildDifference(historyList, index, overview),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCreatedAt(List<Parameters> historyList, int index) {
    return Expanded(
      flex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              DateFormat('d MMM yyyy г.', 'RU').format(historyList[index].date),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: kInactiveLabelTextStyle.color,
              ),
              maxLines: 1,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              DateFormat('EEEE, h:mm ч', 'RU').format(historyList[index].date),
              style: TextStyle(
                fontSize: 15,
                color: kInactiveLabelTextStyle.color,
              ),
              textScaleFactor: 0.9,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWeight(List<Parameters> historyList, int index) {
    return Expanded(
      flex: 4,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Text(
              '${historyList[index].weight}',
              style: kNumberTextStyle,
              textScaleFactor: 0.7,
            ),
            const Text(
              ' кг',
              style: kNumberTextStyle,
              textScaleFactor: 0.3,
            )
          ],
        ),
      ),
    );
  }

  // Widget _buildDifference(List<Parameters> historyList, int index) {
  //   final weightDifference = index != historyList.length - 1
  //       ? (historyList[index].weight - historyList[index + 1].weight)
  //       : 0.0;
  //   return Expanded(
  //     flex: 3,
  //     child: FittedBox(
  //       fit: BoxFit.scaleDown,
  //       child: Row(
  //         children: [
  //           if (weightDifference != 0)
  //             Icon(
  //               weightDifference > 0
  //                   ? Icons.arrow_upward
  //                   : Icons.arrow_downward,
  //               color: weightDifference > 0
  //                   ? kObeseResultColor
  //                   : kNormalResultColor,
  //             ),
  //           if (weightDifference == 0)
  //             Text(
  //               '     ${weightDifference.abs().toStringAsFixed(1)} кг',
  //               style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.w400,
  //                   color: kInactiveLabelTextStyle.color),
  //             ),
  //           if (weightDifference != 0)
  //             Text(
  //               '${weightDifference.abs().toStringAsFixed(1)} кг',
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.w400,
  //                 color: weightDifference > 0
  //                     ? kObeseResultColor
  //                     : kNormalResultColor,
  //               ),
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildDifference(
      List<Parameters> historyList, int index, OverviewProvider overview) {
    final weightDifference = index != historyList.length - 1
        ? (historyList[index].weight - historyList[index + 1].weight)
        : 0.0;
    return Expanded(
      flex: 3,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          children: [
            if (weightDifference != 0)
              Icon(
                overview.isLoseWeight
                    ? weightDifference > 0
                        ? Icons.arrow_upward
                        : Icons.arrow_downward
                    : weightDifference < 0
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                color: overview.isLoseWeight
                    ? weightDifference > 0
                        ? kObeseResultColor
                        : kNormalResultColor
                    : weightDifference < 0
                        ? kObeseResultColor
                        : kNormalResultColor,
              ),
            if (weightDifference == 0)
              Text(
                '     ${weightDifference.abs().toStringAsFixed(1)} кг',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: kInactiveLabelTextStyle.color),
              ),
            if (weightDifference != 0)
              Text(
                '${weightDifference.abs().toStringAsFixed(1)} кг',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
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
        ),
      ),
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
          SizedBox(
            width: 20,
          )
        ],
      ),
    );
  }
}
