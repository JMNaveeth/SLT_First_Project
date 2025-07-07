import 'package:flutter/material.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/utils/utils/colors.dart';

//import '../../../HomePage/widgets/colors.dart';
import 'deg_inspection_data.dart';

class DegInspectionDetailsPage extends StatelessWidget {
  final DegInspectionData inspectionData;
  final DegRemarkData? remarkData;
  final DEGDetails? degDetails;

  DegInspectionDetailsPage({
    required this.inspectionData,
    this.remarkData,
    this.degDetails,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: customColors.mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: customColors.appbarColor,
        title: Text(
          'Inspection Detail',
          style: TextStyle(color: customColors.mainTextColor),
        ),
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],

        iconTheme: IconThemeData(color: customColors.mainTextColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            //Text('ID: ${inspectionData.id}'),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ), // Margin around the container
              decoration: BoxDecoration(
                color: customColors.suqarBackgroundColor, // Background color of the ListTile
                borderRadius: BorderRadius.circular(8.0), // Border radius
                boxShadow:  [
                  BoxShadow(
                    color: customColors.subTextColor, // Shadow color
                   // Shadow position
                  ),
                ],
              ),

              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${inspectionData.clockTime}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: customColors.mainTextColor,
                      ),
                    ),
                    Text(
                      " ${inspectionData.shift}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: customColors.mainTextColor,
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
                          'DEG Id: ${inspectionData.degId}',
                          style: TextStyle(color: customColors.mainTextColor),
                        ),
                      ],
                    ),
                    degDetails != null
                        ? Column(
                          children: [
                            // Text(
                            //     'Location : ${degDetails!.rtom} ${degDetails!.station}'),
                            Text(
                              '${degDetails!.brand_set} ',
                              style: TextStyle(color: customColors.subTextColor),
                            ),
                          ],
                        )
                        : SizedBox.shrink(),
                         // --- ADD THIS BLOCK FOR GPS ---
  Row(
  children: [
    Icon(Icons.location_on, color: customColors.subTextColor, size: 18),
    SizedBox(width: 4),
    Expanded(
      child: Builder(
        builder: (context) {
          print('View Location Data - Lat: ${inspectionData.Latitude}, Long: ${inspectionData.Longitude}');
          
          return Text(
            "Location: ${inspectionData.Latitude.isNotEmpty ? inspectionData.Latitude : 'Not Available'}, "
            "${inspectionData.Longitude.isNotEmpty ? inspectionData.Longitude : 'Not Available'}",
            style: TextStyle(color: customColors.subTextColor),
          );
        }
      ),
    ),
  ],
),
    // --- END GPS BLOCK ---
                    Text(
                      "Checked By : ${inspectionData.username}",
                      style: TextStyle(color: customColors.subTextColor),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 5),

            Text(
              "01 . Genaral Inspection",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: customColors.mainTextColor,
              ),
            ),
            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Cleanliness of DEG",
              titleResponse: inspectionData.degClean,
              remarkResponse:
                  remarkData != null ? remarkData!.degCleanRemark : "",
              warningConditionValue: 'Not Ok',
            ),

            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Cleanliness surrounding the \nDiesel Tank/Pump",
              titleResponse: inspectionData.surroundClean,
              remarkResponse:
                  remarkData != null ? remarkData!.surroundCleanRemark : "",
              warningConditionValue: 'Not Ok',
            ),

            // CustomDetailsCard(
            //   inspectionData: inspectionData,
            //   remarkData: remarkData,
            //   title: "Condition of Vee Belts",
            //   titleResponse: inspectionData.h2GasEmission,
            //   remarkResponse:
            //       remarkData != null ? remarkData!.h2GasEmissionRemark : "",
            //   warningConditionValue: 'Not Ok',
            // ),
            // CustomDetailsCard(
            //   inspectionData: inspectionData,
            //   remarkData: remarkData,
            //   title: "Keep DEG free and \nclean of any dust",
            //   titleResponse: inspectionData.dust,
            //   remarkResponse: remarkData != null ? remarkData!.dustRemark : "",
            //   warningConditionValue: 'Not Ok',
            // ),
            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 5),

            Text(
              "02 . Generator Controller",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: customColors.mainTextColor,
              ),
            ),
            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Alarms",
              titleResponse: inspectionData.alarm,
              remarkResponse: remarkData != null ? remarkData!.alarmRemark : "",
              warningConditionValue: 'Yes',
            ),

            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Warnings",
              titleResponse: inspectionData.warning,
              remarkResponse:
                  remarkData != null ? remarkData!.warningRemark : "",
              warningConditionValue: 'Yes',
            ),
            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Visible Issues/Damages",
              titleResponse: inspectionData.issue,
              remarkResponse: remarkData != null ? remarkData!.issueRemark : "",
              warningConditionValue: 'Yes',
            ),

            // CustomDetailsCard(
            //   inspectionData: inspectionData,
            //   remarkData: remarkData,
            //   title: "Visible Issues/Damages",
            //   titleResponse: inspectionData.issue,
            //   remarkResponse: remarkData != null ? remarkData!.issueRemark : "",
            //   warningConditionValue: 'Yes',
            // ),
            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 5),

            Text(
              "03 . Cooling System Check",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: customColors.mainTextColor,
              ),
            ),
            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title:
                  "Water Leak from Radiator,\nEngine hoses and connections. ",
              titleResponse: inspectionData.leak,
              remarkResponse: remarkData != null ? remarkData!.leakRemark : "",
              warningConditionValue: 'Yes',
            ),

            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Coolant/Water Level",
              titleResponse: inspectionData.waterLevel,
              remarkResponse:
                  remarkData != null ? remarkData!.waterLevelRemark : "",
              warningConditionValue: 'Not Ok',
            ),
            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Radiator exterior",
              titleResponse: inspectionData.exterior,
              remarkResponse:
                  remarkData != null ? remarkData!.exteriorRemark : "",
              warningConditionValue: 'Yes',
            ),

            // CustomDetailsCard(
            //   inspectionData: inspectionData,
            //   remarkData: remarkData,
            //   title: "Sign of Overheating",
            //   titleResponse: inspectionData.overHeat,
            //   remarkResponse:
            //       remarkData != null ? remarkData!.overHeatRemark : "",
            //   warningConditionValue: 'Yes',
            // ),
            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 5),

            Text(
              "04 . Fuel System Check",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: customColors.mainTextColor,
              ),
            ),
            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Fuel Leak",
              titleResponse: inspectionData.fuelLeak,
              remarkResponse:
                  remarkData != null ? remarkData!.fuelLeakRemark : "",
              warningConditionValue: 'Yes',
            ),

            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Fuel Tank Leak",
              titleResponse: inspectionData.tankLeak,
              remarkResponse:
                  remarkData != null ? remarkData!.tankLeakRemark : "",
              warningConditionValue: 'Yes',
            ),

            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Fuel Tank Swell",
              titleResponse: inspectionData.tankSwell,
              remarkResponse:
                  remarkData != null ? remarkData!.tankSwellRemark : "",
              warningConditionValue: 'Yes',
            ),

            SizedBox(height: 5),
            Divider(),

            Text(
              "05 . Air Filter Status",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: customColors.mainTextColor,
              ),
            ),
            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Air Filter Cleanliness",
              titleResponse: inspectionData.airFilter,
              remarkResponse:
                  remarkData != null ? remarkData!.airFilterRemark : "",
              warningConditionValue: 'No',
            ),

            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 5),

            Text(
              "06 . Gas Emissions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: customColors.mainTextColor,
              ),
            ),
            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Hydrogen Gas Emission",
              titleResponse: inspectionData.gasEmission,
              remarkResponse:
                  remarkData != null ? remarkData!.gasEmissionRemark : "",
              warningConditionValue: 'Yes',
            ),

            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 5),

            Text(
              "07 . Lubrication",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: customColors.mainTextColor,
              ),
            ),
            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Oil Leak",
              titleResponse: inspectionData.oilLeak,
              remarkResponse:
                  remarkData != null ? remarkData!.oilLeakRemark : "",
              warningConditionValue: 'Yes',
            ),

            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 5),

            Text(
              "08 . Starter Batteries",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: customColors.mainTextColor,
              ),
            ),
            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Battery Cleanliness",
              titleResponse: inspectionData.batClean,
              remarkResponse:
                  remarkData != null ? remarkData!.batCleanRemark : "",
              warningConditionValue: 'No',
            ),

            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Battery Terminal Voltage",
              titleResponse: inspectionData.batVoltage,
              remarkResponse:
                  remarkData != null ? remarkData!.batVoltageRemark : "",
              warningConditionValue: 'Not Ok',
            ),

            CustomDetailsCard(
              inspectionData: inspectionData,
              remarkData: remarkData,
              title: "Battery Charger",
              titleResponse: inspectionData.batCharger,
              remarkResponse:
                  remarkData != null ? remarkData!.batChargerRemark : "",
              warningConditionValue: 'Not Ok',
            ),

            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 5),

            Text(
              "09 . Battery Voltages",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: customColors.mainTextColor,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ), // Margin around the container
              decoration: BoxDecoration(
                color: customColors.suqarBackgroundColor, // Background color of the ListTile
                borderRadius: BorderRadius.circular(8.0), // Border radius
                boxShadow: [
                  BoxShadow(
                    color: customColors.subTextColor, // Shadow color
                   // Shadow position
                  ),
                ],
              ),
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
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: customColors.mainTextColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    Wrap(
                      spacing: 40, // Spacing between the columns
                      runSpacing:
                          10, // Optional spacing between rows if the wrap continues
                      children: [
                        if (inspectionData.bat1 !=
                            '0') // Condition to show Bat 1 only if not 0
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Bat 1",
                                style: TextStyle(color: customColors.subTextColor),
                              ),
                              Text(
                                '${inspectionData.bat1} V',
                                style: TextStyle(color: customColors.subTextColor),
                              ),
                            ],
                          ),
                        if (inspectionData.bat2 !=
                            '0') // Condition to show Bat 2 only if not 0
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Bat 2",
                                style: TextStyle(color: customColors.subTextColor),
                              ),
                              Text(
                                '${inspectionData.bat2} V',
                                style: TextStyle(color: customColors.subTextColor),
                              ),
                            ],
                          ),
                        if (inspectionData.bat3 !=
                            '0') // Condition to show Bat 3 only if not 0
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Bat 3"),
                              Text('${inspectionData.bat3} V'),
                            ],
                          ),
                        if (inspectionData.bat4 !=
                            '0') // Condition to show Bat 4 only if not 0
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Bat 4"),
                              Text('${inspectionData.bat4} V'),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            //Current Reading
            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 5),

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

  final DegInspectionData inspectionData;
  final String title;
  final String titleResponse;

  @override
  Widget build(BuildContext context) {
    return Card(
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

  final DegInspectionData inspectionData;
  final DegRemarkData? remarkData;
  final String title;
  final String titleResponse;
  final String remarkResponse;
  final String warningConditionValue;

  @override
  Widget build(BuildContext context) {
        final customColors = Theme.of(context).extension<CustomColors>()!;

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ), // Margin around the container
      decoration: BoxDecoration(
        color: customColors.suqarBackgroundColor, // Background color of the ListTile
        borderRadius: BorderRadius.circular(8.0), // Border radius
        boxShadow: [
          BoxShadow(
            color: customColors.subTextColor, // Shadow color
            // Shadow position
          ),
        ],
      ),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: customColors.mainTextColor,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(titleResponse, style: TextStyle(color: customColors.subTextColor)),

                  SizedBox(width: 4),

                  warningConditionValue == "additionalremark"
                      ? const SizedBox.shrink() // Empty space
                      : titleResponse == warningConditionValue
                      ? Icon(Icons.cancel, color: Colors.red)
                      : Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
            ],
          ),
        ),
        subtitle:
            remarkResponse.isNotEmpty
                ? Text("Remark: $remarkResponse")
                : const SizedBox.shrink(),
      ),
    );
  }
}

