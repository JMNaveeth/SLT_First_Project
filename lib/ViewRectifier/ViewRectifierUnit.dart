import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:powerprox/Screens/HomePage/utils/colors.dart';
import 'dart:convert';

import 'package:theme_update/utils/utils/colors.dart';


// import 'package:powerprox/Screens/HomePage/widgets/colors.dart';
//import '../RectifierMaintenancePage.dart';


class ViewRectifierUnit extends StatefulWidget {
  final dynamic RectifierUnit;
  final String searchQuery;

  ViewRectifierUnit({
    required this.RectifierUnit,
    this.searchQuery = '',
  });

  @override
  _ViewRectifierUnitState createState() => _ViewRectifierUnitState();
}

class _ViewRectifierUnitState extends State<ViewRectifierUnit> {
  late Future<List<Map<String, dynamic>>> _moduleDetailsFuture;

  @override
  void initState() {
    super.initState();
    _moduleDetailsFuture = fetchModuleDetails(widget.RectifierUnit['RecID']);
  }

  Future<List<Map<String, dynamic>>> fetchModuleDetails(String recID) async {
    final response = await http.get(
      Uri.parse('https://powerprox.sltidc.lk/GetRecModule.php'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Map<String, dynamic>> modules =
      List<Map<String, dynamic>>.from(data);
      return modules.where((module) => module['RecID'] == recID).toList();
    } else {
      throw Exception('Failed to load module details');
    }
  }

  Widget buildModuleTable(
      List<Map<String, dynamic>> modules, String title, List<String> keys) {
    List<DataRow> rows = [];
    for (var i = 0; i < keys.length; i++) {
      var key = keys[i];
      var value = modules.isNotEmpty ? modules[0][key] : null;
      if (value != null && value != 'null' && value.toString().trim().isNotEmpty) {
        final bool isMatch = widget.searchQuery.isNotEmpty &&
            value.toString().toLowerCase().contains(widget.searchQuery.toLowerCase());

        rows.add(
          DataRow(
            color: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (isMatch) return highlightColor;
                return i.isEven ? Colors.grey[500] : null;
              },
            ),
            cells: [
              DataCell(
                Text(
                  'Module ${i + 1}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey[700],
                  ),
                ),
              ),
              DataCell(
                Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    backgroundColor: isMatch ? highlightColor : null,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blue[800],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 6,
                  offset: const Offset(0, 2), // Shadow position
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DataTable(
                headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.blueGrey[100]!,
                ),
                columnSpacing: 40,
                dataRowHeight: 60,
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Module',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w800,
                        color: Colors.blueGrey,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Serial',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w800,
                        color: Colors.blueGrey,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
                rows: rows,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListTile makeListTile(String subjectName, String? variable) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      padding: const EdgeInsets.only(right: 12.0),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 2.5, color: Colors.blue.shade800),
        ),
      ),
      child: Text(
        subjectName,
        style: const TextStyle(
            color: mainTextColor, fontWeight: FontWeight.w900, fontSize: 15),
      ),
    ),
    title: Text(
      variable ?? 'N/A',
      style: const TextStyle(
          color: const Color.fromARGB(255, 109, 108, 108),
          fontWeight: FontWeight.w700,
          fontSize: 17),
    ),
  );

  Card makeCard(Lesson lesson) {
    final bool isMatch = widget.searchQuery.isNotEmpty &&
        lesson.variable != null &&
        lesson.variable.toString().toLowerCase().contains(widget.searchQuery.toLowerCase());

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SizedBox(
        height: 75.0,
        child: Container(
          decoration: BoxDecoration(
            color: isMatch ? highlightColor : suqarBackgroundColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: makeListTile(lesson.subjectName, lesson.variable),
        ),
      ),
    );
  }

