import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:powerprox/Screens/UPS/UPSRoutineInspection/UPSRoutineInspection.dart';
import 'package:provider/provider.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';

//import '../../UserAccess.dart';
import 'UPSRoutineInspection.dart';

class selectUPSToInspect extends StatefulWidget {
  @override
  _selectUPSToInspectState createState() => _selectUPSToInspectState();
}

class _selectUPSToInspectState extends State<selectUPSToInspect> {
  var Region = [
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

  String selectedprovince = 'ALL'; // Initial selected province
  List<dynamic> UPSSystems = []; // List to store Rectifier system data
  bool isLoading = true; // Flag to track if data is being loaded

  Future<void> fetchUPSSystems() async {
    final url =
        'https://powerprox.sltidc.lk/GetUpsSystems.php'; // Replace with the URL of your PHP script

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        UPSSystems = json.decode(response.body);
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
    fetchUPSSystems();
  }

  void navigateToUPSUnitDetails({required UPSUnit, required String region}) {
    print("test");
    print(region);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => UPSRoutineInspection(UPSUnit: UPSUnit, region: region),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // UserAccess userAccess = Provider.of<UserAccess>(context, listen: true); // Use listen: true to rebuild the widget when the data changes
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: customColors.appbarColor,
        iconTheme: IconThemeData(color: customColors.mainTextColor),
        title: Text(
          'UPS Details',
          style: TextStyle(color: customColors.mainTextColor, fontSize: 20),
        ),
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),
      body: Container(
        // Wrap Column with a Container
        color:
            customColors
                .mainBackgroundColor, // Set the background color to white
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<String>(
                value: selectedprovince,
                style: TextStyle(color: customColors.mainTextColor),
                decoration: InputDecoration(
                  labelText: 'Select province',
                  labelStyle: TextStyle(color: customColors.mainTextColor),
                ),
                 dropdownColor: customColors.suqarBackgroundColor,
                onChanged: (value) {
                  setState(() {
                    selectedprovince = value!;
                  });
                },
                items:
                    Region.map((province) {
                      return DropdownMenuItem<String>(
                        value: province,
                        child: Text(province),
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
                        itemCount: UPSSystems.length,
                        itemBuilder: (context, index) {
                          final system = UPSSystems[index];
                          if (selectedprovince == 'ALL' ||
                              system['Region'] == selectedprovince) {
                            return Card( // Wrap ListTile with Card
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
                                style: TextStyle(color: customColors.mainTextColor),
                              ),
                              subtitle: Text(
                                'Location: ${system['Region']}-${system['RTOM']}',
                                 style: TextStyle(color: customColors.mainTextColor),
                              ),
                              onTap: () {
                                navigateToUPSUnitDetails(
                                  UPSUnit: system,
                                  region:
                                      "${system['Region']}-${system['RTOM']}",
                                );
                              },
                            ),
                            );
                          } else {
                            return SizedBox.shrink(); // Return an empty SizedBox for non-matching Region
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

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:powerprox/Screens/UPS/UPSRoutineInspection/UPSRoutineInspection.dart';
import 'package:provider/provider.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';

//import '../../UserAccess.dart';
import 'UPSRoutineInspection.dart';

class selectUPSToInspect extends StatefulWidget {
  @override
  _selectUPSToInspectState createState() => _selectUPSToInspectState();
}

class _selectUPSToInspectState extends State<selectUPSToInspect> {
  var Region = [
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

  String selectedprovince = 'ALL'; // Initial selected province
  List<dynamic> UPSSystems = []; // List to store Rectifier system data
  bool isLoading = true; // Flag to track if data is being loaded

  Future<void> fetchUPSSystems() async {
    final url =
        'https://powerprox.sltidc.lk/GetUpsSystems.php'; // Replace with the URL of your PHP script

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        UPSSystems = json.decode(response.body);
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
    fetchUPSSystems();
  }

  void navigateToUPSUnitDetails({required UPSUnit, required String region}) {
    print("test");
    print(region);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => UPSRoutineInspection(UPSUnit: UPSUnit, region: region),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // UserAccess userAccess = Provider.of<UserAccess>(context, listen: true); // Use listen: true to rebuild the widget when the data changes
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: customColors.appbarColor,
        iconTheme: IconThemeData(color: customColors.mainTextColor),
        title: Text(
          'UPS Details',
          style: TextStyle(color: customColors.mainTextColor, fontSize: 20),
        ),
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),
      body: Container(
        // Wrap Column with a Container
        color:
            customColors
                .mainBackgroundColor, // Set the background color to white
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<String>(
                value: selectedprovince,
                style: TextStyle(color: customColors.mainTextColor),
                decoration: InputDecoration(
                  labelText: 'Select province',
                  labelStyle: TextStyle(color: customColors.mainTextColor),
                ),
                 dropdownColor: customColors.suqarBackgroundColor,
                onChanged: (value) {
                  setState(() {
                    selectedprovince = value!;
                  });
                },
                items:
                    Region.map((province) {
                      return DropdownMenuItem<String>(
                        value: province,
                        child: Text(province),
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
                        itemCount: UPSSystems.length,
                        itemBuilder: (context, index) {
                          final system = UPSSystems[index];
                          if (selectedprovince == 'ALL' ||
                              system['Region'] == selectedprovince) {
                            return Card( // Wrap ListTile with Card
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
                                style: TextStyle(color: customColors.mainTextColor),
                              ),
                              subtitle: Text(
                                'Location: ${system['Region']}-${system['RTOM']}',
                                 style: TextStyle(color: customColors.mainTextColor),
                              ),
                              onTap: () {
                                navigateToUPSUnitDetails(
                                  UPSUnit: system,
                                  region:
                                      "${system['Region']}-${system['RTOM']}",
                                );
                              },
                            ),
                            );
                          } else {
                            return SizedBox.shrink(); // Return an empty SizedBox for non-matching Region
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
//v1 01-07-2024
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:powerprox/Screens/UPS/UPSRoutineInspection/UPSRoutineInspection.dart';
// import 'package:provider/provider.dart';
//
// import '../../UserAccess.dart';
//
//
// class selectUPSToInspect extends StatefulWidget {
//   @override
//   _selectUPSToInspectState createState() => _selectUPSToInspectState();
// }
//
// class _selectUPSToInspectState extends State<selectUPSToInspect> {
//   var Region = [
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
//   String selectedprovince = 'ALL'; // Initial selected province
//   List<dynamic> UPSSystems = []; // List to store Rectifier system data
//   bool isLoading = true; // Flag to track if data is being loaded
//
//   Future<void> fetchUPSSystems() async {
//     final url =
//         'http://124.43.136.185/GetUpsSystems.php'; // Replace with the URL of your PHP script
//
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       setState(() {
//         UPSSystems = json.decode(response.body);
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
//     fetchUPSSystems();
//   }
//
//   void navigateToUPSUnitDetails(dynamic UPSUnit) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => UPSRoutineInspection(UPSUnit: UPSUnit,),
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
//         title: Text('UPS Details'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: DropdownButtonFormField<String>(
//               value: selectedprovince,
//               decoration: InputDecoration(
//                 labelText: 'Select province',
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   selectedprovince = value!;
//                 });
//               },
//               items: Region.map((province) {
//                 return DropdownMenuItem<String>(
//                   value: province,
//                   child: Text(province),
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
//               itemCount: UPSSystems.length,
//               itemBuilder: (context, index) {
//                 final system = UPSSystems[index];
//                 if (selectedprovince == 'ALL' || system['province'] == selectedprovince) {
//                   return ListTile(
//                     title: Text('${system['Brand']} - ${system['Model']}'),
//                     subtitle: Text('Location: ${system['province']}-${system['RTOM']}'),
//                     onTap: () {
//                       navigateToUPSUnitDetails(system);
//                     },
//                   );
//                 } else {
//                   return SizedBox.shrink(); // Return an empty SizedBox for non-matching Region
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
