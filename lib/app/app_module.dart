import 'package:flutter_modular/flutter_modular.dart';

import 'modules/modules.dart';
import 'pages/pages.dart';
import 'shared/constants/constants.dart';

class AppModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.module(Modular.initialRoute, module: HomeModule());
    r.child(Modular.initialRoute, child: (context) => const SplashPage());
    r.child(RoutesConst.errorPage, child: (context) => const ErrorPage());
    r.module(RoutesConst.home, module: HomeModule());
    r.module(RoutesConst.ocr, module: OcrModule());
  }
}
