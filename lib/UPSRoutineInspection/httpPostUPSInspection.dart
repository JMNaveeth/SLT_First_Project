import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// import 'package:powerprox/Screens/UserAccess.dart';

// import '../UPSMaintenancePage.dart';

class httpPostUPSInspection extends StatefulWidget {
  final Map<String, dynamic> formData;
  final String recId; // Pass the rec ID to the widget
  //final UserAccess userAccess; // Pass UserAccess from the parent widget
  final String region;

  const httpPostUPSInspection({
    super.key,
    required this.formData,
    required this.recId,
   // required this.userAccess,
    required this.region,
  });

  @override
  _httpPostUPSInspectionState createState() => _httpPostUPSInspectionState();
}

class _httpPostUPSInspectionState extends State<httpPostUPSInspection> {
  bool _isLoading = true;
  String? _errorMessage;
  String? shift;
  late String formattedTime;

  @override
  void initState() {
    super.initState();
    formattedTime = _formatTime(widget.formData['clockTime']?.toString() ??
        ''); // Ensure time is formatted
    print('Formatted time: $formattedTime');
    shift = _determineShift(TimeOfDay.now());
    _hasAtLeastOneRemark()
        ? _submitRemarkData()
        : _submitNonRemarkDataWithOutId();
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
      print('Error formatting time: $e');
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
      return 'Night shift';
    }
  }

  String getProblemStatus(){
    if(widget.formData["ventilation"]=="Not Ok"||widget.formData["cabinTemp"]=="Others"||widget.formData['h2GasEmission']=="Yes"||widget.formData["dust"]=="Not Ok"||widget.formData["batClean"]=="Not Ok"||widget.formData['trmVolt']=="Not Ok"||widget.formData['leak']=="Yes"||widget.formData['mimicLED']=="Not Work"||widget.formData["meterPara"]=="Not Ok"||widget.formData["warningAlarm"]=="Yes"||widget.formData["overHeat"]=="Yes"){
      return "1";
    }else{
      return "0";
    }
  }

  //check at least one value is available
  bool _hasAtLeastOneRemark() {
    final remarks = [
      widget.formData['roomCleanRemark'],
      widget.formData['CubicleCleanRemark'],
      widget.formData['roomTempRemark'],
      widget.formData['h2gasEmissionRemark'],
      widget.formData['checkMCBRemark'],
      widget.formData['dcPDBRemark'],
      widget.formData['remoteAlarmRemark'],
      widget.formData['recAlarmRemark'],
      widget.formData['indRemark'],
      widget.formData['ventilationRemark'],
      widget.formData['cabinTempRemark'],
      widget.formData['h2GasEmissionRemark'],
      widget.formData['dustRemark'],
      widget.formData['batCleanRemark'],
      widget.formData['trmVoltRemark'],
      widget.formData['leakRemark'],
      widget.formData['mimicLEDRemark'],
      widget.formData['meterParaRemark'],
      widget.formData['warningAlarmRemark'],
      widget.formData['overHeatRemark'],
      widget.formData['addiRemark'],
    ];

    for (var remark in remarks) {
      if (remark != null && remark.toString().isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  // Submit remark data to the server
  Future<void> _submitRemarkData() async {
    final instance =
        widget.formData['instance']?.toString() ?? ""; // Handle null instances
    final recId = widget.recId; // Ensure UPSID is passed

    final remarkData = {
      'recId': recId, // Pass RecID
     // 'uploader': widget.userAccess.username,
      'ventilationRemark$instance':
      widget.formData['ventilationRemark']?.toString() ?? '',
      'cabinTempRemark$instance':
      widget.formData['cabinTempRemark']?.toString() ?? '',
      'h2GasEmissionRemark$instance':
      widget.formData['h2GasEmissionRemark']?.toString() ?? '',
      'dustRemark$instance': widget.formData['dustRemark']?.toString() ?? '',
      'batCleanRemark$instance':
      widget.formData['batCleanRemark']?.toString() ?? '',
      'trmVoltRemark$instance':
      widget.formData['trmVoltRemark']?.toString() ?? '',
      'leakRemark$instance': widget.formData['leakRemark']?.toString() ?? '',
      'mimicLEDRemark$instance':
      widget.formData['recAlarmRemark']?.toString() ?? '',
      'meterParaRemark$instance':
      widget.formData['meterParaRemark']?.toString() ?? '',
      'warningAlarmRemark$instance':
      widget.formData['warningAlarmRemark']?.toString() ?? '',
      'overHeatRemark$instance':
      widget.formData['overHeatRemark']?.toString() ?? '',
      'addiRemark$instance': widget.formData['addiRemark']?.toString() ?? '',
    };

    try {
      // Insert remark data first
      final remarkResponse = await http
          .post(Uri.parse('https://powerprox.sltidc.lk/POSTDailyUPSRemarks.php'),
          body: remarkData)
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
          print(_errorMessage);
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: ${e.toString()}';
        print(_errorMessage);
      });
    }
  }

  // Fetch remark ID from the server
  Future<int?> _fetchRemarkId() async {
    try {
      final response = await http
          .get(Uri.parse("https://powerprox.sltidc.lk/GETDailyUPSRemarks.php"))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.isNotEmpty) {
          final int remarkId = int.parse(jsonResponse[jsonResponse.length - 1]
          ['DailyUPSRemarksID']
              .toString()); // Adjust index or condition as needed
          print(remarkId.toString().runtimeType);
          print(remarkId.runtimeType);
          return remarkId;
        } else {
          print('No remarks found');
          return null;
        }
      } else {
        print('No remarks found');
        return null;
      }
    } catch (e) {
      print('Error fetching remarks:');
      return null;
    }
  }

  // Submit non-remark data to the server
  Future<void> _submitNonRemarkData(int remarkId) async {
    final instance =
        widget.formData['instance']?.toString() ?? ""; // Handle null instances
    final recId = widget.recId; // Ensure GenID is passed
    final region = widget.region;

    final nonRemarkData = {
      'recId': recId, // Pass Rec ID
      //'userName': widget.userAccess.username,
      'clockTime$instance': formattedTime,
      'shift$instance': shift,
      'DailyUPSRemarksID$instance':
      remarkId.toString() ?? '', // Pass the remark ID
      'location$instance': region,
      'ventilation$instance': widget.formData['ventilation']?.toString() ?? '',
      'cabinTemp$instance': widget.formData['cabinTemp']?.toString() ?? '',
      'h2GasEmission$instance':
      widget.formData['h2GasEmission']?.toString() ?? '',
      'dust$instance': widget.formData['dust']?.toString() ?? '',
      'batClean$instance': widget.formData['batClean']?.toString() ?? '',
      'trmVolt$instance': widget.formData['trmVolt']?.toString() ?? '',
      'leak$instance': widget.formData['leak']?.toString() ?? '',
      'mimicLED$instance': widget.formData['mimicLED']?.toString() ?? '',
      'meterPara$instance': widget.formData['meterPara']?.toString() ?? '',
      'warningAlarm$instance':
      widget.formData['warningAlarm']?.toString() ?? '',
      'overHeat$instance': widget.formData['overHeat']?.toString() ?? '',
      'voltagePs1$instance': widget.formData['voltagePs1']?.toString() ?? '',
      'voltagePs2$instance': widget.formData['voltagePs2']?.toString() ?? '',
      'voltagePs3$instance': widget.formData['voltagePs3']?.toString() ?? '',
      'currentPs1$instance': widget.formData['currentPs1']?.toString() ?? '',
      'currentPs2$instance': widget.formData['currentPs2']?.toString() ?? '',
      'currentPs3$instance': widget.formData['currentPs3']?.toString() ?? '',
      'upsCapacity$instance': widget.formData['upsCapacity']?.toString() ?? '',
      'problemStatus': getProblemStatus()=='0'?"0":"1"
    };

    try {
      final nonRemarkResponse = await http
          .post(Uri.parse('https://powerprox.sltidc.lk/POSTDailyUPSCheck.php'),
          body: nonRemarkData)
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
        print(_errorMessage);
      });
    }
  }

  //without remark id
  // Submit non-remark data to the server
  Future<void> _submitNonRemarkDataWithOutId() async {
    final instance =
        widget.formData['instance']?.toString() ?? ""; // Handle null instances
    final recId = widget.recId; // Ensure GenID is passed
    final region = widget.region;

    final nonRemarkData = {
      'recId': recId, // Pass Rec ID
     // 'userName': widget.userAccess.username,
      'clockTime$instance': formattedTime,
      'shift$instance': shift,

      'location$instance': region,
      'ventilation$instance': widget.formData['ventilation']?.toString() ?? '',
      'cabinTemp$instance': widget.formData['cabinTemp']?.toString() ?? '',
      'h2GasEmission$instance':
      widget.formData['h2GasEmission']?.toString() ?? '',
      'dust$instance': widget.formData['dust']?.toString() ?? '',
      'batClean$instance': widget.formData['batClean']?.toString() ?? '',
      'trmVolt$instance': widget.formData['trmVolt']?.toString() ?? '',
      'leak$instance': widget.formData['leak']?.toString() ?? '',
      'mimicLED$instance': widget.formData['mimicLED']?.toString() ?? '',
      'meterPara$instance': widget.formData['meterPara']?.toString() ?? '',
      'warningAlarm$instance':
      widget.formData['warningAlarm']?.toString() ?? '',
      'overHeat$instance': widget.formData['overHeat']?.toString() ?? '',
      'voltagePs1$instance': widget.formData['voltagePs1']?.toString() ?? '',
      'voltagePs2$instance': widget.formData['voltagePs2']?.toString() ?? '',
      'voltagePs3$instance': widget.formData['voltagePs3']?.toString() ?? '',
      'currentPs1$instance': widget.formData['currentPs1']?.toString() ?? '',
      'currentPs2$instance': widget.formData['currentPs2']?.toString() ?? '',
      'currentPs3$instance': widget.formData['currentPs3']?.toString() ?? '',
      'upsCapacity$instance': widget.formData['upsCapacity']?.toString() ?? '',
      'problemStatus': getProblemStatus()=='0'?"0":"1"
    };

    try {
      final nonRemarkResponse = await http
          .post(Uri.parse('https://powerprox.sltidc.lk/POSTDailyUPSCheck.php'),
          body: nonRemarkData)
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
        print(_errorMessage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Update'),
      ),
      body: Center(
        child: _isLoading
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
            // ElevatedButton(
            //   child: const Text('Back'),
            //   // onPressed: () {
            //   //   Navigator.push(
            //   //     context,
            //   //     MaterialPageRoute(
            //   //       builder: (context) => UPSMaintenancePage(),
            //   //     ),
            //   //   );
            //   // },
            // ),
          ],
        ),
      ),
    );
  }
}

