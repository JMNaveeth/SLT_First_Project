import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/utils/utils/colors.dart';
import 'package:theme_update/widgets/searchWidget.dart';
import 'ViewRectifierUnit.dart';
import 'search_helper_rectifier.dart';

class ViewRectifierDetails extends StatefulWidget {
  @override
  _ViewRectifierDetailsState createState() => _ViewRectifierDetailsState();
}

class _ViewRectifierDetailsState extends State<ViewRectifierDetails> {
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
  List<dynamic> allRectifierSystems = []; // Original list of all systems
  List<dynamic> filteredRectifierSystems =
      []; // Filtered list based on search and region
  bool isLoading = true; // Flag to track if data is being loaded
  String searchQuery = ''; // Store the current search query

  Future<void> fetchRectifierSystems() async {
    final url = 'https://powerprox.sltidc.lk/GetRecSys.php';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        allRectifierSystems = json.decode(response.body);
        applyFilters(); // Apply initial filters
        isLoading = false;
      });
    } else {
      print('Failed to fetch Rectifier systems');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRectifierSystems();
  }

  void applyFilters() {
    setState(() {
      // First filter by region
      var tempFiltered =
          selectedRegion == 'ALL'
              ? allRectifierSystems
              : allRectifierSystems.where((system) {
                return (system['Region'] ?? '').toString().toUpperCase() ==
                    selectedRegion.toUpperCase();
              }).toList();

      // Then filter by search query if it exists
      if (searchQuery.isNotEmpty) {
        tempFiltered =
            tempFiltered
                .where(
                  (system) => SearchHelperRectifier.matchesRectifierQuery(
                    system,
                    searchQuery,
                  ),
                )
                .toList();
      }

      filteredRectifierSystems = tempFiltered;
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

  void navigateToRectifierUnitDetails(dynamic RectifierUnit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ViewRectifierUnit(
              RectifierUnit: RectifierUnit,
              searchQuery: searchQuery,
            ),
      ),
    );
  }

  Map<String, int> getSummary() {
    int totalCount = 0;
    int modularCount = 0;
    int unitaryCount = 0;

    for (var system in filteredRectifierSystems) {
      totalCount++;
      String type = system['Type'].toString().toLowerCase();

      if (type.contains('modular')) {
        modularCount++;
      } else if (type.contains('unitary')) {
        unitaryCount++;
      }
    }

    return {
      'Total Rectifiers': totalCount,
      'Modular': modularCount,
      'Unitary': unitaryCount,
    };
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    final summary = getSummary();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: customColors.mainBackgroundColor,
        appBar: AppBar(
          title: Text(
            'Rectifier Details',
            style: TextStyle(color: customColors.mainTextColor),
          ),
          centerTitle: true,
          backgroundColor: customColors.appbarColor,
          iconTheme: IconThemeData(color: customColors.mainTextColor),
          actions: [
            ThemeToggleButton(), // Use the reusable widget
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: selectedRegion,
                        decoration: InputDecoration(
                          labelText: 'Region',
                          labelStyle: TextStyle(
                            color: customColors.mainTextColor,
                          ),
                          filled: true,
                          fillColor: customColors.mainBackgroundColor,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                        ),
                        dropdownColor: customColors.suqarBackgroundColor,
                        style: TextStyle(color: customColors.mainTextColor),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: customColors.mainTextColor,
                        ),
                        onChanged: handleRegionChange,
                        items:
                            regions.map((region) {
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
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: SearchWidget(
                        onSearch: handleSearch,
                        hintText: 'Search',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Summary Table
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Table(
                    border: TableBorder.all(color: customColors.mainTextColor),
                    columnWidths: const {0: FixedColumnWidth(200)},
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
                                'Total Rectifiers',
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
                                '${summary['Total Rectifiers']}',
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
                                'Modular',
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
                                '${summary['Modular']}',
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
                                'Unitary',
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
                                '${summary['Unitary']}',
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
                const SizedBox(height: 20),
                Expanded(
                  child:
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : filteredRectifierSystems.isEmpty
                          ? Center(
                            child: Text(
                              'No Rectifier systems found.',
                              style: TextStyle(
                                fontSize: 16,
                                color: customColors.subTextColor,
                              ),
                            ),
                          )
                          : ListView.builder(
                            itemCount: filteredRectifierSystems.length,
                            itemBuilder: (context, index) {
                              final system = filteredRectifierSystems[index];
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
                                  leading: Icon(
                                    Icons.battery_charging_full,
                                    color: customColors.subTextColor,
                                  ),
                                  title: Text(
                                    '${system['Brand']} - ${system['Model']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: customColors.subTextColor,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Location: ${system['Region']} - ${system['RTOM']}',
                                    style: TextStyle(
                                      color: customColors.subTextColor,
                                    ),
                                  ),
                                  onTap: () {
                                    navigateToRectifierUnitDetails(system);
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
      ),
    );
  }
}

//v3
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// // import '../utils/utils/colors.dart';
// // import '../widgets/searchWidget.dart';
// import '../../../Widgets/SearchWidget/searchWidget.dart';
// import '../../HomePage/utils/colors.dart';
// import 'ViewRectifierUnit.dart';
//
// class ViewRectifierDetails extends StatefulWidget {
//   const ViewRectifierDetails({super.key});
//
//   @override
//   _ViewRectifierDetailsState createState() => _ViewRectifierDetailsState();
// }
//
// class _ViewRectifierDetailsState extends State<ViewRectifierDetails> {
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
//     'UVA'
//   ];
//
//   String selectedRegion = 'ALL'; // Initial selected region
//   List<dynamic> allRectifierSystems = []; // Original list of all systems
//   List<dynamic> filteredRectifierSystems = []; // Filtered list based on search and region
//   bool isLoading = true; // Flag to track if data is being loaded
//   String searchQuery = ''; // Store the current search query
//
//   Future<void> fetchRectifierSystems() async {
//     final url = 'https://powerprox.sltidc.lk/GetRecSys.php';
//
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       setState(() {
//         allRectifierSystems = json.decode(response.body);
//         applyFilters(); // Apply initial filters
//         isLoading = false;
//       });
//     } else {
//       print('Failed to fetch Rectifier systems');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchRectifierSystems();
//   }
//
//   // Apply both region filter and search query
//   void applyFilters() {
//     setState(() {
//       if (searchQuery.isEmpty && selectedRegion == 'ALL') {
//         // No filters applied
//         filteredRectifierSystems = List.from(allRectifierSystems);
//       } else {
//         filteredRectifierSystems = allRectifierSystems.where((system) {
//           // Apply region filter
//           bool matchesRegion = selectedRegion == 'ALL' || system['Region'] == selectedRegion;
//
//           // Apply search filter if there's a query
//           bool matchesSearch = true;
//           if (searchQuery.isNotEmpty) {
//             final query = searchQuery.toLowerCase();
//             final brand = system['Brand']?.toString().toLowerCase() ?? '';
//             final model = system['Model']?.toString().toLowerCase() ?? '';
//             final region = system['Region']?.toString().toLowerCase() ?? '';
//             final rtom = system['RTOM']?.toString().toLowerCase() ?? '';
//             final type = system['Type']?.toString().toLowerCase() ?? '';
//
//             // Check if any field contains the search query
//             matchesSearch = brand.contains(query) ||
//                 model.contains(query) ||
//                 region.contains(query) ||
//                 rtom.contains(query) ||
//                 type.contains(query);
//           }
//
//           return matchesRegion && matchesSearch;
//         }).toList();
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
//   void navigateToRectifierUnitDetails(dynamic RectifierUnit) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ViewRectifierUnit(RectifierUnit: RectifierUnit),
//       ),
//     );
//   }
//
//   Map<String, int> getSummary() {
//     int totalCount = 0;
//     int modularCount = 0;
//     int unitaryCount = 0;
//
//     for (var system in filteredRectifierSystems) {
//       totalCount++;
//       String type = system['Type'].toString().toLowerCase();
//
//       if (type.contains('modular')) {
//         modularCount++;
//       } else if (type.contains('unitary')) {
//         unitaryCount++;
//       }
//     }
//
//     return {
//       'Total Rectifiers': totalCount,
//       'Modular': modularCount,
//       'Unitary': unitaryCount,
//     };
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final summary = getSummary();
//
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         backgroundColor: mainBackgroundColor,
//         appBar: AppBar(
//           title: const Text(
//             'Rectifier Details',
//             style: TextStyle(color: Colors.white),
//           ),
//           centerTitle: true,
//           backgroundColor: const Color(0xff2B3136),
//           iconTheme: const IconThemeData(color: Colors.white),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 2,
//                     child: DropdownButtonFormField<String>(
//                       value: selectedRegion,
//                       decoration: const InputDecoration(
//                         labelText: 'Region',
//                         border: OutlineInputBorder(),
//                       ),
//                       dropdownColor: suqarBackgroundColor,
//                       onChanged: handleRegionChange,
//                       items: regions.map((region) {
//                         return DropdownMenuItem<String>(
//                           value: region,
//                           child: Text(region, style: const TextStyle(color: mainTextColor)),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     flex: 3,
//                     child: SearchWidget(
//                       onSearch: handleSearch,
//                       hintText: 'Search',
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               // Summary Table
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Table(
//                   border: TableBorder.all(
//                     color: mainTextColor,
//                   ),
//                   columnWidths: const {0: FixedColumnWidth(200)},
//                   children: [
//                     const TableRow(
//                       children: [
//                         TableCell(
//                           child: Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text('Summary',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: mainTextColor,
//                                 )),
//                           ),
//                         ),
//                         TableCell(
//                           child: Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text('Count',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: mainTextColor,
//                                 )),
//                           ),
//                         ),
//                       ],
//                     ),
//                     TableRow(
//                       children: [
//                         const TableCell(
//                           child: Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text(
//                               'Total Rectifiers',
//                               style: TextStyle(
//                                 color: subTextColor,
//                               ),
//                             ),
//                           ),
//                         ),
//                         TableCell(
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               '${summary['Total Rectifiers']}',
//                               style: const TextStyle(
//                                 color: subTextColor,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     TableRow(
//                       children: [
//                         const TableCell(
//                           child: Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text(
//                               'Modular',
//                               style: TextStyle(
//                                 color: subTextColor,
//                               ),
//                             ),
//                           ),
//                         ),
//                         TableCell(
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               '${summary['Modular']}',
//                               style: const TextStyle(
//                                 color: subTextColor,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     TableRow(
//                       children: [
//                         const TableCell(
//                           child: Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text(
//                               'Unitary',
//                               style: TextStyle(
//                                 color: subTextColor,
//                               ),
//                             ),
//                           ),
//                         ),
//                         TableCell(
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               '${summary['Unitary']}',
//                               style: const TextStyle(
//                                 color: subTextColor,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Expanded(
//                 child: isLoading
//                     ? const Center(
//                   child: CircularProgressIndicator(),
//                 )
//                     : filteredRectifierSystems.isEmpty
//                     ? const Center(
//                   child: Text(
//                     'No Rectifier systems found.',
//                     style: TextStyle(fontSize: 16, color: subTextColor),
//                   ),
//                 )
//                     : ListView.builder(
//                   itemCount: filteredRectifierSystems.length,
//                   itemBuilder: (context, index) {
//                     final system = filteredRectifierSystems[index];
//                     return Card(
//                       color: mainBackgroundColor,
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                         decoration: BoxDecoration(
//                           color: suqarBackgroundColor,
//                           borderRadius: BorderRadius.circular(8.0),
//                           boxShadow: const [
//                             BoxShadow(
//                               color: Color(0xFF918F8F),
//                               blurRadius: 4.0,
//                               spreadRadius: 1.0,
//                               offset: Offset(2.0, 2.0),
//                             ),
//                           ],
//                         ),
//                         child: ListTile(
//                           leading: const Icon(
//                             Icons.battery_charging_full,
//                             color: subTextColor,
//                           ),
//                           title: Text(
//                             '${system['Brand']} - ${system['Model']}',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: subTextColor,
//                             ),
//                           ),
//                           subtitle: Text(
//                             'Location: ${system['Region']} - ${system['RTOM']}',
//                             style: const TextStyle(color: subTextColor),
//                           ),
//                           onTap: () {
//                             navigateToRectifierUnitDetails(system);
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



//v2
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'ViewRectifierUnit.dart';
// import '../../HomePage/utils/colors.dart';
//
// class ViewRectifierDetails extends StatefulWidget {
//   @override
//   _ViewRectifierDetailsState createState() => _ViewRectifierDetailsState();
// }
//
// class _ViewRectifierDetailsState extends State<ViewRectifierDetails> {
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
//     'UVA'
//   ];
//
//   String selectedRegion = 'ALL'; // Initial selected region
//   List<dynamic> RectifierSystems = []; // List to store Rectifier system data
//   bool isLoading = true; // Flag to track if data is being loaded
//
//   Future<void> fetchRectifierSystems() async {
//     final url = 'https://powerprox.sltidc.lk/GetRecSys.php'; // Replace with the URL of your PHP script
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
//       setState(() {
//         isLoading = false; // Set isLoading to false in case of an error
//       });
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
//         builder: (context) => ViewRectifierUnit(RectifierUnit: RectifierUnit),
//       ),
//     );
//   }
//
//   Map<String, int> getSummary() {
//     int totalCount = 0;
//     int modularCount = 0;
//     int unitaryCount = 0;
//
//     for (var system in RectifierSystems) {
//       if (selectedRegion == 'ALL' || system['Region'] == selectedRegion) {
//         totalCount++;
//         String type = system['Type'].toString().toLowerCase();
//
//         if (type.contains('modular')) {
//           modularCount++;
//         } else if (type.contains('unitary')) {
//           unitaryCount++;
//         }
//       }
//     }
//
//     return {
//       'Total Rectifiers': totalCount,
//       'Modular': modularCount,
//       'Unitary': unitaryCount,
//     };
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final summary = getSummary();
//
//     return Scaffold(
//       backgroundColor:mainBackgroundColor,
//       appBar: AppBar(
//         title: Text(
//           'Rectifier Details',
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color(0xff2B3136),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 20),
//             Text(
//               'Select a region to view rectifier details:',
//               style: TextStyle(
//                 color: mainTextColor,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 20),
//             DropdownButtonFormField<String>(
//               value: selectedRegion,
//               decoration: InputDecoration(
//                 labelText: 'Region',
//                 border: OutlineInputBorder(),
//               ),
//               dropdownColor: suqarBackgroundColor,
//               onChanged: (value) {
//                 setState(() {
//                   selectedRegion = value!;
//                 });
//               },
//               items: regions.map((region) {
//                 return DropdownMenuItem<String>(
//                   value: region,
//                   child: Text(region, style: TextStyle(color: qrcodeiconColor1),),
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 20),
//             // Summary Table
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Table(
//                 border: TableBorder.all(
//                   color: mainTextColor,
//                 ),
//                 columnWidths: {0: FixedColumnWidth(200)},
//                 children: [
//                   TableRow(
//                     children: [
//                       TableCell(child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('Summary', style: TextStyle(fontWeight: FontWeight.bold,
//                           color: subTextColor,)),
//                       )),
//                       TableCell(child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('Count', style: TextStyle(fontWeight: FontWeight.bold,color: subTextColor,)),
//                       )),
//                     ],
//                   ),
//                   TableRow(
//                     children: [
//                       TableCell(child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('Total Rectifiers',
//                           style: TextStyle(
//                             color: subTextColor,
//                           ),),
//                       )),
//                       TableCell(child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('${summary['Total Rectifiers']}',
//                           style: TextStyle(
//                             color: subTextColor,),),
//                       )),
//                     ],
//                   ),
//                   TableRow(
//                     children: [
//                       TableCell(child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('Modular',
//                           style: TextStyle(
//                             color: subTextColor,),
//                         ),
//                       )),
//                       TableCell(child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('${summary['Modular']}',
//                           style: TextStyle(
//                             color: subTextColor,),),
//                       )),
//                     ],
//                   ),
//                   TableRow(
//                     children: [
//                       TableCell(child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('Unitary',
//                           style: TextStyle(
//                             color: subTextColor,),),
//                       )),
//                       TableCell(child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('${summary['Unitary']}',
//                           style: TextStyle(
//                             color: subTextColor,),),
//                       )),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: isLoading
//                   ? Center(
//                 child: CircularProgressIndicator(),
//               )
//                   : RectifierSystems.isEmpty
//                   ? Center(
//                 child: Text(
//                   'No Rectifier systems found.',
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ):
//               ListView.builder(
//                 itemCount: RectifierSystems.length,
//                 itemBuilder: (context, index) {
//                   final system = RectifierSystems[index];
//                   if (selectedRegion == 'ALL' ||
//                       system['Region'] == selectedRegion) {
//                     return Card(
//                       color: mainBackgroundColor,
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Margin around the container
//                         decoration: BoxDecoration(
//                           color: suqarBackgroundColor, // Background color of the ListTile
//                           borderRadius: BorderRadius.circular(8.0), // Border radius
//                           boxShadow: const [
//                             BoxShadow(
//                               color: Color(0xFF918F8F), // Shadow color
//                               blurRadius: 4.0, // Softening the shadow
//                               spreadRadius: 1.0, // Extent of shadow
//                               offset: Offset(2.0, 2.0), // Shadow position
//                             ),
//                           ],
//                         ),                      child: ListTile(
//                         leading: Icon(Icons.battery_charging_full, color: subTextColor,),
//                         title: Text(
//                           '${system['Brand']} - ${system['Model']}',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: subTextColor,
//                           ),
//                         ),
//                         subtitle: Text(
//                           'Location: ${system['Region']} - ${system['RTOM']}',
//                           style: TextStyle(color: subTextColor,),
//                         ),
//                         onTap: () {
//                           navigateToRectifierUnitDetails(system);
//                         },
//                       ),
//                       ),
//
//                     );
//                   } else {
//                     return SizedBox.shrink();
//                   }
//                 },
//               ),
//
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




//v1
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'ViewRectifierUnit.dart';
//
// class ViewRectifierDetails extends StatefulWidget {
//   @override
//   _ViewRectifierDetailsState createState() => _ViewRectifierDetailsState();
// }
//
// class _ViewRectifierDetailsState extends State<ViewRectifierDetails> {
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
//     'UVA'
//   ];
//
//   String selectedRegion = 'ALL'; // Initial selected region
//   List<dynamic> RectifierSystems = []; // List to store Rectifier system data
//   bool isLoading = true; // Flag to track if data is being loaded
//
//   Future<void> fetchRectifierSystems() async {
//     final url = 'https://powerprox.sltidc.lk/GetRecSys.php'; // Replace with the URL of your PHP script
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
//       setState(() {
//         isLoading = false; // Set isLoading to false in case of an error
//       });
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
//         builder: (context) => ViewRectifierUnit(RectifierUnit: RectifierUnit),
//       ),
//     );
//   }
//
//   Map<String, int> getSummary() {
//     int totalCount = 0;
//     int modularCount = 0;
//     int unitaryCount = 0;
//
//     for (var system in RectifierSystems) {
//       if (selectedRegion == 'ALL' || system['Region'] == selectedRegion) {
//         totalCount++;
//         String type = system['Type'].toString().toLowerCase();
//
//         if (type.contains('modular')) {
//           modularCount++;
//         } else if (type.contains('unitary')) {
//           unitaryCount++;
//         }
//       }
//     }
//
//     return {
//       'Total Rectifiers': totalCount,
//       'Modular': modularCount,
//       'Unitary': unitaryCount,
//     };
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final summary = getSummary();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Rectifier Details',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: const Color.fromARGB(255, 0, 68, 186),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 20),
//             Text(
//               'Select a region to view rectifier details:',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 20),
//             DropdownButtonFormField<String>(
//               value: selectedRegion,
//               decoration: InputDecoration(
//                 labelText: 'Region',
//                 border: OutlineInputBorder(),
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
//             SizedBox(height: 20),
//             // Summary Table
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Table(
//                 border: TableBorder.all(),
//                 columnWidths: {0: FixedColumnWidth(200)},
//                 children: [
//                   TableRow(
//                     children: [
//                       TableCell(child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('Summary', style: TextStyle(fontWeight: FontWeight.bold)),
//                       )),
//                       TableCell(child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('Count', style: TextStyle(fontWeight: FontWeight.bold)),
//                       )),
//                     ],
//                   ),
//                   TableRow(
//                     children: [
//                       TableCell(child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('Total Rectifiers'),
//                       )),
//                       TableCell(child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('${summary['Total Rectifiers']}'),
//                       )),
//                     ],
//                   ),
//                   TableRow(
//                     children: [
//                       TableCell(child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('Modular'),
//                       )),
//                       TableCell(child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('${summary['Modular']}'),
//                       )),
//                     ],
//                   ),
//                   TableRow(
//                     children: [
//                       TableCell(child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('Unitary'),
//                       )),
//                       TableCell(child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('${summary['Unitary']}'),
//                       )),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: isLoading
//                   ? Center(
//                 child: CircularProgressIndicator(),
//               )
//                   : RectifierSystems.isEmpty
//                   ? Center(
//                 child: Text(
//                   'No Rectifier systems found.',
//                   style: TextStyle(fontSize: 16),
//                 ),
//               )
//                   : ListView.builder(
//                 itemCount: RectifierSystems.length,
//                 itemBuilder: (context, index) {
//                   final system = RectifierSystems[index];
//                   if (selectedRegion == 'ALL' ||
//                       system['Region'] == selectedRegion) {
//                     return Card(
//                       margin: EdgeInsets.symmetric(vertical: 10),
//                       child: ListTile(
//                         leading: Icon(Icons.battery_charging_full),
//                         title: Text(
//                           '${system['Brand']} - ${system['Model']}',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         subtitle: Text(
//                           'Location: ${system['Region']} - ${system['RTOM']}',
//                         ),
//                         onTap: () {
//                           navigateToRectifierUnitDetails(system);
//                         },
//                       ),
//                     );
//                   } else {
//                     return SizedBox.shrink();
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
