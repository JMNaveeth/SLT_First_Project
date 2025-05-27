import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:powerprox/Screens/Other%20Assets/Rectifier/RectifierInspectionView/rec_inspection_data.dart';
import 'package:theme_update/Rectifier/RectifierInspectionView/rec_inspection_data.dart';


Future<List<RecInspectionData>> recFetchInspectionData() async {
  final response =
      await http.get(Uri.parse('https://powerprox.sltidc.lk/GETDailyRECCheck.php'));
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    return body
        .map((dynamic item) => RecInspectionData.fromJson(item))
        .toList();
  } else {
    throw Exception('Failed to load inspection data');
  }
}

Future<List<RecRemarkData>> recFetchRemarkData() async {
  final response =
      await http.get(Uri.parse('https://powerprox.sltidc.lk/GETDailyRECRemarks.php'));
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    return body.map((dynamic item) => RecRemarkData.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load remark data');
  }
}

Future<List<RectifierDetails>> rectifierDetailsFetchData() async {
  final response =
      await http.get(Uri.parse('https://powerprox.sltidc.lk/RectifierView.php'));
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    print(body.toString());

    return body.map((dynamic item) => RectifierDetails.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load inspection data');
  }
}
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
                              style: TextStyle(color: customColors.subTextColor),
                            ),
                            Text(
                              '${inspectionData.voltagePs1} V',
                              style: TextStyle(color: customColors.subTextColor),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Phase 2",
                              style: TextStyle(color: customColors.subTextColor),
                            ),
                            Text(
                              '${inspectionData.voltagePs2} V',
                              style: TextStyle(color: customColors.subTextColor),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Phase 3",
                              style: TextStyle(color: customColors.subTextColor),
                            ),
                            Text(
                              '${inspectionData.voltagePs3} V',
                              style: TextStyle(color: customColors.subTextColor),
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
                              style: TextStyle(color: customColors.subTextColor),
                            ),
                            Text(
                              '${inspectionData.currentPs1} A',
                              style: TextStyle(color: customColors.subTextColor),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Phase 2",
                              style: TextStyle(color: customColors.subTextColor),
                            ),
                            Text(
                              '${inspectionData.currentPs2} A',
                              style: TextStyle(color: customColors.subTextColor),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Phase 3",
                              style: TextStyle(color: customColors.subTextColor),
                            ),
                            Text(
                              '${inspectionData.currentPs3} A',
                              style: TextStyle(color: customColors.subTextColor),
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
                              style: TextStyle(color: customColors.subTextColor),
                            ),
                            Text(
                              '${inspectionData.dcVoltage} V',
                              style: TextStyle(color: customColors.subTextColor),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Current",
                              style: TextStyle(color: customColors.subTextColor),
                            ),
                            Text(
                              '${inspectionData.dcCurrent} A',
                              style: TextStyle(color: customColors.subTextColor),
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
