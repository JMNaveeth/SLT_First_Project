import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/utils/utils/colors.dart';
// import 'package:url_launcher/url_launcher.dart';
import '../../theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:theme_update/utils/utils/colors.dart' as customColors;
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/searchWidget.dart';
import 'search_helper.dart';

// Model class for Precision AC
class PrecisionAC {
  final String precisionACId;
  final String region;
  final String rtom;
  final String station;
  final String location;
  final String officeNo; // New field
  final String qrTag;
  final String model;
  final String serialNumber;
  final String manufacturer;
  final String installationDate;
  final String status;
  final String updatedBy;
  final String updatedTime;
  final String coolingCapacity;
  final String powerSupply; // New field
  final String refrigerantType; // New field
  final String dimensions;
  final String weight;
  final String noiseLevel;
  final String noOfCompressors; // New field
  final String serialNumberOfCompressors; // New field
  final String conditionIndoorAirFilters; // New field
  final String conditionIndoorUnit; // New field
  final String conditionOutdoorUnit; // New field
  final String otherSpecifications; // New field
  final String airflow; // New field
  final String noOfRefrigerantCircuits; // New field
  final String noOfEvaporatorCoils; // New field
  final String noOfCondenserCircuits; // New field
  final String noOfCondenserFans; // New field
  final String condenserMountingMethod; // New field
  final String supplierName; // New field
  final String? supplierEmail; // Nullable field
  final String? supplierContactNo; // Nullable field
  final String? warrantyDetails; // Nullable field
  final String? warrantyExpireDate; // Nullable field
  final String? amcExpireDate; // Nullable field
  final String latitude; // New field
  final String longitude;
  final String searchQuery;

  final String airflow_type;

  var No_of_Indoor_Fans; // New field

  PrecisionAC({
    required this.precisionACId,
    required this.region,
    required this.rtom,
    required this.station,
    required this.location,
    required this.officeNo,
    required this.qrTag,
    required this.model,
    required this.serialNumber,
    required this.manufacturer,
    required this.installationDate,
    required this.status,
    required this.updatedBy,
    required this.updatedTime,
    required this.coolingCapacity,
    required this.powerSupply,
    required this.refrigerantType,
    required this.dimensions,
    required this.weight,
    required this.noiseLevel,
    required this.noOfCompressors,
    required this.serialNumberOfCompressors,
    required this.conditionIndoorAirFilters,
    required this.conditionIndoorUnit,
    required this.conditionOutdoorUnit,
    required this.otherSpecifications,
    required this.airflow,
    required this.noOfRefrigerantCircuits,
    required this.noOfEvaporatorCoils,
    required this.noOfCondenserCircuits,
    required this.noOfCondenserFans,
    required this.condenserMountingMethod,
    required this.supplierName,
    this.supplierEmail,
    this.supplierContactNo,
    this.warrantyDetails,
    this.warrantyExpireDate,
    this.amcExpireDate,
    this.searchQuery = '',
    required this.latitude,
    required this.longitude,
    required this.airflow_type,
    required this.No_of_Indoor_Fans,
  });

