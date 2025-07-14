import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

//import '../RectifierMaintenancePage.dart';
//import 'package:powerprox/Screens/UserAccess.dart';

class httpPostRectifierInspection extends StatefulWidget {
  final Map<String, dynamic> formData;
  final String recId; // Pass the rec ID to the widget
 // final UserAccess userAccess; // Pass UserAccess from the parent widget
  final String region;


  const httpPostRectifierInspection(
      {super.key,
        required this.formData,
        required this.recId,
     //   required this.userAccess,
        required this.region});

  @override
  // ignore: library_private_types_in_public_api
  _httpPostRectifierInspectionState createState() =>
      _httpPostRectifierInspectionState();
}

class _httpPostRectifierInspectionState
    extends State<httpPostRectifierInspection> {
  bool _isLoading = true;
  String? _errorMessage;
  String? shift;
  late String formattedTime;
  String problemStatus="0";

  @override
  void initState() {
    super.initState();
    formattedTime = _formatTime(widget.formData['clockTime']?.toString() ??
        ''); // Ensure time is formatted
    shift = _determineShift(TimeOfDay.now());
    _hasAtLeastOneRemark()
        ? _submitRemarkData()
        : _submitNonRemarkDataWithOutId();
    if(getProblemStatus()=="0"){
      print("Here because i see nothing");
      setState(() {
        problemStatus="0";
      });
    }else{
      print("Here because i see something");
      setState(() {
        problemStatus="1";
      });
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
      return 'Night shift';
    }
  }

  String getProblemStatus(){
    if(widget.formData['roomClean']=='Not Ok'||widget.formData['cubicleClean']=='Not Ok'||widget.formData['roomTemp']=='high'||widget.formData['h2gasEmission']=='yes'||widget.formData['checkMCB']=='Not ok'||widget.formData['dcPDB']=='Not ok'||widget.formData['remoteAlarm']=='Not ok'||widget.formData['recAlarmStatus']=='notok'||widget.formData['recIndicatorStatus']=='not ok'){
      print("I detect a fault");
      return "1";
    }else{
      print("I see nothing");
      return "0";

    }
  }

  //check atleast remark available
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
    final recId = widget.recId; // Ensure GenID is passed

    final remarkData = {
      'recId': recId ?? '', // Pass RecID
     // 'uploader': widget.userAccess.username ?? '',
      'roomCleanRemark$instance':
      widget.formData['roomCleanRemark']?.toString() ?? '',
      'CubicleCleanRemark$instance':
      widget.formData['CubicleCleanRemark']?.toString() ?? '',
      'roomTempRemark$instance':
      widget.formData['roomTempRemark']?.toString() ?? '',
      'h2gasEmissionRemark$instance':
      widget.formData['h2gasEmissionRemark']?.toString() ?? '',
      'checkMCBRemark$instance':
      widget.formData['checkMCBRemark']?.toString() ?? '',
      'dcPDBRemark$instance': widget.formData['dcPDBRemark']?.toString() ?? '',
      'remoteAlarmRemark$instance':
      widget.formData['remoteAlarmRemark']?.toString() ?? '',
      'recAlarmRemark$instance':
      widget.formData['recAlarmRemark']?.toString() ?? '',
      'indRemark$instance': widget.formData['indRemark']?.toString() ?? '',
    //  'userName': widget.userAccess.username ?? '',
    };

    try {
      // Insert remark data first
      final remarkResponse = await http
          .post(Uri.parse('http://124.43.136.185:8000/api/rectifiers'),
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
          .get(Uri.parse("http://124.43.136.185:8000/api/rectifiers"))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.isNotEmpty) {
          final int remarkId = int.parse(jsonResponse[jsonResponse.length - 1]
          ['DailyRECRemarkID']
              .toString()); // Adjust index or condition as needed
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
    final recId = widget.recId; // Ensure GenID is passed
    final region = widget.region;

    final nonRemarkData = {
      'recId': recId ?? '', // Pass Rec ID
    //  'userName': widget.userAccess.username ?? '',
      'clockTime$instance': formattedTime ?? '',
      'shift$instance': shift ?? '',
      'DailyRECRemarkID$instance':
      remarkId.toString() ?? '', // Pass the remark ID

      'region$instance': widget.region,
      'room$instance': widget.formData['room']?.toString() ?? '',
      'model$instance': widget.formData['model']?.toString() ?? '',
      'serialNo$instance': widget.formData['serialNo']?.toString() ?? '',
      'roomClean$instance': widget.formData['roomClean']?.toString() ?? '',
      'cubicleClean$instance':
      widget.formData['cubicleClean']?.toString() ?? '',
      'roomTemp$instance': widget.formData['roomTemp']?.toString() ?? '',
      'h2gasEmission$instance':
      widget.formData['h2gasEmission']?.toString() ?? '',
      'checkMCB$instance': widget.formData['checkMCB']?.toString() ?? '',
      'dcPDB$instance': widget.formData['dcPDB']?.toString() ?? '',
      'remoteAlarm$instance': widget.formData['remoteAlarm']?.toString() ?? '',
      'noOfWorkingLine$instance':
      widget.formData['noOfWorkingLine']?.toString() ?? '',
      //'capacity$instance': widget.formData['capacity']?.toString() ?? '',
      //'type$instance': widget.formData['type']?.toString() ?? '',
      'voltagePs1$instance': widget.formData['voltagePs1']?.toString() ?? '',
      'voltagePs2$instance': widget.formData['voltagePs2']?.toString() ?? '',
      'voltagePs3$instance': widget.formData['voltagePs3']?.toString() ?? '',
      'currentPs1$instance': widget.formData['currentPs1']?.toString() ?? '',
      'currentPs2$instance': widget.formData['currentPs2']?.toString() ?? '',
      'currentPs3$instance': widget.formData['currentPs3']?.toString() ?? '',
      'dcVoltage$instance': widget.formData['dcVoltage']?.toString() ?? '',
      'dcCurrent$instance': widget.formData['dcCurrent']?.toString() ?? '',
      'recCapacity$instance': widget.formData['recCapacity']?.toString() ?? '',
      'recAlarmStatus$instance':
      widget.formData['recAlarmStatus']?.toString() ?? '',
      'recIndicatorStatus$instance':
      widget.formData['recIndicatorStatus']?.toString() ?? '',
      'problemStatus': problemStatus,
    };

    try {
      final nonRemarkResponse = await http
          .post(Uri.parse('http://124.43.136.185:8000/api/rectifiers'),
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

//without id
// Submit non-remark data to the server
  Future<void> _submitNonRemarkDataWithOutId() async {
    final instance =
        widget.formData['instance']?.toString() ?? ""; // Handle null instances
    final recId = widget.recId; // Ensure GenID is passed
    final region = widget.region;

    final nonRemarkData = {
      'recId': recId ?? '', // Pass Rec ID
     // 'userName': widget.userAccess.username ?? '',
      'clockTime$instance': formattedTime ?? '',
      'shift$instance': shift ?? '',

      'region$instance': widget.region,
      'room$instance': widget.formData['room']?.toString() ?? '',
      'model$instance': widget.formData['model']?.toString() ?? '',
      'serialNo$instance': widget.formData['serialNo']?.toString() ?? '',
      'roomClean$instance': widget.formData['roomClean']?.toString() ?? '',
      'cubicleClean$instance':
      widget.formData['cubicleClean']?.toString() ?? '',
      'roomTemp$instance': widget.formData['roomTemp']?.toString() ?? '',
      'h2gasEmission$instance':
      widget.formData['h2gasEmission']?.toString() ?? '',
      'checkMCB$instance': widget.formData['checkMCB']?.toString() ?? '',
      'dcPDB$instance': widget.formData['dcPDB']?.toString() ?? '',
      'remoteAlarm$instance': widget.formData['remoteAlarm']?.toString() ?? '',
      'noOfWorkingLine$instance':
      widget.formData['noOfWorkingLine']?.toString() ?? '',
      // 'capacity$instance': widget.formData['capacity']?.toString() ?? '',
      // 'type$instance': widget.formData['type']?.toString() ?? '',
      'voltagePs1$instance': widget.formData['voltagePs1']?.toString() ?? '',
      'voltagePs2$instance': widget.formData['voltagePs2']?.toString() ?? '',
      'voltagePs3$instance': widget.formData['voltagePs3']?.toString() ?? '',
      'currentPs1$instance': widget.formData['currentPs1']?.toString() ?? '',
      'currentPs2$instance': widget.formData['currentPs2']?.toString() ?? '',
      'currentPs3$instance': widget.formData['currentPs3']?.toString() ?? '',
      'dcVoltage$instance': widget.formData['dcVoltage']?.toString() ?? '',
      'dcCurrent$instance': widget.formData['dcCurrent']?.toString() ?? '',
      'recCapacity$instance': widget.formData['recCapacity']?.toString() ?? '',
      'recAlarmStatus$instance':
      widget.formData['recAlarmStatus']?.toString() ?? '',
      'recIndicatorStatus$instance':
      widget.formData['recIndicatorStatus']?.toString() ?? '',
      'problemStatus': problemStatus,
    };

    try {
      final nonRemarkResponse = await http
          .post(Uri.parse('http://124.43.136.185:8000/api/rectifiers'),
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
            ElevatedButton(
              child: const Text('Back'),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => RectifierMaintenancePage(),
                //   ),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}

//v5 10-07-2024
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
//
// import '../RectifierMaintenancePage.dart';
// import 'package:powerprox/Screens/UserAccess.dart';
//
// class httpPostRectifierInspection extends StatefulWidget {
//   final Map<String, dynamic> formData;
//   final String recId; // Pass the rec ID to the widget
//   final UserAccess userAccess; // Pass UserAccess from the parent widget
//   final String region;
//
//   const httpPostRectifierInspection(
//       {super.key,
//         required this.formData,
//         required this.recId,
//         required this.userAccess,
//         required this.region});
//
//   @override
//   // ignore: library_private_types_in_public_api
//   _httpPostRectifierInspectionState createState() =>
//       _httpPostRectifierInspectionState();
// }
//
// class _httpPostRectifierInspectionState
//     extends State<httpPostRectifierInspection> {
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
//     shift = _determineShift(TimeOfDay.now());
//     _hasAtLeastOneRemark()
//         ? _submitRemarkData()
//         : _submitNonRemarkDataWithOutId();
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
// //check atleast remark available
//   bool _hasAtLeastOneRemark() {
//     final remarks = [
//       widget.formData['roomCleanRemark'],
//       widget.formData['CubicleCleanRemark'],
//       widget.formData['roomTempRemark'],
//       widget.formData['h2gasEmissionRemark'],
//       widget.formData['checkMCBRemark'],
//       widget.formData['dcPDBRemark'],
//       widget.formData['remoteAlarmRemark'],
//       widget.formData['recAlarmRemark'],
//       widget.formData['indRemark'],
//     ];
//
//     for (var remark in remarks) {
//       if (remark != null && remark.toString().isNotEmpty) {
//         return true;
//       }
//     }
//     return false;
//   }
//
//   // Submit remark data to the server
//   Future<void> _submitRemarkData() async {
//     final instance =
//         widget.formData['instance']?.toString() ?? ""; // Handle null instances
//     final recId = widget.recId; // Ensure GenID is passed
//
//     final remarkData = {
//       'recId': recId ?? '', // Pass RecID
//       'uploader': widget.userAccess.username ?? '',
//       'roomCleanRemark$instance':
//       widget.formData['roomCleanRemark']?.toString() ?? '',
//       'CubicleCleanRemark$instance':
//       widget.formData['CubicleCleanRemark']?.toString() ?? '',
//       'roomTempRemark$instance':
//       widget.formData['roomTempRemark']?.toString() ?? '',
//       'h2gasEmissionRemark$instance':
//       widget.formData['h2gasEmissionRemark']?.toString() ?? '',
//       'checkMCBRemark$instance':
//       widget.formData['checkMCBRemark']?.toString() ?? '',
//       'dcPDBRemark$instance': widget.formData['dcPDBRemark']?.toString() ?? '',
//       'remoteAlarmRemark$instance':
//       widget.formData['remoteAlarmRemark']?.toString() ?? '',
//       'recAlarmRemark$instance':
//       widget.formData['recAlarmRemark']?.toString() ?? '',
//       'indRemark$instance': widget.formData['indRemark']?.toString() ?? '',
//       'userName': widget.userAccess.username ?? '',
//     };
//
//     try {
//       // Insert remark data first
//       final remarkResponse = await http
//           .post(Uri.parse('http://124.43.136.185/POSTDailyRECRemarks.php'),
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
//           .get(Uri.parse("http://124.43.136.185/GETDailyRECRemarks.php"))
//           .timeout(const Duration(seconds: 10));
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonResponse = json.decode(response.body);
//         if (jsonResponse.isNotEmpty) {
//           final int remarkId = int.parse(jsonResponse[jsonResponse.length - 1]
//           ['DailyRECRemarkID']
//               .toString()); // Adjust index or condition as needed
//           print(remarkId.toString());
//           print(remarkId.runtimeType);
//           return remarkId;
//         } else {
//           return null;
//         }
//       } else {
//         return null;
//       }
//     } catch (e) {
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
//       'recId': recId ?? '', // Pass Rec ID
//       'userName': widget.userAccess.username ?? '',
//       'clockTime$instance': formattedTime ?? '',
//       'shift$instance': shift ?? '',
//       'DailyRECRemarkID$instance':
//       remarkId.toString() ?? '', // Pass the remark ID
//
//       'region$instance': widget.region,
//       'room$instance': widget.formData['room']?.toString() ?? '',
//       'model$instance': widget.formData['model']?.toString() ?? '',
//       'serialNo$instance': widget.formData['serialNo']?.toString() ?? '',
//       'roomClean$instance': widget.formData['roomClean']?.toString() ?? '',
//       'cubicleClean$instance':
//       widget.formData['cubicleClean']?.toString() ?? '',
//       'roomTemp$instance': widget.formData['roomTemp']?.toString() ?? '',
//       'h2gasEmission$instance':
//       widget.formData['h2gasEmission']?.toString() ?? '',
//       'checkMCB$instance': widget.formData['checkMCB']?.toString() ?? '',
//       'dcPDB$instance': widget.formData['dcPDB']?.toString() ?? '',
//       'remoteAlarm$instance': widget.formData['remoteAlarm']?.toString() ?? '',
//       'noOfWorkingLine$instance':
//       widget.formData['noOfWorkingLine']?.toString() ?? '',
//       'capacity$instance': widget.formData['capacity']?.toString() ?? '',
//       'type$instance': widget.formData['type']?.toString() ?? '',
//       'voltagePs1$instance': widget.formData['voltagePs1']?.toString() ?? '',
//       'voltagePs2$instance': widget.formData['voltagePs2']?.toString() ?? '',
//       'voltagePs3$instance': widget.formData['voltagePs3']?.toString() ?? '',
//       'currentPs1$instance': widget.formData['currentPs1']?.toString() ?? '',
//       'currentPs2$instance': widget.formData['currentPs2']?.toString() ?? '',
//       'currentPs3$instance': widget.formData['currentPs3']?.toString() ?? '',
//       'dcVoltage$instance': widget.formData['dcVoltage']?.toString() ?? '',
//       'dcCurrent$instance': widget.formData['dcCurrent']?.toString() ?? '',
//       'recCapacity$instance': widget.formData['recCapacity']?.toString() ?? '',
//       'recAlarmStatus$instance':
//       widget.formData['recAlarmStatus']?.toString() ?? '',
//       'recIndicatorStatus$instance':
//       widget.formData['recIndicatorStatus']?.toString() ?? '',
//     };
//
//     try {
//       final nonRemarkResponse = await http
//           .post(Uri.parse('http://124.43.136.185/POSTDailyRECCheck.php'),
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
// //without id
// // Submit non-remark data to the server
//   Future<void> _submitNonRemarkDataWithOutId() async {
//     final instance =
//         widget.formData['instance']?.toString() ?? ""; // Handle null instances
//     final recId = widget.recId; // Ensure GenID is passed
//     final region = widget.region;
//
//     final nonRemarkData = {
//       'recId': recId ?? '', // Pass Rec ID
//       'userName': widget.userAccess.username ?? '',
//       'clockTime$instance': formattedTime ?? '',
//       'shift$instance': shift ?? '',
//
//       'region$instance': widget.region,
//       'room$instance': widget.formData['room']?.toString() ?? '',
//       'model$instance': widget.formData['model']?.toString() ?? '',
//       'serialNo$instance': widget.formData['serialNo']?.toString() ?? '',
//       'roomClean$instance': widget.formData['roomClean']?.toString() ?? '',
//       'cubicleClean$instance':
//       widget.formData['cubicleClean']?.toString() ?? '',
//       'roomTemp$instance': widget.formData['roomTemp']?.toString() ?? '',
//       'h2gasEmission$instance':
//       widget.formData['h2gasEmission']?.toString() ?? '',
//       'checkMCB$instance': widget.formData['checkMCB']?.toString() ?? '',
//       'dcPDB$instance': widget.formData['dcPDB']?.toString() ?? '',
//       'remoteAlarm$instance': widget.formData['remoteAlarm']?.toString() ?? '',
//       'noOfWorkingLine$instance':
//       widget.formData['noOfWorkingLine']?.toString() ?? '',
//       'capacity$instance': widget.formData['capacity']?.toString() ?? '',
//       'type$instance': widget.formData['type']?.toString() ?? '',
//       'voltagePs1$instance': widget.formData['voltagePs1']?.toString() ?? '',
//       'voltagePs2$instance': widget.formData['voltagePs2']?.toString() ?? '',
//       'voltagePs3$instance': widget.formData['voltagePs3']?.toString() ?? '',
//       'currentPs1$instance': widget.formData['currentPs1']?.toString() ?? '',
//       'currentPs2$instance': widget.formData['currentPs2']?.toString() ?? '',
//       'currentPs3$instance': widget.formData['currentPs3']?.toString() ?? '',
//       'dcVoltage$instance': widget.formData['dcVoltage']?.toString() ?? '',
//       'dcCurrent$instance': widget.formData['dcCurrent']?.toString() ?? '',
//       'recCapacity$instance': widget.formData['recCapacity']?.toString() ?? '',
//       'recAlarmStatus$instance':
//       widget.formData['recAlarmStatus']?.toString() ?? '',
//       'recIndicatorStatus$instance':
//       widget.formData['recIndicatorStatus']?.toString() ?? '',
//     };
//
//     try {
//       final nonRemarkResponse = await http
//           .post(Uri.parse('http://124.43.136.185/POSTDailyRECCheck.php'),
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
//                     builder: (context) => RectifierMaintenancePage(),
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

//v3 02-07-2024
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
//
// import '../RectifierMaintenancePage.dart';
// import 'package:powerprox/Screens/UserAccess.dart';
//
// class httpPostRectifierInspection extends StatefulWidget {
//   final Map<String, dynamic> formData;
//   final String recId; // Pass the rec ID to the widget
//   final UserAccess userAccess; // Pass UserAccess from the parent widget
//   final String region;
//
//     const httpPostRectifierInspection(
//       {super.key,
//         required this.formData,
//         required this.recId,
//         required this.userAccess,
//         required this.region
//       }
//         );
//
//
//   @override
//   // ignore: library_private_types_in_public_api
//   _httpPostRectifierInspectionState createState() =>
//       _httpPostRectifierInspectionState();
// }
//
// class _httpPostRectifierInspectionState
//     extends State<httpPostRectifierInspection> {
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
//     final recId = widget.recId; // Ensure GenID is passed
//
//     final remarkData = {
//       'recId': recId ?? '', // Pass RecID
//       'uploader': widget.userAccess.username ?? '',
//       'roomCleanRemark$instance': widget.formData['roomCleanRemark']?.toString() ?? '',
//       'CubicleCleanRemark$instance':
//       widget.formData['CubicleCleanRemark']?.toString() ?? '',
//       'roomTempRemark$instance':
//       widget.formData['roomTempRemark']?.toString() ?? '',
//       'h2gasEmissionRemark$instance':
//       widget.formData['h2gasEmissionRemark']?.toString() ?? '',
//       'checkMCBRemark$instance':
//       widget.formData['checkMCBRemark']?.toString() ?? '',
//       'dcPDBRemark$instance': widget.formData['dcPDBRemark']?.toString() ?? '',
//       'remoteAlarmRemark$instance':
//       widget.formData['remoteAlarmRemark']?.toString() ?? '',
//       'recAlarmRemark$instance':
//       widget.formData['recAlarmRemark']?.toString() ?? '',
//       'indRemark$instance': widget.formData['indRemark']?.toString() ?? '',
//       'userName': widget.userAccess.username ?? '',
//     };
//
//     try {
//       // Insert remark data first
//       final remarkResponse = await http
//           .post(Uri.parse('http://124.43.136.185/POSTDailyRECRemarks.php'),
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
//           .get(Uri.parse("http://124.43.136.185/GETDailyRECRemarks.php"))
//           .timeout(const Duration(seconds: 10));
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonResponse = json.decode(response.body);
//         if (jsonResponse.isNotEmpty) {
//           final int remarkId = int.parse(jsonResponse[jsonResponse.length - 1]
//           ['DailyRECRemarkID']
//               .toString()); // Adjust index or condition as needed
//           print(remarkId.toString());
//           print(remarkId.runtimeType);
//           return remarkId;
//         } else {
//           return null;
//         }
//       } else {
//         return null;
//       }
//     } catch (e) {
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
//       'recId': recId ?? '', // Pass Rec ID
//       'userName': widget.userAccess.username ?? '',
//       'clockTime$instance': formattedTime ?? '',
//       'shift$instance': shift ?? '',
//       'DailyRECRemarkID$instance':
//       remarkId.toString() ?? '', // Pass the remark ID
//
//       'region$instance': widget.region,
//       'room$instance': widget.formData['room']?.toString() ?? '',
//       'model$instance': widget.formData['model']?.toString() ?? '',
//       'serialNo$instance': widget.formData['serialNo']?.toString() ?? '',
//       'roomClean$instance': widget.formData['roomClean']?.toString() ?? '',
//       'cubicleClean$instance':
//       widget.formData['cubicleClean']?.toString() ?? '',
//       'roomTemp$instance': widget.formData['roomTemp']?.toString() ?? '',
//       'h2gasEmission$instance':
//       widget.formData['h2gasEmission']?.toString() ?? '',
//       'checkMCB$instance': widget.formData['checkMCB']?.toString() ?? '',
//       'dcPDB$instance': widget.formData['dcPDB']?.toString() ?? '',
//       'remoteAlarm$instance': widget.formData['remoteAlarm']?.toString() ?? '',
//       'noOfWorkingLine$instance':
//       widget.formData['noOfWorkingLine']?.toString() ?? '',
//       'capacity$instance': widget.formData['capacity']?.toString() ?? '',
//       'type$instance': widget.formData['type']?.toString() ?? '',
//       'voltagePs1$instance': widget.formData['voltagePs1']?.toString() ?? '',
//       'voltagePs2$instance': widget.formData['voltagePs2']?.toString() ?? '',
//       'voltagePs3$instance': widget.formData['voltagePs3']?.toString() ?? '',
//       'currentPs1$instance': widget.formData['currentPs1']?.toString() ?? '',
//       'currentPs2$instance': widget.formData['currentPs2']?.toString() ?? '',
//       'currentPs3$instance': widget.formData['currentPs3']?.toString() ?? '',
//       'dcVoltage$instance': widget.formData['dcVoltage']?.toString() ?? '',
//       'dcCurrent$instance': widget.formData['dcCurrent']?.toString() ?? '',
//       'recCapacity$instance': widget.formData['recCapacity']?.toString() ?? '',
//       'recAlarmStatus$instance':
//       widget.formData['recAlarmStatus']?.toString() ?? '',
//       'recIndicatorStatus$instance':
//       widget.formData['recIndicatorStatus']?.toString() ?? '',
//     };
//
//     try {
//       final nonRemarkResponse = await http
//           .post(Uri.parse('http://124.43.136.185/POSTDailyRECCheck.php'),
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
//                     builder: (context) => RectifierMaintenancePage(),
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

//v2 1/07/2024
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
//
// import '../RectifierMaintenancePage.dart';
// import 'package:powerprox/Screens/UserAccess.dart';
//
// class httpPostRectifierInspection extends StatefulWidget {
//   final Map<String, dynamic> formData;
//   final String recId; // Pass the rec ID to the widget
//   final UserAccess userAccess; // Pass UserAccess from the parent widget
//
//   const httpPostRectifierInspection(
//       {super.key,
//         required this.formData,
//         required this.recId,
//         required this.userAccess});
//
//   @override
//   // ignore: library_private_types_in_public_api
//   _httpPostRectifierInspectionState createState() =>
//       _httpPostRectifierInspectionState();
// }
//
// class _httpPostRectifierInspectionState
//     extends State<httpPostRectifierInspection> {
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
//     final recId = widget.recId; // Ensure GenID is passed
//
//     final remarkData = {
//       'recId': recId ?? '', // Pass RecID
//       'uploader': widget.userAccess.username ?? '',
//       'roomCleanRemark$instance': widget.formData['roomCleanRemark']?.toString() ?? '',
//       'CubicleCleanRemark$instance': widget.formData['CubicleCleanRemark']?.toString() ?? '',
//       'roomTempRemark$instance': widget.formData['roomTempRemark']?.toString() ?? '',
//       'h2gasEmissionRemark$instance': widget.formData['h2gasEmissionRemark']?.toString() ?? '',
//       'checkMCBRemark$instance': widget.formData['checkMCBRemark']?.toString() ?? '',
//       'dcPDBRemark$instance': widget.formData['dcPDBRemark']?.toString() ?? '',
//       'remoteAlarmRemark$instance': widget.formData['remoteAlarmRemark']?.toString() ?? '',
//       'recAlarmRemark$instance': widget.formData['recAlarmRemark']?.toString() ?? '',
//       'indRemark$instance': widget.formData['indRemark']?.toString() ?? '',
//     };
//
//     try {
//       // Insert remark data first
//       final remarkResponse = await http
//           .post(Uri.parse('http://124.43.136.185/POSTDailyRECRemarks.php'),
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
//           .get(Uri.parse("http://124.43.136.185/GETDailyRECRemarks.php"))
//           .timeout(const Duration(seconds: 10));
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonResponse = json.decode(response.body);
//         if (jsonResponse.isNotEmpty) {
//           final int remarkId = int.parse(jsonResponse[jsonResponse.length - 1]
//           ['DailyRECRemarkID']
//               .toString()); // Adjust index or condition as needed
//           print(remarkId.toString());
//           print(remarkId.runtimeType);
//           return remarkId;
//         } else {
//           return null;
//         }
//       } else {
//         return null;
//       }
//     } catch (e) {
//       return null;
//     }
//   }
//
//   // Submit non-remark data to the server
//   Future<void> _submitNonRemarkData(int remarkId) async {
//     final instance = widget.formData['instance']?.toString() ?? ""; // Handle null instances
//     final recId = widget.recId; // Ensure GenID is passed
//
//     final nonRemarkData = {
//       'recId': recId ?? '', // Pass Rec ID
//       'userName': widget.userAccess.username ?? '',
//       'clockTime$instance': formattedTime ?? '',
//       'shift$instance': shift ?? '',
//       'DailyRECRemarkID$instance': remarkId.toString()?? '', // Pass the remark ID
//
//       'region$instance': widget.formData['region']?.toString() ?? '',
//       'room$instance': widget.formData['room']?.toString() ?? '',
//       'model$instance': widget.formData['model']?.toString() ?? '',
//       'serialNo$instance': widget.formData['serialNo']?.toString() ?? '',
//       'roomClean$instance': widget.formData['roomClean']?.toString() ?? '',
//       'cubicleClean$instance': widget.formData['cubicleClean']?.toString() ?? '',
//       'roomTemp$instance': widget.formData['roomTemp']?.toString() ?? '',
//       'h2gasEmission$instance': widget.formData['h2gasEmission']?.toString() ?? '',
//       'checkMCB$instance': widget.formData['checkMCB']?.toString() ?? '',
//       'dcPDB$instance': widget.formData['dcPDB']?.toString() ?? '',
//       'remoteAlarm$instance': widget.formData['remoteAlarm']?.toString() ?? '',
//       'noOfWorkingLine$instance': widget.formData['noOfWorkingLine']?.toString() ?? '',
//       'capacity$instance': widget.formData['capacity']?.toString() ?? '',
//       'type$instance': widget.formData['type']?.toString() ?? '',
//       'voltagePs1$instance': widget.formData['voltagePs1']?.toString() ?? '',
//       'voltagePs2$instance': widget.formData['voltagePs2']?.toString() ?? '',
//       'voltagePs3$instance': widget.formData['voltagePs3']?.toString() ?? '',
//       'currentPs1$instance': widget.formData['currentPs1']?.toString() ?? '',
//       'currentPs2$instance': widget.formData['currentPs2']?.toString() ?? '',
//       'currentPs3$instance': widget.formData['currentPs3']?.toString() ?? '',
//       'dcVoltage$instance': widget.formData['dcVoltage']?.toString() ?? '',
//       'dcCurrent$instance': widget.formData['dcCurrent']?.toString() ?? '',
//       'recCapacity$instance': widget.formData['recCapacity']?.toString() ?? '',
//       'recAlarmStatus$instance': widget.formData['recAlarmStatus']?.toString() ?? '',
//       'recIndicatorStatus$instance': widget.formData['recIndicatorStatus']?.toString() ?? '',
//     };
//
//     try {
//       final nonRemarkResponse = await http
//           .post(Uri.parse('http://124.43.136.185/POSTDailyRECCheck.php'),
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
//                     builder: (context) => RectifierMaintenancePage(),
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


//v1 01/07/2024
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
//
// import '../RectifierMaintenancePage.dart';
// import 'package:powerprox/Screens/UserAccess.dart';
//
//
// class httpPostRectifierInspection extends StatefulWidget {
//   final Map<String, dynamic> formData;
//   final String recId; // Pass the rec ID to the widget
//   final String? username;
//   final UserAccess userAccess; // Pass UserAccess from the parent widget
//
//   const httpPostRectifierInspection(
//       {super.key,
//         required this.formData,
//         required this.recId,
//         required this.userAccess, this.username});
//
//   @override
//   // ignore: library_private_types_in_public_api
//   _httpPostRectifierInspectionState createState() =>
//       _httpPostRectifierInspectionState();
// }
//
// class _httpPostRectifierInspectionState extends State<httpPostRectifierInspection> {
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
//     shift = _determineShift(TimeOfDay.now());
//     _submitData();
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
//   // Submit data to the server
//   Future<void> _submitData() async {
//     // const nonRemarkUrl =
//     //     'http://124.43.136.185/POSTDailyCheck.php'; // URL for non-remark data
//     // const remarkUrl =
//     //     'http://124.43.136.185/POSTDailyRemarks.php'; // URL for remark data
//
//     final instance =
//         widget.formData['instance']?.toString() ?? ""; // Handle null instances
//     final recId = widget.recId; // Ensure GenID is passed
//
//     final nonRemarkData = {
//       'recId': recId, // Pass Rec ID
//       'userName': widget.userAccess.username,
//       'clockTime$instance': formattedTime,
//       'shift$instance': shift,
//
//       'region$instance': widget.formData['region']?.toString() ?? '',
//       'room$instance': widget.formData['room']?.toString() ?? '',
//       'model$instance': widget.formData['model']?.toString() ?? '',
//       'serialNo$instance': widget.formData['serialNo']?.toString() ?? '',
//       'roomClean$instance': widget.formData['roomClean']?.toString() ?? '',
//       'cubicleClean$instance':
//       widget.formData['cubicleClean']?.toString() ?? '',
//       'roomTemp$instance': widget.formData['roomTemp']?.toString() ?? '',
//       'h2gasEmission$instance':
//       widget.formData['h2gasEmission']?.toString() ?? '',
//       'checkMCB$instance': widget.formData['checkMCB']?.toString() ?? '',
//       'dcPDB$instance': widget.formData['dcPDB']?.toString() ?? '',
//       'remoteAlarm$instance': widget.formData['remoteAlarm']?.toString() ?? '',
//       'noOfWorkingLine$instance':
//       widget.formData['noOfWorkingLine']?.toString() ?? '',
//       'capacity$instance': widget.formData['capacity']?.toString() ?? '',
//       'type$instance': widget.formData['type']?.toString() ?? '',
//       'voltagePs1$instance': widget.formData['voltagePs1']?.toString() ?? '',
//       'voltagePs2$instance': widget.formData['voltagePs2']?.toString() ?? '',
//       'voltagePs3$instance': widget.formData['voltagePs3']?.toString() ?? '',
//       'currentPs1$instance': widget.formData['currentPs1']?.toString() ?? '',
//       'currentPs2$instance': widget.formData['currentPs2']?.toString() ?? '',
//       'currentPs3$instance': widget.formData['currentPs3']?.toString() ?? '',
//       'dcVoltage$instance': widget.formData['dcVoltage']?.toString() ?? '',
//       'dcCurrent$instance': widget.formData['dcCurrent']?.toString() ?? '',
//       'recCapacity$instance': widget.formData['recCapacity']?.toString() ?? '',
//       'recAlarmStatus$instance':
//       widget.formData['recAlarmStatus']?.toString() ?? '',
//       'recIndicatorStatus$instance':
//       widget.formData['recIndicatorStatus']?.toString() ?? '',
//     };
//
//     final remarkData = {
//       'recId': recId, // Pass RecID
//       'uploader': widget.userAccess.username,
//       'roomCleanRemark$instance':
//       widget.formData['roomCleanRemark']?.toString() ?? '',
//       'CubicleCleanRemark$instance':
//       widget.formData['CubicleCleanRemark']?.toString() ?? '',
//       'roomTempRemark$instance':
//       widget.formData['roomTempRemark']?.toString() ?? '',
//       'h2gasEmissionRemark$instance':
//       widget.formData['h2gasEmissionRemark']?.toString() ?? '',
//       'checkMCBRemark$instance':
//       widget.formData['checkMCBRemark']?.toString() ?? '',
//       'dcPDBRemark$instance': widget.formData['dcPDBRemark']?.toString() ?? '',
//       'remoteAlarmRemark$instance':
//       widget.formData['remoteAlarmRemark']?.toString() ?? '',
//       'recAlarmRemark$instance':
//       widget.formData['recAlarmRemark']?.toString() ?? '',
//       'indRemark$instance': widget.formData['indRemark']?.toString() ?? '',
//     };
//
//     try {
//       final nonRemarkResponse = await http
//           .post(Uri.parse('http://124.43.136.185/POSTDailyRECCheck.php'),
//           body: nonRemarkData)
//           .timeout(const Duration(seconds: 10));
//       final remarkResponse = await http
//           .post(Uri.parse('http://124.43.136.185/POSTDailyRECRemarks.php'),
//           body: remarkData)
//           .timeout(const Duration(seconds: 10));
//
//       if (nonRemarkResponse.statusCode == 200 &&
//           remarkResponse.statusCode == 200) {
//         setState(() {
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//           _errorMessage =
//           'Error inserting data: ${nonRemarkResponse.statusCode} or ${remarkResponse.statusCode}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'Error: ${e.toString()}';
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
//                     builder: (context) => RectifierMaintenancePage(),
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
