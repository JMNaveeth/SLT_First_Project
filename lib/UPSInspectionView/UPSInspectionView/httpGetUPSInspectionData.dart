import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:powerprox/Screens/Other%20Assets/UPS/UPSInspectionView/ups_inspection_data.dart';
import 'package:theme_update/UPSInspectionView/UPSInspectionView/ups_inspection_data.dart';
// import 'package:powerprox/Screens/UPS/UPSInspectionView/ups_inspection_data.dart';


Future<List<UpsInspectionData>> upsFetchInspectionData() async {
  final response =
      await http.get(Uri.parse('https://powerprox.sltidc.lk/GETDailyUPSCheck.php'));
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    return body
        .map((dynamic item) => UpsInspectionData.fromJson(item))
        .toList();
  } else {
    throw Exception('Failed to load inspection data');
  }
}

Future<List<UpsRemarkData>> upsFetchRemarkData() async {
  final response =
      await http.get(Uri.parse('https://powerprox.sltidc.lk/GETDailyUPSRemarks.php'));
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    return body.map((dynamic item) => UpsRemarkData.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load remark data');
  }
}

Future<List<UPSDetails>> upsDetailsFetchData() async {
  final response =
      await http.get(Uri.parse('https://powerprox.sltidc.lk/GetUpsSystems.php'));
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    print(body.toString());

    return body.map((dynamic item) => UPSDetails.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load inspection data');
  }
}
