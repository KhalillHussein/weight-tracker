import 'package:bmi_calculator/providers/validation.dart';
import 'package:bmi_calculator/repositories/calories.dart';
import 'package:bmi_calculator/ui/widgets/basic_page.dart';
import 'package:bmi_calculator/ui/widgets/components/index.dart';
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
    showModalBottomSheet(
      context: context,
      backgroundColor: kPrimaryColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10.0),
          topRight: const Radius.circular(10.0),
        ),
      ),
      builder: (context) => Container(
        margin: MediaQuery.of(context).viewInsets,
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
                      ),
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
      'calories': cal,
      'date': timestamp,
    };
  }

  Widget _buildTextField({
    String hintText,
    String labelText,
    ValueChanged onChanged,
    TextInputType keyboardType,
    String errorText,
  }) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        fillColor: kInactiveCardColor,
        filled: true,
        errorText: errorText,
        helperText: '',
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
                    children: [
                      Consumer<CaloriesRepository>(
                        builder: (ctx, cal, _) => Text(
                          cal.summary().toStringAsFixed(1),
                          style: kNumberTextStyle,
                        ),
                      ),
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
          stops: const [
            0.0,
            0.02,
            0.8,
            1.0
          ], // 10% purple, 80% transparent, 10% purple
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Consumer<CaloriesRepository>(
        builder: (ctx, cal, _) => ListView.builder(
          shrinkWrap: true,
          itemCount: cal.parameters.length,
          itemBuilder: (ctx, index) => ReusableCard(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Dismissible(
              direction: DismissDirection.endToStart,
              onDismissed: (direction) =>
                  cal.deleteData(cal.parameters[index].id),
              key: Key(cal.parameters[index].id.toString()),
              background: slideLeftBackground(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            DateFormat('dd').format(cal.parameters[index].date),
                            style: kInactiveLabelTextStyle.copyWith(
                                fontWeight: FontWeight.bold),
                            textScaleFactor: 1.6,
                          ),
                          Text(
                            DateFormat('MMM', 'Ru')
                                .format(cal.parameters[index].date)
                                .toUpperCase(),
                            style: kInactiveLabelTextStyle,
                            textScaleFactor: 0.65,
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cal.parameters[index].name,
                            style: kNumberTextStyle.copyWith(
                                fontWeight: FontWeight.w700),
                            textScaleFactor: 0.47,
                          ),
                          SizedBox(height: 6),
                          Text(
                            'x${cal.parameters[index].count}',
                            style: kInactiveLabelTextStyle.copyWith(
                                fontWeight: FontWeight.w400),
                            textScaleFactor: 0.96,
                          ),
                        ],
                      ),
                      Spacer(flex: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Text(
                            cal.parameters[index].calories.toStringAsFixed(1),
                            style: kNumberTextStyle,
                            textScaleFactor: 0.8,
                          ),
                          SizedBox(width: 2),
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
        ),
      ),
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

class _Chart extends StatefulWidget {
  @override
  __ChartState createState() => __ChartState();
}

class __ChartState extends State<_Chart> {
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
      child: BarChart(
        _mainBarData(),
      ),
    );
  }

  BarChartData _mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: kActiveCardColor,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String weekDay;
                switch (group.x.toInt()) {
                  case 0:
                    weekDay = 'Понедельник';
                    break;
                  case 1:
                    weekDay = 'Вторник';
                    break;
                  case 2:
                    weekDay = 'Среда';
                    break;
                  case 3:
                    weekDay = 'Четверг';
                    break;
                  case 4:
                    weekDay = 'Пятница';
                    break;
                  case 5:
                    weekDay = 'Суббота';
                    break;
                  case 6:
                    weekDay = 'Воскресенье';
                    break;
                }
                return BarTooltipItem(
                    weekDay + '\n' + (rod.y - 1).toString(),
                    TextStyle(
                        color: kAccentColor, fontWeight: FontWeight.bold));
              }),
          touchCallback: (barTouchResponse) {
            setState(() {
              if (barTouchResponse.spot != null &&
                  barTouchResponse.touchInput is! FlPanEnd &&
                  barTouchResponse.touchInput is! FlLongPressEnd) {
                touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
              } else {
                touchedIndex = -1;
              }
            });
          }),
      titlesData: _titlesData(),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  FlTitlesData _titlesData() {
    return FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        getTextStyles: (value) => TextStyle(
          color: kChartLabelTextStyle.color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        margin: 7,
        getTitles: (double value) {
          switch (value.toInt()) {
            case 0:
              return 'Пн';
            case 1:
              return 'Вт';
            case 2:
              return 'Ср';
            case 3:
              return 'Чт';
            case 4:
              return 'Пт';
            case 5:
              return 'Сб';
            case 6:
              return 'Вс';
            default:
              return '';
          }
        },
      ),
      leftTitles: SideTitles(
        showTitles: false,
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = kAccentColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: y <= 5
              ? [Color(0xFFFCB396)]
              : y < 10
                  ? [Color(0xFFEF676A)]
                  : [Color(0xFFD20145)],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 20,
            colors: [kInactiveCardColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 5, isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, 6.5, isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, 5, isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, 7.5, isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, 9, isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, 11.5, isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, 6.5, isTouched: i == touchedIndex);
          default:
            return null;
        }
      });
}