//v2 02-07-2024
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:powerprox/Screens/UserAccess.dart';
//
// import '../UPSMaintenancePage.dart';
//
// class httpPostUPSInspection extends StatefulWidget {
//   final Map<String, dynamic> formData;
//   final String recId; // Pass the rec ID to the widget
//   final UserAccess userAccess; // Pass UserAccess from the parent widget
//   final String region;
//
//   const httpPostUPSInspection({
//     super.key,
//     required this.formData,
//     required this.recId,
//     required this.userAccess,
//     required this.region,
//   });
//
//   @override
//   _httpPostUPSInspectionState createState() => _httpPostUPSInspectionState();
// }
//
// class _httpPostUPSInspectionState extends State<httpPostUPSInspection> {
//   bool _isLoading = true;
//   String? _errorMessage;
//   String? shift;
//   late String formattedTime;
//
//   @override
//   void initState() {
//     super.initState();
//     formattedTime = _formatTime(widget.formData['clockTime']?.toString() ??
//         ''); // Ensure time is formatted
//     print('Formatted time: $formattedTime');
//     shift = _determineShift(TimeOfDay.now());
//     _submitRemarkData();
//   }
//
//   String _formatTime(String clockTime) {
//     try {
//       if (clockTime.isNotEmpty) {
//         DateTime dateTime = DateTime.parse(clockTime); // Parse the time
//         return DateFormat("yyyy-MM-dd HH:mm").format(dateTime); // Format it
//       } else {
//         return 'Invalid Time';
//       }
//     } catch (e) {
//       print('Error formatting time: $e');
//       return 'Invalid Time';
//     }
//   }
//
//   // Determine shift
//   String _determineShift(TimeOfDay time) {
//     final double hour = time.hour + time.minute / 60;
//     if (hour >= 8.0 && hour < 16.0) {
//       return 'Morning Shift';
//     } else if (hour >= 16.0 && hour < 24.0) {
//       return 'Evening Shift';
//     } else {
//       return 'Night shift';
//     }
//   }
//
//   // Submit remark data to the server
//   Future<void> _submitRemarkData() async {
//     final instance =
//         widget.formData['instance']?.toString() ?? ""; // Handle null instances
//     final recId = widget.recId; // Ensure UPSID is passed
//
//     final remarkData = {
//       'recId': recId, // Pass RecID
//       'uploader': widget.userAccess.username,
//       'ventilationRemark$instance':
//       widget.formData['ventilationRemark']?.toString() ?? '',
//       'cabinTempRemark$instance':
//       widget.formData['cabinTempRemark']?.toString() ?? '',
//       'h2GasEmissionRemark$instance':
//       widget.formData['h2GasEmissionRemark']?.toString() ?? '',
//       'dustRemark$instance': widget.formData['dustRemark']?.toString() ?? '',
//       'batCleanRemark$instance':
//       widget.formData['batCleanRemark']?.toString() ?? '',
//       'trmVoltRemark$instance':
//       widget.formData['trmVoltRemark']?.toString() ?? '',
//       'leakRemark$instance': widget.formData['leakRemark']?.toString() ?? '',
//       'mimicLEDRemark$instance':
//       widget.formData['recAlarmRemark']?.toString() ?? '',
//       'meterParaRemark$instance':
//       widget.formData['meterParaRemark']?.toString() ?? '',
//       'warningAlarmRemark$instance':
//       widget.formData['warningAlarmRemark']?.toString() ?? '',
//       'overHeatRemark$instance':
//       widget.formData['overHeatRemark']?.toString() ?? '',
//       'addiRemark$instance': widget.formData['addiRemark']?.toString() ?? '',
//     };
//
//     try {
//       // Insert remark data first
//       final remarkResponse = await http
//           .post(Uri.parse('http://124.43.136.185/POSTDailyUPSRemarks.php'),
//           body: remarkData)
//           .timeout(const Duration(seconds: 10));
//
//       if (remarkResponse.statusCode == 200) {
//         // Assuming the server returns the recId in the response body
//         final remarkId = await _fetchRemarkId(); // Fetch the remark ID
//         if (remarkId != null) {
//           _submitNonRemarkData(remarkId);
//         } else {
//           setState(() {
//             _isLoading = false;
//             _errorMessage = 'Error fetching remark ID';
//           });
//         }
//       } else {
//         setState(() {
//           _isLoading = false;
//           _errorMessage =
//           'Error inserting remark data: ${remarkResponse.statusCode}';
//           print(_errorMessage);
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'Error: ${e.toString()}';
//         print(_errorMessage);
//       });
//     }
//   }
//
//   // Fetch remark ID from the server
//   Future<int?> _fetchRemarkId() async {
//     try {
//       final response = await http
//           .get(Uri.parse("http://124.43.136.185/GETDailyUPSRemarks.php"))
//           .timeout(const Duration(seconds: 10));
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonResponse = json.decode(response.body);
//         if (jsonResponse.isNotEmpty) {
//           final int remarkId = int.parse(jsonResponse[jsonResponse.length - 1]
//           ['DailyUPSRemarksID']
//               .toString()); // Adjust index or condition as needed
//           print(remarkId.toString().runtimeType);
//           print(remarkId.runtimeType);
//           return remarkId;
//         } else {
//           print('No remarks found');
//           return null;
//         }
//       } else {
//         print('No remarks found');
//         return null;
//       }
//     } catch (e) {
//       print('Error fetching remarks:');
//       return null;
//     }
//   }
//
//   // Submit non-remark data to the server
//   Future<void> _submitNonRemarkData(int remarkId) async {
//     final instance =
//         widget.formData['instance']?.toString() ?? ""; // Handle null instances
//     final recId = widget.recId; // Ensure GenID is passed
//     final region = widget.region;
//
//     final nonRemarkData = {
//       'recId': recId, // Pass Rec ID
//       'userName': widget.userAccess.username,
//       'clockTime$instance': formattedTime,
//       'shift$instance': shift,
//       'DailyUPSRemarksID$instance':
//       remarkId.toString() ?? '', // Pass the remark ID
//       'location$instance': region,
//       'ventilation$instance': widget.formData['ventilation']?.toString() ?? '',
//       'cabinTemp$instance': widget.formData['cabinTemp']?.toString() ?? '',
//       'h2GasEmission$instance':
//       widget.formData['h2GasEmission']?.toString() ?? '',
//       'dust$instance': widget.formData['dust']?.toString() ?? '',
//       'batClean$instance': widget.formData['batClean']?.toString() ?? '',
//       'trmVolt$instance': widget.formData['trmVolt']?.toString() ?? '',
//       'leak$instance': widget.formData['leak']?.toString() ?? '',
//       'mimicLED$instance': widget.formData['mimicLED']?.toString() ?? '',
//       'meterPara$instance': widget.formData['meterPara']?.toString() ?? '',
//       'warningAlarm$instance':
//       widget.formData['warningAlarm']?.toString() ?? '',
//       'overHeat$instance': widget.formData['overHeat']?.toString() ?? '',
//       'voltagePs1$instance': widget.formData['voltagePs1']?.toString() ?? '',
//       'voltagePs2$instance': widget.formData['voltagePs2']?.toString() ?? '',
//       'voltagePs3$instance': widget.formData['voltagePs3']?.toString() ?? '',
//       'currentPs1$instance': widget.formData['currentPs1']?.toString() ?? '',
//       'currentPs2$instance': widget.formData['currentPs2']?.toString() ?? '',
//       'currentPs3$instance': widget.formData['currentPs3']?.toString() ?? '',
//       'upsCapacity$instance': widget.formData['upsCapacity']?.toString() ?? '',
//     };
//
//     try {
//       final nonRemarkResponse = await http
//           .post(Uri.parse('http://124.43.136.185/POSTDailyUPSCheck.php'),
//           body: nonRemarkData)
//           .timeout(const Duration(seconds: 10));
//
//       if (nonRemarkResponse.statusCode == 200) {
//         setState(() {
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//           _errorMessage =
//           'Error inserting non-remark data: ${nonRemarkResponse.statusCode}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'Error: ${e.toString()}';
//         print(_errorMessage);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Data Update'),
//       ),
//       body: Center(
//         child: _isLoading
//             ? const CircularProgressIndicator()
//             : _errorMessage != null
//             ? Text(_errorMessage!)
//             : Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Data updated',
//               style: TextStyle(fontSize: 24.0),
//             ),
//             const SizedBox(height: 20.0),
//             ElevatedButton(
//               child: const Text('Back'),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => UPSMaintenancePage(),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



