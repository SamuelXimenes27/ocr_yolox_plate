import 'package:flutter/material.dart';

import '../../../shared/constants/colors_const.dart';
import 'plate_details.dart';

// ignore: must_be_immutable
class ExpandedWithCheckbox extends StatefulWidget {
  Function(bool?)? onChanged;
  Function()? onPressed;
  bool isChecked;
  bool haveWarning;
  bool? isUp;
  String? plate;
  String? brand;
  String? carName;
  String? carColor;
  ExpandedWithCheckbox({
    super.key,
    required this.isChecked,
    this.onPressed,
    this.haveWarning = false,
    this.isUp = true,
    this.onChanged,
    this.brand,
    this.carColor,
    this.carName,
    this.plate,
  });

  @override
  State<ExpandedWithCheckbox> createState() => _ExpandedWithCheckboxState();
}

class _ExpandedWithCheckboxState extends State<ExpandedWithCheckbox> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      height: widget.isUp! ? size.height * 0.05 : size.height * 0.14,
      width: size.width * 1,
      child: Align(
        alignment: Alignment.topCenter,
        child: Stack(
          children: [
            Row(
              children: <Widget>[
                Transform.scale(
                  scale: 1.18,
                  child: Container(
                    width: size.width * 0.1,
                  ),
                  // child: Checkbox(
                  //   activeColor: ColorsConst.infoColor,
                  //   value: widget.isChecked,
                  //   onChanged: (bool? newValue) {
                  //     if (newValue == true) {
                  //       setState(() {
                  //         store.addCountEntity();
                  //       });
                  //     } else if (newValue == false) {
                  //       setState(() {
                  //         store.removeCountEntity();
                  //       });
                  //     }
                  //     setState(() {
                  //       widget.isChecked = newValue!;
                  //     });
                  //   },
                  //   // onChanged: widget.onChanged,
                  // ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlateDetailsPage(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      SizedBox(
                          width: size.width * 0.52,
                          height: size.height * 0.025,
                          child: Text(
                            "${widget.plate}",
                            style: const TextStyle(
                              color: ColorsConst.infoColor,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                      SizedBox(
                          width: size.width * 0.07,
                          child: widget.haveWarning
                              ? const Icon(
                                  Icons.warning_amber_outlined,
                                  size: 18,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.warning_amber_outlined,
                                  size: 18,
                                  color: Colors.transparent,
                                )),
                      const Text('HÁ 1 MIN',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      SizedBox(
                        width: size.width * 0.08,
                        child: const Icon(
                          Icons.keyboard_double_arrow_right_outlined,
                          size: 24,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
