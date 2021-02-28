import 'package:bmi_calculator/providers/chips.dart';
import 'package:bmi_calculator/providers/navigation.dart';
import 'package:bmi_calculator/providers/overview.dart';
import 'package:bmi_calculator/repositories/calculations.dart';
import 'package:bmi_calculator/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:provider/provider.dart';

import './pages/navigation.dart';
import 'providers/index.dart';

void main() {
  initializeDateFormatting();
  runApp(BMICalculator());
}

class BMICalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => OverviewProvider()),
        ChangeNotifierProvider(create: (ctx) => InputProvider()),
        ChangeNotifierProxyProvider<InputProvider, CalculationsProvider>(
          create: (ctx) => CalculationsProvider(
              weight: 0.0, height: 0, age: 0, gender: Gender.male),
          update: (ctx, input, calc) => CalculationsProvider(
            weight: input.weight,
            height: input.height,
            age: input.age,
            gender: input.selectedGender,
          ),
        ),
        ChangeNotifierProvider(create: (ctx) => NavigationProvider()),
        ChangeNotifierProvider(create: (ctx) => ChipsProvider()),
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