//v1 01-07-2024

// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:powerprox/Screens/UserAccess.dart';
//
// import '../UPSMaintenancePage.dart';
//
// class httpPostUPSInspection extends StatefulWidget {
//   final Map<String, dynamic> formData;
//   final String recId; // Pass the rec ID to the widget
//   final UserAccess userAccess; // Pass UserAccess from the parent widget
//
//   const httpPostUPSInspection(
//       {super.key,
//       required this.formData,
//       required this.recId,
//         required this.userAccess});
//
//   @override
//   _httpPostUPSInspectionState createState() =>
//       _httpPostUPSInspectionState();
// }
//
// class _httpPostUPSInspectionState extends State<httpPostUPSInspection> {
//   bool _isLoading = true;
//   String? _errorMessage;
//   String? shift;
//   late String formattedTime;
//
//   @override
//   void initState() {
//     super.initState();
//     formattedTime = _formatTime(widget.formData['clockTime']?.toString() ?? ''); // Ensure time is formatted
//     print('Formatted time: $formattedTime');
//     shift = _determineShift(TimeOfDay.now());
//     _submitRemarkData();
//   }
//
//   String _formatTime(String clockTime) {
//     try {
//       if (clockTime.isNotEmpty) {
//         DateTime dateTime = DateTime.parse(clockTime); // Parse the time
//         return DateFormat("yyyy-MM-dd HH:mm").format(dateTime); // Format it
//       } else {
//         return 'Invalid Time';
//       }
//     } catch (e) {
//       print('Error formatting time: $e');
//       return 'Invalid Time';
//     }
//   }
//
//   // Determine shift
//   String _determineShift(TimeOfDay time) {
//     final double hour = time.hour + time.minute / 60;
//     if (hour >= 8.0 && hour < 16.0) {
//       return 'Morning Shift';
//     } else if (hour >= 16.0 && hour < 24.0) {
//       return 'Evening Shift';
//     } else {
//       return 'Night shift';
//     }
//   }
//
//   // Submit remark data to the server
//   Future<void> _submitRemarkData() async {
//     final instance = widget.formData['instance']?.toString() ?? ""; // Handle null instances
//     final recId = widget.recId; // Ensure UPSID is passed
//
//
//     final remarkData = {
//       'recId': recId, // Pass RecID
//       'uploader': widget.userAccess.username,
//       'ventilationRemark$instance': widget.formData['ventilationRemark']?.toString() ?? '',
//       'cabinTempRemark$instance': widget.formData['cabinTempRemark']?.toString() ?? '',
//       'h2GasEmissionRemark$instance': widget.formData['h2GasEmissionRemark']?.toString() ?? '',
//       'dustRemark$instance': widget.formData['dustRemark']?.toString() ?? '',
//       'batCleanRemark$instance': widget.formData['batCleanRemark']?.toString() ?? '',
//       'trmVoltRemark$instance': widget.formData['trmVoltRemark']?.toString() ?? '',
//       'leakRemark$instance': widget.formData['leakRemark']?.toString() ?? '',
//       'mimicLEDRemark$instance': widget.formData['recAlarmRemark']?.toString() ?? '',
//       'meterParaRemark$instance': widget.formData['meterParaRemark']?.toString() ?? '',
//       'warningAlarmRemark$instance': widget.formData['warningAlarmRemark']?.toString() ?? '',
//       'overHeatRemark$instance': widget.formData['overHeatRemark']?.toString() ?? '',
//       'addiRemark$instance': widget.formData['addiRemark']?.toString() ?? '',
//     };
//
//     try {
//       // Insert remark data first
//       final remarkResponse = await http
//           .post(Uri.parse('http://124.43.136.185/POSTDailyUPSRemarks.php'),
//               body: remarkData)
//           .timeout(const Duration(seconds: 10));
//
//       if (remarkResponse.statusCode == 200) {
//         // Assuming the server returns the recId in the response body
//         final remarkId = await _fetchRemarkId(); // Fetch the remark ID
//         if (remarkId != null) {
//           _submitNonRemarkData(remarkId);
//         } else {
//           setState(() {
//             _isLoading = false;
//             _errorMessage = 'Error fetching remark ID';
//
//           });
//         }
//       } else {
//         setState(() {
//           _isLoading = false;
//           _errorMessage = 'Error inserting remark data: ${remarkResponse.statusCode}';
//           print(_errorMessage);
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'Error: ${e.toString()}';
//         print(_errorMessage);
//       });
//     }
//   }
//
//   // Fetch remark ID from the server
//   Future<int?> _fetchRemarkId() async {
//     try {
//       final response = await http
//           .get(Uri.parse("http://124.43.136.185/GETDailyUPSRemarks.php"))
//           .timeout(const Duration(seconds: 10));
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonResponse = json.decode(response.body);
//         if (jsonResponse.isNotEmpty) {
//           final int remarkId = int.parse(jsonResponse[jsonResponse.length - 1]
//                   ['DailyUPSRemarksID']
//               .toString()); // Adjust index or condition as needed
//           print(remarkId.toString().runtimeType);
//           print(remarkId.runtimeType);
//           return remarkId;
//         } else {
//           print('No remarks found');
//           return null;
//         }
//       } else {
//         print('No remarks found');
//         return null;
//       }
//     } catch (e) {
//       print('Error fetching remarks:');
//       return null;
//     }
//   }
//
//   // Submit non-remark data to the server
//   Future<void> _submitNonRemarkData(int remarkId) async {
//     final instance = widget.formData['instance']?.toString() ?? ""; // Handle null instances
//     final recId = widget.recId; // Ensure GenID is passed
//
//
//     final nonRemarkData = {
//       'recId': recId, // Pass Rec ID
//       'userName': widget.userAccess.username,
//       'clockTime$instance': formattedTime,
//       'shift$instance': shift,
//       'DailyUPSRemarksID$instance': remarkId.toString() ?? '', // Pass the remark ID
//       'location$instance': widget.formData['location']?.toString() ?? '',
//       'ventilation$instance': widget.formData['ventilation']?.toString() ?? '',
//       'cabinTemp$instance': widget.formData['cabinTemp']?.toString() ?? '',
//       'h2GasEmission$instance': widget.formData['h2GasEmission']?.toString() ?? '',
//       'dust$instance': widget.formData['dust']?.toString() ?? '',
//       'batClean$instance': widget.formData['batClean']?.toString() ?? '',
//       'trmVolt$instance': widget.formData['trmVolt']?.toString() ?? '',
//       'leak$instance': widget.formData['leak']?.toString() ?? '',
//       'mimicLED$instance': widget.formData['mimicLED']?.toString() ?? '',
//       'meterPara$instance': widget.formData['meterPara']?.toString() ?? '',
//       'warningAlarm$instance': widget.formData['warningAlarm']?.toString() ?? '',
//       'overHeat$instance': widget.formData['overHeat']?.toString() ?? '',
//       'voltagePs1$instance': widget.formData['voltagePs1']?.toString() ?? '',
//       'voltagePs2$instance': widget.formData['voltagePs2']?.toString() ?? '',
//       'voltagePs3$instance': widget.formData['voltagePs3']?.toString() ?? '',
//       'currentPs1$instance': widget.formData['currentPs1']?.toString() ?? '',
//       'currentPs2$instance': widget.formData['currentPs2']?.toString() ?? '',
//       'currentPs3$instance': widget.formData['currentPs3']?.toString() ?? '',
//       'upsCapacity$instance': widget.formData['upsCapacity']?.toString() ?? '',
//     };
//
//     try {
//       final nonRemarkResponse = await http
//           .post(Uri.parse('http://124.43.136.185/POSTDailyUPSCheck.php'),
//               body: nonRemarkData)
//           .timeout(const Duration(seconds: 10));
//
//       if (nonRemarkResponse.statusCode == 200) {
//         setState(() {
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//           _errorMessage = 'Error inserting non-remark data: ${nonRemarkResponse.statusCode}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'Error: ${e.toString()}';
//         print(_errorMessage);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Data Update'),
//       ),
//       body: Center(
//         child: _isLoading
//             ? const CircularProgressIndicator()
//             : _errorMessage != null
//                 ? Text(_errorMessage!)
//                 : Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         'Data updated',
//                         style: TextStyle(fontSize: 24.0),
//                       ),
//                       const SizedBox(height: 20.0),
//                       ElevatedButton(
//                         child: const Text('Back'),
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => UPSMaintenancePage(
//
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//       ),
//     );
//   }
// }
