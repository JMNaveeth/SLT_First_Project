import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import '../../ACMaintenancePage.dart';
import 'AddIndoorOutdoorUnits.dart';


class HttpPostAc {
  static const String indoorUrl = 'https://powerprox.sltidc.lk/POST_AC_Indoor_Units.php';
  static const String outdoorUrl = 'https://powerprox.sltidc.lk/POST_AC_Outdoor_Units.php';
  static const String getIndoorUrl = 'https://powerprox.sltidc.lk/GET_AC_Indoor_Units.php';
  static const String getOutdoorUrl = 'https://powerprox.sltidc.lk/GET_AC_Outdoor_Units.php';
  static const String connectionUrl = 'https://powerprox.sltidc.lk/POST_AC_Connection.php';

  static Future<bool> postIndoorUnits(Map<String, dynamic> indoorData) async {
    try {
      final response = await http.post(Uri.parse(indoorUrl), body: indoorData).timeout(Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> postOutdoorUnits(Map<String, dynamic> outdoorData) async {
    try {
      final response = await http.post(Uri.parse(outdoorUrl), body: outdoorData).timeout(Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getIndoorUnits() async {
    try {
      final response = await http.get(Uri.parse(getIndoorUrl)).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to load indoor units');
      }
    } catch (e) {
      print('Error fetching indoor units: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getOutdoorUnits() async {
    try {
      final response = await http.get(Uri.parse(getOutdoorUrl)).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to load outdoor units');
      }
    } catch (e) {
      print('Error fetching outdoor units: $e');
      return [];
    }
  }
}

class HttpPostAcUnits extends StatefulWidget {
  final Map<String, dynamic> formDataList;
  final String ? User;

  HttpPostAcUnits({required this.formDataList,required this.User});

  @override
  _HttpPostAcUnitsState createState() => _HttpPostAcUnitsState(formDataList: formDataList, User: User);
}

class _HttpPostAcUnitsState extends State<HttpPostAcUnits> {
  final Map<String, dynamic> formDataList;
  String ? User;

  _HttpPostAcUnitsState({required this.formDataList, required this.User});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _uploadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: Colors.green),
      ),
    );
  }

  void _uploadData() async {
    final uploader = DataUploader(formDataList,User);
    bool success = await uploader.uploadData(context);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(isSuccess: success),
      ),
    );
  }
}


class DataUploader {
  final Map<String, dynamic> _formData;
  final String ? User;

  DataUploader(this._formData,this.User);

