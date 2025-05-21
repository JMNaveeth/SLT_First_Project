import 'package:flutter/material.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/utils/utils/colors.dart';

//import '../../../HomePage/widgets/colors.dart';
import 'DEGInspectionViewData.dart';
import 'deg_inspection_data.dart';
import 'httpGetDEGInspectionData.dart';

class DEGInspectionViewSelect extends StatefulWidget {
  @override
  _DEGInspectionViewSelectState createState() =>
      _DEGInspectionViewSelectState();
}

class _DEGInspectionViewSelectState extends State<DEGInspectionViewSelect> {
  late Future<List<DegInspectionData>> degInspectionData;
  late Future<List<DegRemarkData>> degRemarkData;
  late Future<List<DEGDetails>> degDetails;
  String? selectedRegion = 'ALL';
  String? checkByPerson = 'ALL';
  var locations = ["SLT-HQ", "SLT-WALIKADA"];
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
  Map<String, Set<String>> regionSubmitters = {};

  List<DegInspectionData> degFilterDataByRegion(
    List<DegInspectionData> data,
    String? location,
  ) {
    if (location == null || location.isEmpty || location == 'ALL') {
      return data;
    } else {
      return data
          .where((item) => item.region.split('-')[0] == location)
          .toList();
    }
  }

  List<DegInspectionData> degFilterDataByPerson(
    List<DegInspectionData> data,
    String? person,
  ) {
    if (person == null || person.isEmpty || person == 'ALL') {
      return data;
    } else {
      return data.where((item) => item.username == person).toList();
    }
  }

  DegRemarkData? getRemarkForInspection(
    List<DegRemarkData> remarks,
    String remarkId,
  ) {
    try {
      return remarks.firstWhere(
        (remark) => remark.DailyDEGRemarkID == remarkId,
      );
    } catch (e) {
      return null;
    }
  }

