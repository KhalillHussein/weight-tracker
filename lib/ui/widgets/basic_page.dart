import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart';
import '../../repositories/index.dart';
import '../../utils/index.dart';

/// Centered [ProgressIndicator] widget.
Widget get _loadingIndicator =>
    Center(child: SpinKitPulse(color: kAccentColor));

class BasicPage<T extends BaseRepository> extends StatelessWidget {
  final Widget body;

  const BasicPage({
    @required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, model, child) => model.isLoading
          ? _loadingIndicator
          : model.loadingFailed
              ? ChangeNotifierProvider.value(
                  value: model,
                  child: _ConnectionError<T>(),
                )
              : model.parameters.isEmpty
                  ? _EmptyScreen()
                  : SafeArea(bottom: false, child: body),
    );
  }
}

/// Widget used to display a connection error message.
/// It allows user to reload the page with a simple button.
class _ConnectionError<T extends BaseRepository> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, model, child) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'При загрузке данных что-то пошло не так',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 5),
            FlatButton(
              onPressed: () {},
              textColor: Theme.of(context).accentColor,
              child: const Text('Повторить попытку'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: Image.asset(
                'images/drawkit-support-woman-monochrome.png',
                fit: BoxFit.fitHeight,
                filterQuality: FilterQuality.high,
                isAntiAlias: true,
                height: 250,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Здесь пусто...',
                  style: kBodyTextStyle.copyWith(fontWeight: FontWeight.w700),
                  textScaleFactor: 1.3,
                ),
              ),
            ),
            Expanded(
              child: FittedBox(
                child: Text(
                  'Отсутствуют данные для просмотра.\n Указать их прямо сейчас?',
                  style: kInactiveLabelTextStyle.copyWith(height: 1.6),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Consumer<NavigationProvider>(
              builder: (ctx, navData, _) => OutlineButton(
                onPressed: () {
                  navData.currentIndex = 0;
                },
                highlightedBorderColor: kActiveCardColor,
                child: const Text(
                  "ВВЕСТИ ДАННЫЕ",
                  style: TextStyle(letterSpacing: 1.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
