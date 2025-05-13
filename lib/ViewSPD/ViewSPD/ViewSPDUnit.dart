import 'package:flutter/material.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';

import '../../utils/utils/colors.dart';

class ViewSPDUnit extends StatelessWidget {
  final dynamic SPDUnit;
  final String searchQuery;
  InlineSpan getHighlightedText(
    String text,
    String searchQuery,
    Color textColor,
    Color highlightColor,
  ) {
    if (searchQuery.isEmpty || text.isEmpty) {
      return TextSpan(
        text: text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      );
    }
    final lowerText = text.toLowerCase();
    final lowerQuery = searchQuery.toLowerCase();
    final start = lowerText.indexOf(lowerQuery);
    if (start == -1) {
      return TextSpan(
        text: text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      );
    }
    final end = start + lowerQuery.length;
    return TextSpan(
      children: [
        if (start > 0)
          TextSpan(
            text: text.substring(0, start),
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
        TextSpan(
          text: text.substring(start, end),
          style: TextStyle(
            color: textColor,
            backgroundColor: highlightColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (end < text.length)
          TextSpan(
            text: text.substring(end),
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
      ],
    );
  }

  ViewSPDUnit({required this.SPDUnit, this.searchQuery = ''});

  Widget buildListTile(String title, String? value, BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: customColors.suqarBackgroundColor, // Always normal background
        boxShadow: [
          BoxShadow(
            color: customColors.subTextColor,
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Icon(Icons.info_outline, color: customColors.subTextColor),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: customColors.mainTextColor,
            fontSize: 16,
          ),
        ),
        subtitle: Text.rich(
          getHighlightedText(
            value ?? 'N/A',
            searchQuery,
            customColors.subTextColor,
            customColors.highlightColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SPD Unit Details',
          style: TextStyle(color: customColors.mainTextColor),
        ),
        iconTheme: IconThemeData(color: customColors.mainTextColor),
        backgroundColor: customColors.appbarColor,
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: customColors.mainBackgroundColor),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // SPD Unit details, dynamically rendered
                buildListTile('SPDid', SPDUnit['SPDid'], context),
                buildListTile('Province', SPDUnit['province'], context),
                buildListTile('Rtom_name', SPDUnit['Rtom_name'], context),
                buildListTile('Station', SPDUnit['station'], context),
                buildListTile('SPD Location', SPDUnit['SPDLoc'], context),
                buildListTile('DCFlag', SPDUnit['DCFlag'], context),
                buildListTile('Poles', SPDUnit['poles'], context),
                buildListTile('SPD Type', SPDUnit['SPDType'], context),
                buildListTile('SPD Manufacture', SPDUnit['SPD_Manu'], context),
                buildListTile('SPD Model', SPDUnit['model_SPD'], context),
                buildListTile('Status', SPDUnit['Status'], context),
                buildListTile('Installed Date', SPDUnit['installDt'], context),
                buildListTile('Warranty Date', SPDUnit['warrentyDt'], context),
                buildListTile('Notes', SPDUnit['Notes'], context),
                buildListTile(
                  'Response Time',
                  SPDUnit['responseTime'],
                  context,
                ),
                buildListTile('Submitter', SPDUnit['Submitter'], context),
                buildListTile('Last Updated', SPDUnit['LastUpdated'], context),

                // Additional details based on DCFlag
                if (SPDUnit["DCFlag"] == "0")
                  Column(
                    children: [
                      buildListTile('Modular', SPDUnit["modular"], context),
                      buildListTile('Phase', SPDUnit["phase"], context),
                      buildListTile(
                        'Max continuous operating voltage live-type',
                        SPDUnit["UcLiveMode"],
                        context,
                      ),
                      buildListTile(
                        'Max continuous operating voltage live - reading',
                        SPDUnit["UcLiveVolt"],
                        context,
                      ),
                      buildListTile(
                        'Max continuous operating voltage-neutral',
                        SPDUnit["UcNeutralVolt"],
                        context,
                      ),
                      buildListTile(
                        'UpLiveVolt',
                        SPDUnit["UpLiveVolt"],
                        context,
                      ),
                      buildListTile(
                        'UpNeutralVolt',
                        SPDUnit["UpNeutralVolt"],
                        context,
                      ),
                      buildListTile(
                        'Discharge Type',
                        SPDUnit["dischargeType"],
                        context,
                      ),
                      buildListTile(
                        'Line 8 to 20 Nominal Discharge',
                        SPDUnit["L8to20NomD"],
                        context,
                      ),
                      buildListTile(
                        'Neutral 8 to 20 Nominal Discharge',
                        SPDUnit["N8to20NomD"],
                        context,
                      ),
                      buildListTile(
                        'Line 10 to 350 Impulse Discharge',
                        SPDUnit["L10to350ImpD"],
                        context,
                      ),
                      buildListTile(
                        'Neutral 10 to 350 Impulse Discharge',
                        SPDUnit["N10to350ImpD"],
                        context,
                      ),
                      buildListTile(
                        'MCB Rating',
                        SPDUnit["mcbRating"],
                        context,
                      ),
                      buildListTile(
                        'Response Time',
                        SPDUnit["responseTime"],
                        context,
                      ),
                      buildListTile(
                        'Submitted By',
                        SPDUnit["Submitter"],
                        context,
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      buildListTile(
                        'Voltage Protection Level DC',
                        SPDUnit["UpDCVolt"],
                        context,
                      ),
                      buildListTile(
                        'Nominal Discharge Current 8/20',
                        SPDUnit["Nom_Dis8_20"],
                        context,
                      ),
                      buildListTile(
                        'Impulse Current 10/350',
                        SPDUnit["Nom_Dis10_350"],
                        context,
                      ),
                      buildListTile(
                        'Nominal Voltage Un',
                        SPDUnit["nom_volt"],
                        context,
                      ),
                      buildListTile(
                        'Max Continuous Operating Voltage DC',
                        SPDUnit["UcDCVolt"],
                        context,
                      ),
                    ],
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
