import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../providers/index.dart';

import '../../repositories/index.dart';
import '../../utils/index.dart';

class ChartWidget extends StatelessWidget {
  final List<Color> _gradientColors = [
    kAccentColor.withOpacity(0.6),
    kAccentColor.withOpacity(0.1),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer3<OverviewRepository, ChipsProvider, RadioProvider>(
      builder: (ctx, statData, chips, radio, _) {
        final series = Series(
          data: statData.parameters,
          period: chips.period,
          type: radio.currentGraphType,
        );
        return LineChart(
          _mainData(context, series, radio.currentGraphType),
        );
      },
    );
  }

  LineChartData _mainData(BuildContext context, Series series, GraphType type) {
    final unit = context
        .watch<RadioProvider>()
        .getGraphTypeInterpretation()['units']['abbr'];
    return LineChartData(
      clipData: FlClipData.vertical(),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
            fitInsideVertically: true,
            tooltipBgColor: kInactiveCardColor,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return [
                for (int i = 0; i < touchedBarSpots.length; i++)
                  LineTooltipItem(
                    '${touchedBarSpots[i].y.toStringAsFixed(1)} $unit',
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: touchedBarSpots[i].bar.colors.first,
                    ),
                  ),
              ];
            }),
      ),
      gridData: _gridData(series),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: _bottomTitles(series),
        leftTitles: _leftTitles(series),
        rightTitles: SideTitles(),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
            color: kChartGridColor,
            width: 0.5,
          ),
        ),
      ),
      minX: series.minX,
      maxX: series.maxX,
      minY: series.minY,
      maxY: series.maxY,
      lineBarsData: _charts(context, series, type),
    );
  }

  List<LineChartBarData> _charts(
      BuildContext context, Series series, GraphType type) {
    switch (type) {
      case GraphType.weight:
        return [
          _lineBarIdealWeight(series, context),
          _lineBarAvgWeight(series, context),
          _lineBarData(series, context),
        ];
        break;
      case GraphType.bmi:
        return [
          _lineBarUWBMI(series, context),
          _lineBarNormalBMI(series, context),
          _lineBarOverweightBMI(series, context),
          _lineBarObeseBMI(series, context),
          _lineBarData(series, context),
        ];
        break;
      case GraphType.fatPercent:
        return [
          _lineBarData(series, context),
        ];
      default:
        return [
          _lineBarData(series, context),
        ];
    }
  }

  FlGridData _gridData(Series series) {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: kChartGridColor,
          strokeWidth: 1,
          dashArray: [2, 4],
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: kChartGridColor,
          strokeWidth: 1,
        );
      },
      horizontalInterval: 1,
      checkToShowHorizontalLine: (value) {
        return (value - series.minY) % series.leftTitlesInterval == 0;
      },
    );
  }

  SideTitles _bottomTitles(Series series) {
    return SideTitles(
      showTitles: true,
      reservedSize: 0.0,
      getTextStyles: (value) => kChartLabelTextStyle,
      getTitles: (value) {
        final DateTime date =
            DateTime.fromMillisecondsSinceEpoch(value.toInt());
        return DateFormat('dd.MM').format(date);
      },
      margin: 10.0,
      interval: series.bottomTitlesInterval,
    );
  }

  SideTitles _leftTitles(Series series) {
    return SideTitles(
      showTitles: true,
      getTextStyles: (value) => kChartLabelTextStyle,
      interval: series.leftTitlesInterval,
      reservedSize: 10.0,
      margin: 10.0,
    );
  }

  LineChartBarData _lineBarData(Series series, BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return LineChartBarData(
      spots: series.chartType(),
      isCurved: false,
      colors: [kAccentColor],
      barWidth: height * 0.004,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: height * 0.002,
          color: kPrimaryColor,
          strokeWidth: height * 0.003,
          strokeColor: kAccentColor,
        ),
      ),
      belowBarData: BarAreaData(
        show: true,
        colors: _gradientColors,
        gradientColorStops: [0, 1.0],
        gradientFrom: const Offset(0, 0),
        gradientTo: const Offset(0, 1),
      ),
    );
  }

  LineChartBarData _lineBarIdealWeight(Series series, BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return LineChartBarData(
      dashArray: [2, 4],
      spots: series.spotsIdealWeight,
      isCurved: false,
      colors: [kNormalResultColor],
      barWidth: height * 0.002,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  LineChartBarData _lineBarAvgWeight(Series series, BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return LineChartBarData(
      dashArray: [2, 4],
      spots: series.spotsAvgWeight,
      isCurved: false,
      colors: [kUWResultColor],
      barWidth: height * 0.002,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  LineChartBarData _lineBarUWBMI(Series series, BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return LineChartBarData(
      dashArray: [2, 4],
      spots: series.spotsUWBMI,
      isCurved: false,
      colors: [kUWResultColor],
      barWidth: height * 0.002,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  LineChartBarData _lineBarNormalBMI(Series series, BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return LineChartBarData(
      dashArray: [2, 4],
      spots: series.spotsNormalBMI,
      isCurved: false,
      colors: [kNormalResultColor],
      barWidth: height * 0.002,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  LineChartBarData _lineBarOverweightBMI(Series series, BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return LineChartBarData(
      dashArray: [2, 4],
      spots: series.spotsOverweightBMI,
      isCurved: false,
      colors: [kOverweightResultColor],
      barWidth: height * 0.002,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  LineChartBarData _lineBarObeseBMI(Series series, BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return LineChartBarData(
      dashArray: [2, 4],
      spots: series.spotsObeseBMI,
      isCurved: false,
      colors: [kObeseResultColor],
      barWidth: height * 0.002,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }
}
