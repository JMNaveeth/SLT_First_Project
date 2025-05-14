import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/utils/utils/colors.dart';
import 'package:theme_update/widgets/searchWidget.dart';
import 'ViewUPSUnit.dart';
import 'search_helper_ups.dart';

class ViewUPShighend extends StatefulWidget {
  @override
  _ViewUPShighendState createState() => _ViewUPShighendState();
}

class _ViewUPShighendState extends State<ViewUPShighend> {
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
    'SMW5',
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
  List<dynamic> allUPSSystems = []; // Original list of all systems
  List<dynamic> filteredUPSSystems =
      []; // Filtered list based on search and region
  bool isLoading = true; // Flag to track if data is being loaded
  String searchQuery = ''; // Store the current search query

  Future<void> fetchBatterySystems() async {
    final url =
        'https://powerprox.sltidc.lk/GetUpsSystems.php'; // Replace with the URL of your PHP script

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        allUPSSystems = json.decode(response.body);
        applyFilters(); // Apply initial filters
        isLoading = false; // Set isLoading to false once data is loaded
      });
    } else {
      // Handle the error case
      print('Failed to fetch UPS systems');
      isLoading = false; // Set isLoading to false in case of an error
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBatterySystems();
  }

  // Apply both region filter and search query
  void applyFilters() {
    setState(() {
      // First filter by region
      var tempFiltered =
          selectedRegion == 'ALL'
              ? allUPSSystems
              : allUPSSystems.where((system) {
                return (system['Region'] ?? '').toString().toUpperCase() ==
                    selectedRegion.toUpperCase();
              }).toList();

      // Then filter by search query if it exists
      if (searchQuery.isNotEmpty) {
        tempFiltered =
            tempFiltered
                .where(
                  (system) =>
                      SearchHelperUPS.matchesUPSQuery(system, searchQuery),
                )
                .toList();
      }

      filteredUPSSystems = tempFiltered;
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
        builder:
            (context) =>
                ViewUPSUnit(UPSUnit: batteryUnit, searchQuery: searchQuery),
      ),
    );
  }

  Map<String, int> getSummary() {
    int totalCount = 0;
    int lessThan10kVa = 0;
    int between10And100kVa = 0;
    int moreThan100kVa = 0;

    for (var system in filteredUPSSystems) {
      totalCount++;
      double capacity = double.tryParse(system['UPSCap'].toString()) ?? 0;

      if (capacity < 10) {
        lessThan10kVa++;
      } else if (capacity >= 10 && capacity <= 100) {
        between10And100kVa++;
      } else if (capacity > 100) {
        moreThan100kVa++;
      }
    }

    return {
      'Total Systems': totalCount,
      'Less than 10 kVA': lessThan10kVa,
      '10-100 kVA': between10And100kVa,
      'More than 100 kVA': moreThan100kVa,
    };
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    final summary = getSummary();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'UPS Details',
          style: TextStyle(color: customColors.mainTextColor),
        ),
        iconTheme: IconThemeData(color: customColors.mainTextColor),
        backgroundColor: customColors.appbarColor,
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),
      body: Container(
        color: customColors.mainBackgroundColor,
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
                          labelStyle: TextStyle(
                            color: customColors.subTextColor,
                          ),
                          filled: true,
                          fillColor: customColors.mainBackgroundColor,
                        ),
                        dropdownColor: customColors.suqarBackgroundColor,
                        style: TextStyle(color: customColors.mainTextColor),
                        onChanged: handleRegionChange,
                        items:
                            [
                              'ALL',
                              ...allUPSSystems
                                  .map(
                                    (system) =>
                                        (system['Region'] ?? '')
                                            .toString()
                                            .toUpperCase(),
                                  )
                                  .toSet()
                                  .toList(),
                            ].map((region) {
                              return DropdownMenuItem<String>(
                                value: region,
                                child: Text(
                                  region,
                                  style: TextStyle(
                                    color: customColors.mainTextColor,
                                  ),
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
                  border: TableBorder.all(color: customColors.subTextColor),
                  columnWidths: {0: FixedColumnWidth(200)},
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Summary',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: customColors.mainTextColor,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Count',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: customColors.mainTextColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Total Systems',
                              style: TextStyle(
                                color: customColors.subTextColor,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${summary['Total Systems']}',
                              style: TextStyle(
                                color: customColors.subTextColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Less than 10 kVA',
                              style: TextStyle(
                                color: customColors.subTextColor,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${summary['Less than 10 kVA']}',
                              style: TextStyle(
                                color: customColors.subTextColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '10-100 kVA',
                              style: TextStyle(
                                color: customColors.subTextColor,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${summary['10-100 kVA']}',
                              style: TextStyle(
                                color: customColors.subTextColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'More than 100 kVA',
                              style: TextStyle(
                                color: customColors.subTextColor,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${summary['More than 100 kVA']}',
                              style: TextStyle(
                                color: customColors.subTextColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child:
                    isLoading
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: qrcodeiconColor1,
                          ), // Show loading indicator
                        )
                        : filteredUPSSystems.isEmpty
                        ? Center(
                          child: Text(
                            'No UPS systems found.',
                            style: TextStyle(color: customColors.subTextColor),
                          ),
                        )
                        : ListView.builder(
                          itemCount: filteredUPSSystems.length,
                          itemBuilder: (context, index) {
                            final system = filteredUPSSystems[index];
                            return Card(
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
                                  'Model: ${system['Model']}',
                                  style: TextStyle(
                                    color: customColors.mainTextColor,
                                  ),
                                ),
                                subtitle: Text(
                                  'Location: ${system['Region']}-${system['RTOM']}',
                                  style: TextStyle(
                                    color: customColors.subTextColor,
                                  ),
                                ),
                                onTap: () {
                                  navigateToBatteryUnitDetails(system);
                                },
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



//v2
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../../../Widgets/SearchWidget/searchWidget.dart';
// import '../../HomePage/utils/colors.dart';
// import 'ViewUPSUnit.dart';
//
// class ViewUPShighend extends StatefulWidget {
//   const ViewUPShighend({super.key});
//
//   @override
//   _ViewUPShighendState createState() => _ViewUPShighendState();
// }
//
// class _ViewUPShighendState extends State<ViewUPShighend> {
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
//     'SMW5',
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
//     'UVA',
//   ];
//
//   String selectedRegion = 'ALL'; // Initial selected region
//   List<dynamic> allUPSSystems = []; // Original list of all systems
//   List<dynamic> filteredUPSSystems =
//   []; // Filtered list based on search and region
//   bool isLoading = true; // Flag to track if data is being loaded
//   String searchQuery = ''; // Store the current search query
//
//   Future<void> fetchBatterySystems() async {
//     final url =
//         'https://powerprox.sltidc.lk/GetUpsSystems.php'; // Replace with the URL of your PHP script
//
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       setState(() {
//         allUPSSystems = json.decode(response.body);
//         applyFilters(); // Apply initial filters
//         isLoading = false; // Set isLoading to false once data is loaded
//       });
//     } else {
//       // Handle the error case
//       print('Failed to fetch UPS systems');
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
//   // Apply both region filter and search query
//   void applyFilters() {
//     setState(() {
//       if (searchQuery.isEmpty && selectedRegion == 'ALL') {
//         // No filters applied
//         filteredUPSSystems = List.from(allUPSSystems);
//       } else {
//         filteredUPSSystems =
//             allUPSSystems.where((system) {
//               // Apply region filter
//               bool matchesRegion =
//                   selectedRegion == 'ALL' || system['Region'] == selectedRegion;
//
//               // Apply search filter if there's a query
//               bool matchesSearch = true;
//               if (searchQuery.isNotEmpty) {
//                 final query = searchQuery.toLowerCase();
//                 final brand = system['Brand']?.toString().toLowerCase() ?? '';
//                 final model = system['Model']?.toString().toLowerCase() ?? '';
//                 final region = system['Region']?.toString().toLowerCase() ?? '';
//                 final rtom = system['RTOM']?.toString().toLowerCase() ?? '';
//                 final type = system['Type']?.toString().toLowerCase() ?? '';
//
//                 // Check if any field contains the search query
//                 matchesSearch =
//                     brand.contains(query) ||
//                         model.contains(query) ||
//                         region.contains(query) ||
//                         rtom.contains(query) ||
//                         type.contains(query);
//               }
//
//               return matchesRegion && matchesSearch;
//             }).toList();
//       }
//     });
//   }
//
//   // Handle search query changes
//   void handleSearch(String query) {
//     setState(() {
//       searchQuery = query;
//       applyFilters();
//     });
//   }
//
//   // Handle region selection changes
//   void handleRegionChange(String? region) {
//     if (region != null) {
//       setState(() {
//         selectedRegion = region;
//         applyFilters();
//       });
//     }
//   }
//
//   void navigateToBatteryUnitDetails(dynamic batteryUnit) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ViewUPSUnit(UPSUnit: batteryUnit),
//       ),
//     );
//   }
//
//   Map<String, int> getSummary() {
//     int totalCount = 0;
//     int lessThan10kVa = 0;
//     int between10And100kVa = 0;
//     int moreThan100kVa = 0;
//
//     for (var system in filteredUPSSystems) {
//       totalCount++;
//       double capacity = double.tryParse(system['UPSCap'].toString()) ?? 0;
//
//       if (capacity < 10) {
//         lessThan10kVa++;
//       } else if (capacity >= 10 && capacity <= 100) {
//         between10And100kVa++;
//       } else if (capacity > 100) {
//         moreThan100kVa++;
//       }
//     }
//
//     return {
//       'Total Systems': totalCount,
//       'Less than 10 kVA': lessThan10kVa,
//       '10-100 kVA': between10And100kVa,
//       'More than 100 kVA': moreThan100kVa,
//     };
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final summary = getSummary();
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xff2B3136),
//         title: Text('UPS Details', style: TextStyle(color: Color(0xffFFFFFF))),
//       ),
//       body: Container(
//         color: Color(0xff343A40),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 2,
//                     child: DropdownButtonFormField<String>(
//                       value: selectedRegion,
//                       decoration: InputDecoration(
//                         labelText: 'Select Region',
//                         labelStyle: TextStyle(color: Color(0xffD9D9D9)),
//                         filled: true,
//                         fillColor: mainBackgroundColor,
//                       ),
//                       dropdownColor: Color(0xff212529),
//                       style: TextStyle(color: Color(0xffFFFFFF)),
//                       onChanged: handleRegionChange,
//                       items:
//                       regions.map((region) {
//                         return DropdownMenuItem<String>(
//                           value: region,
//                           child: Text(
//                             region,
//                             style: TextStyle(color: Color(0xffFFFFFF)),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Expanded(
//                     flex: 3,
//                     child: SearchWidget(
//                       onSearch: handleSearch,
//                       hintText: 'Search',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Table(
//                 border: TableBorder.all(color: Color(0xffD9D9D9)),
//                 columnWidths: {0: FixedColumnWidth(200)},
//                 children: [
//                   TableRow(
//                     children: [
//                       TableCell(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             'Summary',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xffFFFFFF),
//                             ),
//                           ),
//                         ),
//                       ),
//                       TableCell(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             'Count',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xffFFFFFF),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   TableRow(
//                     children: [
//                       TableCell(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             'Total Systems',
//                             style: TextStyle(color: Color(0xffD9D9D9)),
//                           ),
//                         ),
//                       ),
//                       TableCell(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             '${summary['Total Systems']}',
//                             style: TextStyle(color: Color(0xffD9D9D9)),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   TableRow(
//                     children: [
//                       TableCell(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             'Less than 10 kVA',
//                             style: TextStyle(color: Color(0xffD9D9D9)),
//                           ),
//                         ),
//                       ),
//                       TableCell(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             '${summary['Less than 10 kVA']}',
//                             style: TextStyle(color: Color(0xffD9D9D9)),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   TableRow(
//                     children: [
//                       TableCell(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             '10-100 kVA',
//                             style: TextStyle(color: Color(0xffD9D9D9)),
//                           ),
//                         ),
//                       ),
//                       TableCell(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             '${summary['10-100 kVA']}',
//                             style: TextStyle(color: Color(0xffD9D9D9)),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   TableRow(
//                     children: [
//                       TableCell(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             'More than 100 kVA',
//                             style: TextStyle(color: Color(0xffD9D9D9)),
//                           ),
//                         ),
//                       ),
//                       TableCell(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             '${summary['More than 100 kVA']}',
//                             style: TextStyle(color: Color(0xffD9D9D9)),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child:
//               isLoading
//                   ? Center(
//                 child: CircularProgressIndicator(
//                   color: Color(0xff20C997),
//                 ), // Show loading indicator
//               )
//                   : filteredUPSSystems.isEmpty
//                   ? Center(
//                 child: Text(
//                   'No UPS systems found.',
//                   style: TextStyle(color: Color(0xffD9D9D9)),
//                 ),
//               )
//                   : ListView.builder(
//                 itemCount: filteredUPSSystems.length,
//                 itemBuilder: (context, index) {
//                   final system = filteredUPSSystems[index];
//                   return Card(
//                     color: mainBackgroundColor,
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(
//                         vertical: 8.0,
//                         horizontal: 16.0,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Color(0xff212529),
//                         borderRadius: BorderRadius.circular(8.0),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Color(0xFF918F8F),
//                             blurRadius: 4.0,
//                             spreadRadius: 1.0,
//                             offset: Offset(2.0, 2.0),
//                           ),
//                         ], // Set border color to black
//                       ),
//                       child: ListTile(
//                         title: Text(
//                           'Model: ${system['Model']}',
//                           style: TextStyle(color: Color(0xffFFFFFF)),
//                         ),
//                         subtitle: Text(
//                           'Location: ${system['Region']}-${system['RTOM']}',
//                           style: TextStyle(color: Color(0xffD9D9D9)),
//                         ),
//                         onTap: () {
//                           navigateToBatteryUnitDetails(system);
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



//v2
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'ViewUPSUnit.dart';
//
// class ViewUPShighend extends StatefulWidget {
//   @override
//   _ViewUPShighendState createState() => _ViewUPShighendState();
// }
//
// class _ViewUPShighendState extends State<ViewUPShighend> {
//   var regions = ['ALL', 'CPN', 'CPS', 'EPN', 'EPS', 'EPN–TC', 'HQ', 'NCP', 'NPN', 'NPS', 'NWPE', 'NWPW', 'PITI', 'SAB', 'SMW5', 'SMW6', 'SPE', 'SPW', 'WEL', 'WPC', 'WPE', 'WPN', 'WPNE', 'WPS', 'WPSE', 'WPSW', 'UVA'];
//
//   String selectedRegion = 'ALL'; // Initial selected region
//   List<dynamic> UPSSystems = []; // List to store UPS system data
//   bool isLoading = true; // Flag to track if data is being loaded
//
//   Future<void> fetchBatterySystems() async {
//     final url = 'https://powerprox.sltidc.lk/GetUpsSystems.php'; // Replace with the URL of your PHP script
//
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       setState(() {
//         UPSSystems = json.decode(response.body);
//         print(UPSSystems);
//         isLoading = false; // Set isLoading to false once data is loaded
//       });
//     } else {
//       // Handle the error case
//       print('Failed to fetch UPS systems');
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
//         builder: (context) => ViewUPSUnit(UPSUnit: batteryUnit),
//       ),
//     );
//   }
//
//   Map<String, int> getSummary() {
//     int totalCount = 0;
//     int lessThan10kVa = 0;
//     int between10And100kVa = 0;
//     int moreThan100kVa = 0;
//
//     for (var system in UPSSystems) {
//       if (selectedRegion == 'ALL' || system['Region'] == selectedRegion) {
//         totalCount++;
//         double capacity = double.tryParse(system['UPSCap'].toString()) ?? 0;
//
//         if (capacity < 10) {
//           lessThan10kVa++;
//         } else if (capacity >= 10 && capacity <= 100) {
//           between10And100kVa++;
//         } else if (capacity > 100) {
//           moreThan100kVa++;
//         }
//       }
//     }
//
//     return {
//       'Total Systems': totalCount,
//       'Less than 10 kVA': lessThan10kVa,
//       '10-100 kVA': between10And100kVa,
//       'More than 100 kVA': moreThan100kVa,
//     };
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final summary = getSummary();
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
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Table(
//               border: TableBorder.all(),
//               columnWidths: {0: FixedColumnWidth(200)},
//               children: [
//                 TableRow(
//                   children: [
//                     TableCell(child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('Summary', style: TextStyle(fontWeight: FontWeight.bold)),
//                     )),
//                     TableCell(child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('Count', style: TextStyle(fontWeight: FontWeight.bold)),
//                     )),
//                   ],
//                 ),
//                 TableRow(
//                   children: [
//                     TableCell(child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('Total Systems'),
//                     )),
//                     TableCell(child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('${summary['Total Systems']}'),
//                     )),
//                   ],
//                 ),
//                 TableRow(
//                   children: [
//                     TableCell(child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('Less than 10 kVA'),
//                     )),
//                     TableCell(child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('${summary['Less than 10 kVA']}'),
//                     )),
//                   ],
//                 ),
//                 TableRow(
//                   children: [
//                     TableCell(child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('10-100 kVA'),
//                     )),
//                     TableCell(child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('${summary['10-100 kVA']}'),
//                     )),
//                   ],
//                 ),
//                 TableRow(
//                   children: [
//                     TableCell(child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('More than 100 kVA'),
//                     )),
//                     TableCell(child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('${summary['More than 100 kVA']}'),
//                     )),
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
//               itemCount: UPSSystems.length,
//               itemBuilder: (context, index) {
//                 final system = UPSSystems[index];
//                 print(system['Region']);
//                 if (selectedRegion == 'ALL' || system['Region'] == selectedRegion) {
//                   return ListTile(
//                     title: Text('Model: ${system['Model']}'),
//                     subtitle: Text('Location: ${system['Region']}-${system['RTOM']}'),
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


//v1 working
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'ViewUPSUnit.dart';
//
// class ViewUPShighend extends StatefulWidget {
//   @override
//   _ViewUPShighendState createState() => _ViewUPShighendState();
// }
//
// class _ViewUPShighendState extends State<ViewUPShighend> {
//   var regions = ['ALL', 'CPN', 'CPS', 'EPN', 'EPS', 'EPN–TC', 'HQ', 'NCP', 'NPN', 'NPS', 'NWPE', 'NWPW', 'PITI', 'SAB', 'SMW6', 'SPE', 'SPW', 'WEL', 'WPC', 'WPE', 'WPN', 'WPNE', 'WPS', 'WPSE', 'WPSW', 'UVA'];
//
//   String selectedRegion = 'ALL'; // Initial selected region
//   List<dynamic> UPSSystems = []; // List to store UPS system data
//   bool isLoading = true; // Flag to track if data is being loaded
//
//   Future<void> fetchBatterySystems() async {
//     final url =
//         'https://powerprox.sltidc.lk/GetUpsSystems.php'; // Replace with the URL of your PHP script
//
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       setState(() {
//         UPSSystems = json.decode(response.body);
//         print(UPSSystems);
//         isLoading = false; // Set isLoading to false once data is loaded
//       });
//     } else {
//       // Handle the error case
//       print('Failed to fetch UPS systems');
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
//         builder: (context) => ViewUPSUnit(UPSUnit:  batteryUnit),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('UPS Details'),
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
//               items: regions.map((Region) {
//                 return DropdownMenuItem<String>(
//                   value: Region,
//                   child: Text(Region),
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
//                 print(system['Region']);
//                 if (selectedRegion == 'ALL' || system['Region'] == selectedRegion) {
//                   return ListTile(
//                     title: Text('Model: ${system['Model']}'),
//                     subtitle: Text('Location: ${system['Region']}-${system['RTOM']}'),
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
