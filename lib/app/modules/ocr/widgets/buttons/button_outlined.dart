import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonOutlinedWidget extends StatelessWidget {
  final Function() onPressed;
  final String title;
  Color backgroundColor;
  Color colorText;
  Color borderSideColor;

  ButtonOutlinedWidget({
    super.key,
    required this.onPressed,
    required this.title,
    required this.backgroundColor,
    required this.colorText,
    this.borderSideColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          minimumSize: Size(
            double.infinity,
            MediaQuery.of(context).size.width * 0.15,
          ),
          side: BorderSide(color: borderSideColor)),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
          color: colorText,
        ),
      ),
    );
  }
}
