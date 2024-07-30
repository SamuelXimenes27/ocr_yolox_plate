import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatefulWidget {
  final AlignmentGeometry? alignment;
  final void Function()? onPressed;
  final IconData? icon;
  final Object? heroTag;
  const CustomFloatingActionButton({
    super.key,
    this.alignment,
    this.heroTag,
    this.icon,
    this.onPressed,
  });

  @override
  State<CustomFloatingActionButton> createState() =>
      _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState
    extends State<CustomFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment!,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 30, 20, 0),
        child: FloatingActionButton(
          onPressed: widget.onPressed,
          backgroundColor: Colors.white,
          heroTag: widget.heroTag,
          child: Icon(
            widget.icon,
            color: const Color.fromRGBO(7, 46, 81, 1),
          ),
        ),
      ),
    );
  }
}
