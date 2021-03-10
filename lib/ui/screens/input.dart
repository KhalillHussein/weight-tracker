import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../providers/index.dart';
import '../widgets/components/index.dart';
import '../widgets/index.dart';
import 'index.dart';

///Класс, реализующий представление экрана ИМТ калькулятора.
///Через него производится указание данных о пользователе.
class InputScreen extends StatelessWidget {
  ///Метод, осуществляющий построение интерфейса пользователя,
  ///будет вызван каждый раз, при изменении состояния (данных) на данном экране.
  @override
  Widget build(BuildContext context) {
    final unit =
        context.watch<RadioProvider>().getMeasureWeightInterpretation()['abbr'];
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: const [
                      Expanded(
                        child: GenderCard(
                          label: 'МУЖСКОЙ',
                          icon: MdiIcons.genderMale,
                          gender: Gender.male,
                          angle: 0.0,
                        ),
                      ),
                      Expanded(
                        child: GenderCard(
                          label: 'ЖЕНСКИЙ',
                          icon: MdiIcons.genderFemale,
                          gender: Gender.female,
                          angle: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: SliderCard(),
                ),
                Expanded(
                  flex: 4,
                  child: Consumer<InputProvider>(
                    builder: (ctx, input, _) => Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: InputCard(
                            label: 'ВЕС ($unit)',
                            showSlider: true,
                            value: input.labelWeight(),
                            incFunction: input.incrementWeight,
                            decFunction: input.decrementWeight,
                          ),
                        ),
                        Expanded(
                          child: InputCard(
                            label: 'ВОЗРАСТ',
                            value: input.age.toString(),
                            incFunction: input.incrementAge,
                            decFunction: input.decrementAge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        BottomButton(
          buttonTitle: 'РАССЧИТАТЬ ИМТ',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
