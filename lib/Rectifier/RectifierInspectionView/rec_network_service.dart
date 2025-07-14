import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:powerprox/Screens/Other%20Assets/Rectifier/RectifierInspectionView/rec_inspection_data.dart';
import 'package:theme_update/Rectifier/RectifierInspectionView/rec_inspection_data.dart';


Future<List<RecInspectionData>> recFetchInspectionData() async {
  final response =
      await http.get(Uri.parse('http://124.43.136.185:8000/api/rectifiers'));
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    return body
        .map((dynamic item) => RecInspectionData.fromJson(item))
        .toList();
  } else {
    throw Exception('Failed to load inspection data');
  }
}

Future<List<RecRemarkData>> recFetchRemarkData() async {
  final response =
      await http.get(Uri.parse('http://124.43.136.185:8000/api/rectifiers'));
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    return body.map((dynamic item) => RecRemarkData.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load remark data');
  }
}

Future<List<RectifierDetails>> rectifierDetailsFetchData() async {
  final response =
      await http.get(Uri.parse('https://powerprox.sltidc.lk/RectifierView.php'));
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    print(body.toString());

    return body.map((dynamic item) => RectifierDetails.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load inspection data');
  }
}
