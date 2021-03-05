import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../utils/index.dart';
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
    final unit =
        context.watch<RadioProvider>().getMeasureWeightInterpretation()['abbr'];
    return Consumer3<InputProvider, OverviewRepository, CalculationsProvider>(
        builder: (ctx, input, overview, calculate, _) {
      return ReusableCard(
        margin: const EdgeInsets.all(30.0),
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15),
        backgroundColor: kActiveCardColor,
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                UserStatus.status.getBmiStatus(calculate.bmi),
                style: kStatusTextStyle.copyWith(
                  color: UserStatus.status.resultBmiTextColor(
                      UserStatus.status.getBmiStatus(calculate.bmi)),
                ),
                textScaleFactor: 0.8,
              ),
              const SizedBox(height: 5),
              Text(
                calculate.bmi.toStringAsFixed(1),
                style: kBMITextStyle,
              ),
              _buildBMINormal(),
              const SizedBox(height: 15),
              _buildIdealWeight(calculate, unit),
              const SizedBox(height: 20),
              Text(
                'Процент жира:',
                style: kInactiveLabelTextStyle,
                textScaleFactor: 1,
              ),
              _buildFatPercentValue(calculate, input),
              const SizedBox(
                height: 25,
              ),
              _buildButton(overview, calculate, context),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBMINormal() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: const [
          Text(
            'Норма ИМТ:',
            style: kInactiveLabelTextStyle,
            textScaleFactor: 1.1,
          ),
          SizedBox(height: 5.0),
          Text(
            '18.5 - 25 kg/m2',
            style: kActiveLabelTextStyle,
            textScaleFactor: 1.1,
          ),
        ],
      ),
    );
  }

  Widget _buildIdealWeight(CalculationsProvider calculate, String unit) {
    return Column(
      children: [
        Text(
          'Идеальный вес:',
          style: kInactiveLabelTextStyle,
          textScaleFactor: 1,
        ),
        const SizedBox(height: 5.0),
        Text(
          '${calculate.idealWeightLabel()} $unit',
          style: kActiveLabelTextStyle,
          textScaleFactor: 1.1,
        ),
      ],
    );
  }

  Widget _buildFatPercentValue(
      CalculationsProvider calculate, InputProvider input) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: [
        Text(
          calculate.getFatPercentByGender().toStringAsFixed(1),
          textAlign: TextAlign.center,
          style: kBMITextStyle.copyWith(
            color: UserStatus.status.resultFatTextColor(
              calculate.getFatPercentByGender(),
              input.gender,
            ),
          ),
          maxLines: 1,
          textScaleFactor: 0.6,
        ),
        Text(
          '%',
          textAlign: TextAlign.center,
          style: kBMITextStyle.copyWith(
            color: UserStatus.status.resultFatTextColor(
              calculate.getFatPercentByGender(),
              input.gender,
            ),
          ),
          maxLines: 1,
          textScaleFactor: 0.3,
        ),
      ],
    );
  }

  Widget _buildButton(OverviewRepository overview,
      CalculationsProvider calculate, BuildContext context) {
    return FlatButton(
      onPressed: () {
        overview.addData(toMap(calculate));
        Navigator.pop(context);
      },
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
      color: kInactiveCardColor,
      child: const Text(
        'СОХРАНИТЬ',
        style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w400),
        textScaleFactor: 1.1,
      ),
    );
  }

  Map<String, dynamic> toMap(CalculationsProvider value) {
    return <String, dynamic>{
      'id': DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .millisecondsSinceEpoch,
      'height': value.height,
      'weight': value.weight,
      'bmi': value.bmi,
      'idealWeight': value.idealMinWeight,
      'fatPercent': value.getFatPercentByGender(),
      'age': value.age,
      'date': DateTime.now().millisecondsSinceEpoch,
    };
  }
}
