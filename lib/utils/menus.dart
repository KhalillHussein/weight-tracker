import 'package:flutter/material.dart';

import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

///Список пунктов меню
List<MenuItem<int>> items = [
  MenuItem<int>(
    id: 0,
    title: 'ИМТ',
    icon: MdiIcons.scaleBathroom,
  ),
  MenuItem<int>(
    id: 1,
    title: 'Счетчик калорий',
    icon: Icons.fastfood_outlined,
  ),
  MenuItem<int>(
    id: 2,
    title: 'Статистика',
    icon: MdiIcons.chartLine,
  ),
  MenuItem<int>(
    id: 3,
    title: 'Настройки',
    icon: MdiIcons.cogOutline,
  ),
];

final menuWithIcon = Menu(
  items: items,
);
