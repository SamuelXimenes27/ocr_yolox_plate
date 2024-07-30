import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../shared/constants/constants.dart';
import '../shared/widgets/widgets.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: ColorsConst.infoColor,
        body: Center(
          child: Column(
            children: [
              const TextAndLineWidget(
                title: StringConst.errorTitlePage,
              ),
              SizedBox(height: size.height * 0.3),
              const Center(
                child: Text(
                  "Ocorreu um erro e não foi possível completar essa ação. Por favor, tente novamente.",
                  style: TextStyle(
                    color: ColorsConst.white100,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Modular.to.pushReplacementNamed(RoutesConst.home);
                  },
                  child: const Text(
                    StringConst.backToHomeLabel,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: ColorsConst.terciary,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.3),
              const LogoAndNameWidget()
            ],
          ),
        ),
      ),
    );
  }
}
