import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';

//import 'package:slt_generator_user/Screens/Battery/ViewBatteryDetails.dart';
//import 'package:slt_generator_user/Screens/BatteryMaintenancePage.dart';
import '../../utils/utils/colors.dart';
import 'ViewBatteryDetails.dart';

import 'ViewBatteryUnit.dart';

class CombinedSetPage extends StatefulWidget {
  final String systemID1;
  final int setCount;
  final String searchQuery;

  CombinedSetPage({
    Key? key,
    required this.systemID1,
    required this.setCount,
    this.searchQuery = '',
  }) : super(key: key);

  @override
  _CombinedSetPageState createState() => _CombinedSetPageState();
}

class _CombinedSetPageState extends State<CombinedSetPage> {
  bool _dataLoaded = false;
  List<dynamic> _dataList = [];
  List<dynamic> _batteryLinkData = [];
  bool _matchFound = false;
  List<Map<String, dynamic>> _matchedStations = [];
  List<Map<String, dynamic>> _matchedData = [];

  @override
  void initState() {
    super.initState();
    _fetchBatterySets();
  }

  Future<void> _fetchBatterySets() async {
    final String dataURL = 'https://powerprox.sltidc.lk/GetBattSets.php';
    try {
      final response = await http.get(Uri.parse(dataURL));
      if (response.statusCode == 200) {
        setState(() {
          _dataLoaded = true;
          _dataList = json.decode(response.body);
          List<Map<String, dynamic>> filteredStations =
              _dataList
                  .where((station) => (station['SystemID'] == widget.systemID1))
                  .cast<Map<String, dynamic>>()
                  .toList();

          _matchedStations = filteredStations;

          // Fetch the second endpoint's data and compare
          _fetchAndCompareBatteryLinkData();
        });
      } else {
        setState(() {
          _dataLoaded = false;
        });
        throw Exception('Failed to load battery sets data');
      }
    } catch (e) {
      setState(() {
        _dataLoaded = false;
      });
      print(e.toString());
    }
  }

