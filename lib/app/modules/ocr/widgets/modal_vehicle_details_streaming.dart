import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/constants/constants.dart';
import '../ocr_store.dart';
import 'buttons/buttons.dart';

class ModalVehicleDetailsRecoding extends StatefulWidget {
  final bool showUp;
  final dynamic Function() onPressedFloatingButton;
  final List? lista;
  const ModalVehicleDetailsRecoding({
    super.key,
    this.showUp = true,
    required this.onPressedFloatingButton,
    this.lista,
  });

  @override
  State<ModalVehicleDetailsRecoding> createState() =>
      _ModalVehicleDetailsRecodingState();
}

class _ModalVehicleDetailsRecodingState
    extends State<ModalVehicleDetailsRecoding> {
  final OcrStore store = Modular.get();
  bool stolen = false;
  bool plateNotFound = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    List<Widget> plateSliders = store.plateListStreaming
        .map(
          (item) => Container(
            margin: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      width: size.width * 0.78,
                      decoration: const BoxDecoration(
                        color: ColorsConst.white80,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            color: ColorsConst.infoColor,
                            width: size.width * 0.75,
                            height: size.height * 0.11,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.55,
                                    height: size.height * 0.1,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 42,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();

    return Stack(
      children: [
        widget.showUp == true
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: CustomFloatingButtonBlur(
                        icon: const Icon(
                          Icons.stop,
                          color: ColorsConst.white100,
                          size: 38,
                        ),
                        height: 90.0,
                        width: 90.0,
                        iconSize: 52.0,
                        onPressed: widget.onPressedFloatingButton,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  SizedBox(
                    width: size.width * 0.78,
                    height: size.height * 0.12,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        initialPage: store.plateListStreaming.length - 1,
                      ),
                      items: plateSliders,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: CustomFloatingButtonBlur(
                        icon: const Icon(
                          Icons.stop,
                          color: ColorsConst.white100,
                          size: 38,
                        ),
                        height: 90.0,
                        width: 90.0,
                        iconSize: 52.0,
                        onPressed: widget.onPressedFloatingButton,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: size.width * 0.78,
                      height: size.height * 0.12,
                      color: ColorsConst.white80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            color: ColorsConst.infoColor,
                            width: size.width * 0.75,
                            height: size.height * 0.105,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: size.width * 0.55,
                                height: size.height * 0.1,
                                child: const Text(
                                  'Iniciando a captura',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
      ],
    );
  }
}
