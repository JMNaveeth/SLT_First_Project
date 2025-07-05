import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// import '../../../UserAccess.dart';
// import '../../genMaintenancePage.dart';

class httpPostDEGInspection extends StatefulWidget {
  final Map<String, dynamic> formData;
  final String degId; // Pass the rec ID to the widget
  final String region;
  //final UserAccess userAccess; // Pass UserAccess from the parent widget

  const httpPostDEGInspection({
    super.key,
    required this.formData,
    required this.degId,
    required this.region,
    //  required this.userAccess
  });

  @override
  // ignore: library_private_types_in_public_api
  _httpPostDEGInspectionState createState() => _httpPostDEGInspectionState();
}

class _httpPostDEGInspectionState extends State<httpPostDEGInspection> {
  bool _isLoading = true;
  String? _errorMessage;
  String? shift;
  late String formattedTime;

  @override
  void initState() {
    super.initState();
    formattedTime = _formatTime(
      widget.formData['clockTime']?.toString() ?? '',
    ); // Ensure time is formatted
    shift = _determineShift(TimeOfDay.now());
    if (_hasAtLeastOneRemark()) {
      _submitRemarkData();
    } else {
      _submitNonRemarkDataWithoutId();
    }
  }

  String _formatTime(String clockTime) {
    try {
      if (clockTime.isNotEmpty) {
        DateTime dateTime = DateTime.parse(clockTime); // Parse the time
        return DateFormat("yyyy-MM-dd HH:mm").format(dateTime); // Format it
      } else {
        return 'Invalid Time';
      }
    } catch (e) {
      return 'Invalid Time';
    }
  }

  // Determine shift
  String _determineShift(TimeOfDay time) {
    final double hour = time.hour + time.minute / 60;
    if (hour >= 8.0 && hour < 16.0) {
      return 'Morning Shift';
    } else if (hour >= 16.0 && hour < 24.0) {
      return 'Evening Shift';
    } else {
      return 'Night Shift';
    }
  }

  bool _hasAtLeastOneRemark() {
    final remarks = [
      widget.formData['degCleanRemark'],
      widget.formData['surroundCleanRemark'],
      widget.formData['vbeltRemark'],
      widget.formData['alarmRemark'],
      widget.formData['warningRemark'],
      widget.formData['issueRemark'],
      widget.formData['leakRemark'],
      widget.formData['waterLevelRemark'],
      widget.formData['exteriorRemark'],
      widget.formData['fuelLeakRemark'],
      widget.formData['airFilterRemark'],
      widget.formData['gasEmmissionRemark'],
      widget.formData['oilLeakRemark'],
      widget.formData['batCleanRemark'],
      widget.formData['batVoltageRemark'],
      widget.formData['batChargerRemark'],
      widget.formData['addiRemark'],
    ];
    debugPrint(remarks.toString());

    for (var remark in remarks) {
      if (remark != null && remark.toString().isNotEmpty) {
        debugPrint("true");
        return true;
      }
    }
    debugPrint("false");
    return false;
  }

