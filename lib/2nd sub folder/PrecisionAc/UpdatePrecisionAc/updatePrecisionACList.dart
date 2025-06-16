import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';
import 'package:url_launcher/url_launcher.dart';
//import '../../ACMaintenancePage.dart';

// Model class for Precision AC
class updatePrecisionAC {
  final String precisionACId;
  final String region;
  final String rtom;
  final String station;
  final String location;
  final String officeNo; // New field
  final String buildingID;
  final String floorNumber;
  final String qrTag;
  final String model;
  final String serialNumber;
  final String manufacturer;
  final String installationDate;
  final String status;

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

  final String airflow_type;

  var No_of_Indoor_Fans; // New field
  final String updatedBy;
  final String updatedTime;

  updatePrecisionAC({
    required this.precisionACId,
    required this.region,
    required this.rtom,
    required this.station,
    required this.location,
    required this.officeNo,
    required this.buildingID,
    required this.floorNumber,
    required this.qrTag,
    required this.model,
    required this.serialNumber,
    required this.manufacturer,
    required this.installationDate,
    required this.status,

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
    required this.latitude,
    required this.longitude,
    required this.airflow_type,
    required this.No_of_Indoor_Fans,

    required this.updatedBy,
    required this.updatedTime,
  });

  factory updatePrecisionAC.fromJson(Map<String, dynamic> json) {
    return updatePrecisionAC(
      precisionACId: json['precisionAC_ID'] ?? '',
      region: json['Region'] ?? '',
      rtom: json['RTOM'] ?? '',
      station: json['Station'] ?? '',
      location: json['Location'] ?? '',
      officeNo: json['Office_No'] ?? '', // Added field
      buildingID: json['building_id'] ?? '', // Added field new
      floorNumber: json['floor_number'] ?? '', // Added field new
      qrTag: json['QRTag'] ?? '',
      model: json['Model'] ?? '',
      serialNumber: json['Serial_Number'] ?? '',
      manufacturer: json['Manufacturer'] ?? '',
      installationDate: json['Installation_Date'] ?? '',
      status: json['Status'] ?? '',

      coolingCapacity: json['Cooling_Capacity'] ?? '',
      powerSupply: json['Power_Supply'] ?? '', // Added field
      refrigerantType: json['Refrigerant_Type'] ?? '', // Added field
      dimensions: json['Dimensions'] ?? '',
      weight: json['Weight'] ?? '',
      noiseLevel: json['Noise_Level'] ?? '',
      noOfCompressors: json['No_of_Compressors'] ?? '', // Added field
      serialNumberOfCompressors:
          json['Serial_Number_of_the_Compressors'] ?? '', // Added field
      conditionIndoorAirFilters:
          json['Condition_Indoor_Air_Filters'] ?? '', // Added field
      conditionIndoorUnit: json['Condition_Indoor_Unit'] ?? '', // Added field
      conditionOutdoorUnit: json['Condition_Outdoor_Unit'] ?? '', // Added field
      otherSpecifications: json['Other_Specifications'] ?? '', // Added field
      airflow: json['Airflow'] ?? '', // Added field
      airflow_type: json['Airflow_Type'] ?? '', // Added field
      noOfRefrigerantCircuits:
          json['No_of_Refrigerant_Circuits'] ?? '', // Added field
      noOfEvaporatorCoils: json['No_of_Evaporator_Coils'] ?? '', // Added field
      noOfCondenserCircuits:
          json['No_of_Condenser_Circuits'] ?? '', // Added field
      noOfCondenserFans: json['No_of_Condenser_Fans'] ?? '', // Added field

      No_of_Indoor_Fans: json['No_of_Indoor_Fans'] ?? '', // Added field

      condenserMountingMethod:
          json['Condenser_Mounting_Method'] ?? '', // Added field
      supplierName: json['Supplier_Name'] ?? '', // Added field
      supplierEmail: json['Supplier_email'], // Nullable field
      supplierContactNo: json['Supplier_contact_no'], // Nullable field
      warrantyDetails: json['Warranty_Details'], // Nullable field
      warrantyExpireDate: json['Warranty_Expire_Date'], // Nullable field
      amcExpireDate: json['AMC_Expire_Date'], // Nullable field
      latitude: json['Latitude'] ?? '', // Added field
      longitude: json['Longitude'] ?? '', // Added field
      updatedBy: json['UpdatedBy'] ?? '',
      updatedTime: json['UpdatedTime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "precisionAC_ID": precisionACId,
      "Region": region,
      "RTOM": rtom,
      "Station": station,
      "Location": location,
      "Office_No": officeNo,
      "building_id": buildingID, // Added field new
      "floor_number": floorNumber, // Added field new
      "QRTag": qrTag,
      "Model": model,
      "Serial_Number": serialNumber,
      "Manufacturer": manufacturer,
      "Installation_Date": installationDate,
      "Status": status,
    };
  }
}

// Fetch Precision AC data function
Future<List<updatePrecisionAC>> fetchPrecisionAC() async {
  final response = await http.get(
    Uri.parse('https://powerprox.sltidc.lk/GET_PrecisionAC.php'),
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    // Filter out entries with null or empty values
    return jsonResponse
        .map((data) => updatePrecisionAC.fromJson(data))
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
class updatePrecisionACList extends StatefulWidget {
  @override
  _PrecisionACListState createState() => _PrecisionACListState();
}

class _PrecisionACListState extends State<updatePrecisionACList> {
  late Future<List<updatePrecisionAC>> futurePrecisionAC;
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
    // Initialize RTOMs and Stations as empty
    futureRTOMs = Future.value([]);
    futureStations = Future.value([]);
    fetchData();
  }



  // void handleSearch(String query) {
  //   setState(() {
  //     searchQuery = query;
  //   });
  // }

  // List<updatePrecisionAC> _filterACs(List<updatePrecisionAC> acs) {
  //   var tempFiltered =
  //       acs.where((ac) {
  //         final matchesStatus =
  //             selectedStatus == null ||
  //             selectedStatus == 'All' ||
  //             ac.status == selectedStatus;
  //         final matchesRegion =
  //             selectedRegion == null ||
  //             selectedRegion == 'All' ||
  //             ac.region == selectedRegion;
  //         final matchesRTOM =
  //             selectedRTOM == null ||
  //             selectedRTOM == 'All' ||
  //             ac.rtom == selectedRTOM;
  //         final matchesStation =
  //             selectedStation == null ||
  //             selectedStation == 'All' ||
  //             ac.station == selectedStation;

  //         return matchesStatus &&
  //             matchesRegion &&
  //             matchesRTOM &&
  //             matchesStation;
  //       }).toList();
  //   return tempFiltered;
  // }


  // Method to handle region change
  void _onRegionChanged(String? newValue) {
    setState(() {
      selectedRegion = newValue;
      selectedRTOM = null; // Reset RTOM
      selectedStation = null; // Reset Station
      futureRTOMs = newValue != null ? fetchRTOMs(newValue) : Future.value([]);
      futureStations = Future.value([]); // Reset stations
    });
  }

  // Method to handle RTOM change
  void _onRTOMChanged(String? newValue) {
    setState(() {
      selectedRTOM = newValue;
      selectedStation = null; // Reset Station
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
      // Handle error (e.g., show a snackbar or dialog)
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
        actions: [ThemeToggleButton()],
      ),
      body: Container(
        color: customColors.mainBackgroundColor,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Filter dropdowns in two columns
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      hint: Text('Select Status'),
                      style: TextStyle(color: customColors.mainTextColor),
                      dropdownColor: customColors.suqarBackgroundColor,

                      value: selectedStatus,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedStatus = newValue;
                        });
                      },
                      items:
                          statuses.map((String status) {
                            return DropdownMenuItem<String>(
                              value: status,
                              child: Text(status),
                            );
                          }).toList(),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: FutureBuilder<List<String>>(
                      future: futureRegions,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return DropdownButton<String>(
                            hint: Text(
                              'Select Region',
                              style: TextStyle(
                                color: customColors.mainTextColor,
                              ),
                            ),
                            style: TextStyle(color: customColors.mainTextColor),
                            dropdownColor: customColors.suqarBackgroundColor,

                            value: selectedRegion,
                            isExpanded: true,
                            onChanged: _onRegionChanged, // Use new method
                            items:
                                ['All', ...snapshot.data!].map((String region) {
                                  return DropdownMenuItem<String>(
                                    value: region,
                                    child: Text(region),
                                  );
                                }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),

              // Display cards in a responsive-height container just below the filters
              Container(
                height:
                    MediaQuery.of(context).size.height *
                    0.15, // Increased height to accommodate all cards
                child: GridView.count(
                  crossAxisCount: 2, // Two columns
                  childAspectRatio:
                      1.5, // Maintain aspect ratio for better visibility
                  children: [
                    // _buildCard('Total AC Units', totalUnits.toString(), Colors.lightBlue[200]!),
                    _buildCard(
                      'UpBlow Units',
                      UpblowUnits.toString(),
                      Colors.lightBlue[200]!,
                    ),
                    _buildCard(
                      'DownBlow Units',
                      DownBlowUnits.toString(),
                      Colors.lightGreen[200]!,
                    ),
                    // _buildCard('Stopped Units', stoppedUnits.toString(), Colors.red[200]!),
                  ],
                ),
              ),

              // Spacing between rows
              Expanded(
                child: FutureBuilder<List<updatePrecisionAC>>(
                  future: futurePrecisionAC,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final precisionACs = snapshot.data!;
                      List<updatePrecisionAC> filteredACs =
                          precisionACs.where((ac) {
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

                      return ListView.builder(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Status: ${ac.status}',
                                    style: TextStyle(
                                      color: customColors.mainTextColor,
                                    ),
                                  ),
                                  Text(
                                    'Region: ${ac.region}',
                                    style: TextStyle(
                                      color: customColors.mainTextColor,
                                    ),
                                  ),
                                  Text(
                                    'Installation Date: ${ac.installationDate}',
                                    style: TextStyle(
                                      color: customColors.mainTextColor,
                                    ),
                                  ),
                                  Text(
                                    'Cooling Capacity: ${ac.coolingCapacity} BTU',
                                    style: TextStyle(
                                      color: customColors.mainTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                // Navigate to the detailed view
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ACDetailView(ac: ac),
                                  ),
                                );
                              },
                            ),
                          );
                        },
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

// class ACDetailView extends StatelessWidget {
//   final updatePrecisionAC ac;

//   ACDetailView({required this.ac});

class ACDetailView extends StatefulWidget {
  final updatePrecisionAC ac;

  ACDetailView({required this.ac});

  @override
  _ACDetailViewState createState() => _ACDetailViewState();
}

class _ACDetailViewState extends State<ACDetailView> {
  late TextEditingController _modelController;
  late TextEditingController _manufacturerController;
  late TextEditingController _serialNumberController;
  late TextEditingController _installationDateController;
  late TextEditingController _qrTagController;
  late TextEditingController _regionController;
  late TextEditingController _rtomController;
  late TextEditingController _stationController;
  late TextEditingController _officeNoController;
  late TextEditingController _floorNumberController;
  late TextEditingController _buildingIDController;

  late TextEditingController _statusController;

  late TextEditingController _dimensionsController;
  late TextEditingController _weightController;
  late TextEditingController _noiseLevelController;
  late TextEditingController _conditionIndoorAirFiltersController;
  late TextEditingController _noOfEvaporatorCoilsController;
  late TextEditingController _noOfIndoorFansController;
  late TextEditingController _conditionIndoorUnitController;

  late TextEditingController _noOfCondenserCircuitsController;
  late TextEditingController _noOfCondenserFansController;
  late TextEditingController _condenserMountingMethodController;
  late TextEditingController _conditionOutdoorUnitController;

  late TextEditingController _noOfCompressorsController;
  late TextEditingController _serialNumberOfCompressorsController;

  late TextEditingController _coolingCapacityController;
  late TextEditingController _powerSupplyController;
  late TextEditingController _refrigerantTypeController;
  late TextEditingController _noOfRefrigerantCircuitsController;
  late TextEditingController _airflowController;
  late TextEditingController _airflowTypeController;
  late TextEditingController _otherSpecificationsController;

  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  late TextEditingController _locationController;
  late TextEditingController _warrantyDetailsController;
  late TextEditingController _warrantyExpireDateController;
  late TextEditingController _amcExpireDateController;

  late TextEditingController _supplierNameController;
  late TextEditingController _supplierEmailController;
  late TextEditingController _supplierContactNoController;

  // late TextEditingController _updatedByController;
  // late TextEditingController _updatedTimeController;

  @override
  void initState() {
    super.initState();

    // Debug: Print initial data passed to the widget
    print("Initial daaaata: ${widget.ac.toJson()}");

    _modelController = TextEditingController(text: widget.ac.model);
    _manufacturerController = TextEditingController(
      text: widget.ac.manufacturer,
    );
    _serialNumberController = TextEditingController(
      text: widget.ac.serialNumber,
    );
    _installationDateController = TextEditingController(
      text: widget.ac.installationDate,
    );
    _qrTagController = TextEditingController(text: widget.ac.qrTag);
    _regionController = TextEditingController(text: widget.ac.region);
    _rtomController = TextEditingController(text: widget.ac.rtom);

    _stationController = TextEditingController(text: widget.ac.station);
    _officeNoController = TextEditingController(text: widget.ac.officeNo);
    _floorNumberController = TextEditingController(text: widget.ac.floorNumber);
    _buildingIDController = TextEditingController(text: widget.ac.buildingID);
    _statusController = TextEditingController(text: widget.ac.status);

    _dimensionsController = TextEditingController(text: widget.ac.dimensions);
    _weightController = TextEditingController(text: widget.ac.weight);
    _noiseLevelController = TextEditingController(text: widget.ac.noiseLevel);
    _conditionIndoorAirFiltersController = TextEditingController(
      text: widget.ac.conditionIndoorAirFilters,
    );
    _noOfEvaporatorCoilsController = TextEditingController(
      text: widget.ac.noOfEvaporatorCoils,
    );
    _noOfIndoorFansController = TextEditingController(
      text: widget.ac.No_of_Indoor_Fans,
    );
    _conditionIndoorUnitController = TextEditingController(
      text: widget.ac.conditionIndoorUnit,
    );

    _noOfCondenserCircuitsController = TextEditingController(
      text: widget.ac.noOfCondenserCircuits,
    );
    _noOfCondenserFansController = TextEditingController(
      text: widget.ac.noOfCondenserFans,
    );
    _condenserMountingMethodController = TextEditingController(
      text: widget.ac.condenserMountingMethod,
    );
    _conditionOutdoorUnitController = TextEditingController(
      text: widget.ac.conditionOutdoorUnit,
    );

    _noOfCompressorsController = TextEditingController(
      text: widget.ac.noOfCompressors,
    );
    _serialNumberOfCompressorsController = TextEditingController(
      text: widget.ac.serialNumberOfCompressors,
    );

    _coolingCapacityController = TextEditingController(
      text: widget.ac.coolingCapacity,
    );
    _powerSupplyController = TextEditingController(text: widget.ac.powerSupply);
    _refrigerantTypeController = TextEditingController(
      text: widget.ac.refrigerantType,
    );
    _noOfRefrigerantCircuitsController = TextEditingController(
      text: widget.ac.noOfRefrigerantCircuits,
    );
    _airflowController = TextEditingController(text: widget.ac.airflow);
    _airflowTypeController = TextEditingController(
      text: widget.ac.airflow_type,
    );
    _otherSpecificationsController = TextEditingController(
      text: widget.ac.otherSpecifications,
    );

    _latitudeController = TextEditingController(text: widget.ac.latitude);
    _longitudeController = TextEditingController(text: widget.ac.longitude);
    _locationController = TextEditingController(text: widget.ac.location);
    _warrantyDetailsController = TextEditingController(
      text: widget.ac.warrantyDetails ?? 'N/A',
    );
    _warrantyExpireDateController = TextEditingController(
      text: widget.ac.warrantyExpireDate ?? 'N/A',
    );
    _amcExpireDateController = TextEditingController(
      text: widget.ac.amcExpireDate ?? 'N/A',
    );

    _supplierNameController = TextEditingController(
      text: widget.ac.supplierName,
    );
    _supplierEmailController = TextEditingController(
      text: widget.ac.supplierEmail ?? 'N/A',
    );
    _supplierContactNoController = TextEditingController(
      text: widget.ac.supplierContactNo ?? 'N/A',
    );

    // _updatedByController = TextEditingController(
    //     text: widget.ac.updatedBy.isNotEmpty ? widget.ac.updatedBy : 'N/A');
    // _updatedTimeController = TextEditingController(
    //     text: widget.ac.updatedTime.isNotEmpty ? widget.ac.updatedTime : 'N/A');
  }

  @override
  void dispose() {
    _modelController.dispose();
    _manufacturerController.dispose();
    _serialNumberController.dispose();
    _installationDateController.dispose();
    _qrTagController.dispose();
    _regionController.dispose();
    _rtomController.dispose();
    _stationController.dispose();
    _officeNoController.dispose();
    _floorNumberController.dispose();
    _buildingIDController.dispose();
    _statusController.dispose();

    _dimensionsController.dispose();
    _weightController.dispose();
    _noiseLevelController.dispose();
    _conditionIndoorAirFiltersController.dispose();
    _noOfEvaporatorCoilsController.dispose();
    _noOfIndoorFansController.dispose();
    _conditionIndoorUnitController.dispose();

    _noOfCondenserCircuitsController.dispose();
    _noOfCondenserFansController.dispose();
    _condenserMountingMethodController.dispose();
    _conditionOutdoorUnitController.dispose();

    _noOfCompressorsController.dispose();
    _serialNumberOfCompressorsController.dispose();

    _coolingCapacityController.dispose();
    _powerSupplyController.dispose();
    _refrigerantTypeController.dispose();
    _noOfRefrigerantCircuitsController.dispose();
    _airflowController.dispose();
    _airflowTypeController.dispose();
    _otherSpecificationsController.dispose();

    _latitudeController.dispose();
    _longitudeController.dispose();
    _locationController.dispose();
    _warrantyDetailsController.dispose();
    _warrantyExpireDateController.dispose();
    _amcExpireDateController.dispose();

    _supplierNameController.dispose();
    _supplierEmailController.dispose();
    _supplierContactNoController.dispose();
    super.dispose();
    // _updatedByController.dispose();
    // _updatedTimeController.dispose();
  }

  bool _hasChanges() {
    return _modelController.text != widget.ac.model ||
        _manufacturerController.text != widget.ac.manufacturer ||
        _serialNumberController.text != widget.ac.serialNumber ||
        _installationDateController.text != widget.ac.installationDate ||
        _qrTagController.text != widget.ac.qrTag ||
        _regionController.text != widget.ac.region ||
        _rtomController.text != widget.ac.rtom ||
        _stationController.text != widget.ac.station ||
        _officeNoController.text != widget.ac.officeNo ||
        _floorNumberController.text != widget.ac.floorNumber ||
        _buildingIDController.text != widget.ac.buildingID ||
        _statusController.text != widget.ac.status ||
        // Additional fields
        _dimensionsController.text != widget.ac.dimensions ||
        _weightController.text != widget.ac.weight ||
        _noiseLevelController.text != widget.ac.noiseLevel ||
        _conditionIndoorAirFiltersController.text !=
            widget.ac.conditionIndoorAirFilters ||
        _noOfEvaporatorCoilsController.text != widget.ac.noOfEvaporatorCoils ||
        _noOfIndoorFansController.text != widget.ac.No_of_Indoor_Fans ||
        _conditionIndoorUnitController.text != widget.ac.conditionIndoorUnit ||
        _noOfCondenserCircuitsController.text !=
            widget.ac.noOfCondenserCircuits ||
        _noOfCondenserFansController.text != widget.ac.noOfCondenserFans ||
        _condenserMountingMethodController.text !=
            widget.ac.condenserMountingMethod ||
        _conditionOutdoorUnitController.text !=
            widget.ac.conditionOutdoorUnit ||
        _noOfCompressorsController.text != widget.ac.noOfCompressors ||
        _serialNumberOfCompressorsController.text !=
            widget.ac.serialNumberOfCompressors ||
        _coolingCapacityController.text != widget.ac.coolingCapacity ||
        _powerSupplyController.text != widget.ac.powerSupply ||
        _refrigerantTypeController.text != widget.ac.refrigerantType ||
        _noOfRefrigerantCircuitsController.text !=
            widget.ac.noOfRefrigerantCircuits ||
        _airflowController.text != widget.ac.airflow ||
        _airflowTypeController.text != widget.ac.airflow_type ||
        _otherSpecificationsController.text != widget.ac.otherSpecifications ||
        _latitudeController.text != widget.ac.latitude ||
        _longitudeController.text != widget.ac.longitude ||
        _locationController.text != widget.ac.location ||
        _warrantyDetailsController.text !=
            (widget.ac.warrantyDetails ?? 'N/A') ||
        _warrantyExpireDateController.text !=
            (widget.ac.warrantyExpireDate ?? 'N/A') ||
        _amcExpireDateController.text != (widget.ac.amcExpireDate ?? 'N/A') ||
        _supplierNameController.text != widget.ac.supplierName ||
        _supplierEmailController.text != (widget.ac.supplierEmail ?? 'N/A') ||
        _supplierContactNoController.text !=
            (widget.ac.supplierContactNo ?? 'N/A');
  }

  Future<void> _saveData() async {
    try {
      String? sanitize(String? value) {
        return (value != null && value.trim().isNotEmpty) ? value : null;
      }

      final requestData = {
        "precisionAC_ID": widget.ac.precisionACId,
        "Region": _regionController.text,
        "RTOM": _rtomController.text,
        "Station": _stationController.text,
        "Office_No": _officeNoController.text,
        "floor_number": _floorNumberController.text,
        "building_id": _buildingIDController.text,

        "QRTag": _qrTagController.text,
        "Model": _modelController.text,
        "Serial_Number": _serialNumberController.text,
        "Manufacturer": _manufacturerController.text,
        "Installation_Date": _installationDateController.text,
        "Status": _statusController.text,

        //Add these fields to the request
        "Dimensions": _dimensionsController.text,
        "Weight": _weightController.text,
        "Noise_Level": _noiseLevelController.text,
        "Condition_Indoor_Air_Filters":
            _conditionIndoorAirFiltersController.text,
        "No_of_Evaporator_Coils": _noOfEvaporatorCoilsController.text,
        "No_of_Indoor_Fans": _noOfIndoorFansController.text,
        "Condition_Indoor_Unit": _conditionIndoorUnitController.text,

        "No_of_Condenser_Circuits": _noOfCondenserCircuitsController.text,
        "No_of_Condenser_Fans": _noOfCondenserFansController.text,
        "Condenser_Mounting_Method": _condenserMountingMethodController.text,
        "Condition_Outdoor_Unit": _conditionOutdoorUnitController.text,

        "No_of_Compressors": _noOfCompressorsController.text,
        "Serial_Number_of_the_Compressors":
            _serialNumberOfCompressorsController.text,

        "Cooling_Capacity": _coolingCapacityController.text,
        "Power_Supply": _powerSupplyController.text,
        "Refrigerant_Type": _refrigerantTypeController.text,
        "No_of_Refrigerant_Circuits": _noOfRefrigerantCircuitsController.text,
        "Airflow": _airflowController.text,
        "Airflow_Type": _airflowTypeController.text,
        "Other_Specifications": _otherSpecificationsController.text,

        "Latitude": _latitudeController.text,
        "Longitude": _longitudeController.text,
        "Location": _locationController.text,
        "Warranty_Details": _warrantyDetailsController.text,
        "Warranty_Expire_Date": _warrantyExpireDateController.text,
        "AMC_Expire_Date": _amcExpireDateController.text,

        "Supplier_Name": _supplierNameController.text,
        "Supplier_email": _supplierEmailController.text,
        "Supplier_contact_no": _supplierContactNoController.text,

        // Add the static values for approvalStatus and UpdateRequester
        "approvalStatus": "1", // Static value for approvalStatus
        "UpdateRequester": "test user", // Static value for UpdateRequester
      };

      print("Finallllll Request Data: $requestData");

      try {
        final response = await http
            .post(
              Uri.parse(
                "https://powerprox.sltidc.lk/POST_PrecisionAC_test.php",
              ),
              body: requestData,
            )
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          print('PrecisionAC information updated successfully.');
          print(response.body);

          // Show success message to the user
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Update successful!")));

          // Navigate to HomeScreen after successful update
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => ACMaintenancePage()),
          // );
        } else {
          print(
            'Failed to update PrecisionAC information: ${response.statusCode}',
          );
          print(response.body);

          // Show error message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to update PrecisionAC information!"),
            ),
          );
          throw Exception('Failed to update PrecisionAC information.');
        }
      } catch (e) {
        print('Error updating PrecisionAC information: $e');

        // Show error message to the user
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error during update: $e")));
        rethrow;
      }
    } catch (e, stackTrace) {
      print("Error during update: $e");
      print(stackTrace);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error during update: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.ac.model)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // General Info
            _buildCategoryHeader('General Info'),
            // _buildDetailTile(Icons.label, 'Precision Ac Id:', ac.precisionACId),
            ///////////////////////////////////////////////////////////////////////////
            //_buildDetailTile(Icons.analytics, 'Model:', ac.model),
            _buildEditableCard(Icons.analytics, 'Model:', _modelController),
            //_buildDetailTile(Icons.factory, 'Manufacturer:', ac.manufacturer),
            _buildEditableCard(
              Icons.factory,
              'Manufacturer:',
              _manufacturerController,
            ),
            //_buildDetailTile(Icons.assignment, 'Serial Code:', ac.serialNumber),
            _buildEditableCard(
              Icons.assignment,
              'Serial Code:',
              _serialNumberController,
            ),
            //_buildDetailTile(Icons.calendar_today, 'Installation Date:',
            //    ac.installationDate),
            _buildEditableCard(
              Icons.calendar_today,
              'Installation Date:',
              _installationDateController,
            ),
            // _buildDetailTile(Icons.label, 'QR Tag:', ac.qrTag),
            _buildEditableCard(Icons.label, 'QR Tag:', _qrTagController),
            // _buildDetailTile(Icons.location_on, 'Region:', ac.region),
            _buildEditableCard(Icons.location_on, 'Region:', _regionController),
            //_buildDetailTile(Icons.location_city, 'RTOM:', ac.rtom),
            _buildEditableCard(Icons.location_city, 'RTOM:', _rtomController),
            //_buildDetailTile(Icons.home_work, 'Station:', ac.station),
            _buildEditableCard(Icons.home_work, 'Station:', _stationController),
            //_buildDetailTile(Icons.home_work, 'Office no:', ac.officeNo),
            _buildEditableCard(
              Icons.home_work,
              'Office no:',
              _officeNoController,
            ),
            _buildEditableCard(
              Icons.home_work,
              'Floor number:',
              _floorNumberController,
            ),
            _buildEditableCard(
              Icons.home_work,
              'Building ID:',
              _buildingIDController,
            ),

            //_buildDetailTile(Icons.copyright, 'Status:', ac.status),
            _buildEditableCard(Icons.copyright, 'Status:', _statusController),

            _buildCategoryHeader('Indoor Info'),
            // _buildDetailTile(Icons.view_array, 'Dimensions:', ac.dimensions),
            // _buildDetailTile(Icons.fitness_center, 'Weight:', ac.weight),
            // _buildDetailTile(Icons.volume_up, 'Noise Level:', ac.noiseLevel),
            // _buildDetailTile(Icons.filter_alt, 'Indoor Air Filters Condition:',
            //     ac.conditionIndoorAirFilters),
            // _buildDetailTile(Icons.ac_unit, 'No. of Evaporator Coils:',
            //     ac.noOfEvaporatorCoils),
            // _buildDetailTile(
            //     Icons.ac_unit, 'No. of Indoor Fans:', ac.No_of_Indoor_Fans),
            // _buildDetailTile(Icons.ac_unit, 'Condition. of Indoor Unit:',
            //     ac.conditionIndoorUnit),
            _buildEditableCard(
              Icons.view_array,
              'Dimensions:',
              _dimensionsController,
            ),
            _buildEditableCard(
              Icons.fitness_center,
              'Weight:',
              _weightController,
            ),
            _buildEditableCard(
              Icons.volume_up,
              'Noise Level:',
              _noiseLevelController,
            ),
            _buildEditableCard(
              Icons.filter_alt,
              'Indoor Air Filters Condition:',
              _conditionIndoorAirFiltersController,
            ),
            _buildEditableCard(
              Icons.ac_unit,
              'No. of Evaporator Coils:',
              _noOfEvaporatorCoilsController,
            ),
            _buildEditableCard(
              Icons.ac_unit,
              'No. of Indoor Fans:',
              _noOfIndoorFansController,
            ),
            _buildEditableCard(
              Icons.ac_unit,
              'Condition of Indoor Unit:',
              _conditionIndoorUnitController,
            ),

            _buildCategoryHeader('Outdoor Info'),
            // _buildDetailTile(Icons.ac_unit, 'No. of Condenser Circuits:',
            //     ac.noOfCondenserCircuits),
            // _buildDetailTile(
            //     Icons.ac_unit, 'No. of Condenser Fans:', ac.noOfCondenserFans),

            // _buildDetailTile(Icons.home, 'Condenser Mounting Method:',
            //     ac.condenserMountingMethod),
            // _buildDetailTile(Icons.ac_unit, 'Condition. of Outdoor Unit:',
            //     ac.conditionOutdoorUnit),
            _buildEditableCard(
              Icons.ac_unit,
              'No. of Condenser Circuits:',
              _noOfCondenserCircuitsController,
            ),
            _buildEditableCard(
              Icons.ac_unit,
              'No. of Condenser Fans:',
              _noOfCondenserFansController,
            ),
            _buildEditableCard(
              Icons.home,
              'Condenser Mounting Method:',
              _condenserMountingMethodController,
            ),
            _buildEditableCard(
              Icons.ac_unit,
              'Condition of Outdoor Unit:',
              _conditionOutdoorUnitController,
            ),

            // Compressor Info
            _buildCategoryHeader('Compressor Info'),
            // _buildDetailTile(
            //     Icons.compress, 'No. of Compressors:', ac.noOfCompressors),
            // _buildDetailTile2(Icons.copyright, 'Compressor Serial code:',
            //     ac.serialNumberOfCompressors),
            _buildEditableCard(
              Icons.compress,
              'No. of Compressors:',
              _noOfCompressorsController,
            ),
            _buildEditableDetailTile2(
              Icons.copyright,
              'Compressor Serial Code:',
              widget.ac.serialNumberOfCompressors,
            ),

            // Specifications
            _buildCategoryHeader('Specifications'),
            // _buildDetailTile(
            //     Icons.ac_unit, 'Cooling Capacity:', ac.coolingCapacity),
            // _buildDetailTile(Icons.power, 'Power Supply:', ac.powerSupply),
            // _buildDetailTile(
            //     Icons.settings, 'Refrigerant Type:', ac.refrigerantType),
            // _buildDetailTile(Icons.replay, 'No. of Refrigerant Circuits:',
            //     ac.noOfRefrigerantCircuits),
            // _buildDetailTile(Icons.air, 'Airflow Rate:', ac.airflow),
            // _buildDetailTile(Icons.air, 'Airflow Type:', ac.airflow_type),
            // _buildDetailTile(Icons.settings, 'Other Specifications:',
            //     ac.otherSpecifications),
            _buildEditableCard(
              Icons.ac_unit,
              'Cooling Capacity:',
              _coolingCapacityController,
            ),
            _buildEditableCard(
              Icons.power,
              'Power Supply:',
              _powerSupplyController,
            ),
            _buildEditableCard(
              Icons.settings,
              'Refrigerant Type:',
              _refrigerantTypeController,
            ),
            _buildEditableCard(
              Icons.replay,
              'No. of Refrigerant Circuits:',
              _noOfRefrigerantCircuitsController,
            ),
            _buildEditableCard(Icons.air, 'Airflow Rate:', _airflowController),
            _buildEditableCard(
              Icons.air,
              'Airflow Type:',
              _airflowTypeController,
            ),
            _buildEditableCard(
              Icons.settings,
              'Other Specifications:',
              _otherSpecificationsController,
            ),

            // Location & Warranty Info
            _buildCategoryHeader('Location & Warranty Info'),
            // _buildDetailTile(Icons.map, 'Latitude:', ac.latitude),
            // _buildDetailTile(Icons.map, 'Longitude:', ac.longitude),
            // _buildDetailTile(Icons.map, 'Location:', ac.location),
            // _buildDetailTile(Icons.access_alarm, 'Warranty Details:',
            //     ac.warrantyDetails ?? 'N/A'),
            // _buildDetailTile(Icons.access_time, 'Warranty Expire Date:',
            //     ac.warrantyExpireDate ?? 'N/A'),
            // _buildDetailTile(
            //     Icons.access_time,
            //     'Annual maintenance Contract availability:',
            //     ac.amcExpireDate ?? 'N/A'),
            _buildEditableCard(Icons.map, 'Latitude:', _latitudeController),
            _buildEditableCard(Icons.map, 'Longitude:', _longitudeController),
            _buildEditableCard(Icons.map, 'Location:', _locationController),
            _buildEditableCard(
              Icons.access_alarm,
              'Warranty Details:',
              _warrantyDetailsController,
            ),
            _buildEditableCard(
              Icons.access_time,
              'Warranty Expire Date:',
              _warrantyExpireDateController,
            ),
            _buildEditableCard(
              Icons.access_time,
              'AMC Expiry Date:',
              _amcExpireDateController,
            ),

            // Supplier Details
            _buildCategoryHeader('Supplier Details'),
            // _buildDetailTile(Icons.person, 'Supplier Name:', ac.supplierName),
            // _buildMailTile(Icons.email, 'Supplier Email:',
            //     ac.supplierEmail ?? 'N/A', AutofillHints.email, context),
            // _buildCallTile(
            //     Icons.phone,
            //     'Supplier Contact No:',
            //     ac.supplierContactNo ?? 'N/A',
            //     AutofillHints.telephoneNumber,
            //     context),
            _buildEditableCard(
              Icons.person,
              'Supplier Name:',
              _supplierNameController,
            ),
            _buildEditableMailTile(
              Icons.email,
              'Supplier Email:',
              _supplierEmailController, // Pass the email controller
              context,
            ),
            _buildEditableCallTile(
              Icons.phone,
              'Supplier Contact No:',
              _supplierContactNoController, // Pass the phone controller
              context,
            ),

            // Update Info
            _buildCategoryHeader('Update Info'),
            _buildDetailTile(
              Icons.person_add,
              'Updated By:',
              widget.ac.updatedBy.isNotEmpty ? widget.ac.updatedBy : 'N/A',
            ),
            _buildDetailTile(
              Icons.access_time,
              'Updated Time:',
              widget.ac.updatedTime.isNotEmpty ? widget.ac.updatedTime : 'N/A',
            ),

            // _buildEditableCard(
            //     Icons.person_add, 'Updated By:', _updatedByController),
            // _buildEditableCard(
            //     Icons.access_time, 'Updated Time:', _updatedTimeController),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Print values to debug
                print('Model: ${_modelController.text}');
                print('Manufacturer: ${_manufacturerController.text}');
                print('Serial Number: ${_serialNumberController.text}');
                print('Installation Date: ${_installationDateController.text}');
                print('QR Tag: ${_qrTagController.text}');
                print('Region: ${_regionController.text}');
                print('RTOM: ${_rtomController.text}');
                print('Station: ${_stationController.text}');
                print('Office No: ${_officeNoController.text}');
                print('Floor Number: ${_floorNumberController.text}');
                print('Building ID: ${_buildingIDController.text}');
                print('Status: ${_statusController.text}');
                print('Dimensions: ${_dimensionsController.text}');
                print('Weight: ${_weightController.text}');
                print('Noise Level: ${_noiseLevelController.text}');
                print(
                  'Indoor Air Filters Condition: ${_conditionIndoorAirFiltersController.text}',
                );
                print(
                  'No. of Evaporator Coils: ${_noOfEvaporatorCoilsController.text}',
                );
                print('No. of Indoor Fans: ${_noOfIndoorFansController.text}');
                print(
                  'Condition of Indoor Unit: ${_conditionIndoorUnitController.text}',
                );
                print(
                  'No. of Condenser Circuits: ${_noOfCondenserCircuitsController.text}',
                );
                print(
                  'No. of Condenser Fans: ${_noOfCondenserFansController.text}',
                );
                print(
                  'Condenser Mounting Method: ${_condenserMountingMethodController.text}',
                );
                print(
                  'Condition of Outdoor Unit: ${_conditionOutdoorUnitController.text}',
                );
                print('Cooling Capacity: ${_coolingCapacityController.text}');
                print('Power Supply: ${_powerSupplyController.text}');
                print('Refrigerant Type: ${_refrigerantTypeController.text}');
                print(
                  'No. of Refrigerant Circuits: ${_noOfRefrigerantCircuitsController.text}',
                );
                print('Airflow Rate: ${_airflowController.text}');
                print('Airflow Type: ${_airflowTypeController.text}');
                print(
                  'Other Specifications: ${_otherSpecificationsController.text}',
                );
                print('Latitude: ${_latitudeController.text}');
                print('Longitude: ${_longitudeController.text}');
                print('Location: ${_locationController.text}');
                print('Warranty Details: ${_warrantyDetailsController.text}');
                print(
                  'Warranty Expire Date: ${_warrantyExpireDateController.text}',
                );
                print('AMC Expiry Date: ${_amcExpireDateController.text}');
                print('Supplier Name: ${_supplierNameController.text}');
                print('Supplier Email: ${_supplierEmailController.text}');
                print(
                  'Supplier Contact No: ${_supplierContactNoController.text}',
                );
                if (_hasChanges()) {
                  _saveData();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("No changes detected.")),
                  );
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }
}

