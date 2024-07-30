import 'package:flutter/material.dart';

import '../../../../shared/constants/constants.dart';

class ButtonWidget extends StatelessWidget {
  final Function()? onPressed;
  final String title;
  final double? height;
  final bool disable;

  const ButtonWidget({
    super.key,
    required this.onPressed,
    required this.title,
    this.height,
    this.disable = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: disable ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsConst.infoColor,
        minimumSize: Size(
          double.infinity,
          height != null ? height! : MediaQuery.of(context).size.width * 0.15,
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
