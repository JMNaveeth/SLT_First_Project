import 'package:flutter/material.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/utils/utils/colors.dart';
import 'package:theme_update/utils/utils/colors.dart' as customsColors;
import 'package:theme_update/widgets/searchWidget.dart';
import 'ViewComfortACUnit.dart';
import 'ac_details_model.dart';
import 'httpGetComfortACdetails.dart';
import 'search_helper_ac.dart';

class SelectComfortACUnit extends StatefulWidget {
  const SelectComfortACUnit({Key? key}) : super(key: key);

  @override
  _SelectComfortACUnitState createState() => _SelectComfortACUnitState();
}

class _SelectComfortACUnitState extends State<SelectComfortACUnit> {
  late Future<List<AcIndoorData>> acIndoorData;
  late Future<List<AcOutdoorData>> acOutdoorData;
  late Future<List<AcLogData>> acLogData;
  List<AcIndoorData> allIndoorData = [];
  List<AcOutdoorData> allOutdoorData = [];

  int nonInverterCount = 0; // Initialize nonInverterCount
  int inverterCount = 0; // Initialize inverterCount

  String? selectedRegion = 'ALL';
  String? selectedRtom = 'ALL';
  String? selectedStation = 'ALL';
  String? selectedBuildingId = 'ALL';
  String? selectedFlowNo = 'ALL';
  String? selectedOfficeNo = 'ALL';
  String? selectedLocation = 'ALL';
  String searchQuery = '';

  Map<
    String?,
    Map<
      String?,
      Map<String?, Map<String?, Map<String?, Map<String?, String?>>>>
    >
  >
  nestedLocationData = {};

  void updateNestedLocationData(List<AcLogData> data) {
    for (var item in data) {
      String region = item.region ?? '';
      String rtom = item.rtom ?? '';
      String station = item.station ?? '';
      String rtomBuildingId = item.rtomBuildingId ?? '';
      String floorNumber = item.floorNumber ?? '';
      String officeNumber = item.officeNumber ?? '';
      String location = item.location ?? '';

      nestedLocationData[region] ??= {};
      nestedLocationData[region]![rtom] ??= {};
      nestedLocationData[region]![rtom]![station] ??= {};
      nestedLocationData[region]![rtom]![station]![rtomBuildingId] ??= {};
      nestedLocationData[region]![rtom]![station]![rtomBuildingId]![floorNumber] ??=
          {};
      nestedLocationData[region]![rtom]![station]![rtomBuildingId]![floorNumber]![officeNumber] =
          location;
    }
    debugPrint('Nested Location Data: $nestedLocationData');
  }

  List<AcLogData> acFilterDataByRegion(List<AcLogData> data, String? region) {
    if (region == null || region.isEmpty || region == 'ALL') {
      return data;
    } else {
      return data.where((item) => item.region == region).toList();
    }
  }

  //filter by Rtom
  List<AcLogData> acFilterDataByRtom(List<AcLogData> data, String? rtom) {
    if (rtom == null || rtom.isEmpty || rtom == 'ALL') {
      return data;
    } else {
      return data.where((item) => item.rtom == rtom).toList();
    }
  }

  //filter by Station

  //filter by Rtom
  List<AcLogData> acFilterDataByStation(List<AcLogData> data, String? station) {
    if (station == null || station.isEmpty || station == 'ALL') {
      return data;
    } else {
      return data.where((item) => item.station == station).toList();
    }
  }

  //filter by building id
  List<AcLogData> acFilterDataByBuildingId(
    List<AcLogData> data,
    String? buildingId,
  ) {
    if (buildingId == null || buildingId.isEmpty || buildingId == 'ALL') {
      return data;
    } else {
      return data.where((item) => item.rtomBuildingId == buildingId).toList();
    }
  }

  //filter by flow no
  List<AcLogData> acFilterDataByFlowNo(List<AcLogData> data, String? flowNo) {
    if (flowNo == null || flowNo.isEmpty || flowNo == 'ALL') {
      return data;
    } else {
      return data.where((item) => item.floorNumber == flowNo).toList();
    }
  }

  //filter by Office No
  List<AcLogData> acFilterDataByOficeNo(
    List<AcLogData> data,
    String? officeNo,
  ) {
    if (officeNo == null || officeNo.isEmpty || officeNo == 'ALL') {
      return data;
    } else {
      return data.where((item) => item.officeNumber == officeNo).toList();
    }
  }

  //filter by Location
  List<AcLogData> acFilterDataByLocation(
    List<AcLogData> data,
    String? location,
  ) {
    if (location == null || location.isEmpty || location == 'ALL') {
      return data;
    } else {
      return data.where((item) => item.location == location).toList();
    }
  }