  // Card makeCard(Lesson lesson) => Card(
  //   elevation: 4.0,
  //   margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
  //   shape: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.circular(8.0),
  //   ),
  //   child: SizedBox(
  //     height: 75.0, // Adjust the height as needed
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: suqarBackgroundColor,
  //         borderRadius: BorderRadius.circular(8.0),
  //       ),
  //       child: makeListTile(lesson.subjectName, lesson.variable),
  //     ),
  //   ),
  // );

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor:mainBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Rectifier Unit Details',
          style: TextStyle(color: Colors.white),
        ),centerTitle: true,
        backgroundColor: appbarColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        // backgroundColor: Color.fromARGB(255, 0, 68, 186),
      ),
      body: SingleChildScrollView(
        child:Container(
          color: mainBackgroundColor,

          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Displaying rectifier details
                Card(color: suqarBackgroundColor,
                  child:makeCard(Lesson(
                      subjectName: 'Rectifier ID',
                      variable: widget.RectifierUnit['RecID'] ?? 'N/A')),),

                Card(color: suqarBackgroundColor,
                  child:makeCard(Lesson(
                      subjectName: 'Region',
                      variable: widget.RectifierUnit['Region'] ?? 'N/A')),),

                Card(color: suqarBackgroundColor,
                  child:makeCard(Lesson(
                      subjectName: 'RTOM',
                      variable: widget.RectifierUnit['RTOM'] ?? 'N/A')),),
                Card(color: suqarBackgroundColor,
                  child:makeCard(Lesson(
                      subjectName: 'Station',
                      variable: widget.RectifierUnit['Station'] ?? 'N/A')),),
                Card(color: suqarBackgroundColor,
                  child: makeCard(Lesson(
                      subjectName: 'Brand',
                      variable: widget.RectifierUnit['Brand'] ?? 'N/A')),),
                Card(color: suqarBackgroundColor,
                  child:makeCard(Lesson(
                      subjectName: 'Model',
                      variable: widget.RectifierUnit['Model'] ?? 'N/A')),),
                Card(color: suqarBackgroundColor,
                  child:makeCard(Lesson(
                      subjectName: 'Frame Capacity Type',
                      variable: widget.RectifierUnit['FrameCapType'] ?? 'N/A')),),
                Card(color: suqarBackgroundColor,
                  child:makeCard(Lesson(
                      subjectName: 'Frame Capacity',
                      variable: widget.RectifierUnit['FrameCap'] ?? 'N/A')),),
                Card(color: suqarBackgroundColor,
                  child:makeCard(Lesson(
                      subjectName: 'Type',
                      variable: widget.RectifierUnit['Type'] ?? 'N/A')),),
                Card(color: suqarBackgroundColor,
                  child:makeCard(Lesson(
                      subjectName: 'Serial Number',
                      variable: widget.RectifierUnit['Serial'] ?? 'N/A')),),

                Card(color: suqarBackgroundColor,
                  child:makeCard(Lesson(
                      subjectName: 'Installed Date',
                      variable: widget.RectifierUnit['InstalledDate'] ?? 'N/A')),),
                Card(color: suqarBackgroundColor,
                  child:makeCard(Lesson(
                      subjectName: 'Power Module Model',
                      variable: widget.RectifierUnit['PWModModel'] ?? 'N/A')),),
                Card(color: suqarBackgroundColor,
                  child:makeCard(Lesson(
                      subjectName: 'Ampere Rating',
                      variable: widget.RectifierUnit['AmpRating'] ?? 'N/A')),),
                Card(color: suqarBackgroundColor,
                  child:makeCard(Lesson(
                      subjectName: 'Power Module Slots',
                      variable: widget.RectifierUnit['PWModsUsed'] ?? 'N/A')),),
                Card(color: suqarBackgroundColor,
                  child:makeCard(Lesson(
                      subjectName: 'Power Modules Available',
                      variable: widget.RectifierUnit['PWModsAvai'] ?? 'N/A')),),
                Card(color: suqarBackgroundColor,
                  child:makeCard(Lesson(
                      subjectName: 'Control Module Model',
                      variable: widget.RectifierUnit['CtrModModel'] ?? 'N/A')),),
                Card(color: suqarBackgroundColor,
                  child:makeCard(Lesson(
                      subjectName: 'Control Modules Slots',
                      variable: widget.RectifierUnit['CtrModsUsed'] ?? 'N/A')),),
                Card(color: suqarBackgroundColor,
                  child:makeCard(Lesson(
                      subjectName: 'Control Modules Available',
                      variable: widget.RectifierUnit['CtrModsAvail'] ?? 'N/A')),),
                Card(color: suqarBackgroundColor,
                  child:makeCard(Lesson(
                      subjectName: 'Last Updated',
                      variable: widget.RectifierUnit['LastUpdated'] ?? 'N/A')),),
                Card(color: suqarBackgroundColor,
                  child:makeCard(Lesson(
                      subjectName: 'Updated By',
                      variable: widget.RectifierUnit['Updated_By'] ?? 'N/A')),),

                const SizedBox(
                  height: 25,
                ),
                // Loading and displaying module details
                Center(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _moduleDetailsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Error loading module details'),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No module details available'),
                        );
                      } else {
                        // Display Power and Control Modules
                        return Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              buildModuleTable(snapshot.data!, 'Power Modules', [
                                'PW_Serial_1',
                                'PW_Serial_2',
                                'PW_Serial_3',
                                'PW_Serial_4',
                                'PW_Serial_5',
                                'PW_Serial_6',
                                'PW_Serial_7',
                                'PW_Serial_8',
                                'PW_Serial_9',
                                'PW_Serial_10',
                              ]),
                              const SizedBox(
                                height: 20,
                              ),
                              buildModuleTable(
                                  snapshot.data!, 'Control Modules', [
                                'Ctr_Serial_1',
                                'Ctr_Serial_2',
                                'Ctr_Serial_3',
                                'Ctr_Serial_4',
                                'Ctr_Serial_5',
                              ]),
                              const SizedBox(
                                height: 20,
                              ),
                              // ElevatedButton.icon(
                              //   onPressed: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => RectifierMaintenancePage(),
                              //       ),
                              //     );
                              //   },
                              //   icon: Icon(
                              //     Icons.home,
                              //     size: 28,
                              //     color: Colors.white,
                              //   ),
                              //   label: Text(
                              //     "Go Back",
                              //     style: TextStyle(
                              //       fontSize: 18,
                              //       fontWeight: FontWeight.bold,
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              //   style: ElevatedButton.styleFrom(
                              //     padding: EdgeInsets.symmetric(
                              //         horizontal: 20, vertical: 15),
                              //     backgroundColor:
                              //     Color.fromARGB(255, 35, 70, 226),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(12),
                              //     ),
                              //     elevation: 4,
                              //     shadowColor: Colors.grey,
                              //   ),
                              // )
                            ],
                          ),
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

