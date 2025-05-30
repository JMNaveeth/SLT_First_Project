
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

// import '../../../UserAccess.dart';
// import '../SPDMaintenancePage.dart';


class httpPostSPD extends StatefulWidget {
  final Map<String, dynamic> formData;
  final bool dcFlag;
//  final UserAccess userAccess; // Pass UserAccess from the parent widget

  httpPostSPD({
    required this.formData,
    required this.dcFlag,
  //  required this.userAccess
    }
    );
     // Add UserAccess as a parameter
  @override
  _httpPostSPDState createState() => _httpPostSPDState();
}

class _httpPostSPDState extends State<httpPostSPD> {
  bool _isLoading = true;
  String? _errorMessage;
  // String? username=widget.userAccess.username; // Declare username as a class field


  // UserAccess userAccess = Provider.of<UserAccess>(context, listen: true); // Use listen: true to rebuild the widget when the data changes
  //
  // String? username = userAccess.username;
  // print('Username: $username');


  @override
  void initState() {
    super.initState();
      _insertData();


  }

  Future<void> _insertData() async {
    final url = 'https://powerprox.sltidc.lk/SPDadd.php'; // Replace with your PHP script URL
    // print('');
    try {
      final response = await http.post(Uri.parse(url), body: {

        //dc part
        'province': widget.formData['province'].toString() ?? '',
        'Rtom_name': widget.formData['Rtom_name'].toString() ?? '',
        'station': widget.formData['station'].toString() ?? '',
        'SPDLoc': widget.formData['SPDLoc'].toString() ?? '',
        'DCFlag': widget.dcFlag ? '1' : '0',
        'poles': widget.formData['poles'].toString() ?? '',
        'SPDType': widget.formData['SPDType'].toString() ?? '',
        'SPD_Manu': widget.formData['SPD_Manu'].toString() ?? '',
        'model_SPD': widget.formData['model_SPD'].toString() ?? '',
        'status': widget.formData['status'].toString() ?? '',
        'PercentageR': widget.formData['PercentageR'].toString() ?? '',
        'PercentageY': widget.formData['PercentageY'].toString() ?? '',
        'PercentageB': widget.formData['PercentageB'].toString() ?? '',
        'nom_volt': widget.formData['nom_volt'].toString() ?? '',
        'UcDCVolt': widget.formData['UcDCVolt'].toString() ?? '',
        'UpDCVolt': widget.formData['UpDCVolt'].toString() ?? '',
        'Nom_Dis8_20': widget.formData['Nom_Dis8_20'].toString() ?? '',
        'Nom_Dis10_350': widget.formData['Nom_Dis10_350'].toString() ?? '',
        'installDt': widget.formData['installDt'].toString() ?? '',
        'warrentyDt': widget.formData['warrentyDt'].toString() ?? '',
        'Notes': widget.formData['Notes'].toString() ?? '',

        //ac part
        'modular': widget.formData['modular'].toString() ?? '',
        'phase': widget.formData['phase'].toString() ?? '',
        'UcLiveMode': widget.formData['UcLiveMode'].toString() ?? '',
        'UcLiveVolt': widget.formData['UcLiveVolt'].toString() ?? '',
        'UcNeutralVolt': widget.formData['UcNeutralVolt'].toString() ?? '',
        'UpLiveVolt': widget.formData['UpLiveVolt'].toString() ?? '',
        'UpNeutralVolt': widget.formData['UpNeutralVolt'].toString() ?? '',
        'dischargeType': widget.formData['dischargeType'].toString() ?? '',


        'L8to20NomD': widget.formData['L8to20NomD'].toString() ?? '',
        'N8to20NomD': widget.formData['N8to20NomD'].toString() ?? '',
        'L10to350ImpD': widget.formData['L10to350ImpD'].toString() ?? '',
        'N10to350ImpD': widget.formData['N10to350ImpD'].toString() ?? '',
        'mcbRating': widget.formData['mcbRating'].toString() ?? '',
        'responseTime': widget.formData['responseTime'].toString() ?? '',
       // 'Submitter' : widget.userAccess.username,

      }).timeout(Duration(seconds: 10)); // Adding a timeout of 10 seconds.

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error inserting data: ${response.statusCode}';
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
      appBar: AppBar(
        title: Text('Data Update'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _errorMessage != null
            ? Text(_errorMessage!)
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Data updated',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              child: Text('Back'),
              onPressed: () {
                // Return to maintenance page
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => SPDMaintenancePage(),
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








//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:powerprox/Screens/SPDMaintenancePage.dart';
// import 'dart:convert';
//
// import '../../Screens/genMaintenancePage.dart';
//
// class httpPostSPD extends StatefulWidget {
//   final Map<String, dynamic> formData;
//
//   httpPostSPD({required this.formData});
//
//   @override
//   _httpPostSPDState createState() => _httpPostSPDState();
// }
//
// class _httpPostSPDState extends State<httpPostSPD> {
//
//   bool _isLoading = true;
//   String? _errorMessage;
//
//   @override
//   void initState() {
//     super.initState();
//     _insertData();
//   }
//
//   Future<void> _insertData() async {
//     final url = 'https://geninfo1.000webhostapp.com/SPDAdd.php'; // Replace with your PHP script URL
//     final response = await http.post(Uri.parse(url), body: {
//       'province': widget.formData['province'],
//       'Rtom_name': widget.formData['Rtom_name'],
//       'station': widget.formData['station'],
//       'SPDLoc': widget.formData['SPDLoc'],
//       'SPDPower': widget.formData['SPDPower'],
//       'phase': widget.formData['phase'],
//       'SPDType': widget.formData['SPDType'],
//       'SPD_Manu': widget.formData['SPD_Manu'],
//       'model_SPD': widget.formData['model_SPD'],
//       'status': widget.formData['status'],
//       'Percentage': widget.formData['Percentage'],
//       'nom_volt' : widget.formData['nom_volt'],
//       'prot_volt' : widget.formData['prot_volt'],
//       'surge_rat' : widget.formData['surge_rating'],
//       'installDt' : widget.formData['installDt'],
//       'warrentyDt' : widget.formData['warrentyDt'],
//
//
//     });
//
//     if (response.statusCode == 200) {
//       setState(() {
//         _isLoading = false;
//       });
//     } else {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'Error inserting data: ${response.statusCode}';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Data Update'),
//       ),
//       body: Center(
//         child: _isLoading
//             ? CircularProgressIndicator()
//             : _errorMessage != null
//             ? Text(_errorMessage!)
//             : Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Data updated',
//               style: TextStyle(fontSize: 24.0),
//             ),
//             SizedBox(height: 20.0),
//             ElevatedButton(
//               child: Text('Back'),
//               onPressed: () {
//                 //return to maintenance page
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SPDMaintenancePage()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
