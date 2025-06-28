import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class FormLoaderRepository {
  /// [assetPath] `
  Future<List<Map<String, dynamic>>> loadFromAsset(String assetPath) async {
    final jsonStr = await rootBundle.loadString(assetPath);
    final raw = jsonDecode(jsonStr) as List<dynamic>;
    return raw.cast<Map<String, dynamic>>();
  }
}
