import 'package:theme_update/2nd%20sub%20folder/httpGetLocations.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';

import '../../../../../Widgets/LoadLocations/httpGetLocations.dart';
//import '../../../../UserAccess.dart';
import 'httpComfortACUpdatePost.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:provider/provider.dart';

import 'edit_comfort_ac.dart';

class ComfortAcUpdate extends StatefulWidget {
  const ComfortAcUpdate({super.key});

  @override
  _ComfortAcUpdateState createState() => _ComfortAcUpdateState();
}

class _ComfortAcUpdateState extends State<ComfortAcUpdate> {
  List<dynamic> indoorUnits = [];
  List<dynamic> outdoorUnits = [];
  List<dynamic> connections = [];
  bool isLoading = true;
  String userName = "";

  // Selection filters
  String? selectedRegion;
  //String? selectedRtom;
  String? selectedStation;
  // String? selectedBrand;

  // Filtered lists
  List<dynamic> filteredIndoorUnits = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final indoorResponse = await http.get(
        Uri.parse('https://powerprox.sltidc.lk/GET_AC_Indoor_Units.php'),
      );
      final outdoorResponse = await http.get(
        Uri.parse('https://powerprox.sltidc.lk/GET_AC_Outdoor_Units.php'),
      );
      final connectionsResponse = await http.get(
        Uri.parse('https://powerprox.sltidc.lk/GET_AC_Connection.php'),
      );

      if (indoorResponse.statusCode == 200) {
        indoorUnits = json.decode(indoorResponse.body);
      }
      if (outdoorResponse.statusCode == 200) {
        outdoorUnits = json.decode(outdoorResponse.body);
      }
      if (connectionsResponse.statusCode == 200) {
        connections = json.decode(connectionsResponse.body);
      }

      // Initialize filtered list
      applyFilters();
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void applyFilters() {
    filteredIndoorUnits =
        indoorUnits.where((unit) {
          final index = indoorUnits.indexOf(unit);
          final connection =
              connections.length > index ? connections[index] : {};

          return (selectedRegion == null ||
                  connection['region'] == selectedRegion) &&
              // (selectedRtom == null || connection['rtom'] == selectedRtom) &&
              (selectedStation == null ||
                  connection['station'] == selectedStation);
          // (selectedBrand == null || unit['brand'] == selectedBrand);
        }).toList();
  }

  // Get unique values for dropdowns
  List<String> getUniqueRegions() {
    return connections
        .map((c) => c['region']?.toString() ?? '')
        .where((r) => r.isNotEmpty)
        .toSet()
        .toList();
  }

  // List<String> getUniqueRtoms() {
  //   return connections.map((c) => c['rtom']?.toString() ?? '').where((r) => r.isNotEmpty).toSet().toList();
  // }

  List<String> getUniqueStations() {
    return connections
        .map((c) => c['station']?.toString() ?? '')
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList();
  }

  // List<String> getUniqueBrands() {
  //   return indoorUnits.map((u) => u['brand']?.toString() ?? '').where((b) => b.isNotEmpty).toSet().toList();
  // }

