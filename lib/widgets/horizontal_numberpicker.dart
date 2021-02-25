import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// ignore: must_be_immutable
class HorizontalNumberPicker extends StatefulWidget {
  final int initialValue;
  final int minValue;
  final int maxValue;
  final int step;

  final int widgetWidth;

  final int widgetHeight;

  int gridCount;

  final int subGridCountPerGrid;

  int gridWidth;

  final int subGridWidth;

  int listViewItemCount;

  double paddingItemWidth;

  final void Function(int) onSelectedChanged;

  String Function(int) scaleTransformer;

  final Color scaleColor;

  final Color indicatorColor;

  final Color scaleTextColor;

  HorizontalNumberPicker({
    Key key,
    this.initialValue = 500,
    this.minValue = 100,
    this.maxValue = 900,
    this.step = 1,
    this.widgetWidth = 200,
    this.widgetHeight = 60,
    this.subGridCountPerGrid = 10,
    this.subGridWidth = 8,
    @required this.onSelectedChanged,
    this.scaleTransformer,
    this.scaleColor = const Color(0xFFE9E9E9),
    this.indicatorColor = const Color(0xFF3995FF),
    this.scaleTextColor = const Color(0xFF8E99A0),
  }) : super(key: key) {
    if (subGridCountPerGrid % 2 != 0) {
      throw Exception("subGridCountPerGrid");
    }

    if ((maxValue - minValue) % step != 0) {
      throw Exception("(maxValue - minValue)");
    }
    final int totalSubGridCount = (maxValue - minValue) ~/ step;

    if (totalSubGridCount % subGridCountPerGrid != 0) {
      throw Exception("(maxValue - minValue)~/step");
    }

    gridCount = totalSubGridCount ~/ subGridCountPerGrid + 1;

    gridWidth = subGridWidth * subGridCountPerGrid;

    listViewItemCount = gridCount + 2;

    paddingItemWidth = widgetWidth / 2 - gridWidth / 2;

    if (scaleTransformer == null) {
      scaleTransformer = (value) {
        return value.toString();
      };
    }
  }

  @override
  State<StatefulWidget> createState() {
    return HorizontalNumberPickerState();
  }
}

class HorizontalNumberPickerState extends State<HorizontalNumberPicker> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController(
      initialScrollOffset: (widget.initialValue - widget.minValue) /
          widget.step *
          widget.subGridWidth,
    );
  }

  @override
  void didUpdateWidget(HorizontalNumberPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    _scrollController?.dispose();
    _scrollController = ScrollController(
      initialScrollOffset: (widget.initialValue - widget.minValue) /
          widget.step *
          widget.subGridWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.widgetWidth.toDouble(),
      height: widget.widgetHeight.toDouble(),
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          NotificationListener(
            onNotification: _onNotification,
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.listViewItemCount,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0 || index == widget.listViewItemCount - 1) {
                  return SizedBox(
                    width: widget.paddingItemWidth,
                    height: 0,
                  );
                } else {
                  int type;

                  if (index == 1) {
                    type = 0;
                  } else if (index == widget.listViewItemCount - 2) {
                    type = 2;
                  } else {
                    type = 1;
                  }

                  return NumberPickerItem(
                    subGridCount: widget.subGridCountPerGrid,
                    subGridWidth: widget.subGridWidth,
                    itemHeight: widget.widgetHeight,
                    valueStr: widget.scaleTransformer(widget.minValue +
                        (index - 1) * widget.subGridCountPerGrid * widget.step),
                    type: type,
                    scaleColor: widget.scaleColor,
                    scaleTextColor: widget.scaleTextColor,
                  );
                }
              },
            ),
          ),
          // Positioned(
          //   bottom: 10,
          //   child: Container(
          //     width: 4,
          //     height: widget.widgetHeight / 8,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(30),
          //       color: widget.indicatorColor,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  bool _onNotification(Notification notification) {
    if (notification is ScrollNotification) {
      final int centerValue =
          (notification.metrics.pixels / widget.subGridWidth).round() *
                  widget.step +
              widget.minValue;

      widget.onSelectedChanged(centerValue);

      if (_scrollingStopped(notification, _scrollController)) {
        select(centerValue);
      }
    }

    return true;
  }

  bool _scrollingStopped(
    Notification notification,
    ScrollController scrollController,
  ) {
    return notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        scrollController.position.activity is! HoldScrollActivity;
  }

  //public------------------------------------------------------------------------

  select(int valueToSelect) {
    _scrollController.animateTo(
      (valueToSelect - widget.minValue) / widget.step * widget.subGridWidth,
      duration: Duration(milliseconds: 200),
      curve: Curves.decelerate,
    );
  }
}

