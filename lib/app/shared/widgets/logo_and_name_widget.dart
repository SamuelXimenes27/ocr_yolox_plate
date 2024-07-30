import 'package:flutter/material.dart';

import '../constants/constants.dart';

class LogoAndNameWidget extends StatelessWidget {
  const LogoAndNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/app.png'),
        SizedBox(
          width: size.width * 0.01,
          height: size.height * 0.06,
        ),
        const Text(StringConst.app,
            style: TextStyle(
              color: ColorsConst.white100,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ))
      ],
    );
  }
}
