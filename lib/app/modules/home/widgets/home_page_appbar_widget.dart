import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/constants/constants.dart';

class HomePageAppbarWidget extends StatefulWidget {
  const HomePageAppbarWidget({super.key});

  @override
  State<HomePageAppbarWidget> createState() => _HomePageAppbarWidgetState();
}

class _HomePageAppbarWidgetState extends State<HomePageAppbarWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        color: ColorsConst.infoColor,
        child: Padding(
          padding: EdgeInsets.only(
            top: size.height * 0.08,
            left: size.height * 0.025,
            right: size.height * 0.025,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                      radius: 30,
                      backgroundColor: ColorsConst.white100,
                      child: IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          'assets/images/brasao.svg',
                          height: 35,
                        ),
                      )),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, bottom: 20.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Text(
                                '${StringConst.hello}, ${StringConst.user}',
                                style: TextStyle(
                                    color: ColorsConst.white100,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.0),
                              ),
                              SizedBox(
                                width: size.width * 0.01,
                              ),
                              SvgPicture.asset(
                                'assets/images/medalha.svg',
                              ),
                              SvgPicture.asset(
                                'assets/images/medalha.svg',
                              ),
                              SvgPicture.asset(
                                'assets/images/medalha.svg',
                              ),
                            ],
                          ),
                        ]),
                  )),
            ],
          ),
        ));
  }
}
