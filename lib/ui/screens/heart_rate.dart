import 'package:bmi_calculator/utils/index.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart';
import '../widgets/components/index.dart';

class HeartRateScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _percent = [
    {
      'rangeFirst': 50,
      'rangeLast': 60,
      'color': kVeryUWResultColor,
      'info': 'Улучшает общее самочувствие и восстановление'
    },
    {
      'rangeFirst': 60,
      'rangeLast': 70,
      'color': kUWResultColor,
      'info': 'Улучшение основной выносливости и сжигание жира'
    },
    {
      'rangeFirst': 70,
      'rangeLast': 80,
      'color': kNormalResultColor,
      'info': 'Повышает аэробную способность'
    },
    {
      'rangeFirst': 80,
      'rangeLast': 90,
      'color': kOverweightResultColor,
      'info': 'Увеличивает порог работоспособности'
    },
    {
      'rangeFirst': 90,
      'rangeLast': 100,
      'color': kObeseResultColor,
      'info': 'Развивает максимальную результативность'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
      child: ShaderMask(
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
              0.98,
              1.0
            ], // 10% purple, 80% transparent, 10% purple
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: Stack(
          clipBehavior: Clip.none,
          // overflow: Overflow.visible,
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
                                style:
                                    kNumberTextStyle.copyWith(wordSpacing: -6),
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
                    Positioned(
                      bottom: -1,
                      left: 0,
                      child: Tooltip(
                        decoration: BoxDecoration(color: kInactiveCardColor),
                        textStyle: kActiveLabelTextStyle.copyWith(
                            fontSize: 14, color: Colors.white.withOpacity(0.9)),
                        message: _percent[index]['info'],
                        child: Icon(
                          Icons.info_outline,
                          color: Colors.white.withOpacity(0.6),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeartBeatImage(Color color) {
    return Stack(
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
