import 'package:provider/provider.dart';
// import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/utils/utils/colors.dart' as customColors;
// import '../../theme_provider.dart';
import '../../widgets/searchWidget.dart';
import '../../widgets/theme change related widjets/theme_provider.dart';
import '../../widgets/theme change related widjets/theme_toggle_button.dart';
import 'search_helper_transformer.dart';
import 'transformer_details_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:flutter/material.dart';
import 'http_get_services.dart';

class ViewTransformerData extends StatefulWidget {
  @override
  _ViewTransformerDataState createState() => _ViewTransformerDataState();
}

class _ViewTransformerDataState extends State<ViewTransformerData> {
  String? selectedRegion = 'Select Region';
  String? selectedRTOM = 'Select RTOM';
  List<String> regionList = ['Select Region'];
  List<String> rtomList = ['Select RTOM'];
  List<Map<String, dynamic>> transformerList = [];
  List<Map<String, dynamic>> filteredTransformers = [];
  int dryTypeCount = 0;
  int oilTypeCount = 0;
  int totalTransformerCount = 0;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Fetch data from all sources
    List<Map<String, dynamic>> transformers =
        await HttpGetServices.getTransformers();
    List<Map<String, dynamic>> regions = await HttpGetServices.getRegions();
    List<Map<String, dynamic>> rtoms = await HttpGetServices.getRTOMs();

    // Extract region and RTOM values that exist in the transformer data
    Set<String> transformerRegions =
        transformers.map((e) => e['Region'].toString()).toSet();
    Set<String> transformerRTOMs =
        transformers.map((e) => e['RTOM'].toString()).toSet();

    // Filter region and RTOM lists based on the transformer data
    regionList =
        ['Select Region'] +
        regions
            .where((region) => transformerRegions.contains(region['Region']))
            .map((region) => region['Region'].toString())
            .toList();

    rtomList =
        ['Select RTOM'] +
        rtoms
            .where((rtom) => transformerRTOMs.contains(rtom['RTOM']))
            .map((rtom) => rtom['RTOM'].toString())
            .toList();

    // Set the initial transformer list and filtered list
    setState(() {
      transformerList = transformers;
      filteredTransformers = transformers;
    });

