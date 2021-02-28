import 'package:bmi_calculator/utils/constants.dart';
import 'package:bmi_calculator/widgets/components/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ReusableCard(
            backgroundColor: kActiveCardColor,
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30.0),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ОБЩИЕ',
                  style: TextStyle(
                    color: kAccentColor,
                    fontWeight: FontWeight.w700,
                  ),
                  textScaleFactor: 0.95,
                ),
                _buildMeasurementsItem(context),
                _buildGraphItem(),
              ],
            ),
          ),
          ReusableCard(
            backgroundColor: kActiveCardColor,
            margin: const EdgeInsets.symmetric(horizontal: 30.0),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ДАННЫЕ',
                  style: TextStyle(
                    color: kAccentColor,
                    fontWeight: FontWeight.w700,
                  ),
                  textScaleFactor: 0.95,
                ),
                _buildDeleteItem(),
              ],
            ),
          ),
          ReusableCard(
            backgroundColor: kActiveCardColor,
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30.0),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'О ПРИЛОЖЕНИИ',
                  style: TextStyle(
                    color: kAccentColor,
                    fontWeight: FontWeight.w700,
                  ),
                  textScaleFactor: 0.95,
                ),
                _buildMenuItem(
                  title: 'Версия приложения',
                  subtitle: 'Текущая версия приложения 0.8',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementsItem(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showDialog(context);
      },
      child: _buildMenuItem(
        title: 'Единицы измерения',
        subtitle: 'Единицы измерения для расчетных параметров',
      ),
    );
  }

  Widget _buildGraphItem() {
    return GestureDetector(
      child: _buildMenuItem(
        title: 'График',
        subtitle: 'Выбор величины, отслеживаемой на графике',
      ),
    );
  }

  Widget _buildDeleteItem() {
    return GestureDetector(
      child: _buildMenuItem(
        title: 'Удалить все данные',
        subtitle: 'Удалить все сохраненные данные',
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            backgroundColor: kActiveCardColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ЕДИНИЦЫ ИЗМЕРЕНИЯ',
                  style: kTitleTextStyle,
                  textScaleFactor: 0.4,
                ),
                SizedBox(height: 20),
                Text(
                  'Единицы роста',
                  style: kInactiveLabelTextStyle,
                  textScaleFactor: 0.85,
                ),
                SizedBox(height: 20),
                Text(
                  'Единицы веса',
                  style: kInactiveLabelTextStyle,
                  textScaleFactor: 0.85,
                ),
              ],
            ),
          );
        });
  }

  Widget _buildMenuItem({String title, String subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: kTitleTextStyle,
                textScaleFactor: 0.5,
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: 260,
                child: Text(
                  subtitle,
                  style: kChartLabelTextStyle.copyWith(height: 1.5),
                  textScaleFactor: 1.2,
                  maxLines: 4,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
