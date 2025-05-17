import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert'; // Import this for JSON encoding
import '../genMaintenancePage.dart';





class HttpGeneratorGetPostPage extends StatefulWidget {
  final Map<String, dynamic> formData;
  final String Updator;

  const HttpGeneratorGetPostPage({
    super.key,
    required this.formData,
    required this.Updator,
  });

  @override
  // ignore: library_private_types_in_public_api
  _HttpGeneratorGetPostPageState createState() =>
      _HttpGeneratorGetPostPageState();
}

class _HttpGeneratorGetPostPageState
    extends State<HttpGeneratorGetPostPage> {
  bool _isLoading = true;
  String? _errorMessage;

  late String formattedTime;

  @override
  void initState() {
    super.initState();
    formattedTime = _formatTime(widget.formData['clockTime']?.toString() ?? '');
    _submitData();
    print("form data = ${widget.formData.toString()}");
  }

  String _formatTime(String clockTime) {
    try {
      if (clockTime.isNotEmpty) {
        DateTime dateTime = DateTime.parse(clockTime);
        return DateFormat("yyyy-MM-dd HH:mm").format(dateTime);
      } else {
        return 'Invalid Time';
      }
    } catch (e) {
      return 'Invalid Time';
    }
  }

  // Submit data to the server
  Future<void> _submitData() async {
    final updatedValues = widget.formData;
    final instance = updatedValues['instance']?.toString() ?? "";

    final updatedData = {
      //'GenID': updatedValues['ID'] ?? '',
      'province': updatedValues['Province'] ?? '',
      'Rtom_name': updatedValues['Rtom Name'] ?? '',
      'station': updatedValues['Station'] ?? '',
      'Available': updatedValues['Available'] ?? '',
      'category': updatedValues['Category'] ?? 'Fixed',
      'brand_alt': updatedValues['Brand Alt'] ?? '',
      'brand_eng': updatedValues['Brand Eng'] ?? '',
      'brand_set': updatedValues['Brand Set'] ?? '',
      'model_alt': updatedValues['Model Alt'] ?? '',
      'model_eng': updatedValues['Model Eng'] ?? '',
      'model_set': updatedValues['Model Set'] ?? '',
      'serial_alt': updatedValues['Serial Alt'] ?? '',
      'serial_eng': updatedValues['Serial Eng'] ?? '',
      'serial_set': updatedValues['Serial Set'] ?? '',
      'mode': updatedValues['Mode'] ?? '',
      'phase_eng': updatedValues['Phase Eng'] ?? '1',
      'set_cap': updatedValues['Set Cap'] ?? '0',
      'tank_prime': updatedValues['Tank Prime'] ?? '0',
      'dayTank': updatedValues['Bulk Tank'] ?? '0',
      'dayTankSze': updatedValues['Bulk Tank Size'] ?? '',
      'feederSize': updatedValues['Feeder Size'] ?? '',
      'RatingMCCB': updatedValues['Rating MCCB'] ?? '',
      'RatingATS': updatedValues['Rating ATS'] ?? '',
      'BrandATS': updatedValues['BrandATS'] ?? '',
      'ModelATS': updatedValues['Model ATS'] ?? '',
      'LocalAgent': updatedValues['Local Agent'] ?? '',
      'Agent_Addr': updatedValues['Agent Addr'] ?? '',
      'Agent_Tel': updatedValues['Agent Tel'] ?? '',
      'YoM': updatedValues['Year of Manufacture'] ?? '',
      'Yo_Install': updatedValues['Year of Install'] ?? '',
      'Battery_Capacity': updatedValues['Battery Capacity'] ?? '',
      'Battery_Brand': updatedValues['Battery Brand'] ?? '',
      'Battery_Count': updatedValues['Battery Count'] ?? '',
      'Controller': updatedValues['Controller'] ?? '',
      'controller_model': updatedValues['Controller Model'] ?? '',
      'Updated': updatedValues['Updated'] ?? '',
      'Updated_By': widget.Updator,
      'Latitude': updatedValues['Latitude'] ?? '',
      'Longitude': updatedValues['Longitude'] ?? '',

    };
    try {
      final response = await http.post(
        Uri.parse('http://124.43.136.185:8000/api/generators'), // FastAPI URL
        headers: {"Content-Type": "application/json"}, // JSON header
        body: json.encode(updatedData), // Encode data as JSON
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Response: ${responseData['message']}');
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
          'Error updating data: ${response.statusCode}, Body: ${response.body}';
        });
        print('Response: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
      print('Response: ${e}');
    }
    // try {
    //   final updatePostResponse = await http
    //       .post(Uri.parse('https://powerprox.sltidc.lk/GenAdd.php'),
    //       body: updatedData)
    //       .timeout(const Duration(seconds: 10));
    //
    //   if (updatePostResponse.statusCode == 200) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   } else {
    //     setState(() {
    //       _isLoading = false;
    //       _errorMessage =
    //       'Error inserting data: ${updatePostResponse.statusCode}, Body: ${updatePostResponse.body}';
    //     });
    //   }
    // } catch (e) {
    //   setState(() {
    //     _isLoading = false;
    //     _errorMessage = 'Error: ${e.toString()}';
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DEG Added'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _errorMessage != null
            ? Text(_errorMessage!)
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Data Updated',
              style: TextStyle(fontSize: 24.0),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              child: const Text('Back'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => maintenancePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


//v2 working system with PHP API
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
//
// import '../genMaintenancePage.dart';
//
//
//
//
//
// class HttpGeneratorGetPostPage extends StatefulWidget {
//   final Map<String, dynamic> formData;
//   final String Updator;
//
//   const HttpGeneratorGetPostPage({
//     super.key,
//     required this.formData,
//     required this.Updator,
//   });
//
//   @override
//   // ignore: library_private_types_in_public_api
//   _HttpGeneratorGetPostPageState createState() =>
//       _HttpGeneratorGetPostPageState();
// }
//
// class _HttpGeneratorGetPostPageState
//     extends State<HttpGeneratorGetPostPage> {
//   bool _isLoading = true;
//   String? _errorMessage;
//
//   late String formattedTime;
//
//   @override
//   void initState() {
//     super.initState();
//     formattedTime = _formatTime(widget.formData['clockTime']?.toString() ?? '');
//     _submitData();
//     print("form data = ${widget.formData.toString()}");
//   }
//
//   String _formatTime(String clockTime) {
//     try {
//       if (clockTime.isNotEmpty) {
//         DateTime dateTime = DateTime.parse(clockTime);
//         return DateFormat("yyyy-MM-dd HH:mm").format(dateTime);
//       } else {
//         return 'Invalid Time';
//       }
//     } catch (e) {
//       return 'Invalid Time';
//     }
//   }
//
//   // Submit data to the server
//   Future<void> _submitData() async {
//     final updatedValues = widget.formData;
//     final instance = updatedValues['instance']?.toString() ?? "";
//
//     final updatedData = {
//       //'GenID': updatedValues['ID'] ?? '',
//       'province': updatedValues['Province'] ?? '',
//       'Rtom_name': updatedValues['Rtom Name'] ?? '',
//       'station': updatedValues['Station'] ?? '',
//       'Available': updatedValues['Available'] ?? '',
//       'category': updatedValues['Category'] ?? 'Fixed',
//       'brand_alt': updatedValues['Brand Alt'] ?? '',
//       'brand_eng': updatedValues['Brand Eng'] ?? '',
//       'brand_set': updatedValues['Brand Set'] ?? '',
//       'model_alt': updatedValues['Model Alt'] ?? '',
//       'model_eng': updatedValues['Model Eng'] ?? '',
//       'model_set': updatedValues['Model Set'] ?? '',
//       'serial_alt': updatedValues['Serial Alt'] ?? '',
//       'serial_eng': updatedValues['Serial Eng'] ?? '',
//       'serial_set': updatedValues['Serial Set'] ?? '',
//       'mode': updatedValues['Mode'] ?? '',
//       'phase_eng': updatedValues['Phase Eng'] ?? '1',
//       'set_cap': updatedValues['Set Cap'] ?? '0',
//       'tank_prime': updatedValues['Tank Prime'] ?? '0',
//       'dayTank': updatedValues['Bulk Tank'] ?? '0',
//       'dayTankSze': updatedValues['Bulk Tank Size'] ?? '',
//       'feederSize': updatedValues['Feeder Size'] ?? '',
//       'RatingMCCB': updatedValues['Rating MCCB'] ?? '',
//       'RatingATS': updatedValues['Rating ATS'] ?? '',
//       'BrandATS': updatedValues['BrandATS'] ?? '',
//       'ModelATS': updatedValues['Model ATS'] ?? '',
//       'LocalAgent': updatedValues['Local Agent'] ?? '',
//       'Agent_Addr': updatedValues['Agent Addr'] ?? '',
//       'Agent_Tel': updatedValues['Agent Tel'] ?? '',
//       'YoM': updatedValues['Year of Manufacture'] ?? '',
//       'Yo_Install': updatedValues['Year of Install'] ?? '',
//       'Battery_Capacity': updatedValues['Battery Capacity'] ?? '',
//       'Battery_Brand': updatedValues['Battery Brand'] ?? '',
//       'Battery_Count': updatedValues['Battery Count'] ?? '',
//       'Controller': updatedValues['Controller'] ?? '',
//       'controller_model': updatedValues['Controller Model'] ?? '',
//       'Updated': updatedValues['Updated'] ?? '',
//       'Updated_By': widget.Updator,
//       'Latitude': updatedValues['Latitude'] ?? '',
//       'Longitude': updatedValues['Longitude'] ?? '',
//
//     };
//
//     try {
//       final updatePostResponse = await http
//           .post(Uri.parse('https://powerprox.sltidc.lk/GenAdd.php'),
//           body: updatedData)
//           .timeout(const Duration(seconds: 10));
//
//       if (updatePostResponse.statusCode == 200) {
//         setState(() {
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//           _errorMessage =
//           'Error inserting data: ${updatePostResponse.statusCode}, Body: ${updatePostResponse.body}';
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
//         title: const Text('DEG Added'),
//       ),
//       body: Center(
//         child: _isLoading
//             ? const CircularProgressIndicator()
//             : _errorMessage != null
//             ? Text(_errorMessage!)
//             : Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Text(
//               'Data Updated',
//               style: TextStyle(fontSize: 24.0),
//             ),
//             const SizedBox(height: 20.0),
//             ElevatedButton(
//               child: const Text('Back'),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => maintenancePage(),
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


//v2
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../../UserAccess.dart';
// import '../genMaintenancePage.dart';
//
// //import 'package:slt_power_prox_new/MyHomePage.dart';
//
// // import '../../Screens/Generators/genMaintenancePage.dart';
//
// class httpPostGen extends StatefulWidget {
//   final Map<String, dynamic> formData;
//   final UserAccess userAccess; // Pass UserAccess from the parent widget
//
//   httpPostGen({required this.formData,
//     required this.userAccess});
//
//   @override
//   _httpPostGenState createState() => _httpPostGenState();
// }
//
// class _httpPostGenState extends State<httpPostGen> {
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
//     final url = 'https://powerprox.sltidc.lk/GenAdd.php'; // Replace with your PHP script URL
//     final response = await http.post(Uri.parse(url), body: {
//       'province': widget.formData['province'],
//       'Rtom_name': widget.formData['Rtom_name'],
//       'station': widget.formData['station'],
//       'Available': widget.formData['Available'],
//       'category': widget.formData['category'],
//       'brand_alt': widget.formData['brand_alt'],
//       'brand_eng': widget.formData['brand_eng'],
//       'brand_set': widget.formData['brand_set'],
//       'model_alt': widget.formData['model_alt'],
//       'model_eng': widget.formData['model_eng'],
//       'model_set': widget.formData['model_set'],
//       'serial_alt' : widget.formData['serial_alt'],
//       'serial_eng' : widget.formData['serial_eng'],
//       'serial_set' : widget.formData['serial_set'],
//       'mode' : widget.formData['mode'],
//       'phase_eng' : widget.formData['phase_eng'],
//       'set_cap' : widget.formData['set_cap'],
//       'tank_prime' : widget.formData['tank_prime'],
//       'dayTank' : widget.formData['dayTank'],
//       'dayTankSze' : widget.formData['dayTankSze'],
//       'feederSize' : widget.formData['feederSize'],
//       'RatingMCCB' : widget.formData['RatingMCCB'],
//       'RatingATS' : widget.formData['RatingATS'],
//       'BrandATS' : widget.formData['BrandATS'],
//       'ModelATS' : widget.formData['ModelATS'],
//       'LocalAgent' : widget.formData['LocalAgent'],
//       'Agent_Addr' : widget.formData['Agent_Addr'],
//       'Agent_Tel' : widget.formData['Agent_Tel'],
//       'YoM' : widget.formData['YoM'],
//       'Yo_Install' : widget.formData['Yo_Install'],
//       'Controller' : widget.formData['Controller'],
//       'controller_model' : widget.formData['controller_model'],
//       'Battery_Capacity' : widget.formData['Battery_Capacity'],
//       'Battery_Brand' : widget.formData['Battery_Brand'],
//       'Battery_Count' : widget.formData['Battery_Count'],
//       'Latitude' : widget.formData['Latitude'],
//       'Longitude' : widget.formData['Longitude'],
//       'Submitter' : widget.userAccess.username,
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
//                   MaterialPageRoute(builder: (context) => maintenancePage()),
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




//   import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class httpPostGen extends StatefulWidget {
//   late final Map<String, dynamic> formData;
//
//   httpPostGen({required this.formData});
//
//   @override
//   _httpPostGenState createState() => _httpPostGenState();
// }
//
// class _httpPostGenState extends State<httpPostGen> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     // Get the values from formData
//     String province = widget.formData['province'];
//     String Rtom_name = widget.formData['Rtom_name'];
//     String station = widget.formData['station'];
//     String Available = widget.formData['Available'];
//     String category = widget.formData['category'];
//     String brand_alt = widget.formData['brand_alt'];
//     String brand_eng = widget.formData['brand_eng'];
//     String brand_set = widget.formData['brand_set'];
//     String model_alt = widget.formData['model_alt'];
//     String model_eng = widget.formData['model_eng'];
//     String model_set = widget.formData['model_set'];
//     String serial_alt = widget.formData['serial_alt'];
//     String serial_eng = widget.formData['serial_eng'];
//     String serial_set = widget.formData['serial_set'];
//     String mode = widget.formData['mode'];
//     String phase_eng = widget.formData['phase_eng'];
//     String set_cap = widget.formData['set_cap'];
//     String tank_prime = widget.formData['tank_prime'];
//     String dayTank = widget.formData['dayTank'];
//     String dayTankSze = widget.formData['dayTankSze'];
//     String feederSize = widget.formData['feederSize'];
//     String RatingMCCB = widget.formData['RatingMCCB'];
//     String RatingATS = widget.formData['RatingATS'];
//     String BrandATS = widget.formData['BrandATS'];
//     String ModelATS = widget.formData['ModelATS'];
//     String LocalAgent = widget.formData['LocalAgent'];
//     String Agent_Addr = widget.formData['Agent_Addr'];
//     String Agent_Tel = widget.formData['Agent_Tel'];
//     String YoM = widget.formData['YoM'];
//     String Yo_Install = widget.formData['Yo_Install'];
//
//
//     // Function to send data to PHP script
//     Future<void> insertData() async {
//       final url = 'https://geninfo1.000webhostapp.com/GenAdd.php'; // Replace with your PHP script URL
//       final response = await http.post(Uri.parse(url), body: {
//         //'ID': '398', // Replace with the actual values you want to insert
//         'province': widget.formData['province'],
//         'Rtom_name': Rtom_name,
//         'station': station,
//         'Available': Available, // Add other variables here
//         'category': category,
//         'brand_alt': brand_alt,
//         'brand_eng': brand_eng,
//         'brand_set': brand_set,
//         'model_alt': model_alt,
//         'model_eng': model_eng,
//         'model_set': model_set,
//         'serial_alt': serial_alt,
//         'serial_eng': serial_eng,
//         'serial_set': serial_set,
//         'mode': mode,
//         'phase_eng': phase_eng,
//         'set_cap': set_cap,
//         'tank_prime': tank_prime,
//         'dayTank': dayTank,
//         'dayTankSze': dayTankSze,
//         'feederSize': feederSize,
//         'RatingMCCB': RatingMCCB,
//         'RatingATS': RatingATS,
//         'BrandATS': BrandATS,
//         'ModelATS': ModelATS,
//         'LocalAgent': LocalAgent,
//         'Agent_Addr': Agent_Addr,
//         'Agent_Tel': Agent_Tel,
//         'YoM': YoM,
//         'Yo_Install': Yo_Install,
//       });
//
//       //print('Response status code: ${response.statusCode}'); // Print the status code
//       // print('Response body: ${response.body}'); // Print the response body
//
//       if (response.statusCode == 200) {
//         //print('Response status code: ${response.statusCode}');
//         //print('Response body: ${response.body}');
//         final responseBody = json.decode(response.body);
//       } else {
//         throw Exception('Error inserting data: ${response.statusCode}');
//       }
//     }
//
//
//     insertData(); // Execute the function to insert data into MySQL database
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('HTTP POST Generated'),
//       ),
//       body: Center(
//         child: FutureBuilder<http.Response>(
//             future: _insertData,
//             builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
//               if (snapshot.hasData) {
//                 final response = snapshot.data!;
//                 if (response.statusCode == 200) {
//                   final responseBody = json.decode(response.body);
//                   return Text('Response Status: ${response.statusCode}\n\n'
//                       'Response Body: $responseBody');
//                 } else {
//                   throw Exception('Error inserting data: ${response.statusCode}');
//                 }
//               } else if (snapshot.hasError) {
//                 return Text('Error: ${snapshot.error}');
//               } else {
//                 return const CircularProgressIndicator();
//               }
//             }),
//       ),
//     );
// }
