import 'package:bmi_calculator/providers/calories_chart.dart';
import 'package:bmi_calculator/providers/validation.dart';
import 'package:bmi_calculator/repositories/calories.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:provider/provider.dart';

import 'providers/index.dart';
import 'repositories/index.dart';
import 'ui/pages/navigation.dart';
import 'utils/index.dart';

void main() {
  initializeDateFormatting();
  runApp(BMICalculator());
}

class BMICalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => RadioProvider()),
        ChangeNotifierProxyProvider<RadioProvider, InputProvider>(
          create: (ctx) => InputProvider(
            weightUnit: 0.0,
            currentWeightMeasure: MeasureWeight.kilograms,
            currentHeightMeasure: MeasureHeight.centimeters,
          ),
          update: (ctx, radio, input) => InputProvider(
            weightUnit: radio.getMeasureWeightInterpretation()['unit'],
            currentWeightMeasure: radio.currentWeightMeasure,
            currentHeightMeasure: radio.currentHeightMeasure,
          ),
        ),
        ChangeNotifierProxyProvider<InputProvider, CalculationsProvider>(
          create: (ctx) => CalculationsProvider(
              weight: 0, height: 0, age: 0, gender: Gender.male, units: 0.0),
          update: (ctx, input, calc) => CalculationsProvider(
            units: input.weightUnit,
            weight: double.parse('${input.weight}.${input.fractionalWeight}'),
            height: input.height,
            age: input.age,
            gender: input.gender,
          ),
        ),
        ChangeNotifierProxyProvider<RadioProvider, OverviewRepository>(
          create: (ctx) => OverviewRepository(),
          update: (ctx, radio, overview) => OverviewRepository()
            ..weightUnit = radio.getMeasureWeightInterpretation()['unit'],
        ),
        ChangeNotifierProvider(create: (ctx) => NavigationProvider()),
        ChangeNotifierProvider(create: (ctx) => ChipsProvider()),
        ChangeNotifierProvider(create: (ctx) => CaloriesRepository()),
        ChangeNotifierProvider(create: (ctx) => ValidationProvider()),
        ChangeNotifierProxyProvider<CaloriesRepository, CaloriesChartProvider>(
          create: (ctx) => CaloriesChartProvider(),
          update: (ctx, repository, chart) =>
              CaloriesChartProvider()..calories = repository.parameters,
        ),
      ],
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          canvasColor: Colors.transparent,
          scaffoldBackgroundColor: kPrimaryColor,
          primaryColor: kPrimaryColor,
          accentColor: kAccentColor,
          pageTransitionsTheme: kPageTransitionsTheme,
        ),
        home: NavigationPage(),
      ),
    );
  }
}
