import 'package:flutter/material.dart';
import 'utils/utils/colors.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = false;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  ThemeData get currentTheme {
    return isDarkMode ? darkTheme : lightTheme;
  }

  ThemeData get lightTheme => ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: appbarColor,
      foregroundColor: mainTextColor,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: mainTextColor),
      bodyMedium: TextStyle(color: mainTextColor),
    ),

    useMaterial3: false,
    cardColor: Colors.blueGrey,

    extensions: <ThemeExtension<dynamic>>[
      const CustomColors(
        mainBackgroundColor: mainBackgroundColor,
        appbarColor: appbarColor,
        mainTextColor: mainTextColor,
        subTextColor: subTextColor,
        suqarBackgroundColor: suqarBackgroundColor,
        highlightColor: Colors.blue, // Highlight color for dark theme
      ),
    ],
  );

  ThemeData get darkTheme => ThemeData(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff212529),
      foregroundColor: Color(0xffFFFFFF),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xffFFFFFF)),
      bodyMedium: TextStyle(color: Color(0xffD9D9D9)),
    ),

    useMaterial3: false,
    cardColor: Colors.blue, //tested here for default card color

    extensions: <ThemeExtension<dynamic>>[
      const CustomColors(
        mainBackgroundColor: Colors.white,
        appbarColor: Colors.white54,
        mainTextColor: Colors.black,
        subTextColor: Colors.black87,
        suqarBackgroundColor: Colors.white,
        highlightColor: Colors.blue, // Highlight color for light theme
      ),
    ],
  );
}

class CustomColors extends ThemeExtension<CustomColors> {
  final Color mainBackgroundColor;
  final Color appbarColor;
  final Color mainTextColor;
  final Color subTextColor;
  final Color suqarBackgroundColor;
  final Color highlightColor; // Add highlightColor here

  const CustomColors({
    required this.mainBackgroundColor,
    required this.appbarColor,
    required this.mainTextColor,
    required this.subTextColor,
    required this.suqarBackgroundColor,
    required this.highlightColor, // Initialize highlightColor
  });

  @override
  CustomColors copyWith({
    Color? mainBackgroundColor,
    Color? appbarColor,
    Color? mainTextColor,
    Color? subTextColor,
    Color? suqarBackgroundColor,
    Color? highlightColor, // Add highlightColor to copyWith
  }) {
    return CustomColors(
      mainBackgroundColor: mainBackgroundColor ?? this.mainBackgroundColor,
      appbarColor: appbarColor ?? this.appbarColor,
      mainTextColor: mainTextColor ?? this.mainTextColor,
      subTextColor: subTextColor ?? this.subTextColor,
      suqarBackgroundColor: suqarBackgroundColor ?? this.suqarBackgroundColor,
      highlightColor:
          highlightColor ?? this.highlightColor, // Copy highlightColor
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      mainBackgroundColor:
          Color.lerp(mainBackgroundColor, other.mainBackgroundColor, t)!,
      appbarColor: Color.lerp(appbarColor, other.appbarColor, t)!,
      mainTextColor: Color.lerp(mainTextColor, other.mainTextColor, t)!,
      subTextColor: Color.lerp(subTextColor, other.subTextColor, t)!,
      suqarBackgroundColor:
          Color.lerp(suqarBackgroundColor, other.suqarBackgroundColor, t)!,
      highlightColor:
          Color.lerp(
            highlightColor,
            other.highlightColor,
            t,
          )!, // Lerp highlightColor
    );
  }
}
                            value: region,
                            child: Text(region,
                                style: TextStyle(color: customColors.mainTextColor)),
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
                              child: Text('Summary',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: customColors.mainTextColor)),
                            )),
                        TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Count',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: customColors.mainTextColor)),
                            )),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Total Systems',
                                style: TextStyle(color: customColors.subTextColor),
                              ),
                            )),
                        TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${summary['Total Systems']}',
                                style: TextStyle(color: customColors.subTextColor),
                              ),
                            )),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Less than 10 kVA',
                                style: TextStyle(color: customColors.subTextColor),
                              ),
                            )),
                        TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${summary['Less than 10 kVA']}',
                                style: TextStyle(color: customColors.subTextColor),
                              ),
                            )),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '10-100 kVA',
                                style: TextStyle(color: customColors.subTextColor),
                              ),
                            )),
                        TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${summary['10-100 kVA']}',
                                style: TextStyle(color: customColors.subTextColor),
                              ),
                            )),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'More than 100 kVA',
                                style: TextStyle(color: customColors.subTextColor),
                              ),
                            )),
                        TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${summary['More than 100 kVA']}',
                                style: TextStyle(color: customColors.subTextColor),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: isLoading
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
                      color: customColors.mainBackgroundColor,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        decoration: BoxDecoration(
                          color: customColors.suqarBackgroundColor,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow:  [
                            BoxShadow(
                              color: Color(0xFF918F8F),
                              blurRadius: 4.0,
                              spreadRadius: 1.0,
                              offset: Offset(2.0, 2.0),
                            ),
                          ], // Set border color to black
                        ),
                        child: ListTile(
                          title: Text(
                            'Model: ${system['Model']}',
                            style:
                            TextStyle(color: customColors.mainTextColor),
                          ),
                          subtitle: Text(
                            'Location: ${system['Region']}-${system['RTOM']}',
                            style:
                            TextStyle(color: customColors.subTextColor),
                          ),
                          onTap: () {
                            navigateToBatteryUnitDetails(system);
                          },
                        ),
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