import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:theme_update/theme_provider.dart';
// import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/widgets/theme%20change%20related%20widjets/theme_provider.dart';
import 'package:theme_update/widgets/theme%20change%20related%20widjets/theme_toggle_button.dart';
import '../../utils/utils/colors.dart';
import '../../widgets/searchWidget.dart';
import 'ViewSPDUnit.dart';
import 'search_helper_spd.dart';

class ViewSPDDetails extends StatefulWidget {
  @override
  _ViewSPDDetailsState createState() => _ViewSPDDetailsState();
}

class _ViewSPDDetailsState extends State<ViewSPDDetails> {
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
  String searchQuery = '';
  List<dynamic> SPDSystems = []; // List to store SPD system data
  List<dynamic> filteredSPDSystems = [];
  bool isLoading = true; // Flag to track if data is being loaded
  int acCount = 0; // AC SPD count
  int dcCount = 0; // DC SPD count

  Future<void> fetchSPDSystems() async {
    final url =
        'https://powerprox.sltidc.lk/GetSPDdetails.php'; // Replace with your PHP script URL

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        SPDSystems = json.decode(response.body);
        filteredSPDSystems = SPDSystems;
        _calculateSummary(); // Calculate AC and DC counts
        isLoading = false; // Set isLoading to false once data is loaded
      });
    } else {
      print('Failed to fetch SPD systems');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _calculateSummary() {
    acCount =
        filteredSPDSystems.where((system) => system['DCFlag'] == '0').length;
    dcCount =
        filteredSPDSystems.where((system) => system['DCFlag'] == '1').length;
  }

  void applyFilters() {
    setState(() {
      // First filter by region
      var tempFiltered =
          selectedRegion == 'ALL'
              ? SPDSystems
              : SPDSystems.where(
                (system) => system['province'] == selectedRegion,
              ).toList();

      // Then filter by search query if it exists
      if (searchQuery.isNotEmpty) {
        tempFiltered =
            tempFiltered
                .where(
                  (system) =>
                      SearchHelperSPD.matchesSPDQuery(system, searchQuery),
                )
                .toList();
      }

      filteredSPDSystems = tempFiltered;
      _calculateSummary();
    });
  }

  void handleSearch(String query) {
    setState(() {
      searchQuery = query;
      applyFilters();
    });
  }

  void handleRegionChange(String? region) {
    if (region != null) {
      setState(() {
        selectedRegion = region;
        applyFilters();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSPDSystems();
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SPD Details'),
        iconTheme: IconThemeData(color: customColors.mainTextColor),
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],

        backgroundColor: customColors.appbarColor,
        foregroundColor: customColors.mainTextColor,
      ),
      backgroundColor: customColors.mainBackgroundColor,
      body: GestureDetector(
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
                    child:
                        SPDSystems.isNotEmpty
                            ? DropdownButtonFormField<String>(
                              value: selectedRegion,
                              decoration: InputDecoration(
                                labelText: 'Select Region',
                                labelStyle: TextStyle(
                                  color: customColors.subTextColor,
                                ),
                                filled: true,
                                fillColor: customColors.mainBackgroundColor,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: customColors.subTextColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: customColors.subTextColor,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: customColors.subTextColor,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              style: TextStyle(
                                color: customColors.mainTextColor,
                              ),
                              dropdownColor: customColors.suqarBackgroundColor,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: customColors.mainTextColor,
                              ),
                              onChanged: handleRegionChange,
                              items:
                                  [
                                    'ALL',
                                    ...SPDSystems.map(
                                          (system) =>
                                              (system['province'] ?? '')
                                                  .toString(),
                                        )
                                        .where(
                                          (region) => region.trim().isNotEmpty,
                                        )
                                        .toSet()
                                        .toList(),
                                  ].map((region) {
                                    return DropdownMenuItem<String>(
                                      value: region,
                                      child: Text(region),
                                    );
                                  }).toList(),
                            )
                            : SizedBox.shrink(),
                  ),
                  const SizedBox(width: 16),
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
            _buildSummaryTable(),
            Expanded(
              child:
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : filteredSPDSystems.isEmpty
                      ? Center(
                        child: Text(
                          searchQuery.isEmpty
                              ? 'No SPD units found'
                              : 'No results found for "$searchQuery"',
                          style: TextStyle(
                            color: customColors.mainTextColor,
                            fontSize: 16,
                          ),
                        ),
                      )
                      : ListView.builder(
                        itemCount: filteredSPDSystems.length,
                        itemBuilder: (context, index) {
                          final system = filteredSPDSystems[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ViewSPDUnit(
                                        SPDUnit: system,
                                        searchQuery: searchQuery,
                                      ),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 10,
                              ),
                              color: customColors.suqarBackgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              shadowColor: customColors.subTextColor,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Site: ${system['Rtom_name']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: customColors.subTextColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Location: ${system['station']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: customColors.subTextColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Type: ${system['DCFlag'] == '0' ? 'AC' : 'DC'}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: customColors.subTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryTable() {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Table(
        border: TableBorder.all(color: customColors.mainTextColor, width: 1.0),
        children: [
          TableRow(
            decoration: BoxDecoration(color: customColors.mainBackgroundColor),
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Summary',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: customColors.mainTextColor,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Count',
                  style: TextStyle(
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
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Total SPD Units',
                  style: TextStyle(color: customColors.subTextColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${filteredSPDSystems.length}',
                  style: TextStyle(color: customColors.subTextColor),
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'AC Units',
                  style: TextStyle(color: customColors.subTextColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$acCount',
                  style: TextStyle(color: customColors.subTextColor),
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'DC Units',
                  style: TextStyle(color: customColors.subTextColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$dcCount',
                  style: TextStyle(color: customColors.subTextColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//v1
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'ViewSPDUnit.dart';
//
// class ViewSPDDetails extends StatefulWidget {
//   @override
//   _ViewSPDDetailsState createState() => _ViewSPDDetailsState();
// }
//
// class _ViewSPDDetailsState extends State<ViewSPDDetails> {
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
//   List<dynamic> SPDSystems = []; // List to store SPD system data
//   bool isLoading = true; // Flag to track if data is being loaded
//
//   Future<void> fetchBatterySystems() async {
//     final url =
//         'https://powerprox.sltidc.lk/GetSPDdetails.php'; // Replace with the URL of your PHP script
//
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       setState(() {
//         SPDSystems = json.decode(response.body);
//         print(SPDSystems);
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
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('SPD Details'),
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
//               itemCount: SPDSystems.length,
//               itemBuilder: (context, index) {
//                 final system = SPDSystems[index];
//                 print(system['province']);
//                 if (selectedRegion == 'ALL' || system['province'] == selectedRegion) {
//                   return ListTile(
//                     title: Text('Site: ${system['Rtom_name']}'),
//                     subtitle: Text('Location: ${system['station']}'),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ViewSPDUnit(SPDUnit:  system),
//                         ),
//                       );
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
