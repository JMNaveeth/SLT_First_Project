import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/utils/utils/colors.dart';

import 'combinedSet.dart';

class ViewBatteryUnit extends StatefulWidget {
  final dynamic batteryUnit;
  final String searchQuery;

  ViewBatteryUnit({required this.batteryUnit, this.searchQuery = ''});

  @override
  ViewBatteryUnitState createState() => ViewBatteryUnitState();
}

class ViewBatteryUnitState extends State<ViewBatteryUnit> {
  bool _dataLoaded = true;

  void initState() {
    super.initState();
  }

  ListTile makeListTile(String subjectName, String? variable) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
          border: new Border(
            right: new BorderSide(width: 1.0, color: customColors.mainTextColor),
          ),
        ),
        child: Text(
          subjectName,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        variable ?? 'N/A',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: SizedBox(
          height: 60.0,
          child: Container(
            decoration: BoxDecoration(
              color: customColors.suqarBackgroundColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(width: 1.0, color: customColors.subTextColor),
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
                  color: customColors.subTextColor,
                  backgroundColor:
                      isMatch ? customColors.highlightColor : customColors.suqarBackgroundColor,
                ),
              ),
            ),
          ),
        ),
      );
    }
  
  // Card makeCard(Lesson lesson) => Card(
  //   elevation: 8.0,
  //   margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
  //   child: SizedBox(
  //     height: 60.0, //
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.grey,
  //         borderRadius: BorderRadius.circular(12.0),
  //       ),
  //       child: makeListTile(lesson.subjectName, lesson.variable),
  //     ),
  //   ),
  // );

  @override
  Widget build(BuildContext context) {
    String sysID1 = (widget.batteryUnit['SystemID'] ?? '0');
    //int sysID2 = int.parse(widget.batteryUnit['SystemID'] ?? '0');
    //int sysID3 = int.parse(widget.batteryUnit['SystemID'] ?? '0');
    int setCnt = int.parse(widget.batteryUnit['SetNo'] ?? 0);
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Battery Unit Details",
          style: TextStyle(color: customColors.mainTextColor),
        ),
        iconTheme: IconThemeData(color: customColors.mainTextColor),
        backgroundColor: customColors.appbarColor,
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),
      class SearchHelperBattery {
  static bool matchesBatteryQuery(Map<String, dynamic> battery, String query) {
    query = query.toLowerCase();
    return _batteryMatchesQuery(battery, query);
  }

  static bool _batteryMatchesQuery(Map<String, dynamic> battery, String query) {
    // Check all possible fields in the battery data
    return battery.values.any((value) =>
    value != null && value.toString().toLowerCase().contains(query));
  }
}
      body:
           _dataLoaded
    ? SingleChildScrollView(
        child: Container(
          color: customColors.mainBackgroundColor,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            children: [
                      makeCard(
                        Lesson(
                          subjectName: 'Rack ID',
                          variable: widget.batteryUnit['SystemID'] ?? 'N/A',
                        ),
                      ),
                      makeCard(
                        Lesson(
                          subjectName: 'Region',
                          variable: widget.batteryUnit['Region'] ?? 'N/A',
                        ),
                      ),
                      makeCard(
                        Lesson(
                          subjectName: 'Site',
                          variable: widget.batteryUnit['Site'] ?? 'N/A',
                        ),
                      ),
                      // makeCard(Lesson(
                      //     subjectName: 'System Type',
                      //     variable: widget.batteryUnit['sysType'] ?? 'N/A')),
                      makeCard(
                        Lesson(
                          subjectName: 'Battery Type',
                          variable: widget.batteryUnit['batType'] ?? 'N/A',
                        ),
                      ),
                      makeCard(
                        Lesson(
                          subjectName: 'Location',
                          variable: widget.batteryUnit['Location'] ?? 'N/A',
                        ),
                      ),
                      makeCard(
                        Lesson(
                          subjectName: 'Set Number',
                          variable: widget.batteryUnit['SetNo'] ?? 'N/A',
                        ),
                      ),
                      makeCard(
                        Lesson(
                          subjectName: 'Notes',
                          variable: widget.batteryUnit['Notes'] ?? 'N/A',
                        ),
                      ),
                      makeCard(
                        Lesson(
                          subjectName: 'Last Update',
                          variable: widget.batteryUnit['last_updated'] ?? 'N/A',
                        ),
                      ),
                      makeCard(
                        Lesson(
                          subjectName: 'Uploader',
                          variable: widget.batteryUnit['uploader'] ?? 'N/A',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          String buttonText = '';
                          Function()? onPressed;

                          if (widget.batteryUnit["SetNo"] == "1") {
                            buttonText = 'for set No 1';
                            onPressed = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => //Set1Page(setID: '111')
                                          CombinedSetPage(
                                        systemID1: sysID1,
                                        //systemID2: sysID2,
                                        //systemID3: sysID3,
                                        setCount: setCnt,
                                        searchQuery: widget.searchQuery,
                                      ),
                                ),
                              );
                            };
                          } else if (widget.batteryUnit["SetNo"] == "2") {
                            buttonText = 'for set No 2';
                            onPressed = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => //Set1Page(setID: '111')
                                          CombinedSetPage(
                                        systemID1: sysID1,
                                        //systemID2: sysID2,
                                        //systemID3: sysID3,
                                        setCount: setCnt,
                                        searchQuery: widget.searchQuery,
                                      ),
                                ),
                              );
                            };
                          }
                          if (widget.batteryUnit["SetNo"] == "3") {
                            buttonText = 'for set No 3';
                            onPressed = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => //Set1Page(setID: '111')
                                          CombinedSetPage(
                                        systemID1: sysID1,
                                        //systemID2: sysID2,
                                        //systemID3: sysID3,
                                        setCount: setCnt,
                                        searchQuery: widget.searchQuery,
                                      ),
                                ),
                              );
                            };
                          }
                          if (widget.batteryUnit["SetNo"] == "4") {
                            buttonText = 'for set No 4';
                            onPressed = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => //Set1Page(setID: '111')
                                          CombinedSetPage(
                                        systemID1: sysID1,
                                        //systemID2: sysID2,
                                        //systemID3: sysID3,
                                        setCount: setCnt,
                                        searchQuery: widget.searchQuery,
                                      ),
                                ),
                              );
                            };
                          }

                          if (onPressed != null) {
                            onPressed();
                          } else {}
                        },
                        style: ElevatedButton.styleFrom(),
                        child: Text(
                          widget.batteryUnit["SetNo"] == "1"
                              ? 'View Battery Set'
                              : widget.batteryUnit["SetNo"] == "2"
                              ? 'View Battery Set'
                              : widget.batteryUnit["SetNo"] == "3"
                              ? 'View Battery Set'
                              : widget.batteryUnit["SetNo"] == "4"
                              ? 'View Battery Set'
                              : 'No valid SetNo',
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : Center(
                child: CircularProgressIndicator(color: qrcodeiconColor1),
              ),
    );
  }
}

