import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../utils/utils/colors.dart';
import '../../widgets/searchWidget.dart';
import 'ViewBatteryUnit.dart';
import 'search_helper_battery.dart';

class ViewBatteryDetails extends StatefulWidget {
  @override
  _ViewBatteryDetailsState createState() => _ViewBatteryDetailsState();
}

class _ViewBatteryDetailsState extends State<ViewBatteryDetails> {
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
    'UVA'
  ];

  String selectedRegion = 'ALL'; // Initial selected region
  List<dynamic> allBatterySystems = []; // Original list of all systems
  List<dynamic> filteredBatterySystems =
      []; // Filtered list based on search and region
  List<dynamic> battSetsData = []; // Store battery sets data
  int numberOfRacks = 0;
  int numberOfStrings = 0;
  int numberOfBatteries = 0;
  bool isLoading = true; // Flag to track if data is being loaded
  String searchQuery = ''; // Store the current search query

  Future<void> fetchBatteryData() async {
    final batSysUrl = 'https://powerprox.sltidc.lk/GetBatSys.php';
    final battSetsUrl = 'https://powerprox.sltidc.lk/GetBattSets.php';

    final batSysResponse = await http.get(Uri.parse(batSysUrl));
    final battSetsResponse = await http.get(Uri.parse(battSetsUrl));

    if (batSysResponse.statusCode == 200 &&
        battSetsResponse.statusCode == 200) {
      setState(() {
        allBatterySystems = json.decode(batSysResponse.body);
        battSetsData =
            json.decode(battSetsResponse.body); // Store battery sets data
        applyFilters(); // Apply initial filters
        isLoading = false;
      });
    } else {
      print('Failed to fetch battery data');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBatteryData();
  }

  void applyFilters() {
    setState(() {
      // First filter by region
      var filteredBatSys = selectedRegion == 'ALL'
          ? allBatterySystems
          : allBatterySystems
              .where((system) =>
                  system['Region']?.toString().toUpperCase() ==
                  selectedRegion.toUpperCase())
              .toList();

      // Then filter by search query if it exists
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();

        // Search in battery systems (racks)
        filteredBatSys = filteredBatSys.where((system) {
          return SearchHelperBattery.matchesBatteryQuery(system, query);
        }).toList();

        // Also search in battery sets and include systems that have matching sets
        final matchingSetIds = battSetsData
            .where((set) {
              return SearchHelperBattery.matchesBatteryQuery(set, query);
            })
            .map((set) => set['SystemID']?.toString())
            .toSet();

        if (matchingSetIds.isNotEmpty) {
          final systemsWithMatchingSets = allBatterySystems.where((system) {
            return matchingSetIds.contains(system['SystemID']?.toString());
          }).toList();

          // Combine with existing filtered systems and remove duplicates
          filteredBatSys =
              [...filteredBatSys, ...systemsWithMatchingSets].toSet().toList();
        }
      }

      filteredBatterySystems = filteredBatSys;

      // Update summary counts
      numberOfRacks = filteredBatSys.length;
      var systemIds =
          filteredBatSys.map((system) => system['SystemID']).toSet();
      var filteredBattSets = battSetsData
          .where((set) => systemIds.contains(set['SystemID']))
          .toList();
      numberOfStrings = filteredBattSets.length;
      numberOfBatteries = filteredBattSets.fold(0, (sum, set) {
        return sum + (int.tryParse(set['batCount'] ?? '0') ?? 0);
      });
    });
  }

  // Handle search query changes
  void handleSearch(String query) {
    setState(() {
      searchQuery = query;
      applyFilters();
    });
  }

  // Handle region selection changes
  void handleRegionChange(String? region) {
    if (region != null) {
      setState(() {
        selectedRegion = region;
        applyFilters();
      });
    }
  }

  void navigateToBatteryUnitDetails(dynamic batteryUnit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewBatteryUnit(
          batteryUnit: batteryUnit,
          searchQuery: searchQuery,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,
        title: Text(
          'Battery Details',
          style: TextStyle(color: mainTextColor),
        ),
        iconTheme: IconThemeData(
          color: mainTextColor,
        ),
      ),
      body: Container(
        color: mainBackgroundColor,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: selectedRegion,
                        decoration: InputDecoration(
                          labelText: 'Select Region',
                          labelStyle: TextStyle(color: subTextColor),
                          filled: true,
                          fillColor: mainBackgroundColor,
                        ),
                        dropdownColor: suqarBackgroundColor,
                        style: TextStyle(color: mainTextColor),
                        onChanged: handleRegionChange,
                        items: regions.map((region) {
                          return DropdownMenuItem<String>(
                            value: region,
                            child: Text(
                              region,
                              style: TextStyle(color: mainTextColor),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: SearchWidget(
                        onSearch: handleSearch,
                        hintText: 'Search',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Table(
                  border: TableBorder.all(color: subTextColor),
                  children: [
                    const TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Number of Racks',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: mainTextColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Number of Strings',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: mainTextColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Number of Batteries',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: mainTextColor),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '$numberOfRacks',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: subTextColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '$numberOfStrings',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: subTextColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '$numberOfBatteries',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: subTextColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: qrcodeiconColor1,
                          ), // Show loading indicator
                        )
                      : filteredBatterySystems.isEmpty
                          ? const Center(
                              child: Text(
                                'No data available for the selected filters',
                                style: TextStyle(color: subTextColor),
                              ),
                            )
                          // : ListView.builder(
                          //     itemCount: filteredBatterySystems.length,
                          //     itemBuilder: (context, index) {
                          //       final system = filteredBatterySystems[index];
                          //       final isRackIdMatch = searchQuery.isNotEmpty &&
                          //           (system['SystemID']?.toString().toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
                          //       final isLocationMatch = searchQuery.isNotEmpty &&
                          //           (system['Location']?.toString().toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
                          //
                          //       return ListTile(
                          //         title: Text('Rack ID: ${system['SystemID']}'),
                          //         subtitle: Text('Location: ${system['Location']}'),
                          //         onTap: () {
                          //           navigateToBatteryUnitDetails(system);
                          //         },
                          //       );
                          //     },
                          //   ),
                          : ListView.builder(
                              itemCount: filteredBatterySystems.length,
                              itemBuilder: (context, index) {
                                final system = filteredBatterySystems[index];
                                final isRackIdMatch = searchQuery.isNotEmpty &&
                                    (system['SystemID']
                                            ?.toString()
                                            .toLowerCase()
                                            .contains(
                                                searchQuery.toLowerCase()) ??
                                        false);
                                final isLocationMatch = searchQuery
                                        .isNotEmpty &&
                                    (system['Location']
                                            ?.toString()
                                            .toLowerCase()
                                            .contains(
                                                searchQuery.toLowerCase()) ??
                                        false);

                                return Card(
                                  color: mainBackgroundColor,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 16.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: suqarBackgroundColor,
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0xFF918F8F),
                                          blurRadius: 4.0,
                                          spreadRadius: 1.0,
                                          offset: Offset(2.0, 2.0),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      title: RichText(
                                        text: TextSpan(
                                          style:
                                              TextStyle(color: mainTextColor),
                                          // White text
                                          children: [
                                            TextSpan(text: 'Rack ID: '),
                                            TextSpan(
                                              text: system['SystemID']
                                                      ?.toString() ??
                                                  'N/A',
                                              style: TextStyle(
                                                backgroundColor: isRackIdMatch
                                                    ? highlightColor
                                                    : Colors.transparent,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      subtitle: RichText(
                                        text: TextSpan(
                                          style: TextStyle(color: subTextColor),
                                          // Light gray text
                                          children: [
                                            TextSpan(text: 'Location: '),
                                            TextSpan(
                                              text: system['Location']
                                                      ?.toString() ??
                                                  'N/A',
                                              style: TextStyle(
                                                backgroundColor: isLocationMatch
                                                    ? highlightColor
                                                    : Colors.transparent,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        navigateToBatteryUnitDetails(system);
                                      },
                                    ),
                                  ),
                                );
                              },
                            )),
            ],
          ),
        ),
      ),
    );
  }
}

//V4
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'ViewBatteryUnit.dart';
//
// class ViewBatteryDetails extends StatefulWidget {
//   @override
//   _ViewBatteryDetailsState createState() => _ViewBatteryDetailsState();
// }
//
// class _ViewBatteryDetailsState extends State<ViewBatteryDetails> {
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
//   List<dynamic> batterySystems = []; // List to store battery system data
//   int numberOfRacks = 0;
//   int numberOfStrings = 0;
//   int numberOfBatteries = 0;
//   bool isLoading = true; // Flag to track if data is being loaded
//
//   Future<void> fetchBatteryData() async {
//     final batSysUrl = 'https://powerprox.sltidc.lk/GetBatSys.php';
//     final battSetsUrl = 'https://powerprox.sltidc.lk/GetBattSets.php';
//
//     final batSysResponse = await http.get(Uri.parse(batSysUrl));
//     final battSetsResponse = await http.get(Uri.parse(battSetsUrl));
//
//     if (batSysResponse.statusCode == 200 && battSetsResponse.statusCode == 200) {
//       setState(() {
//         batterySystems = json.decode(batSysResponse.body);
//
//         // Filter by selected region
//         var filteredBatSys = selectedRegion == 'ALL'
//             ? batterySystems
//             : batterySystems.where((system) => system['Region'] == selectedRegion).toList();
//
//         numberOfRacks = filteredBatSys.length;
//
//         var battSetsData = json.decode(battSetsResponse.body);
//
//         // Get the SystemIDs for the selected region
//         var systemIds = filteredBatSys.map((system) => system['SystemID']).toSet();
//
//         // Filter the battery sets by SystemIDs and count the strings
//         var filteredBattSets = battSetsData.where((set) => systemIds.contains(set['SystemID'])).toList();
//         numberOfStrings = filteredBattSets.length;
//
//         // Sum up the batCount values to get the number of batteries
//         numberOfBatteries = filteredBattSets.fold(0, (sum, set) {
//           return sum + (int.tryParse(set['batCount'] ?? '0') ?? 0);
//         });
//
//         isLoading = false;
//       });
//     } else {
//       print('Failed to fetch battery data');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchBatteryData();
//   }
//
//   void navigateToBatteryUnitDetails(dynamic batteryUnit) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ViewBatteryUnit(batteryUnit: batteryUnit),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Battery Details'),
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
//                   isLoading = true;
//                   fetchBatteryData();
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
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Table(
//               border: TableBorder.all(),
//               children: [
//                 TableRow(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('Number of Racks', textAlign: TextAlign.center),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('Number of Strings', textAlign: TextAlign.center),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('Number of Batteries', textAlign: TextAlign.center),
//                     ),
//                   ],
//                 ),
//                 TableRow(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('$numberOfRacks', textAlign: TextAlign.center),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('$numberOfStrings', textAlign: TextAlign.center),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('$numberOfBatteries', textAlign: TextAlign.center),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: isLoading
//                 ? Center(
//               child: CircularProgressIndicator(), // Show loading indicator
//             )
//                 : ListView.builder(
//               itemCount: batterySystems.length,
//               itemBuilder: (context, index) {
//                 final system = batterySystems[index];
//                 if (selectedRegion == 'ALL' || system['Region'] == selectedRegion) {
//                   return ListTile(
//                     title: Text('Rack ID: ${system['SystemID']}'),
//                     subtitle: Text('Location: ${system['Location']}'),
//                     onTap: () {
//                       navigateToBatteryUnitDetails(system);
//                     },
//                   );
//                 } else {
//                   return SizedBox.shrink();
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//v3
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'ViewBatteryUnit.dart';
//
// class ViewBatteryDetails extends StatefulWidget {
//   @override
//   _ViewBatteryDetailsState createState() => _ViewBatteryDetailsState();
// }
//
// class _ViewBatteryDetailsState extends State<ViewBatteryDetails> {
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
//   List<dynamic> batterySystems = []; // List to store battery system data
//   int numberOfRacks = 0;
//   int numberOfStrings = 0;
//   int numberOfBatteries = 0;
//   bool isLoading = true; // Flag to track if data is being loaded
//
//   Future<void> fetchBatteryData() async {
//     final batSysUrl = 'https://powerprox.sltidc.lk/GetBatSys.php';
//     final battSetsUrl = 'https://powerprox.sltidc.lk/GetBattSets.php';
//
//     final batSysResponse = await http.get(Uri.parse(batSysUrl));
//     final battSetsResponse = await http.get(Uri.parse(battSetsUrl));
//
//     if (batSysResponse.statusCode == 200 && battSetsResponse.statusCode == 200) {
//       setState(() {
//         batterySystems = json.decode(batSysResponse.body);
//
//         // Filter by selected region
//         var filteredBatSys = selectedRegion == 'ALL'
//             ? batterySystems
//             : batterySystems.where((system) => system['Region'] == selectedRegion).toList();
//
//         numberOfRacks = filteredBatSys.length;
//
//         var battSetsData = json.decode(battSetsResponse.body);
//
//         // Get the SystemIDs for the selected region
//         var systemIds = filteredBatSys.map((system) => system['SystemID']).toSet();
//
//         // Filter the battery sets by SystemIDs and count the strings
//         var filteredBattSets = battSetsData.where((set) => systemIds.contains(set['SystemID'])).toList();
//         numberOfStrings = filteredBattSets.length;
//
//         // Sum up the batCount values to get the number of batteries
//         numberOfBatteries = filteredBattSets.fold(0, (sum, set) {
//           return sum + (int.tryParse(set['batCount'] ?? '0') ?? 0);
//         });
//
//         isLoading = false;
//       });
//     } else {
//       print('Failed to fetch battery data');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchBatteryData();
//   }
//
//   void navigateToBatteryUnitDetails(dynamic batteryUnit) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ViewBatteryUnit(batteryUnit: batteryUnit),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Battery Details'),
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
//                   isLoading = true;
//                   fetchBatteryData();
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
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Table(
//               border: TableBorder.all(),
//               children: [
//                 TableRow(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('Number of Racks', textAlign: TextAlign.center),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('Number of Strings', textAlign: TextAlign.center),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('Number of Batteries', textAlign: TextAlign.center),
//                     ),
//                   ],
//                 ),
//                 TableRow(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('$numberOfRacks', textAlign: TextAlign.center),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('$numberOfStrings', textAlign: TextAlign.center),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('$numberOfBatteries', textAlign: TextAlign.center),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: isLoading
//                 ? Center(
//               child: CircularProgressIndicator(), // Show loading indicator
//             )
//                 : ListView.builder(
//               itemCount: batterySystems.length,
//               itemBuilder: (context, index) {
//                 final system = batterySystems[index];
//                 if (selectedRegion == 'ALL' || system['Region'] == selectedRegion) {
//                   return ListTile(
//                     title: Text('Rack ID: ${system['SystemID']}'),
//                     subtitle: Text('Location: ${system['Location']}'),
//                     onTap: () {
//                       navigateToBatteryUnitDetails(system);
//                     },
//                   );
//                 } else {
//                   return SizedBox.shrink();
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//

//v2
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'ViewBatteryUnit.dart';
//
// class ViewBatteryDetails extends StatefulWidget {
//   @override
//   _ViewBatteryDetailsState createState() => _ViewBatteryDetailsState();
// }
//
// class _ViewBatteryDetailsState extends State<ViewBatteryDetails> {
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
//   List<dynamic> batterySystems = []; // List to store battery system data
//   bool isLoading = true; // Flag to track if data is being loaded
//
//   Future<void> fetchBatterySystems() async {
//     final url =
//         'https://powerprox.sltidc.lk/GetBatSys.php'; // Replace with the URL of your PHP script
//
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       setState(() {
//         batterySystems = json.decode(response.body);
//         isLoading = false; // Set isLoading to false once data is loaded
//       });
//     } else {
//       // Handle the error case
//       print('Failed to fetch battery systems');
//       isLoading = false; // Set isLoading to false in case of an error
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchBatterySystems();
//   }
//
//   void navigateToBatteryUnitDetails(dynamic batteryUnit) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ViewBatteryUnit(batteryUnit: batteryUnit),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Battery Details'),
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
//               itemCount: batterySystems.length,
//               itemBuilder: (context, index) {
//                 final system = batterySystems[index];
//                 if (selectedRegion == 'ALL' || system['Region'] == selectedRegion) {
//                   return ListTile(
//                     title: Text('Site: ${system['Site']}'),
//                     subtitle: Text('Location: ${system['Location']}'),
//                     onTap: () {
//                       navigateToBatteryUnitDetails(system);
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
//

//V1 Working
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'ViewBatteryUnit.dart';
//
// class ViewBatteryDetails extends StatefulWidget {
//   @override
//   _ViewBatteryDetailsState createState() => _ViewBatteryDetailsState();
// }
//
// class _ViewBatteryDetailsState extends State<ViewBatteryDetails> {
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
//   List<dynamic> batterySystems = []; // List to store battery system data
//   bool isLoading = true; // Flag to track if data is being loaded
//
//   Future<void> fetchBatterySystems() async {
//     final url =
//         'http://124.43.136.185/GetBatSys.php'; // Replace with the URL of your PHP script
//
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       setState(() {
//         batterySystems = json.decode(response.body);
//         isLoading = false; // Set isLoading to false once data is loaded
//       });
//     } else {
//       // Handle the error case
//       print('Failed to fetch battery systems');
//       isLoading = false; // Set isLoading to false in case of an error
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchBatterySystems();
//   }
//
//   void navigateToBatteryUnitDetails(dynamic batteryUnit) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ViewBatteryUnit(batteryUnit: batteryUnit),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Battery Details'),
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
//               itemCount: batterySystems.length,
//               itemBuilder: (context, index) {
//                 final system = batterySystems[index];
//                 if (selectedRegion == 'ALL' || system['Region'] == selectedRegion) {
//                   return ListTile(
//                     title: Text('Site: ${system['Site']}'),
//                     subtitle: Text('Location: ${system['Location']}'),
//                     onTap: () {
//                       navigateToBatteryUnitDetails(system);
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
