import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:image/image.dart' as imglib;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:ncnn_yolox_flutter/ncnn_yolox_flutter.dart';

import '../../database/db.dart';
import '../../shared/constants/constants.dart';
import '../../shared/helpers/helpers.dart';
import '../../shared/models/base64_image.dart';
import 'widgets/buttons/buttons.dart';
import 'widgets/widgets.dart';

part 'ocr_store.g.dart';

class OcrStore = OcrStoreBase with _$OcrStore;

abstract class OcrStoreBase with Store {
  @observable
  bool showFloatingCameraButtons = true;

  @observable
  bool showUpModalPhoto = false;

  @observable
  bool hasImage = false;

  @observable
  imglib.Image? croppedImage;

  @observable
  List<String> charactersPlate = [];

  @observable
  List<String> charactersOCR = [];

  @observable
  List<Map<String, double>> mapPlate = [{}];

  @observable
  List<String> sortedKeys = [];

  @observable
  LinkedHashMap? sortedMap;

  @observable
  String finalPlateValue = '';

  @observable
  TextEditingController detectionPlate = TextEditingController();

  @observable
  String vehicleType = "";

  @observable
  String country = "";

  @observable
  String status = "";

  @observable
  String plate = "";

  @observable
  String uf = "";

  @observable
  String chassi = "";

  @observable
  String renavam = "";

  @observable
  String brand = "";

  @observable
  String model = "";

  @observable
  String color = "";

  @observable
  String anoFabricacao = "";

  @observable
  String name = "";

  @observable
  String? alertString;

  @observable
  String engineSerial = '';

  @observable
  String cambioSerial = '';

  @observable
  String kindOfVehicle = '';

  @observable
  String category = '';

  @observable
  String modelYear = '';

  @observable
  String fuel = '';

  @observable
  String ufPlate = '';

  @observable
  String cmt = '';

  @observable
  String pbt = '';

  @observable
  String capacityCharge = '';

  @observable
  String bodyworkType = '';

  @observable
  String capacityPassager = '';

  @observable
  String potency = '';

  @observable
  String cylinders = '';

  @observable
  String qtyAxls = '';

  @observable
  String qtyAuxiliaryAxls = '';

  @observable
  String qtyBodyworkAxls = '';

  @observable
  String qtyRearAxls = '';

  @observable
  String situation = '';

  @observable
  String description = '';

  @observable
  String dropDate = '';

  @observable
  String procedure = '';

  @observable
  String chassiType = '';

  @observable
  String vendorCnpj = '';

  @observable
  String ufInvoicing = '';

  @observable
  String dateCrv = '';

  @observable
  String restriction = '';

  @observable
  String ownerName = '';

  @observable
  String ownerDoc = '';

  @observable
  CameraController? cameraController;

  @observable
  imglib.Image? imageCameraMode;

  @observable
  bool streamingDetecting = false;

  @observable
  bool cameraInitialized = false;

  @observable
  CameraImage? savedImage;

  @observable
  imglib.Image? imgCamera;

  @observable
  bool haveInternet = false;

  @observable
  int countSeletedHistoric = 0;

  @observable
  XFile? originalImage;

  @observable
  String confidencesOffline = '';

  @observable
  int count = 0;

  @observable
  int countPhotosStreaming = 0;

  @observable
  int intervaloFramesStreaming = 70;

  @observable
  int qtyFramesStreaming = 30;

  @observable
  int countQueryGet = 0;

  @observable
  List plateListStreaming = [];

  //State
  @observable
  PlateState? actualState = PlateState.loading;
  @observable
  CameraState? actualCameraState = CameraState.awaiting;

  // YoloX
  @observable
  List<YoloxResults> resultsPlate = [];

  @observable
  List<YoloxResults> resultsOCR = [];

  @observable
  imglib.Image? imageContainsOnlyPlate;

  @observable
  bool isMotorcycle = false;

  @observable
  List<String> labels = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  // HistoricPage
  @action
  addCountEntity() {
    countSeletedHistoric++;
  }

  // HistoricPage
  @action
  removeCountEntity() {
    countSeletedHistoric--;
  }

  @action
  editPlateValue(String plate) {
    finalPlateValue = plate;
  }

