import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/utils/utils/colors.dart';
import 'package:theme_update/utils/utils/colors.dart' as customColors;

class ViewUPSUnit extends StatelessWidget {
  final dynamic UPSUnit;
  final String searchQuery;

  ViewUPSUnit({required this.UPSUnit, this.searchQuery = ''});

  ListTile makeListTile(
    String subjectName,
    String? variable,
    BuildContext context,
  ) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
 // Highlight only the matching part of the variable
    InlineSpan getHighlightedText(String text) {
      if (searchQuery.isEmpty) {
        return TextSpan(
          text: text,
          style: TextStyle(
            color: customColors.subTextColor,
            backgroundColor: customColors.suqarBackgroundColor,
          ),
        );
      }
      final lowerText = text.toLowerCase();
      final lowerQuery = searchQuery.toLowerCase();
      final start = lowerText.indexOf(lowerQuery);
      if (start == -1) {
        return TextSpan(
          text: text,
          style: TextStyle(
            color: customColors.subTextColor,
            backgroundColor: customColors.suqarBackgroundColor,
          ),
        );
      }
      final end = start + lowerQuery.length;
      return TextSpan(
        children: [
          if (start > 0)
            TextSpan(
              text: text.substring(0, start),
              style: TextStyle(
                color: customColors.subTextColor,
                backgroundColor: customColors.suqarBackgroundColor,
              ),
            ),
          TextSpan(
            text: text.substring(start, end),
            style: TextStyle(
              color: customColors.subTextColor,
              backgroundColor: customColors.highlightColor,
            ),
          ),
          if (end < text.length)
            TextSpan(
              text: text.substring(end),
              style: TextStyle(
                color: customColors.subTextColor,
                backgroundColor: customColors.suqarBackgroundColor,
              ),
            ),
        ],
      );
    }

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(width: 1.0, color: customColors.subTextColor),
          ),
        ),
        child: Text(
          subjectName,
          style: TextStyle(
            color: customColors.mainTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      title: Text.rich(
        getHighlightedText(variable ?? 'N/A'),
      ),
    );
  }

  bool _shouldHighlight(String? value) {
    if (value == null || searchQuery.isEmpty) return false;
    return value.toLowerCase().contains(searchQuery.toLowerCase());
  }

  Card makeCard(Lesson lesson, BuildContext context) 
  {     final customColors = Theme.of(context).extension<CustomColors>()!;

  return Card(
    elevation: 8.0,
    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: SizedBox(
      height: 60.0, // Adjust the height value as per your requirements
      child: Container(
        decoration: BoxDecoration(
          color: customColors.suqarBackgroundColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: makeListTile(lesson.subjectName, lesson.variable, context),
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
          "UPS Unit Details",
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
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                makeCard(
                  Lesson(
                    subjectName: 'UPS ID',
                    variable: UPSUnit['upsID'] ?? 'N/A',
                  ),
                   context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'Region',
                    variable: UPSUnit['Region'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'RTOM',
                    variable: UPSUnit['RTOM'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'Station',
                    variable: UPSUnit['Station'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'Brand',
                    variable: UPSUnit['Brand'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'Other Brand',
                    variable: UPSUnit['UPSBrandOther'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'Model',
                    variable: UPSUnit['Model'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'Capacity Units',
                    variable: UPSUnit['UPSCapUnits'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'Capacity',
                    variable: UPSUnit['UPSCap'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'Power Factor',
                    variable: UPSUnit['UPSpf'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'Installed Date',
                    variable: UPSUnit['InstalledDate'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'Type',
                    variable: UPSUnit['Type'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'Power Module Model',
                    variable: UPSUnit['PWModModel'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: "Ampere Rating",
                    variable: UPSUnit["AmpRating"],
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'Power Module Used',
                    variable: UPSUnit['PWModsUsed'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'Power Module Available',
                    variable: UPSUnit['PWModsAvail'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'Control Module Model',
                    variable: UPSUnit['CtrModModel'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'Control Module Used',
                    variable: UPSUnit['CtrModsUsed'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'Control Module Available',
                    variable: UPSUnit['CtrModsAvail'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'acCapuF',
                    // change the subject name since line 178 to line 193
                    variable: UPSUnit['acCapuF'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'acCapVoltage',
                    variable: UPSUnit['acCapVoltage'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'acCapNos',
                    variable: UPSUnit['acCapNos'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'dcCapuF',
                    variable: UPSUnit['dcCapuF'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'dcCapVoltage',
                    variable: UPSUnit['dcCapVoltage'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'dcCapNos',
                    variable: UPSUnit['dcCapNos'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'Last Updated',
                    variable: UPSUnit['lastUpdated'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(subjectName: 'AMC', variable: UPSUnit['AMC'] ?? 'N/A'), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'Supplier Name',
                    variable: UPSUnit['Supplier_Name'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'Supplier Contact Number',
                    variable: UPSUnit['SupContactN'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'Supplier Contact Email Address',
                    variable: UPSUnit['SupContactE'] ?? 'N/A',
                  ), context,
                ),
                makeCard(
                  Lesson(
                    subjectName: 'Updated By',
                    variable: UPSUnit['Updated_By'] ?? 'N/A',
                  ), context,
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



//v3
// import 'package:flutter/material.dart';
//
// import '../../HomePage/utils/colors.dart';
//
// class ViewUPSUnit extends StatelessWidget {
//   final dynamic UPSUnit;
//
//   const ViewUPSUnit({super.key, required this.UPSUnit});
//
//   ListTile makeListTile(String subjectName, String? variable) => ListTile(
//     contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//     leading: Container(
//       padding: EdgeInsets.only(right: 12.0),
//       decoration: BoxDecoration(
//         border: Border(right: BorderSide(width: 1.0, color: Color(0xffD9D9D9))),
//       ),
//       child: Text(
//         subjectName,
//         style: TextStyle(color: Color(0xffFFFFFF), fontWeight: FontWeight.bold),
//       ),
//     ),
//     title: Text(
//       variable ?? 'N/A',
//       style: TextStyle(color: Color(0xffD9D9D9), fontWeight: FontWeight.bold),
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
//           color: Color(0xff212529),
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
//         title: Text("UPS Unit Details", style: TextStyle(color: mainTextColor)),
//         backgroundColor: Color(0xff2B3136),
//       ),
//       body: Container(
//         color: Color(0xff343A40),
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 makeCard(
//                   Lesson(
//                     subjectName: 'UPS ID',
//                     variable: UPSUnit['upsID'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'Region',
//                     variable: UPSUnit['Region'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'RTOM',
//                     variable: UPSUnit['RTOM'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'Station',
//                     variable: UPSUnit['Station'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'Brand',
//                     variable: UPSUnit['Brand'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'Other Brand',
//                     variable: UPSUnit['UPSBrandOther'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'Model',
//                     variable: UPSUnit['Model'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'Capacity Units',
//                     variable: UPSUnit['UPSCapUnits'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'Capacity',
//                     variable: UPSUnit['UPSCap'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'Power Factor',
//                     variable: UPSUnit['UPSpf'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'Installed Date',
//                     variable: UPSUnit['InstalledDate'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'Type',
//                     variable: UPSUnit['Type'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'Power Module Model',
//                     variable: UPSUnit['PWModModel'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: "Ampere Rating",
//                     variable: UPSUnit["AmpRating"],
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'Power Module Used',
//                     variable: UPSUnit['PWModsUsed'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'Power Module Available',
//                     variable: UPSUnit['PWModsAvail'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'Control Module Model',
//                     variable: UPSUnit['CtrModModel'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'Control Module Used',
//                     variable: UPSUnit['CtrModsUsed'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'Control Module Available',
//                     variable: UPSUnit['CtrModsAvail'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'acCapuF',
//                     variable: UPSUnit['acCapuF'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'acCapVoltage',
//                     variable: UPSUnit['acCapVoltage'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'acCapNos',
//                     variable: UPSUnit['acCapNos'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'dcCapuF',
//                     variable: UPSUnit['dcCapuF'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'dcCapVoltage',
//                     variable: UPSUnit['dcCapVoltage'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'dcCapNos',
//                     variable: UPSUnit['dcCapNos'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'Last Updated',
//                     variable: UPSUnit['lastUpdated'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(subjectName: 'AMC', variable: UPSUnit['AMC'] ?? 'N/A'),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'Supplier Name',
//                     variable: UPSUnit['Supplier_Name'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'Supplier Contact Number',
//                     variable: UPSUnit['SupContactN'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'Supplier Contact Email Address',
//                     variable: UPSUnit['SupContactE'] ?? 'N/A',
//                   ),
//                 ),
//                 makeCard(
//                   Lesson(
//                     subjectName: 'Updated By',
//                     variable: UPSUnit['Updated_By'] ?? 'N/A',
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



//v2
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class ViewUPSUnit extends StatelessWidget{
//
//   final dynamic UPSUnit;
//
//   ViewUPSUnit({required this.UPSUnit});
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
//         title: Text("UPS Unit Details"),
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               makeCard(Lesson(
//                   subjectName: 'UPS ID',
//                   variable:UPSUnit['upsID'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Region',
//                   variable:UPSUnit['Region'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'RTOM',
//                   variable:UPSUnit['RTOM'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Station',
//                   variable:UPSUnit['Station'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Brand',
//                   variable: UPSUnit['Brand'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Other Brand',
//                   variable: UPSUnit['UPSBrandOther'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Model',
//                   variable:UPSUnit['Model'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Capacity Units',
//                   variable:UPSUnit['UPSCapUnits'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Capacity',
//                   variable:UPSUnit['UPSCap'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Power Factor',
//                   variable:UPSUnit['UPSpf'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Installed Date',
//                   variable:UPSUnit['InstalledDate'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Type',
//                   variable:UPSUnit['Type'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Power Module Model',
//                   variable:UPSUnit['PWModModel'] ?? 'N/A')),
//               makeCard(Lesson(subjectName: "Ampere Rating", variable: UPSUnit["AmpRating"])),
//               makeCard(Lesson(
//                   subjectName: 'Power Module Used',
//                   variable:UPSUnit['PWModsUsed'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Power Module Available',
//                   variable:UPSUnit['PWModsAvail'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Control Module Model',
//                   variable:UPSUnit['CtrModModel'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Control Module Used',
//                   variable:UPSUnit['CtrModsUsed'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Control Module Available',
//                   variable:UPSUnit['CtrModsAvail'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'acCapuF', // change the subject name since line 178 to line 193
//                   variable:UPSUnit['acCapuF'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'acCapVoltage',
//                   variable:UPSUnit['acCapVoltage'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'acCapNos',
//                   variable:UPSUnit['acCapNos'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'dcCapuF',
//                   variable:UPSUnit['dcCapuF'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'dcCapVoltage',
//                   variable:UPSUnit['dcCapVoltage'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'dcCapNos',
//                   variable:UPSUnit['dcCapNos'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Last Updated',
//                   variable:UPSUnit['lastUpdated'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'AMC',
//                   variable:UPSUnit['AMC'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Supplier Name',
//                   variable:UPSUnit['Supplier_Name'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Supplier Contact Number',
//                   variable:UPSUnit['SupContactN'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Supplier Contact Email Address',
//                   variable:UPSUnit['SupContactE'] ?? 'N/A')),
//               makeCard(Lesson(
//                   subjectName: 'Updated By',
//                   variable:UPSUnit['Updated_By'] ?? 'N/A')),
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
//



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