    // Update summary counts
    updateSummaryCounts();
  }

  void filterTransformers() {
    setState(() {
      filteredTransformers =
          transformerList.where((transformer) {
            final regionMatches =
                selectedRegion == 'Select Region' ||
                transformer['Region'] == selectedRegion;
            final rtomMatches =
                selectedRTOM == 'Select RTOM' || transformer['RTOM'] == selectedRTOM;
            final searchMatches =
                searchQuery.isEmpty ||
                SearchHelperTransformer.matchesTransformerQuery(
                  transformer,
                  searchQuery,
                );
            return regionMatches && rtomMatches && searchMatches;
          }).toList();
    });
    updateSummaryCounts();
  }

  void handleSearch(String query) {
    setState(() {
      searchQuery = query;
      filterTransformers();
    });
  }

  void updateSummaryCounts() {
    // Calculate the summary statistics based on the filtered transformers
    setState(() {
      dryTypeCount =
          filteredTransformers
              .where((t) => t['TransformerType'] == 'Dry-Type')
              .length;
      oilTypeCount =
          filteredTransformers
              .where((t) => t['TransformerType'] == 'Oil-Type')
              .length;
      totalTransformerCount = filteredTransformers.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Transformer Data',
          style: TextStyle(
            color: customColors.mainTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: customColors.mainTextColor),
        backgroundColor: customColors.appbarColor,
        centerTitle: true,
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),

      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.opaque,
        // ...existing code...
        child: Container(
          color: customColors.mainBackgroundColor,
          child: Column(
            children: [
              // Combine Search Bar and Dropdowns in a Row
              // ...existing code...
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // Left side: Region and RTOM dropdowns (now stacked vertically)
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          _buildFormFieldWithSpacing(
                            context,
                            //_buildFieldLabel(context, 'Region'),
                            SizedBox.shrink(), // No label
                            FormBuilderDropdown<String>(
                               name: 'Region',
                              decoration: _inputDecoration(
                                context,
                                'Select Region',
                              ),
                              initialValue: selectedRegion,
                              isExpanded: true,
                              dropdownColor: customColors.suqarBackgroundColor,
                              onChanged: (value) {
                                setState(() {
                                  selectedRegion = value;
                                  filterTransformers();
                                });
                              },
                              items:
                                  regionList.map((region) {
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
                          _buildFormFieldWithSpacing(
                            context,
                            // _buildFieldLabel(context, 'RTOM'),
                            SizedBox.shrink(), // No label

                            FormBuilderDropdown<String>(
                              name: 'RTOM',
                              decoration: _inputDecoration(
                                context,
                                'Select RTOM',
                              ),
                              initialValue: selectedRTOM,
                              isExpanded: true,
                              dropdownColor: customColors.suqarBackgroundColor,
                              style: TextStyle(
                                color: customColors.mainTextColor,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  selectedRTOM = value;
                                  filterTransformers();
                                });
                              },
                              items:
                                  rtomList.map((rtom) {
                                    return DropdownMenuItem<String>(
                                      value: rtom,
                                      child: Text(
                                        rtom,
                                        style: TextStyle(
                                          color: customColors.mainTextColor,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    // Right side: Search bar
                    Expanded(
                      flex: 3,
                      child: SearchWidget(
                        onSearch: handleSearch,
                        hintText: 'Search...',
                      ),
                    ),
                  ],
                ),
              ),
              // Summary Table
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  border: TableBorder.all(color: customColors.subTextColor),
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: customColors.mainTextColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Count",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: customColors.mainTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Dry Type Count',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: customColors.subTextColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            dryTypeCount.toString(),
                            style: TextStyle(color: customColors.mainTextColor),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Oil Type Count',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: customColors.subTextColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            oilTypeCount.toString(),
                            style: TextStyle(color: customColors.mainTextColor),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Total Transformers',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: customColors.subTextColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            totalTransformerCount.toString(),
                            style: TextStyle(color: customColors.mainTextColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Transformer Cards
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTransformers.length,
                  itemBuilder: (context, index) {
                    final transformer = filteredTransformers[index];
                    return Card(
                      color: customColors.suqarBackgroundColor,
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          'Transformer ID: ${transformer['Transforme_ID']}',
                          style: TextStyle(color: customColors.mainTextColor),
                        ),
                        subtitle: Text(
                          'Region: ${transformer['Region']}, RTOM: ${transformer['RTOM']}',
                          style: TextStyle(color: customColors.mainTextColor),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => TransformerDetailScreen(
                                    transformerData: transformer,
                                    searchQuery: searchQuery,
                                  ),
                            ),
                          );
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

// Helper method to build a form field with spacing
Widget _buildFormFieldWithSpacing(
  BuildContext context,
  Widget label,
  Widget field,
) {
  final customColors = Theme.of(context).extension<CustomColors>()!;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [label, field, const SizedBox(height: 16.0)],
  );
}

// Helper method to build a field label
Widget _buildFieldLabel(BuildContext context, String labelText) {
  final customColors = Theme.of(context).extension<CustomColors>()!;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      labelText,
      style: TextStyle(
        color: customColors.mainTextColor,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

InputDecoration _inputDecoration(BuildContext context, String labelText) {
  final customColors = Theme.of(context).extension<CustomColors>()!;

  return InputDecoration(
    filled: true,
    // Fill color for better contrast
    fillColor: customColors.mainBackgroundColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      // borderSide: const BorderSide(color: Colors.blue),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.blue,
      ), // Change border color on focus
      // borderSide: const BorderSide(color: Colors.blueAccent),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
      // borderSide: const BorderSide(color: Colors.red),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: customColors.suqarBackgroundColor,
      ), // Normal border color        // borderSide: const BorderSide(color: Colors.blue),
    ),
    contentPadding: const EdgeInsets.symmetric(
      vertical: 16.0,
      horizontal: 12.0,
    ),
  );
}

//v2
// import 'transformer_details_screen.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
//
// import 'package:flutter/material.dart';
// import 'http_get_services.dart';
//
// class ViewTransformerData extends StatefulWidget {
//   @override
//   _ViewTransformerDataState createState() => _ViewTransformerDataState();
// }
//
// class _ViewTransformerDataState extends State<ViewTransformerData> {
//   String? selectedRegion = 'All';
//   String? selectedRTOM = 'All';
//   List<String> regionList = ['All'];
//   List<String> rtomList = ['All'];
//   List<Map<String, dynamic>> transformerList = [];
//   List<Map<String, dynamic>> filteredTransformers = [];
//   int dryTypeCount = 0;
//   int oilTypeCount = 0;
//   int totalTransformerCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//
//   Future<void> fetchData() async {
//     // Fetch data from all sources
//     List<Map<String, dynamic>> transformers =
//     await HttpGetServices.getTransformers();
//     List<Map<String, dynamic>> regions = await HttpGetServices.getRegions();
//     List<Map<String, dynamic>> rtoms = await HttpGetServices.getRTOMs();
//
//     // Extract region and RTOM values that exist in the transformer data
//     Set<String> transformerRegions =
//     transformers.map((e) => e['Region'].toString()).toSet();
//     Set<String> transformerRTOMs =
//     transformers.map((e) => e['RTOM'].toString()).toSet();
//
//     // Filter region and RTOM lists based on the transformer data
//     regionList = ['All'] +
//         regions
//             .where((region) => transformerRegions.contains(region['Region']))
//             .map((region) => region['Region'].toString())
//             .toList();
//
//     rtomList = ['All'] +
//         rtoms
//             .where((rtom) => transformerRTOMs.contains(rtom['RTOM']))
//             .map((rtom) => rtom['RTOM'].toString())
//             .toList();
//
//     // Set the initial transformer list and filtered list
//     setState(() {
//       transformerList = transformers;
//       filteredTransformers = transformers;
//     });
//
//     // Update summary counts
//     updateSummaryCounts();
//   }
//
//   void filterTransformers() {
//     setState(() {
//       filteredTransformers = transformerList.where((transformer) {
//         final regionMatches =
//             selectedRegion == 'All' || transformer['Region'] == selectedRegion;
//         final rtomMatches =
//             selectedRTOM == 'All' || transformer['RTOM'] == selectedRTOM;
//         return regionMatches && rtomMatches;
//       }).toList();
//     });
//
//     // Update summary counts after filtering
//     updateSummaryCounts();
//   }
//
//   void updateSummaryCounts() {
//     // Calculate the summary statistics based on the filtered transformers
//     setState(() {
//       dryTypeCount = filteredTransformers
//           .where((t) => t['TransformerType'] == 'Dry-Type')
//           .length;
//       oilTypeCount = filteredTransformers
//           .where((t) => t['TransformerType'] == 'Oil-Type')
//           .length;
//       totalTransformerCount = filteredTransformers.length;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'View Transformer Data',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.indigo,
//         centerTitle: true,
//       ),
//       body: Column(
//         //adding some space here
//         // mainAxisAlignment: MainAxisAlignment.start,
//
//         children: [
//           // Row for Region and RTOM Dropdowns
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 // Region Dropdown
//                 Expanded(
//                   flex: 5,
//                   child: _buildFormFieldWithSpacing(
//                     _buildFieldLabel('Region'),
//                     FormBuilderDropdown<String>(
//                       name: 'Region',
//                       decoration: _inputDecoration('Select Region'),
//                       initialValue: selectedRegion,
//                       isExpanded: true,
//                       onChanged: (value) {
//                         setState(() {
//                           selectedRegion = value;
//                           filterTransformers();
//                         });
//                       },
//                       items: regionList.map((region) {
//                         return DropdownMenuItem<String>(
//                           value: region,
//                           child: Text(region),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16.0), // Space between the two dropdowns
//
//                 // RTOM Dropdown
//                 Expanded(
//                   flex: 5,
//                   child: _buildFormFieldWithSpacing(
//                     _buildFieldLabel('RTOM'),
//                     FormBuilderDropdown<String>(
//                       name: 'RTOM',
//                       decoration: _inputDecoration('Select RTOM'),
//                       initialValue: selectedRTOM,
//                       isExpanded: true,
//                       onChanged: (value) {
//                         setState(() {
//                           selectedRTOM = value;
//                           filterTransformers();
//                         });
//                       },
//                       items: rtomList.map((rtom) {
//                         return DropdownMenuItem<String>(
//                           value: rtom,
//                           child: Text(rtom),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Summary Table
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Table(
//               border: TableBorder.all(),
//               children: [
//                 const TableRow(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text(
//                         'Transformer Summary',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     //Container(), // Empty cell
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text(
//                         "count",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 TableRow(
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text('Dry Type Count',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(dryTypeCount.toString()),
//                     ),
//                   ],
//                 ),
//                 TableRow(
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text('Oil Type Count',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(oilTypeCount.toString()),
//                     ),
//                   ],
//                 ),
//                 TableRow(
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text('Total Transformers',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(totalTransformerCount.toString()),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           // Transformer Cards
//           Expanded(
//             child: ListView.builder(
//               itemCount: filteredTransformers.length,
//               itemBuilder: (context, index) {
//                 final transformer = filteredTransformers[index];
//                 return Card(
//                   margin: EdgeInsets.all(8.0),
//                   child: ListTile(
//                     title:
//                     Text('Transformer ID: ${transformer['Transforme_ID']}'),
//                     subtitle: Text(
//                         'Region: ${transformer['Region']}, RTOM: ${transformer['RTOM']}'),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => TransformerDetailScreen(
//                             transformerData: transformer,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // Helper method to build a form field with spacing
// Widget _buildFormFieldWithSpacing(Widget label, Widget field) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       label,
//       field,
//       const SizedBox(height: 16.0),
//     ],
//   );
// }
//
// // Helper method to build a field label
// Widget _buildFieldLabel(String labelText) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8.0),
//     child: Text(
//       labelText,
//       style: const TextStyle(
//         fontSize: 16.0,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//   );
// }
//
// InputDecoration _inputDecoration(String labelText) {
//   return InputDecoration(
//     filled: true, // Fill color for better contrast
//     fillColor: Colors.white,
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       // borderSide: const BorderSide(color: Colors.blue),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       borderSide:
//       const BorderSide(color: Colors.blue), // Change border color on focus
//       // borderSide: const BorderSide(color: Colors.blueAccent),
//     ),
//     errorBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       borderSide: BorderSide.none,
//       // borderSide: const BorderSide(color: Colors.red),
//     ),
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       borderSide: const BorderSide(
//           color: Colors
//               .grey), // Normal border color        // borderSide: const BorderSide(color: Colors.blue),
//     ),
//     contentPadding:
//     const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
//   );
// }
//
//
//
//
// //v1
// // import 'package:flutter/material.dart';
// // import 'http_get_services.dart'; // Assuming you have a file for the HTTP service
// // import 'transformer_details_screen.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:flutter_form_builder/flutter_form_builder.dart';
// // import 'package:form_builder_validators/form_builder_validators.dart';
// //
// // class ViewTransformerData extends StatefulWidget {
// //   @override
// //   _ViewTransformerDataState createState() => _ViewTransformerDataState();
// // }
// //
// // class _ViewTransformerDataState extends State<ViewTransformerData> {
// //   final _formKey = GlobalKey<FormBuilderState>();
// //   String? selectedRegion;
// //   String? selectedStation;
// //   String? selectedRtom;
// //
// //
// //   Map<String, String> regionMap = {}; // Store region and Region_ID
// //   List<String> rtoms = [];
// //   String? selectedRTOM;
// //
// //   List<dynamic> _station = [];
// //   List<dynamic> _filteredStation = [];
// //   String? _selectedStation;
// //   bool _isStationLoading = false;
// //
// //   final List<String> regions = [
// //     'ALL',
// //     'CPN',
// //     'CPS',
// //     'EPN',
// //     'EPS',
// //     'EPN–TC',
// //     'HQ',
// //     'NCP',
// //     'NPN',
// //     'NPS',
// //     'NWPE',
// //     'NWPW',
// //     'PITI',
// //     'SAB',
// //     'SMW6',
// //     'SPE',
// //     'SPW',
// //     'WEL',
// //     'WPC',
// //     'WPE',
// //     'WPN',
// //     'WPNE',
// //     'WPS',
// //     'WPSE',
// //     'WPSW',
// //     'UVA'
// //   ];
// //   Map<String, String> _formData = {}; // To hold form data
// //   List<String> stations = [];
// //   List<String> rToms = [];
// //   List<Map<String, dynamic>> transformerData = [];
// //   List<Map<String, dynamic>> filteredTransformerData = [];
// //   bool isLoading = false;
// //
// //   int dryTypeCount = 0;
// //   int oilTypeCount = 0;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchData(); // Fetch all transformer data initially
// //     _fetchRegions(); // Fetch regions on widget initialization
// //     _loadStation(); // Load stations on initialization
// //   }
// //
// //   // Function to load Stations
// //   Future<void> _loadStation() async {
// //     setState(() {
// //       _isStationLoading = true; // Start loading
// //     });
// //
// //     try {
// //       final response = await http.get(
// //           Uri.parse('https://powerprox.sltidc.lk/GETLocationStationTable.php'));
// //       if (response.statusCode == 200) {
// //         final List<dynamic> data = json.decode(response.body);
// //
// //         setState(() {
// //           _station = data.map((item) => item['Station'].toString()).toList();
// //           _filteredStation = List.from(_station); // Copy list for filtering
// //           _isStationLoading = false; // Stop loading
// //         });
// //       } else {
// //         throw Exception('Failed to load Station data');
// //       }
// //     } catch (e) {
// //       print(e);
// //       setState(() {
// //         _isStationLoading = false;
// //       });
// //       _showErrorSnackBar('An error occurred while loading Station data.');
// //     }
// //   }
// //
// //   // Fetch Regions from the API and store Region with Region_ID
// //   Future<void> _fetchRegions() async {
// //     try {
// //       final response = await http
// //           .get(Uri.parse('https://powerprox.sltidc.lk/GETLocationRegion.php'));
// //       if (response.statusCode == 200) {
// //         final List<dynamic> data = json.decode(response.body);
// //
// //         setState(() {
// //           regionMap = {
// //             for (var item in data)
// //               item['Region'].toString(): item['Region_ID'].toString(),
// //           };
// //         });
// //       } else {
// //         throw Exception('Failed to load regions');
// //       }
// //     } catch (e) {
// //       print(e);
// //       _showErrorSnackBar('Failed to load regions.');
// //     }
// //   }
// //
// //   // Fetch RTOMs based on selected Region_ID
// //   Future<void> _fetchRTOMs(String regionName) async {
// //     setState(() {
// //       rtoms.clear(); // Clear any previous data
// //     });
// //
// //     final regionId = regionMap[regionName];
// //     if (regionId == null) {
// //       _showErrorSnackBar('Invalid region selected.');
// //       return;
// //     }
// //
// //     try {
// //       final response = await http
// //           .get(Uri.parse('https://powerprox.sltidc.lk/GETLocationRTOM.php'));
// //       if (response.statusCode == 200) {
// //         final List<dynamic> data = json.decode(response.body);
// //
// //         setState(() {
// //           rtoms = data
// //               .where((item) => item['Region_ID'].toString() == regionId)
// //               .map((item) => item['RTOM'].toString())
// //               .toList();
// //         });
// //       } else {
// //         throw Exception('Failed to load RTOM data');
// //       }
// //     } catch (e) {
// //       print(e);
// //       _showErrorSnackBar('An error occurred while loading RTOM data.');
// //     }
// //   }
// //   // Function to show a SnackBar error message
// //   void _showErrorSnackBar(String message) {
// //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //       content: Text(message),
// //       backgroundColor: Colors.red,
// //     ));
// //   }
// //   // Filter stations
// //   void _filterStations(String rtom) {
// //     setState(() {
// //       _filteredStation = rtom.isEmpty
// //           ? List.from(_station)
// //           : _station
// //           .where((station) =>
// //           station.toLowerCase().contains(rtom.toLowerCase()))
// //           .toList();
// //     });
// //   }
// //   Future<void> fetchData() async {
// //     setState(() {
// //       isLoading = true;
// //     });
// //
// //     try {
// //       HttpService service = HttpService();
// //       List<Map<String, dynamic>> data = await service.getTransformerData();
// //
// //       print(
// //           'Fetched transformer data: ${data.length} entries'); // Debug: Check the data fetched
// //
// //       setState(() {
// //         transformerData = data;
// //         filteredTransformerData = data;
// //         calculateSummary(); // Calculate initial summary
// //       });
// //     } catch (e) {
// //       print('Failed to fetch transformer data: $e');
// //     } finally {
// //       setState(() {
// //         isLoading = false;
// //       });
// //     }
// //   }
// //
// //   Future<void> fetchStations(String region) async {
// //     setState(() {
// //       isLoading = true;
// //     });
// //
// //     try {
// //       HttpService service = HttpService();
// //       List<String> fetchedStations = await service.getStationsByRegion(region);
// //       setState(() {
// //         stations = fetchedStations;
// //       });
// //
// //       print(
// //           'Fetched stations for region $region: $fetchedStations'); // Debug: Check stations fetched
// //     } catch (e) {
// //       print('Failed to fetch stations: $e');
// //     } finally {
// //       setState(() {
// //         isLoading = false;
// //       });
// //     }
// //   }
// //
// //   Future<void> fetchRtoms(String region, String station) async {
// //     setState(() {
// //       isLoading = true;
// //     });
// //
// //     try {
// //       HttpService service = HttpService();
// //       List<String> fetchedRtoms =
// //           await service.getRtomsByRegionAndStation(region, station);
// //       setState(() {
// //         rToms = fetchedRtoms;
// //       });
// //
// //       print(
// //           'Fetched RTOMs for region $region and station $station: $fetchedRtoms'); // Debug: Check RTOMs fetched
// //     } catch (e) {
// //       print('Failed to fetch RTOMs: $e');
// //     } finally {
// //       setState(() {
// //         isLoading = false;
// //       });
// //     }
// //   }
// //
// //   void filterData() {
// //     // Create a temporary list to store filtered data based on selected criteria
// //     List<Map<String, dynamic>> tempData = transformerData.where((site) {
// //       // Filter by selected region if it's not null or 'ALL'
// //       if (selectedRegion != null &&
// //           selectedRegion != 'ALL' &&
// //           site['Region'] != selectedRegion) {
// //         return false;
// //       }
// //
// //       // Filter by selected RTOM if it's not null and matches the selected region
// //       if (selectedRTOM != null && site['RTOM'] != selectedRTOM) {
// //         return false;
// //       }
// //
// //       // Filter by selected station if it's not null and matches the selected RTOM
// //       if (_selectedStation != null && site['Station'] != _selectedStation) {
// //         return false;
// //       }
// //
// //       // Return true if the site matches all criteria
// //       return true;
// //     }).toList();
// //
// //     print('Filtered data: ${tempData.length} entries'); // Debug: Check filtered data
// //
// //     // Update state with filtered data and recalculate summary
// //     setState(() {
// //       filteredTransformerData = tempData;
// //       calculateSummary(); // Recalculate summary whenever data is filtered
// //     });
// //   }
// //
// //
// //   void calculateSummary() {
// //     int dryCount = 0;
// //     int oilCount = 0;
// //
// //     print(
// //         'Calculating summary for ${filteredTransformerData.length} transformers'); // Debug: Check how many transformers are being processed
// //
// //     for (var transformer in filteredTransformerData) {
// //       // Normalize TransformerType strings to avoid mismatches
// //       String transformerType =
// //           transformer['TransformerType']?.toLowerCase() ?? '';
// //       print(
// //           'Processing transformer type: $transformerType'); // Debug: Check transformer type
// //
// //       if (transformerType.contains('dry')) {
// //         dryCount++;
// //       } else if (transformerType.contains('oil')) {
// //         oilCount++;
// //       }
// //     }
// //
// //     print(
// //         'Summary: Dry Type = $dryCount, Oil Type = $oilCount'); // Debug: Check calculated counts
// //
// //     setState(() {
// //       dryTypeCount = dryCount;
// //       oilTypeCount = oilCount;
// //     });
// //   }
// //   // Function to Show Dialog for Adding New Station
// //   void _showAddNewStationDialog(String key, String label) {
// //     TextEditingController _newStationController = TextEditingController();
// //
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text('Add New $label'),
// //           content: TextField(
// //             controller: _newStationController,
// //             decoration: InputDecoration(hintText: 'Enter new $label'),
// //           ),
// //           actions: [
// //             TextButton(
// //               child: Text('Cancel'),
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //             TextButton(
// //               child: Text('Add'),
// //               onPressed: () {
// //                 if (_newStationController.text.isNotEmpty) {
// //                   setState(() {
// //                     _filteredStation.add(_newStationController
// //                         .text); // Add new station to filtered list
// //                     _station.add(_newStationController
// //                         .text); // Add to the main station list
// //                     _formData[key] = _newStationController
// //                         .text; // Automatically select new station
// //                     _selectedStation = _newStationController
// //                         .text; // Set selected value in the dropdown
// //                     _showSnackBar(
// //                         'New station added: ${_newStationController.text}'); // Show confirmation snack bar
// //                   });
// //                   Navigator.of(context).pop();
// //                 }
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //   void _showSnackBar(String message) {
// //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //       content: Text(message),
// //       backgroundColor: Colors.green,
// //     ));
// //   }
// //   // Helper method to build a form field with spacing
// //   Widget _buildFormFieldWithSpacing(Widget label, Widget field) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         label,
// //         field,
// //         const SizedBox(height: 16.0),
// //       ],
// //     );
// //   }
// //
// //   InputDecoration _inputDecoration(String labelText) {
// //     return InputDecoration(
// //       filled: true, // Fill color for better contrast
// //       fillColor: Colors.white,
// //       border: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(10),
// //         // borderSide: const BorderSide(color: Colors.blue),
// //       ),
// //       focusedBorder: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(10),
// //         borderSide: const BorderSide(
// //             color: Colors.blue), // Change border color on focus
// //         // borderSide: const BorderSide(color: Colors.blueAccent),
// //       ),
// //       errorBorder: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(10),
// //         borderSide: BorderSide.none,
// //         // borderSide: const BorderSide(color: Colors.red),
// //       ),
// //       enabledBorder: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(10),
// //         borderSide: const BorderSide(
// //             color: Colors
// //                 .grey), // Normal border color        // borderSide: const BorderSide(color: Colors.blue),
// //       ),
// //       contentPadding:
// //       const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
// //     );
// //   }
// //   // Helper method to build a field label
// //   Widget _buildFieldLabel(String labelText) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 8.0),
// //       child: Text(
// //         labelText,
// //         style: const TextStyle(
// //           fontSize: 16.0,
// //           fontWeight: FontWeight.bold,
// //         ),
// //       ),
// //     );
// //   }
// //   void _showAddNewRTOMDialog() {
// //     TextEditingController _newRTOMController = TextEditingController();
// //
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: const Text('Add New RTOM'),
// //           content: TextField(
// //             controller: _newRTOMController,
// //             decoration: const InputDecoration(hintText: 'Enter new RTOM'),
// //           ),
// //           actions: [
// //             TextButton(
// //               child: const Text('Cancel'),
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //             TextButton(
// //               child: const Text('Add'),
// //               onPressed: () {
// //                 if (_newRTOMController.text.isNotEmpty) {
// //                   setState(() {
// //                     rtoms.add(_newRTOMController
// //                         .text); // Add the new RTOM to the list
// //                     selectedRTOM =
// //                         _newRTOMController.text; // Set the new RTOM as selected
// //                     _formData['rtom'] =
// //                         _newRTOMController.text; // Update form data
// //                     _showSnackBar(
// //                         'New RTOM added: ${_newRTOMController.text}'); // Show confirmation
// //                   });
// //                   Navigator.of(context).pop();
// //                 }
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           'View Transformer Data',
// //           style: TextStyle(
// //             color: Colors.white,
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //         backgroundColor: Colors.indigo,
// //         centerTitle: true,
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // Region Dropdown
// //             _buildFormFieldWithSpacing(
// //               _buildFieldLabel('Region'), // Adding label with consistent UI
// //               FormBuilderDropdown<String>(
// //                 name: 'Region',
// //                 decoration: _inputDecoration('Select Region'), // Consistent decoration
// //                 items: regionMap.keys.map((region) {
// //                   return DropdownMenuItem<String>(
// //                     value: region,
// //                     child: Text(region),
// //                   );
// //                 }).toList(),
// //                 onChanged: (String? newValue) {
// //                   setState(() {
// //                     selectedRegion = newValue;
// //                     selectedRTOM = null; // Reset RTOM selection
// //                     _filteredStation.clear(); // Clear station list
// //                     _selectedStation = null; // Reset station selection
// //
// //                     if (newValue != null) {
// //                       _fetchRTOMs(newValue); // Fetch RTOMs based on selected region
// //                       filterData(); // Filter data based on new region selection
// //                     }
// //                   });
// //                 },
// //                 validator: FormBuilderValidators.required(
// //                   errorText: 'Please select a region.',
// //                 ),
// //               ),
// //             ),
// //
// // // RTOM Dropdown
// //             _buildFormFieldWithSpacing(
// //               _buildFieldLabel('RTOM'), // Adding label with consistent UI
// //               FormBuilderDropdown<String>(
// //                 name: 'RTOM',
// //                 initialValue: rtoms.contains(selectedRTOM) ? selectedRTOM : null,
// //                 decoration: _inputDecoration('Select RTOM'), // Consistent decoration
// //                 items: [
// //                   ...rtoms.map((rtom) {
// //                     return DropdownMenuItem<String>(
// //                       value: rtom,
// //                       child: Text(rtom),
// //                     );
// //                   }).toList(),
// //                   const DropdownMenuItem<String>(
// //                     value: 'Other',
// //                     child: Text('Other'),
// //                   ),
// //                 ],
// //                 onChanged: (String? newValue) {
// //                   setState(() {
// //                     if (newValue == 'Other') {
// //                       _showAddNewRTOMDialog(); // Show dialog to add a new RTOM
// //                     } else {
// //                       selectedRTOM = newValue;
// //                       _filterStations(newValue ?? ''); // Filter stations based on RTOM
// //                       _selectedStation = null; // Reset station selection
// //                       filterData(); // Filter data based on new RTOM selection
// //                     }
// //                   });
// //                 },
// //                 validator: FormBuilderValidators.required(
// //                   errorText: 'Please select an RTOM.',
// //                 ),
// //                 enabled: selectedRegion != null, // Disable if no region selected
// //               ),
// //             ),
// //
// // // Station Dropdown
// //             _buildFormFieldWithSpacing(
// //               _buildFieldLabel('Station'), // Adding label with consistent UI
// //               _isStationLoading
// //                   ? const Center(child: CircularProgressIndicator()) // Show loader
// //                   : FormBuilderDropdown<String>(
// //                 name: 'Station',
// //                 initialValue: _selectedStation,
// //                 decoration: _inputDecoration('Select Station'), // Consistent decoration
// //                 items: [
// //                   ..._filteredStation.map((station) {
// //                     return DropdownMenuItem<String>(
// //                       value: station,
// //                       child: Text(station),
// //                     );
// //                   }).toList(),
// //                   const DropdownMenuItem<String>(
// //                     value: 'Other',
// //                     child: Text('Other'),
// //                   ),
// //                 ],
// //                 onChanged: (String? newValue) {
// //                   setState(() {
// //                     if (newValue == 'Other') {
// //                       _showAddNewStationDialog('station', 'Station');
// //                     } else {
// //                       _formData['station'] = newValue ?? '';
// //                       _selectedStation = newValue;
// //                       filterData(); // Filter data based on new Station selection
// //                     }
// //                   });
// //                 },
// //                 validator: FormBuilderValidators.required(
// //                   errorText: 'Please select a station.',
// //                 ),
// //                 enabled: selectedRTOM != null, // Disable if no RTOM selected
// //               ),
// //             ),
// //
// //             // DropdownButtonFormField<String>(
// //             //   value: selectedRegion,
// //             //   hint: const Text('Select Region - ALL'),
// //             //   items: regions.map((String region) {
// //             //     return DropdownMenuItem<String>(
// //             //       value: region,
// //             //       child: Text(region),
// //             //     );
// //             //   }).toList(),
// //             //   onChanged: (value) {
// //             //     setState(() {
// //             //       selectedRegion = value;
// //             //       selectedStation = null;
// //             //       selectedRtom = null;
// //             //       stations = [];
// //             //       rToms = [];
// //             //       if (value != null) {
// //             //         filterData();
// //             //         if (value != 'ALL') {
// //             //           fetchStations(value);
// //             //         }
// //             //       }
// //             //     });
// //             //   },
// //             //   decoration: const InputDecoration(
// //             //     border: OutlineInputBorder(),
// //             //     contentPadding:
// //             //         EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //             //   ),
// //             // ),
// //             // const SizedBox(height: 20),
// //             // DropdownButtonFormField<String>(
// //             //   value: selectedStation,
// //             //   hint: const Text('Select Station'),
// //             //   items: stations.map((String station) {
// //             //     return DropdownMenuItem<String>(
// //             //       value: station,
// //             //       child: Text(station),
// //             //     );
// //             //   }).toList(),
// //             //   onChanged: (value) {
// //             //     setState(() {
// //             //       selectedStation = value;
// //             //       selectedRtom = null;
// //             //       rToms = [];
// //             //       if (value != null) {
// //             //         filterData();
// //             //         fetchRtoms(selectedRegion!, value);
// //             //       }
// //             //     });
// //             //   },
// //             //   decoration: const InputDecoration(
// //             //     border: OutlineInputBorder(),
// //             //     contentPadding:
// //             //         EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //             //   ),
// //             // ),
// //             // const SizedBox(height: 20),
// //             // DropdownButtonFormField<String>(
// //             //   value: selectedRtom,
// //             //   hint: const Text('Select RTOM'),
// //             //   items: rToms.map((String rtom) {
// //             //     return DropdownMenuItem<String>(
// //             //       value: rtom,
// //             //       child: Text(rtom),
// //             //     );
// //             //   }).toList(),
// //             //   onChanged: (value) {
// //             //     setState(() {
// //             //       selectedRtom = value;
// //             //       filterData();
// //             //     });
// //             //   },
// //             //   decoration: const InputDecoration(
// //             //     border: OutlineInputBorder(),
// //             //     contentPadding:
// //             //         EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //             //   ),
// //             // ),
// //
// //             // Summary table
// //             Container(
// //               padding: const EdgeInsets.all(16.0),
// //               decoration: BoxDecoration(
// //                 color: Colors.grey[200],
// //                 borderRadius: BorderRadius.circular(8),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.grey.withOpacity(0.5),
// //                     spreadRadius: 1,
// //                     blurRadius: 5,
// //                     offset: Offset(0, 3),
// //                   ),
// //                 ],
// //               ),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   const Text(
// //                     'Transformer Summary',
// //                     style: TextStyle(
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 10),
// //                   Table(
// //                     border: TableBorder.all(),
// //                     columnWidths: const {
// //                       0: FlexColumnWidth(1),
// //                       1: FlexColumnWidth(2),
// //                     },
// //                     children: [
// //                       const TableRow(
// //                         children: [
// //                           Padding(
// //                             padding: EdgeInsets.all(8.0),
// //                             child: Text('Type'),
// //                           ),
// //                           Padding(
// //                             padding: EdgeInsets.all(8.0),
// //                             child: Text('Count'),
// //                           ),
// //                         ],
// //                       ),
// //                       TableRow(
// //                         children: [
// //                           const Padding(
// //                             padding: EdgeInsets.all(8.0),
// //                             child: Text('Dry Type'),
// //                           ),
// //                           Padding(
// //                             padding: const EdgeInsets.all(8.0),
// //                             child: Text(dryTypeCount.toString()),
// //                           ),
// //                         ],
// //                       ),
// //                       TableRow(
// //                         children: [
// //                           const Padding(
// //                             padding: EdgeInsets.all(8.0),
// //                             child: Text('Oil Type'),
// //                           ),
// //                           Padding(
// //                             padding: const EdgeInsets.all(8.0),
// //                             child: Text(oilTypeCount.toString()),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //
// //             const SizedBox(height: 20),
// //             if (isLoading)
// //               const Center(child: CircularProgressIndicator())
// //             else if (filteredTransformerData.isEmpty)
// //               const Center(
// //                   child: Text('No data found',
// //                       style:
// //                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
// //             else
// //               ...filteredTransformerData.map((data) {
// //                 return Card(
// //                   child: ListTile(
// //                     title: Text(
// //                       'Station: ${data['Station']}',
// //                       style: const TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     subtitle: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Text('Region: ${data['Region']}'),
// //                         Text('RTOM: ${data['RTOM']}'),
// //                         Text('Transformer Type: ${data['TransformerType']}'),
// //                       ],
// //                     ),
// //                     onTap: () {
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                           builder: (context) =>
// //                               TransformerDetailScreen(transformerData: data),
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 );
// //               }).toList(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
