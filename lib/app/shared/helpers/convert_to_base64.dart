import 'dart:io';
import 'dart:convert';

String convertToBase64(File image) {
  List<int> imageBytes = image.readAsBytesSync();
  String base64Image = base64Encode(imageBytes);
  return base64Image;
}
