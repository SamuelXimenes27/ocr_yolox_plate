import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';

class CustomFloatingButtonBlur extends StatelessWidget {
  final Widget? icon;
  final double? iconSize;
  final double? height;
  final double? width;
  final Function()? onPressed;
  const CustomFloatingButtonBlur({
    super.key,
    this.height = 75.0,
    this.width = 75.0,
    this.icon,
    this.iconSize = 38.0,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: BlurryContainer(
        blur: 5,
        width: 200,
        height: 200,
        elevation: 2,
        color: Colors.grey.withOpacity(0.25),
        padding: const EdgeInsets.all(8),
        borderRadius: const BorderRadius.all(Radius.circular(45)),
        child: IconButton(onPressed: onPressed, icon: icon!),
      ),
    );
  }
}
