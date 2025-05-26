import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';

//import '../../../UserAccess.dart';
import 'RectifierRoutineInspection.dart';

class selectRectifierToInspect extends StatefulWidget {
  @override
  _selectRectifierToInspectState createState() =>
      _selectRectifierToInspectState();
}

class _selectRectifierToInspectState extends State<selectRectifierToInspect> {
  var regions = [
    'ALL',
    'CPN',
    'CPS',
    'EPN',
    'EPS',
    'EPN–TC',
    'HQ',
    'NCP',
    'NPN',
    'NPS',
    'NWPE',
    'NWPW',
    'PITI',
    'SAB',
    'SMW6',
    'SPE',
    'SPW',
    'WEL',
    'WPC',
    'WPE',
    'WPN',
    'WPNE',
    'WPS',
    'WPSE',
    'WPSW',
    'UVA',
  ];

  String selectedRegion = 'ALL'; // Initial selected region
  List<dynamic> RectifierSystems = []; // List to store Rectifier system data
  bool isLoading = true; // Flag to track if data is being loaded

  Future<void> fetchRectifierSystems() async {
    final url =
        'https://powerprox.sltidc.lk/GetRecSys.php'; // Replace with the URL of your PHP script

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        RectifierSystems = json.decode(response.body);
        isLoading = false; // Set isLoading to false once data is loaded
      });
    } else {
      // Handle the error case
      print('Failed to fetch Rectifier systems');
      isLoading = false; // Set isLoading to false in case of an error
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRectifierSystems();
  }

  void navigateToRectifierUnitDetails({
    required RectifierUnit,
    required String region,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => InspectionRec(
              RectifierUnit: RectifierUnit,
              region: region,
              availableModule: RectifierUnit['PWModsAvail'], //Pass real values
              capacity: RectifierUnit['FrameCap'],
              makeType: RectifierUnit['FrameCapType'],
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //  UserAccess userAccess = Provider.of<UserAccess>
    (
      context,
      listen: true,
    ); // Use listen: true to rebuild the widget when the data changes
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: customColors.appbarColor,
        iconTheme: IconThemeData(color: customColors.mainTextColor),
        title: Text(
          'Rectifier Details',
          style: TextStyle(color: customColors.mainTextColor, fontSize: 20),
        ),
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),
      body: Container(
        color:
            customColors
                .mainBackgroundColor, // Set the background color to white
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<String>(
                value: selectedRegion,
                style: TextStyle(color: customColors.mainTextColor),
                decoration: InputDecoration(
                  labelText: 'Select Region',
                  labelStyle: TextStyle(color: customColors.mainTextColor),
                ),
                dropdownColor: customColors.suqarBackgroundColor,
                onChanged: (value) {
                  setState(() {
                    selectedRegion = value!;
                  });
                },
                items:
                    regions.map((region) {
                      return DropdownMenuItem<String>(
                        value: region,
                        child: Text(region),
                      );
                    }).toList(),
              ),
            ),
            Expanded(
              child:
                  isLoading
                      ? Center(
                        child:
                            CircularProgressIndicator(), // Show loading indicator
                      )
                      : ListView.builder(
                        itemCount: RectifierSystems.length,
                        itemBuilder: (context, index) {
                          final system = RectifierSystems[index];
                          if (selectedRegion == 'ALL' ||
                              system['Region'] == selectedRegion) {
                            return Card(
                              // Wrap ListTile with Card
                              elevation: 5,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              color: customColors.suqarBackgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ListTile(
                                title: Text(
                                  '${system['Brand']} - ${system['Model']}',
                                  style: TextStyle(
                                    color: customColors.mainTextColor,
                                  ),
                                ),
                                subtitle: Text(
                                  'Location: ${system['Region']}-${system['RTOM']}',
                                  style: TextStyle(
                                    color: customColors.mainTextColor,
                                  ),
                                ),
                                onTap: () {
                                  navigateToRectifierUnitDetails(
                                    RectifierUnit: system,
                                    region:
                                        "${system['Region']}-${system['RTOM']}",
                                  );
                                },
                              ),
                            );
                          } else {
                            return SizedBox.shrink(); // Return an empty SizedBox for non-matching regions
                          }
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

//v3 10-07-2024
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
//
// import '../../UserAccess.dart';
// import 'RectifierRoutineInspection.dart';
//
// class selectRectifierToInspect extends StatefulWidget {
//   @override
//   _selectRectifierToInspectState createState() =>
//       _selectRectifierToInspectState();
// }
//
// class _selectRectifierToInspectState extends State<selectRectifierToInspect> {
//   var regions = [
//     'ALL',
//     'CPN',
//     'CPS',
//     'EPN',
//     'EPS',
//     'EPN–TC',
//     'HQ',
//     'NCP',
//     'NPN',
//     'NPS',
//     'NWPE',
//     'NWPW',
//     'PITI',
//     'SAB',
//     'SMW6',
//     'SPE',
//     'SPW',
//     'WEL',
//     'WPC',
//     'WPE',
//     'WPN',
//     'WPNE',
//     'WPS',
//     'WPSE',
//     'WPSW',
//     'UVA'
//   ];
//
//   String selectedRegion = 'ALL'; // Initial selected region
//   List<dynamic> RectifierSystems = []; // List to store Rectifier system data
//   bool isLoading = true; // Flag to track if data is being loaded
//
//   Future<void> fetchRectifierSystems() async {
//     final url =
//         'http://124.43.136.185/GetRecSys.php'; // Replace with the URL of your PHP script
//
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       setState(() {
//         RectifierSystems = json.decode(response.body);
//         isLoading = false; // Set isLoading to false once data is loaded
//       });
//     } else {
//       // Handle the error case
//       print('Failed to fetch Rectifier systems');
//       isLoading = false; // Set isLoading to false in case of an error
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchRectifierSystems();
//   }
//
//   void navigateToRectifierUnitDetails({required RectifierUnit, required String region}) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             InspectionRec(RectifierUnit: RectifierUnit, region: region),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     UserAccess userAccess = Provider.of<UserAccess>(context,
//         listen:
//         true); // Use listen: true to rebuild the widget when the data changes
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Rectifier Details'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: DropdownButtonFormField<String>(
//               value: selectedRegion,
//               decoration: InputDecoration(
//                 labelText: 'Select Region',
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   selectedRegion = value!;
//                 });
//               },
//               items: regions.map((region) {
//                 return DropdownMenuItem<String>(
//                   value: region,
//                   child: Text(region),
//                 );
//               }).toList(),
//             ),
//           ),
//           Expanded(
//             child: isLoading
//                 ? Center(
//               child:
//               CircularProgressIndicator(), // Show loading indicator
//             )
//                 : ListView.builder(
//               itemCount: RectifierSystems.length,
//               itemBuilder: (context, index) {
//                 final system = RectifierSystems[index];
//                 if (selectedRegion == 'ALL' ||
//                     system['Region'] == selectedRegion) {
//                   return ListTile(
//                     title:
//                     Text('${system['Brand']} - ${system['Model']}'),
//                     subtitle: Text(
//                         'Location: ${system['Region']}-${system['RTOM']}'),
//                     onTap: () {
//                       navigateToRectifierUnitDetails(
//                           RectifierUnit: system,
//                           region: "${system['Region']}-${system['RTOM']}");
//                     },
//                   );
//                 } else {
//                   return SizedBox
//                       .shrink(); // Return an empty SizedBox for non-matching regions
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//v2 01/07/2024
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
//
// import '../../UserAccess.dart';
// import 'RectifierRoutineInspection.dart';
//
// class selectRectifierToInspect extends StatefulWidget {
//   @override
//   _selectRectifierToInspectState createState() => _selectRectifierToInspectState();
// }
//
// class _selectRectifierToInspectState extends State<selectRectifierToInspect> {
//   var regions = [
//     'ALL',
//     'CPN',
//     'CPS',
//     'EPN',
//     'EPS',
//     'EPN–TC',
//     'HQ',
//     'NCP',
//     'NPN',
//     'NPS',
//     'NWPE',
//     'NWPW',
//     'PITI',
//     'SAB',
//     'SMW6',
//     'SPE',
//     'SPW',
//     'WEL',
//     'WPC',
//     'WPE',
//     'WPN',
//     'WPNE',
//     'WPS',
//     'WPSE',
//     'WPSW',
//     'UVA'
//   ];
//
//   String selectedRegion = 'ALL'; // Initial selected region
//   List<dynamic> RectifierSystems = []; // List to store Rectifier system data
//   bool isLoading = true; // Flag to track if data is being loaded
//
//   Future<void> fetchRectifierSystems() async {
//     final url =
//         'http://124.43.136.185/GetRecSys.php'; // Replace with the URL of your PHP script
//
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       setState(() {
//         RectifierSystems = json.decode(response.body);
//         isLoading = false; // Set isLoading to false once data is loaded
//       });
//     } else {
//       // Handle the error case
//       print('Failed to fetch Rectifier systems');
//       isLoading = false; // Set isLoading to false in case of an error
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchRectifierSystems();
//   }
//
//   void navigateToRectifierUnitDetails(dynamic RectifierUnit) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => InspectionRec(RectifierUnit: RectifierUnit,),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     UserAccess userAccess = Provider.of<UserAccess>(context, listen: true); // Use listen: true to rebuild the widget when the data changes
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Rectifier Details'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: DropdownButtonFormField<String>(
//               value: selectedRegion,
//               decoration: InputDecoration(
//                 labelText: 'Select Region',
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   selectedRegion = value!;
//                 });
//               },
//               items: regions.map((region) {
//                 return DropdownMenuItem<String>(
//                   value: region,
//                   child: Text(region),
//                 );
//               }).toList(),
//             ),
//           ),
//           Expanded(
//             child: isLoading
//                 ? Center(
//               child: CircularProgressIndicator(), // Show loading indicator
//             )
//                 : ListView.builder(
//               itemCount: RectifierSystems.length,
//               itemBuilder: (context, index) {
//                 final system = RectifierSystems[index];
//                 if (selectedRegion == 'ALL' || system['Region'] == selectedRegion) {
//                   return ListTile(
//                     title: Text('${system['Brand']} - ${system['Model']}'),
//                     subtitle: Text('Location: ${system['Region']}-${system['RTOM']}'),
//                     onTap: () {
//                       navigateToRectifierUnitDetails(system);
//                     },
//                   );
//                 } else {
//                   return SizedBox.shrink(); // Return an empty SizedBox for non-matching regions
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//v1 01/07/2024
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
//
// import '../../UserAccess.dart';
// import 'RectifierRoutineInspection.dart';
//
// class selectRectifierToInspect extends StatefulWidget {
//   @override
//   _selectRectifierToInspectState createState() => _selectRectifierToInspectState();
// }
//
// class _selectRectifierToInspectState extends State<selectRectifierToInspect> {
//   var regions = [
//     'ALL',
//     'CPN',
//     'CPS',
//     'EPN',
//     'EPS',
//     'EPN–TC',
//     'HQ',
//     'NCP',
//     'NPN',
//     'NPS',
//     'NWPE',
//     'NWPW',
//     'PITI',
//     'SAB',
//     'SMW6',
//     'SPE',
//     'SPW',
//     'WEL',
//     'WPC',
//     'WPE',
//     'WPN',
//     'WPNE',
//     'WPS',
//     'WPSE',
//     'WPSW',
//     'UVA'
//   ];
//
//   String selectedRegion = 'ALL'; // Initial selected region
//   List<dynamic> RectifierSystems = []; // List to store Rectifier system data
//   bool isLoading = true; // Flag to track if data is being loaded
//
//   Future<void> fetchRectifierSystems() async {
//     final url =
//         'http://124.43.136.185/GetRecSys.php'; // Replace with the URL of your PHP script
//
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       setState(() {
//         RectifierSystems = json.decode(response.body);
//         isLoading = false; // Set isLoading to false once data is loaded
//       });
//     } else {
//       // Handle the error case
//       print('Failed to fetch Rectifier systems');
//       isLoading = false; // Set isLoading to false in case of an error
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchRectifierSystems();
//   }
//
//   void navigateToRectifierUnitDetails(dynamic RectifierUnit) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => InspectionRec(RectifierUnit: RectifierUnit,),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     UserAccess userAccess = Provider.of<UserAccess>(context, listen: true); // Use listen: true to rebuild the widget when the data changes
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Rectifier Details'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: DropdownButtonFormField<String>(
//               value: selectedRegion,
//               decoration: InputDecoration(
//                 labelText: 'Select Region',
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   selectedRegion = value!;
//                 });
//               },
//               items: regions.map((region) {
//                 return DropdownMenuItem<String>(
//                   value: region,
//                   child: Text(region),
//                 );
//               }).toList(),
//             ),
//           ),
//           Expanded(
//             child: isLoading
//                 ? Center(
//               child: CircularProgressIndicator(), // Show loading indicator
//             )
//                 : ListView.builder(
//               itemCount: RectifierSystems.length,
//               itemBuilder: (context, index) {
//                 final system = RectifierSystems[index];
//                 if (selectedRegion == 'ALL' || system['Region'] == selectedRegion) {
//                   return ListTile(
//                     title: Text('${system['Brand']} - ${system['Model']}'),
//                     subtitle: Text('Location: ${system['Region']}-${system['RTOM']}'),
//                     onTap: () {
//                       navigateToRectifierUnitDetails(system);
//                     },
//                   );
//                 } else {
//                   return SizedBox.shrink(); // Return an empty SizedBox for non-matching regions
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
