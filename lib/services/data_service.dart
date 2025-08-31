import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/stop.dart';

class DataService {
  static Future<List<Stop>> loadStops() async {
    final data = await rootBundle.loadString('assets/mock/stops.json');
    final List<dynamic> jsonResult = json.decode(data);
    return jsonResult.map((e) => Stop.fromJson(e)).toList();
  }
}
