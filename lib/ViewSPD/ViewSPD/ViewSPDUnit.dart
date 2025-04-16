import 'package:flutter/material.dart';

import '../../utils/utils/colors.dart';

class ViewSPDUnit extends StatelessWidget {
  final dynamic SPDUnit;
  final String searchQuery;

  ViewSPDUnit({required this.SPDUnit, this.searchQuery = ''});

  Widget buildListTile(String title, String? value) {
    final bool isMatch = searchQuery.isNotEmpty &&
        value != null &&
        value.toLowerCase().contains(searchQuery.toLowerCase());

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: isMatch ? highlightColor : suqarBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Icon(Icons.info_outline, color: Colors.grey),
        title: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: mainTextColor, fontSize: 16),
        ),
        subtitle: Text(
          value ?? 'N/A',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: subTextColor,
            backgroundColor: isMatch ? highlightColor : null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SPD Unit Details', style: TextStyle(color: mainTextColor),),
        iconTheme: IconThemeData(
          color: mainTextColor,
        ),
        backgroundColor: appbarColor,
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xff343A40)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // SPD Unit details, dynamically rendered
                buildListTile('SPDid', SPDUnit['SPDid']),
                buildListTile('Province', SPDUnit['province']),
                buildListTile('Rtom_name', SPDUnit['Rtom_name']),
                buildListTile('Station', SPDUnit['station']),
                buildListTile('SPD Location', SPDUnit['SPDLoc']),
                buildListTile('DCFlag', SPDUnit['DCFlag']),
                buildListTile('Poles', SPDUnit['poles']),
                buildListTile('SPD Type', SPDUnit['SPDType']),
                buildListTile('SPD Manufacture', SPDUnit['SPD_Manu']),
                buildListTile('SPD Model', SPDUnit['model_SPD']),
                buildListTile('Status', SPDUnit['Status']),
                buildListTile('Installed Date', SPDUnit['installDt']),
                buildListTile('Warranty Date', SPDUnit['warrentyDt']),
                buildListTile('Notes', SPDUnit['Notes']),
                buildListTile('Response Time', SPDUnit['responseTime']),
                buildListTile('Submitter', SPDUnit['Submitter']),
                buildListTile('Last Updated', SPDUnit['LastUpdated']),

                // Additional details based on DCFlag
                if (SPDUnit["DCFlag"] == "0")
                  Column(
                    children: [
                      buildListTile('Modular', SPDUnit["modular"]),
                      buildListTile('Phase', SPDUnit["phase"]),
                      buildListTile(
                          'Max continuous operating voltage live-type',
                          SPDUnit["UcLiveMode"]),
                      buildListTile(
                          'Max continuous operating voltage live - reading',
                          SPDUnit["UcLiveVolt"]),
                      buildListTile('Max continuous operating voltage-neutral',
                          SPDUnit["UcNeutralVolt"]),
                      buildListTile('UpLiveVolt', SPDUnit["UpLiveVolt"]),
                      buildListTile('UpNeutralVolt', SPDUnit["UpNeutralVolt"]),
                      buildListTile('Discharge Type', SPDUnit["dischargeType"]),
                      buildListTile('Line 8 to 20 Nominal Discharge',
                          SPDUnit["L8to20NomD"]),
                      buildListTile('Neutral 8 to 20 Nominal Discharge',
                          SPDUnit["N8to20NomD"]),
                      buildListTile('Line 10 to 350 Impulse Discharge',
                          SPDUnit["L10to350ImpD"]),
                      buildListTile('Neutral 10 to 350 Impulse Discharge',
                          SPDUnit["N10to350ImpD"]),
                      buildListTile('MCB Rating', SPDUnit["mcbRating"]),
                      buildListTile('Response Time', SPDUnit["responseTime"]),
                      buildListTile('Submitted By', SPDUnit["Submitter"]),
                    ],
                  )
                else
                  Column(
                    children: [
                      buildListTile(
                          'Voltage Protection Level DC', SPDUnit["UpDCVolt"]),
                      buildListTile('Nominal Discharge Current 8/20',
                          SPDUnit["Nom_Dis8_20"]),
                      buildListTile(
                          'Impulse Current 10/350', SPDUnit["Nom_Dis10_350"]),
                      buildListTile('Nominal Voltage Un', SPDUnit["nom_volt"]),
                      buildListTile('Max Continuous Operating Voltage DC',
                          SPDUnit["UcDCVolt"]),
                    ],
                  )
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

