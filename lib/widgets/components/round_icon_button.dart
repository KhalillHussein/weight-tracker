import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const RoundIconButton({@required this.icon, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: 0.0,
      shape: const CircleBorder(),
      fillColor: const Color(0xFF1C1F32),
      constraints: const BoxConstraints.tightFor(width: 56, height: 56),
      child: Icon(
        icon,
        size: 28,
      ),
    );
  }
}
