import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/constants/colors_const.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../ocr_store.dart';
import 'buttons/buttons.dart';

class PlateDetailsPage extends StatefulWidget {
  const PlateDetailsPage({
    super.key,
  });

  @override
  State<PlateDetailsPage> createState() => _PlateDetailsPageState();
}

class _PlateDetailsPageState extends State<PlateDetailsPage> {
  final store = Modular.get<OcrStore>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'CONSULTA DETALHADA',
            style: TextStyle(
              color: ColorsConst.infoColor,
            ),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: ColorsConst.infoColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
          backgroundColor: const Color(0x00ffffff),
          elevation: 0,
        ),
        body: Observer(builder: (context) {
          if (store.actualState == PlateState.loading) {
            return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: LoadingWidget(),
                ));
          } else if (store.actualState == PlateState.success) {
            return const SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                    child: Stack(
                  children: [
                    // Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: [
                    //       Observer(builder: (context) {
                    //         if (store.showDialogOccurrences) {
                    //           return ListView.builder(
                    //             physics: const NeverScrollableScrollPhysics(),
                    //             shrinkWrap: true,
                    //             itemCount: store.vehicleOccurrences.length,
                    //             itemBuilder: (context, index) {
                    //               return WarningDetail(
                    //                 iconColor: Color(
                    //                   int.parse(
                    //                     convertToColor(
                    //                       store.vehicleOccurrences[index]
                    //                           .nivelAlerta
                    //                           .toString(),
                    //                     ).replaceAll('#', '0xff'),
                    //                   ),
                    //                 ),
                    //                 icon: Icons.warning,
                    //                 title: store
                    //                     .vehicleOccurrences[index].descricao!,
                    //               );
                    //             },
                    //           );
                    //         } else {
                    //           return Container();
                    //         }
                    //       }),
                    //       store.isBaseSinal == true
                    //           ? const Center(
                    //               child: Text(
                    //                 'Consulta feita na Base SINAL',
                    //                 style: TextStyle(
                    //                   fontWeight: FontWeight.w900,
                    //                 ),
                    //               ),
                    //             )
                    //           : Container(),
                    //       store.status.isNotEmpty && store.status != 'null'
                    //           ? informationText("STATUS", store.status)
                    //           : Container(),
                    //       store.plate.isNotEmpty && store.plate != 'null'
                    //           ? informationText("PLACA", store.plate)
                    //           : Container(),
                    //       store.chassi.isNotEmpty
                    //           ? informationText("CHASSI", store.chassi)
                    //           : Container(),
                    //       store.engineSerial.isNotEmpty
                    //           ? informationText("Nº MOTOR", store.engineSerial)
                    //           : Container(),
                    //       store.cambioSerial.isNotEmpty
                    //           ? informationText(
                    //               "Nº CAIXA CÂMBIO", store.cambioSerial)
                    //           : Container(),
                    //       store.renavam.isNotEmpty
                    //           ? informationText("RENAVAM", store.renavam)
                    //           : Container(),
                    //       store.brand.isNotEmpty && store.model.isNotEmpty
                    //           ? informationText("MARCA/MODELO",
                    //               "${store.brand}/${store.model}")
                    //           : Container(),
                    //       store.color.isNotEmpty && store.color != 'null'
                    //           ? informationText("COR", store.color)
                    //           : Container(),
                    //       store.category.isNotEmpty
                    //           ? informationText("CATEGORIA", store.category)
                    //           : Container(),
                    //       store.anoFabricacao.isNotEmpty &&
                    //               store.anoFabricacao != 'null'
                    //           ? informationText(
                    //               "ANO Fabricação", store.anoFabricacao)
                    //           : Container(),
                    //       store.modelYear.isNotEmpty
                    //           ? informationText("ANO MODELO", store.modelYear)
                    //           : Container(),
                    //       store.fuel.isNotEmpty
                    //           ? informationText("COMBUSTÍVEL", store.fuel)
                    //           : Container(),
                    //       store.ufPlate.isNotEmpty
                    //           ? informationText(
                    //               "MUNICÍPIO EMPLACAMENTO/UF", store.ufPlate)
                    //           : Container(),
                    //       store.bodyworkType.isNotEmpty
                    //           ? informationText(
                    //               "TIPO DE CARROCERIA", store.bodyworkType)
                    //           : Container(),
                    //       store.cmt.isNotEmpty
                    //           ? informationText("CMT", store.cmt)
                    //           : Container(),
                    //       store.pbt.isNotEmpty
                    //           ? informationText("PBT", store.pbt)
                    //           : Container(),
                    //       store.capacityCharge.isNotEmpty
                    //           ? informationText(
                    //               "CAPAC. DE CARGA", store.capacityCharge)
                    //           : Container(),
                    //       store.capacityPassager.isNotEmpty
                    //           ? informationText("CAPAC. DE PASSAGEIRO",
                    //               store.capacityPassager)
                    //           : Container(),
                    //       store.potency.isNotEmpty
                    //           ? informationText("POTENCIA", store.potency)
                    //           : Container(),
                    //       store.cylinders.isNotEmpty
                    //           ? informationText("CILINDRADAS", store.cylinders)
                    //           : Container(),
                    //       store.qtyAxls.isNotEmpty
                    //           ? informationText(
                    //               "NUMERO DE EIXOS", store.qtyAxls)
                    //           : Container(),
                    //       store.qtyAuxiliaryAxls.isNotEmpty
                    //           ? informationText("NUMERO DE EIXOS AUXILIARES",
                    //               store.qtyAuxiliaryAxls)
                    //           : Container(),
                    //       store.qtyBodyworkAxls.isNotEmpty
                    //           ? informationText("NUMERO DE EIXOS CARROCERIA",
                    //               store.qtyBodyworkAxls)
                    //           : Container(),
                    //       store.qtyRearAxls.isNotEmpty
                    //           ? informationText("NUMERO DE EIXOS TRASEIROS",
                    //               store.qtyRearAxls)
                    //           : Container(),
                    //       store.situation.isNotEmpty &&
                    //               store.situation != 'null'
                    //           ? informationText("SITUAÇÃO", store.situation)
                    //           : Container(),
                    //       store.description.isNotEmpty &&
                    //               store.description != 'null'
                    //           ? informationText("DESCRIÇÃO", store.description)
                    //           : Container(),
                    //       store.dropDate.isNotEmpty
                    //           ? informationText("DATA DA BAIXA", store.dropDate)
                    //           : Container(),
                    //       store.procedure.isNotEmpty
                    //           ? informationText(
                    //               "PROCEDÊNCIA DO VEÍCULO", store.procedure)
                    //           : Container(),
                    //       store.chassiType.isNotEmpty
                    //           ? informationText("TIPO DE REMARCAÇÃO DO CHASSI",
                    //               store.chassiType)
                    //           : Container(),
                    //       store.vendorCnpj.isNotEmpty
                    //           ? informationText(
                    //               "CNPJº VENDEDOR", store.vendorCnpj)
                    //           : Container(),
                    //       store.ufInvoicing.isNotEmpty
                    //           ? informationText(
                    //               "UF DE FATURAMENTO", store.ufInvoicing)
                    //           : Container(),
                    //       store.dateCrv.isNotEmpty
                    //           ? informationText(
                    //               "DATA EMISSÃO DO CRV", store.dateCrv)
                    //           : Container(),
                    //       store.restriction.isNotEmpty
                    //           ? informationSection("RESTRIÇÕES")
                    //           : Container(),
                    //       store.restriction.isNotEmpty
                    //           ? informationText(
                    //               "RESTRIÇÃO 1", store.restriction)
                    //           : Container(),
                    //       store.ownerName.isNotEmpty ||
                    //               store.ownerDoc.isNotEmpty
                    //           ? informationSection("PROPRIETÁRIO")
                    //           : Container(),
                    //       store.ownerName.isNotEmpty ||
                    //               store.ownerDoc.isNotEmpty
                    //           ? informationText(
                    //               'Nome do proprietário', store.ownerName)
                    //           : Container(),
                    //       store.ownerDoc.isNotEmpty
                    //           ? informationText(
                    //               "CPF/CNPJ proprietário", store.ownerDoc)
                    //           : Container(),
                    //       const SizedBox(
                    //         height: 15,
                    //       ),
                    //       store.isBaseSinal == true
                    //           ? store.status == 'null' &&
                    //                   store.plate == 'null' &&
                    //                   store.color == 'null' &&
                    //                   store.anoFabricacao == 'null' &&
                    //                   store.situation == 'null' &&
                    //                   store.description == 'null'
                    //               ? const Center(
                    //                   child: Text(
                    //                     'Sem registro na Base SINAL',
                    //                   ),
                    //                 )
                    //               : Container()
                    //           : Container(),
                    //     ])
                  ],
                )),
              ),
            );
          } else if (store.actualState == PlateState.error) {
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 50,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Ocorreu um erro ao buscar os dados, clique abaixo para voltar",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          ButtonWidget(
                            onPressed: () => {Navigator.pop(context)},
                            title: 'Voltar',
                          )
                        ],
                      ),
                    ),
                  ),
                ));
          } else {
            return Container();
          }
        }));
  }

  Widget informationSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 12),
      child: Text(
        '--$title',
        style: const TextStyle(
          color: Color.fromRGBO(51, 65, 85, 1),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget informationText(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${key.toUpperCase()}: ',
              style: const TextStyle(
                color: ColorsConst.black100,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: value.toUpperCase(),
              style: const TextStyle(
                color: ColorsConst.neutralColor2,
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }
}