  Future<bool> uploadData(BuildContext context) async {
    final indoorData = {
      'region': _formData['region'] ?? '',
      'rtom': _formData['rtom'] ?? '',
      'station': _formData['station'] ?? '',
      'rtom_building_id': _formData['rtom_building_id'] ?? '',
      'floor_number': _formData['indoor_floor_number'] ?? '',
      'office_number': _formData['indoor_office_number'] ?? '',
      'location': _formData['indoor_location'] ?? '',
      'brand': _formData['indoor_brand'] ?? '',
      'model': _formData['indoor_model'] ?? '',
      'capacity': _formData['indoor_capacity'] ?? '',
      'serial_number': _formData['serial_number'] ?? 'Pending',
      'installation_type': _formData['installation_type'] ?? '',
      'refrigerant_type': _formData['refrigerant_type'] ?? '',
      'power_supply': _formData['indoor_power_supply'] ?? '',
      'warranty_expiry_date': _formData['indoor_warranty_expiry_date'] ?? '',
      'installation_date': _formData['installation_date'] ?? '',
      'supplier_name': _formData['indoor_supplier_name'] ?? '',
      'po_number': _formData['indoor_po_number'] ?? 'Pending',
      'remote_available': _formData['remote_available'] ?? '',
      'notes': _formData['indoor_notes'] ?? '',
      'status': _formData['indoor_status'] ?? '0',
      'no_AC_plants': _formData['no_AC_plants'] ?? '',
      'DoM': _formData['DoM'] ?? '',
      'condition_ID_unit': _formData['condition_ID_unit'] ?? '',
      'Type': _formData['Type'] ?? 'C',
      'category': _formData['category'] ?? '',
      'QR_In': _formData['QR_In'] ?? '',
      'uploaded_by': _formData['uploaded_by']=User,

      // 'User': User,
    };

    final outdoorData = {
      'brand': _formData['brand'] ?? '',
      'model': _formData['model'] ?? '',
      'capacity': _formData['capacity'] ?? '',
      'outdoor_fan_model': _formData['outdoor_fan_model'] ?? '',
      'power_supply': _formData['outdoor_power_supply'] ?? '',
      'compressor_mounted_with': _formData['compressor_mounted_with'] ?? '',
      'compressor_capacity': _formData['compressor_capacity'] ?? '',
      'compressor_brand': _formData['compressor_brand'] ?? '',
      'compressor_model': _formData['compressor_model'] ?? '',
      'compressor_serial_number': _formData['compressor_serial_number'] ?? 'Pending',
      'supplier_name': _formData['outdoor_supplier_name'] ?? '',
      'po_number': _formData['outdoor_po_number'] ?? 'Pending',
      'notes': _formData['outdoor_notes'] ?? '',
      'status': _formData['outdoor_status'] ?? '0',
      'Installation_Date': _formData['Installation_Date'] ?? '',
      'warranty_expiry_date': _formData['outdoor_warranty_expiry_date'] ?? '',
      'no_AC_plants': _formData['no_AC_plants'] ?? '',
      'DoM': _formData['DoM'] ?? '',
      'condition_OD_unit': _formData['condition_OD_unit'] ?? '',
      'Type': _formData['Type'] ?? 'C',
      'category': _formData['category'] ?? '',
      'QR_Out': _formData['QR_Out'] ?? '',
      'uploaded_by': _formData['uploaded_by']=User,
    };

    try {
      final indoorSuccess = await HttpPostAc.postIndoorUnits(indoorData);
      final outdoorSuccess = await HttpPostAc.postOutdoorUnits(outdoorData);

      if (!indoorSuccess || !outdoorSuccess) {
        return false;
      }

      final indoorUnits = await HttpPostAc.getIndoorUnits();
      final outdoorUnits = await HttpPostAc.getOutdoorUnits();

      final indoorDataFetched = indoorUnits.isNotEmpty ? indoorUnits.last : null;
      final outdoorDataFetched = outdoorUnits.isNotEmpty ? outdoorUnits.last : null;

      if (indoorDataFetched == null || outdoorDataFetched == null) {
        throw Exception('No indoor or outdoor data available');
      }

      final acIndoorId = indoorDataFetched['ac_indoor_id']?.toString() ?? '';
      final acOutdoorId = outdoorDataFetched['ac_outdoor_id']?.toString() ?? '';

      final connectionData = {
        'ac_indoor_id': acIndoorId,
        'ac_outdoor_id': acOutdoorId,
        'region': _formData['region'] ?? '',
        'rtom': _formData['rtom'] ?? '',
        'station': _formData['station'] ?? '',
        'rtom_building_id': _formData['rtom_building_id'] ?? '',
        'floor_number': _formData['indoor_floor_number'] ?? '',
        'office_number': _formData['indoor_office_number'] ?? '',
        'location': _formData['indoor_location'] ?? '',
        // 'no_AC_plants': _formData['no_AC_plants'] ?? '',
        // 'QR_loc': _formData['QR_loc'] ?? '',

        "Longitude": _formData['Longitude'].toString() ?? '4',
        "Latitude": _formData['Latitude'].toString() ?? '6',
        'uploaded_by': _formData['uploaded_by']=User,

      };


      if (kDebugMode) {
        print(connectionData);
      }

      final response = await http.post(
        Uri.parse(HttpPostAc.connectionUrl),
        body: connectionData,
      );



      return response.statusCode == 200;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}




class ResultPage extends StatefulWidget {
  final bool isSuccess;

  ResultPage({required this.isSuccess});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSuccess ? 'Success' : 'Failure'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _animation.value,
                  child: Icon(
                    widget.isSuccess ? Icons.check_circle : Icons.error,
                    size: 80,
                    color: widget.isSuccess ? Colors.green : Colors.red,
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Text(
              widget.isSuccess ? 'Data upload successful!' : 'Failed to upload data.',
              style: TextStyle(fontSize: 20, color: widget.isSuccess ? Colors.green : Colors.red),
            ),
            SizedBox(height: 20),
            CupertinoButton(
              child: Text('Go to Home Page'),
              color: Color(0xFF00AEE4),
              onPressed: () {
                // Navigator.pushReplacement(
                //   context,
                //   CupertinoPageRoute(builder: (context) => ACMaintenancePage()),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}