import 'dart:convert';

import 'package:http/http.dart' as http;
import 'ac_details_model.dart';

Future<List<AcIndoorData>> fetchAcIndoorData() async {
  final response = await http
      .get(Uri.parse('https://powerprox.sltidc.lk/GET_AC_Indoor_Units.php'));
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    return body.map((dynamic item) => AcIndoorData.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load AC indoor data');
  }
}

Future<List<AcOutdoorData>> fetchAcOutdoorData() async {
  final response = await http
      .get(Uri.parse('https://powerprox.sltidc.lk/GET_AC_Outdoor_Units.php'));
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    return body.map((dynamic item) => AcOutdoorData.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load AC outdoor data');
  }
}

Future<List<AcLogData>> fetchAcLogData() async {
  final response =
      await http.get(Uri.parse('https://powerprox.sltidc.lk/GET_AC_Connection.php'));
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    return body.map((dynamic item) => AcLogData.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load AC log data');
  }
}

Future<List<PrecisionAC>> fetchPrecisionAcData() async {
  final response =
      await http.get(Uri.parse('https://powerprox.sltidc.lk/GET_PrecisionAC.php'));

  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    return body.map((dynamic item) => PrecisionAC.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load AC log data');
  }
}
