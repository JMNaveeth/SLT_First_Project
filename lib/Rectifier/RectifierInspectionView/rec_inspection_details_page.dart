import 'package:flutter/material.dart';
//import 'package:powerprox/Screens/Other%20Assets/Rectifier/RectifierInspectionView/rec_inspection_data.dart';
import 'package:theme_update/Rectifier/RectifierInspectionView/rec_inspection_data.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/utils/utils/colors.dart';
// import 'package:rectifier2/rec_inspection_data3.dart';
//import '../../../HomePage/widgets/colors.dart';

class RecInspectionDetailPage extends StatelessWidget {
  final RecInspectionData inspectionData;
  final RecRemarkData? remarkData;
  final RectifierDetails? rectifierDetails;

  RecInspectionDetailPage({
    required this.inspectionData,
    required this.remarkData,
    required this.rectifierDetails,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inspection Detail',
          style: TextStyle(color: customColors.mainTextColor),
        ),
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],

        centerTitle: true,
        backgroundColor: customColors.appbarColor,
        iconTheme: IconThemeData(color: customColors.mainTextColor),
      ),

      body: Container(
        // Wrap Padding with a Container
        color:
            customColors
                .mainBackgroundColor, // Or Colors.white, or any other color
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              //Text('ID: ${inspectionData.id}'),
              Card(
                color: customColors.suqarBackgroundColor,
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${inspectionData.clockTime}",
                        style: TextStyle(
                          color: customColors.mainTextColor,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        " ${inspectionData.shift}",
                        style: TextStyle(
                          color: customColors.mainTextColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Region: ${inspectionData.region}',
                            style: TextStyle(color: customColors.mainTextColor),
                          ),
                          Text(
                            'Rec Id: ${inspectionData.recId}',
                            style: TextStyle(color: customColors.mainTextColor),
                          ),
                        ],
                      ),
                   rectifierDetails != null
    ? Column(
      children: [
        Text(
          'Location : ${rectifierDetails?.rtom} ${rectifierDetails?.station}',
          style: TextStyle(
            color: customColors.subTextColor,
          ),
        ),
        Text(
          '${rectifierDetails?.brand}',
          style: TextStyle(
            color: customColors.subTextColor,
          ),
        ),
      ],
    )
    : SizedBox.shrink(),
                      // --- ADD THIS BLOCK FOR GPS ---
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: customColors.subTextColor,
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Latitude: ${inspectionData.Latitude != 0.0 ? inspectionData.Latitude : "Not Available"}",
                            style: TextStyle(color: customColors.subTextColor),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Longitude: ${inspectionData.Longitude != 0.0 ? inspectionData.Longitude : "Not Available"}",
                            style: TextStyle(color: customColors.subTextColor),
                          ),
                        ],
                      ), // --- END GPS BLOCK ---
                      Text(
                        "Checked By : ${inspectionData.userName}",
                        style: TextStyle(color: customColors.subTextColor),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 5),
              Divider(),
              SizedBox(height: 5),
              CustomDetailsCard(
                inspectionData: inspectionData,
                remarkData: remarkData,
                title: "Cleanliness of Room",
                titleResponse: inspectionData.roomClean,
                remarkResponse:
                    remarkData != null ? remarkData!.roomCleanRemark : "",
                warningConditionValue: 'Not Ok',
                backgroundColor: customColors.suqarBackgroundColor,
                textColor: customColors.subTextColor,
              ),
              CustomDetailsCard(
                inspectionData: inspectionData,
                remarkData: remarkData,
                title: "Cleanliness of Cubicles",
                titleResponse: inspectionData.cubicleClean,
                remarkResponse:
                    remarkData != null ? remarkData!.cubicleCleanRemark : "",
                warningConditionValue: 'Not Ok',
                backgroundColor: customColors.suqarBackgroundColor,
                textColor: customColors.subTextColor,
              ),
              CustomDetailsCard(
                inspectionData: inspectionData,
                remarkData: remarkData,
                title: "Measure Room Tempertature",
                titleResponse: inspectionData.roomTemp,
                remarkResponse:
                    remarkData != null ? remarkData!.roomTempRemark : "",
                warningConditionValue: 'high',
                backgroundColor: customColors.suqarBackgroundColor,
                textColor: customColors.subTextColor,
              ),
              CustomDetailsCard(
                inspectionData: inspectionData,
                remarkData: remarkData,
                title: "Measure Hygrogen Gas Emission",
                titleResponse: inspectionData.h2gasEmission,
                remarkResponse:
                    remarkData != null ? remarkData!.h2gasEmissionRemark : "",
                warningConditionValue: 'yes',
                backgroundColor: customColors.suqarBackgroundColor,
                textColor: customColors.subTextColor,
              ),
              CustomDetailsCard(
                inspectionData: inspectionData,
                remarkData: remarkData,
                title: "Check Main Circuit ",
                titleResponse: inspectionData.checkMCB,
                remarkResponse:
                    remarkData != null ? remarkData!.checkMCBRemark : "",
                warningConditionValue: 'Not ok',
                backgroundColor: customColors.suqarBackgroundColor,
                textColor: customColors.subTextColor,
              ),
              CustomDetailsCard(
                inspectionData: inspectionData,
                remarkData: remarkData,
                title: "DC PDB",
                titleResponse: inspectionData.dcPDB,
                remarkResponse:
                    remarkData != null ? remarkData!.dcPDBRemark : "",
                warningConditionValue: 'Not ok',
                backgroundColor: customColors.suqarBackgroundColor,
                textColor: customColors.subTextColor,
              ),

              CustomDetailsCard(
                inspectionData: inspectionData,
                remarkData: remarkData,
                title: "Test Remote Alarm",
                titleResponse: inspectionData.remoteAlarm,
                remarkResponse:
                    remarkData != null ? remarkData!.remoteAlarmRemark : "",
                warningConditionValue: 'Not ok',
                backgroundColor: customColors.suqarBackgroundColor,
                textColor: customColors.subTextColor,
              ),
              SizedBox(height: 5),
              Divider(),
              SizedBox(height: 5),
              CustomOneDetailsCard(
                inspectionData: inspectionData,
                title: "No.of Working Lines",
                titleResponse: inspectionData.noOfWorkingLine,
                backgroundColor: customColors.suqarBackgroundColor,
                textColor: customColors.subTextColor,
              ),
              CustomOneDetailsCard(
                inspectionData: inspectionData,
                title: "Capacity",
                titleResponse: inspectionData.noOfWorkingLine,
                backgroundColor: customColors.suqarBackgroundColor,
                textColor: customColors.subTextColor,
              ),

              // CustomOneDetailsCard(
              //   inspectionData: inspectionData,
              //   title: "Make Type",
              //   titleResponse: inspectionData.type,
              //   backgroundColor: suqarBackgroundColor,
              //   textColor: subTextColor,),
              SizedBox(height: 5),
              Divider(),
              SizedBox(height: 5),
              Text(
                "Rectifier Reading",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: customColors.mainTextColor,
                ),
              ),
              Card(
                color: customColors.suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 15,
                    bottom: 5,
                    top: 10,
                    left: 15,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Voltage Reading",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: customColors.mainTextColor,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Phase 1",
                                style: TextStyle(
                                  color: customColors.subTextColor,
                                ),
                              ),
                              Text(
                                '${inspectionData.voltagePs1} V',
                                style: TextStyle(
                                  color: customColors.subTextColor,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Phase 2",
                                style: TextStyle(
                                  color: customColors.subTextColor,
                                ),
                              ),
                              Text(
                                '${inspectionData.voltagePs2} V',
                                style: TextStyle(
                                  color: customColors.subTextColor,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Phase 3",
                                style: TextStyle(
                                  color: customColors.subTextColor,
                                ),
                              ),
                              Text(
                                '${inspectionData.voltagePs3} V',
                                style: TextStyle(
                                  color: customColors.subTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              //Current Reading
              Card(
                color: customColors.suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 15,
                    bottom: 5,
                    top: 10,
                    left: 15,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Current Reading",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: customColors.mainTextColor,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Phase 1",
                                style: TextStyle(
                                  color: customColors.subTextColor,
                                ),
                              ),
                              Text(
                                '${inspectionData.currentPs1} A',
                                style: TextStyle(
                                  color: customColors.subTextColor,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Phase 2",
                                style: TextStyle(
                                  color: customColors.subTextColor,
                                ),
                              ),
                              Text(
                                '${inspectionData.currentPs2} A',
                                style: TextStyle(
                                  color: customColors.subTextColor,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Phase 3",
                                style: TextStyle(
                                  color: customColors.subTextColor,
                                ),
                              ),
                              Text(
                                '${inspectionData.currentPs3} A',
                                style: TextStyle(
                                  color: customColors.subTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              //DC Output
              Card(
                color: customColors.suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 15,
                    bottom: 5,
                    top: 10,
                    left: 15,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "DC Output",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: customColors.mainTextColor,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Voltage",
                                style: TextStyle(
                                  color: customColors.subTextColor,
                                ),
                              ),
                              Text(
                                '${inspectionData.dcVoltage} V',
                                style: TextStyle(
                                  color: customColors.subTextColor,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Current",
                                style: TextStyle(
                                  color: customColors.subTextColor,
                                ),
                              ),
                              Text(
                                '${inspectionData.dcCurrent} A',
                                style: TextStyle(
                                  color: customColors.subTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              CustomOneDetailsCard(
                inspectionData: inspectionData,
                title: "Capacity",
                titleResponse: inspectionData.recCapacity,
                backgroundColor: customColors.suqarBackgroundColor,
                textColor: customColors.subTextColor,
              ),
              CustomDetailsCard(
                inspectionData: inspectionData,
                remarkData: remarkData,
                title: "Alarm Status",
                titleResponse: inspectionData.recAlarmStatus,
                remarkResponse:
                    remarkData != null ? remarkData!.recAlarmRemark : "",
                warningConditionValue: 'notok',
                backgroundColor: customColors.suqarBackgroundColor,
                textColor: customColors.subTextColor,
              ),
              CustomDetailsCard(
                inspectionData: inspectionData,
                remarkData: remarkData,
                title: "Indicator Status",
                titleResponse: inspectionData.recIndicatorStatus,
                remarkResponse: remarkData != null ? remarkData!.indRemark : "",
                warningConditionValue: 'not ok',
                backgroundColor: customColors.suqarBackgroundColor,
                textColor: customColors.subTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomOneDetailsCard extends StatelessWidget {
  const CustomOneDetailsCard({
    super.key,
    required this.inspectionData,
    required this.title,
    required this.titleResponse,
    required this.backgroundColor,
    required this.textColor,
  });

  final RecInspectionData inspectionData;
  final String title;
  final String titleResponse;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor ?? Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          top: 20,
          bottom: 20,
          right: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(color: textColor ?? Colors.black)),
            Text(
              titleResponse,
              style: TextStyle(color: textColor ?? Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDetailsCard extends StatelessWidget {
  const CustomDetailsCard({
    super.key,
    required this.inspectionData,
    required this.remarkData,
    required this.title,
    required this.titleResponse,
    required this.remarkResponse,
    required this.warningConditionValue,
    required this.backgroundColor,
    required this.textColor,
  });

  final RecInspectionData inspectionData;
  final RecRemarkData? remarkData;
  final String title;
  final String titleResponse;
  final String remarkResponse;
  final String warningConditionValue;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      color:
          warningConditionValue == "additionalremark"
              ? Theme.of(context).cardColor
              : titleResponse == warningConditionValue
              ? Color.fromARGB(172, 216, 127, 121)
              : backgroundColor,
      // : Theme.of(context).cardColor,
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w400, color: textColor),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  titleResponse,
                  style: TextStyle(color: textColor), // ✅ Fix applied here
                ),
                warningConditionValue == "additionalremark"
                    ? const SizedBox.shrink() // Empty space
                    : titleResponse == warningConditionValue
                    ? Icon(Icons.cancel, color: Colors.red)
                    : Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
          ],
        ),
        subtitle:
            remarkResponse != ""
                ? Text(
                  "Remark: $remarkResponse",
                  style: TextStyle(color: textColor), // ✅ Fix applied here
                )
                : const SizedBox.shrink(),
      ),
    );
  }
}

//v1
// import 'package:flutter/material.dart';
// import 'package:powerprox/Screens/Rectifier/RectifierInspectionView/rec_inspection_data.dart';
//
// class RecInspectionDetailPage extends StatelessWidget {
//   final RecInspectionData inspectionData;
//   final RecRemarkData? remarkData;
//   final RectifierDetails? rectifierDetails;
//
//   RecInspectionDetailPage(
//       {required this.inspectionData,
//       required this.remarkData,
//       required this.rectifierDetails});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Inspection Detail'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             //Text('ID: ${inspectionData.id}'),
//             Card(
//               child: ListTile(
//                 title: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("${inspectionData.clockTime}"),
//                     Text(" ${inspectionData.shift}"),
//                   ],
//                 ),
//                 subtitle: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Region: ${inspectionData.region}'),
//                         Text('Rec Id: ${inspectionData.recId}'),
//                       ],
//                     ),
//                     Text(
//                         'Location : ${rectifierDetails!.rtom} ${rectifierDetails!.station}'),
//                     Text(
//                         '${rectifierDetails!.brand} | (${rectifierDetails!.model})'),
//                     Text("Checked By : ${inspectionData.userName}")
//                   ],
//                 ),
//               ),
//             ),
//
//             SizedBox(
//               height: 5,
//             ),
//             Divider(),
//             SizedBox(
//               height: 5,
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Cleanliness of Room",
//               titleResponse: inspectionData.roomClean,
//               remarkResponse:
//                   remarkData != null ? remarkData!.roomCleanRemark : "",
//               warningConditionValue: 'Not Ok',
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Cleanliness of Cubicles",
//               titleResponse: inspectionData.cubicleClean,
//               remarkResponse:
//                   remarkData != null ? remarkData!.cubicleCleanRemark : "",
//               warningConditionValue: 'Not Ok',
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Measure Room Tempertature",
//               titleResponse: inspectionData.roomTemp,
//               remarkResponse:
//                   remarkData != null ? remarkData!.roomTempRemark : "",
//               warningConditionValue: 'high',
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Measure Hygrogen Gas Emission",
//               titleResponse: inspectionData.h2gasEmission,
//               remarkResponse:
//                   remarkData != null ? remarkData!.h2gasEmissionRemark : "",
//               warningConditionValue: 'yes',
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Check Main Circuit ",
//               titleResponse: inspectionData.checkMCB,
//               remarkResponse:
//                   remarkData != null ? remarkData!.checkMCBRemark : "",
//               warningConditionValue: 'Not ok',
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "DC PDB",
//               titleResponse: inspectionData.dcPDB,
//               remarkResponse: remarkData != null ? remarkData!.dcPDBRemark : "",
//               warningConditionValue: 'Not ok',
//             ),
//
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Test Remote Alarm",
//               titleResponse: inspectionData.remoteAlarm,
//               remarkResponse:
//                   remarkData != null ? remarkData!.remoteAlarmRemark : "",
//               warningConditionValue: 'Not ok',
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             Divider(),
//             SizedBox(
//               height: 5,
//             ),
//             CustomOneDetailsCard(
//               inspectionData: inspectionData,
//               title: "No.of Working Lines",
//               titleResponse: inspectionData.noOfWorkingLine,
//             ),
//             CustomOneDetailsCard(
//                 inspectionData: inspectionData,
//                 title: "Capacity",
//                 titleResponse: inspectionData.noOfWorkingLine),
//             CustomOneDetailsCard(
//                 inspectionData: inspectionData,
//                 title: "Make Type",
//                 titleResponse: inspectionData.type),
//
//             SizedBox(
//               height: 5,
//             ),
//             Divider(),
//             SizedBox(
//               height: 5,
//             ),
//             const Text(
//               "Rectifier Reading",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             Card(
//                 child: Padding(
//               padding: const EdgeInsets.only(
//                   right: 15, bottom: 5, top: 10, left: 15),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Voltage Reading",
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("Phase 1"),
//                           Text('${inspectionData.voltagePs1} V')
//                         ],
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("Phase 2"),
//                           Text('${inspectionData.voltagePs2} V')
//                         ],
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("Phase 3"),
//                           Text('${inspectionData.voltagePs3} V')
//                         ],
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             )),
//
//             //Current Reading
//             Card(
//                 child: Padding(
//               padding: const EdgeInsets.only(
//                   right: 15, bottom: 5, top: 10, left: 15),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Current Reading",
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("Phase 1"),
//                           Text('${inspectionData.currentPs1} A')
//                         ],
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("Phase 2"),
//                           Text('${inspectionData.currentPs2} A')
//                         ],
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("Phase 3"),
//                           Text('${inspectionData.currentPs3} A')
//                         ],
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             )),
//
//             //DC Output
//             Card(
//                 child: Padding(
//               padding: const EdgeInsets.only(
//                   right: 15, bottom: 5, top: 10, left: 15),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     "DC Output",
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("Voltage"),
//                           Text('${inspectionData.dcVoltage} V')
//                         ],
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("Current"),
//                           Text('${inspectionData.dcCurrent} A')
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             )),
//             CustomOneDetailsCard(
//                 inspectionData: inspectionData,
//                 title: "Capacity",
//                 titleResponse: inspectionData.recCapacity),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Alarm Status",
//               titleResponse: inspectionData.recAlarmStatus,
//               remarkResponse:
//                   remarkData != null ? remarkData!.recAlarmRemark : "",
//               warningConditionValue: 'notok',
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Indicator Status",
//               titleResponse: inspectionData.recIndicatorStatus,
//               remarkResponse: remarkData != null ? remarkData!.indRemark : "",
//               warningConditionValue: 'not ok',
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class CustomOneDetailsCard extends StatelessWidget {
//   const CustomOneDetailsCard(
//       {super.key,
//       required this.inspectionData,
//       required this.title,
//       required this.titleResponse});
//
//   final RecInspectionData inspectionData;
//   final String title;
//   final String titleResponse;
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding:
//             const EdgeInsets.only(left: 15, top: 20, bottom: 20, right: 15),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [Text(title), Text(titleResponse)],
//         ),
//       ),
//     );
//   }
// }
//
// class CustomDetailsCard extends StatelessWidget {
//   const CustomDetailsCard({
//     super.key,
//     required this.inspectionData,
//     required this.remarkData,
//     required this.title,
//     required this.titleResponse,
//     required this.remarkResponse,
//     required this.warningConditionValue,
//   });
//
//   final RecInspectionData inspectionData;
//   final RecRemarkData? remarkData;
//   final String title;
//   final String titleResponse;
//   final String remarkResponse;
//   final String warningConditionValue;
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: warningConditionValue == "additionalremark"
//           ? Theme.of(context).cardColor
//           : titleResponse == warningConditionValue
//               ? Color.fromARGB(172, 216, 127, 121)
//               : Theme.of(context).cardColor,
//       child: ListTile(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               title,
//               style: TextStyle(fontWeight: FontWeight.w400),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Text(titleResponse),
//                 warningConditionValue == "additionalremark"
//                     ? const SizedBox.shrink() // Empty space
//                     : titleResponse == warningConditionValue
//                         ? Icon(
//                             Icons.cancel,
//                             color: Colors.red,
//                           )
//                         : Icon(
//                             Icons.check_circle,
//                             color: Colors.green,
//                           ),
//               ],
//             ),
//           ],
//         ),
//         subtitle: remarkResponse != ""
//             ? Text("Remark: $remarkResponse")
//             : const SizedBox.shrink(),
//       ),
//     );
//   }
// }
