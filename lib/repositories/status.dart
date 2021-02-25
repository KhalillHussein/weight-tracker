import 'package:bmi_calculator/providers/index.dart';
import 'package:flutter/material.dart';

import '../utils/index.dart';

class Status {
  Status._();
  static final Status status = Status._();

  static const String kUWResultText = 'ПОНИЖЕННЫЙ ВЕС';
  static const String kNormalResultText = 'НОРМАЛЬНЫЙ ВЕС';
  static const String kOverweightResultText = 'ИЗБЫТОЧНЫЙ ВЕС';
  static const String kObese1ResultText = 'ОЖИРЕНИЕ I СТЕПЕНИ';
  static const String kObese2ResultText = 'ОЖИРЕНИЕ II СТЕПЕНИ';
  static const String kObese3ResultText = 'ОЖИРЕНИЕ III СТЕПЕНИ';
  static const String kUnknownText = 'НЕИЗВЕСТНО';

  String getBmiStatus(double bmi) {
    if (bmi < 18.5) {
      return kUWResultText;
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      return kNormalResultText;
    } else if (bmi > 25.0 && bmi <= 29.9) {
      return kOverweightResultText;
    } else if (bmi > 30.0 && bmi <= 34.9) {
      return kObese1ResultText;
    } else if (bmi > 35.0 && bmi <= 39.9) {
      return kObese2ResultText;
    } else if (bmi >= 40.0) {
      return kObese3ResultText;
    } else {
      return kUnknownText;
    }
  }
  //
  // String getFatStatusMale(double maleFatPercent) {
  //   if (maleFatPercent < 5) {
  //     return 'НИЗКИЙ ПРОЦЕНТ ЖИРА\n(зона риска)';
  //   } else if (maleFatPercent >= 5 && maleFatPercent <= 8) {
  //     return 'АТЛЕТИЧЕСКОЕ ТЕЛОСЛОЖЕНИЕ';
  //   } else if (maleFatPercent > 8 && maleFatPercent <= 12) {
  //     return 'СПОРТИВНОЕ ТЕЛОСЛОЖЕНИЕ';
  //   } else if (maleFatPercent > 12 && maleFatPercent <= 20) {
  //     return 'ОБЫЧНОЕ ТЕЛОСЛОЖЕНИЕ';
  //   } else if (maleFatPercent > 20 && maleFatPercent <= 30) {
  //     return 'ИЗБЫТОЧНЫЙ ЖИР';
  //   } else if (maleFatPercent > 30) {
  //     return 'ВЫСОКИЙ ПРОЦЕНТ ЖИРА\n(зона риска)';
  //   } else {
  //     return 'НЕИЗВЕСТНО';
  //   }
  // }
  //
  // String getFatStatusFemale(double femaleFatPercent) {
  //   if (femaleFatPercent < 15) {
  //     return 'НИЗКИЙ ПРОЦЕНТ ЖИРА\n(зона риска)';
  //   } else if (femaleFatPercent >= 15 && femaleFatPercent <= 18) {
  //     return 'АТЛЕТИЧЕСКОЕ ТЕЛОСЛОЖЕНИЕ';
  //   } else if (femaleFatPercent > 18 && femaleFatPercent <= 22) {
  //     return 'СПОРТИВНОЕ ТЕЛОСЛОЖЕНИЕ';
  //   } else if (femaleFatPercent > 22 && femaleFatPercent <= 30) {
  //     return 'ОБЫЧНОЕ ТЕЛОСЛОЖЕНИЕ';
  //   } else if (femaleFatPercent > 30 && femaleFatPercent <= 40) {
  //     return 'ИЗБЫТОЧНЫЙ ЖИР';
  //   } else if (femaleFatPercent > 40) {
  //     return 'ВЫСОКИЙ ПРОЦЕНТ ЖИРА\n(зона риска)';
  //   } else {
  //     return 'НЕИЗВЕСТНО';
  //   }
  // }

  Color resultFatTextColor(double fatPercent, Gender gender) {
    switch (gender) {
      case Gender.female:
        if (fatPercent < 15) {
          return kUWResultColor;
        } else if (fatPercent >= 15 && fatPercent <= 30) {
          return kNormalResultColor;
        } else if (fatPercent > 30 && fatPercent <= 40) {
          return kOverweightResultColor;
        } else if (fatPercent > 40) {
          return kObeseResultColor;
        } else {
          return kUWResultColor;
        }
        break;
      case Gender.male:
        if (fatPercent < 5) {
          return kUWResultColor;
        } else if (fatPercent >= 5 && fatPercent <= 20) {
          return kNormalResultColor;
        } else if (fatPercent > 20 && fatPercent <= 30) {
          return kOverweightResultColor;
        } else if (fatPercent > 30) {
          return kObeseResultColor;
        } else {
          return kUWResultColor;
        }
        break;
      default:
        return kUWResultColor;
        break;
    }
  }
  //
  // Color resultTextFatColor(String result) {
  //   switch (result) {
  //     case 'НИЗКИЙ ПРОЦЕНТ ЖИРА\n(зона риска)':
  //       return kUWResultColor;
  //       break;
  //     case 'АТЛЕТИЧЕСКОЕ ТЕЛОСЛОЖЕНИЕ':
  //       return kNormalResultColor;
  //       break;
  //     case 'СПОРТИВНОЕ ТЕЛОСЛОЖЕНИЕ':
  //       return kOverweightResultColor;
  //       break;
  //     case 'ОБЫЧНОЕ ТЕЛОСЛОЖЕНИЕ':
  //       return kObese1ResultColor;
  //       break;
  //     case 'ИЗБЫТОЧНЫЙ ЖИР':
  //       return kObeseResultColor;
  //       break;
  //     case 'ВЫСОКИЙ ПРОЦЕНТ ЖИРА\n(зона риска)':
  //       return kObeseResultColor;
  //       break;
  //     default:
  //       return kUWResultColor;
  //   }
  // }

  Color resultBmiTextColor(String result) {
    switch (result) {
      case kUWResultText:
        return kUWResultColor;
        break;
      case kNormalResultText:
        return kNormalResultColor;
        break;
      case kOverweightResultText:
        return kOverweightResultColor;
        break;
      case kObese1ResultText:
        return kObese1ResultColor;
        break;
      case kObese2ResultText:
        return kObeseResultColor;
        break;
      case kObese3ResultText:
        return kObeseResultColor;
        break;
      default:
        return kNormalResultColor;
    }
  }
}
