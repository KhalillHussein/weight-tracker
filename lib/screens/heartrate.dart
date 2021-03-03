import 'package:bmi_calculator/repositories/calculations.dart';
import 'package:bmi_calculator/utils/index.dart';
import 'package:bmi_calculator/widgets/components/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeartRateScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _percent = [
    {
      'rangeFirst': 50,
      'rangeLast': 60,
      'color': kVeryUWResultColor,
    },
    {
      'rangeFirst': 60,
      'rangeLast': 70,
      'color': kUWResultColor,
    },
    {
      'rangeFirst': 70,
      'rangeLast': 80,
      'color': kNormalResultColor,
    },
    {
      'rangeFirst': 80,
      'rangeLast': 90,
      'color': kOverweightResultColor,
    },
    {
      'rangeFirst': 90,
      'rangeLast': 100,
      'color': kObeseResultColor,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
      child: Stack(
        children: [
          ListView.builder(
            itemCount: _percent.length,
            itemBuilder: (ctx, index) => ReusableCard(
              margin: const EdgeInsets.symmetric(vertical: 8),
              backgroundColor: kActiveCardColor,
              child: Stack(
                children: [
                  _buildHeartBeatImage(_percent[index]['color']),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Text(
                            '${_percent[index]['rangeFirst']} - ${_percent[index]['rangeLast']}%',
                            style: kActiveLabelTextStyle.copyWith(
                                wordSpacing: -2,
                                color: _percent[index]['color']),
                            textScaleFactor: 0.95,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Consumer<CalculationsProvider>(
                            builder: (ctx, calc, _) => Text(
                              '${calc.percentOfHeartRate(_percent[index]['rangeFirst']).round()} - ${calc.percentOfHeartRate(_percent[index]['rangeLast']).round()}',
                              style: kNumberTextStyle.copyWith(wordSpacing: -6),
                              textScaleFactor: 0.8,
                            ),
                          ),
                          Text(
                            'уд/мин',
                            style: kInactiveLabelTextStyle,
                            textScaleFactor: 0.8,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      kPrimaryColor,
                      kPrimaryColor.withOpacity(0),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeartBeatImage(Color color) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        Image.asset(
          'images/conifer-pulse.png',
          fit: BoxFit.fill,
          height: 75,
          width: 225,
          color: color,
          filterQuality: FilterQuality.high,
          isAntiAlias: true,
        ),
        Positioned(
          left: 0,
          child: Container(
            height: 80,
            width: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                kActiveCardColor,
                kActiveCardColor.withOpacity(0),
              ]),
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                kActiveCardColor.withOpacity(0),
                kActiveCardColor,
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
