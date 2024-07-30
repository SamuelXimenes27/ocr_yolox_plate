import 'package:flutter/material.dart';

import '../constants/colors_const.dart';

class TextAndLineWidget extends StatelessWidget {
  const TextAndLineWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.10),
      child: Container(
        width: size.width * 0.85,
        padding: const EdgeInsets.fromLTRB(10, 0, 15, 10),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: ColorsConst.white100,
              width: 2.5,
            ),
          ),
        ),
        child: Center(
          child: Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ColorsConst.white100,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
