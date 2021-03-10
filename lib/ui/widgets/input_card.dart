import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart';
import '../../utils/index.dart';
import '../widgets/components/index.dart';

class InputCard extends StatelessWidget {
  final String label;

  final String value;
  final bool showSlider;

  final VoidCallback incFunction;

  final VoidCallback decFunction;

  const InputCard({
    this.showSlider = false,
    this.label,
    this.value,
    this.incFunction,
    this.decFunction,
  });

  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      margin: const EdgeInsets.all(3.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: kInactiveLabelTextStyle,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(
                value,
                style: kNumberTextStyle,
              ),
            ),
          ),
          if (showSlider) Expanded(child: _buildSlider(context)),
          const Spacer(),
          Expanded(
            flex: 7,
            child: FittedBox(
              child: Row(
                children: <Widget>[
                  RoundIconButton(
                    icon: MdiIcons.minus,
                    onPressed: decFunction,
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  RoundIconButton(
                    icon: MdiIcons.plus,
                    onPressed: incFunction,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildSlider(BuildContext context) {
  return Consumer<InputProvider>(
    builder: (ctx, input, _) => SliderTheme(
      data: SliderTheme.of(context).copyWith(
        inactiveTrackColor: Color(0xFF8D8E98),
        activeTrackColor: Colors.white,
        thumbColor: Color(0xFFEB1555),
        overlayColor: Colors.transparent,
        trackHeight: 1.5,
        trackShape: const RectangularSliderTrackShape(),
        thumbShape: const RetroSliderThumbShape(),
      ),
      child: Slider(
        value: input.fractionalWeight.toDouble(),
        max: 9.0,
        onChanged: (value) {
          input.fractionalWeight = value.round();
        },
      ),
    ),
  );
}

//
// class RetroSliderThumbShape extends SliderComponentShape {
//   final double thumbRadius;
//
//   const RetroSliderThumbShape({
//     this.thumbRadius = 6.0,
//   });
//
//   @override
//   Size getPreferredSize(bool isEnabled, bool isDiscrete) {
//     return Size.fromRadius(thumbRadius);
//   }
//
//   @override
//   void paint(
//     PaintingContext context,
//     Offset center, {
//     Size sizeWithOverflow,
//     double textScaleFactor,
//     Animation<double> activationAnimation,
//     Animation<double> enableAnimation,
//     bool isDiscrete,
//     TextPainter labelPainter,
//     RenderBox parentBox,
//     SliderThemeData sliderTheme,
//     TextDirection textDirection,
//     double value,
//   }) {
//     final Canvas canvas = context.canvas;
//
//     final rect = Rect.fromCircle(center: center, radius: thumbRadius);
//
//     final rrect = RRect.fromRectAndRadius(
//       Rect.fromPoints(
//         Offset(rect.left, rect.top),
//         Offset(rect.right, rect.bottom),
//       ),
//       Radius.circular(thumbRadius - 10),
//     );
//
//     final fillPaint = Paint()
//       ..color = sliderTheme.activeTrackColor
//       ..style = PaintingStyle.fill;
//
//     final borderPaint = Paint()
//       ..color = Colors.black
//       ..strokeWidth = 2.8
//       ..style = PaintingStyle.stroke;
//
//     canvas.drawRRect(rrect, fillPaint);
//     canvas.drawRRect(rrect, borderPaint);
//   }
// }

class RetroSliderThumbShape extends SliderComponentShape {
  final double thumbSize;

  const RetroSliderThumbShape({
    this.thumbSize = 12.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbSize);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Size sizeWithOverflow,
    double textScaleFactor,
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
  }) {
    final Canvas canvas = context.canvas;

    Path _triangle(double size, Offset thumbCenter) {
      final Path thumbPath = Path();
      final double halfSize = size / 1.4;
      thumbPath.moveTo(thumbCenter.dx + halfSize, thumbCenter.dy + 4);
      thumbPath.lineTo(thumbCenter.dx, thumbCenter.dy - size + 2);
      thumbPath.lineTo(thumbCenter.dx - halfSize, thumbCenter.dy + 4);
      thumbPath.close();
      return thumbPath;
    }

    final borderPaint = Paint()
      ..color = kInactiveCardColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawPath(
        _triangle(thumbSize, center), Paint()..color = sliderTheme.thumbColor);
    canvas.drawPath(_triangle(thumbSize, center), borderPaint);
  }
}
