import 'package:bmi_calculator/models/calories.dart';
import 'package:bmi_calculator/providers/calories_chart.dart';
import 'package:bmi_calculator/providers/validation.dart';
import 'package:bmi_calculator/repositories/calories.dart';
import 'package:bmi_calculator/ui/widgets/basic_page.dart';
import 'package:bmi_calculator/ui/widgets/components/index.dart';
import 'package:bmi_calculator/ui/widgets/dialogs.dart';
import 'package:bmi_calculator/utils/constants.dart';
import 'package:bmi_calculator/utils/index.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class CalorieCounterScreen extends StatelessWidget {
  final Color barBackgroundColor = kInactiveCardColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BasicPage<CaloriesRepository>(
            body: Container(
              margin: const EdgeInsets.only(left: 25.0, right: 25.0, top: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 4, child: _Chart()),
                  Expanded(flex: 2, child: TodayCounter()),
                  Expanded(flex: 4, child: TodayStats()),
                ],
              ),
            ),
          ),
        ),
        BottomButton(
          onTap: () {
            _showForm(context);
          },
          buttonTitle: 'НОВАЯ ЗАПИСЬ',
        ),
      ],
    );
  }

  void _showForm(BuildContext context) {
    showBottomRoundDialog(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Container(
            width: 80.0,
            height: 5.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: kInactiveCardColor,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Consumer<ValidationProvider>(
              builder: (ctx, validate, _) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildTextField(
                        hintText: "",
                        labelText: "Название",
                        keyboardType: TextInputType.text,
                        onChanged: (name) => validate.changeName(name),
                        errorText: validate.name.error,
                        helperText: 'Название продукта в любом формате'),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            hintText: "",
                            labelText: "Количество",
                            keyboardType: TextInputType.number,
                            onChanged: (count) => validate.changeCount(count),
                            errorText: validate.count.error,
                            helperText: 'Целое число 0 - 9999',
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildTextField(
                            hintText: "",
                            labelText: "Калории",
                            keyboardType: TextInputType.number,
                            onChanged: (cal) => validate.changeCal(cal),
                            errorText: validate.cal.error,
                            helperText: 'Калорий в единице',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Consumer<CaloriesRepository>(
                      builder: (ctx, calories, _) => BottomButton(
                        onTap: validate.isValid
                            ? () {
                                calories.addData(
                                  toMap(
                                    name: validate.name.value,
                                    count: int.parse(validate.count.value),
                                    cal: double.parse(validate.cal.value),
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            : null,
                        buttonTitle: 'ДОБАВИТЬ',
                      ),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> toMap(
      {@required String name, @required int count, @required double cal}) {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    return <String, dynamic>{
      'id': timestamp,
      'name': name,
      'count': count,
      'calories': cal * count,
      'date': timestamp,
    };
  }

  Widget _buildTextField({
    String hintText,
    String labelText,
    ValueChanged onChanged,
    TextInputType keyboardType,
    String errorText,
    String helperText,
  }) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        fillColor: kInactiveCardColor,
        filled: true,
        errorText: errorText,
        helperText: helperText,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kActiveCardColor, width: 2),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: kActiveCardColor, width: 2),
        ),
      ),
      onChanged: (value) => onChanged(value),
    );
  }
}

/// Calorie counter for the day
class TodayCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      margin: EdgeInsets.only(bottom: 15),
      backgroundColor: kActiveCardColor,
      child: Row(children: [
        Expanded(
          child: FittedBox(
            child: Icon(
              Icons.fastfood_outlined,
              size: 50,
              color: Colors.white.withAlpha(200),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 10,
                child: FittedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Consumer<CaloriesRepository>(
                        builder: (ctx, cal, _) => Text(
                          cal.summary().toStringAsFixed(1),
                          style: kNumberTextStyle,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        "cal",
                        style: kNumberTextStyle,
                        textScaleFactor: 0.4,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: FittedBox(
                  child: Text(
                    "сегодня",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

/// Food stats for the day
class TodayStats extends StatelessWidget {
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
                      SizedBox(width: 20),
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
                      Spacer(flex: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            calories[index].calories.toStringAsFixed(1),
                            style: kNumberTextStyle,
                            textScaleFactor: 0.7,
                          ),
                          SizedBox(width: 3),
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

class _Chart extends StatelessWidget {
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
        touchCallback: (barTouchResponse) {
          chart.setTouchedIndex(barTouchResponse);
        },
        touchTooltipData: BarTouchTooltipData(
            fitInsideVertically: true,
            tooltipBgColor: kActiveCardColor,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                (rod.y - 1).toString(),
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
          y: isTouched ? y + 1 : y,
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