//v2
// import 'package:flutter/material.dart';
//
// class ViewSPDUnit extends StatelessWidget {
//   final dynamic SPDUnit;
//
//   ViewSPDUnit({required this.SPDUnit});
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
//         title: Text('SPD Unit Details'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               makeCard(Lesson(
//                   subjectName: 'SPDid',
//                   variable: SPDUnit['SPDid'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'province',
//                   variable: SPDUnit['province'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Rtom_name',
//                   variable: SPDUnit['Rtom_name'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Station',
//                   variable: SPDUnit['station'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'SPD Location',
//                   variable: SPDUnit['SPDLoc'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'DCFlag',
//                   variable: SPDUnit['DCFlag'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: "Poles", variable: SPDUnit["poles"])),
//               makeCard(Lesson(
//                   subjectName: 'SPD Type',
//                   variable: SPDUnit['SPDType'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'SPD Manufacture',
//                   variable: SPDUnit['SPD_Manu'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'SPD Model',
//                   variable: SPDUnit['model_SPD'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Status',
//                   variable: SPDUnit['Status'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'SPD Type',
//                   variable: SPDUnit['SPDType'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'installed Date',
//                   variable: SPDUnit['installDt'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Warranty Date',
//                   variable: SPDUnit['warrentyDt'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Notes',
//                   variable: SPDUnit['Notes'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Response Time',
//                   variable: SPDUnit['responseTime'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Submitter',
//                   variable: SPDUnit['Submitter'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Last Updated',
//                   variable: SPDUnit['LastUpdated'] ?? 'N/A')),
//
//               if (SPDUnit["DCFlag"] == "0")
//                 Column(
//                   children: [
//                     makeCard(Lesson(
//                         subjectName: "modular",
//                         variable: SPDUnit["modular"] ?? 'N/A')),
//                     makeCard(Lesson(
//                         subjectName: "phase",
//                         variable: SPDUnit["phase"] ?? 'N/A')),
//                     makeCard(Lesson(
//                         subjectName:
//                         "Max continuous operating voltage live-type",
//                         variable: SPDUnit["UcLiveMode"] ?? 'N/A')),
//                     makeCard(Lesson(
//                         subjectName:
//                         "Maximum continuous operating voltage live - reading",
//                         variable: SPDUnit["UcLiveVolt"] ?? 'N/A')),
//                     makeCard(Lesson(
//                         subjectName: "Max continuous operating voltage-neutral",
//                         variable: SPDUnit["UcNeutralVolt"] ?? 'N/A')),
//                     // Type the subject name correctly (UpLiveVolt and UpNeutralVolt)
//                     makeCard(Lesson(
//                         subjectName: "UpLiveVolt",
//                         variable: SPDUnit["UpLiveVolt"] ?? 'N/A')),
//                     makeCard(Lesson(
//                         subjectName: "UpNeutralVolt",
//                         variable: SPDUnit["UpNeutralVolt"] ?? 'N/A')),
//                     makeCard(Lesson(
//                         subjectName: "discharge Type",
//                         variable: SPDUnit["dischargeType"] ?? 'N/A')),
//                     makeCard(Lesson(
//                         subjectName: "Line 8 to 20 Nominal Discharge",
//                         variable: SPDUnit["L8to20NomD"] ?? 'N/A')),
//                     makeCard(Lesson(
//                         subjectName: "Neutral 8 to 20 Nominal Discharge",
//                         variable: SPDUnit["N8to20NomD"] ?? 'N/A')),
//                     makeCard(Lesson(
//                         subjectName: "line 10 to 350 impulse discharge",
//                         variable: SPDUnit["L10to350ImpD"] ?? 'N/A')),
//                     makeCard(Lesson(
//                         subjectName: "Neutral 10 to 350 impulse discharge",
//                         variable: SPDUnit["N10to350ImpD"] ?? 'N/A')),
//                     makeCard(Lesson(
//                         subjectName: "MCB Rating",
//                         variable: SPDUnit["mcbRating"] ?? 'N/A')),
//                     makeCard(Lesson(
//                         subjectName: "Response Time",
//                         variable: SPDUnit["responseTime"] ?? 'N/A')),
//                     makeCard(Lesson(
//                         subjectName: "Submitted By",
//                         variable: SPDUnit["Submitter"] ?? 'N/A')),
//                   ],
//                 )
//               else
//                 Column(
//                   children: [
//
//                     makeCard(Lesson(
//                         subjectName: "Voltage Protection Level DC",
//                         variable: SPDUnit["UpDCVolt"] ?? 'N/A')),
//                     makeCard(Lesson(
//                         subjectName: "Nominal Discharge Current 8/20",
//                         variable: SPDUnit["Nom_Dis8_20"] ?? 'N/A')),
//                     makeCard(Lesson(
//                         subjectName: "impulse current 10/350",
//                         variable: SPDUnit["Nom_Dis10_350"] ?? 'N/A')),
//                     makeCard(Lesson(
//                         subjectName: "nominal voltage un",
//                         variable: SPDUnit["nom_volt"] ?? 'N/A')),
//                     makeCard(Lesson(
//                         subjectName: "maximum continuous operating voltage dc",
//                         variable: SPDUnit["UcDCVolt"] ?? 'N/A'))
//                   ],
//                 )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
// class Lesson {
//   final String subjectName;
//   final String variable;
//
//   Lesson({required this.subjectName, required this.variable});
// }
//
//
//
//
