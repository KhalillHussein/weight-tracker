import 'package:flutter/material.dart';

import '../../repositories/index.dart';
import '../../utils/index.dart';
import '../widgets/components/index.dart';
import '../widgets/index.dart';

///Класс, реализующий представление экрана статистики.
///На данном произведен обзор всех измерений пользователя.
class OverviewScreen extends StatelessWidget {
  ///Метод, осуществляющий построение интерфейса пользователя,
  ///будет вызван каждый раз, при изменении состояния (данных) на данном экране.
  @override
  Widget build(BuildContext context) {
    return BasicPage<OverviewRepository>(
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                  left: 25.0, right: 25.0, top: 30.0, bottom: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 8, child: _buildChart()),
                  const Spacer(),
                  Expanded(flex: 3, child: WeightProgressIndicator()),
                  const Spacer(),
                  Expanded(flex: 6, child: _buildBmiStatusIndicator()),
                ],
              ),
            ),
          ),
          BottomButton(
              onTap: () => _showHistory(context), buttonTitle: 'ИСТОРИЯ')
        ],
      ),
    );
  }

  ///Метод, реализующий представление графика на экране обзора
  Widget _buildChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            flex: 2,
            child: FittedBox(fit: BoxFit.fitHeight, child: ChipsSelector())),
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 20.0),
            child: ChartWidget(),
          ),
        ),
      ],
    );
  }

  ///Метод, реализующий представление индикатора ИМТ на экране обзора
  Widget _buildBmiStatusIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 3,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'ИМТ статус',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: kInactiveLabelTextStyle.color,
                  letterSpacing: 1.1),
            ),
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 12,
          child: ReusableCard(
            backgroundColor: kActiveCardColor,
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
            child: BmiStatusIndicator(),
          ),
        ),
      ],
    );
  }

  ///Метод, реализующий всплывающее окно со списком истории измерений
  // void _showHistory(BuildContext context) {
  //   final Size size = MediaQuery.of(context).size;
  //   showBottomRoundDialog(
  //     context: context,
  //     child: SizedBox(
  //       height: size.height * 0.5,
  //       child: ShaderMask(
  //         shaderCallback: (Rect rect) {
  //           return LinearGradient(
  //             begin: Alignment.topCenter,
  //             end: Alignment.bottomCenter,
  //             colors: [
  //               kPrimaryColor.withOpacity(0.9),
  //               Colors.transparent,
  //               Colors.transparent,
  //               kPrimaryColor,
  //             ],
  //             stops: const [0.0, 0.02, 0.8, 1.0],
  //           ).createShader(rect);
  //         },
  //         blendMode: BlendMode.dstOut,
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const SizedBox(height: 20),
  //             Container(
  //               width: 80.0,
  //               height: 5.0,
  //               alignment: Alignment.center,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10.0),
  //                 color: kInactiveCardColor,
  //               ),
  //             ),
  //             Container(
  //               margin: const EdgeInsets.only(top: 20.0),
  //               child: HistoryList(),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void _showHistory(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    showBottomRoundDialog(
      context: context,
      child: SizedBox(
        height: size.height * 0.5,
        child: Stack(
          children: <Widget>[
            Container(
              height: 50.0,
              width: size.width,
              padding: const EdgeInsets.only(right: 50.0, left: 50.0),
              child: Center(
                child: Container(
                  width: 80.0,
                  height: 5.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: kInactiveCardColor,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50.0),
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
                      stops: const [0.0, 0.02, 0.85, 1.0],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstOut,
                  child: HistoryList()),
            ),
          ],
        ),
      ),
    );
  }
}
