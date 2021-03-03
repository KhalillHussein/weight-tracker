//
// import 'package:bmi_calculator/providers/index.dart';
//
// import 'package:bmi_calculator/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class EmptyScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(60.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Expanded(
//               flex: 6,
//               child: Image.asset(
//                 'images/drawkit-support-woman-monochrome.png',
//                 fit: BoxFit.fitHeight,
//                 filterQuality: FilterQuality.high,
//                 isAntiAlias: true,
//                 height: 250,
//               ),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: FittedBox(
//                 fit: BoxFit.scaleDown,
//                 child: Text(
//                   'Здесь пусто...',
//                   style: kBodyTextStyle.copyWith(fontWeight: FontWeight.w700),
//                   textScaleFactor: 1.3,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: FittedBox(
//                 child: Text(
//                   'Отсутствуют данные для просмотра.\n Указать их прямо сейчас?',
//                   style: kInactiveLabelTextStyle.copyWith(height: 1.6),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Consumer<NavigationProvider>(
//               builder: (ctx, navData, _) => OutlineButton(
//                 onPressed: () {
//                   navData.currentIndex = 0;
//                 },
//                 highlightedBorderColor: kActiveCardColor,
//                 child: const Text(
//                   "ВВЕСТИ ДАННЫЕ",
//                   style: TextStyle(letterSpacing: 1.7),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