//v1
// import 'package:flutter/material.dart';
// import 'deg_inspection_data.dart';
//
//
// class DegInspectionDetailsPage extends StatelessWidget {
//   final DegInspectionData inspectionData;
//   final DegRemarkData? remarkData;
//   final DEGDetails? degDetails;
//
//   DegInspectionDetailsPage(
//       {required this.inspectionData,
//       this.remarkData,
//       this.degDetails});
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
//                         Text('DEG Id: ${inspectionData.degId}'),
//                       ],
//                     ),
//                     degDetails != null
//                         ? Column(
//                             children: [
//                               // Text(
//                               //     'Location : ${degDetails!.rtom} ${degDetails!.station}'),
//                               Text(
//                                   '${degDetails!.brand_set} '),
//                             ],
//                           )
//                         : SizedBox.shrink(),
//                     Text("Checked By : ${inspectionData.username}")
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
//               title: "Cleanliness of DEG",
//               titleResponse: inspectionData.degClean,
//               remarkResponse:
//                   remarkData != null ? remarkData!.degCleanRemark : "",
//               warningConditionValue: 'Not Ok',
//             ),
//
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title:
//                   "Cleanliness surrounding the \nDiesel Tank/Pump",
//               titleResponse: inspectionData.surroundClean,
//               remarkResponse:
//                   remarkData != null ? remarkData!.surroundCleanRemark : "",
//               warningConditionValue: 'Not Ok',
//             ),
//             // CustomDetailsCard(
//             //   inspectionData: inspectionData,
//             //   remarkData: remarkData,
//             //   title: "Condition of Vee Belts",
//             //   titleResponse: inspectionData.h2GasEmission,
//             //   remarkResponse:
//             //       remarkData != null ? remarkData!.h2GasEmissionRemark : "",
//             //   warningConditionValue: 'Not Ok',
//             // ),
//             // CustomDetailsCard(
//             //   inspectionData: inspectionData,
//             //   remarkData: remarkData,
//             //   title: "Keep DEG free and \nclean of any dust",
//             //   titleResponse: inspectionData.dust,
//             //   remarkResponse: remarkData != null ? remarkData!.dustRemark : "",
//             //   warningConditionValue: 'Not Ok',
//             // ),
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
//               "02 . Generator Controller",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Alarms",
//               titleResponse: inspectionData.alarm,
//               remarkResponse:
//                   remarkData != null ? remarkData!.alarmRemark : "",
//               warningConditionValue: 'Yes',
//             ),
//
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Warnings",
//               titleResponse: inspectionData.warning,
//               remarkResponse:
//                   remarkData != null ? remarkData!.warningRemark : "",
//               warningConditionValue: 'Yes',
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Visible Issues/Damages",
//               titleResponse: inspectionData.issue,
//               remarkResponse: remarkData != null ? remarkData!.issueRemark : "",
//               warningConditionValue: 'Yes',
//             ),
//             // CustomDetailsCard(
//             //   inspectionData: inspectionData,
//             //   remarkData: remarkData,
//             //   title: "Visible Issues/Damages",
//             //   titleResponse: inspectionData.issue,
//             //   remarkResponse: remarkData != null ? remarkData!.issueRemark : "",
//             //   warningConditionValue: 'Yes',
//             // ),
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
//               "03 . Cooling System Check",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Water Leak from Radiator,\nEngine hoses and connections. ",
//               titleResponse: inspectionData.leak,
//               remarkResponse:
//                   remarkData != null ? remarkData!.leakRemark : "",
//               warningConditionValue: 'Yes',
//             ),
//
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Coolant/Water Level",
//               titleResponse: inspectionData.waterLevel,
//               remarkResponse:
//                   remarkData != null ? remarkData!.waterLevelRemark : "",
//               warningConditionValue: 'Not Ok',
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Radiator exterior",
//               titleResponse: inspectionData.exterior,
//               remarkResponse:
//                   remarkData != null ? remarkData!.exteriorRemark : "",
//               warningConditionValue: 'Yes',
//             ),
//             // CustomDetailsCard(
//             //   inspectionData: inspectionData,
//             //   remarkData: remarkData,
//             //   title: "Sign of Overheating",
//             //   titleResponse: inspectionData.overHeat,
//             //   remarkResponse:
//             //       remarkData != null ? remarkData!.overHeatRemark : "",
//             //   warningConditionValue: 'Yes',
//             // ),
//
//             SizedBox(
//               height: 5,
//             ),
//             Divider(),
//             SizedBox(
//               height: 5,
//             ),
//
//
//             Text(
//               "04 . Fuel System Check",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Fuel Leak",
//               titleResponse: inspectionData.fuelLeak,
//               remarkResponse:
//               remarkData != null ? remarkData!.fuelLeakRemark : "",
//               warningConditionValue: 'Yes',
//             ),
//
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Fuel Tank Leak",
//               titleResponse: inspectionData.tankLeak,
//               remarkResponse:
//               remarkData != null ? remarkData!.tankLeakRemark : "",
//               warningConditionValue: 'Yes',
//             ),
//
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Fuel Tank Swell",
//               titleResponse: inspectionData.tankSwell,
//               remarkResponse:
//               remarkData != null ? remarkData!.tankSwellRemark : "",
//               warningConditionValue: 'Yes',
//             ),
//
//
//             SizedBox(
//               height: 5,
//             ),
//             Divider(),
//
//             Text(
//               "05 . Air Filter Status",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Air Filter Cleanliness",
//               titleResponse: inspectionData.airFilter,
//               remarkResponse:
//               remarkData != null ? remarkData!.airFilterRemark : "",
//               warningConditionValue: 'No',
//             ),
//
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
//               "06 . Gas Emissions",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Hydrogen Gas Emission",
//               titleResponse: inspectionData.gasEmission,
//               remarkResponse:
//               remarkData != null ? remarkData!.gasEmissionRemark : "",
//               warningConditionValue: 'Yes',
//             ),
//
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
//               "07 . Lubrication",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Oil Leak",
//               titleResponse: inspectionData.oilLeak,
//               remarkResponse:
//               remarkData != null ? remarkData!.oilLeakRemark : "",
//               warningConditionValue: 'Yes',
//             ),
//
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
//               "08 . Starter Batteries",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Battery Cleanliness",
//               titleResponse: inspectionData.batClean,
//               remarkResponse:
//               remarkData != null ? remarkData!.batCleanRemark : "",
//               warningConditionValue: 'No',
//             ),
//
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Battery Terminal Voltage",
//               titleResponse: inspectionData.batVoltage,
//               remarkResponse:
//               remarkData != null ? remarkData!.batVoltageRemark : "",
//               warningConditionValue: 'Not Ok',
//             ),
//
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Battery Charger",
//               titleResponse: inspectionData.batCharger,
//               remarkResponse:
//               remarkData != null ? remarkData!.batChargerRemark : "",
//               warningConditionValue: 'Not Ok',
//             ),
//
//
//             SizedBox(
//               height: 5,
//             ),
//             Divider(),
//             SizedBox(
//               height: 5,
//             ),
//
//             const Text(
//               "09 . Battery Voltages",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.only(
//                     right: 15, bottom: 5, top: 10, left: 15),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Voltage Measurements",
//                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Wrap(
//                       spacing: 40, // Spacing between the columns
//                       runSpacing: 10, // Optional spacing between rows if the wrap continues
//                       children: [
//                         if (inspectionData.bat1 != '0') // Condition to show Bat 1 only if not 0
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text("Bat 1"),
//                               Text('${inspectionData.bat1} V'),
//                             ],
//                           ),
//                         if (inspectionData.bat2 != '0') // Condition to show Bat 2 only if not 0
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text("Bat 2"),
//                               Text('${inspectionData.bat2} V'),
//                             ],
//                           ),
//                         if (inspectionData.bat3 != '0') // Condition to show Bat 3 only if not 0
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text("Bat 3"),
//                               Text('${inspectionData.bat3} V'),
//                             ],
//                           ),
//                         if (inspectionData.bat4 != '0') // Condition to show Bat 4 only if not 0
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text("Bat 4"),
//                               Text('${inspectionData.bat4} V'),
//                             ],
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//
//
//             //Current Reading
//
//
//             SizedBox(
//               height: 5,
//             ),
//             Divider(),
//             SizedBox(
//               height: 5,
//             ),
//
//
//
//
//             CustomDetailsCard(
//               inspectionData: inspectionData,
//               remarkData: remarkData,
//               title: "Additional Remark",
//               titleResponse: "",
//               remarkResponse: remarkData != null ? remarkData!.addiRemark : "",
//               warningConditionValue: "additionalremark",
//             ),
//
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
//   final DegInspectionData inspectionData;
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
//   final DegInspectionData inspectionData;
//   final DegRemarkData? remarkData;
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
