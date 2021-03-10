import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../providers/index.dart';
import '../../utils/index.dart';

class CaloriesChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
      child: Consumer<CaloriesChartProvider>(
        builder: (ctx, chart, _) => BarChart(
          _mainBarData(chart),
        ),
      ),
    );
  }

  BarChartData _mainBarData(CaloriesChartProvider chart) {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: true,
        touchCallback: (barTouchResponse) =>
            chart.setTouchedIndex(barTouchResponse),
        touchTooltipData: BarTouchTooltipData(
            fitInsideVertically: true,
            tooltipBgColor: kActiveCardColor,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                (rod.y - 1).toStringAsFixed(0) + 'cal',
                kInactiveLabelTextStyle.copyWith(fontSize: 14),
              );
            }),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: getBottomTitles(chart),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: [
        for (int i = 0; i < chart.groupedValues.length; i++)
          makeGroupData(
            i,
            chart.groupedValues[i]['amount'],
            isTouched: i == chart.touchedIndex,
            maxY: chart.totalCal,
          ),
      ],
    );
  }

  SideTitles getBottomTitles(CaloriesChartProvider chart) => SideTitles(
      showTitles: true,
      getTextStyles: (value) => TextStyle(
            color: kChartLabelTextStyle.color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
      margin: 7,
      getTitles: (value) => chart.groupedValues[value.toInt()]['day']);

  BarChartGroupData makeGroupData(int x, double y,
      {bool isTouched = false, double maxY}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 50 : y,
          colors: y <= 500
              ? [Color(0xFFFCB396)]
              : y <= 1000
                  ? [Color(0xFFEF676A)]
                  : [Color(0xFFD20145)],
          width: 21,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: maxY,
            colors: [kInactiveCardColor],
          ),
        ),
      ],
    );
  }
}
