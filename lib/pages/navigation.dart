import 'package:bmi_calculator/screens/settings.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:drawerbehavior/drawer_scaffold.dart';
import 'package:drawerbehavior/drawerbehavior.dart';

import '../providers/index.dart';
import '../screens/index.dart';
import '../utils/constants.dart';
import '../utils/menus.dart';

class NavigationPage extends StatelessWidget {
  final List<Map<String, Object>> _screens = [
    {
      'title': 'ИМТ КАЛЬКУЛЯТОР',
      'page': InputScreen(),
    },
    {
      'title': 'ЗОНЫ СЕРДЦЕБИЕНИЯ',
      'page': HeartRateScreen(),
    },
    {
      'title': 'СТАТИСТИКА',
      'page': OverviewScreen(),
    },
    {
      'title': 'НАСТРОЙКИ',
      'page': SettingsScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (ctx, model, _) => DrawerScaffold(
          contentView: Screen(color: Theme.of(context).scaffoldBackgroundColor),
          appBar: AppBar(
            title: Text(
              _screens[model.currentIndex]['title'],
              style: kAppBarTextStyle,
            ),
            centerTitle: true,
            elevation: 15.0,
          ),
          drawers: [
            SideDrawer(
              percentage: 0.8,
              menu: menuWithIcon,
              textStyle: kInactiveLabelTextStyle.copyWith(
                  color: Colors.white.withOpacity(0.9)),
              animation: true,
              color: kInactiveCardColor,
              selectorColor: kAccentColor,
              selectedItemId: model.currentIndex,
              onMenuItemSelected: (index) => model.currentIndex = index,
            ),
          ],
          builder: (context, id) => _screens[id]['page']
          //     IndexedStack(
          //   index: id,
          //   children:
          //       menuWithIcon.items.map((e) => _screens[e.id]['page']).toList(),
          // ),
          ),
    );
  }
}