Widget _buildCard(String title, String value, Color color) {
  return Card(
    elevation: 4, // Add a shadow effect
    color: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Rounded corners
    ),
    margin: const EdgeInsets.all(8.0), // Margin between cards
    child: ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      tileColor: color, // Set the background color of the ListTile
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Keep the rounded corners
      ),
      contentPadding: const EdgeInsets.all(16.0), // Padding inside the ListTile
      // Optional: Add a leading icon
      // leading: Icon(Icons.info, color: Colors.white), // You can change the icon as needed
    ),
  );
}

Widget _buildDetailTile2(IconData icon, String title, String serialNumbers) {
  // Split the single string into a list of serial numbers
  List<String> serialList =
      serialNumbers.split(',').map((s) => s.trim()).toList();

  // Create a formatted string for the subtitle
  String serialCodes = serialList
      .asMap()
      .entries
      .map((entry) {
        int index = entry.key;
        String value = entry.value;
        return 'Compressor ${index + 1} Serial Code: $value';
      })
      .join('\n'); // Join with new line for better formatting

  return Card(
    margin: const EdgeInsets.symmetric(vertical: 5),
    elevation: 2,
    child: ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(serialCodes), // Use the formatted serial codes
    ),
  );
}

// Category Header
Widget _buildCategoryHeader(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );
}

