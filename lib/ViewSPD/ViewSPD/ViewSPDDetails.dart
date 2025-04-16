import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
    'UVA'
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
    acCount = SPDSystems.where((system) => system['DCFlag'] == '0').length;
    dcCount = SPDSystems.where((system) => system['DCFlag'] == '1').length;
  }

  void applyFilters() {
    setState(() {
      // First filter by region
      var tempFiltered = selectedRegion == 'ALL'
          ? SPDSystems
          : SPDSystems.where((system) => system['province'] == selectedRegion)
              .toList();

      // Then filter by search query if it exists
      if (searchQuery.isNotEmpty) {
        tempFiltered = tempFiltered
            .where((system) =>
                SearchHelperSPD.matchesSPDQuery(system, searchQuery))
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('SPD Details'),
        iconTheme: IconThemeData(
          color: mainTextColor,
        ),
        backgroundColor: appbarColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: mainBackgroundColor,
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
                    child: DropdownButtonFormField<String>(
                      value: selectedRegion,
                      decoration: const InputDecoration(
                        labelText: 'Select Region',
                        labelStyle: TextStyle(color: subTextColor),
                        filled: true,
                        fillColor: mainBackgroundColor,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 2.0),
                        ),
                      ),
                      style: const TextStyle(
                        color: mainTextColor,
                      ),
                      dropdownColor: suqarBackgroundColor,
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.white),
                      onChanged: handleRegionChange,
                      items: regions.map((region) {
                        return DropdownMenuItem<String>(
                          value: region,
                          child: Text(region),
                        );
                      }).toList(),
                    ),
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
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : filteredSPDSystems.isEmpty
                      ? Center(
                          child: Text(
                            searchQuery.isEmpty
                                ? 'No SPD units found'
                                : 'No results found for "$searchQuery"',
                            style: const TextStyle(
                              color: Colors.white,
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
                                    builder: (context) => ViewSPDUnit(
                                      SPDUnit: system,
                                      searchQuery: searchQuery,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 5,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 10,
                                ),
                                color: suqarBackgroundColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                shadowColor: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Site: ${system['Rtom_name']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: subTextColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Location: ${system['station']}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: subTextColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Type: ${system['DCFlag'] == '0' ? 'AC' : 'DC'}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: subTextColor,
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Table(
        border: TableBorder.all(
          color: Colors.white,
          width: 1.0,
        ),
        children: [
          const TableRow(
            decoration: BoxDecoration(
              color: mainBackgroundColor,
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Summary',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: mainTextColor,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Count',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: mainTextColor,
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Total SPD Units',
                  style: TextStyle(
                    color: subTextColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${filteredSPDSystems.length}',
                  style: const TextStyle(
                    color: subTextColor,
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'AC Units',
                  style: TextStyle(
                    color: subTextColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$acCount',
                  style: const TextStyle(
                    color: subTextColor,
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'DC Units',
                  style: TextStyle(
                    color: subTextColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$dcCount',
                  style: const TextStyle(
                    color: subTextColor,
                  ),
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
