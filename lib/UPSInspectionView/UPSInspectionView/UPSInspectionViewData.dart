import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme_update/utils/utils/colors.dart' as customColors;
import 'package:theme_update/widgets/gps%20related%20widgets/SmartGPSRibbon.dart';
// import '../../../../Widgets/ThemeToggle/theme_provider.dart';
// import '../../../Widgets/ThemeToggle/theme_provider.dart';
import '../../widgets/theme change related widjets/theme_provider.dart';
import '../../widgets/theme change related widjets/theme_toggle_button.dart';
import 'ups_inspection_data.dart';

class UpsInspectionDetailsPage extends StatelessWidget {
  final UpsInspectionData inspectionData;
  final UpsRemarkData? remarkData;
  final UPSDetails? upsDetails;

  UpsInspectionDetailsPage({
    required this.inspectionData,
    required this.remarkData,
    this.upsDetails,
  });

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
          'Inspection Detail',
          style: TextStyle(color: customColors.mainTextColor, fontSize: 20),
        ),
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),
      body:Container(
  color: customColors.mainBackgroundColor, // Add this for body background color
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
                      style: themeData.textTheme.bodyMedium!.copyWith(
                        color: custom.mainTextColor,
                      ),
                    ),
                    Text(
                      " ${inspectionData.shift}",
                      style: themeData.textTheme.bodyMedium!.copyWith(
                        color: custom.mainTextColor,
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
                          style: themeData.textTheme.bodyMedium!.copyWith(
                            color: custom.mainTextColor,
                          ),
                        ),
                        Text(
                          'Rec Id: ${inspectionData.recId}',
                          style: themeData.textTheme.bodyMedium!.copyWith(
                            color: custom.mainTextColor,
                          ),
                        ),
                      ],
                    ),
                    upsDetails != null
                        ? Column(
                          children: [
                            Text(
                              'Location : ${upsDetails!.rtom} ${upsDetails!.station}',
                              style: themeData.textTheme.bodyMedium!.copyWith(
                                color: custom.mainTextColor,
                              ),
                            ),
                            Text(
                              '${upsDetails!.brand} | (${upsDetails!.model})',
                              style: themeData.textTheme.bodyMedium!.copyWith(
                                color: custom.mainTextColor,
                              ),
                            ),
                          ],
                        )
                        : SizedBox.shrink(),
                    Text(
                      "Checked By : ${inspectionData.userName}",
                      style: themeData.textTheme.bodyMedium!.copyWith(
                        color: custom.mainTextColor,
                      ),
                    ),
                   // --- REPLACE GPS BLOCK WITH THIS ---
