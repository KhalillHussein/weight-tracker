import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/index.dart';
import '../../utils/index.dart';
import '../widgets/components/index.dart';
import '../widgets/index.dart';

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
                _buildGraphItem(context),
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
                _buildDeleteItem(context),
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
      onTap: () => showBottomRoundDialog(
        context: context,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15),
          child: _SettingsMeasure(),
        ),
      ),
      child: Consumer<RadioProvider>(
        builder: (ctx, radio, _) => _buildMenuItem(
          title: 'Единицы измерения',
          subtitle:
              '${radio.getMeasureWeightInterpretation()['interpretation']}, ${radio.getMeasureHeightInterpretation()['interpretation']}',
        ),
      ),
    );
  }

  Widget _buildGraphItem(BuildContext context) {
    return GestureDetector(
      onTap: () => showBottomRoundDialog(
        context: context,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15),
          child: _SettingsChart(),
        ),
      ),
      child: Consumer<RadioProvider>(
        builder: (ctx, radio, _) => _buildMenuItem(
          title: 'График',
          subtitle: radio.getGraphTypeInterpretation()['name'],
        ),
      ),
    );
  }

  Widget _buildDeleteItem(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDeleteDialog(context);
      },
      child: _buildMenuItem(
        title: 'Удалить все данные',
        subtitle: 'Удалить все сохраненные данные',
      ),
    );
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
              Text(
                subtitle,
                style: kChartLabelTextStyle.copyWith(height: 1.5),
                textScaleFactor: 1.2,
                maxLines: 4,
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsMeasure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentMeasureHeight =
        context.read<RadioProvider>().currentHeightMeasure;
    final currentMeasureWeight =
        context.read<RadioProvider>().currentWeightMeasure;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'ЕДИНИЦЫ ИЗМЕРЕНИЯ',
          style: kAppBarTextStyle.copyWith(
              fontWeight: FontWeight.w500, letterSpacing: 0.8),
          textScaleFactor: 1.05,
        ),
        const SizedBox(height: 35),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                'Единицы роста',
                style: kInactiveLabelTextStyle,
                textScaleFactor: 0.85,
              ),
            ),
            const SizedBox(height: 5),
            RadioCell<MeasureHeight>(
              value: MeasureHeight.centimeters,
              groupValue: currentMeasureHeight,
              onChanged: (value) => _changeHeightMeasure(context, value),
              label: 'Сантиметры',
            ),
            RadioCell<MeasureHeight>(
              value: MeasureHeight.footInches,
              groupValue: currentMeasureHeight,
              onChanged: (value) => _changeHeightMeasure(context, value),
              label: 'Футы/Дюймы',
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                'Единицы веса',
                style: kInactiveLabelTextStyle,
                textScaleFactor: 0.85,
              ),
            ),
            const SizedBox(height: 5),
            RadioCell<MeasureWeight>(
              value: MeasureWeight.kilograms,
              groupValue: currentMeasureWeight,
              onChanged: (value) => _changeWeightMeasure(context, value),
              label: 'Килограммы',
            ),
            RadioCell<MeasureWeight>(
              value: MeasureWeight.pounds,
              groupValue: currentMeasureWeight,
              onChanged: (value) => _changeWeightMeasure(context, value),
              label: 'Фунты',
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _changeHeightMeasure(
      BuildContext context, MeasureHeight measure) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    context.read<RadioProvider>().currentHeightMeasure = measure;
    // Saves new settings
    prefs.setInt('heightMeasure', measure.index);

    Navigator.pop(context);
  }

  Future<void> _changeWeightMeasure(
      BuildContext context, MeasureWeight measure) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    context.read<RadioProvider>().currentWeightMeasure = measure;
    // Saves new settings
    prefs.setInt('weightMeasure', measure.index);

    Navigator.pop(context);
  }
}

class _SettingsChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentChartType = context.read<RadioProvider>().currentGraphType;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'ГРАФИК',
          style: kAppBarTextStyle.copyWith(
              fontWeight: FontWeight.w500, letterSpacing: 0.8),
          textScaleFactor: 1.05,
        ),
        const SizedBox(height: 15),
        RadioCell<GraphType>(
          value: GraphType.weight,
          groupValue: currentChartType,
          onChanged: (value) => _changeChartType(context, value),
          label: 'Вес',
        ),
        RadioCell<GraphType>(
          value: GraphType.fatPercent,
          groupValue: currentChartType,
          onChanged: (value) => _changeChartType(context, value),
          label: 'Процент жира',
        ),
        RadioCell<GraphType>(
          value: GraphType.bmi,
          groupValue: currentChartType,
          onChanged: (value) => _changeChartType(context, value),
          label: 'ИМТ',
        ),
      ],
    );
  }

  Future<void> _changeChartType(BuildContext context, GraphType type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    context.read<RadioProvider>().currentGraphType = type;
    // Saves new settings
    prefs.setInt('chartType', type.index);

    Navigator.pop(context);
  }
}