  @action
  redirectHistoricPage(context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoricPage(
          plateList: plateListStreaming,
        ),
      ),
    ).whenComplete(() {
      actualCameraState = CameraState.awaiting;
    });
  }

  @action
  redirectModalStreaming() {
    return ModalVehicleDetailsRecoding(
      showUp: true,
      lista: plateListStreaming,
      onPressedFloatingButton: () {
        countPhotosStreaming = 0;
        countQueryGet = 0;
        actualCameraState = CameraState.awaiting;
        streamingDetecting = false;
      },
    );
  }

  @action
  redirectImagePreview(imglib.Image? image, context) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ImagePreview(
                  img: image,
                  finalPlateValue: finalPlateValue,
                  detectionPlate: detectionPlate,
                  confidencesOffline: confidencesOffline,
                )));
  }

  @action
  getImage(
    bool cameraMode,
    cameraTaked,
  ) async {
    actualCameraState = CameraState.loading;

    mapPlate.clear();
    sortedMap?.clear();
    charactersPlate.clear();
    resultsOCR.clear();
    resultsPlate.clear();
    finalPlateValue = '';
    charactersOCR.clear();

    var uuid = const Uuid();
    NcnnYolox ncnn = NcnnYolox();

    Map<String, double> mapY = {};
    Map<String, double> mapX = {};
    String firstPartPlate = '';
    String secondPartPlate = '';

    List<Map<String, double>> listMapYTop3 = [];
    List<Map<String, double>> listMapXBottom4 = [];
    List<Map<String, double>> mapPlateX = [];
    List<Map<String, double>> mapPlateY = [];

    try {
      originalImage;

      if (originalImage == null) {
        actualCameraState = CameraState.awaiting;
      }

      // Camera Method
      Directory tempDirCamera = await getTemporaryDirectory();
      String tempPathCamera = tempDirCamera.path;

      if (originalImage != null || cameraTaked != null) {
        hasImage = false;
        cameraMode == true ? actualCameraState = CameraState.loading : null;
        cameraMode == true ? showFloatingCameraButtons = false : null;
      } else {
        return;
      }

      // Camera Method
      String imagePathCamera = tempPathCamera.split('cache/')[0].trim();
      String pathCamera = "$imagePathCamera/${uuid.v4()}.png";
      Uint8List? imageInUnit8ListCamera;
      cameraMode == true
          ? imageInUnit8ListCamera = imglib.encodeJpg(cameraTaked) as Uint8List
          : null;

      File? cameraImage;
      cameraMode == true ? cameraImage = await File(pathCamera).create() : null;
      cameraMode == true
          ? cameraImage!.writeAsBytesSync(imageInUnit8ListCamera!)
          : null;

      XFile sendImageCloud;
      sendImageCloud = XFile(cameraImage!.path);

      File? compressedFile = await compressAndGetFile(
          sendImageCloud.path, '${tempDirCamera.path}/${uuid.v4()}.jpg');

      if (haveInternet == true) {
        if (cameraMode) {
          // await sendData(XFile(compressedFile!.path), 'vehicle');
        }

        String img64 = convertToBase64(cameraImage);

        var dataForDB = Base64Image(base64Data: img64.toString());

        // Add image base64 into db
        if (img64.isNotEmpty) {
          await DB.instance.newBase64(dataForDB);
        }
        detectionPlate.text = finalPlateValue;
      } else {
        // PRIMEIRA CAMADA: Objetivo é identificar a placa
        imageCameraMode = cameraTaked;

        imglib.Image carImage = imageCameraMode!;

        try {
          await ncnn.initYolox(
            modelPath: 'assets/models/yolox_plate.bin',
            paramPath: 'assets/models/yolox_plate.param',
          );

          final decodeImagePlate = await decodeImageFromList(
            File(
              pathCamera,
            ).readAsBytesSync(),
          );

          final pixelsPlate = (await decodeImagePlate.toByteData(
            format: ui.ImageByteFormat.rawRgba,
          ))!
              .buffer
              .asUint8List();

          resultsPlate = ncnn.detect(
            pixels: pixelsPlate,
            pixelFormat: PixelFormat.rgba,
            width: decodeImagePlate.width,
            height: decodeImagePlate.height,
          );

          ncnn.dispose();

          for (final result in resultsPlate) {
            imageContainsOnlyPlate = imglib.copyCrop(
              carImage,
              result.x.round(),
              result.y.round(),
              result.width.round(),
              result.height.round(),
            );

            if (result.width / result.height > 1.6) {
              isMotorcycle = false;
            } else if (result.width / result.height <= 1.6) {
              isMotorcycle = true;
            }
          }

          Uint8List imageInUnit8List =
              imglib.encodeJpg(imageContainsOnlyPlate!) as Uint8List;
          File? file;
          file = await File(pathCamera).create();
          file.writeAsBytesSync(imageInUnit8List);
        } catch (e) {
          debugPrint(e.toString());
        }

        if (resultsPlate.isNotEmpty) {
          // SEGUNDA CAMADA: Objetivo é identificar o caractere
          await ncnn.initYolox(
            modelPath: 'assets/models/yolox_ocr.bin',
            paramPath: 'assets/models/yolox_ocr.param',
          );

          final decodeImageOCR = await decodeImageFromList(
            File(
              pathCamera,
            ).readAsBytesSync(),
          );

          final pixelsOCR = (await decodeImageOCR.toByteData(
            format: ui.ImageByteFormat.rawRgba,
          ))!
              .buffer
              .asUint8List();

          resultsOCR = ncnn.detect(
            pixels: pixelsOCR,
            pixelFormat: PixelFormat.rgba,
            width: decodeImageOCR.width,
            height: decodeImageOCR.height,
          );

          for (final e in resultsOCR) {
            try {
              mapX = {};
              mapX[labels[e.label]] = e.x;
              mapPlateX.add(mapX);

              mapPlateX
                  .sort((a, b) => a.values.first.compareTo(b.values.first));

              mapY = {};
              mapY[labels[e.label]] = e.y;
              mapPlateY.add(mapY);
              mapPlateY
                  .sort((a, b) => a.values.first.compareTo(b.values.first));
              charactersPlate.add(labels[e.label]);
              charactersOCR.add(e.prob.toString());
            } catch (e) {}

            if (isMotorcycle == false) {
              Map<String, double> map = {};
              map[labels[e.label]] = e.x;

              mapPlate.add(map);

              mapPlate.sort((a, b) => a.values.first.compareTo(b.values.first));

              sortedKeys = mapPlate.map((e) => e.keys.first).toList();

              finalPlateValue = sortedKeys.join('');
            }
          }

          if (isMotorcycle == true) {
            try {
              // Add the 3 first entries based on Y (First/Up part of the plate)
              for (int i = 0; i < 3; i++) {
                listMapYTop3.addAll([mapPlateY[i]]);
              }
              List<Map<String, double>> listMapYTop3Updated = [];
              for (var entry in listMapYTop3) {
                String key = entry.keys.first;
                double value = entry.values.first;
                listMapYTop3Updated.addAll(mapPlateX
                    .where((x) => x.containsKey(key))
                    .map((x) => {key: x[key]!}));
              }

              //Removing repeated value entries
              Set<double> uniqueValuesTop = {};
              listMapYTop3Updated.removeWhere((entry) {
                if (uniqueValuesTop.contains(entry.values.first)) {
                  return true;
                } else {
                  uniqueValuesTop.add(entry.values.first);
                  return false;
                }
              });

              //Sorting the list from minor to major
              listMapYTop3Updated
                  .sort((a, b) => a.values.first.compareTo(b.values.first));

              for (Map<String, double> entry in listMapYTop3Updated) {
                firstPartPlate += entry.keys.first;
              }

              // Add the 4 last entries based on Y (Second/Bottom part of the plate)
              for (int i = mapPlateY.length - 4; i < mapPlateY.length; i++) {
                listMapXBottom4.addAll([mapPlateY[i]]);
              }
              List<Map<String, double>> listMapYBottom4Updated = [];
              for (var entry in listMapXBottom4) {
                String key = entry.keys.first;
                double value = entry.values.first;
                listMapYBottom4Updated.addAll(mapPlateX
                    .where((x) => x.containsKey(key))
                    .map((x) => {key: x[key]!}));
              }

              //Removing repeated value entries
              Set<double> uniqueValuesBottom = {};
              listMapYBottom4Updated.removeWhere((entry) {
                if (uniqueValuesBottom.contains(entry.values.first)) {
                  return true;
                } else {
                  uniqueValuesBottom.add(entry.values.first);
                  return false;
                }
              });

              listMapYBottom4Updated
                  .sort((a, b) => a.values.first.compareTo(b.values.first));

              for (Map<String, double> entry in listMapYBottom4Updated) {
                secondPartPlate += entry.keys.first;
              }

              finalPlateValue = '$firstPartPlate$secondPartPlate';
            } catch (e) {}
          }
        } else {}

        try {
          List confidenceList = charactersOCR
              .map((number) =>
                  '${(double.parse(number) * 100).toStringAsFixed(2)}%')
              .toList();

          confidencesOffline = confidenceList.join(', ');
        } catch (e) {}
      }

      croppedImage = imageCameraMode;
      hasImage = true;
      // statictics.updateStatistics("ocr");
      actualCameraState = CameraState.awaiting;
      showFloatingCameraButtons = false;
      showUpModalPhoto = true;
      ncnn.dispose();
    } catch (e) {
      actualCameraState = CameraState.awaiting;
    }
    actualCameraState = CameraState.awaiting;
  }

  @action
  Future processCameraStreaming(CameraImage image, context) async {
    if (streamingDetecting == true) {
      count += 1;

      imglib.Image? img;

      var uuid = const Uuid();

      if (count == intervaloFramesStreaming) {
        countPhotosStreaming += 1;

        if (image.format.group == ImageFormatGroup.yuv420) {
          img = convertYUV420(image);
        } else if (image.format.group == ImageFormatGroup.bgra8888) {
          img = convertBGRA8888(image);
        }

        Directory tempDirCamera = await getTemporaryDirectory();
        var tempPathCamera = '${tempDirCamera.path}precompress.jpg';

        Uint8List imageInUnit8List = imglib.encodeJpg(img!) as Uint8List;
        File? file;
        file = await File(tempPathCamera).create();
        file.writeAsBytesSync(imageInUnit8List);

        XFile sendImagesCloud;
        sendImagesCloud = XFile(file.path);
        File? compressedFile = await compressAndGetFile(
            sendImagesCloud.path, '${tempDirCamera.path}/${uuid.v4()}.jpg');
        // await sendData(XFile(compressedFile!.path), 'image').whenComplete(() {
        //   countQueryGet++;
        //   if (countQueryGet == qtyFramesStreaming) {
        //     Future.delayed(const Duration(seconds: 3))
        //         .then((value) => redirectHistoricPage(context))
        //         .whenComplete(() {
        //       countPhotosStreaming = 0;
        //       countQueryGet = 0;
        //       plateListStreaming.clear();
        //     });
        //   }
        // });

        count = 0;
      }

      if (countPhotosStreaming == qtyFramesStreaming) {
        streamingDetecting = false;
      }
    }
  }

  @action
  Future<File?> compressAndGetFile(String file, String targetPath) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file,
      targetPath,
      quality: 90,
      minWidth: 1024,
      minHeight: 1024,
    );

    return result;
  }

  @action
  imglib.Image convertBGRA8888(CameraImage image) {
    return imglib.Image.fromBytes(
      image.width,
      image.height,
      image.planes[0].bytes,
      format: imglib.Format.bgra,
    );
  }

  @action
  imglib.Image convertYUV420(CameraImage cameraImage) {
    final imageWidth = cameraImage.width;
    final imageHeight = cameraImage.height;

    final yBuffer = cameraImage.planes[0].bytes;
    final uBuffer = cameraImage.planes[1].bytes;
    final vBuffer = cameraImage.planes[2].bytes;

    final int yRowStride = cameraImage.planes[0].bytesPerRow;
    final int yPixelStride = cameraImage.planes[0].bytesPerPixel!;

    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final imglib.Image image = imglib.Image(imageWidth, imageHeight);

    for (int h = 0; h < imageHeight; h++) {
      int uvh = (h / 2).floor();

      for (int w = 0; w < imageWidth; w++) {
        int uvw = (w / 2).floor();

        final yIndex = (h * yRowStride) + (w * yPixelStride);

        // Y plane should have positive values belonging to [0...255]
        final int y = yBuffer[yIndex];

        // U/V Values are subsampled i.e. each pixel in U/V chanel in a
        // YUV_420 image act as chroma value for 4 neighbouring pixels
        final int uvIndex = (uvh * uvRowStride) + (uvw * uvPixelStride);

        // U/V values ideally fall under [-0.5, 0.5] range. To fit them into
        // [0, 255] range they are scaled up and centered to 128.
        // Operation below brings U/V values to [-128, 127].
        final int u = uBuffer[uvIndex];
        final int v = vBuffer[uvIndex];

        // Compute RGB values per formula above.
        int r = (y + v * 1436 / 1024 - 179).round();
        int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
        int b = (y + u * 1814 / 1024 - 227).round();

        r = r.clamp(0, 255);
        g = g.clamp(0, 255);
        b = b.clamp(0, 255);

        // Use 255 for alpha value, no transparency. ARGB values are
        // positioned in each byte of a single 4 byte integer
        // [AAAAAAAARRRRRRRRGGGGGGGGBBBBBBBB]
        final int argbIndex = h * imageWidth + w;

        image.data[argbIndex] = 0xff000000 |
            ((b << 16) & 0xff0000) |
            ((g << 8) & 0xff00) |
            (r & 0xff);
      }
    }

    return image;
  }

  showPopUp(context) async {
    final prefs = await SharedPreferences.getInstance();
    bool seen = prefs.getBool('seen') ?? false;

    if (seen) {
      return;
    }
    if (!await hasInternetConnection()) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Center(
                child: Text(
                  'Aviso',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: ColorsConst.infoColor1,
                  ),
                ),
              ),
              content: const Text(
                'Alinhe o dispositivo com a placa do veículo para um melhor resultado',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              actions: <Widget>[
                Center(
                  child: SizedBox(
                    width: 100,
                    height: 50,
                    child: ButtonOutlinedWidget(
                      onPressed: () {
                        prefs.setBool('seen', true);
                        Navigator.pop(context);
                      },
                      title: 'Ok'.toUpperCase(),
                      colorText: const Color.fromRGBO(7, 46, 81, 1),
                      backgroundColor: Colors.white,
                    ),
                  ),
                )
              ],
            );
          });
    }
  }
}

enum CameraState { loading, awaiting, detecting, hasData }

enum PlateState { loading, success, error, awaiting }