SmartGPSRibbon(
  latitude: inspectionData.latitude,
  longitude: inspectionData.longitude,
  region: inspectionData.region,
),
// --- END GPS BLOCK ---
                  ],
                ),
              ),
            ),

            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 5),

            Text(
              "01 . Genaral Inspection",
              style: themeData.textTheme.headlineSmall!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: custom.mainTextColor,
              ),
            ),
            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Check Ventilation of the room",
              titleResponse: inspectionData.ventilation,
              remarkResponse:
                  remarkData != null ? remarkData!.ventilationRemark : "",
              warningConditionValue: 'Not Ok',
            ),

            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title:
                  "Cleck the battery \ncabinet temperature \n(20-25 Centigrade)",
              titleResponse: inspectionData.cabinTemp,
              remarkResponse:
                  remarkData != null ? remarkData!.cabinTempRemark : "",
              warningConditionValue: 'Others',
            ),
            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Measure Hydrogen gas Emission",
              titleResponse: inspectionData.h2GasEmission,
              remarkResponse:
                  remarkData != null ? remarkData!.h2GasEmissionRemark : "",
              warningConditionValue: 'Yes',
            ),
            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Keep UPS free and \nclean of any dust",
              titleResponse: inspectionData.dust,
              remarkResponse: remarkData != null ? remarkData!.dustRemark : "",
              warningConditionValue: 'Not Ok',
            ),

            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 5),

            Text(
              "02 . Batter Inspection",
              style: themeData.textTheme.headlineSmall!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: custom.mainTextColor,
              ),
            ),
            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Check Cleanliness",
              titleResponse: inspectionData.batClean,
              remarkResponse:
                  remarkData != null ? remarkData!.batCleanRemark : "",
              warningConditionValue: 'Not Ok',
            ),

            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Check Terminal Voltage",
              titleResponse: inspectionData.trmVolt,
              remarkResponse:
                  remarkData != null ? remarkData!.trmVoltRemark : "",
              warningConditionValue: 'Not Ok',
            ),
            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Check for any leakage",
              titleResponse: inspectionData.leak,
              remarkResponse: remarkData != null ? remarkData!.leakRemark : "",
              warningConditionValue: 'Yes',
            ),

            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 5),

            Text(
              "03 . Daily Inspection of the UPS",
              style: themeData.textTheme.headlineSmall!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: custom.mainTextColor,
              ),
            ),
            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Mimic LED Indication",
              titleResponse: inspectionData.mimicLED,
              remarkResponse:
                  remarkData != null ? remarkData!.mimicLEDRemark : "",
              warningConditionValue: 'Not Work',
            ),

            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "All metered parameters",
              titleResponse: inspectionData.meterPara,
              remarkResponse:
                  remarkData != null ? remarkData!.meterParaRemark : "",
              warningConditionValue: 'Not Ok',
            ),
            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Warning or Alarm Massages",
              titleResponse: inspectionData.warningAlarm,
              remarkResponse:
                  remarkData != null ? remarkData!.warningAlarmRemark : "",
              warningConditionValue: 'Yes',
            ),
            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Sign of Overheating",
              titleResponse: inspectionData.overHeat,
              remarkResponse:
                  remarkData != null ? remarkData!.overHeatRemark : "",
              warningConditionValue: 'Yes',
            ),

            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 5),
            Text(
              "04 . UPS Reading",
              style: themeData.textTheme.headlineSmall!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: custom.mainTextColor,
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
                      "Voltage Measurements",
                      style: themeData.textTheme.bodyMedium!.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: custom.mainTextColor,
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
                              style: themeData.textTheme.bodyMedium!.copyWith(
                                color: custom.mainTextColor,
                              ),
                            ),
                            Text(
                              '${inspectionData.voltagePs1} V',
                              style: themeData.textTheme.bodyMedium!.copyWith(
                                color: custom.mainTextColor,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Phase 2",
                              style: themeData.textTheme.bodyMedium!.copyWith(
                                color: custom.mainTextColor,
                              ),
                            ),
                            Text(
                              '${inspectionData.voltagePs2} V',
                              style: themeData.textTheme.bodyMedium!.copyWith(
                                color: custom.mainTextColor,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Phase 3",
                              style: themeData.textTheme.bodyMedium!.copyWith(
                                color: custom.mainTextColor,
                              ),
                            ),
                            Text(
                              '${inspectionData.voltagePs3} V',
                              style: themeData.textTheme.bodyMedium!.copyWith(
                                color: custom.mainTextColor,
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
                      "Current Measurements",
                      style: themeData.textTheme.bodyMedium!.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: custom.mainTextColor,
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
                              style: themeData.textTheme.bodyMedium!.copyWith(
                                color: custom.mainTextColor,
                              ),
                            ),
                            Text(
                              '${inspectionData.currentPs1} A',
                              style: themeData.textTheme.bodyMedium!.copyWith(
                                color: custom.mainTextColor,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Phase 2",
                              style: themeData.textTheme.bodyMedium!.copyWith(
                                color: custom.mainTextColor,
                              ),
                            ),
                            Text(
                              '${inspectionData.currentPs2} A',
                              style: themeData.textTheme.bodyMedium!.copyWith(
                                color: custom.mainTextColor,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Phase 3",
                              style: themeData.textTheme.bodyMedium!.copyWith(
                                color: custom.mainTextColor,
                              ),
                            ),
                            Text(
                              '${inspectionData.currentPs3} A',
                              style: themeData.textTheme.bodyMedium!.copyWith(
                                color: custom.mainTextColor,
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

            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 5),

            CustomOneDetailsCard(
              inspectionData: inspectionData,
              title: "Capacity",
              titleResponse: "${inspectionData.upsCapacity}%",
            ),
            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Additional Remark",
              titleResponse: "",
              remarkResponse: remarkData != null ? remarkData!.addiRemark : "",
              warningConditionValue: "additionalremark",
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
  });

  final UpsInspectionData inspectionData;
  final String title;
  final String titleResponse;

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return Card(
      color: customColors.suqarBackgroundColor,

      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          top: 20,
          bottom: 20,
          right: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(title), Text(titleResponse)],
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
  });

  final UpsInspectionData inspectionData;
  final UpsRemarkData? remarkData;
  final String title;
  final String titleResponse;
  final String remarkResponse;
  final String warningConditionValue;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeData = themeProvider.currentTheme;
    final custom = themeData.extension<CustomColors>()!;
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Card(
      color: customColors.suqarBackgroundColor,

      // color:
      //     warningConditionValue == "additionalremark"
      //         ? Theme.of(context).cardColor
      //         : titleResponse == warningConditionValue
      //         ? Color.fromARGB(172, 216, 127, 121)
      //         : Theme.of(context).cardColor,
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: themeData.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w400,
                color: custom.mainTextColor,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  titleResponse,
                  style: themeData.textTheme.bodyMedium!.copyWith(
                    color: custom.mainTextColor,
                  ),
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
            remarkResponse.isNotEmpty
                ? Text(
                  "Remark: $remarkResponse",
                  style: themeData.textTheme.bodyMedium!.copyWith(
                    color: custom.mainTextColor,
                  ),
                )
                : const SizedBox.shrink(),
      ),
    );
  }
}

