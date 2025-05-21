import 'dart:convert';
import 'package:http/http.dart' as http;

import 'deg_inspection_data.dart';



Future<List<DegInspectionData>> degFetchInspectionData() async {
  final response =
      await http.get(Uri.parse('https://powerprox.sltidc.lk/GETDailyDEGCheck.php'));
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    return body
        .map((dynamic item) => DegInspectionData.fromJson(item))
        .toList();
  } else {
    throw Exception('Failed to load inspection data');
  }
}

Future<List<DegRemarkData>> degFetchRemarkData() async {
  final response =
      await http.get(Uri.parse('https://powerprox.sltidc.lk/GETDailyDEGRemarks.php'));
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    return body.map((dynamic item) => DegRemarkData.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load remark data');
  }
}

Future<List<DEGDetails>> degDetailsFetchData() async {
  final response =
      await http.get(Uri.parse('https://powerprox.sltidc.lk/GETGenerators.php'));
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    print(body.toString());

    return body.map((dynamic item) => DEGDetails.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load inspection data');
  }
}