class Lesson {
  final String subjectName;
  final String variable;

  Lesson({required this.subjectName, required this.variable});
}

//v5
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// import 'combinedSet.dart';
//
// class ViewBatteryUnit extends StatefulWidget {
//   final dynamic batteryUnit;
//   ViewBatteryUnit({required this.batteryUnit});
//
//   @override
//   ViewBatteryUnitState createState() => ViewBatteryUnitState();
// }
//
// class ViewBatteryUnitState extends State<ViewBatteryUnit> {
//   bool _dataLoaded = true;
//
//
//   void initState() {
//     super.initState();
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
//       height: 60.0, //
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
//
//   @override
//   Widget build(BuildContext context) {
//     String sysID1 = (widget.batteryUnit['SystemID'] ?? '0');
//     //int sysID2 = int.parse(widget.batteryUnit['SystemID'] ?? '0');
//     //int sysID3 = int.parse(widget.batteryUnit['SystemID'] ?? '0');
//     int setCnt = int.parse(widget.batteryUnit['SetNo'] ?? 0);
//
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Battery Unit Details"),
//         backgroundColor: Colors.blue,
//       ),
//       body: _dataLoaded
//
//           ? SingleChildScrollView(
//         child: Column(
//           children: [
//             makeCard(Lesson(
//                 subjectName: 'Battery ID',
//                 variable: widget.batteryUnit['SystemID'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Region',
//                 variable: widget.batteryUnit['Region'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Site',
//                 variable: widget.batteryUnit['Site'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'System Type',
//                 variable: widget.batteryUnit['sysType'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Battery Type',
//                 variable: widget.batteryUnit['batType'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Location',
//                 variable: widget.batteryUnit['Location'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Set Number',
//                 variable: widget.batteryUnit['SetNo'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Notes',
//                 variable: widget.batteryUnit['Notes'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Last Update',
//                 variable: widget.batteryUnit['last_updated'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Uploader',
//                 variable: widget.batteryUnit['uploader'] ?? 'N/A')),
//             ElevatedButton(
//               onPressed: () {
//                 String buttonText = '';
//                 Function()? onPressed;
//
//                 if (widget.batteryUnit["SetNo"] == "1") {
//                   buttonText = 'for set No 1';
//                   onPressed = () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => //Set1Page(setID: '111')
//                           CombinedSetPage(
//                             systemID1: sysID1,
//                             //systemID2: sysID2,
//                             //systemID3: sysID3,
//                             setCount: setCnt,
//                           )),
//                     );
//                   };
//                 }else if (widget.batteryUnit["SetNo"] == "2") {
//                   buttonText = 'for set No 2';
//                   onPressed = () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => //Set1Page(setID: '111')
//                           CombinedSetPage(
//                             systemID1: sysID1,
//                             //systemID2: sysID2,
//                             //systemID3: sysID3,
//                             setCount: setCnt,
//                           )),
//                     );
//                   };
//                 }if (widget.batteryUnit["SetNo"] == "3") {
//                   buttonText = 'for set No 3';
//                   onPressed = () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => //Set1Page(setID: '111')
//                           CombinedSetPage(
//                             systemID1: sysID1,
//                             //systemID2: sysID2,
//                             //systemID3: sysID3,
//                             setCount: setCnt,
//                           )),
//                     );
//                   };
//                 }if (widget.batteryUnit["SetNo"] == "4") {
//                   buttonText = 'for set No 4';
//                   onPressed = () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => //Set1Page(setID: '111')
//                           CombinedSetPage(
//                             systemID1: sysID1,
//                             //systemID2: sysID2,
//                             //systemID3: sysID3,
//                             setCount: setCnt,
//                           )),
//                     );
//                   };
//                 }
//
//                 if (onPressed != null) {
//                   onPressed();
//                 } else {
//
//                 }
//               },
//               child: Text(
//                 widget.batteryUnit["SetNo"] == "1"
//                     ? 'View Battery Set'
//                     : widget.batteryUnit["SetNo"] == "2"
//                     ? 'View Battery Set'
//                     : widget.batteryUnit["SetNo"] == "3"
//                     ? 'View Battery Set'
//                     : widget.batteryUnit["SetNo"] == "4"
//                     ? 'View Battery Set'
//                     : 'No valid SetNo',
//                 style: TextStyle(color: Colors.black),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.brown,
//               ),
//             ),
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

