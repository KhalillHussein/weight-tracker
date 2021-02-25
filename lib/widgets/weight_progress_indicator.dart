import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../providers/index.dart';
import '../utils/index.dart';

class WeightProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<OverviewProvider>(
      builder: (ctx, overview, _) => Column(
        children: [
          Expanded(
            flex: 36,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildLimits(
                    weight: overview.firstItem.weight.toStringAsFixed(1),
                    date: DateFormat('d MMM yyy', 'RU')
                        .format(overview.firstItem.date),
                    // '17 Апреля 2018',
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 4,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: _buildCurrentWeight(
                        currentWeight:
                            overview.lastItem.weight.toStringAsFixed(1)),
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 2,
                  child: _buildLimits(
                    weight: overview.lastItem.idealWeight.toStringAsFixed(1),
                    date: DateFormat('d MMM yyy', 'RU')
                        .format(overview.lastItem.date),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StepProgressIndicator(
              totalSteps: max(
                  (overview.lastItem.idealWeight.round() -
                          overview.firstItem.weight.round())
                      .abs(),
                  1),
              currentStep: overview.progressValue(),
              size: 3.0,
              padding: 0,
              selectedColor: kAccentColor,
              roundedEdges: Radius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLimits({String weight, String date}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          fit: BoxFit.fitHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(
                weight,
                style: TextStyle(
                    fontSize: 25,
                    color: kInactiveLabelTextStyle.color,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
                textScaleFactor: 1.6,
              ),
              Text(
                ' кг',
                style: kInactiveLabelTextStyle.copyWith(fontSize: 12),
                textScaleFactor: 1.6,
              ),
            ],
          ),
        ),
        FittedBox(
          fit: BoxFit.fitHeight,
          child: Text(
            date,
            style:
                TextStyle(fontSize: 15, color: kInactiveLabelTextStyle.color),
            maxLines: 1,
            textScaleFactor: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentWeight({String currentWeight}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: [
        Text(
          currentWeight,
          style: kNumberTextStyle,
          maxLines: 1,
          textScaleFactor: 2.2,
        ),
        const Text(
          'кг',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          textScaleFactor: 2.2,
        ),
      ],
    );
  }
}
