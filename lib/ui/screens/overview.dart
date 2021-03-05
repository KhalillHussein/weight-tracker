import 'package:flutter/material.dart';

import '../../repositories/index.dart';
import '../../utils/index.dart';
import '../widgets/components/index.dart';
import '../widgets/index.dart';

class OverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasicPage<OverviewRepository>(
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                  left: 25.0, right: 25.0, top: 30.0, bottom: 20.0),
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

  void _showHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          color: Colors.transparent,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Container(
            decoration: const BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width,
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
                  child: HistoryList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
