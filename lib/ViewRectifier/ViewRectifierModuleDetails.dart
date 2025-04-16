import 'package:flutter/material.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/utils/utils/colors.dart';

class ViewRectifierModuleDetails extends StatelessWidget {
  final dynamic RectifierUnit;
  final String searchQuery;

  ViewRectifierModuleDetails({
    required this.RectifierUnit,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
        final customColors = Theme.of(context).extension<CustomColors>()!;

    List<DataRow> buildModuleRows(List<String> keys) {
      List<DataRow> rows = [];
      for (var i = 0; i < keys.length; i++) {
        var key = keys[i];
        var value = RectifierUnit[key];
        if (value != null && value != 'null' && value.toString().trim().isNotEmpty) {
          final bool isMatch = searchQuery.isNotEmpty &&
              value.toString().toLowerCase().contains(searchQuery.toLowerCase());

          rows.add(
            DataRow(
              color: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (isMatch) return highlightColor;
                  return null;
                },
              ),
              cells: [
                DataCell(Text('Module ${i + 1}')),
                DataCell(Text(
                  value.toString(),
                  style: TextStyle(
                    color: customColors.subTextColor,
                    backgroundColor: isMatch ? highlightColor : null,
                  ),
                )),
              ],
            ),
          );
        }
      }
      return rows;
    }

