import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../ocr_store.dart';
import 'expanded_with_checkbox.dart';

class HistoricPage extends StatefulWidget {
  final String title;
  final List? plateList;

  const HistoricPage({
    super.key,
    this.title = "Historic",
    this.plateList,
  });

  @override
  HistoricPageState createState() => HistoricPageState();
}

class HistoricPageState extends State<HistoricPage> {
  final store = Modular.get<OcrStore>();

  @override
  void initState() {
    super.initState();
    store.countSeletedHistoric = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isChecked = false;
    List? items = widget.plateList;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            store.countPhotosStreaming = 0;
            store.countQueryGet = 0;
            Modular.to.pop();
          },
          icon: const Icon(Icons.close),
        ),
        backgroundColor: const Color.fromRGBO(7, 46, 81, 1),
        title: const Text('HISTÓRICO DE VIDEOMONITORAMENTO',
            style: TextStyle(
              overflow: TextOverflow.visible,
              fontSize: 15,
            )),
      ),
      body: ListView.builder(
        itemCount: items!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(3),
            child: Column(
              children: [
                ExpandedWithCheckbox(
                  isChecked: isChecked,
                  plate: items[index],
                ),
                const Divider(
                  color: Colors.black,
                  height: 10,
                )
              ],
            ),
          );
        },
      ),
      // bottomSheet: Observer(
      //   builder: (context) {
      //     return Container(
      //         decoration: const BoxDecoration(
      //           color: Colors.white,
      //           boxShadow: [
      //             BoxShadow(
      //               color: Colors.black26,
      //               blurRadius: 10,
      //               offset: Offset(0, 0),
      //             ),
      //           ],
      //         ),
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Padding(
      //               padding:
      //                   const EdgeInsets.only(left: 10, top: 15, bottom: 20),
      //               child: SizedBox(
      //                 child: RichText(
      //                   text: TextSpan(
      //                     children: [
      //                       const TextSpan(
      //                         text: 'ENTIDADES SELECIONADAS:   ',
      //                         style: TextStyle(
      //                           fontSize: 14,
      //                           fontFamily: 'Lexend',
      //                           color: Color.fromRGBO(7, 46, 81, 1),
      //                         ),
      //                       ),
      //                       WidgetSpan(
      //                         child: Image.asset(
      //                           'assets/images/carIcon.png',
      //                           scale: 0.9,
      //                         ),
      //                       ),
      //                       TextSpan(
      //                         text: " ${store.countSeletedHistoric}",
      //                         style: const TextStyle(
      //                           fontSize: 14,
      //                           fontFamily: 'Lexend',
      //                           color: Color.fromRGBO(7, 46, 81, 1),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             Padding(
      //               padding:
      //                   const EdgeInsets.only(left: 10, right: 10, bottom: 20),
      //               child: ButtonWidgetIcon(
      //                 icon: const Image(
      //                   image:
      //                       AssetImage('assets/images/iconVideoHistoric.png'),
      //                 ),
      //                 onPressed: () {},
      //                 title: 'Incluir Procedimento'.toUpperCase(),
      //                 colorText: Colors.white,
      //                 backgroundColor: const Color.fromRGBO(7, 46, 81, 1),
      //               ),
      //             ),
      //           ],
      //         ));
      //   },
      // ),
    );
  }
}
