import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repositories/index.dart';
import '../../utils/index.dart';

Future<T> showBottomRoundDialog<T>({
  @required BuildContext context,
  @required Widget child,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: kPrimaryColor,
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
          title: Text(
            'Удалить все данные',
            style: kTitleTextStyle,
            textScaleFactor: 0.5,
          ),
          backgroundColor: kActiveCardColor,
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              textColor: kAccentColor,
              child: Text('ОТМЕНА'),
            ),
            FlatButton(
              onPressed: () {
                context.read<OverviewRepository>().wipeData();
                Navigator.pop(context);
              },
              textColor: kAccentColor,
              child: Text('ДА'),
            ),
          ],
          content: Text(
            'Вы уверены?',
            style: kInactiveLabelTextStyle,
            textScaleFactor: 0.85,
          ),
        );
      });
}
