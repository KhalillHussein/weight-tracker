import 'package:bmi_calculator/widgets/horizontal_numberpicker_wrapper.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../utils/index.dart';
import '../widgets/components/index.dart';

class PlannerScreen extends StatefulWidget {
  @override
  _PlannerScreenState createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 16,
                  child: ReusableCard(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    backgroundColor: kActiveCardColor,
                    child: _buildTableCalendar(),
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 5,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: HorizontalNumberPickerWrapper(
                      titleTextColor: Colors.white,
                      indicatorColor: kAccentColor,
                      initialValue: 60,
                      minValue: 20,
                      maxValue: 260,
                      step: 1,
                      unit: 'кг',
                      widgetWidth: MediaQuery.of(context).size.width.round(),
                      subGridCountPerGrid: 6,
                      subGridWidth: 20,
                      onSelectedChanged: (value) {
                        print(value);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        BottomButton(onTap: () {}, buttonTitle: 'ЗАПЛАНИРОВАТЬ')
      ],
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      locale: 'ru_RU',
      calendarController: _calendarController,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: const CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: kCalendarTextStyle,
        holidayStyle: kCalendarTextStyle,
        outsideStyle: kCalendarTextStyle,
        weekdayStyle: kCalendarTextStyle,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: kCalendarDaysOfWeeksTextStyle,
        weekendStyle: kCalendarDaysOfWeeksTextStyle,
        dowTextBuilder: (date, locale) =>
            toBeginningOfSentenceCase(DateFormat.E(locale).format(date)),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
        titleTextStyle: kInactiveLabelTextStyle,
        titleTextBuilder: (date, locale) =>
            toBeginningOfSentenceCase(DateFormat.yMMMM(locale).format(date)),
        leftChevronIcon: Icon(
          MdiIcons.chevronLeft,
          size: 30,
          color: kInactiveLabelTextStyle.color,
        ),
        rightChevronIcon: Icon(
          MdiIcons.chevronRight,
          size: 30,
          color: kInactiveLabelTextStyle.color,
        ),
      ),
      builders: CalendarBuilders(
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            decoration: const BoxDecoration(
              color: kInactiveCardColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: kCalendarTextStyle.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
        selectedDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            decoration: const BoxDecoration(
              color: kAccentColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: kCalendarTextStyle.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
