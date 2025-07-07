import 'dart:convert';
import 'package:http/http.dart' as http;

import 'deg_inspection_data.dart';



Future<List<DegInspectionData>> degFetchInspectionData() async {
  try {
    // Print the URL being called
    print('Calling API: http://124.43.136.185:8000/api/dailyDEGCheck');
    
    final response = await http.get(
      Uri.parse('http://124.43.136.185:8000/api/dailyDEGCheck'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 30));

    // Print response details
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // Try to parse the JSON
      List<dynamic> body;
      try {
        body = json.decode(response.body);
      } catch (e) {
        print('JSON decode error: $e');
        throw Exception('Failed to parse response data');
      }

      // Map the data
      return body.map((dynamic item) {
        print('Processing item: $item'); // Debug print
        return DegInspectionData.fromJson(item);
      }).toList();
    } else {
      print('Server returned error code: ${response.statusCode}');
      throw Exception('Server returned status code ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching inspection data: $e');
    throw Exception('Failed to load inspection data: $e');
  }
}

Future<List<DegRemarkData>> degFetchRemarkData() async {
  try {
    print('Calling API: http://124.43.136.185:8000/api/dailyDEGRemarks');
    
    final response = await http.get(
      Uri.parse('http://124.43.136.185:8000/api/dailyDEGRemarks'),  // Remove .php
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 30));

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => DegRemarkData.fromJson(item)).toList();
    } else {
      throw Exception('Server returned status code ${response.statusCode}');
    }
  } catch (e) {
 print('Error fetching remark data: $e');
    throw Exception('Failed to load remark data: $e');
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