  DEGDetails? getRectifierDetails(List<DEGDetails> degDetails, String recId) {
    try {
      return degDetails.firstWhere((details) => details.ID == recId);
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    degInspectionData = degFetchInspectionData().then((data) {
      setState(() {
        for (var item in data) {
          if (!regionSubmitters.containsKey(item.region)) {
            regionSubmitters[item.region] = {};
          }
          regionSubmitters[item.region]?.add('ALL');
          regionSubmitters[item.region]?.add(item.username);
        }
      });
      return data;
    });
    degRemarkData = degFetchRemarkData();
    degDetails = degDetailsFetchData();
    debugPrint(regionSubmitters.toString());
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: customColors.mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: customColors.appbarColor,
        title: Center(
          child: Text(
            'Inspection Data',
            style: TextStyle(color: customColors.mainTextColor),
          ),
        ),
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],

        iconTheme: IconThemeData(color: customColors.mainTextColor),
      ),

      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: customColors.mainBackgroundColor,
                  borderRadius: BorderRadius.circular(
                    8.0,
                  ), // Same radius as your input border
                  border: Border.all(
                    color: customColors.subTextColor, // Border color
                    width: 1, // Border width
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: customColors.subTextColor, // Shadow color
                      // Offset for the shadow (horizontal, vertical)
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
                  child: DropdownButton<String>(
                    hint: Text('Select Region'),
                    value: selectedRegion,
                    style: (TextStyle(color: customColors.mainTextColor)),
                    dropdownColor: customColors.suqarBackgroundColor,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRegion = newValue;
                        // checkByPerson =
                        //     null; // Reset person selection when region changes
                      });
                    },
                    items:
                        regions.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                  ),
                ),
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: customColors.mainBackgroundColor,
                  borderRadius: BorderRadius.circular(
                    8.0,
                  ), // Same radius as your input border
                  border: Border.all(
                    color: customColors.subTextColor, // Border color
                    width: 1, // Border width
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: customColors.subTextColor, // Shadow color
                      // Offset for the shadow (horizontal, vertical)
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
                  child: DropdownButton<String>(
                    hint: Text(
                      'Checked By',
                      style: (TextStyle(color: customColors.mainTextColor)),
                    ),
                    value: checkByPerson,
                    style: (TextStyle(color: customColors.mainTextColor)),
                    dropdownColor: customColors.suqarBackgroundColor,
                    onChanged: (String? newValue) {
                      setState(() {
                        checkByPerson = newValue;
                      });
                    },
                    items:
                        selectedRegion != null &&
                                regionSubmitters[selectedRegion] != null
                            ? regionSubmitters[selectedRegion]!.map((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList()
                            : [],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: Future.wait([
                degInspectionData,
                degRemarkData,
                degDetails,
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData ||
                    (snapshot.data![0] as List).isEmpty ||
                    (snapshot.data![1] as List).isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  List<DegInspectionData> inspectionDataList =
                      snapshot.data![0] as List<DegInspectionData>;
                  List<DegRemarkData> remarkDataList =
                      snapshot.data![1] as List<DegRemarkData>;
                  List<DEGDetails> degDetailsList =
                      snapshot.data![2] as List<DEGDetails>;

                  // Filter data based on selected region
                  inspectionDataList = degFilterDataByRegion(
                    inspectionDataList,
                    selectedRegion,
                  );

                  // Filter data based on selected person
                  inspectionDataList = degFilterDataByPerson(
                    inspectionDataList,
                    checkByPerson,
                  );

                  // Sort the filtered data in reverse order by clockTime
                  inspectionDataList.sort(
                    (a, b) => b.clockTime.compareTo(a.clockTime),
                  );

                  // Check if the filtered list is empty
                  if (inspectionDataList.isEmpty) {
                    return Center(
                      child: Text('No data available for the selected region'),
                    );
                  }

                  return ListView.builder(
                    itemCount: inspectionDataList.length,
                    itemBuilder: (context, index) {
                      DegInspectionData data = inspectionDataList[index];
                      DegRemarkData? filteredRemarkDataList =
                          getRemarkForInspection(
                            remarkDataList,
                            data.DailyDEGRemarkID,
                          );

                      DEGDetails? degDetails = getRectifierDetails(
                        degDetailsList,
                        data.degId,
                      );

                      // Check if filteredRemarkDataList is empty
                      if (filteredRemarkDataList == null) {
                        DegRemarkData? remark = filteredRemarkDataList;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => DegInspectionDetailsPage(
                                      inspectionData: data,
                                      remarkData: remark,
                                      degDetails: degDetails,
                                    ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ), // Margin around the container
                            decoration: BoxDecoration(
                              color:
                                  customColors
                                      .suqarBackgroundColor, // Background color of the ListTile
                              borderRadius: BorderRadius.circular(
                                8.0,
                              ), // Border radius
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      customColors.subTextColor, // Shadow color
                                  // Shadow position
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                'Date: ${data.clockTime}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: customColors.mainTextColor,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Text('Region: ${data.region}'),
                                  Text(
                                    '${degDetails!.brand_set} ',
                                    style: TextStyle(
                                      color: customColors.subTextColor,
                                    ),
                                  ),
                                  Text(
                                    'Location : ${data.region} | (${data.degId})',
                                    style: TextStyle(
                                      color: customColors.subTextColor,
                                    ),
                                  ),
                                  Text(
                                    'Shift: ${data.shift}',
                                    style: TextStyle(
                                      color: customColors.subTextColor,
                                    ),
                                  ),
                                  Text(
                                    'Checked By: ${data.username}',
                                    style: TextStyle(
                                      color: customColors.subTextColor,
                                    ),
                                  ),
                                  Text(
                                    'Remark: No remark available',
                                    style: TextStyle(
                                      color: customColors.subTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        DegRemarkData remark = filteredRemarkDataList;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => DegInspectionDetailsPage(
                                      inspectionData: data,
                                      remarkData: remark,
                                      degDetails: degDetails,
                                    ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ), // Margin around the container
                            decoration: BoxDecoration(
                              color:
                                  customColors
                                      .suqarBackgroundColor, // Background color of the ListTile
                              borderRadius: BorderRadius.circular(
                                8.0,
                              ), // Border radius
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      customColors.subTextColor, // Shadow color
                                  // Shadow position
                                ),
                              ],
                            ),

                            child: ListTile(
                              title: Text(
                                'Date: ${data.clockTime}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: customColors.mainTextColor,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Text('Region: ${data.region}'),
                                  Text(
                                    '${degDetails!.brand_set} ',
                                    style: TextStyle(
                                      color: customColors.subTextColor,
                                    ),
                                  ),
                                  Text(
                                    'Location : ${data.region}  | (${data.degId})',
                                    style: TextStyle(
                                      color: customColors.subTextColor,
                                    ),
                                  ),
                                  Text(
                                    'Shift: ${data.shift}',
                                    style: TextStyle(
                                      color: customColors.subTextColor,
                                    ),
                                  ),
                                  Text(
                                    'Checked By: ${data.username}',
                                    style: TextStyle(
                                      color: customColors.subTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

//v1
// import 'package:flutter/material.dart';
//
// import 'DEGInspectionViewData.dart';
// import 'deg_inspection_data.dart';
// import 'httpGetDEGInspectionData.dart';
//
//
//
// class DEGInspectionViewSelect extends StatefulWidget {
//   @override
//   _DEGInspectionViewSelectState createState() => _DEGInspectionViewSelectState();
// }
//
// class _DEGInspectionViewSelectState extends State<DEGInspectionViewSelect> {
//   late Future<List<DegInspectionData>> degInspectionData;
//   late Future<List<DegRemarkData>> degRemarkData;
//   late Future<List<DEGDetails>> degDetails;
//   String? selectedRegion = 'ALL';
//   String? checkByPerson = 'ALL';
//   var locations = ["SLT-HQ", "SLT-WALIKADA"];
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
//   Map<String, Set<String>> regionSubmitters = {};
//
//   List<DegInspectionData> degFilterDataByRegion(
//       List<DegInspectionData> data, String? location) {
//     if (location == null || location.isEmpty || location == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.region.split('-')[0] == location).toList();
//     }
//   }
//
//   List<DegInspectionData> degFilterDataByPerson(
//       List<DegInspectionData> data, String? person) {
//     if (person == null || person.isEmpty || person == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.username == person).toList();
//     }
//   }
//
//   DegRemarkData? getRemarkForInspection(
//       List<DegRemarkData> remarks, String remarkId) {
//     try {
//       return remarks.firstWhere((remark) => remark.DailyDEGRemarkID == remarkId);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   DEGDetails? getRectifierDetails(List<DEGDetails> degDetails, String recId) {
//     try {
//       return degDetails.firstWhere((details) => details.ID == recId);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     degInspectionData = degFetchInspectionData().then((data) {
//       setState(() {
//         for (var item in data) {
//           if (!regionSubmitters.containsKey(item.region)) {
//             regionSubmitters[item.region] = {};
//           }
//           regionSubmitters[item.region]?.add('ALL');
//           regionSubmitters[item.region]?.add(item.username);
//         }
//       });
//       return data;
//     });
//     degRemarkData = degFetchRemarkData();
//     degDetails = degDetailsFetchData();
//     debugPrint(regionSubmitters.toString());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Inspection Data'),
//       ),
//       body: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               DropdownButton<String>(
//                 hint: Text('Select Region'),
//                 value: selectedRegion,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     selectedRegion = newValue;
//                     // checkByPerson =
//                     //     null; // Reset person selection when region changes
//                   });
//                 },
//                 items: regions.map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//               DropdownButton<String>(
//                 hint: Text('Checked By'),
//                 value: checkByPerson,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     checkByPerson = newValue;
//                   });
//                 },
//                 items: selectedRegion != null &&
//                         regionSubmitters[selectedRegion] != null
//                     ? regionSubmitters[selectedRegion]!.map((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList()
//                     : [],
//               ),
//             ],
//           ),
//           Expanded(
//             child: FutureBuilder<List<dynamic>>(
//               future:
//                   Future.wait([degInspectionData, degRemarkData, degDetails]),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData ||
//                     (snapshot.data![0] as List).isEmpty ||
//                     (snapshot.data![1] as List).isEmpty) {
//                   return Center(child: Text('No data available'));
//                 } else {
//                   List<DegInspectionData> inspectionDataList =
//                       snapshot.data![0] as List<DegInspectionData>;
//                   List<DegRemarkData> remarkDataList =
//                       snapshot.data![1] as List<DegRemarkData>;
//                   List<DEGDetails> degDetailsList =
//                       snapshot.data![2] as List<DEGDetails>;
//
//                   // Filter data based on selected region
//                   inspectionDataList =
//                       degFilterDataByRegion(inspectionDataList, selectedRegion);
//
//                   // Filter data based on selected person
//                   inspectionDataList =
//                       degFilterDataByPerson(inspectionDataList, checkByPerson);
//
//                   // Sort the filtered data in reverse order by clockTime
//                   inspectionDataList
//                       .sort((a, b) => b.clockTime.compareTo(a.clockTime));
//
//                   // Check if the filtered list is empty
//                   if (inspectionDataList.isEmpty) {
//                     return Center(
//                         child:
//                             Text('No data available for the selected region'));
//                   }
//
//                   return ListView.builder(
//                     itemCount: inspectionDataList.length,
//                     itemBuilder: (context, index) {
//                       DegInspectionData data = inspectionDataList[index];
//                       DegRemarkData? filteredRemarkDataList =
//                           getRemarkForInspection(remarkDataList, data.DailyDEGRemarkID);
//
//                       DEGDetails? degDetails =
//                           getRectifierDetails(degDetailsList, data.degId);
//
//                       // Check if filteredRemarkDataList is empty
//                       if (filteredRemarkDataList == null) {
//                         DegRemarkData? remark = filteredRemarkDataList;
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => DegInspectionDetailsPage(
//                                   inspectionData: data,
//                                   remarkData: remark,
//                                   degDetails: degDetails,
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Card(
//                             child: ListTile(
//                               title: Text('Date: ${data.clockTime}'),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   //Text('Region: ${data.region}'),
//                                   Text(
//                                       '${degDetails!.brand_set} '),
//                                   Text(
//                                       'Location : ${data.region} | (${data.degId})'),
//                                   Text('Shift: ${data.shift}'),
//                                   Text('Checked By: ${data.username}'),
//                                   Text('Remark: No remark available'),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       } else {
//                         DegRemarkData remark = filteredRemarkDataList;
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => DegInspectionDetailsPage(
//                                   inspectionData: data,
//                                   remarkData: remark,
//                                   degDetails: degDetails,
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Card(
//                             child: ListTile(
//                               title: Text('Date: ${data.clockTime}'),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   //Text('Region: ${data.region}'),
//                                   Text(
//                                       '${degDetails!.brand_set} '),
//                                   Text(
//                                       'Location : ${data.region}  | (${data.degId})'),
//                                   Text('Shift: ${data.shift}'),
//                                   Text('Checked By: ${data.username}'),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       }
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
