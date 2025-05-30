import 'dart:convert';
import 'package:http/http.dart' as http;

import 'generator_details_model.dart';

Future<List<Generator>> GeneratorFetchData() async {
  final response =
      await http.get(Uri.parse('https://powerprox.sltidc.lk/GETGenerators.php'));
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    print(body.toString());

    return body.map((dynamic item) => Generator.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load inspection data');
  }
}
