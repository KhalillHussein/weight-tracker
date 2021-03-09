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
              'Ошибка загрузки данных :(',
              style: kBodyTextStyle.copyWith(fontWeight: FontWeight.w700),
              textScaleFactor: 0.9,
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
        child: Consumer<NavigationProvider>(
          builder: (ctx, navigation, _) => navigation.currentIndex == 2
              ? _overviewEmptyScreen()
              : _caloriesEmptyScreen(),
        ),
      ),
    );
  }

  Widget _caloriesEmptyScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Expanded(
          flex: 6,
          child: Image.asset(
            'images/breakfast-colour-1200px.png',
            fit: BoxFit.scaleDown,
            filterQuality: FilterQuality.high,
            isAntiAlias: true,
            width: 250,
          ),
        ),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Здесь пока пусто...',
              style: kBodyTextStyle.copyWith(fontWeight: FontWeight.w700),
              textScaleFactor: 1.3,
            ),
          ),
        ),
        Expanded(
          child: FittedBox(
            child: Text(
              'Отслеживайте потребление калорий.\nНачните прямо сейчас!',
              style: kInactiveLabelTextStyle.copyWith(height: 1.6),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _overviewEmptyScreen() {
    return Column(
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
          builder: (ctx, navData, _) => OutlinedButton(
            onPressed: () {
              navData.currentIndex = 0;
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              ),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              overlayColor: MaterialStateProperty.all<Color>(
                  Colors.grey.withOpacity(0.1)),
            ),
            // highlightedBorderColor: kActiveCardColor,
            child: const Text(
              "УКАЗАТЬ ДАННЫЕ",
              style: TextStyle(letterSpacing: 1.7),
            ),
          ),
        ),
      ],
    );
  }
}