  // Submit remark data to the server
  Future<void> _submitRemarkData() async {
    final instance =
        widget.formData['instance']?.toString() ?? ""; // Handle null instances
    final recId = widget.degId; // Ensure GenID is passed
    // final username = widget.userAccess.username ?? '';

    final remarkData = {
      'degId': recId, // Pass RecID
      //'username': username,
      'degCleanRemark$instance':
          widget.formData['degCleanRemark']?.toString() ?? '',
      'surroundCleanRemark$instance':
          widget.formData['surroundCleanRemark']?.toString() ?? '',
      'vbeltRemark$instance': widget.formData['vbeltRemark']?.toString() ?? '',
      'alarmRemark$instance': widget.formData['alarmRemark']?.toString() ?? '',
      'warningRemark$instance':
          widget.formData['warningRemark']?.toString() ?? '',
      'issueRemark$instance': widget.formData['issueRemark']?.toString() ?? '',
      'leakRemark$instance': widget.formData['leakRemark']?.toString() ?? '',
      'waterLevelRemark$instance':
          widget.formData['waterLevelRemark']?.toString() ?? '',
      'exteriorRemark$instance':
          widget.formData['exteriorRemark']?.toString() ?? '',
      'fuelLeakRemark$instance':
          widget.formData['fuelLeakRemark']?.toString() ?? '',
      'airFilterRemark$instance':
          widget.formData['airFilterRemark']?.toString() ?? '',
      'gasEmissionRemark$instance':
          widget.formData['gasEmissionRemark']?.toString() ?? '',
      'oilLeakRemark$instance':
          widget.formData['oilLeakRemark']?.toString() ?? '',
      'batCleanRemark$instance':
          widget.formData['batCleanRemark']?.toString() ?? '',
      'batVoltageRemark$instance':
          widget.formData['batVoltageRemark']?.toString() ?? '',
      'batChargerRemark$instance':
          widget.formData['batChargerRemark']?.toString() ?? '',
      'addiRemark$instance': 
         widget.formData['addiRemark']?.toString() ?? '',
      'latitude': widget.formData['gpsLocation']?['lat']?.toString() ?? '',
      'longitude': widget.formData['gpsLocation']?['lng']?.toString() ?? '',
    };
  print(jsonEncode(remarkData)); // Debug: see what you send

    try {
      // Insert remark data first
      final remarkResponse = await http
          .post(
             Uri.parse('http://124.43.136.185:8000/api/dailyDEGRemarks'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode(remarkData),
          )
          .timeout(const Duration(seconds: 10));

      if (remarkResponse.statusCode == 200) {
        // Assuming the server returns the recId in the response body
        final remarkId = await _fetchRemarkId(); // Fetch the remark ID
        if (remarkId != null) {
          _submitNonRemarkData(remarkId);
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Error fetching remark ID';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Error inserting remark data: ${remarkResponse.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  // Fetch remark ID from the server
  Future<int?> _fetchRemarkId() async {
    try {
      final response = await http
          .get(Uri.parse("http://124.43.136.185:8000/api/dailyDEGRemarks"))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.isNotEmpty) {
          final int remarkId = int.parse(
            jsonResponse[jsonResponse.length - 1]['DailyDEGRemarkID']
                .toString(),
          ); // Adjust index or condition as needed
          print(remarkId.toString());
          print(remarkId.runtimeType);
          return remarkId;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Submit non-remark data to the server
  Future<void> _submitNonRemarkData(int remarkId) async {
    final instance =
        widget.formData['instance']?.toString() ?? ""; // Handle null instances
    final recId = widget.degId; // Ensure GenID is passed
    // final username = widget.userAccess.username ?? '';
    final region = widget.region;

    final nonRemarkData = {
      'degId': recId, // Pass deg ID
      //'username': username,
      'clockTime$instance': formattedTime,
      'shift$instance': shift,
      'DailyDEGRemarkID$instance': remarkId.toString(), // Pass the remark ID

      'region$instance': region,
      'degClean$instance': widget.formData['degClean']?.toString() ?? '',
      'surroundClean$instance':
          widget.formData['surroundClean']?.toString() ?? '',
      'alarm$instance': widget.formData['alarm']?.toString() ?? '',
      'warning$instance': widget.formData['warning']?.toString() ?? '',
      'issue$instance': widget.formData['issue']?.toString() ?? '',
      'leak$instance': widget.formData['leak']?.toString() ?? '',
      'waterLevel$instance': widget.formData['waterLevel']?.toString() ?? '',
      'exterior$instance': widget.formData['exterior']?.toString() ?? '',
      'fuelLeak$instance': widget.formData['fuelLeak']?.toString() ?? '',
      'airFilter$instance': widget.formData['airFilter']?.toString() ?? '',
      'gasEmission$instance': widget.formData['gasEmission']?.toString() ?? '',
      'oilLeak$instance': widget.formData['oilLeak']?.toString() ?? '',
      'batClean$instance': widget.formData['batClean']?.toString() ?? '',
      'batVoltage$instance': widget.formData['batVoltage']?.toString() ?? '',
      'batCharger$instance': widget.formData['batCharger']?.toString() ?? '',
      'bat1$instance': widget.formData['bat1']?.toString() ?? '',
      'bat2$instance': widget.formData['bat2']?.toString() ?? '',
      'bat3$instance': widget.formData['bat3']?.toString() ?? '',
      'bat4$instance': widget.formData['bat4']?.toString() ?? '',
      'latitude':
          widget.formData['gpsLocation']?['lat']?.toString() ?? '',
      'longitude':
          widget.formData['gpsLocation']?['lng']?.toString() ?? '',
    };
  print(jsonEncode(nonRemarkData)); // Debug: see what you send

    try {
      final nonRemarkResponse = await http
          .post(
            Uri.parse('http://124.43.136.185:8000/api/dailyDEGRemarks'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode(nonRemarkData),
          )
          .timeout(const Duration(seconds: 10));

      if (nonRemarkResponse.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Error inserting non-remark data: ${nonRemarkResponse.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  // Submit non-remark data without remark ID
  Future<void> _submitNonRemarkDataWithoutId() async {
    final instance =
        widget.formData['instance']?.toString() ?? ""; // Handle null instances
    final recId = widget.degId; // Ensure GenID is passed
    //final username = widget.userAccess.username ?? '';
    final region = widget.region;

    final nonRemarkData = {
      'degId': recId, // Pass RecID
      // 'username': username,
      'clockTime$instance': formattedTime,
      'shift$instance': shift,

      'region$instance': region,
      'degClean$instance': widget.formData['degClean']?.toString() ?? '',
      'surroundClean$instance':
          widget.formData['surroundClean']?.toString() ?? '',
      'alarm$instance': widget.formData['alarm']?.toString() ?? '',
      'warning$instance': widget.formData['warning']?.toString() ?? '',
      'issue$instance': widget.formData['issue']?.toString() ?? '',
      'leak$instance': widget.formData['leak']?.toString() ?? '',
      'waterLevel$instance': widget.formData['waterLevel']?.toString() ?? '',
      'exterior$instance': widget.formData['exterior']?.toString() ?? '',
      'fuelLeak$instance': widget.formData['fuelLeak']?.toString() ?? '',
      'airFilter$instance': widget.formData['airFilter']?.toString() ?? '',
      'gasEmission$instance': widget.formData['gasEmission']?.toString() ?? '',
      'oilLeak$instance': widget.formData['oilLeak']?.toString() ?? '',
      'batClean$instance': widget.formData['batClean']?.toString() ?? '',
      'batVoltage$instance': widget.formData['batVoltage']?.toString() ?? '',
      'batCharger$instance': widget.formData['batCharger']?.toString() ?? '',
      'bat1$instance': widget.formData['bat1']?.toString() ?? '',
      'bat2$instance': widget.formData['bat2']?.toString() ?? '',
      'bat3$instance': widget.formData['bat3']?.toString() ?? '',
      'bat4$instance': widget.formData['bat4']?.toString() ?? '',
    };

    try {
      final nonRemarkResponse = await http
          .post(
            Uri.parse('http://124.43.136.185:8000/api/dailyDEGCheck'),
            body: nonRemarkData,
          )
          .timeout(const Duration(seconds: 10));

      if (nonRemarkResponse.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Error inserting non-remark data: ${nonRemarkResponse.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Update')),
      body: Center(
        child:
            _isLoading
                ? const CircularProgressIndicator()
                : _errorMessage != null
                ? Text(_errorMessage!)
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Data updated',
                      style: TextStyle(fontSize: 24.0),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      child: const Text('Back'),
                      onPressed: () {
                        //             Navigator.push(
                        //               context,
                        //               MaterialPageRoute(
                        //                 builder: (context) => maintenancePage(
                        // ),
                        //               ),
                        //             );
                      },
                    ),
                  ],
                ),
      ),
    );
  }
}
