import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

List<MenuItem<int>> items = [
  MenuItem<int>(
    id: 0,
    title: 'ИМТ',
    icon: MdiIcons.scaleBathroom,
  ),
  MenuItem<int>(
    id: 1,
    title: 'Планировщик',
    icon: MdiIcons.calendarEdit,
  ),
  MenuItem<int>(
    id: 2,
    title: 'Статистика',
    icon: MdiIcons.chartLine,
  ),
  MenuItem<int>(
    id: 3,
    title: 'Настройки',
    icon: MdiIcons.cog,
  ),
];

final menuWithIcon = Menu(
  items: items,
);