//v4 working code
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// import 'combinedSet.dart';
//
// class ViewBatteryUnit extends StatefulWidget {
//   final dynamic batteryUnit;
//   ViewBatteryUnit({required this.batteryUnit});
//
//   @override
//   ViewBatteryUnitState createState() => ViewBatteryUnitState();
// }
//
// class ViewBatteryUnitState extends State<ViewBatteryUnit> {
//   bool _dataLoaded = true;
//
//
//   void initState() {
//     super.initState();
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
//       height: 60.0, //
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
//
//   @override
//   Widget build(BuildContext context) {
//     int sysID = int.parse(widget.batteryUnit['SystemID'] ?? '0');
//     int setCnt=int.parse(widget.batteryUnit['SetNo'] ?? 0);
//
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Battery Unit Details"),
//         backgroundColor: Colors.blue,
//       ),
//       body: _dataLoaded
//
//           ? SingleChildScrollView(
//         child: Column(
//           children: [
//             makeCard(Lesson(
//                 subjectName: 'Battery ID',
//                 variable: widget.batteryUnit['SystemID'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Region',
//                 variable: widget.batteryUnit['Region'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Site',
//                 variable: widget.batteryUnit['Site'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'System Type',
//                 variable: widget.batteryUnit['sysType'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Battery Type',
//                 variable: widget.batteryUnit['batType'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Location',
//                 variable: widget.batteryUnit['Location'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Set Number',
//                 variable: widget.batteryUnit['SetNo'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Notes',
//                 variable: widget.batteryUnit['Notes'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Last Update',
//                 variable: widget.batteryUnit['last_updated'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Uploader',
//                 variable: widget.batteryUnit['uploader'] ?? 'N/A')),
//             ElevatedButton(
//               onPressed: () {
//                 String buttonText = '';
//                 Function()? onPressed;
//
//                 if (widget.batteryUnit["SetNo"] == "1") {
//                   buttonText = 'for set No 1';
//                   onPressed = () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => //Set1Page(setID: '111')
//                           CombinedSetPage(
//                             systemID: sysID,
//                             setCount: setCnt,
//                           )),
//                     );
//                   };
//                 }
//
//                 if (onPressed != null) {
//                   onPressed();
//                 } else {
//
//                 }
//               },
//               child: Text(
//                 widget.batteryUnit["SetNo"] == "1"
//                     ? 'View Battery Set'
//                     : widget.batteryUnit["SetNo"] == "2"
//                     ? 'View Battery Set'
//                     : widget.batteryUnit["SetNo"] == "3"
//                     ? 'View Battery Set'
//                     : 'No valid SetNo',
//                 style: TextStyle(color: Colors.black),
//               ),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.brown,
//               ),
//             ),
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

