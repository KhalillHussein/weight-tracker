import 'package:flutter/material.dart';

///Список всех констант используемых в приложении.
///В качестве констант выступают значения цвета компонентов интерфейса
///и стили текста.

const double kBottomContainerHeight = 65.0;
const Color kActiveCardColor = Color(0xFF1D1E33);
const Color kInactiveCardColor = Color(0xFF111428);
const Color kAccentColor = Color(0xFFEB1555);
const Color kPrimaryColor = Color(0xFF0A0D22);
const Color kChartGridColor = Color(0xFF343548);
const TextStyle kAppBarTextStyle = TextStyle(fontSize: 17);
const TextStyle kInactiveLabelTextStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.w500,
  color: Color(0xFF8D8E98),
);
const TextStyle kActiveLabelTextStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.w500,
  color: Colors.white,
);
const TextStyle kChartLabelTextStyle = TextStyle(
  color: Color(0xFF8C8D98),
  fontWeight: FontWeight.w400,
  fontSize: 11.0,
);
const TextStyle kNumberTextStyle = TextStyle(
  fontWeight: FontWeight.w900,
  fontSize: 40.0,
);

const TextStyle kLargeButtonTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 17.0,
  letterSpacing: 1.2,
);

const TextStyle kTitleTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 38.0,
);

const TextStyle kBMITextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 100.0,
);

const TextStyle kBodyTextStyle = TextStyle(
  fontSize: 22.0,
);

const kPageTransitionsTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  },
);

const TextStyle kStatusTextStyle = TextStyle(
  fontWeight: FontWeight.w700,
  letterSpacing: 2.0,
  fontSize: 22.0,
);

const Color kVeryUWResultColor = Color(0xFFF85BE0);

const Color kSeverelyUWResultColor = Color(0xFFDC3EF7);

const Color kUWResultColor = Color(0xFF4CA7F6);

const Color kNormalResultColor = Color(0xFF22E67B);

const Color kOverweightResultColor = Color(0xFFFECA52);

const Color kObese1ResultColor = Color(0xFFFE7C64);

const Color kObeseResultColor = Color(0xFFF54367);
