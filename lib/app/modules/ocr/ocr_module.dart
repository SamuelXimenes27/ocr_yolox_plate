import 'package:ocr_yolox_plate/app/modules/ocr/ocr_page.dart';
import 'package:ocr_yolox_plate/app/modules/ocr/ocr_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OcrModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(OcrStore.new);
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => const OcrPage(),
    );
  }
}
