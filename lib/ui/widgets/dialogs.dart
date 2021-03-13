import 'package:bmi_calculator/repositories/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/index.dart';

Future<T> showBottomRoundDialog<T>({
  @required BuildContext context,
  @required Widget child,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: kPrimaryColor,
    isScrollControlled: true,
    builder: (context) => child,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(10.0),
        topRight: const Radius.circular(10.0),
      ),
    ),
  );
}

void showDeleteDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          title: const Text(
            'Удалить все данные',
            style: kTitleTextStyle,
            textScaleFactor: 0.5,
          ),
          backgroundColor: kActiveCardColor,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(kAccentColor),
                overlayColor: MaterialStateProperty.all<Color>(
                    Colors.grey.withOpacity(0.1)),
              ),
              child: const Text('ОТМЕНА'),
            ),
            Consumer2<OverviewRepository, CaloriesRepository>(
              builder: (ctx, overview, calories, _) => TextButton(
                onPressed: () {
                  overview.wipeData();
                  calories.wipeData();
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(kAccentColor),
                  overlayColor: MaterialStateProperty.all<Color>(
                      Colors.grey.withOpacity(0.1)),
                ),
                child: const Text('ДА'),
              ),
            ),
          ],
          content: const Text(
            'Вы уверены?',
            style: kInactiveLabelTextStyle,
            textScaleFactor: 0.85,
          ),
        );
      });
}