    return Scaffold(
      appBar: AppBar(
        title:  Text('Rectifier Unit Details',style: TextStyle(color: customColors.mainTextColor),),
        backgroundColor: customColors.appbarColor,
        iconTheme:  IconThemeData(color: customColors.mainTextColor),
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],

      ),
      body: Container(
        color: customColors.mainBackgroundColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rectifier ID: ${RectifierUnit['RecID']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),

                // Power Modules Table
                const Center(
                  child: Text(
                    'Power Modules',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text(
                        'Module',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Serial',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                  rows: buildModuleRows([
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
                    'PW_Serial_11',
                    'PW_Serial_12',
                    'PW_Serial_13',
                    'PW_Serial_14',
                    'PW_Serial_15',
                    'PW_Serial_16',
                    'PW_Serial_17',
                    'PW_Serial_18',
                    'PW_Serial_19',
                    'PW_Serial_20',
                  ]),
                ),

                // Control Modules Table
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Control Modules',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text(
                        'Module',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Serial',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                  rows: buildModuleRows([
                    'Ctr_Serial_1',
                    'Ctr_Serial_2',
                    'Ctr_Serial_3',
                    'Ctr_Serial_4',
                    'Ctr_Serial_5',
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



//v3
// import 'package:flutter/material.dart';
//
// class ViewRectifierModuleDetails extends StatelessWidget {
//   final dynamic RectifierUnit;
//
//   ViewRectifierModuleDetails({required this.RectifierUnit});
//
//   @override
//   Widget build(BuildContext context) {
//     List<DataRow> buildModuleRows(List<String> keys) {
//       List<DataRow> rows = [];
//       for (var i = 0; i < keys.length; i++) {
//         var key = keys[i];
//         var value = RectifierUnit[key];
//         if (value != null && value != 'null' && value.toString().trim().isNotEmpty) {
//           rows.add(
//             DataRow(
//               cells: [
//                 DataCell(Text('Module ${i + 1}')),
//                 DataCell(Text(value.toString())),
//               ],
//             ),
//           );
//         }
//       }
//       return rows;
//     }
//
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
//                 style: TextStyle(fontSize: 16),
//               ),
//               SizedBox(height: 10),
//
//               // Power Modules Table
//               Center(
//                 child: Text(
//                   'Power Modules',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),
//               DataTable(
//                 columns: const <DataColumn>[
//                   DataColumn(
//                     label: Text(
//                       'Module',
//                       style: TextStyle(fontStyle: FontStyle.italic),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Text(
//                       'Serial',
//                       style: TextStyle(fontStyle: FontStyle.italic),
//                     ),
//                   ),
//                 ],
//                 rows: buildModuleRows([
//                   'PW_Serial_1',
//                   'PW_Serial_2',
//                   'PW_Serial_3',
//                   'PW_Serial_4',
//                   'PW_Serial_5',
//                   'PW_Serial_6',
//                   'PW_Serial_7',
//                   'PW_Serial_8',
//                   'PW_Serial_9',
//                   'PW_Serial_10',
//                   'PW_Serial_11',
//                   'PW_Serial_12',
//                   'PW_Serial_13',
//                   'PW_Serial_14',
//                   'PW_Serial_15',
//                   'PW_Serial_16',
//                   'PW_Serial_17',
//                   'PW_Serial_18',
//                   'PW_Serial_19',
//                   'PW_Serial_20',
//                 ]),
//               ),
//
//               // Control Modules Table
//               SizedBox(height: 20),
//               Center(
//                 child: Text(
//                   'Control Modules',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),
//               DataTable(
//                 columns: const <DataColumn>[
//                   DataColumn(
//                     label: Text(
//                       'Module',
//                       style: TextStyle(fontStyle: FontStyle.italic),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Text(
//                       'Serial',
//                       style: TextStyle(fontStyle: FontStyle.italic),
//                     ),
//                   ),
//                 ],
//                 rows: buildModuleRows([
//                   'Ctr_Serial_1',
//                   'Ctr_Serial_2',
//                   'Ctr_Serial_3',
//                   'Ctr_Serial_4',
//                   'Ctr_Serial_5',
//                 ]),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//


//v2 working
// import 'package:flutter/material.dart';
//
// class ViewRectifierModuleDetails extends StatelessWidget {
//   final dynamic RectifierUnit;
//
//   ViewRectifierModuleDetails({required this.RectifierUnit});
//
//   @override
//   Widget build(BuildContext context) {
//     List<Widget> buildModuleDetails(String title, List<String> keys) {
//       List<Widget> modules = [];
//       for (var key in keys) {
//         var value = RectifierUnit[key];
//         if (value != null && value != 'null' && value.toString().trim().isNotEmpty) {
//           modules.add(
//             Text(
//               '$key: $value',
//               style: TextStyle(fontSize: 16),
//             ),
//           );
//           modules.add(SizedBox(height: 10));
//         }
//       }
//       if (modules.isNotEmpty) {
//         modules.insert(
//           0,
//           Center(
//             child: Text(
//               title,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         );
//         modules.insert(1, SizedBox(height: 10));
//       }
//       return modules;
//     }
//
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
//                 style: TextStyle(fontSize: 16),
//               ),
//               SizedBox(height: 10),
//
//               // Power Modules
//               ...buildModuleDetails('Power Modules', [
//                 'PW_Serial_1',
//                 'PW_Serial_2',
//                 'PW_Serial_3',
//                 'PW_Serial_4',
//                 'PW_Serial_5',
//                 'PW_Serial_6',
//                 'PW_Serial_7',
//                 'PW_Serial_8',
//                 'PW_Serial_9',
//                 'PW_Serial_10',
//                 'PW_Serial_11',
//                 'PW_Serial_12',
//                 'PW_Serial_13',
//                 'PW_Serial_14',
//                 'PW_Serial_15',
//                 'PW_Serial_16',
//                 'PW_Serial_17',
//                 'PW_Serial_18',
//                 'PW_Serial_19',
//                 'PW_Serial_20',
//               ]),
//
//               // Control Modules
//               ...buildModuleDetails('Control Modules', [
//                 'Ctr_Serial_1',
//                 'Ctr_Serial_2',
//                 'Ctr_Serial_3',
//                 'Ctr_Serial_4',
//                 'Ctr_Serial_5',
//               ]),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


//v1 working
// import 'package:flutter/material.dart';
//
// class ViewRectifierModuleDetails extends StatelessWidget {
//   final dynamic RectifierUnit;
//
//   ViewRectifierModuleDetails({required this.RectifierUnit});
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
//
//               Center(
//                 child: Text(
//                   'Power Modules',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//
//               Text(
//                 'PW_Serial_1: ${RectifierUnit['PW_Serial_1']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'PW_Serial_2: ${RectifierUnit['PW_Serial_2']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'PW_Serial_3: ${RectifierUnit['PW_Serial_3']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'PW_Serial_4: ${RectifierUnit['PW_Serial_4']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'PW_Serial_5: ${RectifierUnit['PW_Serial_5']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//
//               Text(
//                 'PW_Serial_6: ${RectifierUnit['PW_Serial_6']}${RectifierUnit['FrameCapType']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'PW_Serial_7: ${RectifierUnit['PW_Serial_7']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'PW_Serial_8: ${RectifierUnit['PW_Serial_8']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'PW_Serial_9: ${RectifierUnit['PW_Serial_9']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'PW_Serial_10: ${RectifierUnit['PW_Serial_10']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'PW_Serial_11: ${RectifierUnit['PW_Serial_11']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'PW_Serial_12: ${RectifierUnit['PW_Serial_12']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'PW_Serial_13: ${RectifierUnit['PW_Serial_13']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'PW_Serial_14: ${RectifierUnit['PW_Serial_14']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'PW_Serial_15: ${RectifierUnit['PW_Serial_15']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'PW_Serial_16: ${RectifierUnit['PW_Serial_16']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'PW_Serial_17: ${RectifierUnit['PW_Serial_17']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'PW_Serial_18: ${RectifierUnit['PW_Serial_18']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'PW_Serial_19: ${RectifierUnit['PW_Serial_19']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'PW_Serial_20: ${RectifierUnit['PW_Serial_20']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//
//               Center(
//                 child: Text(
//                   'Control Modules',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//
//
//               SizedBox(height: 10),
//               Text(
//                 'Ctr_Serial_1: ${RectifierUnit['Ctr_Serial_1']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Ctr_Serial_2: ${RectifierUnit['Ctr_Serial_2']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Ctr_Serial_3: ${RectifierUnit['Ctr_Serial_3']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Ctr_Serial_4: ${RectifierUnit['Ctr_Serial_4']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Ctr_Serial_5: ${RectifierUnit['Ctr_Serial_5']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 10),
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