class Lesson {
  final String subjectName;
  final String variable;

  Lesson({required this.subjectName, required this.variable});
}



//v7
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// // import 'package:powerprox/Screens/HomePage/utils/colors.dart';
// import 'dart:convert';
//
// import 'package:powerprox/Screens/HomePage/widgets/colors.dart';
// //import '../RectifierMaintenancePage.dart';
//
//
// class ViewRectifierUnit extends StatefulWidget {
//   final dynamic RectifierUnit;
//
//   ViewRectifierUnit({required this.RectifierUnit});
//
//   @override
//   _ViewRectifierUnitState createState() => _ViewRectifierUnitState();
// }
//
// class _ViewRectifierUnitState extends State<ViewRectifierUnit> {
//   late Future<List<Map<String, dynamic>>> _moduleDetailsFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _moduleDetailsFuture = fetchModuleDetails(widget.RectifierUnit['RecID']);
//   }
//
//   Future<List<Map<String, dynamic>>> fetchModuleDetails(String recID) async {
//     final response = await http.get(
//       Uri.parse('https://powerprox.sltidc.lk/GetRecModule.php'),
//     );
//
//     if (response.statusCode == 200) {
//       List<dynamic> data = jsonDecode(response.body);
//       List<Map<String, dynamic>> modules =
//       List<Map<String, dynamic>>.from(data);
//       return modules.where((module) => module['RecID'] == recID).toList();
//     } else {
//       throw Exception('Failed to load module details');
//     }
//   }
//
//   Widget buildModuleTable(
//       List<Map<String, dynamic>> modules, String title, List<String> keys) {
//     List<DataRow> rows = [];
//     for (var i = 0; i < keys.length; i++) {
//       var key = keys[i];
//       var value = modules.isNotEmpty ? modules[0][key] : null;
//       if (value != null &&
//           value != 'null' &&
//           value.toString().trim().isNotEmpty) {
//         rows.add(
//           DataRow(
//             color: MaterialStateProperty.resolveWith<Color?>(
//                   (Set<MaterialState> states) {
//                 return i.isEven
//                     ? Colors.grey[500]
//                     : null; // Alternate row color
//               },
//             ),
//             cells: [
//               DataCell(
//                 Text(
//                   'Module ${i + 1}',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.blueGrey[700],
//                   ),
//                 ),
//               ),
//               DataCell(
//                 Text(
//                   value.toString(),
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }
//     }
//
//     return Center(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(height: 20),
//           Center(
//             child: Text(
//               title,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//                 color: Colors.blue[800],
//               ),
//             ),
//           ),
//           SizedBox(height: 10),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   blurRadius: 6,
//                   offset: Offset(0, 2), // Shadow position
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: DataTable(
//                 headingRowColor: MaterialStateColor.resolveWith(
//                       (states) => Colors.blueGrey[100]!,
//                 ),
//                 columnSpacing: 40,
//                 dataRowHeight: 60,
//                 columns: const <DataColumn>[
//                   DataColumn(
//                     label: Text(
//                       'Module',
//                       style: TextStyle(
//                         fontStyle: FontStyle.italic,
//                         fontWeight: FontWeight.w800,
//                         color: Colors.blueGrey,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Text(
//                       'Serial',
//                       style: TextStyle(
//                         fontStyle: FontStyle.italic,
//                         fontWeight: FontWeight.w800,
//                         color: Colors.blueGrey,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                 ],
//                 rows: rows,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   ListTile makeListTile(String subjectName, String? variable) => ListTile(
//     contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//     leading: Container(
//       padding: EdgeInsets.only(right: 12.0),
//       decoration: BoxDecoration(
//         border: Border(
//           right: BorderSide(width: 2.5, color: Colors.blue.shade800),
//         ),
//       ),
//       child: Text(
//         subjectName,
//         style: TextStyle(
//             color: mainTextColor, fontWeight: FontWeight.w900, fontSize: 15),
//       ),
//     ),
//     title: Text(
//       variable ?? 'N/A',
//       style: TextStyle(
//           color: const Color.fromARGB(255, 109, 108, 108),
//           fontWeight: FontWeight.w700,
//           fontSize: 17),
//     ),
//   );
//
//   Card makeCard(Lesson lesson) => Card(
//     elevation: 4.0,
//     margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(8.0),
//     ),
//     child: SizedBox(
//       height: 75.0, // Adjust the height as needed
//       child: Container(
//         decoration: BoxDecoration(
//           color: suqarBackgroundColor,
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         child: makeListTile(lesson.subjectName, lesson.variable),
//       ),
//     ),
//   );
//
//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       backgroundColor:mainBackgroundColor,
//       appBar: AppBar(
//         title: Text(
//           'Rectifier Unit Details',
//           style: TextStyle(color: Colors.white),
//         ),centerTitle: true,
//         backgroundColor: appbarColor,
//         iconTheme: IconThemeData(
//           color: Colors.white,
//         ),
//         // backgroundColor: Color.fromARGB(255, 0, 68, 186),
//       ),
//       body: SingleChildScrollView(
//         child:Container(
//           color: mainBackgroundColor,
//
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Displaying rectifier details
//                 Card(color: suqarBackgroundColor,
//                   child:makeCard(Lesson(
//                       subjectName: 'Rectifier ID',
//                       variable: widget.RectifierUnit['RecID'] ?? 'N/A')),),
//
//                 Card(color: suqarBackgroundColor,
//                   child:makeCard(Lesson(
//                       subjectName: 'Region',
//                       variable: widget.RectifierUnit['Region'] ?? 'N/A')),),
//
//                 Card(color: suqarBackgroundColor,
//                   child:makeCard(Lesson(
//                       subjectName: 'RTOM',
//                       variable: widget.RectifierUnit['RTOM'] ?? 'N/A')),),
//                 Card(color: suqarBackgroundColor,
//                   child:makeCard(Lesson(
//                       subjectName: 'Station',
//                       variable: widget.RectifierUnit['Station'] ?? 'N/A')),),
//                 Card(color: suqarBackgroundColor,
//                   child: makeCard(Lesson(
//                       subjectName: 'Brand',
//                       variable: widget.RectifierUnit['Brand'] ?? 'N/A')),),
//                 Card(color: suqarBackgroundColor,
//                   child:makeCard(Lesson(
//                       subjectName: 'Model',
//                       variable: widget.RectifierUnit['Model'] ?? 'N/A')),),
//                 Card(color: suqarBackgroundColor,
//                   child:makeCard(Lesson(
//                       subjectName: 'Frame Capacity Type',
//                       variable: widget.RectifierUnit['FrameCapType'] ?? 'N/A')),),
//                 Card(color: suqarBackgroundColor,
//                   child:makeCard(Lesson(
//                       subjectName: 'Frame Capacity',
//                       variable: widget.RectifierUnit['FrameCap'] ?? 'N/A')),),
//                 Card(color: suqarBackgroundColor,
//                   child:makeCard(Lesson(
//                       subjectName: 'Type',
//                       variable: widget.RectifierUnit['Type'] ?? 'N/A')),),
//                 Card(color: suqarBackgroundColor,
//                   child:makeCard(Lesson(
//                       subjectName: 'Serial Number',
//                       variable: widget.RectifierUnit['Serial'] ?? 'N/A')),),
//
//                 Card(color: suqarBackgroundColor,
//                   child:makeCard(Lesson(
//                       subjectName: 'Installed Date',
//                       variable: widget.RectifierUnit['InstalledDate'] ?? 'N/A')),),
//                 Card(color: suqarBackgroundColor,
//                   child:makeCard(Lesson(
//                       subjectName: 'Power Module Model',
//                       variable: widget.RectifierUnit['PWModModel'] ?? 'N/A')),),
//                 Card(color: suqarBackgroundColor,
//                   child:makeCard(Lesson(
//                       subjectName: 'Ampere Rating',
//                       variable: widget.RectifierUnit['AmpRating'] ?? 'N/A')),),
//                 Card(color: suqarBackgroundColor,
//                   child:makeCard(Lesson(
//                       subjectName: 'Power Module Slots',
//                       variable: widget.RectifierUnit['PWModsUsed'] ?? 'N/A')),),
//                 Card(color: suqarBackgroundColor,
//                   child:makeCard(Lesson(
//                       subjectName: 'Power Modules Available',
//                       variable: widget.RectifierUnit['PWModsAvai'] ?? 'N/A')),),
//                 Card(color: suqarBackgroundColor,
//                   child:makeCard(Lesson(
//                       subjectName: 'Control Module Model',
//                       variable: widget.RectifierUnit['CtrModModel'] ?? 'N/A')),),
//                 Card(color: suqarBackgroundColor,
//                   child:makeCard(Lesson(
//                       subjectName: 'Control Modules Slots',
//                       variable: widget.RectifierUnit['CtrModsUsed'] ?? 'N/A')),),
//                 Card(color: suqarBackgroundColor,
//                   child:makeCard(Lesson(
//                       subjectName: 'Control Modules Available',
//                       variable: widget.RectifierUnit['CtrModsAvail'] ?? 'N/A')),),
//                 Card(color: suqarBackgroundColor,
//                   child:makeCard(Lesson(
//                       subjectName: 'Last Updated',
//                       variable: widget.RectifierUnit['LastUpdated'] ?? 'N/A')),),
//                 Card(color: suqarBackgroundColor,
//                   child:makeCard(Lesson(
//                       subjectName: 'Updated By',
//                       variable: widget.RectifierUnit['Updated_By'] ?? 'N/A')),),
//
//                 SizedBox(
//                   height: 25,
//                 ),
//                 // Loading and displaying module details
//                 Center(
//                   child: FutureBuilder<List<Map<String, dynamic>>>(
//                     future: _moduleDetailsFuture,
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       } else if (snapshot.hasError) {
//                         return Center(
//                           child: Text('Error loading module details'),
//                         );
//                       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                         return Center(
//                           child: Text('No module details available'),
//                         );
//                       } else {
//                         // Display Power and Control Modules
//                         return Center(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               buildModuleTable(snapshot.data!, 'Power Modules', [
//                                 'PW_Serial_1',
//                                 'PW_Serial_2',
//                                 'PW_Serial_3',
//                                 'PW_Serial_4',
//                                 'PW_Serial_5',
//                                 'PW_Serial_6',
//                                 'PW_Serial_7',
//                                 'PW_Serial_8',
//                                 'PW_Serial_9',
//                                 'PW_Serial_10',
//                               ]),
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               buildModuleTable(
//                                   snapshot.data!, 'Control Modules', [
//                                 'Ctr_Serial_1',
//                                 'Ctr_Serial_2',
//                                 'Ctr_Serial_3',
//                                 'Ctr_Serial_4',
//                                 'Ctr_Serial_5',
//                               ]),
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               // ElevatedButton.icon(
//                               //   onPressed: () {
//                               //     Navigator.push(
//                               //       context,
//                               //       MaterialPageRoute(
//                               //         builder: (context) => RectifierMaintenancePage(),
//                               //       ),
//                               //     );
//                               //   },
//                               //   icon: Icon(
//                               //     Icons.home,
//                               //     size: 28,
//                               //     color: Colors.white,
//                               //   ),
//                               //   label: Text(
//                               //     "Go Back",
//                               //     style: TextStyle(
//                               //       fontSize: 18,
//                               //       fontWeight: FontWeight.bold,
//                               //       color: Colors.white,
//                               //     ),
//                               //   ),
//                               //   style: ElevatedButton.styleFrom(
//                               //     padding: EdgeInsets.symmetric(
//                               //         horizontal: 20, vertical: 15),
//                               //     backgroundColor:
//                               //     Color.fromARGB(255, 35, 70, 226),
//                               //     shape: RoundedRectangleBorder(
//                               //       borderRadius: BorderRadius.circular(12),
//                               //     ),
//                               //     elevation: 4,
//                               //     shadowColor: Colors.grey,
//                               //   ),
//                               // )
//                             ],
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
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


//v4 25-02-23
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../RectifierMaintenancePage.dart';
//
//
// class ViewRectifierUnit extends StatefulWidget {
//   final dynamic RectifierUnit;
//
//   ViewRectifierUnit({required this.RectifierUnit});
//
//   @override
//   _ViewRectifierUnitState createState() => _ViewRectifierUnitState();
// }
//
// class _ViewRectifierUnitState extends State<ViewRectifierUnit> {
//   late Future<List<Map<String, dynamic>>> _moduleDetailsFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _moduleDetailsFuture = fetchModuleDetails(widget.RectifierUnit['RecID']);
//   }
//
//   Future<List<Map<String, dynamic>>> fetchModuleDetails(String recID) async {
//     final response = await http.get(
//       Uri.parse('https://powerprox.sltidc.lk/GetRecModule.php'),
//     );
//
//     if (response.statusCode == 200) {
//       List<dynamic> data = jsonDecode(response.body);
//       List<Map<String, dynamic>> modules =
//       List<Map<String, dynamic>>.from(data);
//       return modules.where((module) => module['RecID'] == recID).toList();
//     } else {
//       throw Exception('Failed to load module details');
//     }
//   }
//
//   Widget buildModuleTable(
//       List<Map<String, dynamic>> modules, String title, List<String> keys) {
//     List<DataRow> rows = [];
//     for (var i = 0; i < keys.length; i++) {
//       var key = keys[i];
//       var value = modules.isNotEmpty ? modules[0][key] : null;
//       if (value != null &&
//           value != 'null' &&
//           value.toString().trim().isNotEmpty) {
//         rows.add(
//           DataRow(
//             color: MaterialStateProperty.resolveWith<Color?>(
//                   (Set<MaterialState> states) {
//                 return i.isEven
//                     ? Colors.grey[200]
//                     : null; // Alternate row color
//               },
//             ),
//             cells: [
//               DataCell(
//                 Text(
//                   'Module ${i + 1}',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.blueGrey[700],
//                   ),
//                 ),
//               ),
//               DataCell(
//                 Text(
//                   value.toString(),
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }
//     }
//
//     return Center(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(height: 20),
//           Center(
//             child: Text(
//               title,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//                 color: Colors.blue[800],
//               ),
//             ),
//           ),
//           SizedBox(height: 10),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   blurRadius: 6,
//                   offset: Offset(0, 2), // Shadow position
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: DataTable(
//                 headingRowColor: MaterialStateColor.resolveWith(
//                       (states) => Colors.blueGrey[100]!,
//                 ),
//                 columnSpacing: 40,
//                 dataRowHeight: 60,
//                 columns: const <DataColumn>[
//                   DataColumn(
//                     label: Text(
//                       'Module',
//                       style: TextStyle(
//                         fontStyle: FontStyle.italic,
//                         fontWeight: FontWeight.w800,
//                         color: Colors.blueGrey,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Text(
//                       'Serial',
//                       style: TextStyle(
//                         fontStyle: FontStyle.italic,
//                         fontWeight: FontWeight.w800,
//                         color: Colors.blueGrey,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                 ],
//                 rows: rows,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   ListTile makeListTile(String subjectName, String? variable) => ListTile(
//     contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//     leading: Container(
//       padding: EdgeInsets.only(right: 12.0),
//       decoration: BoxDecoration(
//         border: Border(
//           right: BorderSide(width: 2.5, color: Colors.blue.shade800),
//         ),
//       ),
//       child: Text(
//         subjectName,
//         style: TextStyle(
//             color: Colors.black, fontWeight: FontWeight.w900, fontSize: 15),
//       ),
//     ),
//     title: Text(
//       variable ?? 'N/A',
//       style: TextStyle(
//           color: const Color.fromARGB(255, 109, 108, 108),
//           fontWeight: FontWeight.w700,
//           fontSize: 17),
//     ),
//   );
//
//   Card makeCard(Lesson lesson) => Card(
//     elevation: 4.0,
//     margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(8.0),
//     ),
//     child: SizedBox(
//       height: 75.0, // Adjust the height as needed
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8.0),
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
//         title: Text(
//           'Rectifier Unit Details',
//           style: TextStyle(color: Colors.white),
//         ),
//         iconTheme: IconThemeData(
//           color: Colors.white,
//         ),
//         backgroundColor: Color.fromARGB(255, 0, 68, 186),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Displaying rectifier details
//               makeCard(Lesson(
//                   subjectName: 'Rectifier ID',
//                   variable: widget.RectifierUnit['RecID'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Region',
//                   variable: widget.RectifierUnit['Region'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'RTOM',
//                   variable: widget.RectifierUnit['RTOM'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Station',
//                   variable: widget.RectifierUnit['Station'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Brand',
//                   variable: widget.RectifierUnit['Brand'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Model',
//                   variable: widget.RectifierUnit['Model'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Frame Capacity Type',
//                   variable: widget.RectifierUnit['FrameCapType'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Frame Capacity',
//                   variable: widget.RectifierUnit['FrameCap'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Type',
//                   variable: widget.RectifierUnit['Type'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Serial Number',
//                   variable: widget.RectifierUnit['Serial'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Installed Date',
//                   variable: widget.RectifierUnit['InstalledDate'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Power Module Model',
//                   variable: widget.RectifierUnit['PWModModel'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Ampere Rating',
//                   variable: widget.RectifierUnit['AmpRating'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Power Module Slots',
//                   variable: widget.RectifierUnit['PWModsUsed'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Power Modules Available',
//                   variable: widget.RectifierUnit['PWModsAvai'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Control Module Model',
//                   variable: widget.RectifierUnit['CtrModModel'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Control Modules Slots',
//                   variable: widget.RectifierUnit['CtrModsUsed'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Control Modules Available',
//                   variable: widget.RectifierUnit['CtrModsAvail'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Last Updated',
//                   variable: widget.RectifierUnit['LastUpdated'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Updated By',
//                   variable: widget.RectifierUnit['Updated_By'] ?? 'N/A')),
//               SizedBox(
//                 height: 25,
//               ),
//               // Loading and displaying module details
//               Center(
//                 child: FutureBuilder<List<Map<String, dynamic>>>(
//                   future: _moduleDetailsFuture,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     } else if (snapshot.hasError) {
//                       return Center(
//                         child: Text('Error loading module details'),
//                       );
//                     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return Center(
//                         child: Text('No module details available'),
//                       );
//                     } else {
//                       // Display Power and Control Modules
//                       return Center(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             buildModuleTable(snapshot.data!, 'Power Modules', [
//                               'PW_Serial_1',
//                               'PW_Serial_2',
//                               'PW_Serial_3',
//                               'PW_Serial_4',
//                               'PW_Serial_5',
//                               'PW_Serial_6',
//                               'PW_Serial_7',
//                               'PW_Serial_8',
//                               'PW_Serial_9',
//                               'PW_Serial_10',
//                             ]),
//                             SizedBox(
//                               height: 20,
//                             ),
//                             buildModuleTable(
//                                 snapshot.data!, 'Control Modules', [
//                               'Ctr_Serial_1',
//                               'Ctr_Serial_2',
//                               'Ctr_Serial_3',
//                               'Ctr_Serial_4',
//                               'Ctr_Serial_5',
//                             ]),
//                             SizedBox(
//                               height: 20,
//                             ),
//                             ElevatedButton.icon(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => RectifierMaintenancePage(),
//                                   ),
//                                 );
//                               },
//                               icon: Icon(
//                                 Icons.home,
//                                 size: 28,
//                                 color: Colors.white,
//                               ),
//                               label: Text(
//                                 "Go Back",
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 20, vertical: 15),
//                                 backgroundColor:
//                                 Color.fromARGB(255, 35, 70, 226),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 elevation: 4,
//                                 shadowColor: Colors.grey,
//                               ),
//                             )
//                           ],
//                         ),
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
// class Lesson {
//   final String subjectName;
//   final String variable;
//
//   Lesson({required this.subjectName, required this.variable});
// }




