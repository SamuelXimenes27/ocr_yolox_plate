import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../shared/constants/constants.dart';
import '../styles/themes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(const Duration(seconds: 2), () async {
        Modular.to.pushReplacementNamed(RoutesConst.home);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              ColorsConst.infoColor1,
              ColorsConst.neutralColor2,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(size.width * 0.16, 0, 0, 0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/logo_mobile_systems_white.png',
                      scale: size.height * 0.009,
                    ),
                    SizedBox(width: size.width * 0.01),
                    Text(
                      "Sistemas Móveis",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorsConst.white100,
                        fontSize: size.height * 0.037,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.03),
              SizedBox(
                width: size.width * 0.7,
                child: Text(
                  StringConst.splash,
                  style: AppThemes.lightTheme.textTheme.headlineMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