//v1
// import 'package:flutter/material.dart';
// import 'package:powerprox/Screens/UPS/UPSInspectionView/ups_inspection_data.dart';
//
//
// class UpsInspectionDetailsPage extends StatelessWidget {
//   final UpsInspectionData inspectionData;
//   final UpsRemarkData? remarkData;
//   final UPSDetails? upsDetails;
//
//   UpsInspectionDetailsPage(
//       {required this.inspectionData,
//       required this.remarkData,
//       this.upsDetails});
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
//                     upsDetails != null
//                         ? Column(
//                             children: [
//                               Text(
//                                   'Location : ${upsDetails!.rtom} ${upsDetails!.station}'),
//                               Text(
//                                   '${upsDetails!.brand} | (${upsDetails!.model})'),
//                             ],
//                           )
//                         : SizedBox.shrink(),
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
//
//             Text(
//               "01 . Genaral Inspection",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Check Ventilation of the room",
//               titleResponse: inspectionData.ventilation,
//               remarkResponse:
//                   remarkData != null ? remarkData!.ventilationRemark : "",
//               warningConditionValue: 'Not Ok',
//             ),
//
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title:
//                   "Cleck the battery \ncabinet temperature \n(20-25 Centigrade)",
//               titleResponse: inspectionData.cabinTemp,
//               remarkResponse:
//                   remarkData != null ? remarkData!.cabinTempRemark : "",
//               warningConditionValue: 'Others',
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Measure Hydrogen gas Emission",
//               titleResponse: inspectionData.h2GasEmission,
//               remarkResponse:
//                   remarkData != null ? remarkData!.h2GasEmissionRemark : "",
//               warningConditionValue: 'Yes',
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Keep UPS free and \nclean of any dust",
//               titleResponse: inspectionData.dust,
//               remarkResponse: remarkData != null ? remarkData!.dustRemark : "",
//               warningConditionValue: 'Not Ok',
//             ),
//
//             SizedBox(
//               height: 5,
//             ),
//             Divider(),
//             SizedBox(
//               height: 5,
//             ),
//
//             Text(
//               "02 . Batter Inspection",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Check Cleanliness",
//               titleResponse: inspectionData.batClean,
//               remarkResponse:
//                   remarkData != null ? remarkData!.batCleanRemark : "",
//               warningConditionValue: 'Not Ok',
//             ),
//
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Check Terminal Voltage",
//               titleResponse: inspectionData.trmVolt,
//               remarkResponse:
//                   remarkData != null ? remarkData!.trmVoltRemark : "",
//               warningConditionValue: 'Not Ok',
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Check for any leakage",
//               titleResponse: inspectionData.leak,
//               remarkResponse: remarkData != null ? remarkData!.leakRemark : "",
//               warningConditionValue: 'Yes',
//             ),
//
//             SizedBox(
//               height: 5,
//             ),
//             Divider(),
//             SizedBox(
//               height: 5,
//             ),
//
//             Text(
//               "03 . Daily Inspection of the UPS",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Mimic LED Indication",
//               titleResponse: inspectionData.mimicLED,
//               remarkResponse:
//                   remarkData != null ? remarkData!.mimicLEDRemark : "",
//               warningConditionValue: 'Not Work',
//             ),
//
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "All metered parameters",
//               titleResponse: inspectionData.meterPara,
//               remarkResponse:
//                   remarkData != null ? remarkData!.meterParaRemark : "",
//               warningConditionValue: 'Not Ok',
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Warning or Alarm Massages",
//               titleResponse: inspectionData.warningAlarm,
//               remarkResponse:
//                   remarkData != null ? remarkData!.warningAlarmRemark : "",
//               warningConditionValue: 'Yes',
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Sign of Overheating",
//               titleResponse: inspectionData.overHeat,
//               remarkResponse:
//                   remarkData != null ? remarkData!.overHeatRemark : "",
//               warningConditionValue: 'Yes',
//             ),
//
//             SizedBox(
//               height: 5,
//             ),
//             Divider(),
//             SizedBox(
//               height: 5,
//             ),
//             const Text(
//               "04 . UPS Reading",
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
//                     "Voltage Measurements",
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
//                     "Current Measurements",
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
//             SizedBox(
//               height: 5,
//             ),
//             Divider(),
//             SizedBox(
//               height: 5,
//             ),
//
//             //DC Output
//             // Card(
//             //     child: Padding(
//             //   padding: const EdgeInsets.only(
//             //       right: 15, bottom: 5, top: 10, left: 15),
//             //   child: Column(
//             //     mainAxisAlignment: MainAxisAlignment.start,
//             //     children: [
//             //       Text(
//             //         "DC Output",
//             //         style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//             //       ),
//             //       SizedBox(
//             //         height: 5,
//             //       ),
//             //       Row(
//             //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //         children: [
//             //           Column(
//             //             mainAxisAlignment: MainAxisAlignment.center,
//             //             children: [
//             //               Text("Voltage"),
//             //               Text('${inspectionData.dcVoltage} V')
//             //             ],
//             //           ),
//             //           Column(
//             //             mainAxisAlignment: MainAxisAlignment.center,
//             //             children: [
//             //               Text("Phase 2"),
//             //               Text('${inspectionData.dcCurrent} A')
//             //             ],
//             //           ),
//             //         ],
//             //       ),
//             //     ],
//             //   ),
//             // )),
//
//             CustomOneDetailsCard(
//                 inspectionData: inspectionData,
//                 title: "Capacity",
//                 titleResponse: "${inspectionData.upsCapacity}%"),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Additional Remark",
//               titleResponse: "",
//               remarkResponse: remarkData != null ? remarkData!.addiRemark : "",
//               warningConditionValue: "additionalremark",
//             ),
//             // CustomDetailsCard(
//             //     inspectionData: inspectionData,
//             //     remarkData: remarkData,
//             //     title: "Indicator Status",
//             //     titleResponse: inspectionData.recIndicatorStatus,
//             //     remarkResponse: remarkData.indRemark)
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
//   final UpsInspectionData inspectionData;
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
//   final UpsInspectionData inspectionData;
//   final UpsRemarkData? remarkData;
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
//         subtitle: remarkResponse.isNotEmpty
//             ? Text("Remark: $remarkResponse")
//             : const SizedBox.shrink(),
//       ),
//     );
//   }
// }
