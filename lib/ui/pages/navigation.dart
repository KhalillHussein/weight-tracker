import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:drawerbehavior/drawer_scaffold.dart';
import 'package:drawerbehavior/drawerbehavior.dart';

import '../../providers/index.dart';
import '../../utils/index.dart';
import '../screens/index.dart';

///Представление стартовой страницы с возможностью навигации
class NavigationPage extends StatelessWidget {
  ///Список заголовков и соответствующих им представлений.
  ///Данный список используется в реализации перехода между страницами приложения.
  final List<Map<String, Object>> _screens = [
    {
      'title': 'ИМТ КАЛЬКУЛЯТОР',
      'page': InputScreen(),
    },
    {
      'title': 'СЧЕТЧИК КАЛОРИЙ',
      'page': CaloriesCounterScreen(),
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

  ///Переопределение метода [build] класса StatelessWidget
  ///Он будет вызываться для визуализации/обновления элементов интерфейса
  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (ctx, model, _) => DrawerScaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
          builder: (context, id) => _screens[id]['page']),
    );
  }
}
