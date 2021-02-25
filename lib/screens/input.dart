import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../providers/input.dart';
import '../widgets/calculate_button.dart';
import '../widgets/gender_card.dart';
import '../widgets/input_card.dart';
import '../widgets/slider_card.dart';

class InputScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(30.0),
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
                    builder: (ctx, calcData, _) => Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: InputCard(
                            label: 'ВЕС',
                            value: calcData.weight.toInt(),
                            incFunction: calcData.incrementWeight,
                            decFunction: calcData.decrementWeight,
                          ),
                        ),
                        Expanded(
                          child: InputCard(
                            label: 'ВОЗРАСТ',
                            value: calcData.age,
                            incFunction: calcData.incrementAge,
                            decFunction: calcData.decrementAge,
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
        CalculateButton(),
      ],
    );
  }
}
