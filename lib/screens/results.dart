import 'package:bmi_calculator/repositories/calculations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/index.dart';
import '../repositories/index.dart';
import '../utils/index.dart';
import '../widgets/components/index.dart';

class ResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ИМТ КАЛЬКУЛЯТОР',
          style: kAppBarTextStyle,
        ),
        centerTitle: true,
        elevation: 15.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              alignment: Alignment.bottomLeft,
              child: const Text(
                'Ваш результат',
                style: kTitleTextStyle,
                textScaleFactor: 0.8,
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: _buildCardResult(context),
          ),
          BottomButton(
            buttonTitle: 'ПОВТОРИТЬ',
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCardResult(BuildContext context) {
    return Consumer2<InputProvider, OverviewProvider>(
        builder: (ctx, input, overview, _) {
      final calculate = Calculations(
          height: input.height,
          weight: input.weight,
          age: input.age,
          gender: input.selectedGender);
      return ReusableCard(
        margin: const EdgeInsets.all(30.0),
        backgroundColor: kActiveCardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  Status.status.getBmiStatus(calculate.bmi),
                  style: kStatusTextStyle.copyWith(
                    color: Status.status.resultBmiTextColor(
                        Status.status.getBmiStatus(calculate.bmi)),
                  ),
                  textScaleFactor: 0.8,
                ),
                SizedBox(height: 5),
                Text(
                  calculate.bmi.toStringAsFixed(1),
                  style: kBMITextStyle,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: const [
                      Text(
                        'Норма ИМТ:',
                        style: kInactiveLabelTextStyle,
                        textScaleFactor: 1.1,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        '18.5 - 25 кг/м2',
                        style: kActiveLabelTextStyle,
                        textScaleFactor: 1.1,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Column(
                  children: [
                    Text(
                      'Идеальный вес:',
                      style: kInactiveLabelTextStyle,
                      textScaleFactor: 1,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      '${calculate.idealMinWeight.toStringAsFixed(1)} - ${calculate.idealMaxWeight.toStringAsFixed(1)} кг',
                      style: kActiveLabelTextStyle,
                      textScaleFactor: 1.1,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Процент жира:',
                  style: kInactiveLabelTextStyle,
                  textScaleFactor: 1,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Text(
                      calculate.getFatPercent().toStringAsFixed(1),
                      textAlign: TextAlign.center,
                      style: kBMITextStyle.copyWith(
                        //  fontWeight: FontWeight.w600,
                        color: Status.status.resultFatTextColor(
                          calculate.getFatPercent(),
                          input.selectedGender,
                        ),
                      ),
                      maxLines: 1,
                      textScaleFactor: 0.6,
                    ),
                    Text(
                      '%',
                      textAlign: TextAlign.center,
                      style: kBMITextStyle.copyWith(
                        color: Status.status.resultFatTextColor(
                          calculate.getFatPercent(),
                          input.selectedGender,
                        ),
                      ),
                      maxLines: 1,
                      textScaleFactor: 0.3,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                FlatButton(
                  onPressed: () {
                    overview.addData(toMap(calculate));
                    Navigator.pop(context);
                  },
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 50.0),
                  color: kInactiveCardColor,
                  child: const Text(
                    'СОХРАНИТЬ',
                    style: TextStyle(
                        letterSpacing: 2, fontWeight: FontWeight.w400),
                    textScaleFactor: 1.1,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Map<String, dynamic> toMap(Calculations value) {
    return <String, dynamic>{
      'height': value.height,
      'weight': value.weight,
      'bmi': value.bmi,
      'idealWeight': value.idealMinWeight,
      'age': value.age,
      'date': DateTime.now(),
    };
  }
}