// Editable Card
Widget _buildEditableCard(
  IconData icon,
  String label,
  TextEditingController controller,
) {
  return Card(
    elevation: 4, // Add a shadow effect
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Rounded corners
    ),
    margin: const EdgeInsets.all(8.0), // Margin between cards
    child: ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: TextFormField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'Tap to edit',
          border: OutlineInputBorder(),
        ),
      ),
    ),
  );
}

// Editable Detail Tile for Serial Numbers

/// Editable Detail Tile for Serial Numbers
Widget _buildEditableDetailTile2(
  IconData icon,
  String title,
  String serialNumbers,
) {
  // Split the serial numbers into a list
  List<String> serialList =
      serialNumbers.split(',').map((s) => s.trim()).toList();

  // Store the modified serial numbers
  TextEditingController serialController = TextEditingController(
    text: serialNumbers,
  );

  return Card(
    margin: const EdgeInsets.symmetric(vertical: 4.0),
    elevation: 2,
    child: ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Editable text field for serial numbers
          TextField(
            controller: serialController,
            decoration: const InputDecoration(
              hintText: 'Enter serial numbers',
              border: OutlineInputBorder(),
            ),
            onChanged: (newSerials) {
              // Handle any changes made to serial numbers
            },
          ),
        ],
      ),
    ),
  );
}

