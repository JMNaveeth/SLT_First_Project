import 'package:flutter/material.dart';
// import 'package:powerprox/Screens/Other%20Assets/Rectifier/RectifierInspectionView/rec_inspection_data.dart';
// import 'package:powerprox/Screens/Other%20Assets/Rectifier/RectifierInspectionView/rec_inspection_details_page.dart';
// import 'package:powerprox/Screens/Other%20Assets/Rectifier/RectifierInspectionView/rec_network_service.dart';
import 'package:theme_update/Rectifier/RectifierInspectionView/rec_inspection_data.dart';
import 'package:theme_update/Rectifier/RectifierInspectionView/rec_inspection_details_page.dart';
import 'package:theme_update/Rectifier/RectifierInspectionView/rec_network_service.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/utils/utils/colors.dart';

//import '../../../HomePage/widgets/colors.dart';

class RectifierInspectionViewSelect extends StatefulWidget {
  const RectifierInspectionViewSelect({super.key});

  @override
  _RectifierInspectionViewSelectState createState() =>
      _RectifierInspectionViewSelectState();
}

class _RectifierInspectionViewSelectState
    extends State<RectifierInspectionViewSelect> {
  late Future<List<RecInspectionData>> recInspectionData;
  late Future<List<RecRemarkData>> recRemarkData;
  late Future<List<RectifierDetails>> rectifierDetails;
  String? selectedRegion = 'ALL';
  String? checkByPerson = 'ALL';
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

  List<RecInspectionData> recFilterDataByRegion(
    List<RecInspectionData> data,
    String? region,
  ) {
    if (region == null || region.isEmpty || region == 'ALL') {
      return data;
    } else {
      return data.where((item) => item.region == region).toList();
    }
  }

  List<RecInspectionData> recFilterDataByPerson(
    List<RecInspectionData> data,
    String? person,
  ) {
    if (person == null || person.isEmpty || person == 'ALL') {
      return data;
    } else {
      return data.where((item) => item.userName == person).toList();
    }
  }

  RecRemarkData? getRemarkForInspection(
    List<RecRemarkData> remarks,
    String remarkId,
  ) {
    try {
      return remarks.firstWhere((remark) => remark.id == remarkId);
    } catch (e) {
      return null;
    }
  }

  RectifierDetails? getRectifierDetails(
    List<RectifierDetails> rectifierDetails,
    String recId,
  ) {
    try {
      return rectifierDetails.firstWhere((details) => details.recID == recId);
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    recInspectionData = recFetchInspectionData().then((data) {
      setState(() {
        for (var item in data) {
          if (!regionSubmitters.containsKey(item.region)) {
            regionSubmitters[item.region] = {};
          }
          regionSubmitters[item.region]?.add('ALL');
          regionSubmitters[item.region]?.add(item.userName);
        }
      });
      return data;
    });
    recRemarkData = recFetchRemarkData();
    rectifierDetails = rectifierDetailsFetchData();
    debugPrint(regionSubmitters.toString());
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inspection Data',
          style: TextStyle(color: customColors.mainTextColor),
        ),
        centerTitle: true,
        backgroundColor: customColors.appbarColor,
        iconTheme: IconThemeData(color: customColors.mainTextColor),
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),
      body: Container(
        // Wrap the Column with a Container
        color:
            customColors
                .mainBackgroundColor, // Or Colors.white for a hardcoded white
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton<String>(
                  hint: Text('Select Region'),
                  value: selectedRegion,
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
                          child: Text(
                            value,
                            style: TextStyle(color: customColors.subTextColor),
                          ),
                        );
                      }).toList(),
                ),
                DropdownButton<String>(
                  hint: Text(
                    'Checked By',
                    style: TextStyle(color: customColors.mainTextColor),
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
              ],
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: Future.wait([
                  recInspectionData,
                  recRemarkData,
                  rectifierDetails,
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
                    List<RecInspectionData> inspectionDataList =
                        snapshot.data![0] as List<RecInspectionData>;
                    List<RecRemarkData> remarkDataList =
                        snapshot.data![1] as List<RecRemarkData>;
                    List<RectifierDetails> rectifierDetailsList =
                        snapshot.data![2] as List<RectifierDetails>;

                    // Filter data based on selected region
                    inspectionDataList = recFilterDataByRegion(
                      inspectionDataList,
                      selectedRegion,
                    );

                    // Filter data based on selected person
                    inspectionDataList = recFilterDataByPerson(
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
                        child: Text(
                          'No data available for the selected region',
                        ),
                      );
                    }

                    return ListView.builder(
                      key: PageStorageKey(rectifierDetailsList),
                      itemCount: inspectionDataList.length,
                      itemBuilder: (context, index) {
                        RecInspectionData data = inspectionDataList[index];
                        RecRemarkData? filteredRemarkDataList =
                            getRemarkForInspection(
                              remarkDataList,
                              data.remarkId,
                            );
                        RectifierDetails? rectifierDetails =
                            getRectifierDetails(
                              rectifierDetailsList,
                              data.recId,
                            );

                        // Check if filteredRemarkDataList is empty
                        if (filteredRemarkDataList == null) {
                          RecRemarkData? remark = filteredRemarkDataList;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => RecInspectionDetailPage(
                                        inspectionData: data,
                                        remarkData: remark,
                                        rectifierDetails: rectifierDetails,
                                      ),
                                ),
                              );
                            },
                            child: Card(
                              color: customColors.suqarBackgroundColor,
                              child: ListTile(
                                title: Text(
                                  'Date: ${data.clockTime}',
                                  style: TextStyle(
                                    color: customColors.mainTextColor,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Text('Region: ${data.region}'),
                                  Text(
  rectifierDetails != null
      ? '${rectifierDetails.brand}'
      : 'Unknown Rectifier',
  style: TextStyle(
    color: customColors.subTextColor,
  ),
),
Text(
  rectifierDetails != null
      ? 'Location : ${rectifierDetails.rtom} ${rectifierDetails.station} | (${data.recId})'
      : 'Location : ${data.region} | (${data.recId})',
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
                                      'Checked By: ${data.userName}',
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
                          debugPrint(filteredRemarkDataList.toString());
                          RecRemarkData? remark = filteredRemarkDataList;
                          return GestureDetector(
                            onTap: () {
                              debugPrint(data.currentPs1.toString());
                              debugPrint(remark.cubicleCleanRemark.toString());

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => RecInspectionDetailPage(
                                        inspectionData: data,
                                        remarkData: remark,
                                        rectifierDetails: rectifierDetails,
                                      ),

                                  //  RecInspectionDetailPage(
                                  //   inspectionData: data,
                                  //   remarkData: remark,
                                  // ),
                                ),
                              );
                            },
                            child: Card(
                              child: ListTile(
                                title: Text('Date: ${data.clockTime}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text('Region: ${data.region}'),
                                    Text(
          rectifierDetails != null 
              ? '${rectifierDetails.brand} | (${rectifierDetails.model})'
              : 'Unknown Rectifier',
        ),
        Text(
          rectifierDetails != null
              ? 'Location : ${rectifierDetails.rtom} ${rectifierDetails.station} | (${data.recId})'
              : 'Location : Unknown | (${data.recId})',
        ),
                                    Text('Shift: ${data.shift}'),
                                    Text('Checked By: ${data.userName}'),
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
      ),
    );
  }
}

//v1
// import 'package:flutter/material.dart';
// import 'package:powerprox/Screens/Rectifier/RectifierInspectionView/rec_inspection_data.dart';
// import 'package:powerprox/Screens/Rectifier/RectifierInspectionView/rec_inspection_details_page.dart';
// import 'package:powerprox/Screens/Rectifier/RectifierInspectionView/rec_network_service.dart';
//
//
//
// class RectifierInspectionViewSelect extends StatefulWidget {
//   const RectifierInspectionViewSelect({super.key});
//
//   @override
//   _RectifierInspectionViewSelectState createState() =>
//       _RectifierInspectionViewSelectState();
// }
//
// class _RectifierInspectionViewSelectState
//     extends State<RectifierInspectionViewSelect> {
//   late Future<List<RecInspectionData>> recInspectionData;
//   late Future<List<RecRemarkData>> recRemarkData;
//   late Future<List<RectifierDetails>> rectifierDetails;
//   String? selectedRegion = 'ALL';
//   String? checkByPerson = 'ALL';
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
//   List<RecInspectionData> recFilterDataByRegion(
//       List<RecInspectionData> data, String? region) {
//     if (region == null || region.isEmpty || region == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.region == region).toList();
//     }
//   }
//
//   List<RecInspectionData> recFilterDataByPerson(
//       List<RecInspectionData> data, String? person) {
//     if (person == null || person.isEmpty || person == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.userName == person).toList();
//     }
//   }
//
//   RecRemarkData? getRemarkForInspection(
//       List<RecRemarkData> remarks, String remarkId) {
//     try {
//       return remarks.firstWhere((remark) => remark.id == remarkId);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   RectifierDetails? getRectifierDetails(
//       List<RectifierDetails> rectifierDetails, String recId) {
//     try {
//       return rectifierDetails.firstWhere((details) => details.recID == recId);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     recInspectionData = recFetchInspectionData().then((data) {
//       setState(() {
//         for (var item in data) {
//           if (!regionSubmitters.containsKey(item.region)) {
//             regionSubmitters[item.region] = {};
//           }
//           regionSubmitters[item.region]?.add('ALL');
//           regionSubmitters[item.region]?.add(item.userName);
//         }
//       });
//       return data;
//     });
//     recRemarkData = recFetchRemarkData();
//     rectifierDetails = rectifierDetailsFetchData();
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
//               future: Future.wait(
//                   [recInspectionData, recRemarkData, rectifierDetails]),
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
//                   List<RecInspectionData> inspectionDataList =
//                       snapshot.data![0] as List<RecInspectionData>;
//                   List<RecRemarkData> remarkDataList =
//                       snapshot.data![1] as List<RecRemarkData>;
//                   List<RectifierDetails> rectifierDetailsList =
//                       snapshot.data![2] as List<RectifierDetails>;
//
//                   // Filter data based on selected region
//                   inspectionDataList =
//                       recFilterDataByRegion(inspectionDataList, selectedRegion);
//
//                   // Filter data based on selected person
//                   inspectionDataList =
//                       recFilterDataByPerson(inspectionDataList, checkByPerson);
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
//                       RecInspectionData data = inspectionDataList[index];
//                       RecRemarkData? filteredRemarkDataList =
//                           getRemarkForInspection(remarkDataList, data.remarkId);
//                       RectifierDetails? rectifierDetails =
//                           getRectifierDetails(rectifierDetailsList, data.recId);
//
//                       // Check if filteredRemarkDataList is empty
//                       if (filteredRemarkDataList == null) {
//                         RecRemarkData? remark = filteredRemarkDataList;
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => RecInspectionDetailPage(
//                                   inspectionData: data,
//                                   remarkData: remark,
//                                   rectifierDetails: rectifierDetails,
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
//                                       '${rectifierDetails!.brand} | (${rectifierDetails.model})'),
//                                   Text(
//                                       'Location : ${rectifierDetails.rtom} ${rectifierDetails.station} | (${data.recId})'),
//                                   Text('Shift: ${data.shift}'),
//                                   Text('Checked By: ${data.userName}'),
//                                   Text('Remark: No remark available'),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       } else {
//                         debugPrint(filteredRemarkDataList.toString());
//                         RecRemarkData? remark = filteredRemarkDataList;
//                         return GestureDetector(
//                           onTap: () {
//                             debugPrint(data.currentPs1.toString());
//                             debugPrint(remark.cubicleCleanRemark.toString());
//
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => RecInspectionDetailPage(
//                                         inspectionData: data,
//                                         remarkData: remark,
//                                         rectifierDetails: rectifierDetails,
//                                       )
//
//                                   //  RecInspectionDetailPage(
//                                   //   inspectionData: data,
//                                   //   remarkData: remark,
//                                   // ),
//                                   ),
//                             );
//                           },
//                           child: Card(
//                             child: ListTile(
//                               title: Text('Date: ${data.clockTime}'),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // Text('Region: ${data.region}'),
//                                   Text(
//                                       '${rectifierDetails!.brand} | (${rectifierDetails.model})'),
//                                   Text(
//                                       'Location : ${rectifierDetails.rtom} ${rectifierDetails.station} | (${data.recId})'),
//                                   Text('Shift: ${data.shift}'),
//                                   Text('Checked By: ${data.userName}'),
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
