import 'package:flutter/material.dart';

import '../shared/constants/constants.dart';
import '../shared/widgets/logo_and_name_widget.dart';
import '../shared/widgets/text_and_line_widget.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

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
                title: StringConst.loadingTitlePage,
              ),
              SizedBox(height: size.height * 0.35),
              const Center(
                child: CircularProgressIndicator(
                  color: ColorsConst.white100,
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