//------------------------------------------------------------------------------

class NumberPickerItem extends StatelessWidget {
  final int subGridCount;
  final int subGridWidth;
  final int itemHeight;
  final String valueStr;

  final int type;

  final Color scaleColor;
  final Color scaleTextColor;

  const NumberPickerItem({
    Key key,
    @required this.subGridCount,
    @required this.subGridWidth,
    @required this.itemHeight,
    @required this.valueStr,
    @required this.type,
    @required this.scaleColor,
    @required this.scaleTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double itemWidth = (subGridWidth * subGridCount).toDouble();
    final double itemHeight = this.itemHeight.toDouble();

    return CustomPaint(
      size: Size(itemWidth, itemHeight),
      painter: MyPainter(this.subGridWidth, this.valueStr, this.type,
          this.scaleColor, this.scaleTextColor),
    );
  }
}

class MyPainter extends CustomPainter {
  final int subGridWidth;

  final String valueStr;

  final int type;

  final Color scaleColor;

  final Color scaleTextColor;

  Paint _linePaint;
  Paint _subLinePaint;

  final double _lineWidth = 3;

  MyPainter(this.subGridWidth, this.valueStr, this.type, this.scaleColor,
      this.scaleTextColor) {
    _linePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = _lineWidth
      ..color = scaleColor;
    _subLinePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = _lineWidth
      ..color = scaleColor.withOpacity(0.2);
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawLine(canvas, size);
    drawText(canvas, size);
  }

  void drawLine(Canvas canvas, Size size) {
    double startX, endX;
    switch (type) {
      case 0:
        startX = size.width / 2;
        endX = size.width;
        break;
      case 2:
        startX = 0;
        endX = size.width / 2;
        break;
      default:
        startX = 0;
        endX = size.width;
    }

    // canvas.drawLine(Offset(startX, 0 + _lineWidth / 2),
    //     Offset(endX, 0 + _lineWidth / 2), _linePaint);

    for (double x = startX; x <= endX; x += subGridWidth) {
      if (x == size.width / 2) {
        canvas.drawLine(
            Offset(x, 0), Offset(x, size.height * 3 / 8), _linePaint);
      } else {
        canvas.drawLine(
            Offset(x, 0), Offset(x, size.height / 4), _subLinePaint);
      }
    }
  }

  void drawText(Canvas canvas, Size size) {
    ui.Paragraph p = _buildText(valueStr, size.width);

    final double halfWidth = p.minIntrinsicWidth / 2;
    final double halfHeight = p.height / 2;
    canvas.drawParagraph(
        p, Offset(size.width / 2 - halfWidth, size.height - p.height * 2));
  }

  ui.Paragraph _buildText(String content, double maxWidth) {
    final ui.ParagraphBuilder paragraphBuilder =
        ui.ParagraphBuilder(ui.ParagraphStyle());
    paragraphBuilder.pushStyle(
      ui.TextStyle(
        fontSize: 18,
        color: this.scaleTextColor,
      ),
    );
    paragraphBuilder.addText(content);

    final ui.Paragraph paragraph = paragraphBuilder.build();
    paragraph.layout(ui.ParagraphConstraints(width: maxWidth));

    return paragraph;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
