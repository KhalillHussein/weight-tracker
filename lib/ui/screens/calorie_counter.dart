import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../utils/index.dart';
import '../widgets/components/index.dart';
import '../widgets/index.dart';

///Класс, реализующий представление экрана с информацией о потребленных калориях.
class CalorieCounterScreen extends StatelessWidget {
  ///Метод, осуществляющий построение интерфейса пользователя,
  ///будет вызван каждый раз, при изменении состояния (данных) на данном экране.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BasicPage<CaloriesRepository>(
            body: Container(
              margin: const EdgeInsets.only(left: 25.0, right: 25.0, top: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 4, child: CaloriesChart()),
                  Expanded(flex: 2, child: _TodayCounter()),
                  Expanded(flex: 4, child: CaloriesList()),
                ],
              ),
            ),
          ),
        ),
        BottomButton(
          onTap: () {
            _showForm(context);
          },
          buttonTitle: 'НОВАЯ ЗАПИСЬ',
        ),
      ],
    );
  }

  ///Метод, реализующий построение всплывающего диалога с формой,
  ///для ввода новых данных.
  void _showForm(BuildContext context) {
    showBottomRoundDialog(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Container(
            width: 80.0,
            height: 5.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: kInactiveCardColor,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Consumer<ValidationProvider>(
              builder: (ctx, validate, _) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildTextField(
                        hintText: "",
                        labelText: "Название",
                        keyboardType: TextInputType.text,
                        onChanged: (name) => validate.changeName(name),
                        errorText: validate.name.error,
                        helperText: 'Название продукта в любом формате'),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            hintText: "",
                            labelText: "Количество",
                            keyboardType: TextInputType.number,
                            onChanged: (count) => validate.changeCount(count),
                            errorText: validate.count.error,
                            helperText: 'Целое число 0 - 9999',
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildTextField(
                            hintText: "",
                            labelText: "Калории",
                            keyboardType: TextInputType.number,
                            onChanged: (cal) => validate.changeCal(cal),
                            errorText: validate.cal.error,
                            helperText: 'Калорий в единице',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Consumer<CaloriesRepository>(
                      builder: (ctx, calories, _) => BottomButton(
                        onTap: validate.isValid
                            ? () {
                                calories.addData(
                                  toMap(
                                    name: validate.name.value,
                                    count: int.parse(validate.count.value),
                                    cal: double.parse(validate.cal.value),
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            : null,
                        buttonTitle: 'ДОБАВИТЬ',
                      ),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  ///Метод для преобразования введенных данных с формы в ассоциативный массив
  ///с соответствующими ключами. Данный массив будет передан
  ///в репозиторий [CaloriesRepository], через который данные массива будут
  ///добавлены в БД и отображены на данном экране.
  Map<String, dynamic> toMap(
      {@required String name, @required int count, @required double cal}) {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    return <String, dynamic>{
      'id': timestamp,
      'name': name,
      'count': count,
      'calories': cal * count,
      'date': timestamp,
    };
  }

  ///Метод реализующий представление текстового поля.
  Widget _buildTextField({
    String hintText,
    String labelText,
    ValueChanged onChanged,
    TextInputType keyboardType,
    String errorText,
    String helperText,
  }) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        fillColor: kInactiveCardColor,
        filled: true,
        errorText: errorText,
        helperText: helperText,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kActiveCardColor, width: 2),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: kActiveCardColor, width: 2),
        ),
      ),
      onChanged: (value) => onChanged(value),
    );
  }
}

/// Приватный класс, реализующий виджет с информацией о сумме калорий
///за текущий день недели.
class _TodayCounter extends StatelessWidget {
  ///Метод, осуществляющий построение интерфейса пользователя,
  ///отображает виджет с данными о суммарных калориях за текущий день недели
  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      margin: EdgeInsets.only(bottom: 15),
      backgroundColor: kActiveCardColor,
      child: Row(children: [
        Expanded(
          child: FittedBox(
            child: Icon(
              Icons.fastfood_outlined,
              size: 50,
              color: Colors.white.withAlpha(200),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 10,
                child: FittedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Consumer<CaloriesRepository>(
                        builder: (ctx, cal, _) => Text(
                          cal.summary().toStringAsFixed(1),
                          style: kNumberTextStyle,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        "cal",
                        style: kNumberTextStyle,
                        textScaleFactor: 0.4,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: FittedBox(
                  child: Text(
                    "сегодня",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
