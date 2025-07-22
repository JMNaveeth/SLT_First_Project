import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme_update/utils/utils/colors.dart' as customColors;
// import '../../../Widgets/ThemeToggle/theme_provider.dart';
// import '../../../../Widgets/ThemeToggle/theme_provider.dart';
import '../../widgets/theme change related widjets/theme_provider.dart';
import '../../widgets/theme change related widjets/theme_toggle_button.dart';
import 'ups_inspection_data.dart';
import 'UPSInspectionViewData.dart';
import 'httpGetUPSInspectionData.dart';
// import '../widgets/theme_provider.dart';

class UPSInspectionViewSelect extends StatefulWidget {
  @override
  _UPSInspectionViewSelectState createState() => _UPSInspectionViewSelectState();
}

class _UPSInspectionViewSelectState extends State<UPSInspectionViewSelect> {
  late Future<List<UpsInspectionData>> upsInspectionData;
  late Future<List<UpsRemarkData>> upsRemarkData;
  late Future<List<UPSDetails>> upsDetails;
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
    'UVA'
  ];
  Map<String, Set<String>> regionSubmitters = {};

  List<UpsInspectionData> upsFilterDataByRegion(
      List<UpsInspectionData> data, String? location) {
    if (location == null || location.isEmpty || location == 'ALL') {
      return data;
    } else {
      return data.where((item) => item.region == location).toList();
    }
  }

  List<UpsInspectionData> upsFilterDataByPerson(
      List<UpsInspectionData> data, String? person) {
    if (person == null || person.isEmpty || person == 'ALL') {
      return data;
    } else {
      return data.where((item) => item.userName == person).toList();
    }
  }

  UpsRemarkData? getRemarkForInspection(
      List<UpsRemarkData> remarks, String remarkId) {
    try {
      return remarks.firstWhere((remark) => remark.id == remarkId);
    } catch (e) {
      return null;
    }
  }

  UPSDetails? getRectifierDetails(List<UPSDetails> upsDetails, String recId) {
    try {
      return upsDetails.firstWhere((details) => details.upsID == recId);
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    upsInspectionData = upsFetchInspectionData().then((data) {
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
    upsRemarkData = upsFetchRemarkData();
    upsDetails = upsDetailsFetchData();
    debugPrint(regionSubmitters.toString());
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeData = themeProvider.currentTheme;
    final custom = themeData.extension<CustomColors>()!;
        final customColors = Theme.of(context).extension<CustomColors>()!;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: customColors.appbarColor,
        iconTheme: IconThemeData(color: customColors.mainTextColor),
        title: Text(
          'Inspection Data',
          style: TextStyle(color: customColors.mainTextColor, fontSize: 20),
        ),
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownButton<String>(
                hint: Text('Select Region'),
                value: selectedRegion,
                style: themeData.textTheme.bodyMedium!.copyWith(
                  color: customColors.mainTextColor,
                ),
                dropdownColor: customColors.suqarBackgroundColor,
                iconEnabledColor: custom.mainTextColor,
                underline: Container(
                  height: 2,
                  color: custom.mainTextColor,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRegion = newValue;
                    // checkByPerson =
                    //     null; // Reset person selection when region changes
                  });
                },
                items: regions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButton<String>(

                hint: Text(
                  'Checked By',
                  style: themeData.textTheme.bodyMedium!.copyWith(
                    color: custom.hinttColor,    // ← use your custom hint color
                  ),
                ),
                // hint: Text('Checked By'),

                value: checkByPerson,
                style: themeData.textTheme.bodyMedium!.copyWith(
                  color: custom.mainTextColor,
                ),
                dropdownColor: custom.suqarBackgroundColor,
                iconEnabledColor: custom.mainTextColor,
                underline: Container(
                  height: 2,
                  color: custom.mainTextColor,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    checkByPerson = newValue;
                  });
                },
                items: selectedRegion != null &&
                    regionSubmitters[selectedRegion] != null
                    ? regionSubmitters[selectedRegion]!.map((String value) {
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
              future:
              Future.wait([upsInspectionData, upsRemarkData, upsDetails]),
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
                  List<UpsInspectionData> inspectionDataList =
                  snapshot.data![0] as List<UpsInspectionData>;
                  List<UpsRemarkData> remarkDataList =
                  snapshot.data![1] as List<UpsRemarkData>;
                  List<UPSDetails> upsDetailsList =
                  snapshot.data![2] as List<UPSDetails>;

                  // Filter data based on selected region
                  inspectionDataList =
                      upsFilterDataByRegion(inspectionDataList, selectedRegion);

                  // Filter data based on selected person
                  inspectionDataList =
                      upsFilterDataByPerson(inspectionDataList, checkByPerson);

                  // Sort the filtered data in reverse order by clockTime
                  inspectionDataList
                      .sort((a, b) => b.clockTime.compareTo(a.clockTime));

                  // Check if the filtered list is empty
                  if (inspectionDataList.isEmpty) {
                    return Center(
                        child:
                        Text('No data available for the selected region'));
                  }

                  return ListView.builder(
                    itemCount: inspectionDataList.length,
                    itemBuilder: (context, index) {
                      UpsInspectionData data = inspectionDataList[index];
                      UpsRemarkData? filteredRemarkDataList =
                      getRemarkForInspection(remarkDataList, data.remarkId);

                      UPSDetails? upsDetails =
                      getRectifierDetails(upsDetailsList, data.recId);

                      // Check if filteredRemarkDataList is empty
                      if (filteredRemarkDataList == null) {
                        UpsRemarkData? remark = filteredRemarkDataList;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpsInspectionDetailsPage(
                                  inspectionData: data,
                                  remarkData: remark,
                                  upsDetails: upsDetails,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(
                                'Date: ${data.clockTime}',
                                style: themeData.textTheme.bodyMedium!.copyWith(
                                  color: customColors.mainTextColor,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Text('Region: ${data.region}'),
                                  Text(
                                    '${upsDetails!.brand} | (${upsDetails.model})',
                                    style: themeData.textTheme.bodyMedium!.copyWith(
                                      color: custom.mainTextColor,
                                    ),
                                  ),
                                  Text(
                                    'Location : ${upsDetails.rtom} ${upsDetails.station} | (${data.recId})',
                                    style: themeData.textTheme.bodyMedium!.copyWith(
                                      color: custom.mainTextColor,
                                    ),
                                  ),
                                  Text(
                                    'Shift: ${data.shift}',
                                    style: themeData.textTheme.bodyMedium!.copyWith(
                                      color: custom.mainTextColor,
                                    ),
                                  ),
                                  Text(
                                    'Checked By: ${data.userName}',
                                    style: themeData.textTheme.bodyMedium!.copyWith(
                                      color: custom.mainTextColor,
                                    ),
                                  ),
                                  Text(
                                    'Remark: No remark available',
                                    style: themeData.textTheme.bodyMedium!.copyWith(
                                      color: custom.mainTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        UpsRemarkData remark = filteredRemarkDataList;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpsInspectionDetailsPage(
                                  inspectionData: data,
                                  remarkData: remark,
                                  upsDetails: upsDetails,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: ListTile(
                              title: Text('Date: ${data.clockTime}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Text('Region: ${data.region}'),
                                  Text(
                                      '${upsDetails!.brand} | (${upsDetails.model})'),
                                  Text(
                                      'Location : ${upsDetails.rtom} ${upsDetails.station} | (${data.recId})'),
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
    );
  }
}



//v1
// import 'package:flutter/material.dart';
// import 'package:powerprox/Screens/UPS/UPSInspectionView/ups_inspection_data.dart';
// import 'package:powerprox/Screens/UPS/UPSInspectionView/UPSInspectionViewData.dart';
// import 'package:powerprox/Screens/UPS/UPSInspectionView/httpGetUPSInspectionData.dart';
//
//
// class UPSInspectionViewSelect extends StatefulWidget {
//   @override
//   _UPSInspectionViewSelectState createState() => _UPSInspectionViewSelectState();
// }
//
// class _UPSInspectionViewSelectState extends State<UPSInspectionViewSelect> {
//   late Future<List<UpsInspectionData>> upsInspectionData;
//   late Future<List<UpsRemarkData>> upsRemarkData;
//   late Future<List<UPSDetails>> upsDetails;
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
//   List<UpsInspectionData> upsFilterDataByRegion(
//       List<UpsInspectionData> data, String? location) {
//     if (location == null || location.isEmpty || location == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.region == location).toList();
//     }
//   }
//
//   List<UpsInspectionData> upsFilterDataByPerson(
//       List<UpsInspectionData> data, String? person) {
//     if (person == null || person.isEmpty || person == 'ALL') {
//       return data;
//     } else {
//       return data.where((item) => item.userName == person).toList();
//     }
//   }
//
//   UpsRemarkData? getRemarkForInspection(
//       List<UpsRemarkData> remarks, String remarkId) {
//     try {
//       return remarks.firstWhere((remark) => remark.id == remarkId);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   UPSDetails? getRectifierDetails(List<UPSDetails> upsDetails, String recId) {
//     try {
//       return upsDetails.firstWhere((details) => details.upsID == recId);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     upsInspectionData = upsFetchInspectionData().then((data) {
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
//     upsRemarkData = upsFetchRemarkData();
//     upsDetails = upsDetailsFetchData();
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
//                   Future.wait([upsInspectionData, upsRemarkData, upsDetails]),
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
//                   List<UpsInspectionData> inspectionDataList =
//                       snapshot.data![0] as List<UpsInspectionData>;
//                   List<UpsRemarkData> remarkDataList =
//                       snapshot.data![1] as List<UpsRemarkData>;
//                   List<UPSDetails> upsDetailsList =
//                       snapshot.data![2] as List<UPSDetails>;
//
//                   // Filter data based on selected region
//                   inspectionDataList =
//                       upsFilterDataByRegion(inspectionDataList, selectedRegion);
//
//                   // Filter data based on selected person
//                   inspectionDataList =
//                       upsFilterDataByPerson(inspectionDataList, checkByPerson);
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
//                       UpsInspectionData data = inspectionDataList[index];
//                       UpsRemarkData? filteredRemarkDataList =
//                           getRemarkForInspection(remarkDataList, data.remarkId);
//
//                       UPSDetails? upsDetails =
//                           getRectifierDetails(upsDetailsList, data.recId);
//
//                       // Check if filteredRemarkDataList is empty
//                       if (filteredRemarkDataList == null) {
//                         UpsRemarkData? remark = filteredRemarkDataList;
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => UpsInspectionDetailsPage(
//                                   inspectionData: data,
//                                   remarkData: remark,
//                                   upsDetails: upsDetails,
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
//                                       '${upsDetails!.brand} | (${upsDetails.model})'),
//                                   Text(
//                                       'Location : ${upsDetails.rtom} ${upsDetails.station} | (${data.recId})'),
//                                   Text('Shift: ${data.shift}'),
//                                   Text('Checked By: ${data.userName}'),
//                                   Text('Remark: No remark available'),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       } else {
//                         UpsRemarkData remark = filteredRemarkDataList;
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => UpsInspectionDetailsPage(
//                                   inspectionData: data,
//                                   remarkData: remark,
//                                   upsDetails: upsDetails,
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
//                                       '${upsDetails!.brand} | (${upsDetails.model})'),
//                                   Text(
//                                       'Location : ${upsDetails.rtom} ${upsDetails.station} | (${data.recId})'),
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
