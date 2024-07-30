import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image/image.dart' as imglib;
import 'package:mobx/mobx.dart';
import '../ocr_store.dart';

import '../../../shared/constants/colors_const.dart';
import 'widgets.dart';

const String yolo = "Tiny YOLOv2 Plate";

// ignore: must_be_immutable
class ImagePreview extends StatefulWidget {
  final imglib.Image? img;
  String? finalPlateValue;
  final bool? plateNotFound;
  final String? confidencesOffline;
  final String? firstConfidence;
  final String? secondConfidence;
  final String? thirdConfidence;
  final String? fourthConfidence;
  final String? fifthConfidence;
  final String? sixthConfidence;
  final String? seventhConfidence;
  final TextEditingController? detectionPlate;

  ImagePreview({
    super.key,
    required this.img,
    this.finalPlateValue,
    this.plateNotFound,
    this.firstConfidence,
    this.secondConfidence,
    this.thirdConfidence,
    this.fourthConfidence,
    this.fifthConfidence,
    this.sixthConfidence,
    this.seventhConfidence,
    this.detectionPlate,
    this.confidencesOffline,
  });

  @override
  State<ImagePreview> createState() => ImagePreviewState();
}

class ImagePreviewState extends State<ImagePreview> {
  final OcrStore store = Modular.get();

  bool showFloatingCameraButtons = true;
  bool showUpModalPhoto = true;
  bool showUpModalRecording = false;
  bool stolen = false;
  bool plateNotFound = false;
  bool isRecording = false;

  ReactionDisposer? disposer;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double? scale = size.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Image.memory(imglib.encodeJpg(widget.img!) as Uint8List),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 20, 0),
                child: FloatingActionButton(
                  heroTag: 'btnBack',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color.fromRGBO(7, 46, 81, 1),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: store.finalPlateValue.isNotEmpty ||
                        store.finalPlateValue != ''
                    ? 80
                    : 150,
                right: 20),
            child: Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                  width: 30,
                  height: 30,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white60,
                    onPressed: null,
                    child: Transform.scale(
                      scale: 0.7,
                      child: Image.asset(
                        'assets/images/database_icon.png',
                        color: ColorsConst.infoColor,
                      ),
                    ),
                  )),
            ),
          ),
          Observer(builder: (context) {
            return ModalVehicleDetails(
              onPressedSave: () {},
              onPressedAnotherVehicle: () {
                store.actualCameraState = CameraState.awaiting;

                Navigator.pop(context);
              },
              onPressedIsNotTheVehicle: () {
                Navigator.pop(context);
              },
              onPressedSearch: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlateDetailsPage(),
                  ),
                );
              },
              onPressedEdit: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Editar Placa'),
                        content: TextField(
                          onChanged: (value) {
                            store.alertString = value;
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(8)
                          ],
                          controller: widget.detectionPlate,
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsConst.infoColor),
                            child: const Text('Confirmar'),
                            onPressed: () {
                              store.editPlateValue(store.alertString!);

                              setState(() {
                                widget.finalPlateValue = store.alertString!;

                                Navigator.pop(context);
                              });
                            },
                          ),
                        ],
                      );
                    });
              },
              finalPlateValue: widget.finalPlateValue!,
              showUp: showUpModalPhoto,
              confidencesOffline: widget.confidencesOffline!,
            );
          }),
        ],
      ),
    );
  }
}
