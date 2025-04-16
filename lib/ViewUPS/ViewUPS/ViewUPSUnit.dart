import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/utils/colors.dart';

class ViewUPSUnit extends StatelessWidget {
  final dynamic UPSUnit;
  final String searchQuery;

  ViewUPSUnit({required this.UPSUnit, this.searchQuery = ''});

  ListTile makeListTile(String subjectName, String? variable) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1.0, color: subTextColor),
            ),
          ),
          child: Text(
            subjectName,
            style: TextStyle(color: mainTextColor, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          variable ?? 'N/A',
          style: TextStyle(
              color: subTextColor,
              fontWeight: FontWeight.bold,
              backgroundColor: _shouldHighlight(variable)
                  ? highlightColor
                  : Colors.transparent),
        ),
      );

  bool _shouldHighlight(String? value) {
    if (value == null || searchQuery.isEmpty) return false;
    return value.toLowerCase().contains(searchQuery.toLowerCase());
  }

  Card makeCard(Lesson lesson) => Card(
        elevation: 8.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: SizedBox(
          height: 60.0, // Adjust the height value as per your requirements
          child: Container(
            decoration: BoxDecoration(
              color: suqarBackgroundColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: makeListTile(lesson.subjectName, lesson.variable),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "UPS Unit Details",
          style: TextStyle(color: mainTextColor),
        ),
        iconTheme: IconThemeData(
          color: mainTextColor,
        ),
        backgroundColor: appbarColor,
      ),
      body: Container(
        color: mainBackgroundColor,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                makeCard(Lesson(
                    subjectName: 'UPS ID',
                    variable: UPSUnit['upsID'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'Region',
                    variable: UPSUnit['Region'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'RTOM', variable: UPSUnit['RTOM'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'Station',
                    variable: UPSUnit['Station'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'Brand', variable: UPSUnit['Brand'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'Other Brand',
                    variable: UPSUnit['UPSBrandOther'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'Model', variable: UPSUnit['Model'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'Capacity Units',
                    variable: UPSUnit['UPSCapUnits'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'Capacity',
                    variable: UPSUnit['UPSCap'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'Power Factor',
                    variable: UPSUnit['UPSpf'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'Installed Date',
                    variable: UPSUnit['InstalledDate'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'Type', variable: UPSUnit['Type'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'Power Module Model',
                    variable: UPSUnit['PWModModel'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: "Ampere Rating",
                    variable: UPSUnit["AmpRating"])),
                makeCard(Lesson(
                    subjectName: 'Power Module Used',
                    variable: UPSUnit['PWModsUsed'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'Power Module Available',
                    variable: UPSUnit['PWModsAvail'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'Control Module Model',
                    variable: UPSUnit['CtrModModel'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'Control Module Used',
                    variable: UPSUnit['CtrModsUsed'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'Control Module Available',
                    variable: UPSUnit['CtrModsAvail'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'acCapuF',
                    // change the subject name since line 178 to line 193
                    variable: UPSUnit['acCapuF'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'acCapVoltage',
                    variable: UPSUnit['acCapVoltage'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'acCapNos',
                    variable: UPSUnit['acCapNos'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'dcCapuF',
                    variable: UPSUnit['dcCapuF'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'dcCapVoltage',
                    variable: UPSUnit['dcCapVoltage'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'dcCapNos',
                    variable: UPSUnit['dcCapNos'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'Last Updated',
                    variable: UPSUnit['lastUpdated'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'AMC', variable: UPSUnit['AMC'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'Supplier Name',
                    variable: UPSUnit['Supplier_Name'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'Supplier Contact Number',
                    variable: UPSUnit['SupContactN'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'Supplier Contact Email Address',
                    variable: UPSUnit['SupContactE'] ?? 'N/A')),
                makeCard(Lesson(
                    subjectName: 'Updated By',
                    variable: UPSUnit['Updated_By'] ?? 'N/A')),
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

//v1
// import 'package:flutter/material.dart';
//
// class ViewUPSUnit extends StatelessWidget {
//   final dynamic UPSUnit;
//
//   ViewUPSUnit({required this.UPSUnit});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('UPS Unit Details'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'UPS ID: ${UPSUnit['upsID']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Region: ${UPSUnit['Region']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Site: ${UPSUnit['RTOM']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Station: ${UPSUnit['Station']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Brand: ${UPSUnit['Brand']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Brand (if Other): ${UPSUnit['UPSBrandOther']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Model: ${UPSUnit['Model']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//
//               Text(
//                 'UPS Capacity: ${UPSUnit['UPSCap']}${UPSUnit['UPSCapUnits']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'UPS Type: ${UPSUnit['Type']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Serial of The UPS: ${UPSUnit['Serial']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Date of Install: ${UPSUnit['InstalledDate']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'UPS Type: ${UPSUnit['Type']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Power Module Model: ${UPSUnit['PWModModel']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Power Module Slots: ${UPSUnit['PWModsAvail']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Power Modules Available: ${UPSUnit['PWModsUsed']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Control Module Model: ${UPSUnit['CtrModModel']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Control Module Slots: ${UPSUnit['CtrModsAvail']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Control Modules Available: ${UPSUnit['CtrModsUsed']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//
//
//
//               Text(
//                 'AC capacitors Capacitance: ${UPSUnit['acCapuF']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'AC Capacitance Voltage: ${UPSUnit['acCapNos']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'AC Capacitor Quantity: ${UPSUnit['acCapNos']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'DC Capacitors Capacitance (uF): ${UPSUnit['dcCapuF']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'DC Capacitor Voltage (V): ${UPSUnit['dcCapVoltage']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'DC Capacitor Quantity: ${UPSUnit['dcCapNos']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//
//
//
//
//
//
//
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