  Widget buildDropdownRow(CustomColors customColors) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: customColors.mainBackgroundColor,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Region',
                    labelStyle: TextStyle(color: customColors.mainTextColor),
                    border: OutlineInputBorder(),
                  ),
                  dropdownColor: customColors.suqarBackgroundColor,
                  value: selectedRegion,
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(
                        'All Regions',
                        style: TextStyle(color: customColors.mainTextColor),
                      ),
                    ),
                    ...getUniqueRegions().map(
                      (region) => DropdownMenuItem(
                        value: region,
                        child: Text(
                          region,
                          style: TextStyle(color: customColors.mainTextColor),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedRegion = value;
                      applyFilters();
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              // Expanded(
              //   child: DropdownButtonFormField<String>(
              //     decoration: InputDecoration(
              //       labelText: 'RTOM',
              //       labelStyle: TextStyle(color: customColors.mainTextColor),
              //       border: OutlineInputBorder(),
              //     ),
              //     dropdownColor: customColors.suqarBackgroundColor,
              //     value: selectedRtom,
              //     items: [
              //       DropdownMenuItem(value: null, child: Text('All RTOMs', style: TextStyle(color: customColors.mainTextColor))),
              //       ...getUniqueRtoms().map((rtom) => DropdownMenuItem(
              //         value: rtom,
              //         child: Text(rtom, style: TextStyle(color: customColors.mainTextColor)),
              //       )),
              //     ],
              //     onChanged: (value) {
              //       setState(() {
              //         selectedRtom = value;
              //         applyFilters();
              //       });
              //     },
              //   ),
              // ),
            ],
          ),

          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Station',
                labelStyle: TextStyle(color: customColors.mainTextColor),
                border: OutlineInputBorder(),
              ),
              dropdownColor: customColors.suqarBackgroundColor,
              value: selectedStation,
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(
                    'All Stations',
                    style: TextStyle(color: customColors.mainTextColor),
                  ),
                ),
                ...getUniqueStations().map(
                  (station) => DropdownMenuItem(
                    value: station,
                    child: Text(
                      station,
                      style: TextStyle(color: customColors.mainTextColor),
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedStation = value;
                  applyFilters();
                });
              },
            ),
          ),
          const SizedBox(width: 8),

          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Station',
                labelStyle: TextStyle(color: customColors.mainTextColor),
                border: OutlineInputBorder(),
              ),
              dropdownColor: customColors.suqarBackgroundColor,
              value: selectedStation,
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(
                    'All Stations',
                    style: TextStyle(color: customColors.mainTextColor),
                  ),
                ),
                ...getUniqueStations().map(
                  (station) => DropdownMenuItem(
                    value: station,
                    child: Text(
                      station,
                      style: TextStyle(color: customColors.mainTextColor),
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedStation = value;
                  applyFilters();
                });
              },
            ),
          ),
          // Expanded(
          //   child: DropdownButtonFormField<String>(
          //     decoration: InputDecoration(
          //       labelText: 'Brand',
          //       labelStyle: TextStyle(color: customColors.mainTextColor),
          //       border: OutlineInputBorder(),
          //     ),
          //     dropdownColor: customColors.suqarBackgroundColor,
          //     value: selectedBrand,
          //     items: [
          //       DropdownMenuItem(value: null, child: Text('All Brands', style: TextStyle(color: customColors.mainTextColor))),
          //       ...getUniqueBrands().map((brand) => DropdownMenuItem(
          //         value: brand,
          //         child: Text(brand, style: TextStyle(color: customColors.mainTextColor)),
          //       )),
          //     ],
          //     onChanged: (value) {
          //       setState(() {
          //         selectedBrand = value;
          //         applyFilters();
          //       });
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // UserAccess userAccess = Provider.of<UserAccess>(context, listen: true); // Use listen: true to rebuild the widget when the data changes
    // userName=userAccess.username!;
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return ChangeNotifierProvider(
      create: (context) => LocationProvider()..loadAllData(),
      child: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'AC Comfort Units',
                style: TextStyle(color: customColors.mainTextColor),
              ),
              iconTheme: IconThemeData(color: customColors.mainTextColor),
              backgroundColor: customColors.appbarColor,
              actions: [ThemeToggleButton()],
            ),
            body: Container(
              color: customColors.mainBackgroundColor,
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                        children: [
                          buildDropdownRow(customColors),
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredIndoorUnits.length,
                              itemBuilder: (context, index) {
                                final unit = filteredIndoorUnits[index];
                                final originalIndex = indoorUnits.indexOf(unit);
                                final ConnectionUnits =
                                    connections.length > originalIndex
                                        ? connections[originalIndex]
                                        : {};

                                if (unit == null) {
                                  return Container();
                                }
                                return Card(
                                  color: customColors.suqarBackgroundColor,

                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 16.0,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      'Brand : ${unit['brand'] ?? 'No Brand'}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: customColors.mainTextColor,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Model : ${unit['model'] ?? 'No model'}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: customColors.mainTextColor,
                                          ),
                                        ),

                                        Text(
                                          'Rtom: ${ConnectionUnits['rtom'] ?? 'No rtom'}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: customColors.mainTextColor,
                                          ),
                                        ),
                                        Text(
                                          'Location: ${ConnectionUnits['region'] ?? 'No region'}'
                                          '| ${ConnectionUnits['rtom'] ?? 'No RTOM'}'
                                          '| ${ConnectionUnits['station'] ?? 'No station'}'
                                          '| ${ConnectionUnits['office_number'] ?? 'No office_number'}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: customColors.mainTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => EditComfortAcPage(
                                                indoorData: unit,
                                                outdoorUnitData:
                                                    outdoorUnits.length > index
                                                        ? outdoorUnits[index]
                                                        : {},
                                                connectionData:
                                                    connections.length > index
                                                        ? connections[index]
                                                        : {},
                                                user: userName,
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
          );
        },
      ),
    );
  }
}
