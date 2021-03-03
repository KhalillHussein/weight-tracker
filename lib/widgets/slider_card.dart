// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../providers/index.dart';
// import '../utils/index.dart';
// import '../widgets/components/index.dart';
//
// class SliderCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<InputProvider>(
//       builder: (ctx, input, _) => ReusableCard(
//         margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 3.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Expanded(
//               flex: 4,
//               child: FittedBox(
//                 fit: BoxFit.scaleDown,
//                 child: Text(
//                   'РОСТ',
//                   style: kInactiveLabelTextStyle,
//                 ),
//               ),
//             ),
//             // const Spacer(),
//             Expanded(
//               flex: 9,
//               child: FittedBox(
//                 fit: BoxFit.fitHeight,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.baseline,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Text(
//                       '${input.height}',
//                       style: kNumberTextStyle,
//                     ),
//                     const SizedBox(width: 2),
//                     Consumer<InputProvider>(
//                       builder: (ctx, input, _) => Text(
//                         input.unitAbbr,
//                         style: kInactiveLabelTextStyle,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             const Spacer(),
//             Expanded(flex: 6, child: _buildSlider(context, input)),
//             //  const Spacer(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSlider(BuildContext context, InputProvider input) {
//     return SliderTheme(
//       data: SliderTheme.of(context).copyWith(
//         inactiveTrackColor: Color(0xFF8D8E98),
//         activeTrackColor: Colors.white,
//         thumbColor: Color(0xFFEB1555),
//         overlayColor: Color(0x29EB1555),
//         trackHeight: 2.0,
//         trackShape: const RectangularSliderTrackShape(),
//         thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15.0),
//         overlayShape: const RoundSliderOverlayShape(overlayRadius: 25.0),
//       ),
//       child: Slider(
//         value: input.height.toDouble(),
//         min: input.minHeight.toDouble(),
//         max: input.maxHeight.toDouble(),
//         onChanged: (value) {
//           input.height = value.round();
//         },
//       ),
//     );
//   }
// }

import 'package:bmi_calculator/providers/radio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/index.dart';
import '../utils/index.dart';
import '../widgets/components/index.dart';

class SliderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final unit =
        context.watch<RadioProvider>().getMeasureHeightInterpretation()['abbr'];
    return Consumer<InputProvider>(
      builder: (ctx, input, _) => ReusableCard(
        margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 3.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Expanded(
              flex: 4,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'РОСТ',
                  style: kInactiveLabelTextStyle,
                ),
              ),
            ),
            // const Spacer(),
            Expanded(
              flex: 9,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      input.labelHeight(),
                      style: kNumberTextStyle,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      unit,
                      style: kInactiveLabelTextStyle,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Expanded(flex: 6, child: _buildSlider(context, input)),
            //  const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(BuildContext context, InputProvider input) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        inactiveTrackColor: Color(0xFF8D8E98),
        activeTrackColor: Colors.white,
        thumbColor: Color(0xFFEB1555),
        overlayColor: Color(0x29EB1555),
        trackHeight: 2.0,
        trackShape: const RectangularSliderTrackShape(),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15.0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 25.0),
      ),
      child: Slider(
        value: input.height.toDouble(),
        min: input.minHeight.toDouble(),
        max: input.maxHeight.toDouble(),
        onChanged: (value) {
          input.height = value.round();
        },
      ),
    );
  }
}
