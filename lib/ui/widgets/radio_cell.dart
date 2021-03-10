import 'package:flutter/material.dart';

import '../../utils/index.dart';

class RadioCell<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String label;
  final ValueChanged<T> onChanged;

  const RadioCell({
    Key key,
    @required this.value,
    @required this.groupValue,
    @required this.label,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
          activeColor: kAccentColor,
          value: value,
          groupValue: groupValue,
          onChanged: (value) => onChanged(value),
        ),
        Text(
          label,
          style: kActiveLabelTextStyle,
          textScaleFactor: 0.9,
        ),
      ],
    );
  }
}