//v3
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// import 'combinedSet.dart';
//
// class ViewBatteryUnit extends StatefulWidget {
//     final dynamic batteryUnit;
//    ViewBatteryUnit({required this.batteryUnit});
//
//   @override
//   ViewBatteryUnitState createState() => ViewBatteryUnitState();
// }
//
// class ViewBatteryUnitState extends State<ViewBatteryUnit> {
//   bool _dataLoaded = true;
//
//
//   void initState() {
//     super.initState();
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
//       height: 60.0, //
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
//
//   @override
//   Widget build(BuildContext context) {
//     var sysID=widget.batteryUnit['SystemID'] ?? 'N/A';
//     var setCnt=widget.batteryUnit['SetNo'] ?? 'N/A';
//
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Battery Unit Details"),
//         backgroundColor: Colors.blue,
//       ),
//       body: _dataLoaded
//
//           ? SingleChildScrollView(
//         child: Column(
//           children: [
//             makeCard(Lesson(
//                 subjectName: 'Battery ID',
//                 variable: widget.batteryUnit['SystemID'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Region',
//                 variable: widget.batteryUnit['Region'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Site',
//                 variable: widget.batteryUnit['Site'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'System Type',
//                 variable: widget.batteryUnit['sysType'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Battery Type',
//                 variable: widget.batteryUnit['batType'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Location',
//                 variable: widget.batteryUnit['Location'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Set Number',
//                 variable: widget.batteryUnit['SetNo'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Notes',
//                 variable: widget.batteryUnit['Notes'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Last Update',
//                 variable: widget.batteryUnit['last_updated'] ?? 'N/A')),
//             makeCard(Lesson(
//                 subjectName: 'Uploader',
//                 variable: widget.batteryUnit['uploader'] ?? 'N/A')),
//             ElevatedButton(
//               onPressed: () {
//                 String buttonText = '';
//                 Function()? onPressed;
//
//                 if (widget.batteryUnit["SetNo"] == "1") {
//                   buttonText = 'for set No 1';
//                   onPressed = () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => //Set1Page(setID: '111')
//                           CombinedSetPage(
//                             systemID: sysID,
//                             setCount: setCnt,
//                           )),
//                     );
//                   };
//                 } else if (widget.batteryUnit["SetNo"] == "2") {
//                   buttonText = 'for set No 2';
//                   onPressed = () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder:
//                               (context) => //Set2Page(setID1: "118", setID2: "119",)
//                           CombinedSetPage(
//                               setId1: "118",
//                               setId2: "119",
//                               setId3: null)),
//                     );
//                   };
//                 } else if (widget.batteryUnit["SetNo"] == "3") {
//                   buttonText = 'for set No 3';
//                   onPressed = () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder:
//                               (context) => //Set3Page(setId1: '124', setId2: '125', setId3: '126')
//                           CombinedSetPage(
//                               setId1: "124",
//                               setId2: "125",
//                               setId3: "126")),
//                     );
//                   };
//                 }
//
//                 if (onPressed != null) {
//                   onPressed();
//                 } else {
//
//                 }
//               },
//               child: Text(
//                 widget.batteryUnit["SetNo"] == "1"
//                     ? 'View Battery Set'
//                     : widget.batteryUnit["SetNo"] == "2"
//                     ? 'View Battery Set'
//                     : widget.batteryUnit["SetNo"] == "3"
//                     ? 'View Battery Set'
//                     : 'No valid SetNo',
//                 style: TextStyle(color: Colors.black),
//               ),
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.brown,
//               ),
//             ),
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