//v3 working as of 07-09-2024
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class ViewRectifierUnit extends StatefulWidget {
//   final dynamic RectifierUnit;
//
//   ViewRectifierUnit({required this.RectifierUnit});
//
//   @override
//   _ViewRectifierUnitState createState() => _ViewRectifierUnitState();
// }
//
// class _ViewRectifierUnitState extends State<ViewRectifierUnit> {
//   late Future<List<Map<String, dynamic>>> _moduleDetailsFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _moduleDetailsFuture = fetchModuleDetails(widget.RectifierUnit['RecID']);
//   }
//
//   Future<List<Map<String, dynamic>>> fetchModuleDetails(String recID) async {
//     final response = await http.get(
//       Uri.parse('https://powerprox.sltidc.lk/GetRecModule.php'),
//     );
//
//     if (response.statusCode == 200) {
//       List<dynamic> data = jsonDecode(response.body);
//       List<Map<String, dynamic>> modules =
//       List<Map<String, dynamic>>.from(data);
//       return modules.where((module) => module['RecID'] == recID).toList();
//     } else {
//       throw Exception('Failed to load module details');
//     }
//   }
//
//   Widget buildModuleTable(List<Map<String, dynamic>> modules, String title,
//       List<String> keys) {
//     List<DataRow> rows = [];
//     for (var i = 0; i < keys.length; i++) {
//       var key = keys[i];
//       var value = modules.isNotEmpty ? modules[0][key] : null;
//       if (value != null && value != 'null' && value.toString().trim().isNotEmpty) {
//         rows.add(
//           DataRow(
//             cells: [
//               DataCell(Text('Module ${i + 1}')),
//               DataCell(Text(value.toString())),
//             ],
//           ),
//         );
//       }
//     }
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(height: 20),
//         Center(
//           child: Text(
//             title,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//               color: Colors.black,
//             ),
//           ),
//         ),
//         SizedBox(height: 10),
//         DataTable(
//           columns: const <DataColumn>[
//             DataColumn(
//               label: Text(
//                 'Module',
//                 style: TextStyle(fontStyle: FontStyle.italic),
//               ),
//             ),
//             DataColumn(
//               label: Text(
//                 'Serial',
//                 style: TextStyle(fontStyle: FontStyle.italic),
//               ),
//             ),
//           ],
//           rows: rows,
//         ),
//       ],
//     );
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
//         title: Text('Rectifier Unit Details'),
//         backgroundColor: Colors.blue,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               makeCard(Lesson(
//                   subjectName: 'Rectifier ID',
//                   variable: widget.RectifierUnit['RecID'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Region',
//                   variable: widget.RectifierUnit['Region'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'RTOM',
//                   variable: widget.RectifierUnit['RTOM'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Station',
//                   variable: widget.RectifierUnit['Station'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Brand',
//                   variable: widget.RectifierUnit['Brand'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Model',
//                   variable: widget.RectifierUnit['Model'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Frame Capacity Type',
//                   variable: widget.RectifierUnit['FrameCapType'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Frame Capacity',
//                   variable: widget.RectifierUnit['FrameCap'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Type',
//                   variable: widget.RectifierUnit['Type'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Serial Number',
//                   variable: widget.RectifierUnit['Serial'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Installed Date',
//                   variable: widget.RectifierUnit['InstalledDate'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Power Module Model',
//                   variable: widget.RectifierUnit['PWModModel'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Ampere Rating',
//                   variable: widget.RectifierUnit['AmpRating'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Power Module Slots',
//                   variable: widget.RectifierUnit['PWModsUsed'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Power Modules Available',
//                   variable: widget.RectifierUnit['PWModsAvai'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Control Module Model',
//                   variable: widget.RectifierUnit['CtrModModel'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Control Modules Slots',
//                   variable: widget.RectifierUnit["CtrModsUsed"])),
//               makeCard(Lesson(
//                   subjectName: 'Control Modules Available',
//                   variable: widget.RectifierUnit['CtrModsAvail'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Last Updated',
//                   variable: widget.RectifierUnit['LastUpdated'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Updated By',
//                   variable: widget.RectifierUnit['Updated_By'] ?? 'N/A')),
//
//               // Loading and displaying module details
//               FutureBuilder<List<Map<String, dynamic>>>(
//                 future: _moduleDetailsFuture,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   } else if (snapshot.hasError) {
//                     return Center(
//                       child: Text('Error loading module details'),
//                     );
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return Center(
//                       child: Text('No module details available'),
//                     );
//                   } else {
//                     // Display Power and Control Modules
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         buildModuleTable(snapshot.data!, 'Power Modules', [
//                           'PW_Serial_1',
//                           'PW_Serial_2',
//                           'PW_Serial_3',
//                           'PW_Serial_4',
//                           'PW_Serial_5',
//                           'PW_Serial_6',
//                           'PW_Serial_7',
//                           'PW_Serial_8',
//                           'PW_Serial_9',
//                           'PW_Serial_10',
//                         ]),
//                         buildModuleTable(snapshot.data!, 'Control Modules', [
//                           'Ctr_Serial_1',
//                           'Ctr_Serial_2',
//                           'Ctr_Serial_3',
//                           'Ctr_Serial_4',
//                           'Ctr_Serial_5',
//                         ]),
//                       ],
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
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


//v2 working as of 06/09/2024
// import 'package:flutter/material.dart';
//
// class ViewRectifierUnit extends StatelessWidget {
//   final dynamic RectifierUnit;
//
//   ViewRectifierUnit({required this.RectifierUnit});
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
//         title: Text('Rectifier Unit Details'),
//         backgroundColor: Colors.blue,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               makeCard(Lesson(
//                   subjectName: 'Rectifier ID',
//                   variable: RectifierUnit['RecID'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Region',
//                   variable: RectifierUnit['Region'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'RTOM',
//                   variable: RectifierUnit['RTOM'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Station',
//                   variable: RectifierUnit['Station'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Brand',
//                   variable: RectifierUnit['Brand'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Model',
//                   variable: RectifierUnit['Model'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Frame Capacity Type',
//                   variable: RectifierUnit['FrameCapType'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Frame Capacity',
//                   variable: RectifierUnit['FrameCap'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Type',
//                   variable: RectifierUnit['Type'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Serial Number',
//                   variable: RectifierUnit['Serial'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Installed Date',
//                   variable: RectifierUnit['InstalledDate'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Power Module Model',
//                   variable: RectifierUnit['PWModModel'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Ampere Rating',
//                   variable: RectifierUnit['AmpRating'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Power Module Slots',
//                   variable: RectifierUnit['PWModsUsed'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Power Modules Available',
//                   variable: RectifierUnit['PWModsAvai'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Control Module Model',
//                   variable: RectifierUnit['CtrModModel'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Control Modules Slots',
//                   variable: RectifierUnit["CtrModsUsed"])),
//               makeCard(Lesson(
//                   subjectName: 'Control Modules Available',
//                   variable: RectifierUnit['CtrModsAvail'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Last Updated',
//                   variable: RectifierUnit['LastUpdated'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Updated By',
//                   variable: RectifierUnit['Updated_By'] ?? 'N/A')),
//
//             ],
//           ),
//         ),
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




//v1 working
// import 'package:flutter/material.dart';
//
// class ViewRectifierUnit extends StatelessWidget {
//   final dynamic RectifierUnit;
//
//   ViewRectifierUnit({required this.RectifierUnit});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Rectifier Unit Details'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Rectifier ID: ${RectifierUnit['RecID']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Region: ${RectifierUnit['Region']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Site: ${RectifierUnit['RTOM']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Station: ${RectifierUnit['Station']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Brand: ${RectifierUnit['Brand']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Model: ${RectifierUnit['Model']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//
//               Text(
//                 'Frame Capacity: ${RectifierUnit['FrameCap']}${RectifierUnit['FrameCapType']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Rectifier Type: ${RectifierUnit['Type']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Serial of The Rectifier: ${RectifierUnit['Serial']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Date of Install: ${RectifierUnit['InstalledDate']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Power Module Model: ${RectifierUnit['PWModModel']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Power Module Slots: ${RectifierUnit['PWModsAvail']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Power Modules Available: ${RectifierUnit['PWModsUsed']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Control Module Model: ${RectifierUnit['CtrModModel']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Control Module Slots: ${RectifierUnit['CtrModsAvail']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Control Modules Available: ${RectifierUnit['CtrModsUsed']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//


