import 'package:flutter/material.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

import '../constants/colors_const.dart';

class LoadingWidget extends StatefulWidget {
  final Color lineColor;

  const LoadingWidget({super.key, this.lineColor = ColorsConst.infoColor});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: WidgetCircularAnimator(
        innerColor: widget.lineColor,
        outerColor: widget.lineColor,
        child: Image.asset(
          'assets/images/Gif_app_SM2.0.gif',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