//V2
// import 'package:flutter/material.dart';
//
// class ViewBatteryUnit extends StatelessWidget {
//   final dynamic batteryUnit;
//
//   ViewBatteryUnit({required this.batteryUnit});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Battery Unit Details'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'ID: ${batteryUnit['ID']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Region: ${batteryUnit['Region']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Site: ${batteryUnit['Site']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Battery Type: ${batteryUnit['batType']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Location: ${batteryUnit['Location']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Set Capacity: ${batteryUnit['set_cap']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Set Voltage: ${batteryUnit['set_volt']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Notes: ${batteryUnit['notes']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Tray Count: ${batteryUnit['trayCount']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Battery Voltage: ${batteryUnit['batVolt']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Battery Count: ${batteryUnit['batCount']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Brand: ${batteryUnit['brand']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Model: ${batteryUnit['model']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Battery Capacity: ${batteryUnit['batCap']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Connection Type: ${batteryUnit['conType']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Parallel: ${batteryUnit['Prll']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Parallel Connection 0: ${batteryUnit['parCon_0']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Parallel Connection 1: ${batteryUnit['parCon_1']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Parallel Connection 2: ${batteryUnit['parCon_2']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Installation Date: ${batteryUnit['installDt']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Warranty Start Date: ${batteryUnit['warrantSt']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Warranty End Date: ${batteryUnit['warrantEd']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Last Updated: ${batteryUnit['last_updated']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//V1
// import 'package:flutter/material.dart';
//
// class ViewBatteryUnit extends StatelessWidget {
//   final dynamic batteryUnit;
//
//   ViewBatteryUnit({required this.batteryUnit});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Battery Unit Details'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Site: ${batteryUnit['Site']}'),
//             Text('Location: ${batteryUnit['Location']}'),
//             // Display other battery unit details as needed
//           ],
//         ),
//       ),
//     );
//   }
// }
