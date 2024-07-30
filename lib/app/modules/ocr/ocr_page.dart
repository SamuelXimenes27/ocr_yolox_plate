import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:ocr_yolox_plate/app/modules/ocr/ocr_store.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as imglib;
import 'package:ffi/ffi.dart' as ff;

import '../../shared/constants/constants.dart';
import '../../shared/widgets/widgets.dart';
import 'widgets/buttons/buttons.dart';
import 'widgets/widgets.dart';

typedef ConvertFunc = Pointer<Uint32> Function(
    Pointer<Uint8>, Pointer<Uint8>, Pointer<Uint8>, Int32, Int32, Int32, Int32);
typedef Convert = Pointer<Uint32> Function(
    Pointer<Uint8>, Pointer<Uint8>, Pointer<Uint8>, int, int, int, int);

class OcrPage extends StatefulWidget {
  final String title;
  const OcrPage({super.key, this.title = 'OcrPage'});
  @override
  OcrPageState createState() => OcrPageState();
}

class OcrPageState extends State<OcrPage> {
  final OcrStore store = Modular.get();

  final DynamicLibrary convertImageLib = Platform.isAndroid
      ? DynamicLibrary.open("libconvertImage.so")
      : DynamicLibrary.process();
  late Convert conv;

  @override
  void initState() {
    super.initState();
    _initializeCamera();

    conv = convertImageLib
        .lookup<NativeFunction<ConvertFunc>>('convertImage')
        .asFunction<Convert>();

    Future.delayed(const Duration(seconds: 1), () => store.showPopUp(context));
  }

  @override
  void dispose() {
    store.cameraInitialized = false;
    store.cameraController!.dispose();
    super.dispose();
  }