  Future<void> _fetchAndCompareBatteryLinkData() async {
    final String linkDataURL =
        'https://powerprox.sltidc.lk/GETBattery_link.php';
    try {
      final response = await http.get(Uri.parse(linkDataURL));
      if (response.statusCode == 200) {
        setState(() {
          _batteryLinkData = json.decode(response.body);

          // Clear _matchedData before adding new results
          _matchedData.clear();

          // Compare _matchedStations[i]["SetID"] with _batteryLinkData["Batt_SetID"]
          for (int i = 0; i < _matchedStations.length && i < 4; i++) {
            String setId = _matchedStations[i]['SetID'];
            var matched = _batteryLinkData.firstWhere(
              (data) => data['Batt_SetID'] == 'BS:$setId',
              orElse: () => null,
            );

            print(matched);

            // Check if matched is not null and the link_active field is set to "Active"
            if (matched != null && matched['link_active'] == 'Active') {
              _matchedData.add(matched);
              print('Matched active data for SetID $setId: $matched');
            } else if (matched != null) {
              // Optional: Print if the data is inactive
              print('Ignored inactive data for SetID $setId: $matched');
            }
          }
        });
      } else {
        throw Exception('Failed to load battery link data');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Card makeButtonCard(Lesson lesson, String ID) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: SizedBox(
        height: 80.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: customColors.subTextColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // Space between text and button
            children: [
              Expanded(
                child: makeListTile(
                  lesson.subjectName,
                  lesson.variable,
                ), // Text content
              ),
              // Conditional rendering of the button
              ID != 'N/A'
                  ? ElevatedButton(
                    onPressed: () {
                      // Handle button press here
                      print("View button clicked: ${lesson.variable}");
                    },
                    child: Text('View'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ), // Adjust button padding
                    ),
                  )
                  : SizedBox(), // Empty widget when ID is 'N/A'
            ],
          ),
        ),
      ),
    );
  }

  ListTile makeListTile(String subjectName, String? variable) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      leading: Container(
        padding: const EdgeInsets.only(right: 12.0),
        decoration:  BoxDecoration(
          border: Border(right: BorderSide(width: 1.0, color: customColors.mainTextColor)),
        ),
        child: Text(
          subjectName,
          style: TextStyle(
            color: customColors.mainTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        variable ?? 'N/A',
        style:  TextStyle(
          color: customColors.mainTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Card makeCard(Lesson lesson) {
    final isMatch =
        widget.searchQuery.isNotEmpty &&
        (lesson.variable?.toString().toLowerCase().contains(
              widget.searchQuery.toLowerCase(),
            ) ??
            false);
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: SizedBox(
        height: 60.0,
        child: Container(
          decoration: BoxDecoration(
            color: customColors.suqarBackgroundColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            leading: Container(
              padding: const EdgeInsets.only(right: 12.0),
              decoration:  BoxDecoration(
                border: Border(
                  right: BorderSide(width: 1.0, color: customColors.mainTextColor),
                ),
              ),
              child: Text(
                lesson.subjectName,
                style: TextStyle(
                  color: customColors.mainTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  
                ),
              ),
            ),
            title: Text(
              lesson.variable ?? 'N/A',
              style: TextStyle(
                color: customColors.mainTextColor,
                backgroundColor: isMatch ? customColors.highlightColor : Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Card makeCard(Lesson lesson) => Card(
  //       elevation: 8.0,
  //       margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
  //       child: SizedBox(
  //         height: 60.0, // Adjust the height value as per your requirements
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: suqarBackgroundColor,
  //             borderRadius: BorderRadius.circular(12.0),
  //           ),
  //           child: makeListTile(lesson.subjectName, lesson.variable),
  //         ),
  //       ),
  //     );

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Battery Sets",
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
        child:
            _dataLoaded
                ? SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_matchedStations.length == 1)
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              "Battery Set 1",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                color: customColors.mainTextColor,
                              ),
                            ),
                            const SizedBox(height: 15),
                            makeCard(
                              Lesson(
                                subjectName: "Status",
                                variable:
                                    _matchedStations[0]["status"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set ID",
                                variable: _matchedStations[0]["SetID"],
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Rack ID",
                                variable:
                                    _matchedStations[0]["SystemID"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'System Type',
                                variable:
                                    _matchedStations[0]["sysType"] ?? 'N/A',
                              ),
                            ),
                            // Ensure _matchedData is not empty before accessing it
                            _matchedData.isNotEmpty
                                ? makeButtonCard(
                                  Lesson(
                                    subjectName: 'System ID',
                                    variable:
                                        _matchedData[0]["asset_tag"] ?? 'N/A',
                                  ),
                                  _matchedData[0]["asset_tag"],
                                )
                                : makeCard(
                                  Lesson(
                                    subjectName: 'System ID',
                                    variable: 'N/A',
                                  ),
                                ),
                            makeCard(
                              Lesson(
                                subjectName: 'Tray Count',
                                variable:
                                    _matchedStations[0]['trayCount'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Battery Voltage",
                                variable:
                                    _matchedStations[0]["batVolt"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'Battery Capacity',
                                variable:
                                    _matchedStations[0]['batCap'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Number of batteries in the rack",
                                variable:
                                    _matchedStations[0]["batCount"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'Brand',
                                variable: _matchedStations[0]['Brand'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Model",
                                variable: _matchedStations[0]["model"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName:
                                    'ConType', // change the subject name
                                variable:
                                    _matchedStations[0]['conType'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Trays Set",
                                variable:
                                    _matchedStations[0]["traysSet"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set Capacity",
                                variable:
                                    _matchedStations[0]["set_cap"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set Voltage",
                                variable:
                                    _matchedStations[0]["set_volt"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Installed Date",
                                variable:
                                    (_matchedStations[0]["installDt"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Warranty Commencement Date",
                                variable:
                                    (_matchedStations[0]["warrantSt"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Warranty Expiration Date",
                                variable:
                                    (_matchedStations[0]["warrantEd"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Last Update",
                                variable:
                                    _matchedStations[0]["last_updated"] ??
                                    'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Uploader",
                                variable:
                                    _matchedStations[0]["uploader"] ?? 'N/A',
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                const SizedBox(width: 100),
                                // ElevatedButton(
                                //   onPressed: () {
                                //     Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //           builder: (context) => ViewBatteryUnit(
                                //             batteryUnit: _matchedStations[0]
                                //             ["SystemID"],
                                //           ),
                                //         ));
                                //   },
                                //   child: Text(
                                //     "Back",
                                //     style: TextStyle(color: Colors.black),
                                //   ),
                                //   style: ElevatedButton.styleFrom(
                                //       primary: Colors.brown),
                                // ),
                                const SizedBox(width: 50),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ViewBatteryDetails(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(),
                                  child: const Text("Close"),
                                  // child: Text(
                                  //   "Close",
                                  //   style: TextStyle(color: Colors.black),
                                  // ),
                                  // style: ElevatedButton.styleFrom(
                                  //     backgroundColor: Colors.brown),
                                ),
                              ],
                            ),
                          ],
                        ),
                      if (_matchedStations.length == 2)
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                              "Battery Set 1",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 15),
                            makeCard(
                              Lesson(
                                subjectName: "Status",
                                variable:
                                    _matchedStations[0]["status"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set ID",
                                variable: _matchedStations[0]["SetID"],
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Rack ID",
                                variable:
                                    _matchedStations[0]["SystemID"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'System Type',
                                variable:
                                    _matchedStations[0]["sysType"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'System Type',
                                variable:
                                    _matchedStations[0]["sysType"] ?? 'N/A',
                              ),
                            ),
                            // Ensure _matchedData is not empty before accessing it
                            _matchedData.isNotEmpty
                                ? makeButtonCard(
                                  Lesson(
                                    subjectName: 'System ID',
                                    variable:
                                        _matchedData[0]["asset_tag"] ?? 'N/A',
                                  ),
                                  _matchedData[0]["asset_tag"],
                                )
                                : makeCard(
                                  Lesson(
                                    subjectName: 'System ID',
                                    variable: 'N/A',
                                  ),
                                ),
                            makeCard(
                              Lesson(
                                subjectName: 'Tray Count',
                                variable:
                                    _matchedStations[0]['trayCount'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Battery Voltage",
                                variable:
                                    _matchedStations[0]["batVolt"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'Battery Capacity',
                                variable:
                                    _matchedStations[0]['batCap'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Number of batteries in the rack",
                                variable:
                                    _matchedStations[0]["batCount"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'Brand',
                                variable: _matchedStations[0]['Brand'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Model",
                                variable: _matchedStations[0]["model"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName:
                                    'ConType', // change the subject name
                                variable:
                                    _matchedStations[0]['conType'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Trays Set",
                                variable:
                                    _matchedStations[0]["traysSet"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set Capacity",
                                variable:
                                    _matchedStations[0]["set_cap"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set Voltage",
                                variable:
                                    _matchedStations[0]["set_volt"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Installed Date",
                                variable:
                                    (_matchedStations[0]["installDt"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Warranty Commencement Date",
                                variable:
                                    (_matchedStations[0]["warrantSt"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Warranty Expiration Date",
                                variable:
                                    (_matchedStations[0]["warrantEd"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Last Update",
                                variable:
                                    _matchedStations[0]["last_updated"] ??
                                    'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Uploader",
                                variable:
                                    _matchedStations[0]["uploader"] ?? 'N/A',
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Battery Set 2",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 15),
                            makeCard(
                              Lesson(
                                subjectName: "Status",
                                variable:
                                    _matchedStations[1]["status"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set ID",
                                variable: _matchedStations[1]["SetID"],
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Rack ID",
                                variable:
                                    _matchedStations[1]["SystemID"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'System Type',
                                variable:
                                    _matchedStations[1]["sysType"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'System Type',
                                variable:
                                    _matchedStations[0]["sysType"] ?? 'N/A',
                              ),
                            ),
                            // Ensure _matchedData is not empty before accessing it
                            _matchedData.isNotEmpty
                                ? makeButtonCard(
                                  Lesson(
                                    subjectName: 'System ID',
                                    variable:
                                        _matchedData[1]["asset_tag"] ?? 'N/A',
                                  ),
                                  _matchedData[1]["asset_tag"],
                                )
                                : makeCard(
                                  Lesson(
                                    subjectName: 'System ID',
                                    variable: 'N/A',
                                  ),
                                ),
                            makeCard(
                              Lesson(
                                subjectName: 'Tray Count',
                                variable:
                                    _matchedStations[1]['trayCount'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Battery Voltage",
                                variable:
                                    _matchedStations[1]["batVolt"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'Battery Capacity',
                                variable:
                                    _matchedStations[1]['batCap'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Number of batteries in the rack",
                                variable:
                                    _matchedStations[1]["batCount"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'Brand',
                                variable: _matchedStations[1]['Brand'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Model",
                                variable: _matchedStations[1]["model"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName:
                                    'ConType', // change the subject name
                                variable:
                                    _matchedStations[1]['conType'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Trays Set",
                                variable:
                                    _matchedStations[1]["traysSet"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set Capacity",
                                variable:
                                    _matchedStations[1]["set_cap"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set Voltage",
                                variable:
                                    _matchedStations[1]["set_volt"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Installed Date",
                                variable:
                                    (_matchedStations[1]["installDt"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Warranty Commencement Date",
                                variable:
                                    (_matchedStations[1]["warrantSt"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Warranty Expiration Date",
                                variable:
                                    (_matchedStations[1]["warrantEd"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Last Update",
                                variable:
                                    _matchedStations[1]["last_updated"] ??
                                    'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Uploader",
                                variable:
                                    _matchedStations[1]["uploader"] ?? 'N/A',
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                const SizedBox(width: 100),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ViewBatteryUnit(
                                              batteryUnit:
                                                  _matchedStations[1]["SystemID"],
                                            ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(),
                                  child: const Text("Back"),
                                ),
                                const SizedBox(width: 50),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ViewBatteryDetails(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(),
                                  child: Text("Close"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      if (_matchedStations.length == 3)
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                              "Battery Set 1",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 15),
                            makeCard(
                              Lesson(
                                subjectName: "Status",
                                variable:
                                    _matchedStations[0]["status"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set ID",
                                variable: _matchedStations[0]["SetID"],
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Rack ID",
                                variable:
                                    _matchedStations[0]["SystemID"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'System Type',
                                variable:
                                    _matchedStations[0]["sysType"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'System Type',
                                variable:
                                    _matchedStations[0]["sysType"] ?? 'N/A',
                              ),
                            ),
                            // Ensure _matchedData is not empty before accessing it
                            _matchedData.isNotEmpty
                                ? makeButtonCard(
                                  Lesson(
                                    subjectName: 'System ID',
                                    variable:
                                        _matchedData[0]["asset_tag"] ?? 'N/A',
                                  ),
                                  _matchedData[0]["asset_tag"],
                                )
                                : makeCard(
                                  Lesson(
                                    subjectName: 'System ID',
                                    variable: 'N/A',
                                  ),
                                ),
                            makeCard(
                              Lesson(
                                subjectName: 'Tray Count',
                                variable:
                                    _matchedStations[0]['trayCount'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Battery Voltage",
                                variable:
                                    _matchedStations[0]["batVolt"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'Battery Capacity',
                                variable:
                                    _matchedStations[0]['batCap'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Number of batteries in the rack",
                                variable:
                                    _matchedStations[0]["batCount"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'Brand',
                                variable: _matchedStations[0]['Brand'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Model",
                                variable: _matchedStations[0]["model"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName:
                                    'ConType', // change the subject name
                                variable:
                                    _matchedStations[0]['conType'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Trays Set",
                                variable:
                                    _matchedStations[0]["traysSet"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set Capacity",
                                variable:
                                    _matchedStations[0]["set_cap"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set Voltage",
                                variable:
                                    _matchedStations[0]["set_volt"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Installed Date",
                                variable:
                                    (_matchedStations[0]["installDt"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Warranty Commencement Date",
                                variable:
                                    (_matchedStations[0]["warrantSt"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Warranty Expiration Date",
                                variable:
                                    (_matchedStations[0]["warrantEd"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Last Update",
                                variable:
                                    _matchedStations[0]["last_updated"] ??
                                    'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Uploader",
                                variable:
                                    _matchedStations[0]["uploader"] ?? 'N/A',
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Battery Set 2",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 15),
                            makeCard(
                              Lesson(
                                subjectName: "Status",
                                variable:
                                    _matchedStations[1]["status"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set ID",
                                variable: _matchedStations[1]["SetID"],
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Rack ID",
                                variable:
                                    _matchedStations[1]["SystemID"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'System Type',
                                variable:
                                    _matchedStations[1]["sysType"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'System Type',
                                variable:
                                    _matchedStations[0]["sysType"] ?? 'N/A',
                              ),
                            ),
                            // Ensure _matchedData is not empty before accessing it
                            _matchedData.isNotEmpty
                                ? makeButtonCard(
                                  Lesson(
                                    subjectName: 'System ID',
                                    variable:
                                        _matchedData[1]["asset_tag"] ?? 'N/A',
                                  ),
                                  _matchedData[1]["asset_tag"],
                                )
                                : makeCard(
                                  Lesson(
                                    subjectName: 'System ID',
                                    variable: 'N/A',
                                  ),
                                ),
                            makeCard(
                              Lesson(
                                subjectName: 'Tray Count',
                                variable:
                                    _matchedStations[1]['trayCount'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Battery Voltage",
                                variable:
                                    _matchedStations[1]["batVolt"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'Battery Capacity',
                                variable:
                                    _matchedStations[1]['batCap'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Number of batteries in the rack",
                                variable:
                                    _matchedStations[1]["batCount"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'Brand',
                                variable: _matchedStations[1]['Brand'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Model",
                                variable: _matchedStations[1]["model"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName:
                                    'ConType', // change the subject name
                                variable:
                                    _matchedStations[1]['conType'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Trays Set",
                                variable:
                                    _matchedStations[1]["traysSet"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set Capacity",
                                variable:
                                    _matchedStations[1]["set_cap"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set Voltage",
                                variable:
                                    _matchedStations[1]["set_volt"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Installed Date",
                                variable:
                                    (_matchedStations[1]["installDt"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Warranty Commencement Date",
                                variable:
                                    (_matchedStations[1]["warrantSt"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Warranty Expiration Date",
                                variable:
                                    (_matchedStations[1]["warrantEd"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Last Update",
                                variable:
                                    _matchedStations[1]["last_updated"] ??
                                    'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Uploader",
                                variable:
                                    _matchedStations[1]["uploader"] ?? 'N/A',
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Battery Set 3",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 15),
                            makeCard(
                              Lesson(
                                subjectName: "Status",
                                variable:
                                    _matchedStations[2]["status"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set ID",
                                variable: _matchedStations[2]["SetID"],
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Rack ID",
                                variable:
                                    _matchedStations[2]["SystemID"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'System Type',
                                variable:
                                    _matchedStations[2]["sysType"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'System Type',
                                variable:
                                    _matchedStations[0]["sysType"] ?? 'N/A',
                              ),
                            ),
                            // Ensure _matchedData is not empty before accessing it
                            _matchedData.isNotEmpty
                                ? makeButtonCard(
                                  Lesson(
                                    subjectName: 'System ID',
                                    variable:
                                        _matchedData[2]["asset_tag"] ?? 'N/A',
                                  ),
                                  _matchedData[2]["asset_tag"],
                                )
                                : makeCard(
                                  Lesson(
                                    subjectName: 'System ID',
                                    variable: 'N/A',
                                  ),
                                ),
                            makeCard(
                              Lesson(
                                subjectName: 'Tray Count',
                                variable:
                                    _matchedStations[2]['trayCount'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Battery Voltage",
                                variable:
                                    _matchedStations[2]["batVolt"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'Battery Capacity',
                                variable:
                                    _matchedStations[2]['batCap'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Number of batteries in the rack",
                                variable:
                                    _matchedStations[2]["batCount"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'Brand',
                                variable: _matchedStations[2]['Brand'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Model",
                                variable: _matchedStations[2]["model"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName:
                                    'ConType', // change the subject name
                                variable:
                                    _matchedStations[2]['conType'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Trays Set",
                                variable:
                                    _matchedStations[2]["traysSet"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set Capacity",
                                variable:
                                    _matchedStations[2]["set_cap"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set Voltage",
                                variable:
                                    _matchedStations[2]["set_volt"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Installed Date",
                                variable:
                                    (_matchedStations[2]["installDt"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Warranty Commencement Date",
                                variable:
                                    (_matchedStations[2]["warrantSt"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Warranty Expiration Date",
                                variable:
                                    (_matchedStations[2]["warrantEd"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Last Update",
                                variable:
                                    _matchedStations[2]["last_updated"] ??
                                    'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Uploader",
                                variable:
                                    _matchedStations[2]["uploader"] ?? 'N/A',
                              ),
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 100),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ViewBatteryUnit(
                                              batteryUnit:
                                                  _matchedStations[1]["SystemID"],
                                            ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(),
                                  child: Text("Back"),
                                ),
                                const SizedBox(width: 50),
                                ElevatedButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => BatteryMaintenancePage(),
                                    //     ));
                                  },
                                  style: ElevatedButton.styleFrom(),
                                  child: Text("Close"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      if (_matchedStations.length == 4)
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                              "Battery Set 1",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 15),
                            makeCard(
                              Lesson(
                                subjectName: "Status",
                                variable:
                                    _matchedStations[0]["status"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set ID",
                                variable: _matchedStations[0]["SetID"],
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Rack ID",
                                variable:
                                    _matchedStations[0]["SystemID"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'System Type',
                                variable:
                                    _matchedStations[0]["sysType"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'System Type',
                                variable:
                                    _matchedStations[0]["sysType"] ?? 'N/A',
                              ),
                            ),
                            // Ensure _matchedData is not empty before accessing it
                            _matchedData.isNotEmpty
                                ? makeButtonCard(
                                  Lesson(
                                    subjectName: 'System ID',
                                    variable:
                                        _matchedData[0]["asset_tag"] ?? 'N/A',
                                  ),
                                  _matchedData[0]["asset_tag"],
                                )
                                : makeCard(
                                  Lesson(
                                    subjectName: 'System ID',
                                    variable: 'N/A',
                                  ),
                                ),
                            makeCard(
                              Lesson(
                                subjectName: 'Tray Count',
                                variable:
                                    _matchedStations[0]['trayCount'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Battery Voltage",
                                variable:
                                    _matchedStations[0]["batVolt"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'Battery Capacity',
                                variable:
                                    _matchedStations[0]['batCap'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Number of batteries in the rack",
                                variable:
                                    _matchedStations[0]["batCount"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'Brand',
                                variable: _matchedStations[0]['Brand'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Model",
                                variable: _matchedStations[0]["model"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName:
                                    'ConType', // change the subject name
                                variable:
                                    _matchedStations[0]['conType'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Trays Set",
                                variable:
                                    _matchedStations[0]["traysSet"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set Capacity",
                                variable:
                                    _matchedStations[0]["set_cap"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set Voltage",
                                variable:
                                    _matchedStations[0]["set_volt"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Installed Date",
                                variable:
                                    (_matchedStations[0]["installDt"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Warranty Commencement Date",
                                variable:
                                    (_matchedStations[0]["warrantSt"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Warranty Expiration Date",
                                variable:
                                    (_matchedStations[0]["warrantEd"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Last Update",
                                variable:
                                    _matchedStations[0]["last_updated"] ??
                                    'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Uploader",
                                variable:
                                    _matchedStations[0]["uploader"] ?? 'N/A',
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Battery Set 2",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 15),
                            makeCard(
                              Lesson(
                                subjectName: "Status",
                                variable:
                                    _matchedStations[1]["status"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set ID",
                                variable: _matchedStations[1]["SetID"],
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Rack ID",
                                variable:
                                    _matchedStations[1]["SystemID"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'System Type',
                                variable:
                                    _matchedStations[1]["sysType"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'System Type',
                                variable:
                                    _matchedStations[0]["sysType"] ?? 'N/A',
                              ),
                            ),
                            // Ensure _matchedData is not empty before accessing it
                            _matchedData.isNotEmpty
                                ? makeButtonCard(
                                  Lesson(
                                    subjectName: 'System ID',
                                    variable:
                                        _matchedData[1]["asset_tag"] ?? 'N/A',
                                  ),
                                  _matchedData[1]["asset_tag"],
                                )
                                : makeCard(
                                  Lesson(
                                    subjectName: 'System ID',
                                    variable: 'N/A',
                                  ),
                                ),
                            makeCard(
                              Lesson(
                                subjectName: 'Tray Count',
                                variable:
                                    _matchedStations[1]['trayCount'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Battery Voltage",
                                variable:
                                    _matchedStations[1]["batVolt"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'Battery Capacity',
                                variable:
                                    _matchedStations[1]['batCap'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Number of batteries in the rack",
                                variable:
                                    _matchedStations[1]["batCount"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'Brand',
                                variable: _matchedStations[1]['Brand'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Model",
                                variable: _matchedStations[1]["model"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName:
                                    'ConType', // change the subject name
                                variable:
                                    _matchedStations[1]['conType'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Trays Set",
                                variable:
                                    _matchedStations[1]["traysSet"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set Capacity",
                                variable:
                                    _matchedStations[1]["set_cap"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set Voltage",
                                variable:
                                    _matchedStations[1]["set_volt"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Installed Date",
                                variable:
                                  ( _matchedStations[1]["installDt"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Warranty Commencement Date",
                                variable:
                                   ( _matchedStations[1]["warrantSt"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Warranty Expiration Date",
                                variable:
                                    (_matchedStations[1]["warrantEd"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Last Update",
                                variable:
                                    _matchedStations[1]["last_updated"] ??
                                    'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Uploader",
                                variable:
                                    _matchedStations[1]["uploader"] ?? 'N/A',
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Battery Set 3",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 15),
                            makeCard(
                              Lesson(
                                subjectName: "Status",
                                variable:
                                    _matchedStations[2]["status"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set ID",
                                variable: _matchedStations[2]["SetID"],
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Rack ID",
                                variable:
                                    _matchedStations[2]["SystemID"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'System Type',
                                variable:
                                    _matchedStations[2]["sysType"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'System Type',
                                variable:
                                    _matchedStations[0]["sysType"] ?? 'N/A',
                              ),
                            ),
                            // Ensure _matchedData is not empty before accessing it
                            _matchedData.isNotEmpty
                                ? makeButtonCard(
                                  Lesson(
                                    subjectName: 'System ID',
                                    variable:
                                        _matchedData[2]["asset_tag"] ?? 'N/A',
                                  ),
                                  _matchedData[2]["asset_tag"],
                                )
                                : makeCard(
                                  Lesson(
                                    subjectName: 'System ID',
                                    variable: 'N/A',
                                  ),
                                ),
                            makeCard(
                              Lesson(
                                subjectName: 'Tray Count',
                                variable:
                                    _matchedStations[2]['trayCount'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Battery Voltage",
                                variable:
                                    _matchedStations[2]["batVolt"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'Battery Capacity',
                                variable:
                                    _matchedStations[2]['batCap'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Number of batteries in the rack",
                                variable:
                                    _matchedStations[2]["batCount"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'Brand',
                                variable: _matchedStations[2]['Brand'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Model",
                                variable: _matchedStations[2]["model"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName:
                                    'ConType', // change the subject name
                                variable:
                                    _matchedStations[2]['conType'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Trays Set",
                                variable:
                                    _matchedStations[2]["traysSet"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set Capacity",
                                variable:
                                    _matchedStations[2]["set_cap"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set Voltage",
                                variable:
                                    _matchedStations[2]["set_volt"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Installed Date",
                                variable:
                                    (_matchedStations[2]["installDt"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Warranty Commencement Date",
                                variable:
                                    (_matchedStations[2]["warrantSt"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Warranty Expiration Date",
                                variable:
                                    (_matchedStations[2]["warrantEd"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Last Update",
                                variable:
                                    _matchedStations[2]["last_updated"] ??
                                    'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Uploader",
                                variable:
                                    _matchedStations[2]["uploader"] ?? 'N/A',
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Battery Set 4",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 15),
                            makeCard(
                              Lesson(
                                subjectName: "Status",
                                variable:
                                    _matchedStations[3]["status"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set ID",
                                variable: _matchedStations[3]["SetID"],
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Rack ID",
                                variable:
                                    _matchedStations[3]["SystemID"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'System Type',
                                variable:
                                    _matchedStations[3]["sysType"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'System Type',
                                variable:
                                    _matchedStations[0]["sysType"] ?? 'N/A',
                              ),
                            ),
                            // Ensure _matchedData is not empty before accessing it
                            _matchedData.isNotEmpty
                                ? makeButtonCard(
                                  Lesson(
                                    subjectName: 'System ID',
                                    variable:
                                        _matchedData[3]["asset_tag"] ?? 'N/A',
                                  ),
                                  _matchedData[3]["asset_tag"],
                                )
                                : makeCard(
                                  Lesson(
                                    subjectName: 'System ID',
                                    variable: 'N/A',
                                  ),
                                ),
                            makeCard(
                              Lesson(
                                subjectName: 'Tray Count',
                                variable:
                                    _matchedStations[3]['trayCount'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Battery Voltage",
                                variable:
                                    _matchedStations[3]["batVolt"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'Battery Capacity',
                                variable:
                                    _matchedStations[3]['batCap'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Number of batteries in the rack",
                                variable:
                                    _matchedStations[3]["batCount"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: 'Brand',
                                variable: _matchedStations[3]['Brand'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Model",
                                variable: _matchedStations[3]["model"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName:
                                    'ConType', // change the subject name
                                variable:
                                    _matchedStations[3]['conType'] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Trays Set",
                                variable:
                                    _matchedStations[3]["traysSet"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set Capacity",
                                variable:
                                    _matchedStations[3]["set_cap"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Set Voltage",
                                variable:
                                    _matchedStations[3]["set_volt"] ?? 'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Installed Date",
                                variable:
                                    (_matchedStations[3]["installDt"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Warranty Commencement Date",
                                variable:
                                    (_matchedStations[3]["warrantSt"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Warranty Expiration Date",
                                variable:
                                    (_matchedStations[3]["warrantEd"] ?? 'N/A').replaceAll('00:00:00.000', ''),
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Last Update",
                                variable:
                                    _matchedStations[3]["last_updated"] ??
                                    'N/A',
                              ),
                            ),
                            makeCard(
                              Lesson(
                                subjectName: "Uploader",
                                variable:
                                    _matchedStations[3]["uploader"] ?? 'N/A',
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(width: 100),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ViewBatteryUnit(
                                              batteryUnit:
                                                  _matchedStations[1]["SystemID"],
                                            ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(),
                                  child: Text("Back"),
                                ),
                                SizedBox(width: 50),
                                ElevatedButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => BatteryMaintenancePage(),
                                    //     ));
                                  },
                                  style: ElevatedButton.styleFrom(),
                                  child: Text(
                                    "Close",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                )
                : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class Lesson {
  final String subjectName;
  final String variable;

  Lesson({required this.subjectName, required this.variable});
}

//v2
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:powerprox/Screens/Battery/viewBatterySystem/ViewBatteryDetails.dart';
// import 'package:powerprox/Screens/Battery/BatteryMaintenancePage.dart';
// import 'ViewBatteryDetails.dart';
//
// import 'ViewBatteryUnit.dart';
//
// class CombinedSetPage extends StatefulWidget {
//   final String systemID1;
//   final int setCount;
//
//   CombinedSetPage({
//     Key? key,
//     required this.systemID1,
//     required this.setCount,
//   }) : super(key: key);
//
//   @override
//   _CombinedSetPageState createState() => _CombinedSetPageState();
// }
//
// class _CombinedSetPageState extends State<CombinedSetPage> {
//   bool _dataLoaded = false;
//   List<dynamic> _dataList = []; // Explicit declaration
//   bool _matchFound = false;
//   List<Map<String, dynamic>> _matchedStations = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchBatterySets();
//   }
//
//   Future<void> _fetchBatterySets() async {
//     final String dataURL = 'https://powerprox.sltidc.lk/GetBattSets.php';
//     try {
//       final response = await http.get(Uri.parse(dataURL));
//       if (response.statusCode == 200) {
//         setState(() {
//           _dataLoaded = true;
//           _dataList = json.decode(response.body);
//           List<Map<String, dynamic>> filteredStations = _dataList
//               .where((station) =>
//           (station['SystemID'] == widget.systemID1 )).cast<Map<String, dynamic>>()
//               .toList();
//           print(widget.systemID1);
//           print(widget.setCount);
//           print(filteredStations);
//           //print(_dataList);
//
//           _matchedStations = filteredStations;
//           _matchFound = _matchedStations.isNotEmpty;
//           //print(_matchedStations);
//
//           for (var i = 0; i < _matchedStations.length; i++) {
//             Map<String, dynamic> station = _matchedStations[i];
//             print('Battery Set ${i + 1}: $station');
//           }
//         });
//       } else {
//         setState(() {
//           _dataLoaded = false;
//         });
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       setState(() {
//         _dataLoaded = false;
//       });
//       print(e.toString());
//     }
//   }
//
//
//   ListTile makeListTile(String subjectName, String? variable) => ListTile(
//     contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//     leading: Container(
//       padding: EdgeInsets.only(right: 12.0),
//       decoration: new BoxDecoration(
//         border: new Border(
//           right: new BorderSide(width: 1.0, color: Colors.white),
//         ),
//       ),
//       child: Text(
//         subjectName,
//         style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//       ),
//     ),
//     title: Text(
//       variable ?? 'N/A',
//       style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//     ),
//   );
//
//   Card makeCard(Lesson lesson) => Card(
//     elevation: 8.0,
//     margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
//     child: SizedBox(
//       height: 60.0, // Adjust the height value as per your requirements
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.grey,
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         child: makeListTile(lesson.subjectName, lesson.variable),
//       ),
//     ),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Battery Sets"),
//         backgroundColor: Colors.blue,
//       ),
//       body: _dataLoaded
//           ? SingleChildScrollView(
//         child: Column(
//           children: [
//             if (_matchedStations.length == 1)
//               Column(
//                 children: [
//                   SizedBox(height: 10,),
//                   Text(
//                     "Battery Set 1",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400, fontSize: 18),
//                   ),
//                   SizedBox(height: 15,),
//                   makeCard(Lesson(
//                       subjectName: "Set ID",
//                       variable: _matchedStations[0]["SetID"])),
//                   makeCard(Lesson(
//                       subjectName: "System ID",
//                       variable:
//                       _matchedStations[0]["SystemID"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'System Type',
//                       variable:
//                       _matchedStations[0]["sysType"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Tray Count',
//                       variable:
//                       _matchedStations[0]['trayCount'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Battery Voltage",
//                       variable: _matchedStations[0]["batVolt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Battery Capacity',
//                       variable: _matchedStations[0]['batCap'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Number of batteries in the rack",
//                       variable:
//                       _matchedStations[0]["batCount"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Brand',
//                       variable: _matchedStations[0]['Brand'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Model",
//                       variable: _matchedStations[0]["model"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'ConType', // change the subject name
//                       variable: _matchedStations[0]['conType'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Trays Set",
//                       variable:
//                       _matchedStations[0]["traysSet"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Capacity",
//                       variable: _matchedStations[0]["set_cap"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Voltage",
//                       variable:
//                       _matchedStations[0]["set_volt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Installed Date",
//                       variable:
//                       _matchedStations[0]["installDt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Commencement Date",
//                       variable:
//                       _matchedStations[0]["warrantSt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Expiration Date",
//                       variable:
//                       _matchedStations[0]["warrantEd"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Last Update",
//                       variable:
//                       _matchedStations[0]["last_updated"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Uploader",
//                       variable:
//                       _matchedStations[0]["uploader"] ?? 'N/A')),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 100,
//                       ),
//                       // ElevatedButton(
//                       //   onPressed: () {
//                       //     Navigator.push(
//                       //         context,
//                       //         MaterialPageRoute(
//                       //           builder: (context) => ViewBatteryUnit(
//                       //             batteryUnit: _matchedStations[0]
//                       //             ["SystemID"],
//                       //           ),
//                       //         ));
//                       //   },
//                       //   child: Text(
//                       //     "Back",
//                       //     style: TextStyle(color: Colors.black),
//                       //   ),
//                       //   style: ElevatedButton.styleFrom(
//                       //       primary: Colors.brown),
//                       // ),
//                       SizedBox(
//                         width: 50,
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ViewBatteryDetails(),
//                               ));
//                         },
//                         child: Text(
//                           "Close",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.brown),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             if (_matchedStations.length == 2)
//               Column(
//                 children: [
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     "Battery Set 1",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400, fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   makeCard(Lesson(
//                       subjectName: "Set ID",
//                       variable: _matchedStations[0]["SetID"])),
//                   makeCard(Lesson(
//                       subjectName: "System ID",
//                       variable:
//                       _matchedStations[0]["SystemID"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'System Type',
//                       variable:
//                       _matchedStations[0]["sysType"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Tray Count',
//                       variable:
//                       _matchedStations[0]['trayCount'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Battery Voltage",
//                       variable: _matchedStations[0]["batVolt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Battery Capacity',
//                       variable: _matchedStations[0]['batCap'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Number of batteries in the rack",
//                       variable:
//                       _matchedStations[0]["batCount"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Brand',
//                       variable: _matchedStations[0]['Brand'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Model",
//                       variable: _matchedStations[0]["model"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'ConType', // change the subject name
//                       variable: _matchedStations[0]['conType'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Trays Set",
//                       variable:
//                       _matchedStations[0]["traysSet"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Capacity",
//                       variable: _matchedStations[0]["set_cap"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Voltage",
//                       variable:
//                       _matchedStations[0]["set_volt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Installed Date",
//                       variable:
//                       _matchedStations[0]["installDt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Commencement Date",
//                       variable:
//                       _matchedStations[0]["warrantSt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Expiration Date",
//                       variable:
//                       _matchedStations[0]["warrantEd"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Last Update",
//                       variable:
//                       _matchedStations[0]["last_updated"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Uploader",
//                       variable:
//                       _matchedStations[0]["uploader"] ?? 'N/A')),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     "Battery Set 2",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400, fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   makeCard(Lesson(
//                       subjectName: "Set ID",
//                       variable: _matchedStations[1]["SetID"])),
//                   makeCard(Lesson(
//                       subjectName: "System ID",
//                       variable:
//                       _matchedStations[1]["SystemID"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'System Type',
//                       variable:
//                       _matchedStations[1]["sysType"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Tray Count',
//                       variable:
//                       _matchedStations[1]['trayCount'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Battery Voltage",
//                       variable: _matchedStations[1]["batVolt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Battery Capacity',
//                       variable: _matchedStations[1]['batCap'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Number of batteries in the rack",
//                       variable:
//                       _matchedStations[1]["batCount"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Brand',
//                       variable: _matchedStations[1]['Brand'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Model",
//                       variable: _matchedStations[1]["model"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'ConType', // change the subject name
//                       variable: _matchedStations[1]['conType'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Trays Set",
//                       variable:
//                       _matchedStations[1]["traysSet"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Capacity",
//                       variable: _matchedStations[1]["set_cap"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Voltage",
//                       variable:
//                       _matchedStations[1]["set_volt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Installed Date",
//                       variable:
//                       _matchedStations[1]["installDt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Commencement Date",
//                       variable:
//                       _matchedStations[1]["warrantSt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Expiration Date",
//                       variable:
//                       _matchedStations[1]["warrantEd"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Last Update",
//                       variable:
//                       _matchedStations[1]["last_updated"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Uploader",
//                       variable:
//                       _matchedStations[1]["uploader"] ?? 'N/A')),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 100,
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ViewBatteryUnit(
//                                   batteryUnit: _matchedStations[1]
//                                   ["SystemID"],
//                                 ),
//                               ));
//                         },
//                         child: Text(
//                           "Back",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.brown),
//                       ),
//                       SizedBox(
//                         width: 50,
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ViewBatteryDetails(),
//                               ));
//                         },
//                         child: Text(
//                           "Close",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.brown),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             if (_matchedStations.length == 3)
//               Column(
//                 children: [
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     "Battery Set 1",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400, fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   makeCard(Lesson(
//                       subjectName: "Set ID",
//                       variable: _matchedStations[0]["SetID"])),
//                   makeCard(Lesson(
//                       subjectName: "System ID",
//                       variable:
//                       _matchedStations[0]["SystemID"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'System Type',
//                       variable:
//                       _matchedStations[0]["sysType"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Tray Count',
//                       variable:
//                       _matchedStations[0]['trayCount'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Battery Voltage",
//                       variable: _matchedStations[0]["batVolt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Battery Capacity',
//                       variable: _matchedStations[0]['batCap'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Number of batteries in the rack",
//                       variable:
//                       _matchedStations[0]["batCount"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Brand',
//                       variable: _matchedStations[0]['Brand'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Model",
//                       variable: _matchedStations[0]["model"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'ConType', // change the subject name
//                       variable: _matchedStations[0]['conType'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Trays Set",
//                       variable:
//                       _matchedStations[0]["traysSet"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Capacity",
//                       variable: _matchedStations[0]["set_cap"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Voltage",
//                       variable:
//                       _matchedStations[0]["set_volt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Installed Date",
//                       variable:
//                       _matchedStations[0]["installDt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Commencement Date",
//                       variable:
//                       _matchedStations[0]["warrantSt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Expiration Date",
//                       variable:
//                       _matchedStations[0]["warrantEd"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Last Update",
//                       variable:
//                       _matchedStations[0]["last_updated"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Uploader",
//                       variable:
//                       _matchedStations[0]["uploader"] ?? 'N/A')),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     "Battery Set 2",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400, fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   makeCard(Lesson(
//                       subjectName: "Set ID",
//                       variable: _matchedStations[1]["SetID"])),
//                   makeCard(Lesson(
//                       subjectName: "System ID",
//                       variable:
//                       _matchedStations[1]["SystemID"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'System Type',
//                       variable:
//                       _matchedStations[1]["sysType"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Tray Count',
//                       variable:
//                       _matchedStations[1]['trayCount'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Battery Voltage",
//                       variable: _matchedStations[1]["batVolt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Battery Capacity',
//                       variable: _matchedStations[1]['batCap'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Number of batteries in the rack",
//                       variable:
//                       _matchedStations[1]["batCount"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Brand',
//                       variable: _matchedStations[1]['Brand'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Model",
//                       variable: _matchedStations[1]["model"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'ConType', // change the subject name
//                       variable: _matchedStations[1]['conType'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Trays Set",
//                       variable:
//                       _matchedStations[1]["traysSet"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Capacity",
//                       variable: _matchedStations[1]["set_cap"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Voltage",
//                       variable:
//                       _matchedStations[1]["set_volt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Installed Date",
//                       variable:
//                       _matchedStations[1]["installDt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Commencement Date",
//                       variable:
//                       _matchedStations[1]["warrantSt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Expiration Date",
//                       variable:
//                       _matchedStations[1]["warrantEd"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Last Update",
//                       variable:
//                       _matchedStations[1]["last_updated"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Uploader",
//                       variable:
//                       _matchedStations[1]["uploader"] ?? 'N/A')),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Text(
//                     "Battery Set 3",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400, fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   makeCard(Lesson(
//                       subjectName: "Set ID",
//                       variable: _matchedStations[2]["SetID"])),
//                   makeCard(Lesson(
//                       subjectName: "System ID",
//                       variable:
//                       _matchedStations[2]["SystemID"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'System Type',
//                       variable:
//                       _matchedStations[2]["sysType"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Tray Count',
//                       variable:
//                       _matchedStations[2]['trayCount'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Battery Voltage",
//                       variable: _matchedStations[2]["batVolt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Battery Capacity',
//                       variable: _matchedStations[2]['batCap'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Number of batteries in the rack",
//                       variable:
//                       _matchedStations[2]["batCount"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Brand',
//                       variable: _matchedStations[2]['Brand'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Model",
//                       variable: _matchedStations[2]["model"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'ConType', // change the subject name
//                       variable: _matchedStations[2]['conType'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Trays Set",
//                       variable:
//                       _matchedStations[2]["traysSet"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Capacity",
//                       variable: _matchedStations[2]["set_cap"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Voltage",
//                       variable:
//                       _matchedStations[2]["set_volt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Installed Date",
//                       variable:
//                       _matchedStations[2]["installDt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Commencement Date",
//                       variable:
//                       _matchedStations[2]["warrantSt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Expiration Date",
//                       variable:
//                       _matchedStations[2]["warrantEd"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Last Update",
//                       variable:
//                       _matchedStations[2]["last_updated"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Uploader",
//                       variable:
//                       _matchedStations[2]["uploader"] ?? 'N/A')),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 100,
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ViewBatteryUnit(
//                                   batteryUnit: _matchedStations[1]
//                                   ["SystemID"],
//                                 ),
//                               ));
//                         },
//                         child: Text(
//                           "Back",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.brown),
//                       ),
//                       SizedBox(
//                         width: 50,
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           // Navigator.push(
//                           //     context,
//                           //     MaterialPageRoute(
//                           //       builder: (context) => BatteryMaintenancePage(),
//                           //     ));
//                         },
//                         child: Text(
//                           "Close",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.brown),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),if (_matchedStations.length == 4)
//               Column(
//                 children: [
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     "Battery Set 1",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400, fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   makeCard(Lesson(
//                       subjectName: "Set ID",
//                       variable: _matchedStations[0]["SetID"])),
//                   makeCard(Lesson(
//                       subjectName: "System ID",
//                       variable:
//                       _matchedStations[0]["SystemID"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'System Type',
//                       variable:
//                       _matchedStations[0]["sysType"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Tray Count',
//                       variable:
//                       _matchedStations[0]['trayCount'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Battery Voltage",
//                       variable: _matchedStations[0]["batVolt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Battery Capacity',
//                       variable: _matchedStations[0]['batCap'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Number of batteries in the rack",
//                       variable:
//                       _matchedStations[0]["batCount"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Brand',
//                       variable: _matchedStations[0]['Brand'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Model",
//                       variable: _matchedStations[0]["model"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'ConType', // change the subject name
//                       variable: _matchedStations[0]['conType'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Trays Set",
//                       variable:
//                       _matchedStations[0]["traysSet"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Capacity",
//                       variable: _matchedStations[0]["set_cap"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Voltage",
//                       variable:
//                       _matchedStations[0]["set_volt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Installed Date",
//                       variable:
//                       _matchedStations[0]["installDt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Commencement Date",
//                       variable:
//                       _matchedStations[0]["warrantSt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Expiration Date",
//                       variable:
//                       _matchedStations[0]["warrantEd"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Last Update",
//                       variable:
//                       _matchedStations[0]["last_updated"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Uploader",
//                       variable:
//                       _matchedStations[0]["uploader"] ?? 'N/A')),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     "Battery Set 2",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400, fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   makeCard(Lesson(
//                       subjectName: "Set ID",
//                       variable: _matchedStations[1]["SetID"])),
//                   makeCard(Lesson(
//                       subjectName: "System ID",
//                       variable:
//                       _matchedStations[1]["SystemID"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'System Type',
//                       variable:
//                       _matchedStations[1]["sysType"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Tray Count',
//                       variable:
//                       _matchedStations[1]['trayCount'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Battery Voltage",
//                       variable: _matchedStations[1]["batVolt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Battery Capacity',
//                       variable: _matchedStations[1]['batCap'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Number of batteries in the rack",
//                       variable:
//                       _matchedStations[1]["batCount"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Brand',
//                       variable: _matchedStations[1]['Brand'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Model",
//                       variable: _matchedStations[1]["model"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'ConType', // change the subject name
//                       variable: _matchedStations[1]['conType'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Trays Set",
//                       variable:
//                       _matchedStations[1]["traysSet"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Capacity",
//                       variable: _matchedStations[1]["set_cap"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Voltage",
//                       variable:
//                       _matchedStations[1]["set_volt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Installed Date",
//                       variable:
//                       _matchedStations[1]["installDt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Commencement Date",
//                       variable:
//                       _matchedStations[1]["warrantSt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Expiration Date",
//                       variable:
//                       _matchedStations[1]["warrantEd"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Last Update",
//                       variable:
//                       _matchedStations[1]["last_updated"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Uploader",
//                       variable:
//                       _matchedStations[1]["uploader"] ?? 'N/A')),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Text(
//                     "Battery Set 3",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400, fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   makeCard(Lesson(
//                       subjectName: "Set ID",
//                       variable: _matchedStations[2]["SetID"])),
//                   makeCard(Lesson(
//                       subjectName: "System ID",
//                       variable:
//                       _matchedStations[2]["SystemID"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'System Type',
//                       variable:
//                       _matchedStations[2]["sysType"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Tray Count',
//                       variable:
//                       _matchedStations[2]['trayCount'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Battery Voltage",
//                       variable: _matchedStations[2]["batVolt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Battery Capacity',
//                       variable: _matchedStations[2]['batCap'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Number of batteries in the rack",
//                       variable:
//                       _matchedStations[2]["batCount"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Brand',
//                       variable: _matchedStations[2]['Brand'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Model",
//                       variable: _matchedStations[2]["model"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'ConType', // change the subject name
//                       variable: _matchedStations[2]['conType'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Trays Set",
//                       variable:
//                       _matchedStations[2]["traysSet"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Capacity",
//                       variable: _matchedStations[2]["set_cap"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Voltage",
//                       variable:
//                       _matchedStations[2]["set_volt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Installed Date",
//                       variable:
//                       _matchedStations[2]["installDt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Commencement Date",
//                       variable:
//                       _matchedStations[2]["warrantSt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Expiration Date",
//                       variable:
//                       _matchedStations[2]["warrantEd"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Last Update",
//                       variable:
//                       _matchedStations[2]["last_updated"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Uploader",
//                       variable:
//                       _matchedStations[2]["uploader"] ?? 'N/A')),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Text(
//                     "Battery Set 4",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400, fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   makeCard(Lesson(
//                       subjectName: "Set ID",
//                       variable: _matchedStations[3]["SetID"])),
//                   makeCard(Lesson(
//                       subjectName: "System ID",
//                       variable:
//                       _matchedStations[3]["SystemID"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'System Type',
//                       variable:
//                       _matchedStations[3]["sysType"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Tray Count',
//                       variable:
//                       _matchedStations[3]['trayCount'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Battery Voltage",
//                       variable: _matchedStations[3]["batVolt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Battery Capacity',
//                       variable: _matchedStations[3]['batCap'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Number of batteries in the rack",
//                       variable:
//                       _matchedStations[3]["batCount"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Brand',
//                       variable: _matchedStations[3]['Brand'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Model",
//                       variable: _matchedStations[3]["model"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'ConType', // change the subject name
//                       variable: _matchedStations[3]['conType'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Trays Set",
//                       variable:
//                       _matchedStations[3]["traysSet"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Capacity",
//                       variable: _matchedStations[3]["set_cap"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Voltage",
//                       variable:
//                       _matchedStations[3]["set_volt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Installed Date",
//                       variable:
//                       _matchedStations[3]["installDt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Commencement Date",
//                       variable:
//                       _matchedStations[3]["warrantSt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Expiration Date",
//                       variable:
//                       _matchedStations[3]["warrantEd"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Last Update",
//                       variable:
//                       _matchedStations[3]["last_updated"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Uploader",
//                       variable:
//                       _matchedStations[3]["uploader"] ?? 'N/A')),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 100,
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ViewBatteryUnit(
//                                   batteryUnit: _matchedStations[1]
//                                   ["SystemID"],
//                                 ),
//                               ));
//                         },
//                         child: Text(
//                           "Back",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.brown),
//                       ),
//                       SizedBox(
//                         width: 50,
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           // Navigator.push(
//                           //     context,
//                           //     MaterialPageRoute(
//                           //       builder: (context) => BatteryMaintenancePage(),
//                           //     ));
//                         },
//                         child: Text(
//                           "Close",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.brown),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       )
//           : Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
//
// class Lesson {
//   final String subjectName;
//   final String variable;
//
//   Lesson({required this.subjectName, required this.variable});
// }
//
//

//V2 Working
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:slt_generator_user/Screens/Battery/ViewBatteryDetails.dart';
// import 'package:slt_generator_user/Screens/BatteryMaintenancePage.dart';
//
// import 'ViewBatteryUnit.dart';
//
// class CombinedSetPage extends StatefulWidget {
//   final int systemID;
//   final int setCount;
//
//   CombinedSetPage({
//     Key? key,
//     required this.systemID,
//     required this.setCount,
//   }) : super(key: key);
//
//   @override
//   _CombinedSetPageState createState() => _CombinedSetPageState();
// }
//
// class _CombinedSetPageState extends State<CombinedSetPage> {
//   bool _dataLoaded = false;
//   List<Map<String, dynamic>> _dataList = []; // Explicit declaration
//   bool _matchFound = false;
//   List<Map<String, dynamic>> _matchedStations = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchBatterySets();
//   }
//
//   Future<void> _fetchBatterySets() async {
//     final String dataURL = 'http://124.43.136.185/GetBattSets.php';
//     try {
//       final response = await http.get(Uri.parse(dataURL));
//       if (response.statusCode == 200) {
//         setState(() {
//           _dataLoaded = true;
//           _dataList = json.decode(response.body);
//           List<Map<String, dynamic>> filteredStations = _dataList
//               .where((station) =>
//           station['SystemID'] == widget.systemID &&
//               station['SetCount'] == widget.setCount)
//               .toList();
//
//           _matchedStations = List<Map<String, dynamic>>.from(filteredStations);
//           _matchFound = _matchedStations.isNotEmpty;
//           //print(_matchedStations);
//
//           for (var i = 0; i < _matchedStations.length; i++) {
//             Map<String, dynamic> station = _matchedStations[i];
//             print('Battery Set ${i + 1}: $station');
//           }
//         });
//       } else {
//         setState(() {
//           _dataLoaded = false;
//         });
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       setState(() {
//         _dataLoaded = false;
//       });
//       print(e.toString());
//     }
//   }
//
//
//
//
//
//   ListTile makeListTile(String subjectName, String? variable) => ListTile(
//     contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//     leading: Container(
//       padding: EdgeInsets.only(right: 12.0),
//       decoration: new BoxDecoration(
//         border: new Border(
//           right: new BorderSide(width: 1.0, color: Colors.white),
//         ),
//       ),
//       child: Text(
//         subjectName,
//         style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//       ),
//     ),
//     title: Text(
//       variable ?? 'N/A',
//       style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//     ),
//   );
//
//   Card makeCard(Lesson lesson) => Card(
//     elevation: 8.0,
//     margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
//     child: SizedBox(
//       height: 60.0, // Adjust the height value as per your requirements
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.grey,
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         child: makeListTile(lesson.subjectName, lesson.variable),
//       ),
//     ),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Battery Sets"),
//         backgroundColor: Colors.blue,
//       ),
//       body: _dataLoaded
//           ? SingleChildScrollView(
//         child: Column(
//           children: [
//             if (_matchedStations.length == 1)
//               Column(
//                 children: [
//                   SizedBox(height: 10,),
//                   Text(
//                     "Battery Set 1",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400, fontSize: 18),
//                   ),
//                   SizedBox(height: 15,),
//                   makeCard(Lesson(
//                       subjectName: "Set ID",
//                       variable: _matchedStations[0]["SetID"])),
//                   makeCard(Lesson(
//                       subjectName: "System ID",
//                       variable:
//                       _matchedStations[0]["SystemID"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Tray Count',
//                       variable:
//                       _matchedStations[0]['trayCount'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Battery Voltage",
//                       variable: _matchedStations[0]["batVolt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Battery Capacity',
//                       variable: _matchedStations[0]['batCap'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Number of batteries in the rack",
//                       variable:
//                       _matchedStations[0]["batCount"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Brand',
//                       variable: _matchedStations[0]['Brand'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Model",
//                       variable: _matchedStations[0]["model"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'ConType', // change the subject name
//                       variable: _matchedStations[0]['conType'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Trays Set",
//                       variable:
//                       _matchedStations[0]["traysSet"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Capacity",
//                       variable: _matchedStations[0]["set_cap"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Voltage",
//                       variable:
//                       _matchedStations[0]["set_volt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Installed Date",
//                       variable:
//                       _matchedStations[0]["installDt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Commencement Date",
//                       variable:
//                       _matchedStations[0]["warrantSt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Expiration Date",
//                       variable:
//                       _matchedStations[0]["warrantEd"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Last Update",
//                       variable:
//                       _matchedStations[0]["last_updated"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Uploader",
//                       variable:
//                       _matchedStations[0]["uploader"] ?? 'N/A')),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 100,
//                       ),
//                       // ElevatedButton(
//                       //   onPressed: () {
//                       //     Navigator.push(
//                       //         context,
//                       //         MaterialPageRoute(
//                       //           builder: (context) => ViewBatteryUnit(
//                       //             batteryUnit: _matchedStations[0]
//                       //             ["SystemID"],
//                       //           ),
//                       //         ));
//                       //   },
//                       //   child: Text(
//                       //     "Back",
//                       //     style: TextStyle(color: Colors.black),
//                       //   ),
//                       //   style: ElevatedButton.styleFrom(
//                       //       primary: Colors.brown),
//                       // ),
//                       SizedBox(
//                         width: 50,
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ViewBatteryDetails(),
//                               ));
//                         },
//                         child: Text(
//                           "Close",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         style: ElevatedButton.styleFrom(
//
//                             foregroundColor: Colors.brown
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             if (_matchedStations.length == 2)
//               Column(
//                 children: [
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     "Battery Set 1",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400, fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   makeCard(Lesson(
//                       subjectName: "Set ID",
//                       variable: _matchedStations[0]["SetID"])),
//                   makeCard(Lesson(
//                       subjectName: "System ID",
//                       variable:
//                       _matchedStations[0]["SystemID"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Tray Count',
//                       variable:
//                       _matchedStations[0]['trayCount'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Battery Voltage",
//                       variable: _matchedStations[0]["batVolt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Battery Capacity',
//                       variable: _matchedStations[0]['batCap'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Number of batteries in the rack",
//                       variable:
//                       _matchedStations[0]["batCount"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Brand',
//                       variable: _matchedStations[0]['Brand'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Model",
//                       variable: _matchedStations[0]["model"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'ConType', // change the subject name
//                       variable: _matchedStations[0]['conType'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Trays Set",
//                       variable:
//                       _matchedStations[0]["traysSet"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Capacity",
//                       variable: _matchedStations[0]["set_cap"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Voltage",
//                       variable:
//                       _matchedStations[0]["set_volt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Installed Date",
//                       variable:
//                       _matchedStations[0]["installDt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Commencement Date",
//                       variable:
//                       _matchedStations[0]["warrantSt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Expiration Date",
//                       variable:
//                       _matchedStations[0]["warrantEd"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Last Update",
//                       variable:
//                       _matchedStations[0]["last_updated"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Uploader",
//                       variable:
//                       _matchedStations[0]["uploader"] ?? 'N/A')),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     "Battery Set 2",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400, fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   makeCard(Lesson(
//                       subjectName: "Set ID",
//                       variable: _matchedStations[1]["SetID"])),
//                   makeCard(Lesson(
//                       subjectName: "System ID",
//                       variable:
//                       _matchedStations[1]["SystemID"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Tray Count',
//                       variable:
//                       _matchedStations[1]['trayCount'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Battery Voltage",
//                       variable: _matchedStations[1]["batVolt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Battery Capacity',
//                       variable: _matchedStations[1]['batCap'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Number of batteries in the rack",
//                       variable:
//                       _matchedStations[1]["batCount"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Brand',
//                       variable: _matchedStations[1]['Brand'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Model",
//                       variable: _matchedStations[1]["model"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'ConType', // change the subject name
//                       variable: _matchedStations[1]['conType'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Trays Set",
//                       variable:
//                       _matchedStations[1]["traysSet"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Capacity",
//                       variable: _matchedStations[1]["set_cap"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Voltage",
//                       variable:
//                       _matchedStations[1]["set_volt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Installed Date",
//                       variable:
//                       _matchedStations[1]["installDt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Commencement Date",
//                       variable:
//                       _matchedStations[1]["warrantSt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Expiration Date",
//                       variable:
//                       _matchedStations[1]["warrantEd"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Last Update",
//                       variable:
//                       _matchedStations[1]["last_updated"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Uploader",
//                       variable:
//                       _matchedStations[1]["uploader"] ?? 'N/A')),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 100,
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ViewBatteryUnit(
//                                   batteryUnit: _matchedStations[1]
//                                   ["SystemID"],
//                                 ),
//                               ));
//                         },
//                         child: Text(
//                           "Back",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                             foregroundColor: Colors.brown),
//                       ),
//                       SizedBox(
//                         width: 50,
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ViewBatteryDetails(),
//                               ));
//                         },
//                         child: Text(
//                           "Close",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                             foregroundColor: Colors.brown),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             if (_matchedStations.length == 3)
//               Column(
//                 children: [
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     "Battery Set 1",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400, fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   makeCard(Lesson(
//                       subjectName: "Set ID",
//                       variable: _matchedStations[0]["SetID"])),
//                   makeCard(Lesson(
//                       subjectName: "System ID",
//                       variable:
//                       _matchedStations[0]["SystemID"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Tray Count',
//                       variable:
//                       _matchedStations[0]['trayCount'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Battery Voltage",
//                       variable: _matchedStations[0]["batVolt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Battery Capacity',
//                       variable: _matchedStations[0]['batCap'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Number of batteries in the rack",
//                       variable:
//                       _matchedStations[0]["batCount"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Brand',
//                       variable: _matchedStations[0]['Brand'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Model",
//                       variable: _matchedStations[0]["model"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'ConType', // change the subject name
//                       variable: _matchedStations[0]['conType'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Trays Set",
//                       variable:
//                       _matchedStations[0]["traysSet"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Capacity",
//                       variable: _matchedStations[0]["set_cap"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Voltage",
//                       variable:
//                       _matchedStations[0]["set_volt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Installed Date",
//                       variable:
//                       _matchedStations[0]["installDt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Commencement Date",
//                       variable:
//                       _matchedStations[0]["warrantSt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Expiration Date",
//                       variable:
//                       _matchedStations[0]["warrantEd"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Last Update",
//                       variable:
//                       _matchedStations[0]["last_updated"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Uploader",
//                       variable:
//                       _matchedStations[0]["uploader"] ?? 'N/A')),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     "Battery Set 2",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400, fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   makeCard(Lesson(
//                       subjectName: "Set ID",
//                       variable: _matchedStations[1]["SetID"])),
//                   makeCard(Lesson(
//                       subjectName: "System ID",
//                       variable:
//                       _matchedStations[1]["SystemID"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Tray Count',
//                       variable:
//                       _matchedStations[1]['trayCount'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Battery Voltage",
//                       variable: _matchedStations[1]["batVolt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Battery Capacity',
//                       variable: _matchedStations[1]['batCap'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Number of batteries in the rack",
//                       variable:
//                       _matchedStations[1]["batCount"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Brand',
//                       variable: _matchedStations[1]['Brand'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Model",
//                       variable: _matchedStations[1]["model"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'ConType', // change the subject name
//                       variable: _matchedStations[1]['conType'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Trays Set",
//                       variable:
//                       _matchedStations[1]["traysSet"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Capacity",
//                       variable: _matchedStations[1]["set_cap"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Voltage",
//                       variable:
//                       _matchedStations[1]["set_volt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Installed Date",
//                       variable:
//                       _matchedStations[1]["installDt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Commencement Date",
//                       variable:
//                       _matchedStations[1]["warrantSt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Expiration Date",
//                       variable:
//                       _matchedStations[1]["warrantEd"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Last Update",
//                       variable:
//                       _matchedStations[1]["last_updated"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Uploader",
//                       variable:
//                       _matchedStations[1]["uploader"] ?? 'N/A')),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Text(
//                     "Battery Set 3",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400, fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   makeCard(Lesson(
//                       subjectName: "Set ID",
//                       variable: _matchedStations[2]["SetID"])),
//                   makeCard(Lesson(
//                       subjectName: "System ID",
//                       variable:
//                       _matchedStations[2]["SystemID"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Tray Count',
//                       variable:
//                       _matchedStations[2]['trayCount'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Battery Voltage",
//                       variable: _matchedStations[2]["batVolt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Battery Capacity',
//                       variable: _matchedStations[2]['batCap'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Number of batteries in the rack",
//                       variable:
//                       _matchedStations[2]["batCount"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Brand',
//                       variable: _matchedStations[2]['Brand'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Model",
//                       variable: _matchedStations[2]["model"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'ConType', // change the subject name
//                       variable: _matchedStations[2]['conType'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Trays Set",
//                       variable:
//                       _matchedStations[2]["traysSet"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Capacity",
//                       variable: _matchedStations[2]["set_cap"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Voltage",
//                       variable:
//                       _matchedStations[2]["set_volt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Installed Date",
//                       variable:
//                       _matchedStations[2]["installDt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Commencement Date",
//                       variable:
//                       _matchedStations[2]["warrantSt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Expiration Date",
//                       variable:
//                       _matchedStations[2]["warrantEd"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Last Update",
//                       variable:
//                       _matchedStations[2]["last_updated"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Uploader",
//                       variable:
//                       _matchedStations[2]["uploader"] ?? 'N/A')),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 100,
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ViewBatteryUnit(
//                                   batteryUnit: _matchedStations[1]
//                                   ["SystemID"],
//                                 ),
//                               ));
//                         },
//                         child: Text(
//                           "Back",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                             foregroundColor: Colors.brown),
//                       ),
//                       SizedBox(
//                         width: 50,
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => BatteryMaintenancePage(),
//                               ));
//                         },
//                         child: Text(
//                           "Close",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                             foregroundColor: Colors.brown),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       )
//           : Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
//
// class Lesson {
//   final String subjectName;
//   final String variable;
//
//   Lesson({required this.subjectName, required this.variable});
// }
//

//v1 working
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:slt_generator_user/Screens/Battery/ViewBatteryDetails.dart';
// import 'package:slt_generator_user/Screens/BatteryMaintenancePage.dart';
//
// import 'ViewBatteryUnit.dart';
//
// class CombinedSetPage extends StatefulWidget {
//   final String? setId1;
//   final String? setId2;
//   final String? setId3;
//   final String? setId4;
//
//   CombinedSetPage({
//     Key? key,
//     required this.setId1,
//     required this.setId2,
//     required this.setId3,
//     required this.setId4,
//   }) : super(key: key);
//
//   @override
//   _CombinedSetPageState createState() => _CombinedSetPageState();
// }
//
// class _CombinedSetPageState extends State<CombinedSetPage> {
//   bool _dataLoaded = false;
//   List<dynamic> _dataList = [];
//   bool _matchFound = false;
//   List<Map<String, dynamic>> _matchedStations = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchBatterySets();
//   }
//
//   Future<void> _fetchBatterySets() async {
//     final String dataURL = 'http://124.43.136.185/GetBattSets.php';
//     try {
//       final response = await http.get(Uri.parse(dataURL));
//       if (response.statusCode == 200) {
//         setState(() {
//           _dataLoaded = true;
//           _dataList = json.decode(response.body);
//           List<Map<String, dynamic>> filteredStations = _dataList
//               .where((station) => (station['SetID'] == widget.setId1 ||
//               station['SetID'] == widget.setId2 ||
//               station['SetID'] == widget.setId3))
//               .cast<Map<String, dynamic>>()
//               .toList();
//
//           _matchedStations = filteredStations;
//           _matchFound = _matchedStations.isNotEmpty;
//           //print(_matchedStations);
//
//           if (_matchedStations.isNotEmpty) {
//             if (_matchedStations.length == 1) {
//               Map<String, dynamic> station1 = _matchedStations[0];
//               print('Battery Set 1: $station1');
//             }
//             if (_matchedStations.length == 2) {
//               Map<String, dynamic> station1 = _matchedStations[0];
//               Map<String, dynamic> station2 = _matchedStations[1];
//               print('Battery Set 1: $station1');
//               print('Battery Set 2: $station2');
//             }
//             if (_matchedStations.length == 3) {
//               Map<String, dynamic> station1 = _matchedStations[0];
//               Map<String, dynamic> station2 = _matchedStations[1];
//               Map<String, dynamic> station3 = _matchedStations[2];
//               print('Battery Set 1: $station1');
//               print('Battery Set 2: $station2');
//               print('Battery Set 3: $station3');
//             }
//           } else {
//             _matchFound = false;
//           }
//         });
//       } else {
//         setState(() {
//           _dataLoaded = false;
//         });
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       setState(() {
//         _dataLoaded = false;
//       });
//       print(e.toString());
//     }
//   }
//
//   ListTile makeListTile(String subjectName, String? variable) => ListTile(
//     contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//     leading: Container(
//       padding: EdgeInsets.only(right: 12.0),
//       decoration: new BoxDecoration(
//         border: new Border(
//           right: new BorderSide(width: 1.0, color: Colors.white),
//         ),
//       ),
//       child: Text(
//         subjectName,
//         style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//       ),
//     ),
//     title: Text(
//       variable ?? 'N/A',
//       style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//     ),
//   );
//
//   Card makeCard(Lesson lesson) => Card(
//     elevation: 8.0,
//     margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
//     child: SizedBox(
//       height: 60.0, // Adjust the height value as per your requirements
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.grey,
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         child: makeListTile(lesson.subjectName, lesson.variable),
//       ),
//     ),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Battery Sets"),
//         backgroundColor: Colors.blue,
//       ),
//       body: _dataLoaded
//           ? SingleChildScrollView(
//         child: Column(
//           children: [
//             if (_matchedStations.length == 1)
//               Column(
//                 children: [
//                   SizedBox(height: 10,),
//                   Text(
//                     "Battery Set 1",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400, fontSize: 18),
//                   ),
//                   SizedBox(height: 15,),
//                   makeCard(Lesson(
//                       subjectName: "Set ID",
//                       variable: _matchedStations[0]["SetID"])),
//                   makeCard(Lesson(
//                       subjectName: "System ID",
//                       variable:
//                       _matchedStations[0]["SystemID"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Tray Count',
//                       variable:
//                       _matchedStations[0]['trayCount'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Battery Voltage",
//                       variable: _matchedStations[0]["batVolt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Battery Capacity',
//                       variable: _matchedStations[0]['batCap'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Number of batteries in the rack",
//                       variable:
//                       _matchedStations[0]["batCount"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Brand',
//                       variable: _matchedStations[0]['Brand'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Model",
//                       variable: _matchedStations[0]["model"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'ConType', // change the subject name
//                       variable: _matchedStations[0]['conType'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Trays Set",
//                       variable:
//                       _matchedStations[0]["traysSet"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Capacity",
//                       variable: _matchedStations[0]["set_cap"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Voltage",
//                       variable:
//                       _matchedStations[0]["set_volt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Installed Date",
//                       variable:
//                       _matchedStations[0]["installDt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Commencement Date",
//                       variable:
//                       _matchedStations[0]["warrantSt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Expiration Date",
//                       variable:
//                       _matchedStations[0]["warrantEd"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Last Update",
//                       variable:
//                       _matchedStations[0]["last_updated"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Uploader",
//                       variable:
//                       _matchedStations[0]["uploader"] ?? 'N/A')),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 100,
//                       ),
//                       // ElevatedButton(
//                       //   onPressed: () {
//                       //     Navigator.push(
//                       //         context,
//                       //         MaterialPageRoute(
//                       //           builder: (context) => ViewBatteryUnit(
//                       //             batteryUnit: _matchedStations[0]
//                       //             ["SystemID"],
//                       //           ),
//                       //         ));
//                       //   },
//                       //   child: Text(
//                       //     "Back",
//                       //     style: TextStyle(color: Colors.black),
//                       //   ),
//                       //   style: ElevatedButton.styleFrom(
//                       //       primary: Colors.brown),
//                       // ),
//                       SizedBox(
//                         width: 50,
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ViewBatteryDetails(),
//                               ));
//                         },
//                         child: Text(
//                           "Close",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                             primary: Colors.brown),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             if (_matchedStations.length == 2)
//               Column(
//                 children: [
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     "Battery Set 1",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400, fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   makeCard(Lesson(
//                       subjectName: "Set ID",
//                       variable: _matchedStations[0]["SetID"])),
//                   makeCard(Lesson(
//                       subjectName: "System ID",
//                       variable:
//                       _matchedStations[0]["SystemID"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Tray Count',
//                       variable:
//                       _matchedStations[0]['trayCount'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Battery Voltage",
//                       variable: _matchedStations[0]["batVolt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Battery Capacity',
//                       variable: _matchedStations[0]['batCap'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Number of batteries in the rack",
//                       variable:
//                       _matchedStations[0]["batCount"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Brand',
//                       variable: _matchedStations[0]['Brand'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Model",
//                       variable: _matchedStations[0]["model"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'ConType', // change the subject name
//                       variable: _matchedStations[0]['conType'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Trays Set",
//                       variable:
//                       _matchedStations[0]["traysSet"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Capacity",
//                       variable: _matchedStations[0]["set_cap"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Voltage",
//                       variable:
//                       _matchedStations[0]["set_volt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Installed Date",
//                       variable:
//                       _matchedStations[0]["installDt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Commencement Date",
//                       variable:
//                       _matchedStations[0]["warrantSt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Expiration Date",
//                       variable:
//                       _matchedStations[0]["warrantEd"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Last Update",
//                       variable:
//                       _matchedStations[0]["last_updated"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Uploader",
//                       variable:
//                       _matchedStations[0]["uploader"] ?? 'N/A')),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     "Battery Set 2",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400, fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   makeCard(Lesson(
//                       subjectName: "Set ID",
//                       variable: _matchedStations[1]["SetID"])),
//                   makeCard(Lesson(
//                       subjectName: "System ID",
//                       variable:
//                       _matchedStations[1]["SystemID"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Tray Count',
//                       variable:
//                       _matchedStations[1]['trayCount'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Battery Voltage",
//                       variable: _matchedStations[1]["batVolt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Battery Capacity',
//                       variable: _matchedStations[1]['batCap'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Number of batteries in the rack",
//                       variable:
//                       _matchedStations[1]["batCount"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Brand',
//                       variable: _matchedStations[1]['Brand'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Model",
//                       variable: _matchedStations[1]["model"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'ConType', // change the subject name
//                       variable: _matchedStations[1]['conType'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Trays Set",
//                       variable:
//                       _matchedStations[1]["traysSet"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Capacity",
//                       variable: _matchedStations[1]["set_cap"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Voltage",
//                       variable:
//                       _matchedStations[1]["set_volt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Installed Date",
//                       variable:
//                       _matchedStations[1]["installDt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Commencement Date",
//                       variable:
//                       _matchedStations[1]["warrantSt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Expiration Date",
//                       variable:
//                       _matchedStations[1]["warrantEd"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Last Update",
//                       variable:
//                       _matchedStations[1]["last_updated"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Uploader",
//                       variable:
//                       _matchedStations[1]["uploader"] ?? 'N/A')),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 100,
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ViewBatteryUnit(
//                                   batteryUnit: _matchedStations[1]
//                                   ["SystemID"],
//                                 ),
//                               ));
//                         },
//                         child: Text(
//                           "Back",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                             primary: Colors.brown),
//                       ),
//                       SizedBox(
//                         width: 50,
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ViewBatteryDetails(),
//                               ));
//                         },
//                         child: Text(
//                           "Close",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                             primary: Colors.brown),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             if (_matchedStations.length == 3)
//               Column(
//                 children: [
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     "Battery Set 1",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400, fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   makeCard(Lesson(
//                       subjectName: "Set ID",
//                       variable: _matchedStations[0]["SetID"])),
//                   makeCard(Lesson(
//                       subjectName: "System ID",
//                       variable:
//                       _matchedStations[0]["SystemID"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Tray Count',
//                       variable:
//                       _matchedStations[0]['trayCount'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Battery Voltage",
//                       variable: _matchedStations[0]["batVolt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Battery Capacity',
//                       variable: _matchedStations[0]['batCap'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Number of batteries in the rack",
//                       variable:
//                       _matchedStations[0]["batCount"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Brand',
//                       variable: _matchedStations[0]['Brand'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Model",
//                       variable: _matchedStations[0]["model"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'ConType', // change the subject name
//                       variable: _matchedStations[0]['conType'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Trays Set",
//                       variable:
//                       _matchedStations[0]["traysSet"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Capacity",
//                       variable: _matchedStations[0]["set_cap"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Voltage",
//                       variable:
//                       _matchedStations[0]["set_volt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Installed Date",
//                       variable:
//                       _matchedStations[0]["installDt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Commencement Date",
//                       variable:
//                       _matchedStations[0]["warrantSt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Expiration Date",
//                       variable:
//                       _matchedStations[0]["warrantEd"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Last Update",
//                       variable:
//                       _matchedStations[0]["last_updated"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Uploader",
//                       variable:
//                       _matchedStations[0]["uploader"] ?? 'N/A')),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     "Battery Set 2",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400, fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   makeCard(Lesson(
//                       subjectName: "Set ID",
//                       variable: _matchedStations[1]["SetID"])),
//                   makeCard(Lesson(
//                       subjectName: "System ID",
//                       variable:
//                       _matchedStations[1]["SystemID"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Tray Count',
//                       variable:
//                       _matchedStations[1]['trayCount'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Battery Voltage",
//                       variable: _matchedStations[1]["batVolt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Battery Capacity',
//                       variable: _matchedStations[1]['batCap'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Number of batteries in the rack",
//                       variable:
//                       _matchedStations[1]["batCount"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Brand',
//                       variable: _matchedStations[1]['Brand'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Model",
//                       variable: _matchedStations[1]["model"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'ConType', // change the subject name
//                       variable: _matchedStations[1]['conType'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Trays Set",
//                       variable:
//                       _matchedStations[1]["traysSet"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Capacity",
//                       variable: _matchedStations[1]["set_cap"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Voltage",
//                       variable:
//                       _matchedStations[1]["set_volt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Installed Date",
//                       variable:
//                       _matchedStations[1]["installDt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Commencement Date",
//                       variable:
//                       _matchedStations[1]["warrantSt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Expiration Date",
//                       variable:
//                       _matchedStations[1]["warrantEd"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Last Update",
//                       variable:
//                       _matchedStations[1]["last_updated"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Uploader",
//                       variable:
//                       _matchedStations[1]["uploader"] ?? 'N/A')),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Text(
//                     "Battery Set 3",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400, fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   makeCard(Lesson(
//                       subjectName: "Set ID",
//                       variable: _matchedStations[2]["SetID"])),
//                   makeCard(Lesson(
//                       subjectName: "System ID",
//                       variable:
//                       _matchedStations[2]["SystemID"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Tray Count',
//                       variable:
//                       _matchedStations[2]['trayCount'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Battery Voltage",
//                       variable: _matchedStations[2]["batVolt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Battery Capacity',
//                       variable: _matchedStations[2]['batCap'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Number of batteries in the rack",
//                       variable:
//                       _matchedStations[2]["batCount"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'Brand',
//                       variable: _matchedStations[2]['Brand'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Model",
//                       variable: _matchedStations[2]["model"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: 'ConType', // change the subject name
//                       variable: _matchedStations[2]['conType'] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Trays Set",
//                       variable:
//                       _matchedStations[2]["traysSet"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Capacity",
//                       variable: _matchedStations[2]["set_cap"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Set Voltage",
//                       variable:
//                       _matchedStations[2]["set_volt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Installed Date",
//                       variable:
//                       _matchedStations[2]["installDt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Commencement Date",
//                       variable:
//                       _matchedStations[2]["warrantSt"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Warranty Expiration Date",
//                       variable:
//                       _matchedStations[2]["warrantEd"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Last Update",
//                       variable:
//                       _matchedStations[2]["last_updated"] ?? 'N/A')),
//                   makeCard(Lesson(
//                       subjectName: "Uploader",
//                       variable:
//                       _matchedStations[2]["uploader"] ?? 'N/A')),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 100,
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ViewBatteryUnit(
//                                   batteryUnit: _matchedStations[1]
//                                   ["SystemID"],
//                                 ),
//                               ));
//                         },
//                         child: Text(
//                           "Back",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                             primary: Colors.brown),
//                       ),
//                       SizedBox(
//                         width: 50,
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => BatteryMaintenancePage(),
//                               ));
//                         },
//                         child: Text(
//                           "Close",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                             primary: Colors.brown),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       )
//           : Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
//
// class Lesson {
//   final String subjectName;
//   final String variable;
//
//   Lesson({required this.subjectName, required this.variable});
// }
