import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/constants/constants.dart';

class HomePageBodyWidget extends StatefulWidget {
  const HomePageBodyWidget({super.key});

  @override
  State<HomePageBodyWidget> createState() => _HomePageBodyWidgetState();
}

class _HomePageBodyWidgetState extends State<HomePageBodyWidget> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;

    return Observer(
      builder: (context) {
        return Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: size * 0.025,
                    bottom: size * 0.020,
                    top: size * 0.025,
                  ),
                  child: const Text(
                    StringConst.procedures,
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: size * 0.025),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: size * 0.015),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: ColorsConst.neutralColor29,
                          child: IconButton(
                            onPressed: () {
                              Modular.to.pushNamed(RoutesConst.ocr);
                            },
                            icon: SvgPicture.asset(
                              'assets/images/ocr.svg',
                              height: 35,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            StringConst.ocr,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