  // Handle search query changes
  void handleSearch(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  List<AcLogData> filterDataBySearch(List<AcLogData> data) {
    if (searchQuery.isEmpty) {
      return data;
    } else {
      return data.where((logItem) {
        // Find corresponding indoor data
        AcIndoorData? indoor;
        try {
          indoor = allIndoorData.firstWhere(
            (indoor) => indoor.acIndoorId == logItem.acIndoorId,
          );
        } catch (e) {
          indoor = null;
        }

        // Find corresponding outdoor data
        AcOutdoorData? outdoor;
        try {
          outdoor = allOutdoorData.firstWhere(
            (outdoor) => outdoor.acOutdoorId == logItem.acOutdoorId,
          );
        } catch (e) {
          outdoor = null;
        }

        return SearchHelperAC.matchesACQuery(
          logItem,
          indoor,
          outdoor,
          searchQuery,
        );
      }).toList();
    }
  }

  @override
  void initState() {
    super.initState();

    // Fetch Outdoor Data
    acOutdoorData = fetchAcOutdoorData().then((data) {
      allOutdoorData = data;
      return data;
    });

    // Fetch Indoor Data and Calculate Counts
    acIndoorData = fetchAcIndoorData().then((data) {
      setState(() {
        allIndoorData = data;
        inverterCount =
            allIndoorData
                .where((item) => item.type?.toLowerCase() == 'inverter')
                .length;
        nonInverterCount =
            allIndoorData
                .where((item) => item.type?.toLowerCase() == 'non-inverter')
                .length;
        // Add debug statements here
        debugPrint('Inverter Count: $inverterCount');
        debugPrint('Non-Inverter Count: $nonInverterCount');
      });
      return data;
    });

    // Fetch Log Data
    acLogData = fetchAcLogData().then((data) {
      setState(() {
        updateNestedLocationData(data);
      });
      return data;
    });
  }

  Map<String, int> getSummary(List<AcIndoorData> indoorDataList) {
    int totalInvertor = 0;
    int totalNoninvertor = 0;

    for (var system in indoorDataList) {
      final type = system.type?.trim().toLowerCase();
      if (type == 'inverter') {
        totalInvertor++;
      } else if (type == 'non-inverter') {
        totalNoninvertor++;
      }
    }

    return {'Invertor': totalInvertor, 'Non Invertor': totalNoninvertor};
  }

 Widget buildSummaryTable() {
  final customColors = Theme.of(context).extension<CustomColors>()!;
  return FutureBuilder<List<AcIndoorData>>(
    future: acIndoorData,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text('No data available'));
      } else {
        final summary = getSummary(snapshot.data!);
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Table(
            border: TableBorder.all(color: customColors.subTextColor),
            columnWidths: {0: FixedColumnWidth(200)},
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Summary',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: customColors.mainTextColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Inverter',
                      style: TextStyle(color: customColors.subTextColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${summary['Invertor'] ?? 0}',
                      style: TextStyle(color: customColors.subTextColor),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Non-Inverter',
                      style: TextStyle(color: customColors.subTextColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${summary['Non Invertor'] ?? 0}',
                      style: TextStyle(color: customColors.subTextColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    },
  );
}
  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AC Details',
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
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                // Add SearchWidget here
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: SearchWidget(
                    onSearch: handleSearch,
                    hintText: 'Search',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Region:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: customColors.mainTextColor,
                      ),
                    ),
                    DropdownButton<String>(
                      dropdownColor: customColors.suqarBackgroundColor,
                      hint: Text(
                        'Select Region',
                        style: TextStyle(color: customColors.mainTextColor),
                      ),
                      value: selectedRegion,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRegion = newValue;
                          selectedRtom = 'ALL';
                          selectedStation = 'ALL';
                          selectedBuildingId = 'ALL';
                          selectedFlowNo = 'ALL';
                          selectedOfficeNo = 'ALL';
                          selectedLocation = 'ALL';
                          // Reset selections
                        });
                      },
                      items:
                          ([
                            'ALL',
                            ...nestedLocationData.keys,
                          ]).map<DropdownMenuItem<String>>((String? value) {
                            return DropdownMenuItem<String>(
                              value: value!,
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: customColors.mainTextColor,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),

                //rtom
                Align(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "RTOM  :",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: customColors.mainTextColor,
                          ),
                        ),
                        DropdownButton<String>(
                          dropdownColor: customColors.suqarBackgroundColor,
                          hint: Text(
                            'RTOM',
                            style: TextStyle(color: customColors.mainTextColor),
                          ),
                          value: selectedRtom,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedRtom = newValue;
                              selectedStation = 'ALL';
                              selectedBuildingId = 'ALL';
                              selectedFlowNo = 'ALL';
                              selectedOfficeNo = 'ALL';
                              selectedLocation = 'ALL';
                            });
                          },
                          items:
                              selectedRegion != null &&
                                      nestedLocationData[selectedRegion] != null
                                  ? ([
                                    'ALL',
                                    ...nestedLocationData[selectedRegion]!.keys,
                                  ]).map((String? value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value!,
                                        style: TextStyle(
                                          color: customColors.mainTextColor,
                                        ),
                                      ),
                                    );
                                  }).toList()
                                  : [],
                        ),
                        //station
                        //Spacer(),
                        SizedBox(width: 85),
                        Text(
                          "STATION  :",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: customColors.mainTextColor,
                          ),
                        ),
                        DropdownButton<String>(
                          dropdownColor: customColors.suqarBackgroundColor,
                          hint: Text(
                            'Station',
                            style: TextStyle(color: customColors.mainTextColor),
                          ),
                          value: selectedStation,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedStation = newValue;
                              selectedBuildingId = 'ALL';
                              selectedFlowNo = 'ALL';
                              selectedOfficeNo = 'ALL';
                              selectedLocation = 'ALL';
                            });
                          },
                          items:
                              selectedRtom != null &&
                                      nestedLocationData[selectedRegion]?[selectedRtom] !=
                                          null
                                  ? ([
                                    'ALL',
                                    ...nestedLocationData[selectedRegion!]![selectedRtom]!
                                        .keys,
                                  ]).map((String? value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value!,
                                        style: TextStyle(
                                          color: customColors.mainTextColor,
                                        ),
                                      ),
                                    );
                                  }).toList()
                                  : [],
                        ),
                      ],
                    ),
                  ),
                ),

                //station
                Align(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "BUILDING  :",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: customColors.mainTextColor,
                          ),
                        ),
                        DropdownButton<String>(
                          dropdownColor: customColors.suqarBackgroundColor,
                          hint: Text(
                            'Building',
                            style: TextStyle(color: customColors.mainTextColor),
                          ),
                          value: selectedBuildingId,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedBuildingId = newValue;
                              selectedFlowNo = 'ALL';
                              selectedOfficeNo = 'ALL';
                              selectedLocation = 'ALL';
                            });
                          },
                          items:
                              selectedStation != null &&
                                      nestedLocationData[selectedRegion]?[selectedRtom]?[selectedStation] !=
                                          null
                                  ? ([
                                    'ALL',
                                    ...nestedLocationData[selectedRegion!]![selectedRtom]![selectedStation]!
                                        .keys,
                                  ]).map((String? value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value!,
                                        style: TextStyle(
                                          color: customColors.mainTextColor,
                                        ),
                                      ),
                                    );
                                  }).toList()
                                  : [],
                        ),
                        SizedBox(width: 40),
                        //Spacer(),
                        Text(
                          "FLOW  :",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: customColors.mainTextColor,
                          ),
                        ),
                        DropdownButton<String>(
                          dropdownColor: customColors.suqarBackgroundColor,
                          hint: Text(
                            'Flow',
                            style: TextStyle(color: customColors.mainTextColor),
                          ),
                          value: selectedFlowNo,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedFlowNo = newValue;
                              selectedOfficeNo = 'ALL';
                              selectedLocation = 'ALL';
                            });
                          },
                          items:
                              selectedBuildingId != null &&
                                      nestedLocationData[selectedRegion]?[selectedRtom]?[selectedStation]?[selectedBuildingId] !=
                                          null
                                  ? ([
                                    'ALL',
                                    ...nestedLocationData[selectedRegion!]![selectedRtom]![selectedStation]![selectedBuildingId]!
                                        .keys,
                                  ]).map((String? value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value!,
                                        style: TextStyle(
                                          color: customColors.mainTextColor,
                                        ),
                                      ),
                                    );
                                  }).toList()
                                  : [],
                        ),
                      ],
                    ),
                  ),
                ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "OFFICE NO  :",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: customColors.mainTextColor,
                        ),
                      ),
                      DropdownButton<String>(
                        dropdownColor: customColors.suqarBackgroundColor,
                        hint: Text(
                          'Office No',
                          style: TextStyle(color: customColors.mainTextColor),
                        ),
                        value: selectedOfficeNo,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedOfficeNo = newValue;
                            selectedLocation = 'ALL';
                          });
                        },
                        items:
                            selectedFlowNo != null &&
                                    nestedLocationData[selectedRegion]?[selectedRtom]?[selectedStation]?[selectedBuildingId]?[selectedFlowNo] !=
                                        null
                                ? ([
                                  'ALL',
                                  ...nestedLocationData[selectedRegion!]![selectedRtom]![selectedStation]![selectedBuildingId]![selectedFlowNo]!
                                      .keys,
                                ]).map((String? value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value!,
                                      style: TextStyle(
                                        color: customColors.mainTextColor,
                                      ),
                                    ),
                                  );
                                }).toList()
                                : [],
                      ),
                      SizedBox(width: 22),
                      Text(
                        "LOCATION  :",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: customColors.mainTextColor,
                        ),
                      ),
                      DropdownButton<String>(
                        dropdownColor: customColors.suqarBackgroundColor,
                        hint: Text(
                          'Location',
                          style: TextStyle(color: customColors.mainTextColor),
                        ),
                        value: selectedLocation,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLocation = newValue;
                          });
                        },
                        items:
                            selectedOfficeNo != null &&
                                    nestedLocationData[selectedRegion]?[selectedRtom]?[selectedStation]?[selectedBuildingId]?[selectedFlowNo]?[selectedOfficeNo] !=
                                        null
                                ? ([
                                  'ALL',
                                  nestedLocationData[selectedRegion!]![selectedRtom]![selectedStation]![selectedBuildingId]![selectedFlowNo]![selectedOfficeNo]!,
                                ]).map((String? value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value!,
                                      style: TextStyle(
                                        color: customColors.mainTextColor,
                                      ),
                                    ),
                                  );
                                }).toList()
                                : [],
                      ),
                    ],
                  ),
                ),
                buildSummaryTable(),

                const SizedBox(height: 15),

                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: Future.wait([
                      acIndoorData,
                      acOutdoorData,
                      acLogData,
                    ]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData ||
                          (snapshot.data![0] as List).isEmpty ||
                          (snapshot.data![1] as List).isEmpty ||
                          (snapshot.data![2] as List).isEmpty) {
                        return Center(child: Text('No data available'));
                      } else {
                        List<AcIndoorData> indoorDataList =
                            snapshot.data![0] as List<AcIndoorData>;
                        List<AcOutdoorData> outdoorDataList =
                            snapshot.data![1] as List<AcOutdoorData>;
                        List<AcLogData> logDataList =
                            snapshot.data![2] as List<AcLogData>;

                        logDataList = acFilterDataByRegion(
                          logDataList,
                          selectedRegion,
                        );
                        logDataList = acFilterDataByRtom(
                          logDataList,
                          selectedRtom,
                        );
                        logDataList = acFilterDataByStation(
                          logDataList,
                          selectedStation,
                        );
                        logDataList = acFilterDataByBuildingId(
                          logDataList,
                          selectedBuildingId,
                        );
                        logDataList = acFilterDataByFlowNo(
                          logDataList,
                          selectedFlowNo,
                        );

                        logDataList = acFilterDataByOficeNo(
                          logDataList,
                          selectedOfficeNo,
                        );
                        logDataList = acFilterDataByLocation(
                          logDataList,
                          selectedLocation,
                        );

                        // indoorDataList.sort(
                        //     (a, b) => b.lastUpdated!.compareTo(a.lastUpdated!));

                        // if (indoorDataList.isEmpty) {
                        //   return Center(
                        //       child: Text(
                        //           'No data available for the selected region'));
                        // }

                        // Apply search filter
                        logDataList = filterDataBySearch(logDataList);

                        if (logDataList.isEmpty) {
                          return Center(
                            child: Text(
                              'No data available for the selected filters',
                              style: TextStyle(
                                color: customColors.mainTextColor,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: logDataList.length,
                          itemBuilder: (context, index) {
                            AcLogData logData = logDataList[index];
                            debugPrint(" INDOOR ID ${logData.acIndoorId}");

                            AcIndoorData? indoorData;
                            AcOutdoorData? outdoorData;

                            // Check if acIndoorId is not null and try to find the corresponding indoorData
                            if (logData.acIndoorId != null &&
                                logData.acIndoorId.isNotEmpty) {
                              try {
                                indoorData = indoorDataList.firstWhere(
                                  (indoor) =>
                                      int.parse(indoor.acIndoorId) ==
                                      int.parse(logData.acIndoorId),
                                );
                                debugPrint(logData.acIndoorId);
                              } catch (e) {
                                debugPrint(
                                  'No suitable logData found for ${logData.acIndoorId}',
                                );
                                indoorData =
                                    null; // Set indoorData to null explicitly
                              }
                            } else {
                              debugPrint(
                                'Skipping logData with null or empty acIndoorId',
                              );
                            }

                            // Check if acOutdoorId is not null and try to find the corresponding outdoorData
                            if (logData.acOutdoorId != null &&
                                logData.acOutdoorId.isNotEmpty) {
                              if (indoorData != null) {
                                try {
                                  outdoorData = outdoorDataList.firstWhere(
                                    (outdoor) =>
                                        int.parse(outdoor.acOutdoorId!) ==
                                        int.parse(logData.acOutdoorId),
                                  );
                                  debugPrint(logData.acOutdoorId);
                                } catch (e) {
                                  debugPrint(
                                    'No suitable outdoorData found for ${logData.acOutdoorId}',
                                  );
                                  outdoorData =
                                      null; // Set outdoorData to null explicitly
                                }
                              }
                            } else {
                              debugPrint(
                                'Skipping logData with null or empty acOutdoorId',
                              );
                            }

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ViewComfortACUnit(
                                          outdoorData: outdoorData,
                                          logData: logData,
                                          indoorData: indoorData,
                                          searchQuery: searchQuery,
                                        ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 4, // Adds a subtle shadow
                                color: customColors.suqarBackgroundColor,

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // Rounded corners
                                ),

                                child: ListTile(
                                  hoverColor: Colors.blue.withOpacity(0.1),

                                  // Blue hover effect
                                  title: Text(
                                    'Region: ${logData.region ?? ""}',
                                    style: TextStyle(
                                      color: customColors.mainTextColor,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Location: ${logData.location ?? ""}',
                                        style: TextStyle(
                                          color: customColors.subTextColor,
                                        ),
                                      ),
                                      Text(
                                        'AC ID: ${indoorData?.qrIn ?? "N/A"}',
                                        style: TextStyle(
                                          color: customColors.subTextColor,
                                        ),
                                      ),
                                      Text(
                                        'Capacity: ${indoorData?.capacity ?? "N/A"}',
                                        style: TextStyle(
                                          color: customColors.subTextColor,
                                        ),
                                      ),
                                      Text(
                                        'Brand: ${indoorData?.brand ?? "N/A"}',
                                        style: TextStyle(
                                          color: customColors.subTextColor,
                                        ),
                                      ),
                                      Text(
                                        'Last Updated: ${indoorData?.lastUpdated ?? "N/A"}',
                                        style: TextStyle(
                                          color: customColors.subTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
      ),
    );
  }
}



//v3
// import 'package:flutter/material.dart';
// // import '../../../HomePage/utils/colors.dart';
// import '../../../../Widgets/SearchWidget/searchWidget.dart';
// import '../../../HomePage/widgets/colors.dart';
// import 'ViewComfortACUnit.dart';
// import 'ac_details_model.dart';
// import 'httpGetComfortACdetails.dart';
//
// class SelectComfortACUnit extends StatefulWidget {
//   const SelectComfortACUnit({super.key});
//
//   @override
//   _SelectComfortACUnitState createState() => _SelectComfortACUnitState();
// }
//
// class _SelectComfortACUnitState extends State<SelectComfortACUnit> {
//   late Future<List<AcIndoorData>> acIndoorData;
//   late Future<List<AcOutdoorData>> acOutdoorData;
//   late Future<List<AcLogData>> acLogData;
//
//   String? selectedRegion = 'ALL';
//   String? selectedRtom = 'ALL';
//   String? selectedStation = 'ALL';
//   String? selectedBuildingId = 'ALL';
//   String? selectedFlowNo = 'ALL';
//   String? selectedOfficeNo = 'ALL';
//   String? selectedLocation = 'ALL';
//   String searchQuery = '';
//
//   Map<
//       String?,
//       Map<
//           String?,
//           Map<String?, Map<String?, Map<String?, Map<String?, String?>>>>
//       >
//   >
//   nestedLocationData = {};
//
//   void updateNestedLocationData(List<AcLogData> data) {
//     for (var item in data) {
//       String region = item.region ?? '';
//       String rtom = item.rtom ?? '';
//       String station = item.station ?? '';
//       String rtomBuildingId = item.rtomBuildingId ?? '';
//       String floorNumber = item.floorNumber ?? '';
//       String officeNumber = item.officeNumber ?? '';
//       String location = item.location ?? '';
//
//       nestedLocationData[region] ??= {};
//       nestedLocationData[region]![rtom] ??= {};
//       nestedLocationData[region]![rtom]![station] ??= {};
//       nestedLocationData[region]![rtom]![station]![rtomBuildingId] ??= {};
//       nestedLocationData[region]![rtom]![station]![rtomBuildingId]![floorNumber] ??=
//       {};
//       nestedLocationData[region]![rtom]![station]![rtomBuildingId]![floorNumber]![officeNumber] =
//           location;
//     }
//     debugPrint('Nested Location Data: $nestedLocationData');
//   }
//
//   List<AcLogData> acFilterDataByRegion(List<AcLogData> data, String? region) {
//     if (region == null || region.isEmpty || region == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.region == region).toList();
//     }
//   }
//
//   //filter by Rtom
//   List<AcLogData> acFilterDataByRtom(List<AcLogData> data, String? rtom) {
//     if (rtom == null || rtom.isEmpty || rtom == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.rtom == rtom).toList();
//     }
//   }
//
//   //filter by Station
//
//   //filter by Rtom
//   List<AcLogData> acFilterDataByStation(List<AcLogData> data, String? station) {
//     if (station == null || station.isEmpty || station == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.station == station).toList();
//     }
//   }
//
//   //filter by building id
//   List<AcLogData> acFilterDataByBuildingId(
//       List<AcLogData> data,
//       String? buildingId,
//       ) {
//     if (buildingId == null || buildingId.isEmpty || buildingId == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.rtomBuildingId == buildingId).toList();
//     }
//   }
//
//   //filter by flow no
//   List<AcLogData> acFilterDataByFlowNo(List<AcLogData> data, String? flowNo) {
//     if (flowNo == null || flowNo.isEmpty || flowNo == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.floorNumber == flowNo).toList();
//     }
//   }
//
//   //filter by Office No
//   List<AcLogData> acFilterDataByOficeNo(
//       List<AcLogData> data,
//       String? officeNo,
//       ) {
//     if (officeNo == null || officeNo.isEmpty || officeNo == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.officeNumber == officeNo).toList();
//     }
//   }
//
//   //filter by Location
//   List<AcLogData> acFilterDataByLocation(
//       List<AcLogData> data,
//       String? location,
//       ) {
//     if (location == null || location.isEmpty || location == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.location == location).toList();
//     }
//   }
//
//   // Handle search query changes
//   void handleSearch(String query) {
//     setState(() {
//       searchQuery = query;
//     });
//   }
//
//   // Filter data based on search query
//   List<AcLogData> filterDataBySearch(List<AcLogData> data) {
//     if (searchQuery.isEmpty) {
//       return data;
//     } else {
//       return data.where((item) {
//         final query = searchQuery.toLowerCase();
//         final region = item.region?.toLowerCase() ?? '';
//         final rtom = item.rtom?.toLowerCase() ?? '';
//         final station = item.station?.toLowerCase() ?? '';
//         final buildingId = item.rtomBuildingId?.toLowerCase() ?? '';
//         final floorNumber = item.floorNumber?.toLowerCase() ?? '';
//         final officeNumber = item.officeNumber?.toLowerCase() ?? '';
//         final location = item.location?.toLowerCase() ?? '';
//
//         return region.contains(query) ||
//             rtom.contains(query) ||
//             station.contains(query) ||
//             buildingId.contains(query) ||
//             floorNumber.contains(query) ||
//             officeNumber.contains(query) ||
//             location.contains(query);
//       }).toList();
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     acOutdoorData = fetchAcOutdoorData();
//     acIndoorData = fetchAcIndoorData();
//     acLogData = fetchAcLogData();
//     acLogData = fetchAcLogData().then((data) {
//       setState(() {
//         updateNestedLocationData(data);
//         debugPrint("send log data");
//       });
//       return data;
//     });
//
//     debugPrint(nestedLocationData.toString());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('AC Details', style: TextStyle(color: mainTextColor)),
//         backgroundColor: appbarColor,
//       ),
//       body: Container(
//         color: mainBackgroundColor,
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             children: [
//               // Add SearchWidget here
//               Padding(
//                 padding: const EdgeInsets.all(0),
//                 child: SearchWidget(onSearch: handleSearch, hintText: 'Search'),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Region:",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w400,
//                       color: mainTextColor,
//                     ),
//                   ),
//                   DropdownButton<String>(
//                     dropdownColor: suqarBackgroundColor,
//                     hint: Text(
//                       'Select Region',
//                       style: TextStyle(color: mainTextColor),
//                     ),
//                     value: selectedRegion,
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         selectedRegion = newValue;
//                         selectedRtom = 'ALL';
//                         selectedStation = 'ALL';
//                         selectedBuildingId = 'ALL';
//                         selectedFlowNo = 'ALL';
//                         selectedOfficeNo = 'ALL';
//                         selectedLocation = 'ALL';
//                       });
//                     },
//                     items: ([
//                       'ALL',
//                       ...nestedLocationData.keys,
//                     ]).map<DropdownMenuItem<String>>((String? value) {
//                       return DropdownMenuItem<String>(
//                         value: value!,
//                         child: Text(
//                           value,
//                           style: TextStyle(color: mainTextColor),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               ),
//
//               //rtom
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(
//                         "RTOM  :",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w400,
//                           color: mainTextColor,
//                         ),
//                       ),
//                       DropdownButton<String>(
//                         dropdownColor: suqarBackgroundColor,
//                         hint: Text(
//                           'RTOM',
//                           style: TextStyle(color: mainTextColor),
//                         ),
//                         value: selectedRtom,
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             selectedRtom = newValue;
//                             selectedStation = 'ALL';
//                             selectedBuildingId = 'ALL';
//                             selectedFlowNo = 'ALL';
//                             selectedOfficeNo = 'ALL';
//                             selectedLocation = 'ALL';
//                           });
//                         },
//                         items: selectedRegion != null &&
//                             nestedLocationData[selectedRegion] != null
//                             ? ([
//                           'ALL',
//                           ...nestedLocationData[selectedRegion]!.keys,
//                         ]).map((String? value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(
//                               value!,
//                               style: TextStyle(color: mainTextColor),
//                             ),
//                           );
//                         }).toList()
//                             : [],
//                       ),
//                       SizedBox(width: 85),
//                       Text(
//                         "STATION  :",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w400,
//                           color: mainTextColor,
//                         ),
//                       ),
//                       DropdownButton<String>(
//                         dropdownColor: suqarBackgroundColor,
//                         hint: Text(
//                           'Station',
//                           style: TextStyle(color: mainTextColor),
//                         ),
//                         value: selectedStation,
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             selectedStation = newValue;
//                             selectedBuildingId = 'ALL';
//                             selectedFlowNo = 'ALL';
//                             selectedOfficeNo = 'ALL';
//                             selectedLocation = 'ALL';
//                           });
//                         },
//                         items: selectedRtom != null &&
//                             nestedLocationData[selectedRegion]?[selectedRtom] !=
//                                 null
//                             ? ([
//                           'ALL',
//                           ...nestedLocationData[selectedRegion!]![selectedRtom]!
//                               .keys,
//                         ]).map((String? value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(
//                               value!,
//                               style: TextStyle(color: mainTextColor),
//                             ),
//                           );
//                         }).toList()
//                             : [],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               //station
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(
//                         "BUILDING  :",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w400,
//                           color: mainTextColor,
//                         ),
//                       ),
//                       DropdownButton<String>(
//                         dropdownColor: suqarBackgroundColor,
//                         hint: Text(
//                           'Building',
//                           style: TextStyle(color: mainTextColor),
//                         ),
//                         value: selectedBuildingId,
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             selectedBuildingId = newValue;
//                             selectedFlowNo = 'ALL';
//                             selectedOfficeNo = 'ALL';
//                             selectedLocation = 'ALL';
//                           });
//                         },
//                         items: selectedStation != null &&
//                             nestedLocationData[selectedRegion]?[selectedRtom]?[selectedStation] !=
//                                 null
//                             ? ([
//                           'ALL',
//                           ...nestedLocationData[selectedRegion!]![selectedRtom]![selectedStation]!
//                               .keys,
//                         ]).map((String? value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(
//                               value!,
//                               style: TextStyle(color: mainTextColor),
//                             ),
//                           );
//                         }).toList()
//                             : [],
//                       ),
//                       SizedBox(width: 40),
//                       Text(
//                         "FLOW  :",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w400,
//                           color: mainTextColor,
//                         ),
//                       ),
//                       DropdownButton<String>(
//                         dropdownColor: suqarBackgroundColor,
//                         hint: Text(
//                           'Flow',
//                           style: TextStyle(color: mainTextColor),
//                         ),
//                         value: selectedFlowNo,
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             selectedFlowNo = newValue;
//                             selectedOfficeNo = 'ALL';
//                             selectedLocation = 'ALL';
//                           });
//                         },
//                         items: selectedBuildingId != null &&
//                             nestedLocationData[selectedRegion]?[selectedRtom]?[selectedStation]?[selectedBuildingId] !=
//                                 null
//                             ? ([
//                           'ALL',
//                           ...nestedLocationData[selectedRegion!]![selectedRtom]![selectedStation]![selectedBuildingId]!
//                               .keys,
//                         ]).map((String? value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(
//                               value!,
//                               style: TextStyle(color: mainTextColor),
//                             ),
//                           );
//                         }).toList()
//                             : [],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       "OFFICE NO  :",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w400,
//                         color: mainTextColor,
//                       ),
//                     ),
//                     DropdownButton<String>(
//                       dropdownColor: suqarBackgroundColor,
//                       hint: Text(
//                         'Office No',
//                         style: TextStyle(color: mainTextColor),
//                       ),
//                       value: selectedOfficeNo,
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedOfficeNo = newValue;
//                           selectedLocation = 'ALL';
//                         });
//                       },
//                       items: selectedFlowNo != null &&
//                           nestedLocationData[selectedRegion]?[selectedRtom]?[selectedStation]?[selectedBuildingId]?[selectedFlowNo] !=
//                               null
//                           ? ([
//                         'ALL',
//                         ...nestedLocationData[selectedRegion!]![selectedRtom]![selectedStation]![selectedBuildingId]![selectedFlowNo]!
//                             .keys,
//                       ]).map((String? value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(
//                             value!,
//                             style: TextStyle(color: mainTextColor),
//                           ),
//                         );
//                       }).toList()
//                           : [],
//                     ),
//                     SizedBox(width: 22),
//                     Text(
//                       "LOCATION  :",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w400,
//                         color: mainTextColor,
//                       ),
//                     ),
//                     DropdownButton<String>(
//                       dropdownColor: suqarBackgroundColor,
//                       hint: Text(
//                         'Location',
//                         style: TextStyle(color: mainTextColor),
//                       ),
//                       value: selectedLocation,
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedLocation = newValue;
//                         });
//                       },
//                       items: selectedOfficeNo != null &&
//                           nestedLocationData[selectedRegion]?[selectedRtom]?[selectedStation]?[selectedBuildingId]?[selectedFlowNo]?[selectedOfficeNo] !=
//                               null
//                           ? ([
//                         'ALL',
//                         nestedLocationData[selectedRegion!]![selectedRtom]![selectedStation]![selectedBuildingId]![selectedFlowNo]![selectedOfficeNo]!,
//                       ]).map((String? value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(
//                             value!,
//                             style: TextStyle(color: mainTextColor),
//                           ),
//                         );
//                       }).toList()
//                           : [],
//                     ),
//                   ],
//                 ),
//               ),
//
//               Expanded(
//                 child: FutureBuilder<List<dynamic>>(
//                   future: Future.wait([acIndoorData, acOutdoorData, acLogData]),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     } else if (snapshot.hasError) {
//                       return Center(child: Text('Error: ${snapshot.error}'));
//                     } else if (!snapshot.hasData ||
//                         (snapshot.data![0] as List).isEmpty ||
//                         (snapshot.data![1] as List).isEmpty ||
//                         (snapshot.data![2] as List).isEmpty) {
//                       return Center(child: Text('No data available'));
//                     } else {
//                       List<AcIndoorData> indoorDataList =
//                       snapshot.data![0] as List<AcIndoorData>;
//                       List<AcOutdoorData> outdoorDataList =
//                       snapshot.data![1] as List<AcOutdoorData>;
//                       List<AcLogData> logDataList =
//                       snapshot.data![2] as List<AcLogData>;
//
//                       logDataList = acFilterDataByRegion(
//                         logDataList,
//                         selectedRegion,
//                       );
//                       logDataList = acFilterDataByRtom(
//                         logDataList,
//                         selectedRtom,
//                       );
//                       logDataList = acFilterDataByStation(
//                         logDataList,
//                         selectedStation,
//                       );
//                       logDataList = acFilterDataByBuildingId(
//                         logDataList,
//                         selectedBuildingId,
//                       );
//                       logDataList = acFilterDataByFlowNo(
//                         logDataList,
//                         selectedFlowNo,
//                       );
//
//                       logDataList = acFilterDataByOficeNo(
//                         logDataList,
//                         selectedOfficeNo,
//                       );
//                       logDataList = acFilterDataByLocation(
//                         logDataList,
//                         selectedLocation,
//                       );
//
//                       // indoorDataList.sort(
//                       //     (a, b) => b.lastUpdated!.compareTo(a.lastUpdated!));
//
//                       // if (indoorDataList.isEmpty) {
//                       //   return Center(
//                       //       child: Text(
//                       //           'No data available for the selected region'));
//                       // }
//
//                       // Apply search filter
//                       logDataList = filterDataBySearch(logDataList);
//
//                       if (logDataList.isEmpty) {
//                         return Center(
//                           child: Text(
//                             'No data available for the selected filters',
//                           ),
//                         );
//                       }
//
//                       return ListView.builder(
//                         itemCount: logDataList.length,
//                         itemBuilder: (context, index) {
//                           AcLogData logData = logDataList[index];
//                           debugPrint(" INDOOR ID ${logData.acIndoorId}");
//
//                           AcIndoorData? indoorData;
//                           AcOutdoorData? outdoorData;
//
//                           // Check if acIndoorId is not null and try to find the corresponding indoorData
//                           if (logData.acIndoorId.isNotEmpty) {
//                             try {
//                               indoorData = indoorDataList.firstWhere(
//                                     (indoor) =>
//                                 int.parse(indoor.acIndoorId) ==
//                                     int.parse(logData.acIndoorId),
//                               );
//                               debugPrint(logData.acIndoorId);
//                             } catch (e) {
//                               debugPrint(
//                                 'No suitable logData found for ${logData.acIndoorId}',
//                               );
//                               indoorData =
//                               null; // Set indoorData to null explicitly
//                             }
//                           } else {
//                             debugPrint(
//                               'Skipping logData with null or empty acIndoorId',
//                             );
//                           }
//
//                           // Check if acOutdoorId is not null and try to find the corresponding outdoorData
//                           if (logData.acOutdoorId.isNotEmpty) {
//                             if (indoorData != null) {
//                               try {
//                                 outdoorData = outdoorDataList.firstWhere(
//                                       (outdoor) =>
//                                   int.parse(outdoor.acOutdoorId!) ==
//                                       int.parse(logData.acOutdoorId),
//                                 );
//                                 debugPrint(logData.acOutdoorId);
//                               } catch (e) {
//                                 debugPrint(
//                                   'No suitable outdoorData found for ${logData.acOutdoorId}',
//                                 );
//                                 outdoorData =
//                                 null; // Set outdoorData to null explicitly
//                               }
//                             }
//                           } else {
//                             debugPrint(
//                               'Skipping logData with null or empty acOutdoorId',
//                             );
//                           }
//
//                           return GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder:
//                                       (context) => ViewComfortACUnit(
//                                     outdoorData: outdoorData,
//                                     logData: logData,
//                                     indoorData: indoorData,
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: Card(
//                               elevation: 4, // Adds a subtle shadow
//                               color: suqarBackgroundColor, // Card background color
//
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(
//                                   15,
//                                 ), // Rounded corners
//                               ),
//
//                               child: ListTile(
//                                 hoverColor: Colors.blue.withOpacity(
//                                   0.1,
//                                 ), // Blue hover effect
//
//                                 title: Text(
//                                   'Region: ${logData.region ?? ""}',
//                                   style: TextStyle(color: mainTextColor),
//                                 ),
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Location: ${logData.location ?? ""}',
//                                       style: TextStyle(color: subTextColor),
//                                     ),
//                                     Text(
//                                       'AC ID: ${indoorData?.qrIn ?? "N/A"}',
//                                       style: TextStyle(color: subTextColor),
//                                     ),
//                                     Text(
//                                       'Capacity: ${indoorData?.capacity ?? "N/A"}',
//                                       style: TextStyle(color: subTextColor),
//                                     ),
//                                     Text(
//                                       'Brand: ${indoorData?.brand ?? "N/A"}',
//                                       style: TextStyle(color: subTextColor),
//                                     ),
//                                     Text(
//                                       'Last Updated: ${indoorData?.lastUpdated ?? "N/A"}',
//                                       style: TextStyle(color: subTextColor),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     }
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
//


//v2
// import 'package:flutter/material.dart';
//
// import 'ViewComfortACUnit.dart';
// import 'ac_details_model.dart';
// import 'httpGetComfortACdetails.dart';
//
//
//
// class SelectComfortACUnit extends StatefulWidget {
//   const SelectComfortACUnit({Key? key}) : super(key: key);
//
//   @override
//   _SelectComfortACUnitState createState() => _SelectComfortACUnitState();
// }
//
// class _SelectComfortACUnitState extends State<SelectComfortACUnit> {
//   late Future<List<AcIndoorData>> acIndoorData;
//   late Future<List<AcOutdoorData>> acOutdoorData;
//   late Future<List<AcLogData>> acLogData;
//
//   String? selectedRegion = 'ALL';
//   String? selectedRtom = 'ALL';
//   String? selectedStation = 'ALL';
//   String? selectedBuildingId = 'ALL';
//   String? selectedFlowNo = 'ALL';
//   String? selectedOfficeNo = 'ALL';
//   String? selectedLocation = 'ALL';
//
//
//   Map<
//       String?,
//       Map<String?,
//           Map<String?, Map<String?, Map<String?, Map<String?, String?>>>>>>
//   nestedLocationData = {};
//
//   void updateNestedLocationData(List<AcLogData> data) {
//     for (var item in data) {
//
//       String region = item.region ?? '';
//       String rtom = item.rtom ?? '';
//       String station = item.station ?? '';
//       String rtomBuildingId = item.rtomBuildingId ?? '';
//       String floorNumber = item.floorNumber ?? '';
//       String officeNumber = item.officeNumber ?? '';
//       String location = item.location ?? '';
//
//       nestedLocationData[region] ??= {};
//       nestedLocationData[region]![rtom] ??= {};
//       nestedLocationData[region]![rtom]![station] ??= {};
//       nestedLocationData[region]![rtom]![station]![rtomBuildingId] ??= {};
//       nestedLocationData[region]![rtom]![station]![rtomBuildingId]![
//       floorNumber] ??= {};
//       nestedLocationData[region]![rtom]![station]![rtomBuildingId]![
//       floorNumber]![officeNumber] = location;
//     }
//     debugPrint('Nested Location Data: $nestedLocationData');
//   }
//
//   List<AcLogData> acFilterDataByRegion(List<AcLogData> data, String? region) {
//     if (region == null || region.isEmpty || region == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.region == region).toList();
//     }
//   }
//
// //filter by Rtom
//   List<AcLogData> acFilterDataByRtom(List<AcLogData> data, String? rtom) {
//     if (rtom == null || rtom.isEmpty || rtom == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.rtom == rtom).toList();
//     }
//   }
//
//   //filter by Station
//
//   //filter by Rtom
//   List<AcLogData> acFilterDataByStation(List<AcLogData> data, String? station) {
//     if (station == null || station.isEmpty || station == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.station == station).toList();
//     }
//   }
//
//   //filter by building id
//   List<AcLogData> acFilterDataByBuildingId(
//       List<AcLogData> data, String? buildingId) {
//     if (buildingId == null || buildingId.isEmpty || buildingId == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.rtomBuildingId == buildingId).toList();
//     }
//   }
//
//   //filter by flow no
//   List<AcLogData> acFilterDataByFlowNo(List<AcLogData> data, String? flowNo) {
//     if (flowNo == null || flowNo.isEmpty || flowNo == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.floorNumber == flowNo).toList();
//     }
//   }
//
//   //filter by Office No
//   List<AcLogData> acFilterDataByOficeNo(
//       List<AcLogData> data, String? officeNo) {
//     if (officeNo == null || officeNo.isEmpty || officeNo == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.officeNumber == officeNo).toList();
//     }
//   }
//
//   //filter by Location
//   List<AcLogData> acFilterDataByLocation(
//       List<AcLogData> data, String? location) {
//     if (location == null || location.isEmpty || location == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.location == location).toList();
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     acOutdoorData = fetchAcOutdoorData();
//     acIndoorData = fetchAcIndoorData();
//     acLogData = fetchAcLogData();
//     acLogData = fetchAcLogData().then((data) {
//       setState(() {
//         updateNestedLocationData(data);
//         debugPrint("send log data");
//       });
//       return data;
//     });
//
//     debugPrint(nestedLocationData.toString());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('AC Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Region:",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//                 ),
//                 DropdownButton<String>(
//                   hint: Text('Select Region'),
//                   value: selectedRegion,
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       selectedRegion = newValue;
//                       selectedRtom = 'ALL';
//                       selectedStation = 'ALL';
//                       selectedBuildingId = 'ALL';
//                       selectedFlowNo = 'ALL';
//                       selectedOfficeNo = 'ALL';
//                       selectedLocation = 'ALL';
//                       // Reset selections
//                     });
//                   },
//                   items: (['ALL', ...nestedLocationData.keys])
//                       .map<DropdownMenuItem<String>>((String? value) {
//                     return DropdownMenuItem<String>(
//                       value: value!,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                 ),
//               ],
//             ),
//
//             //rtom
//             Align(
//               alignment: Alignment.centerLeft,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       "RTOM  :",
//                       style:
//                       TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//                     ),
//                     DropdownButton<String>(
//                       hint: Text('RTOM'),
//                       value: selectedRtom,
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedRtom = newValue;
//                           selectedStation = 'ALL';
//                           selectedBuildingId = 'ALL';
//                           selectedFlowNo = 'ALL';
//                           selectedOfficeNo = 'ALL';
//                           selectedLocation = 'ALL';
//                         });
//                       },
//                       items: selectedRegion != null &&
//                           nestedLocationData[selectedRegion] != null
//                           ? ([
//                         'ALL',
//                         ...nestedLocationData[selectedRegion]!.keys
//                       ]).map((String? value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value!),
//                         );
//                       }).toList()
//                           : [],
//                     ),
//                     //station
//                     //Spacer(),
//                     SizedBox(
//                       width: 85,
//                     ),
//                     Text(
//                       "STATION  :",
//                       style:
//                       TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//                     ),
//                     DropdownButton<String>(
//                       hint: Text('Station'),
//                       value: selectedStation,
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedStation = newValue;
//                           selectedBuildingId = 'ALL';
//                           selectedFlowNo = 'ALL';
//                           selectedOfficeNo = 'ALL';
//                           selectedLocation = 'ALL';
//                         });
//                       },
//                       items: selectedRtom != null &&
//                           nestedLocationData[selectedRegion]
//                           ?[selectedRtom] !=
//                               null
//                           ? ([
//                         'ALL',
//                         ...nestedLocationData[selectedRegion!]![
//                         selectedRtom]!
//                             .keys
//                       ]).map((String? value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value!),
//                         );
//                       }).toList()
//                           : [],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             //station
//             Align(
//               alignment: Alignment.centerLeft,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       "BUILDING  :",
//                       style:
//                       TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//                     ),
//                     DropdownButton<String>(
//                       hint: Text('Building'),
//                       value: selectedBuildingId,
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedBuildingId = newValue;
//                           selectedFlowNo = 'ALL';
//                           selectedOfficeNo = 'ALL';
//                           selectedLocation = 'ALL';
//                         });
//                       },
//                       items: selectedStation != null &&
//                           nestedLocationData[selectedRegion]?[selectedRtom]
//                           ?[selectedStation] !=
//                               null
//                           ? ([
//                         'ALL',
//                         ...nestedLocationData[selectedRegion!]![
//                         selectedRtom]![selectedStation]!
//                             .keys
//                       ]).map((String? value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value!),
//                         );
//                       }).toList()
//                           : [],
//                     ),
//                     SizedBox(
//                       width: 40,
//                     ),
//                     //Spacer(),
//                     Text(
//                       "FLOW  :",
//                       style:
//                       TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//                     ),
//                     DropdownButton<String>(
//                       hint: Text('Flow'),
//                       value: selectedFlowNo,
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedFlowNo = newValue;
//                           selectedOfficeNo = 'ALL';
//                           selectedLocation = 'ALL';
//                         });
//                       },
//                       items: selectedBuildingId != null &&
//                           nestedLocationData[selectedRegion]?[selectedRtom]
//                           ?[selectedStation]?[selectedBuildingId] !=
//                               null
//                           ? ([
//                         'ALL',
//                         ...nestedLocationData[selectedRegion!]![
//                         selectedRtom]![selectedStation]![
//                         selectedBuildingId]!
//                             .keys
//                       ]).map((String? value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value!),
//                         );
//                       }).toList()
//                           : [],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     "OFFICE NO  :",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//                   ),
//                   DropdownButton<String>(
//                     hint: Text('Office No'),
//                     value: selectedOfficeNo,
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         selectedOfficeNo = newValue;
//                         selectedLocation = 'ALL';
//                       });
//                     },
//                     items: selectedFlowNo != null &&
//                         nestedLocationData[selectedRegion]?[selectedRtom]
//                         ?[selectedStation]?[selectedBuildingId]
//                         ?[selectedFlowNo] !=
//                             null
//                         ? ([
//                       'ALL',
//                       ...nestedLocationData[selectedRegion!]![
//                       selectedRtom]![selectedStation]![
//                       selectedBuildingId]![selectedFlowNo]!
//                           .keys
//                     ]).map((String? value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value!),
//                       );
//                     }).toList()
//                         : [],
//                   ),
//                   SizedBox(
//                     width: 22,
//                   ),
//                   Text(
//                     "LOCATION  :",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//                   ),
//                   DropdownButton<String>(
//                     hint: Text('Location'),
//                     value: selectedLocation,
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         selectedLocation = newValue;
//                       });
//                     },
//                     items: selectedOfficeNo != null &&
//                         nestedLocationData[selectedRegion]?[selectedRtom]
//                         ?[selectedStation]?[selectedBuildingId]
//                         ?[selectedFlowNo]?[selectedOfficeNo] !=
//                             null
//                         ? ([
//                       'ALL',
//                       nestedLocationData[selectedRegion!]![selectedRtom]![
//                       selectedStation]![selectedBuildingId]![
//                       selectedFlowNo]![selectedOfficeNo]!
//                     ]).map((String? value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value!),
//                       );
//                     }).toList()
//                         : [],
//                   ),
//                 ],
//               ),
//             ),
//
//
//
//             Expanded(
//               child: FutureBuilder<List<dynamic>>(
//                 future: Future.wait([acIndoorData, acOutdoorData, acLogData]),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (!snapshot.hasData ||
//                       (snapshot.data![0] as List).isEmpty ||
//                       (snapshot.data![1] as List).isEmpty ||
//                       (snapshot.data![2] as List).isEmpty) {
//                     return Center(child: Text('No data available'));
//                   } else {
//                     List<AcIndoorData> indoorDataList =
//                     snapshot.data![0] as List<AcIndoorData>;
//                     List<AcOutdoorData> outdoorDataList =
//                     snapshot.data![1] as List<AcOutdoorData>;
//                     List<AcLogData> logDataList =
//                     snapshot.data![2] as List<AcLogData>;
//
//                     logDataList =
//                         acFilterDataByRegion(logDataList, selectedRegion);
//                     logDataList = acFilterDataByRtom(logDataList, selectedRtom);
//                     logDataList =
//                         acFilterDataByStation(logDataList, selectedStation);
//                     logDataList = acFilterDataByBuildingId(
//                         logDataList, selectedBuildingId);
//                     logDataList =
//                         acFilterDataByFlowNo(logDataList, selectedFlowNo);
//
//                     logDataList =
//                         acFilterDataByOficeNo(logDataList, selectedOfficeNo);
//                     logDataList =
//                         acFilterDataByLocation(logDataList, selectedLocation);
//
//                     // indoorDataList.sort(
//                     //     (a, b) => b.lastUpdated!.compareTo(a.lastUpdated!));
//
//                     if (indoorDataList.isEmpty) {
//                       return Center(
//                           child: Text(
//                               'No data available for the selected region'));
//                     }
//
//                     return ListView.builder(
//                       itemCount: logDataList.length,
//                       itemBuilder: (context, index) {
//                         AcLogData logData = logDataList[index];
//                         debugPrint(" INDOOR ID ${logData.acIndoorId}");
//
//                         AcIndoorData? indoorData;
//                         AcOutdoorData? outdoorData;
//
//                         // Check if acIndoorId is not null and try to find the corresponding indoorData
//                         if (logData.acIndoorId != null &&
//                             logData.acIndoorId.isNotEmpty) {
//                           try {
//                             indoorData = indoorDataList.firstWhere((indoor) =>
//                             int.parse(indoor.acIndoorId) ==
//                                 int.parse(logData.acIndoorId));
//                             debugPrint(logData.acIndoorId);
//                           } catch (e) {
//                             debugPrint(
//                                 'No suitable logData found for ${logData.acIndoorId}');
//                             indoorData =
//                             null; // Set indoorData to null explicitly
//                           }
//                         } else {
//                           debugPrint(
//                               'Skipping logData with null or empty acIndoorId');
//                         }
//
//                         // Check if acOutdoorId is not null and try to find the corresponding outdoorData
//                         if (logData.acOutdoorId != null &&
//                             logData.acOutdoorId.isNotEmpty) {
//                           if (indoorData != null) {
//                             try {
//                               outdoorData = outdoorDataList.firstWhere(
//                                       (outdoor) =>
//                                   int.parse(outdoor.acOutdoorId!) ==
//                                       int.parse(logData.acOutdoorId));
//                               debugPrint(logData.acOutdoorId);
//                             } catch (e) {
//                               debugPrint(
//                                   'No suitable outdoorData found for ${logData.acOutdoorId}');
//                               outdoorData =
//                               null; // Set outdoorData to null explicitly
//                             }
//                           }
//                         } else {
//                           debugPrint(
//                               'Skipping logData with null or empty acOutdoorId');
//                         }
//
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ViewComfortACUnit(
//                                   outdoorData: outdoorData,
//                                   logData: logData,
//                                   indoorData: indoorData,
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Card(
//
//                             elevation: 4, // Adds a subtle shadow
//                             color: Colors.white, // Card background color
//
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15), // Rounded corners
//                             ),
//
//                             child: ListTile(
//                               hoverColor: Colors.blue.withOpacity(0.1), // Blue hover effect
//
//                               title: Text('Region: ${logData.region ?? ""}'),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Location: ${logData.location ?? ""}'),
//                                   Text(
//                                       'AC ID: ${indoorData?.qrIn ?? "N/A"}'),
//                                   Text(
//                                       'Capacity: ${indoorData?.capacity ?? "N/A"}'),
//                                   Text('Brand: ${indoorData?.brand ?? "N/A"}'),
//                                   Text(
//                                       'Last Updated: ${indoorData?.lastUpdated ?? "N/A"}'),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
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
//



//v1
// import 'package:flutter/material.dart';
//
// import 'SelectComfortACUnit.dart';
// import 'ViewComfortACUnit.dart';
// import 'ac_details_model.dart';
// import 'httpGetComfortACdetails.dart';
// // import 'package:ups_inspection/AC/Comfort%20Ac/ac_network.dart'; // Adjust import path as per your project structure
//
// class SelectComfortACUnit extends StatefulWidget {
//   const SelectComfortACUnit({Key? key}) : super(key: key);
//
//   @override
//   _SelectComfortACUnitState createState() => _SelectComfortACUnitState();
// }
//
// class _SelectComfortACUnitState extends State<SelectComfortACUnit> {
//   late Future<List<AcIndoorData>> acIndoorData;
//   late Future<List<AcOutdoorData>> acOutdoorData;
//   late Future<List<AcLogData>> acLogData;
//
//   String? selectedRegion = 'ALL';
//   String? selectedRtom = 'ALL';
//   String? selectedStation = 'ALL';
//   String? selectedBuildingId = 'ALL';
//   String? selectedFlowNo = 'ALL';
//   String? selectedOfficeNo = 'ALL';
//   String? selectedLocation = 'ALL';
//
//   // var regions = [
//   //   'ALL',
//   //   'Colombo',
//   //   'Gampaha',
//   //   'Kandy',
//   //   'Jaffna',
//   //   'Galle',
//   //   // Add more regions as needed
//   // ];
//
//   Map<
//           String?,
//           Map<String?,
//               Map<String?, Map<String?, Map<String?, Map<String?, String?>>>>>>
//       nestedLocationData = {};
//
//   void updateNestedLocationData(List<AcLogData> data) {
//     for (var item in data) {
//       // nestedLocationData[item.region] ??= {};
//       // nestedLocationData[item.region]![item.rtom] ??= {};
//       // nestedLocationData[item.region]![item.rtom]![item.station] ??= {};
//       // nestedLocationData[item.region]![item.rtom]![item.station]![
//       //     item.rtomBuildingId] ??= {};
//       // nestedLocationData[item.region]![item.rtom]![item.station]![
//       //     item.rtomBuildingId]![item.floorNumber] ??= {};
//       // nestedLocationData[item.region]![item.rtom]![item.station]![
//       //         item.rtomBuildingId]![item.floorNumber]![item.officeNumber] =
//       //     item.location;
//       // Use null-coalescing operator to provide default values for null properties
//       String region = item.region ?? '';
//       String rtom = item.rtom ?? '';
//       String station = item.station ?? '';
//       String rtomBuildingId = item.rtomBuildingId ?? '';
//       String floorNumber = item.floorNumber ?? '';
//       String officeNumber = item.officeNumber ?? '';
//       String location = item.location ?? '';
//
//       nestedLocationData[region] ??= {};
//       nestedLocationData[region]![rtom] ??= {};
//       nestedLocationData[region]![rtom]![station] ??= {};
//       nestedLocationData[region]![rtom]![station]![rtomBuildingId] ??= {};
//       nestedLocationData[region]![rtom]![station]![rtomBuildingId]![
//           floorNumber] ??= {};
//       nestedLocationData[region]![rtom]![station]![rtomBuildingId]![
//           floorNumber]![officeNumber] = location;
//     }
//     debugPrint('Nested Location Data: $nestedLocationData');
//   }
//
//   List<AcLogData> acFilterDataByRegion(List<AcLogData> data, String? region) {
//     if (region == null || region.isEmpty || region == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.region == region).toList();
//     }
//   }
//
// //filter by Rtom
//   List<AcLogData> acFilterDataByRtom(List<AcLogData> data, String? rtom) {
//     if (rtom == null || rtom.isEmpty || rtom == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.rtom == rtom).toList();
//     }
//   }
//
//   //filter by Station
//
//   //filter by Rtom
//   List<AcLogData> acFilterDataByStation(List<AcLogData> data, String? station) {
//     if (station == null || station.isEmpty || station == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.station == station).toList();
//     }
//   }
//
//   //filter by building id
//   List<AcLogData> acFilterDataByBuildingId(
//       List<AcLogData> data, String? buildingId) {
//     if (buildingId == null || buildingId.isEmpty || buildingId == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.rtomBuildingId == buildingId).toList();
//     }
//   }
//
//   //filter by flow no
//   List<AcLogData> acFilterDataByFlowNo(List<AcLogData> data, String? flowNo) {
//     if (flowNo == null || flowNo.isEmpty || flowNo == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.floorNumber == flowNo).toList();
//     }
//   }
//
//   //filter by Office No
//   List<AcLogData> acFilterDataByOficeNo(
//       List<AcLogData> data, String? officeNo) {
//     if (officeNo == null || officeNo.isEmpty || officeNo == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.officeNumber == officeNo).toList();
//     }
//   }
//
//   //filter by Location
//   List<AcLogData> acFilterDataByLocation(
//       List<AcLogData> data, String? location) {
//     if (location == null || location.isEmpty || location == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.location == location).toList();
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     acOutdoorData = fetchAcOutdoorData();
//     acIndoorData = fetchAcIndoorData();
//     acLogData = fetchAcLogData();
//     acLogData = fetchAcLogData().then((data) {
//       setState(() {
//         updateNestedLocationData(data);
//         debugPrint("send log data");
//       });
//       return data;
//     });
//
//     debugPrint(nestedLocationData.toString());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('AC Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Region:",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//                 ),
//                 DropdownButton<String>(
//                   hint: Text('Select Region'),
//                   value: selectedRegion,
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       selectedRegion = newValue;
//                       selectedRtom = 'ALL';
//                       selectedStation = 'ALL';
//                       selectedBuildingId = 'ALL';
//                       selectedFlowNo = 'ALL';
//                       selectedOfficeNo = 'ALL';
//                       selectedLocation = 'ALL';
//                       // Reset selections
//                     });
//                   },
//                   items: (['ALL', ...nestedLocationData.keys])
//                       .map<DropdownMenuItem<String>>((String? value) {
//                     return DropdownMenuItem<String>(
//                       value: value!,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                 ),
//               ],
//             ),
//
//             //rtom
//             Align(
//               alignment: Alignment.centerLeft,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       "RTOM  :",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//                     ),
//                     DropdownButton<String>(
//                       hint: Text('RTOM'),
//                       value: selectedRtom,
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedRtom = newValue;
//                           selectedStation = 'ALL';
//                           selectedBuildingId = 'ALL';
//                           selectedFlowNo = 'ALL';
//                           selectedOfficeNo = 'ALL';
//                           selectedLocation = 'ALL';
//                         });
//                       },
//                       items: selectedRegion != null &&
//                               nestedLocationData[selectedRegion] != null
//                           ? ([
//                               'ALL',
//                               ...nestedLocationData[selectedRegion]!.keys
//                             ]).map((String? value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value!),
//                               );
//                             }).toList()
//                           : [],
//                     ),
//                     //station
//                     //Spacer(),
//                     SizedBox(
//                       width: 85,
//                     ),
//                     Text(
//                       "STATION  :",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//                     ),
//                     DropdownButton<String>(
//                       hint: Text('Station'),
//                       value: selectedStation,
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedStation = newValue;
//                           selectedBuildingId = 'ALL';
//                           selectedFlowNo = 'ALL';
//                           selectedOfficeNo = 'ALL';
//                           selectedLocation = 'ALL';
//                         });
//                       },
//                       items: selectedRtom != null &&
//                               nestedLocationData[selectedRegion]
//                                       ?[selectedRtom] !=
//                                   null
//                           ? ([
//                               'ALL',
//                               ...nestedLocationData[selectedRegion!]![
//                                       selectedRtom]!
//                                   .keys
//                             ]).map((String? value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value!),
//                               );
//                             }).toList()
//                           : [],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             //station
//             Align(
//               alignment: Alignment.centerLeft,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       "BUILDING  :",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//                     ),
//                     DropdownButton<String>(
//                       hint: Text('Building'),
//                       value: selectedBuildingId,
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedBuildingId = newValue;
//                           selectedFlowNo = 'ALL';
//                           selectedOfficeNo = 'ALL';
//                           selectedLocation = 'ALL';
//                         });
//                       },
//                       items: selectedStation != null &&
//                               nestedLocationData[selectedRegion]?[selectedRtom]
//                                       ?[selectedStation] !=
//                                   null
//                           ? ([
//                               'ALL',
//                               ...nestedLocationData[selectedRegion!]![
//                                       selectedRtom]![selectedStation]!
//                                   .keys
//                             ]).map((String? value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value!),
//                               );
//                             }).toList()
//                           : [],
//                     ),
//                     SizedBox(
//                       width: 40,
//                     ),
//                     //Spacer(),
//                     Text(
//                       "FLOW  :",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//                     ),
//                     DropdownButton<String>(
//                       hint: Text('Flow'),
//                       value: selectedFlowNo,
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedFlowNo = newValue;
//                           selectedOfficeNo = 'ALL';
//                           selectedLocation = 'ALL';
//                         });
//                       },
//                       items: selectedBuildingId != null &&
//                               nestedLocationData[selectedRegion]?[selectedRtom]
//                                       ?[selectedStation]?[selectedBuildingId] !=
//                                   null
//                           ? ([
//                               'ALL',
//                               ...nestedLocationData[selectedRegion!]![
//                                           selectedRtom]![selectedStation]![
//                                       selectedBuildingId]!
//                                   .keys
//                             ]).map((String? value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value!),
//                               );
//                             }).toList()
//                           : [],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     "OFFICE NO  :",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//                   ),
//                   DropdownButton<String>(
//                     hint: Text('Office No'),
//                     value: selectedOfficeNo,
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         selectedOfficeNo = newValue;
//                         selectedLocation = 'ALL';
//                       });
//                     },
//                     items: selectedFlowNo != null &&
//                             nestedLocationData[selectedRegion]?[selectedRtom]
//                                         ?[selectedStation]?[selectedBuildingId]
//                                     ?[selectedFlowNo] !=
//                                 null
//                         ? ([
//                             'ALL',
//                             ...nestedLocationData[selectedRegion!]![
//                                         selectedRtom]![selectedStation]![
//                                     selectedBuildingId]![selectedFlowNo]!
//                                 .keys
//                           ]).map((String? value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value!),
//                             );
//                           }).toList()
//                         : [],
//                   ),
//                   SizedBox(
//                     width: 22,
//                   ),
//                   Text(
//                     "LOCATION  :",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//                   ),
//                   DropdownButton<String>(
//                     hint: Text('Location'),
//                     value: selectedLocation,
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         selectedLocation = newValue;
//                       });
//                     },
//                     items: selectedOfficeNo != null &&
//                             nestedLocationData[selectedRegion]?[selectedRtom]
//                                         ?[selectedStation]?[selectedBuildingId]
//                                     ?[selectedFlowNo]?[selectedOfficeNo] !=
//                                 null
//                         ? ([
//                             'ALL',
//                             nestedLocationData[selectedRegion!]![selectedRtom]![
//                                     selectedStation]![selectedBuildingId]![
//                                 selectedFlowNo]![selectedOfficeNo]!
//                           ]).map((String? value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value!),
//                             );
//                           }).toList()
//                         : [],
//                   ),
//                 ],
//               ),
//             ),
//
//             // //flow
//             // SingleChildScrollView(
//             //   scrollDirection: Axis.horizontal,
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //     children: [],
//             //   ),
//             // ),
//
//             // //office no
//             // SingleChildScrollView(
//             //   scrollDirection: Axis.horizontal,
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //     children: [],
//             //   ),
//             // ),
//
//             // //location
//             // SingleChildScrollView(
//             //   scrollDirection: Axis.horizontal,
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //     children: [],
//             //   ),
//             // ),
//             // Row(
//             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //   children: [
//             //     Text(
//             //       "Region:",
//             //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//             //     ),
//             //     DropdownButton<String>(
//             //       hint: Text('Select Region'),
//             //       value: selectedRegion,
//             //       onChanged: (String? newValue) {
//             //         setState(() {
//             //           selectedRegion = newValue;
//             //           selectedRtom = 'ALL';
//             //           selectedStation = 'ALL';
//             //           selectedBuildingId = 'ALL';
//             //           selectedFlowNo = 'ALL';
//             //           selectedOfficeNo = 'ALL';
//             //           selectedLocation = 'ALL';
//             //           // Reset selections
//
//             //           debugPrint('Selected Region: $selectedRegion');
//             //         });
//             //       },
//             //       items: (['ALL', ...nestedLocationData.keys])
//             //           .map<DropdownMenuItem<String>>((String? value) {
//             //         return DropdownMenuItem<String>(
//             //           value: value!,
//             //           child: Text(value),
//             //         );
//             //       }).toList(),
//             //     ),
//             //   ],
//             // ),
//             // SizedBox(height: 10),
//             // SingleChildScrollView(
//             //   scrollDirection: Axis.horizontal,
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //     children: [
//             //       Text(
//             //         "RTOM  :",
//             //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//             //       ),
//             //       DropdownButton<String>(
//             //         hint: Text('RTOM'),
//             //         value: selectedRtom,
//             //         onChanged: (String? newValue) {
//             //           setState(() {
//             //             selectedRtom = newValue;
//             //             selectedStation = 'ALL';
//             //             selectedBuildingId = 'ALL';
//             //             selectedFlowNo = 'ALL';
//             //             selectedOfficeNo = 'ALL';
//             //             selectedLocation = 'ALL';
//             //             debugPrint('Selected Location: $selectedLocation');
//             //           });
//             //         },
//             //         items: selectedRegion != null &&
//             //                 nestedLocationData[selectedRegion] != null
//             //             ? (['ALL', ...nestedLocationData[selectedRegion]!.keys])
//             //                 .map((String? value) {
//             //                 return DropdownMenuItem<String>(
//             //                   value: value,
//             //                   child: Text(value!),
//             //                 );
//             //               }).toList()
//             //             : [],
//             //       ),
//             //     ],
//             //   ),
//             // ),
//
//             // //station
//             // SingleChildScrollView(
//             //   scrollDirection: Axis.horizontal,
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //     children: [
//             //       Text(
//             //         "STATION  :",
//             //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//             //       ),
//             //       DropdownButton<String>(
//             //         hint: Text('Station'),
//             //         value: selectedStation,
//             //         onChanged: (String? newValue) {
//             //           setState(() {
//             //             selectedStation = newValue;
//             //             selectedBuildingId = 'ALL';
//             //             selectedFlowNo = 'ALL';
//             //             selectedOfficeNo = 'ALL';
//             //             selectedLocation = 'ALL';
//             //           });
//             //         },
//             //         items: selectedRtom != null &&
//             //                 nestedLocationData[selectedRegion]![selectedRtom] !=
//             //                     null
//             //             ? ([
//             //                 'ALL',
//             //                 ...nestedLocationData[selectedRegion!]![
//             //                         selectedRtom]!
//             //                     .keys
//             //               ]).map((String? value) {
//             //                 return DropdownMenuItem<String>(
//             //                   value: value,
//             //                   child: Text(value!),
//             //                 );
//             //               }).toList()
//             //             : [],
//             //       ),
//             //     ],
//             //   ),
//             // ),
//
//             // //building id
//             // SingleChildScrollView(
//             //   scrollDirection: Axis.horizontal,
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //     children: [
//             //       Text(
//             //         "RTOM Buildin ID  :",
//             //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//             //       ),
//             //       DropdownButton<String>(
//             //         hint: Text('RTOM Buildin ID'),
//             //         value: selectedBuildingId,
//             //         onChanged: (String? newValue) {
//             //           setState(() {
//             //             selectedBuildingId = newValue;
//             //             selectedFlowNo = 'ALL';
//             //             selectedOfficeNo = 'ALL';
//             //             selectedLocation = 'ALL';
//             //           });
//             //         },
//             //         items: selectedStation != null &&
//             //                 nestedLocationData[selectedRegion]![selectedRtom]![
//             //                         selectedRegion] !=
//             //                     null
//             //             ? ([
//             //                 'ALL',
//             //                 ...nestedLocationData[selectedRegion]![
//             //                         selectedRtom]![selectedStation]!
//             //                     .keys
//             //               ]).map((String? value) {
//             //                 return DropdownMenuItem<String>(
//             //                   value: value,
//             //                   child: Text(value!),
//             //                 );
//             //               }).toList()
//             //             : [],
//             //       ),
//             //     ],
//             //   ),
//             // ),
//
//             // //Flow No
//             // SingleChildScrollView(
//             //   scrollDirection: Axis.horizontal,
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //     children: [
//             //       Text(
//             //         "Flow No  :",
//             //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//             //       ),
//             //       DropdownButton<String>(
//             //         hint: Text('Flow No'),
//             //         value: selectedFlowNo,
//             //         onChanged: (String? newValue) {
//             //           setState(() {
//             //             selectedFlowNo = newValue;
//             //             selectedOfficeNo = 'ALL';
//             //             selectedLocation = 'ALL';
//             //           });
//             //         },
//             //         items: selectedBuildingId != null &&
//             //                 nestedLocationData[selectedRegion]![selectedRtom]![
//             //                         selectedRegion]![selectedBuildingId] !=
//             //                     null
//             //             ? ([
//             //                 'ALL',
//             //                 ...nestedLocationData[selectedRegion]![
//             //                             selectedRtom]![selectedStation]![
//             //                         selectedBuildingId]!
//             //                     .keys
//             //               ]).map((String? value) {
//             //                 return DropdownMenuItem<String>(
//             //                   value: value,
//             //                   child: Text(value!),
//             //                 );
//             //               }).toList()
//             //             : [],
//             //       ),
//             //     ],
//             //   ),
//             // ),
//
//             // //office no
//             // SingleChildScrollView(
//             //   scrollDirection: Axis.horizontal,
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //     children: [
//             //       Text(
//             //         "OFFICE NO :",
//             //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//             //       ),
//             //       DropdownButton<String>(
//             //         hint: Text("Office"),
//             //         value: selectedOfficeNo,
//             //         onChanged: (String? newValue) {
//             //           setState(() {
//             //             selectedOfficeNo = newValue;
//             //             selectedLocation = 'ALL';
//             //           });
//             //         },
//             //         items: selectedOfficeNo != null &&
//             //                 nestedLocationData[selectedRegion]![selectedRtom]![
//             //                             selectedRegion]![selectedBuildingId]![
//             //                         selectedFlowNo] !=
//             //                     null
//             //             ? ([
//             //                 'ALL',
//             //                 ...nestedLocationData[selectedRegion]![
//             //                             selectedRtom]![selectedStation]![
//             //                         selectedBuildingId]![selectedFlowNo]!
//             //                     .keys
//             //               ]).map((String? value) {
//             //                 return DropdownMenuItem<String>(
//             //                   value: value,
//             //                   child: Text(value!),
//             //                 );
//             //               }).toList()
//             //             : [],
//             //       ),
//             //     ],
//             //   ),
//             // ),
//
//             // //location
//             // SingleChildScrollView(
//             //   scrollDirection: Axis.horizontal,
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //     children: [
//             //       Text(
//             //         "LOCATION :",
//             //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//             //       ),
//             //       DropdownButton<String>(
//             //         hint: Text("Location"),
//             //         value: selectedLocation,
//             //         onChanged: (String? newValue) {
//             //           setState(() {
//             //             selectedLocation = newValue;
//             //           });
//             //         },
//             //         items: selectedOfficeNo != null &&
//             //                 nestedLocationData[selectedRegion]?[selectedRtom]
//             //                             ?[selectedStation]?[selectedBuildingId]
//             //                         ?[selectedFlowNo]?[selectedOfficeNo] !=
//             //                     null
//             //             ? ([
//             //                 'ALL',
//             //                 nestedLocationData[selectedRegion]![selectedRtom]![
//             //                         selectedStation]![selectedBuildingId]![
//             //                     selectedFlowNo]![selectedOfficeNo]!
//             //               ]).map((String? value) {
//             //                 return DropdownMenuItem<String>(
//             //                   value: value,
//             //                   child: Text(value!),
//             //                 );
//             //               }).toList()
//             //             : [],
//             //       ),
//             //     ],
//             //   ),
//             // ),
//
//             Expanded(
//               child: FutureBuilder<List<dynamic>>(
//                 future: Future.wait([acIndoorData, acOutdoorData, acLogData]),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (!snapshot.hasData ||
//                       (snapshot.data![0] as List).isEmpty ||
//                       (snapshot.data![1] as List).isEmpty ||
//                       (snapshot.data![2] as List).isEmpty) {
//                     return Center(child: Text('No data available'));
//                   } else {
//                     List<AcIndoorData> indoorDataList =
//                         snapshot.data![0] as List<AcIndoorData>;
//                     List<AcOutdoorData> outdoorDataList =
//                         snapshot.data![1] as List<AcOutdoorData>;
//                     List<AcLogData> logDataList =
//                         snapshot.data![2] as List<AcLogData>;
//
//                     logDataList =
//                         acFilterDataByRegion(logDataList, selectedRegion);
//                     logDataList = acFilterDataByRtom(logDataList, selectedRtom);
//                     logDataList =
//                         acFilterDataByStation(logDataList, selectedStation);
//                     logDataList = acFilterDataByBuildingId(
//                         logDataList, selectedBuildingId);
//                     logDataList =
//                         acFilterDataByFlowNo(logDataList, selectedFlowNo);
//
//                     logDataList =
//                         acFilterDataByOficeNo(logDataList, selectedOfficeNo);
//                     logDataList =
//                         acFilterDataByLocation(logDataList, selectedLocation);
//
//                     // indoorDataList.sort(
//                     //     (a, b) => b.lastUpdated!.compareTo(a.lastUpdated!));
//
//                     if (indoorDataList.isEmpty) {
//                       return Center(
//                           child: Text(
//                               'No data available for the selected region'));
//                     }
//
//                     return ListView.builder(
//                       itemCount: logDataList.length,
//                       itemBuilder: (context, index) {
//                         AcLogData logData = logDataList[index];
//                         debugPrint(" INDOOR ID ${logData.acIndoorId}");
//
//                         AcIndoorData? indoorData;
//                         AcOutdoorData? outdoorData;
//
//                         // Check if acIndoorId is not null and try to find the corresponding indoorData
//                         if (logData.acIndoorId != null &&
//                             logData.acIndoorId.isNotEmpty) {
//                           try {
//                             indoorData = indoorDataList.firstWhere((indoor) =>
//                                 int.parse(indoor.acIndoorId) ==
//                                 int.parse(logData.acIndoorId));
//                             debugPrint(logData.acIndoorId);
//                           } catch (e) {
//                             debugPrint(
//                                 'No suitable logData found for ${logData.acIndoorId}');
//                             indoorData =
//                                 null; // Set indoorData to null explicitly
//                           }
//                         } else {
//                           debugPrint(
//                               'Skipping logData with null or empty acIndoorId');
//                         }
//
//                         // Check if acOutdoorId is not null and try to find the corresponding outdoorData
//                         if (logData.acOutdoorId != null &&
//                             logData.acOutdoorId.isNotEmpty) {
//                           if (indoorData != null) {
//                             try {
//                               outdoorData = outdoorDataList.firstWhere(
//                                   (outdoor) =>
//                                       int.parse(outdoor.acOutdoorId!) ==
//                                       int.parse(logData.acOutdoorId));
//                               debugPrint(logData.acOutdoorId);
//                             } catch (e) {
//                               debugPrint(
//                                   'No suitable outdoorData found for ${logData.acOutdoorId}');
//                               outdoorData =
//                                   null; // Set outdoorData to null explicitly
//                             }
//                           }
//                         } else {
//                           debugPrint(
//                               'Skipping logData with null or empty acOutdoorId');
//                         }
//
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ViewComfortACUnit(
//                                   outdoorData: outdoorData,
//                                   logData: logData,
//                                   indoorData: indoorData,
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Card(
//                             child: ListTile(
//                               title: Text('Region: ${logData.region ?? ""}'),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Location: ${logData.location ?? ""}'),
//                                   Text(
//                                       'AC ID: ${indoorData?.acIndoorId ?? "N/A"}'),
//                                   Text(
//                                       'Capacity: ${indoorData?.capacity ?? "N/A"}'),
//                                   Text('Brand: ${indoorData?.brand ?? "N/A"}'),
//                                   Text(
//                                       'Last Updated: ${indoorData?.lastUpdated ?? "N/A"}'),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
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