Widget _buildEditableMailTile(
  IconData icon,
  String title,
  TextEditingController emailController,
  BuildContext context,
) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 4.0),
    elevation: 2,
    child: ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: TextField(
        controller: emailController, // Controller passed as argument
        decoration: const InputDecoration(
          hintText: 'Enter email address',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.emailAddress,
        onChanged: (newEmail) {
          // Update the supplier email text
          emailController.text = newEmail.trim();
        },
      ),
      onTap: () async {
        final Uri emailUri = Uri(scheme: 'mailto', path: emailController.text);
        if (await canLaunchUrl(emailUri)) {
          await launchUrl(emailUri, mode: LaunchMode.externalApplication);
        } else {
          Clipboard.setData(ClipboardData(text: emailController.text));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Email copied to clipboard.")),
          );
        }
      },
    ),
  );
}

Widget _buildEditableCallTile(
  IconData icon,
  String title,
  TextEditingController phoneController,
  BuildContext context,
) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 4.0),
    elevation: 2,
    child: ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: TextField(
        controller: phoneController, // Controller passed as argument
        decoration: const InputDecoration(
          hintText: 'Enter contact number',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.phone,
        onChanged: (newPhone) {
          // Update the supplier contact number text
          phoneController.text = newPhone.trim();
        },
      ),
      onTap: () async {
        final Uri telUri = Uri(scheme: 'tel', path: phoneController.text);
        if (await canLaunchUrl(telUri)) {
          await launchUrl(telUri);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not launch dialer.")),
          );
        }
      },
    ),
  );
}
