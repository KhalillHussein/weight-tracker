import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../providers/index.dart';
import '../repositories/index.dart';
import '../utils/index.dart';

class BmiStatusIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<OverviewProvider>(
      builder: (ctx, statisticsData, _) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 12, child: FittedBox(child: _buildTopText(statisticsData))),
          const Spacer(),
          Expanded(flex: 8, child: _buildIndicator(statisticsData)),
          const Spacer(),
          Expanded(flex: 4, child: _buildDivValues()),
        ],
      ),
    );
  }

  Widget _buildTopText(OverviewProvider statisticsData) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: [
        Text(
          statisticsData.lastItem.bmi.toStringAsFixed(1),
          style: kNumberTextStyle,
          textScaleFactor: 1.2,
        ),
        const SizedBox(width: 10),
        Text(
          Status.status.getBmiStatus(statisticsData.lastItem.bmi),
          style: TextStyle(
            color: Status.status.resultBmiTextColor(
                Status.status.getBmiStatus(statisticsData.lastItem.bmi)),
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.3,
          ),
          textScaleFactor: 1.2,
        ),
      ],
    );
  }

  Widget _buildIndicator(OverviewProvider statisticsData) {
    return StepProgressIndicator(
      totalSteps: 50,
      customColor: (index) {
        if (index < 8) //15-18.5
        {
          return kUWResultColor;
        } else if (index >= 8 && index < 20) //18.5-25
        {
          return kNormalResultColor;
        } else if (index >= 20 && index < 30) //25-30
        {
          return kOverweightResultColor;
        } else if (index >= 30 && index < 40) //30-35
        {
          return kObese1ResultColor;
        } else if (index >= 40 && index <= 50) //35-40
        {
          return kObeseResultColor;
        }
        return kUWResultColor;
      },
      customSize: (index, _) {
        var value = (statisticsData.lastItem.bmi.round() - 15) * 2;
        if (value < 0) {
          value = 0;
        }
        if (value > 49) {
          value = 49;
        }
        if (index == value) {
          return 50;
        } else {
          return 20;
        }
      },
    );
  }

  Widget _buildDivValues() {
    return Row(
      children: const [
        Expanded(
            child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '15',
            style: kChartLabelTextStyle,
            textScaleFactor: 1.5,
            maxLines: 1,
          ),
        )),
        Spacer(flex: 2),
        Expanded(
            flex: 3,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '18.5',
                style: kChartLabelTextStyle,
                textScaleFactor: 1.5,
                maxLines: 1,
              ),
            )),
        Spacer(flex: 4),
        Expanded(
            child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '25',
            style: kChartLabelTextStyle,
            textScaleFactor: 1.5,
            maxLines: 1,
          ),
        )),
        Spacer(flex: 4),
        Expanded(
            child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '30',
            style: kChartLabelTextStyle,
            textScaleFactor: 1.5,
            maxLines: 1,
          ),
        )),
        Spacer(flex: 4),
        Expanded(
            child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '35',
            style: kChartLabelTextStyle,
            textScaleFactor: 1.5,
            maxLines: 1,
          ),
        )),
        Spacer(flex: 4),
        Expanded(
            child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '40',
            style: kChartLabelTextStyle,
            textScaleFactor: 1.5,
            maxLines: 1,
          ),
        )),
      ],
    );
  }
}
