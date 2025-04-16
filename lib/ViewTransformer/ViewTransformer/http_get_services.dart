import 'dart:convert';
import 'package:http/http.dart' as http;

import 'search_helper_transformer.dart';

class HttpGetServices {
  static const String transformerUrl =
      'https://powerprox.sltidc.lk/GETTransformer.php';
  static const String regionUrl =
      'https://powerprox.sltidc.lk/GETLocationRegion.php';
  static const String rtomUrl =
      'https://powerprox.sltidc.lk/GETLocationRTOM.php';

  static Future<List<Map<String, dynamic>>> getTransformers() async {
    final response = await http.get(Uri.parse(transformerUrl));
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  }

  static Future<List<Map<String, dynamic>>> getRegions() async {
    final response = await http.get(Uri.parse(regionUrl));
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  }

  static Future<List<Map<String, dynamic>>> getRTOMs() async {
    final response = await http.get(Uri.parse(rtomUrl));
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  }

  static Future<List<Map<String, dynamic>>> getTransformersByQuery(
      String query) async {
    final response = await http.get(Uri.parse(transformerUrl));
    final allTransformers =
        List<Map<String, dynamic>>.from(json.decode(response.body));

    return allTransformers
        .where((transformer) =>
            SearchHelperTransformer.matchesTransformerQuery(transformer, query))
        .toList();
  }
}

//v2
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class HttpGetServices {
//   static const String transformerUrl =
//       'https://powerprox.sltidc.lk/GETTransformer.php';
//   static const String regionUrl =
//       'https://powerprox.sltidc.lk/GETLocationRegion.php';
//   static const String rtomUrl =
//       'https://powerprox.sltidc.lk/GETLocationRTOM.php';
//
//   static Future<List<Map<String, dynamic>>> getTransformers() async {
//     final response = await http.get(Uri.parse(transformerUrl));
//     return List<Map<String, dynamic>>.from(json.decode(response.body));
//   }
//
//   static Future<List<Map<String, dynamic>>> getRegions() async {
//     final response = await http.get(Uri.parse(regionUrl));
//     return List<Map<String, dynamic>>.from(json.decode(response.body));
//   }
//
//   static Future<List<Map<String, dynamic>>> getRTOMs() async {
//     final response = await http.get(Uri.parse(rtomUrl));
//     return List<Map<String, dynamic>>.from(json.decode(response.body));
//   }
// }

//v1
// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
//
// class HttpService {
//   Future<List<String>> getStationsByRegion(String region) async {
//     try {
//       List siteData = await getTransformerData();
//       List<String> stations = siteData
//           .where((site) => site['Region'] == region)
//           .map((site) => site['Station'] as String)
//           .toSet()
//           .toList();
//       return stations;
//     } catch (e) {
//       throw Exception('Failed to load stations: $e');
//     }
//   }
//
//   Future<List<String>> getRtomsByRegionAndStation(
//       String region, String station) async {
//     try {
//       List siteData = await getTransformerData();
//       List<String> rtoms = siteData
//           .where(
//               (site) => site['Region'] == region && site['Station'] == station)
//           .map((site) => site['RTOM'] as String)
//           .toSet()
//           .toList();
//       return rtoms;
//     } catch (e) {
//       throw Exception('Failed to load RTOMs: $e');
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> getTransformerData() async {
//     try {
//       final response = await http
//           .get(
//             Uri.parse('https://powerprox.sltidc.lk/GETTransformer.php'),
//           )
//           .timeout(const Duration(seconds: 30));
//
//       if (response.statusCode == 200) {
//         // Decode the JSON data and cast to List<Map<String, dynamic>>
//         final List<dynamic> data = jsonDecode(response.body);
//
//         // Ensure that every element in the list is a map
//         final List<Map<String, dynamic>> transformerData =
//             data.map((item) => item as Map<String, dynamic>).toList();
//
//         print('Transformer data retrieved successfully.');
//         print(transformerData); // Optional: Print the retrieved data
//
//         return transformerData;
//       } else {
//         print('Failed to retrieve transformer data: ${response.statusCode}');
//         throw Exception('Failed to retrieve transformer data.');
//       }
//     } catch (e) {
//       print('Error retrieving transformer data: $e');
//       rethrow;
//     }
//   }
// }