  factory PrecisionAC.fromJson(Map<String, dynamic> json) {
    return PrecisionAC(
      precisionACId: json['precisionAC_ID'] ?? '',
      region: json['Region'] ?? '',
      rtom: json['RTOM'] ?? '',
      station: json['Station'] ?? '',
      location: json['Location'] ?? '',
      officeNo: json['Office_No'] ?? '',
      // Added field
      qrTag: json['QRTag'] ?? '',
      model: json['Model'] ?? '',
      serialNumber: json['Serial_Number'] ?? '',
      manufacturer: json['Manufacturer'] ?? '',
      installationDate: json['Installation_Date'] ?? '',
      status: json['Status'] ?? '',
      updatedBy: json['UpdatedBy'] ?? '',
      updatedTime: json['UpdatedTime'] ?? '',
      coolingCapacity: json['Cooling_Capacity'] ?? '',
      powerSupply: json['Power_Supply'] ?? '',

      // Added field
      refrigerantType: json['Refrigerant_Type'] ?? '',
      // Added field
      dimensions: json['Dimensions'] ?? '',
      weight: json['Weight'] ?? '',
      noiseLevel: json['Noise_Level'] ?? '',
      noOfCompressors: json['No_of_Compressors'] ?? '',
      // Added field
      serialNumberOfCompressors: json['Serial_Number_of_the_Compressors'] ?? '',
      // Added field
      conditionIndoorAirFilters: json['Condition_Indoor_Air_Filters'] ?? '',
      // Added field
      conditionIndoorUnit: json['Condition_Indoor_Unit'] ?? '',
      // Added field
      conditionOutdoorUnit: json['Condition_Outdoor_Unit'] ?? '',
      // Added field
      otherSpecifications: json['Other_Specifications'] ?? '',
      // Added field
      airflow: json['Airflow'] ?? '',
      // Added field
      airflow_type: json['Airflow_Type'] ?? '',
      // Added field
      noOfRefrigerantCircuits: json['No_of_Refrigerant_Circuits'] ?? '',
      // Added field
      noOfEvaporatorCoils: json['No_of_Evaporator_Coils'] ?? '',
      // Added field
      noOfCondenserCircuits: json['No_of_Condenser_Circuits'] ?? '',
      // Added field
      noOfCondenserFans: json['No_of_Condenser_Fans'] ?? '',

      // Added field
      No_of_Indoor_Fans: json['No_of_Indoor_Fans'] ?? '',

      // Added field
      condenserMountingMethod: json['Condenser_Mounting_Method'] ?? '',
      // Added field
      supplierName: json['Supplier_Name'] ?? '',
      // Added field
      supplierEmail: json['Supplier_email'],
      // Nullable field
      supplierContactNo: json['Supplier_contact_no'],
      // Nullable field
      warrantyDetails: json['Warranty_Details'],
      // Nullable field
      warrantyExpireDate: json['Warranty_Expire_Date'],
      // Nullable field
      amcExpireDate: json['AMC_Expire_Date'],
      // Nullable field
      latitude: json['Latitude'] ?? '',
      // Added field
      longitude: json['Longitude'] ?? '', // Added field
    );
  }
}

// Fetch Precision AC data function
Future<List<PrecisionAC>> fetchPrecisionAC() async {
  final response = await http.get(
    Uri.parse('https://powerprox.sltidc.lk/GET_PrecisionAC.php'),
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    // Filter out entries with null or empty values
    return jsonResponse
        .map((data) => PrecisionAC.fromJson(data))
        .where((ac) => ac.model.isNotEmpty) // Adjust the field as necessary
        .toList();
  } else {
    throw Exception('Failed to load precision AC data');
  }
}

// Fetch regions function
Future<List<String>> fetchRegions() async {
  final response = await http.get(
    Uri.parse('https://powerprox.sltidc.lk/GETLocationRegion.php'),
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    // Filter out null or empty regions
    return List<String>.from(
      jsonResponse
          .map((data) => data['Region'])
          .where((region) => region != null && region.isNotEmpty),
    );
  } else {
    throw Exception('Failed to load regions');
  }
}

// Fetch RTOMs function based on selected Region ID
Future<List<String>> fetchRTOMs(String regionId) async {
  final response = await http.get(
    Uri.parse(
      'https://powerprox.sltidc.lk/GETLocationRTOM.php?regionId=$regionId',
    ),
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    // Filter out null or empty RTOMs
    return List<String>.from(
      jsonResponse
          .map((data) => data['RTOM'])
          .where((rtom) => rtom != null && rtom.isNotEmpty),
    );
  } else {
    throw Exception('Failed to load RTOMs');
  }
}

// Fetch stations function based on selected RTOM
Future<List<String>> fetchStations(String rtom) async {
  final response = await http.get(
    Uri.parse(
      'https://powerprox.sltidc.lk/GETLocationStationTable.php?rtom=$rtom',
    ),
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    // Filter out null or empty stations
    return List<String>.from(
      jsonResponse
          .map((data) => data['Station'])
          .where((station) => station != null && station.isNotEmpty),
    );
  } else {
    throw Exception('Failed to load stations');
  }
}

int totalUnits = 0;
int UpblowUnits = 0;
int DownBlowUnits = 0;
int stoppedUnits = 0;

// List view widget with filters
class PrecisionACList extends StatefulWidget {
  @override
  _PrecisionACListState createState() => _PrecisionACListState();
}

class _PrecisionACListState extends State<PrecisionACList> {
  late Future<List<PrecisionAC>> futurePrecisionAC;
  late Future<List<String>> futureRegions;
  late Future<List<String>> futureRTOMs;
  late Future<List<String>> futureStations;

  String? selectedStatus;
  String? selectedRegion;
  String? selectedRTOM;
  String? selectedStation;
  String searchQuery = '';

  List<String> statuses = ['All', 'Working', 'Running', 'Stopped', 'Faulty'];

