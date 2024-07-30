import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../ocr_store.dart';
import '../../../shared/constants/colors_const.dart';

import 'buttons/button_outlined.dart';
import 'buttons/button_widget.dart';

class ModalVehicleDetails extends StatefulWidget {
  final bool showUp;
  final List? confidencesValues;
  final String? confidencesOffline;
  final String finalPlateValue;
  final Function() onPressedSave;
  final Function() onPressedAnotherVehicle;
  final Function() onPressedIsNotTheVehicle;
  final Function() onPressedSearch;
  final Function() onPressedEdit;

  const ModalVehicleDetails({
    super.key,
    this.showUp = true,
    required this.onPressedIsNotTheVehicle,
    required this.finalPlateValue,
    required this.onPressedAnotherVehicle,
    required this.onPressedSave,
    required this.onPressedSearch,
    required this.onPressedEdit,
    this.confidencesOffline,
    this.confidencesValues,
  });

  @override
  State<ModalVehicleDetails> createState() => ModalVehicleDetailsState();
}

class ModalVehicleDetailsState extends State<ModalVehicleDetails> {
  final OcrStore store = Modular.get();

  bool stolen = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return DraggableScrollableSheet(
        initialChildSize: 0.2,
        minChildSize: 0.13,
        maxChildSize: 1.0,
        builder: (BuildContext context, ScrollController scrollController) {
          return ListView(
            children: [
              widget.showUp == true
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 5,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: size.width * 1,
                              height: widget.finalPlateValue.isNotEmpty ||
                                      widget.finalPlateValue != ''
                                  ? size.height * 0.125
                                  : size.height * 0.06,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: widget.finalPlateValue.isNotEmpty ||
                                        widget.finalPlateValue != ''
                                    ? ColorsConst.infoColor
                                    : ColorsConst.warning8,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  widget.finalPlateValue.isNotEmpty ||
                                          widget.finalPlateValue != ''
                                      ? Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      widget.finalPlateValue,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 42,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed:
                                                          widget.onPressedEdit,
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                IconButton(
                                                  onPressed:
                                                      widget.onPressedSearch,
                                                  icon: const Icon(
                                                    Icons.search,
                                                    color: Colors.white,
                                                    size: 38,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Wrap(
                                                  spacing: 2,
                                                  children: [
                                                    confidenceOfflineValues(
                                                        widget
                                                            .confidencesOffline!)
                                                  ],
                                                )
                                              ],
                                            )
                                          ]),
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Center(
                                            child: Text(
                                              'Não conseguiu identificar'
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            ),
                            stolen == true
                                ? Container(
                                    width: size.width * 1,
                                    height: size.height * 0.1,
                                    color: Colors.red,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 0, 0),
                                          child: Row(
                                            children: [
                                              Wrap(
                                                spacing: 90,
                                                children: [
                                                  Text(
                                                    "Roubado/Furtado \n"
                                                            .toUpperCase() +
                                                        "Sinal 72h"
                                                            .toUpperCase(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                      Icons.arrow_upward,
                                                      color: Colors.white,
                                                      size: 38,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            const Divider(
                              height: 15,
                              thickness: 1,
                            ),
                            ButtonOutlinedWidget(
                              onPressed: widget.onPressedAnotherVehicle,
                              title: 'Fiscalizar outro veiculo'.toUpperCase(),
                              colorText: const Color.fromRGBO(7, 46, 81, 1),
                              backgroundColor: Colors.white,
                            ),
                            const SizedBox(height: 10),
                            widget.finalPlateValue.isNotEmpty ||
                                    widget.finalPlateValue != ''
                                ? ButtonWidget(
                                    onPressed: widget.onPressedSave,
                                    title: 'Salvar para vincular'.toUpperCase(),
                                  )
                                : Container(),
                            widget.finalPlateValue.isNotEmpty ||
                                    widget.finalPlateValue != ''
                                ? const SizedBox(height: 10)
                                : Container(),
                            ButtonOutlinedWidget(
                              onPressed: widget.onPressedIsNotTheVehicle,
                              title: 'Não é o veiculo abordado'.toUpperCase(),
                              colorText: Colors.red,
                              backgroundColor: Colors.white,
                              borderSideColor: Colors.red,
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    )
                  : Container()
            ],
          );
        });
  }

  Widget confidenceOfflineValues(String title) {
    return Text(
      title != '' ? title : '',
      style: const TextStyle(
        fontSize: 11,
        color: Colors.white,
      ),
    );
  }
}