  _initializeCamera() async {
    List<CameraDescription> cameras = await availableCameras();
    store.cameraController =
        CameraController(cameras[0], ResolutionPreset.veryHigh);
    store.cameraController!.initialize().then((_) async {
      await store.cameraController!.startImageStream((CameraImage image) =>
          store.streamingDetecting == true
              ? store.processCameraStreaming(image, context)
              : store.savedImage = image);
      setState(() {
        store.cameraInitialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double? scale = size.aspectRatio / 0.5;

    if (scale < 1) scale = 1 / scale;

    return SafeArea(
        child: Scaffold(
      body: Observer(builder: (context) {
        if (store.actualCameraState == CameraState.loading) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: CustomFloatingActionButton(
                  alignment: Alignment.topLeft,
                  heroTag: 'btnBackDisabled',
                  icon: Icons.arrow_back,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const LoadingWidget(),
            ],
          );
        } else if (store.actualCameraState == CameraState.awaiting) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Transform.scale(
                  scale: scale,
                  child: store.cameraInitialized
                      ? CameraPreview(store.cameraController!)
                      : const Center(
                          child: LoadingWidget(),
                        )),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: CustomFloatingActionButton(
                  alignment: Alignment.topLeft,
                  heroTag: 'btnBack',
                  icon: Icons.arrow_back,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              store.actualCameraState == CameraState.loading
                  ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: const LoadingWidget(),
                    )
                  : Container(),
            ],
          );
        } else if (store.actualCameraState == CameraState.detecting) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Transform.scale(
                  scale: scale,
                  child: store.cameraInitialized
                      ? CameraPreview(store.cameraController!)
                      : const Center(
                          child: LoadingWidget(),
                        )),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: CustomFloatingActionButton(
                  alignment: Alignment.topLeft,
                  heroTag: 'btnBack',
                  icon: Icons.arrow_back,
                  onPressed: () {
                    // Navigator.popAndPushNamed(context, RoutesConst.home);
                    Navigator.pop(context);
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ModalVehicleDetailsRecoding(
                    showUp: false,
                    onPressedFloatingButton: () {
                      setState(() {
                        store.actualCameraState = CameraState.awaiting;
                        store.streamingDetecting = false;
                      });
                    },
                  )
                ],
              )
            ],
          );
        } else if (store.actualCameraState == CameraState.hasData) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Transform.scale(
                  scale: scale,
                  child: store.cameraInitialized
                      ? CameraPreview(store.cameraController!)
                      : const Center(
                          child: LoadingWidget(),
                        )),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: CustomFloatingActionButton(
                  alignment: Alignment.topLeft,
                  heroTag: 'btnBack',
                  icon: Icons.arrow_back,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, RoutesConst.home);
                    // Navigator.pop(context);
                  },
                ),
              ),
              CustomFloatingActionButton(
                alignment: Alignment.topRight,
                heroTag: 'btnHistoric',
                icon: Icons.restore,
                onPressed: () {
                  store.redirectHistoricPage(context);
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  store.redirectModalStreaming(),
                ],
              )
            ],
          );
        } else {
          return Container();
        }
      }),
      floatingActionButton: Observer(
        builder: (context) {
          if (store.actualCameraState == CameraState.awaiting) {
            return _floatingActionButton()!;
          } else {
            return Container();
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ));
  }

  Widget? _floatingActionButton() {
    final size = MediaQuery.of(context).size;
    imglib.Image? resizedImage;

    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 120, right: 20),
        child: Align(
          alignment: Alignment.bottomRight,
          child: SizedBox(
            width: 30,
            height: 30,
            child: FloatingActionButton(
              backgroundColor: Colors.white60,
              onPressed: null,
              heroTag: 'btnModel',
              child: Transform.scale(
                scale: 0.7,
                child: Image.asset(
                  'assets/images/database_icon.png',
                  color: ColorsConst.infoColor,
                ),
              ),
            ),
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            widthFactor: size.width * 0.0027,
            alignment: Alignment.bottomRight,
            child: Wrap(
              spacing: 15,
              children: [
                CustomFloatingButtonBlur(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: ColorsConst.white100,
                    size: 38,
                  ),
                  height: 90.0,
                  width: 90.0,
                  iconSize: 42.0,
                  onPressed: () async {
                    store.streamingDetecting = false;

                    setState(() {
                      Pointer<Uint8> p = ff.calloc
                          .allocate(store.savedImage!.planes[0].bytes.length);
                      Pointer<Uint8> p1 = ff.calloc
                          .allocate(store.savedImage!.planes[1].bytes.length);
                      Pointer<Uint8> p2 = ff.calloc
                          .allocate(store.savedImage!.planes[2].bytes.length);

                      // Assign the planes data to the pointers of the image
                      Uint8List pointerList = p.asTypedList(
                          store.savedImage!.planes[0].bytes.length);
                      Uint8List pointerList1 = p1.asTypedList(
                          store.savedImage!.planes[1].bytes.length);
                      Uint8List pointerList2 = p2.asTypedList(
                          store.savedImage!.planes[2].bytes.length);
                      pointerList.setRange(
                          0,
                          store.savedImage!.planes[0].bytes.length,
                          store.savedImage!.planes[0].bytes);
                      pointerList1.setRange(
                          0,
                          store.savedImage!.planes[1].bytes.length,
                          store.savedImage!.planes[1].bytes);
                      pointerList2.setRange(
                          0,
                          store.savedImage!.planes[2].bytes.length,
                          store.savedImage!.planes[2].bytes);

                      // Call the convertImage function and convert the YUV to RGB
                      Pointer<Uint32> imgP = conv(
                          p,
                          p1,
                          p2,
                          store.savedImage!.planes[1].bytesPerRow,
                          store.savedImage!.planes[1].bytesPerPixel!,
                          store.savedImage!.width,
                          store.savedImage!.height);
                      // Get the pointer of the data returned from the function to a List
                      List<int> imgData = imgP.asTypedList(
                          (store.savedImage!.planes[0].bytesPerRow *
                              store.savedImage!.height));

                      // Generate image from the converted data
                      store.imgCamera = imglib.Image.fromBytes(
                          store.savedImage!.height,
                          store.savedImage!.width,
                          imgData);

                      // Free the memory space allocated
                      // from the planes and the converted data
                      ff.calloc.free(p);
                      ff.calloc.free(p1);
                      ff.calloc.free(p2);
                      ff.calloc.free(imgP);

                      resizedImage = imglib.copyResize(store.imgCamera!,
                          width: 1080, height: 1920);

                      store.showFloatingCameraButtons = false;
                      store.actualCameraState = CameraState.loading;
                    });

                    await store
                        .getImage(
                          true,
                          resizedImage,
                        )
                        .then((value) =>
                            store.redirectImagePreview(resizedImage, context));
                  },
                ),
                CustomFloatingButtonBlur(
                    icon: const Image(
                      image: AssetImage('assets/images/record_icon.png'),
                    ),
                    height: 90.0,
                    width: 90.0,
                    iconSize: 42.0,
                    onPressed: () {
                      setState(() {
                        store.streamingDetecting = true;
                        store.plateListStreaming.clear();
                        store.actualCameraState = CameraState.detecting;
                      });
                    }),
              ],
            ),
          ),
        ],
      ),
    ]);
  }
}