  @override
  void initState() {
    super.initState();
    futurePrecisionAC = fetchPrecisionAC();
    futureRegions = fetchRegions();
    futureRTOMs = Future.value([]);
    futureStations = Future.value([]);
    fetchData();
  }

  void handleSearch(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  List<PrecisionAC> _filterACs(List<PrecisionAC> acs) {
    var tempFiltered =
        acs.where((ac) {
          final matchesStatus =
              selectedStatus == null ||
              selectedStatus == 'All' ||
              ac.status == selectedStatus;
          final matchesRegion =
              selectedRegion == null ||
              selectedRegion == 'All' ||
              ac.region == selectedRegion;
          final matchesRTOM =
              selectedRTOM == null ||
              selectedRTOM == 'All' ||
              ac.rtom == selectedRTOM;
          final matchesStation =
              selectedStation == null ||
              selectedStation == 'All' ||
              ac.station == selectedStation;

          return matchesStatus &&
              matchesRegion &&
              matchesRTOM &&
              matchesStation;
        }).toList();

    if (searchQuery.isNotEmpty) {
      tempFiltered =
          tempFiltered.where((ac) {
            return SearchHelperPrecisionAC.matchesPrecisionACQuery(
              ac,
              searchQuery,
            );
          }).toList();
    }

    return tempFiltered;
  }

  void _onRegionChanged(String? newValue) {
    setState(() {
      selectedRegion = newValue;
      selectedRTOM = null;
      selectedStation = null;
      futureRTOMs = newValue != null ? fetchRTOMs(newValue) : Future.value([]);
      futureStations = Future.value([]);
    });
  }

  void _onRTOMChanged(String? newValue) {
    setState(() {
      selectedRTOM = newValue;
      selectedStation = null;
      futureStations =
          newValue != null ? fetchStations(newValue) : Future.value([]);
    });
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('https://powerprox.sltidc.lk/GET_PrecisionAC.php'),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          totalUnits = data.length;
          UpblowUnits =
              data.where((unit) => unit['Airflow_Type'] == 'Upblow').length;
          DownBlowUnits =
              data.where((unit) => unit['Airflow_Type'] == 'DownBlow').length;
          stoppedUnits =
              data.where((unit) => unit['Status'] == 'Stopped').length;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Precision AC List',
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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side: Status (top) and Region (bottom)
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<List<String>>(
                          future: futureRegions,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text(
                                'Error: ${snapshot.error}',
                                style: TextStyle(
                                  color: customColors.subTextColor,
                                ),
                              );
                            } else {
                              return DropdownButton<String>(
                                hint: Text(
                                  'Select Region',
                                  style: TextStyle(
                                    color: customColors.subTextColor,
                                  ),
                                ),
                                value: selectedRegion,
                                isExpanded: true,
                                dropdownColor:
                                    customColors.suqarBackgroundColor,
                                onChanged: _onRegionChanged,
                                items:
                                    ['All', ...snapshot.data!].map((
                                      String region,
                                    ) {
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
                              );
                            }
                          },
                        ),
                        SizedBox(height: 12),
                        DropdownButton<String>(
                          hint: Text(
                            'Select Status',
                            style: TextStyle(color: customColors.subTextColor),
                          ),
                          value: selectedStatus,
                          isExpanded: true,
                          dropdownColor: customColors.suqarBackgroundColor,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedStatus = newValue;
                            });
                          },
                          items:
                              statuses.map((String status) {
                                return DropdownMenuItem<String>(
                                  value: status,
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      color: customColors.mainTextColor,
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  // Right side: Search bar
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        width: 300, // Adjust width as needed
                        child: SearchWidget(
                          onSearch: handleSearch,
                          hintText: 'Search...',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<PrecisionAC>>(
                  future: futurePrecisionAC,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(color: customColors.subTextColor),
                        ),
                      );
                    } else {
                      final precisionACs = snapshot.data!;
                      List<PrecisionAC> filteredACs = _filterACs(precisionACs);

                      // Count UpBlow and DownBlow units in the filtered list
                      int filteredUpblowUnits =
                          filteredACs
                              .where((ac) => ac.airflow_type == 'Upblow')
                              .length;
                      int filteredDownBlowUnits =
                          filteredACs
                              .where((ac) => ac.airflow_type == 'DownBlow')
                              .length;

                      return Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            child: GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio: 1.5,
                              children: [
                                _buildCard(
                                  'UpBlow Units',
                                  filteredUpblowUnits.toString(),
                                  const Color.fromARGB(255, 97, 176, 240),
                                ),
                                _buildCard(
                                  'DownBlow Units',
                                  filteredDownBlowUnits.toString(),
                                  const Color.fromARGB(255, 105, 228, 105),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredACs.length,
                              itemBuilder: (context, index) {
                                final ac = filteredACs[index];

                                return Card(
                                  color: customColors.suqarBackgroundColor,
                                  margin: EdgeInsets.all(10),
                                  child: ListTile(
                                    title: Text(
                                      ac.model,
                                      style: TextStyle(
                                        color: customColors.mainTextColor,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Status: ${ac.status}',
                                          style: TextStyle(
                                            color: customColors.subTextColor,
                                          ),
                                        ),
                                        Text(
                                          'Region: ${ac.region}',
                                          style: TextStyle(
                                            color: customColors.subTextColor,
                                          ),
                                        ),
                                        Text(
                                          'Installation Date: ${ac.installationDate}',
                                          style: TextStyle(
                                            color: customColors.subTextColor,
                                          ),
                                        ),
                                        Text(
                                          'Cooling Capacity: ${ac.coolingCapacity} BTU',
                                          style: TextStyle(
                                            color: customColors.subTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => ACDetailView(
                                                ac: ac,
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
                      );
                    }
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

class ACDetailView extends StatelessWidget {
  final PrecisionAC ac;
  final String searchQuery;

  ACDetailView({required this.ac, this.searchQuery = ''});

  InlineSpan getHighlightedText(
    String text,
    String searchQuery,
    Color textColor,
    Color highlightColor,
  ) {
    if (searchQuery.isEmpty || text.isEmpty) {
      return TextSpan(
        text: text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      );
    }
    final lowerText = text.toLowerCase();
    final lowerQuery = searchQuery.toLowerCase();
    final start = lowerText.indexOf(lowerQuery);
    if (start == -1) {
      return TextSpan(
        text: text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      );
    }
    final end = start + lowerQuery.length;
    return TextSpan(
      children: [
        if (start > 0)
          TextSpan(
            text: text.substring(0, start),
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
        TextSpan(
          text: text.substring(start, end),
          style: TextStyle(
            color: textColor,
            backgroundColor: highlightColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (end < text.length)
          TextSpan(
            text: text.substring(end),
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ac.model,
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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // General Info
              _buildCategoryHeader('General Info', context),
              _buildDetailTile(context, Icons.analytics, 'Model:', ac.model),
              _buildDetailTile(
                context,
                Icons.factory,
                'Manufacturer:',
                ac.manufacturer,
              ),
              _buildDetailTile(
                context,
                Icons.assignment,
                'Serial Code:',
                ac.serialNumber,
              ),
              _buildDetailTile(
                context,
                Icons.calendar_today,
                'Installation Date:',
                ac.installationDate,
              ),
              _buildDetailTile(context, Icons.label, 'QR Tag:', ac.qrTag),
              _buildDetailTile(
                context,
                Icons.location_on,
                'Region:',
                ac.region,
              ),
              _buildDetailTile(context, Icons.location_city, 'RTOM:', ac.rtom),
              _buildDetailTile(
                context,
                Icons.home_work,
                'Station:',
                ac.station,
              ),
              _buildDetailTile(
                context,
                Icons.home_work,
                'Office no:',
                ac.officeNo,
              ),
              _buildDetailTile(context, Icons.copyright, 'Status:', ac.status),

              _buildCategoryHeader('Indoor Info', context),
              _buildDetailTile(
                context,
                Icons.view_array,
                'Dimensions:',
                ac.dimensions,
              ),
              _buildDetailTile(
                context,
                Icons.fitness_center,
                'Weight:',
                ac.weight,
              ),
              _buildDetailTile(
                context,
                Icons.volume_up,
                'Noise Level:',
                ac.noiseLevel,
              ),
              _buildDetailTile(
                context,
                Icons.filter_alt,
                'Indoor Air Filters Condition:',
                ac.conditionIndoorAirFilters,
              ),
              _buildDetailTile(
                context,
                Icons.ac_unit,
                'No. of Evaporator Coils:',
                ac.noOfEvaporatorCoils,
              ),
              _buildDetailTile(
                context,
                Icons.ac_unit,
                'No. of Indoor Fans:',
                ac.No_of_Indoor_Fans,
              ),
              _buildDetailTile(
                context,
                Icons.ac_unit,
                'Condition. of Indoor Unit:',
                ac.conditionIndoorUnit,
              ),

              _buildCategoryHeader('Outdoor Info', context),
              _buildDetailTile(
                context,
                Icons.ac_unit,
                'No. of Condenser Circuits:',
                ac.noOfCondenserCircuits,
              ),
              _buildDetailTile(
                context,
                Icons.ac_unit,
                'No. of Condenser Fans:',
                ac.noOfCondenserFans,
              ),
              _buildDetailTile(
                context,
                Icons.home,
                'Condenser Mounting Method:',
                ac.condenserMountingMethod,
              ),
              _buildDetailTile(
                context,
                Icons.ac_unit,
                'Condition. of Outdoor Unit:',
                ac.conditionOutdoorUnit,
              ),

              // Compressor Info
              _buildCategoryHeader('Compressor Info', context),
              _buildDetailTile(
                context,
                Icons.compress,
                'No. of Compressors:',
                ac.noOfCompressors,
              ),
              _buildDetailTile2(
                context,
                Icons.copyright,
                'Compressor Serial code:',
                ac.serialNumberOfCompressors,
              ),

              // Specifications
              _buildCategoryHeader('Specifications', context),
              _buildDetailTile(
                context,
                Icons.ac_unit,
                'Cooling Capacity:',
                ac.coolingCapacity,
              ),
              _buildDetailTile(
                context,
                Icons.power,
                'Power Supply:',
                ac.powerSupply,
              ),
              _buildDetailTile(
                context,
                Icons.settings,
                'Refrigerant Type:',
                ac.refrigerantType,
              ),
              _buildDetailTile(
                context,
                Icons.replay,
                'No. of Refrigerant Circuits:',
                ac.noOfRefrigerantCircuits,
              ),
              _buildDetailTile(context, Icons.air, 'Airflow Rate:', ac.airflow),
              _buildDetailTile(
                context,
                Icons.air,
                'Airflow Type:',
                ac.airflow_type,
              ),
              _buildDetailTile(
                context,
                Icons.settings,
                'Other Specifications:',
                ac.otherSpecifications,
              ),

              // Location & Warranty Info
              _buildCategoryHeader('Location & Warranty Info', context),
              _buildDetailTile(context, Icons.map, 'Latitude:', ac.latitude),
              _buildDetailTile(context, Icons.map, 'Longitude:', ac.longitude),
              _buildDetailTile(context, Icons.map, 'Location:', ac.location),
              _buildDetailTile(
                context,
                Icons.access_alarm,
                'Warranty Details:',
                ac.warrantyDetails ?? 'N/A',
              ),
              _buildDetailTile(
                context,
                Icons.access_time,
                'Warranty Expire Date:',
                ac.warrantyExpireDate ?? 'N/A',
              ),
              _buildDetailTile(
                context,
                Icons.access_time,
                'Annual maintenance Contract availability:',
                ac.amcExpireDate ?? 'N/A',
              ),

              // Supplier Details
              _buildCategoryHeader('Supplier Details', context),
              _buildDetailTile(
                context,
                Icons.person,
                'Supplier Name:',
                ac.supplierName,
              ),
              _buildMailTile(
                Icons.email,
                'Supplier Email:',
                ac.supplierEmail ?? 'N/A',
                AutofillHints.email,
                context,
              ),
              _buildCallTile(
                Icons.phone,
                'Supplier Contact No:',
                ac.supplierContactNo ?? 'N/A',
                AutofillHints.telephoneNumber,
                context,
              ),

              // Update Info
              _buildCategoryHeader('Update Info', context),
              _buildDetailTile(
                context,
                Icons.person_add,
                'Updated By:',
                ac.updatedBy.isNotEmpty ? ac.updatedBy : 'N/A',
              ),
              _buildDetailTile(
                context,
                Icons.access_time,
                'Updated Time:',
                ac.updatedTime.isNotEmpty ? ac.updatedTime : 'N/A',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Add this inside your ACDetailView class:
  bool _shouldHighlight(String value) {
    // Example: highlight if the searchQuery is found in the title (case-insensitive)
    return searchQuery.isNotEmpty &&
        value.toLowerCase().contains(searchQuery.toLowerCase());
  }

  Widget _buildCategoryHeader(String title, BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: customColors.mainTextColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDetailTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      color: customColors.suqarBackgroundColor,
      child: ListTile(
        leading: Icon(icon, color: customColors.subTextColor),
        title: Text(
          title,
          style: TextStyle(
            color: customColors.mainTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text.rich(
          getHighlightedText(
            subtitle,
            searchQuery,
            customColors.subTextColor,
            customColors.highlightColor,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile2(
    BuildContext context,
    IconData icon,
    String title,
    String serialNumbers,
  ) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    List<String> serialList =
        serialNumbers.split(',').map((s) => s.trim()).toList();

    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      color: customColors.suqarBackgroundColor,
      child: ListTile(
        leading: Icon(icon, color: Colors.grey),
        title: Text(
          title,
          style: TextStyle(
            color: customColors.mainTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              serialList.asMap().entries.map((entry) {
                int index = entry.key;
                String value = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text.rich(
                    getHighlightedText(
                      'Compressor ${index + 1} Serial Code: $value',
                      searchQuery,
                      customColors.subTextColor,
                      customColors.highlightColor,
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  // Widget _buildDetailTile2(IconData icon, String title, String serialNumbers) {
  //   // Split the single string into a list of serial numbers
  //   List<String> serialList = serialNumbers.split(',').map((s) => s.trim()).toList();
  //
  //   // Create a formatted string for the subtitle
  //   String serialCodes = serialList.asMap().entries.map((entry) {
  //     int index = entry.key;
  //     String value = entry.value;
  //     return 'Compressor ${index + 1} Serial Code: $value';
  //   }).join('\n'); // Join with new line for better formatting
  //
  //   return Card(
  //     margin: EdgeInsets.symmetric(vertical: 5),
  //     elevation: 2,
  //     child: ListTile(
  //       leading: Icon(icon, color: Colors.blue),
  //       title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
  //       subtitle: Text(serialCodes), // Use the formatted serial codes
  //     ),
  //   );
  // }

  Widget _buildMailTile(
    IconData icon,
    String title,
    String subtitle,
    String emailAddress,
    BuildContext context,
  ) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    final bool isMatch =
        searchQuery.isNotEmpty &&
        subtitle.toLowerCase().contains(searchQuery.toLowerCase());

    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      color: customColors.suqarBackgroundColor,
      child: ListTile(
        leading: Icon(icon, color: Colors.grey),
        title: Text(
          title,
          style: TextStyle(
            color: customColors.mainTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.blue)),
        onTap: () async {
          final Uri emailUri = Uri(
            // scheme: 'mailto',
            path: subtitle, // Make sure this is the correct email
          );
          // if (await canLaunchUrl(emailUri)) {
          //   await launchUrl(
          //     emailUri,
          //     mode: LaunchMode.externalApplication, // Launch in external email app
          //   );
          // }
          // else {
          //   // If launching the email app fails, copy email to clipboard
          //   Clipboard.setData(ClipboardData(text: emailAddress));
          //
          //   // Show a slide-in Flushbar notification
          //   Flushbar(
          //     message: "The email address has been copied to your clipboard.",
          //     icon: Icon(
          //       Icons.email,
          //       size: 28.0,
          //       color: Colors.white,
          //     ),
          //     duration: Duration(seconds: 3),
          //     leftBarIndicatorColor: Colors.blue,
          //     backgroundColor: Colors.blueAccent, // Light blue background color
          //   ).show(context);
          // }
        },
      ),
    );
  }

  Widget _buildCallTile(
    IconData icon,
    String title,
    String subtitle,
    String phoneNumber,
    BuildContext context,
  ) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    final bool isMatch =
        searchQuery.isNotEmpty &&
        subtitle.toLowerCase().contains(searchQuery.toLowerCase());

    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      color: customColors.suqarBackgroundColor,
      child: ListTile(
        leading: Icon(icon, color: Colors.grey),
        title: Text(
          title,
          style: TextStyle(
            color: customColors.mainTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.blue)),
        onTap: () async {
          final Uri telUri = Uri(scheme: 'tel', path: subtitle);
          // if (await canLaunchUrl(telUri)) {
          //   await launchUrl(telUri);
          // }
          // else {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('Could not launch dialer')),
          //   );
          // }
        },
      ),
    );
  }
}

Widget _buildCard(String title, String value, Color color) {
  return Card(
    elevation: 4,
    // Add a shadow effect
    color: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Rounded corners
    ),
    margin: EdgeInsets.all(8.0),
    // Margin between cards
    child: ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      tileColor: color,
      // Set the background color of the ListTile
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Keep the rounded corners
      ),
      contentPadding: EdgeInsets.all(16.0), // Padding inside the ListTile
      // Optional: Add a leading icon
      // leading: Icon(Icons.info, color: Colors.white), // You can change the icon as needed
    ),
  );
}
