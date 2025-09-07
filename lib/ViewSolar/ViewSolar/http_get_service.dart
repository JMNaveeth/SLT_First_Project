import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpGetService {
  final String baseUrl = 'https://powerprox.sltidc.lk/';
  final String panel = 'https://powerprox.sltidc.lk/GET_Panel_Information.php';
  final String solarSites = 'https://powerprox.sltidc.lk/GET_Solar_System.php';
  final String inverter = 'https://powerprox.sltidc.lk/GET_Grid_Inverter_Information.php';

  Future<List<Map<String, dynamic>>> getSiteData() async {
    try {
      final response = await http
          .get(Uri.parse(solarSites))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.cast<Map<String, dynamic>>();
      } else {
        print('Failed to fetch site data: ${response.statusCode}');
        print(response.body);
        throw Exception('Failed to fetch site data.');
      }
    } catch (e) {
      print('Error fetching site data: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getPanelsData() async {
    try {
      final response =
          await http.get(Uri.parse(panel)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.cast<Map<String, dynamic>>();
      } else {
        print('Failed to fetch panels data: ${response.statusCode}');
        print(response.body);
        throw Exception('Failed to fetch panels data.');
      }
    } catch (e) {
      print('Error fetching panels data: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getInverterData() async {
    try {
      final response = await http
          .get(Uri.parse(inverter))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.cast<Map<String, dynamic>>();
      } else {
        print('Failed to fetch inverter data: ${response.statusCode}');
        print(response.body);
        throw Exception('Failed to fetch inverter data.');
      }
    } catch (e) {
      print('Error fetching inverter data: $e');
      rethrow;
    }
  }

  Future<List<String>> getStationsByRegion(String region) async {
    try {
      List<Map<String, dynamic>> siteData = await getSiteData();
      List<String> stations = siteData
          .where((site) => site['region'] == region)
          .map((site) => site['station'] as String)
          .toSet()
          .toList();
      return stations;
    } catch (e) {
      throw Exception('Failed to load stations: $e');
    }
  }

  Future<List<String>> getRtomsByRegionAndStation(
      String region, String station) async {
    try {
      List<Map<String, dynamic>> siteData = await getSiteData();
      List<String> rtoms = siteData
          .where(
              (site) => site['region'] == region && site['station'] == station)
          .map((site) => site['rtom'] as String)
          .toSet()
          .toList();
      return rtoms;
    } catch (e) {
      throw Exception('Failed to load RTOMs: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getSolarData() async {
    try {
      final response = await http
          .get(Uri.parse(solarSites))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.cast<Map<String, dynamic>>();
      } else {
        print('Failed to fetch solar data: ${response.statusCode}');
        print(response.body);
        throw Exception('Failed to fetch solar data.');
      }
    } catch (e) {
      print('Error fetching solar data: $e');
      rethrow;
    }
  }

  Future<String?> getSiteId(String region, String station) async {
    try {
      List<Map<String, dynamic>> siteData = await getSiteData();
      Map<String, dynamic>? selectedSite = siteData.firstWhere(
        (site) => site['region'] == region && site['station'] == station,
        orElse: () => {},
      );
      return selectedSite?['site_id']?.toString();
    } catch (e) {
      throw Exception('Failed to get site ID: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getPanelsDataBySiteId(
      String siteId) async {
    final response = await http.get(Uri.parse('$panel?site_id=$siteId'));
    if (response.statusCode == 200) {
      try {
        List<dynamic> data = json.decode(response.body);
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        } else {
          throw Exception('Unexpected data format');
        }
      } catch (e) {
        throw Exception('Failed to parse panel data: $e');
      }
    } else {
      throw Exception(
          'Failed to load panel data: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  Future<List<Map<String, dynamic>>> getInverterDataBySiteId(
      String siteId) async {
    final response = await http.get(Uri.parse('$inverter?site_id=$siteId'));
    if (response.statusCode == 200) {
      try {
        List data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } catch (e) {
        throw Exception('Failed to parse inverter data: $e');
      }
    } else {
      throw Exception(
          'Failed to load inverter data: ${response.statusCode} ${response.reasonPhrase}');
    }
  }
}
import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpGetService {
  final String baseUrl = 'https://powerprox.sltidc.lk/';
  final String panel = 'https://powerprox.sltidc.lk/GET_Panel_Information.php';
  final String solarSites = 'https://powerprox.sltidc.lk/GET_Solar_System.php';
  final String inverter = 'https://powerprox.sltidc.lk/GET_Grid_Inverter_Information.php';

  Future<List<Map<String, dynamic>>> getSiteData() async {
    try {
      final response = await http
          .get(Uri.parse(solarSites))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.cast<Map<String, dynamic>>();
      } else {
        print('Failed to fetch site data: ${response.statusCode}');
        print(response.body);
        throw Exception('Failed to fetch site data.');
      }
    } catch (e) {
      print('Error fetching site data: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getPanelsData() async {
    try {
      final response =
          await http.get(Uri.parse(panel)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.cast<Map<String, dynamic>>();
      } else {
        print('Failed to fetch panels data: ${response.statusCode}');
        print(response.body);
        throw Exception('Failed to fetch panels data.');
      }
    } catch (e) {
      print('Error fetching panels data: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getInverterData() async {
    try {
      final response = await http
          .get(Uri.parse(inverter))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.cast<Map<String, dynamic>>();
      } else {
        print('Failed to fetch inverter data: ${response.statusCode}');
        print(response.body);
        throw Exception('Failed to fetch inverter data.');
      }
    } catch (e) {
      print('Error fetching inverter data: $e');
      rethrow;
    }
  }

  Future<List<String>> getStationsByRegion(String region) async {
    try {
      List<Map<String, dynamic>> siteData = await getSiteData();
      List<String> stations = siteData
          .where((site) => site['region'] == region)
          .map((site) => site['station'] as String)
          .toSet()
          .toList();
      return stations;
    } catch (e) {
      throw Exception('Failed to load stations: $e');
    }
  }

  Future<List<String>> getRtomsByRegionAndStation(
      String region, String station) async {
    try {
      List<Map<String, dynamic>> siteData = await getSiteData();
      List<String> rtoms = siteData
          .where(
              (site) => site['region'] == region && site['station'] == station)
          .map((site) => site['rtom'] as String)
          .toSet()
          .toList();
      return rtoms;
    } catch (e) {
      throw Exception('Failed to load RTOMs: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getSolarData() async {
    try {
      final response = await http
          .get(Uri.parse(solarSites))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.cast<Map<String, dynamic>>();
      } else {
        print('Failed to fetch solar data: ${response.statusCode}');
        print(response.body);
        throw Exception('Failed to fetch solar data.');
      }
    } catch (e) {
      print('Error fetching solar data: $e');
      rethrow;
    }
  }

  Future<String?> getSiteId(String region, String station) async {
    try {
      List<Map<String, dynamic>> siteData = await getSiteData();
      Map<String, dynamic>? selectedSite = siteData.firstWhere(
        (site) => site['region'] == region && site['station'] == station,
        orElse: () => {},
      );
      return selectedSite?['site_id']?.toString();
    } catch (e) {
      throw Exception('Failed to get site ID: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getPanelsDataBySiteId(
      String siteId) async {
    final response = await http.get(Uri.parse('$panel?site_id=$siteId'));
    if (response.statusCode == 200) {
      try {
        List<dynamic> data = json.decode(response.body);
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        } else {
          throw Exception('Unexpected data format');
        }
      } catch (e) {
        throw Exception('Failed to parse panel data: $e');
      }
    } else {
      throw Exception(
          'Failed to load panel data: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  Future<List<Map<String, dynamic>>> getInverterDataBySiteId(
      String siteId) async {
    final response = await http.get(Uri.parse('$inverter?site_id=$siteId'));
    if (response.statusCode == 200) {
      try {
        List data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } catch (e) {
        throw Exception('Failed to parse inverter data: $e');
      }
    } else {
      throw Exception(
          'Failed to load inverter data: ${response.statusCode} ${response.reasonPhrase}');
    }
  }
}
