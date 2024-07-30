import 'dart:convert';

class Datas {
  static final List<String> values = [id, base64data];
  static const String id = 'id';
  static const String base64data = 'base64data';
}

Base64Image base64FromJson(String str) {
  final jsonData = json.decode(str);
  return Base64Image.fromMap(jsonData);
}

String base64ToJson(Base64Image data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Base64Image {
  int? id;
  String? base64Data;

  Base64Image({
    this.id,
    this.base64Data,
  });

  factory Base64Image.fromMap(Map<String, dynamic> json) => Base64Image(
        id: json["id"],
        base64Data: json["base64_image"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "base64_image": base64Data.toString(),
      };
}
