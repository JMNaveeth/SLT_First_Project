import 'package:flutter/material.dart';
import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/utils/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:theme_update/utils/utils/colors.dart' as customColors;
import '../../theme_provider.dart';

class TransformerDetailScreen extends StatefulWidget {
  final Map<String, dynamic> transformerData;
  final String searchQuery;

  TransformerDetailScreen({
    required this.transformerData,
    this.searchQuery = '',
  });

  @override
  _TransformerDetailScreenState createState() =>
      _TransformerDetailScreenState();
}

class _TransformerDetailScreenState extends State<TransformerDetailScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  InlineSpan getHighlightedText(
    String text,
    String searchQuery,
    Color textColor,
    Color highlightColor,
  ) {
    if (searchQuery.isEmpty || text.isEmpty) {
      return TextSpan(
        text: text,
        style: TextStyle(color: textColor, fontSize: 16),
      );
    }
    final lowerText = text.toLowerCase();
    final lowerQuery = searchQuery.toLowerCase();
    final start = lowerText.indexOf(lowerQuery);
    if (start == -1) {
      return TextSpan(
        text: text,
        style: TextStyle(color: textColor, fontSize: 16),
      );
    }
    final end = start + lowerQuery.length;
    return TextSpan(
      children: [
        if (start > 0)
          TextSpan(
            text: text.substring(0, start),
            style: TextStyle(color: textColor, fontSize: 16),
          ),
        TextSpan(
          text: text.substring(start, end),
          style: TextStyle(
            color: textColor,
            backgroundColor: highlightColor,
            fontSize: 16,
          ),
        ),
        if (end < text.length)
          TextSpan(
            text: text.substring(end),
            style: TextStyle(color: textColor, fontSize: 16),
          ),
      ],
    );
  }

  Widget buildDetailContainer(String title, dynamic detail) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    bool isEmail = title == 'Supplier Email';
    bool isPhone = title == 'Supplier Contact';

    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      color: customColors.suqarBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title:   ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: customColors.mainTextColor,
              ),
            ),
            Expanded(
              child:
                  (isEmail || isPhone) && detail != null
                      ? GestureDetector(
                        onTap: () async {
                          if (isEmail) {
                            final Uri emailUri = Uri(
                              scheme: 'mailto',
                              path: detail.toString(),
                            );
                            if (await canLaunchUrl(emailUri)) {
                              await launchUrl(emailUri);
                            }
                          } else if (isPhone) {
                            final Uri telUri = Uri(
                              scheme: 'tel',
                              path: detail.toString(),
                            );
                            if (await canLaunchUrl(telUri)) {
                              await launchUrl(telUri);
                            }
                          }
                        },
                        child: Text.rich(
                          getHighlightedText(
                            detail.toString(),
                            widget.searchQuery,
                            Colors.blue,
                            customColors.hinttColor,
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      )
                      : Text.rich(
                        getHighlightedText(
                          detail != null ? detail.toString() : 'N/A',
                          widget.searchQuery,
                          customColors.subTextColor,
                          customColors.hinttColor,
                        ),
                        style: TextStyle(fontSize: 16),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    final transformerType =
        widget.transformerData['TransformerType']; // transformer type to check
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transformer Details',
          style: TextStyle(
            color: customColors.mainTextColor,
            fontFamily: 'outfit',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: customColors.appbarColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: customColors.mainTextColor),
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),

      body: Container(
        color: customColors.mainBackgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDetailContainer(
                'Transformer ID',
                widget.transformerData['Transforme_ID'],
              ),
              const SizedBox(height: 16),
              buildDetailContainer('QR Tag', widget.transformerData['qrTag']),
              const SizedBox(height: 16),
              Text(
                'Location Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: customColors.mainTextColor,
                ),
              ),
              buildDetailContainer('Region', widget.transformerData['Region']),
              buildDetailContainer('RTOM', widget.transformerData['RTOM']),
              buildDetailContainer(
                'Station',
                widget.transformerData['Station'],
              ),
              buildDetailContainer(
                'Location Latitude',
                widget.transformerData['LocationLatitude'],
              ),
              buildDetailContainer(
                'Location Longitude',
                widget.transformerData['LocationLongitude'],
              ),
              const SizedBox(height: 16),
              Text(
                'Owner Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: customColors.mainTextColor,
                ),
              ),
              buildDetailContainer('Owner', widget.transformerData['Owner']),
              const SizedBox(height: 16),
              Text(
                'General Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: customColors.mainTextColor,
                ),
              ),
              buildDetailContainer(
                'Transformer Type',
                widget.transformerData['TransformerType'],
              ),
              buildDetailContainer(
                'Manufacturer',
                widget.transformerData['Manufacturer'],
              ),
              buildDetailContainer(
                'Installation Date',
                widget.transformerData['InstallationDate'],
              ),
              buildDetailContainer(
                'Last Maintenance Date',
                widget.transformerData['LastMaintenanceDate'],
              ),

              // Fields specific to Oil Type Transformers
              if (transformerType == 'Oil-Type') ...[
                const SizedBox(height: 16),
                Text(
                  'Oil-Type Specific Fields',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: customColors.mainTextColor,
                  ),
                ),
                buildDetailContainer(
                  'Oil Level',
                  widget.transformerData['OilLevel'],
                ),
                buildDetailContainer(
                  'Oil Type',
                  widget.transformerData['OilType'],
                ),
                Text(
                  'Ratings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: customColors.mainTextColor,
                  ),
                ),
                buildDetailContainer(
                  'Capacity',
                  widget.transformerData['Capacity'],
                ),
                buildDetailContainer(
                  'Voltage Level Primary',
                  widget.transformerData['VoltageLevelPrimary'],
                ),
                buildDetailContainer(
                  'Voltage Level Secondary',
                  widget.transformerData['VoltageLevelSecondary'],
                ),
                buildDetailContainer(
                  'Rated Frequency (Hz)',
                  widget.transformerData['Rated_Frequency'],
                ),
                buildDetailContainer(
                  'Rated Current Primary (A)',
                  widget.transformerData['Rated_Current_Primary'],
                ),
                buildDetailContainer(
                  'Rated Current Secondary (A)',
                  widget.transformerData['Rated_Current_Secondary'],
                ),
                const SizedBox(height: 16),
                Text(
                  'Test Values',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: customColors.mainTextColor,
                  ),
                ),
                buildDetailContainer(
                  'LI Withstand (kV)',
                  widget.transformerData['LI_Withstand'],
                ),
                buildDetailContainer(
                  'AC Withstand (kV)',
                  widget.transformerData['AC_Withstand'],
                ),
                buildDetailContainer(
                  'Insulation Levels - Oil (kV)',
                  widget.transformerData['Insulation_Level_Oil'],
                ),
                buildDetailContainer(
                  'Insulation Levels -  Winding (kV)',
                  widget.transformerData['Insulation_Level_Winding'],
                ),
                buildDetailContainer(
                  'Actual Oil Temperature',
                  widget.transformerData['Actual_Oil_Temperature'],
                ),
                buildDetailContainer(
                  'Excitation Current (A)',
                  widget.transformerData['Excitation_Current'],
                ),
                Text(
                  'Physical Characteristics',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: customColors.mainTextColor,
                  ),
                ),
                buildDetailContainer(
                  'Tap Position',
                  widget.transformerData['Tap_Position'],
                ),
                buildDetailContainer(
                  'Total Mass (kg)',
                  widget.transformerData['Total_Mass'],
                ),
                buildDetailContainer(
                  'Serial No',
                  widget.transformerData['Serial_No'],
                ),
                buildDetailContainer(
                  'Manufacturing Date',
                  widget.transformerData['Manufacturing_Date'],
                ),
              ],

              // Fields specific to Dry Type Transformers
              if (transformerType == 'Dry-Type') ...[
                const SizedBox(height: 16),
                Text(
                  'General Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: customColors.mainTextColor,
                  ),
                ),
                buildDetailContainer('Phase', widget.transformerData['Phase']),
                buildDetailContainer(
                  'Frequency (Hz)',
                  widget.transformerData['Frequency'],
                ),
                const SizedBox(height: 16),
                Text(
                  'Ratings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: customColors.mainTextColor,
                  ),
                ),
                buildDetailContainer(
                  'Capacity (Rated Power) (kVA)',
                  widget.transformerData['Capacity'],
                ),
                buildDetailContainer(
                  'Rated HV Current (A)',
                  widget.transformerData['Rated_HV_Current'],
                ),
                buildDetailContainer(
                  'Rated LV Current (A)',
                  widget.transformerData['Rated_HV_Current'],
                ),
                buildDetailContainer(
                  'Type of Cooling',
                  widget.transformerData['Cooling_Type'],
                ),
                buildDetailContainer(
                  'Vector Group',
                  widget.transformerData['Vector_Group'],
                ),
                const SizedBox(height: 16),
                Text(
                  'Test Values',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: customColors.mainTextColor,
                  ),
                ),
                buildDetailContainer(
                  'LI Withstand (kV)',
                  widget.transformerData['LI_Withstand'],
                ),
                buildDetailContainer(
                  'AC Withstand (kV)',
                  widget.transformerData['AC_Withstand'],
                ),
                buildDetailContainer(
                  'Insulation Class',
                  widget.transformerData['Insulation_Class'],
                ),
                buildDetailContainer(
                  'Insulation Material',
                  widget.transformerData['InsulationMaterial'],
                ),
                buildDetailContainer(
                  'Temperature Rise (°C)',
                  widget.transformerData['Temperature_Rise'],
                ),
                buildDetailContainer(
                  'Winding Material',
                  widget.transformerData['Winding_Material'],
                ),
                buildDetailContainer(
                  'C/E/F Class',
                  widget.transformerData['class'],
                ),
                const SizedBox(height: 16),
                Text(
                  'Physical Characteristics',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: customColors.mainTextColor,
                  ),
                ),
                buildDetailContainer(
                  'IP Code of Enclosure',
                  widget.transformerData['IP_Enclosure'],
                ),
                buildDetailContainer(
                  'Total Weight (kg)',
                  widget.transformerData['Total_Weight'],
                ),
                const SizedBox(height: 16),
                Text(
                  'Other Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: customColors.mainTextColor,
                  ),
                ),
                buildDetailContainer(
                  'Manufacturing No.',
                  widget.transformerData['Manufacturing_No'],
                ),
                buildDetailContainer(
                  'Manufacturing Date',
                  widget.transformerData['Manufacturing_Date'],
                ),
                buildDetailContainer(
                  'Applied Standard',
                  widget.transformerData['Applied_Standard'],
                ),
              ],

              const SizedBox(height: 16),
              Text(
                'Operating Conditions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: customColors.mainTextColor,
                ),
              ),
              buildDetailContainer(
                'Winding Temperature',
                widget.transformerData['WindingTemperature'],
              ),
              buildDetailContainer(
                'Ambient Temperature',
                widget.transformerData['AmbientTemperature'],
              ),
              buildDetailContainer(
                'Operating Status',
                widget.transformerData['OperatingStatus'],
              ),
              buildDetailContainer(
                'Load Current',
                widget.transformerData['LoadCurrent'],
              ),
              buildDetailContainer(
                'Load Current Measured Date',
                widget.transformerData['LoadCurrentDate'],
              ),
              buildDetailContainer(
                'Energy Consumption',
                widget.transformerData['EnergyConsumption'],
              ),
              buildDetailContainer(
                'Energy Consumption Date',
                widget.transformerData['EnergyConsumptionDate'],
              ),
              const SizedBox(height: 16),
              Text(
                'Service and Maintenance Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: customColors.mainTextColor,
                ),
              ),
              buildDetailContainer(
                'Service Provider',
                widget.transformerData['ServiceProvider'],
              ),
              buildDetailContainer(
                'AMC Available',
                widget.transformerData['AMCAvailable'],
              ),
              buildDetailContainer(
                'Supplier Contact',
                widget.transformerData['SupplierContact'],
              ),
              buildDetailContainer(
                'Supplier Email',
                widget.transformerData['SupplierEmail'],
              ),
              buildDetailContainer(
                'Remarks',
                widget.transformerData['Remarks'],
              ),
              const SizedBox(height: 16),
              Text(
                'Other Information',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: customColors.mainTextColor,
                ),
              ),
              buildDetailContainer(
                'Uploaded By',
                widget.transformerData['uploadedBy'],
              ),
              buildDetailContainer(
                'Uploaded Time',
                widget.transformerData['uploadedTime'],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//v3
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class TransformerDetailScreen extends StatefulWidget {
//   final Map<String, dynamic> transformerData;
//
//   TransformerDetailScreen({required this.transformerData});
//
//   @override
//   _TransformerDetailScreenState createState() =>
//       _TransformerDetailScreenState();
// }
//
// class _TransformerDetailScreenState extends State<TransformerDetailScreen> {
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   Widget buildDetailContainer(String title, dynamic detail) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       padding: const EdgeInsets.all(12.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '$title:   ',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//               color: Colors.indigo[900],
//             ),
//           ),
//           Expanded(
//             child: GestureDetector(
//               onTap: () async {
//                 if (title == 'Supplier Email' && detail != null) {
//                   // Open email app
//                   final Uri emailUri = Uri(
//                     scheme: 'mailto',
//                     path: detail.toString(),
//                   );
//                   if (await canLaunchUrl(emailUri)) {
//                     await launchUrl(emailUri);
//                   } else {
//                     // Handle error
//                     print('Could not launch email app');
//                     print('Could not launch email app. URI: $emailUri');
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content:
//                         Text('No email app found! Please install one.'),
//                       ),
//                     );
//                   }
//                 } else if (title == 'Supplier Contact' && detail != null) {
//                   // Open dialer
//                   final Uri phoneUri = Uri(
//                     scheme: 'tel',
//                     path: detail.toString(),
//                   );
//                   if (await canLaunchUrl(phoneUri)) {
//                     await launchUrl(phoneUri);
//                   } else {
//                     // Handle error
//                     print('Could not launch phone dialer');
//                     print('Could not launch phone dialer. URI: $phoneUri');
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content:
//                         Text('No phone app found! Please install one.'),
//                       ),
//                     );
//                   }
//                 }
//               },
//               child: Text(
//                 detail != null ? detail.toString() : 'N/A',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color:
//                   title == 'Supplier Email' || title == 'Supplier Contact'
//                       ? Colors.blue
//                       : Colors.black,
//                   decoration:
//                   title == 'Supplier Email' || title == 'Supplier Contact'
//                       ? TextDecoration.underline
//                       : TextDecoration.none,
//                 ),
//                 softWrap: true,
//                 overflow: TextOverflow.visible,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final transformerType =
//     widget.transformerData['TransformerType']; // tranformer type to check
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Transformer Details',
//           style: TextStyle(
//             color: Colors.white,
//             fontFamily: 'outfit',
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.indigo,
//         centerTitle: true,
//         iconTheme: const IconThemeData(
//           color: Colors.white,
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             buildDetailContainer(
//                 'Transformer ID', widget.transformerData['Transforme_ID']),
//             const SizedBox(height: 16),
//             const Text(
//               'Location Details',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.black87,
//               ),
//             ),
//             buildDetailContainer('Region', widget.transformerData['Region']),
//             buildDetailContainer('RTOM', widget.transformerData['RTOM']),
//             buildDetailContainer('Station', widget.transformerData['Station']),
//             buildDetailContainer('Location Latitude',
//                 widget.transformerData['LocationLatitude']),
//             buildDetailContainer('Location Longitude',
//                 widget.transformerData['LocationLongitude']),
//             const SizedBox(height: 16),
//             const Text(
//               'Owner Details',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.black87,
//               ),
//             ),
//             buildDetailContainer('Owner', widget.transformerData['Owner']),
//             const SizedBox(height: 16),
//             const Text(
//               'General Details',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.black87,
//               ),
//             ),
//             buildDetailContainer(
//                 'Transformer Type', widget.transformerData['TransformerType']),
//             //buildDetailContainer('transformer Type', "Oil Type"),
//             //buildDetailContainer('transformer Type', "Dry Type"),
//             buildDetailContainer(
//                 'Manufacturer', widget.transformerData['Manufacturer']),
//             buildDetailContainer('Installation Date',
//                 widget.transformerData['InstallationDate']),
//             buildDetailContainer('Last Maintenance Date',
//                 widget.transformerData['LastMaintenanceDate']),
//
//             // Fields specific to Oil Type Transformers
//             if (transformerType == 'Oil-Type') ...[
//               const SizedBox(height: 16),
//               const Text(
//                 'Oil-Type Specific Fields',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Colors.black87,
//                 ),
//               ),
//               buildDetailContainer(
//                   'Oil Level', widget.transformerData['OilLevel']),
//               buildDetailContainer(
//                   'Oil Type', widget.transformerData['OilType']),
//               const Text(
//                 'Ratings',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Colors.black87,
//                 ),
//               ),
//               buildDetailContainer(
//                   'Capacity', widget.transformerData['Capacity']),
//               buildDetailContainer('Voltage Level Primary',
//                   widget.transformerData['VoltageLevelPrimary']),
//               buildDetailContainer('Voltage Level Secondary',
//                   widget.transformerData['VoltageLevelSecondary']),
//               buildDetailContainer('Rated Frequency (Hz)',
//                   widget.transformerData['Rated_Frequency']),
//               buildDetailContainer('Rated Current Primary (A)',
//                   widget.transformerData['Rated_Current_Primary']),
//               buildDetailContainer('Rated Current Secondary (A)',
//                   widget.transformerData['Rated_Current_Secondary']),
//               const SizedBox(height: 16),
//               const Text(
//                 'Test Values',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Colors.black87,
//                 ),
//               ),
//               buildDetailContainer(
//                   'LI Withstand (kV)', widget.transformerData['LI_Withstand']),
//               buildDetailContainer(
//                   'AC Withstand (kV)', widget.transformerData['AC_Withstand']),
//               buildDetailContainer('Insulation Levels - Oil (kV)',
//                   widget.transformerData['Insulation_Level_Oil']),
//               buildDetailContainer('Insulation Levels -  Winding (kV)',
//                   widget.transformerData['Insulation_Level_Winding']),
//               buildDetailContainer('Actual Oil Temperature',
//                   widget.transformerData['Actual_Oil_Temperature']),
//               buildDetailContainer('Excitation Current (A)',
//                   widget.transformerData['Excitation_Current']),
//               const Text(
//                 'Physical Characteristics',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Colors.black87,
//                 ),
//               ),
//               buildDetailContainer(
//                   'Tap Position', widget.transformerData['Tap_Position']),
//               buildDetailContainer(
//                   'Total Mass (kg)', widget.transformerData['Total_Mass']),
//               buildDetailContainer(
//                   'Serial No', widget.transformerData['Serial_No']),
//               buildDetailContainer('Manufacturing Date',
//                   widget.transformerData['Manufacturing_Date']),
//             ],
//
//             // Fields specific to Dry Type Transformers
//             if (transformerType == 'Dry-Type') ...[
//               const SizedBox(height: 16),
//               const Text(
//                 'General Information',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Colors.black87,
//                 ),
//               ),
//               buildDetailContainer('Phase', widget.transformerData['Phase']),
//               buildDetailContainer(
//                   'Frequency (Hz)', widget.transformerData['Frequency']),
//               const SizedBox(height: 16),
//               const Text(
//                 'Ratings',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Colors.black87,
//                 ),
//               ),
//               buildDetailContainer('Capacity (Rated Power) (kVA)',
//                   widget.transformerData['Capacity']),
//               buildDetailContainer('Rated HV Current (A)',
//                   widget.transformerData['Rated_HV_Current']),
//               buildDetailContainer('Rated LV Current (A)',
//                   widget.transformerData['Rated_HV_Current']),
//               buildDetailContainer(
//                   'Type of Cooling', widget.transformerData['Cooling_Type']),
//               buildDetailContainer(
//                   'Vector Group', widget.transformerData['Vector_Group']),
//               const SizedBox(height: 16),
//               const Text(
//                 'Test Values',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Colors.black87,
//                 ),
//               ),
//               buildDetailContainer(
//                   'LI Withstand (kV)', widget.transformerData['LI_Withstand']),
//               buildDetailContainer(
//                   'AC Withstand (kV)', widget.transformerData['AC_Withstand']),
//               buildDetailContainer('Insulation Class',
//                   widget.transformerData['Insulation_Class']),
//               buildDetailContainer('Insulation Material',
//                   widget.transformerData['InsulationMaterial']),
//               buildDetailContainer('Temperature Rise (°C)',
//                   widget.transformerData['Temperature_Rise']),
//               buildDetailContainer('Winding Material',
//                   widget.transformerData['Winding_Material']),
//               buildDetailContainer(
//                   'C/E/F Class', widget.transformerData['class']),
//               const SizedBox(height: 16),
//               const Text(
//                 'Physical Characteristics',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Colors.black87,
//                 ),
//               ),
//               buildDetailContainer('IP Code of Enclosure',
//                   widget.transformerData['IP_Enclosure']),
//               buildDetailContainer(
//                   'Total Weight (kg)', widget.transformerData['Total_Weight']),
//               const SizedBox(height: 16),
//               const Text(
//                 'Other Information',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Colors.black87,
//                 ),
//               ),
//               buildDetailContainer('Manufacturing No.',
//                   widget.transformerData['Manufacturing_No']),
//               buildDetailContainer('Manufacturing Date',
//                   widget.transformerData['Manufacturing_Date']),
//               buildDetailContainer('Applied Standard',
//                   widget.transformerData['Applied_Standard']),
//             ],
//
//             const SizedBox(height: 16),
//             const Text(
//               'Operating Conditions',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.black87,
//               ),
//             ),
//             buildDetailContainer('Winding Temperature',
//                 widget.transformerData['WindingTemperature']),
//             buildDetailContainer('Ambient Temperature',
//                 widget.transformerData['AmbientTemperature']),
//             buildDetailContainer(
//                 'Operating Status', widget.transformerData['OperatingStatus']),
//             buildDetailContainer(
//                 'Load Current', widget.transformerData['LoadCurrent']),
//             buildDetailContainer('Load Current Measured Date',
//                 widget.transformerData['LoadCurrentDate']),
//             buildDetailContainer('Energy Consumption',
//                 widget.transformerData['EnergyConsumption']),
//             buildDetailContainer('Energy Consumption Date',
//                 widget.transformerData['EnergyConsumptionDate']),
//             const SizedBox(height: 16),
//             const Text(
//               'Service and Maintenance Details',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.black87,
//               ),
//             ),
//             buildDetailContainer(
//                 'Service Provider', widget.transformerData['ServiceProvider']),
//             buildDetailContainer(
//                 'AMC Available', widget.transformerData['AMCAvailable']),
//             buildDetailContainer(
//                 'Supplier Contact', widget.transformerData['SupplierContact']),
//             buildDetailContainer(
//                 'Supplier Email', widget.transformerData['SupplierEmail']),
//             buildDetailContainer('Remarks', widget.transformerData['Remarks']),
//             const SizedBox(height: 16),
//             const Text(
//               'Other Information',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.black87,
//               ),
//             ),
//             // buildDetailContainer('Manufacturing No.',
//             //     widget.transformerData['Manufacturing_No']),
//
//             // buildDetailContainer(
//             //     'Applied Standard', widget.transformerData['Applied_Standard']),
//             buildDetailContainer(
//                 'Uploaded By', widget.transformerData['uploadedBy']),
//             buildDetailContainer(
//                 'Uploaded Time', widget.transformerData['uploadedTime']),
//           ],
//         ),
//       ),
//     );
//   }
// }

//v2
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class TransformerDetailScreen extends StatefulWidget {
//   final Map<String, dynamic> transformerData;
//
//   TransformerDetailScreen({required this.transformerData});
//
//   @override
//   _TransformerDetailScreenState createState() =>
//       _TransformerDetailScreenState();
// }
//
// class _TransformerDetailScreenState extends State<TransformerDetailScreen> {
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   Widget buildDetailContainer(String title, dynamic detail) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       padding: const EdgeInsets.all(12.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '$title:   ',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//               color: Colors.indigo[900],
//             ),
//           ),
//           Expanded(
//             child: GestureDetector(
//               onTap: () async {
//                 if (title == 'Supplier Email' && detail != null) {
//                   // Open email app
//                   final Uri emailUri = Uri(
//                     scheme: 'mailto',
//                     path: detail.toString(),
//                   );
//                   if (await canLaunchUrl(emailUri)) {
//                     await launchUrl(emailUri);
//                   } else {
//                     // Handle error
//                     print('Could not launch email app');
//                     print('Could not launch email app. URI: $emailUri');
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content:
//                         Text('No email app found! Please install one.'),
//                       ),
//                     );
//                   }
//                 } else if (title == 'Supplier Contact' && detail != null) {
//                   // Open dialer
//                   final Uri phoneUri = Uri(
//                     scheme: 'tel',
//                     path: detail.toString(),
//                   );
//                   if (await canLaunchUrl(phoneUri)) {
//                     await launchUrl(phoneUri);
//                   } else {
//                     // Handle error
//                     print('Could not launch phone dialer');
//                     print('Could not launch phone dialer. URI: $phoneUri');
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content:
//                         Text('No phone app found! Please install one.'),
//                       ),
//                     );
//                   }
//                 }
//               },
//               child: Text(
//                 detail != null ? detail.toString() : 'N/A',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color:
//                   title == 'Supplier Email' || title == 'Supplier Contact'
//                       ? Colors.blue
//                       : Colors.black,
//                   decoration:
//                   title == 'Supplier Email' || title == 'Supplier Contact'
//                       ? TextDecoration.underline
//                       : TextDecoration.none,
//                 ),
//                 softWrap: true,
//                 overflow: TextOverflow.visible,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final transformerType =
//     widget.transformerData['TransformerType']; // tranformer type to check
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Transformer Details',
//           style: TextStyle(
//             color: Colors.white,
//             fontFamily: 'outfit',
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.indigo,
//         centerTitle: true,
//         iconTheme: const IconThemeData(
//           color: Colors.white,
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             buildDetailContainer(
//                 'Transformer ID', widget.transformerData['Transforme_ID']),
//             const SizedBox(height: 16),
//             const Text(
//               'Location Details',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.black87,
//               ),
//             ),
//             buildDetailContainer('Region', widget.transformerData['Region']),
//             buildDetailContainer('RTOM', widget.transformerData['RTOM']),
//             buildDetailContainer('Station', widget.transformerData['Station']),
//             buildDetailContainer('Location Latitude',
//                 widget.transformerData['LocationLatitude']),
//             buildDetailContainer('Location Longitude',
//                 widget.transformerData['LocationLongitude']),
//             const SizedBox(height: 16),
//             const Text(
//               'Owner Details',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.black87,
//               ),
//             ),
//             buildDetailContainer('Owner', widget.transformerData['Owner']),
//             const SizedBox(height: 16),
//             const Text(
//               'General Details',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.black87,
//               ),
//             ),
//             buildDetailContainer(
//                 'Transformer Type', widget.transformerData['TransformerType']),
//             //buildDetailContainer('transformer Type', "Oil Type"),
//             //buildDetailContainer('transformer Type', "Dry Type"),
//             buildDetailContainer(
//                 'Manufacturer', widget.transformerData['Manufacturer']),
//             buildDetailContainer('Installation Date',
//                 widget.transformerData['InstallationDate']),
//             buildDetailContainer('Last Maintenance Date',
//                 widget.transformerData['LastMaintenanceDate']),
//
//             // Fields specific to Oil Type Transformers
//             if (transformerType == 'Oil-Type') ...[
//               const SizedBox(height: 16),
//               const Text(
//                 'Oil-Type Specific Fields',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Colors.black87,
//                 ),
//               ),
//               buildDetailContainer(
//                   'Oil Level', widget.transformerData['OilLevel']),
//               buildDetailContainer(
//                   'Oil Type', widget.transformerData['OilType']),
//               const Text(
//                 'Ratings',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Colors.black87,
//                 ),
//               ),
//               buildDetailContainer(
//                   'Capacity', widget.transformerData['Capacity']),
//               buildDetailContainer('Voltage Level Primary',
//                   widget.transformerData['VoltageLevelPrimary']),
//               buildDetailContainer('Voltage Level Secondary',
//                   widget.transformerData['VoltageLevelSecondary']),
//               buildDetailContainer('Rated Frequency (Hz)',
//                   widget.transformerData['Rated_Frequency']),
//               buildDetailContainer('Rated Current Primary (A)',
//                   widget.transformerData['Rated_Current_Primary']),
//               buildDetailContainer('Rated Current Secondary (A)',
//                   widget.transformerData['Rated_Current_Secondary']),
//               const SizedBox(height: 16),
//               const Text(
//                 'Test Values',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Colors.black87,
//                 ),
//               ),
//               buildDetailContainer(
//                   'LI Withstand (kV)', widget.transformerData['LI_Withstand']),
//               buildDetailContainer(
//                   'AC Withstand (kV)', widget.transformerData['AC_Withstand']),
//               buildDetailContainer('Insulation Levels - Oil (kV)',
//                   widget.transformerData['Insulation_Level_Oil']),
//               buildDetailContainer('Insulation Levels -  Winding (kV)',
//                   widget.transformerData['Insulation_Level_Winding']),
//               buildDetailContainer('Actual Oil Temperature',
//                   widget.transformerData['Actual_Oil_Temperature']),
//               buildDetailContainer('Excitation Current (A)',
//                   widget.transformerData['Excitation_Current']),
//               const Text(
//                 'Physical Characteristics',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Colors.black87,
//                 ),
//               ),
//               buildDetailContainer(
//                   'Tap Position', widget.transformerData['Tap_Position']),
//               buildDetailContainer(
//                   'Total Mass (kg)', widget.transformerData['Total_Mass']),
//               buildDetailContainer(
//                   'Serial No', widget.transformerData['Serial_No']),
//               buildDetailContainer('Manufacturing Date',
//                   widget.transformerData['Manufacturing_Date']),
//             ],
//
//             // Fields specific to Dry Type Transformers
//             if (transformerType == 'Dry-Type') ...[
//               const SizedBox(height: 16),
//               const Text(
//                 'General Information',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Colors.black87,
//                 ),
//               ),
//               buildDetailContainer('Phase', widget.transformerData['Phase']),
//               buildDetailContainer(
//                   'Frequency (Hz)', widget.transformerData['Frequency']),
//               const SizedBox(height: 16),
//               const Text(
//                 'Ratings',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Colors.black87,
//                 ),
//               ),
//               buildDetailContainer('Capacity (Rated Power) (kVA)',
//                   widget.transformerData['Capacity']),
//               buildDetailContainer('Rated HV Current (A)',
//                   widget.transformerData['Rated_HV_Current']),
//               buildDetailContainer('Rated LV Current (A)',
//                   widget.transformerData['Rated_HV_Current']),
//               buildDetailContainer(
//                   'Type of Cooling', widget.transformerData['Cooling_Type']),
//               buildDetailContainer(
//                   'Vector Group', widget.transformerData['Vector_Group']),
//               const SizedBox(height: 16),
//               const Text(
//                 'Test Values',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Colors.black87,
//                 ),
//               ),
//               buildDetailContainer(
//                   'LI Withstand (kV)', widget.transformerData['LI_Withstand']),
//               buildDetailContainer(
//                   'AC Withstand (kV)', widget.transformerData['AC_Withstand']),
//               buildDetailContainer('Insulation Class',
//                   widget.transformerData['Insulation_Class']),
//               buildDetailContainer('Insulation Material',
//                   widget.transformerData['InsulationMaterial']),
//               buildDetailContainer('Temperature Rise (°C)',
//                   widget.transformerData['Temperature_Rise']),
//               buildDetailContainer('Winding Material',
//                   widget.transformerData['Winding_Material']),
//               buildDetailContainer(
//                   'C/E/F Class', widget.transformerData['class']),
//               const SizedBox(height: 16),
//               const Text(
//                 'Physical Characteristics',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Colors.black87,
//                 ),
//               ),
//               buildDetailContainer('IP Code of Enclosure',
//                   widget.transformerData['IP_Enclosure']),
//               buildDetailContainer(
//                   'Total Weight (kg)', widget.transformerData['Total_Weight']),
//               const SizedBox(height: 16),
//               const Text(
//                 'Other Information',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Colors.black87,
//                 ),
//               ),
//               buildDetailContainer('Manufacturing No.',
//                   widget.transformerData['Manufacturing_No']),
//               buildDetailContainer('Manufacturing Date',
//                   widget.transformerData['Manufacturing_Date']),
//               buildDetailContainer('Applied Standard',
//                   widget.transformerData['Applied_Standard']),
//             ],
//
//             const SizedBox(height: 16),
//             const Text(
//               'Operating Conditions',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.black87,
//               ),
//             ),
//             buildDetailContainer('Winding Temperature',
//                 widget.transformerData['WindingTemperature']),
//             buildDetailContainer('Ambient Temperature',
//                 widget.transformerData['AmbientTemperature']),
//             buildDetailContainer(
//                 'Operating Status', widget.transformerData['OperatingStatus']),
//             buildDetailContainer(
//                 'Load Current', widget.transformerData['LoadCurrent']),
//             buildDetailContainer('Load Current Measured Date',
//                 widget.transformerData['LoadCurrentDate']),
//             buildDetailContainer('Energy Consumption',
//                 widget.transformerData['EnergyConsumption']),
//             buildDetailContainer('Energy Consumption Date',
//                 widget.transformerData['EnergyConsumptionDate']),
//             const SizedBox(height: 16),
//             const Text(
//               'Service and Maintenance Details',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.black87,
//               ),
//             ),
//             buildDetailContainer(
//                 'Service Provider', widget.transformerData['ServiceProvider']),
//             buildDetailContainer(
//                 'AMC Available', widget.transformerData['AMCAvailable']),
//             buildDetailContainer(
//                 'Supplier Contact', widget.transformerData['SupplierContact']),
//             buildDetailContainer(
//                 'Supplier Email', widget.transformerData['SupplierEmail']),
//             buildDetailContainer('Remarks', widget.transformerData['Remarks']),
//             const SizedBox(height: 16),
//             const Text(
//               'Other Information',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.black87,
//               ),
//             ),
//             // buildDetailContainer('Manufacturing No.',
//             //     widget.transformerData['Manufacturing_No']),
//
//             // buildDetailContainer(
//             //     'Applied Standard', widget.transformerData['Applied_Standard']),
//             buildDetailContainer(
//                 'Uploaded By', widget.transformerData['uploadedBy']),
//             buildDetailContainer(
//                 'Uploaded Time', widget.transformerData['uploadedTime']),
//           ],
//         ),
//       ),
//     );
//   }
// }

//v1
// import 'package:flutter/material.dart';
//
// class TransformerDetailScreen extends StatefulWidget {
//   final Map<String, dynamic> transformerData;
//
//   TransformerDetailScreen({required this.transformerData});
//
//   @override
//   _TransformerDetailScreenState createState() =>
//       _TransformerDetailScreenState();
// }
//
// class _TransformerDetailScreenState extends State<TransformerDetailScreen> {
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   Widget buildDetailContainer(String title, dynamic detail) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       padding: const EdgeInsets.all(12.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '$title:   ',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//               color: Colors.indigo[900],
//             ),
//           ),
//           Expanded(
//             child: Text(
//               detail != null ? detail.toString() : 'N/A',
//               style: const TextStyle(
//                 fontSize: 16,
//               ),
//               softWrap: true,
//               overflow: TextOverflow.visible,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Transformer Details',
//           style: TextStyle(
//             color: Colors.white,
//             fontFamily: 'outfit',
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.indigo,
//         centerTitle: true,
//         iconTheme: const IconThemeData(
//           color: Colors.white,
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             buildDetailContainer(
//                 'Transformer ID', widget.transformerData['TransformerID']),
//             buildDetailContainer('Region', widget.transformerData['Region']),
//             buildDetailContainer('RTOM', widget.transformerData['RTOM']),
//             buildDetailContainer('Station', widget.transformerData['Station']),
//             buildDetailContainer('Owner', widget.transformerData['Owner']),
//             buildDetailContainer(
//                 'Transformer Type', widget.transformerData['TransformerType']),
//             buildDetailContainer(
//                 'Manufacturer', widget.transformerData['Manufacturer']),
//             buildDetailContainer('Manufacturing Date',
//                 widget.transformerData['Manufacturing_Date']),
//             buildDetailContainer('Installation Date',
//                 widget.transformerData['InstallationDate']),
//             buildDetailContainer('Last Maintenance Date',
//                 widget.transformerData['LastMaintenanceDate']),
//             buildDetailContainer(
//                 'Capacity', widget.transformerData['Capacity']),
//             buildDetailContainer(
//                 'LI Withstand (kV)', widget.transformerData['LI_Withstand']),
//             buildDetailContainer(
//                 'AC Withstand (kV)', widget.transformerData['AC_Withstand']),
//             buildDetailContainer('transformer Type', "Oil Type"),
//             buildDetailContainer(
//                 'Oil Level', widget.transformerData['OilLevel']),
//             buildDetailContainer('Oil Type', widget.transformerData['OilType']),
//             buildDetailContainer('Voltage Level Primary',
//                 widget.transformerData['VoltageLevelPrimary']),
//             buildDetailContainer('Voltage Level Secondary',
//                 widget.transformerData['VoltageLevelSecondary']),
//             buildDetailContainer('Rated Frequency (Hz)',
//                 widget.transformerData['Rated_Frequency']),
//             buildDetailContainer('Rated Current Primary (A)',
//                 widget.transformerData['Rated_Current_Primary']),
//             buildDetailContainer('Rated Current Secondary (A)',
//                 widget.transformerData['Rated_Current_Secondary']),
//             buildDetailContainer('Insulation Levels - Oil (kV)',
//                 widget.transformerData['Insulation_Level_Oil']),
//             buildDetailContainer('Insulation Levels -  Winding (kV)',
//                 widget.transformerData['Insulation_Level_Winding']),
//             buildDetailContainer('Actual Oil Temperature',
//                 widget.transformerData['Actual_Oil_Temperature']),
//             buildDetailContainer('Excitation Current (A)',
//                 widget.transformerData['Excitation_Current']),
//             buildDetailContainer(
//                 'Tap Position', widget.transformerData['Tap_Position']),
//             buildDetailContainer(
//                 'Total Mass (kg)', widget.transformerData['Total_Mass']),
//             buildDetailContainer(
//                 'Serial No', widget.transformerData['Serial_No']),
//             buildDetailContainer('transformer Type', "Dry Type"),
//             buildDetailContainer('Phase', widget.transformerData['Phase']),
//             buildDetailContainer(
//                 'Frequency (Hz)', widget.transformerData['Frequency']),
//             buildDetailContainer('Rated HV Current (A)',
//                 widget.transformerData['Rated_HV_Current']),
//             buildDetailContainer('Rated LV Current (A)',
//                 widget.transformerData['Rated_LV_Current']),
//             buildDetailContainer(
//                 'Type of Cooling', widget.transformerData['Cooling_Type']),
//             buildDetailContainer(
//                 'Vector Group', widget.transformerData['Vector_Group']),
//             buildDetailContainer(
//                 'Insulation Class', widget.transformerData['Insulation_Class']),
//             buildDetailContainer('Insulation Material',
//                 widget.transformerData['InsulationMaterial']),
//             buildDetailContainer('Temperature Rise (°C)',
//                 widget.transformerData['Temperature_Rise']),
//             buildDetailContainer(
//                 'Winding Material', widget.transformerData['Winding_Material']),
//             buildDetailContainer(
//                 'C/E/F Class', widget.transformerData['class']),
//             buildDetailContainer(
//                 'IP Code of Enclosure', widget.transformerData['IP_Enclosure']),
//             buildDetailContainer(
//                 'Total Weight (kg)', widget.transformerData['Total_Weight']),
//             buildDetailContainer('Manufacturing No.',
//                 widget.transformerData['Manufacturing_No']),
//             buildDetailContainer(
//                 'Applied Standard', widget.transformerData['Applied_Standard']),
//             buildDetailContainer('Winding Temperature',
//                 widget.transformerData['WindingTemperature']),
//             buildDetailContainer('Ambient Temperature',
//                 widget.transformerData['AmbientTemperature']),
//             buildDetailContainer(
//                 'Operating Status', widget.transformerData['OperatingStatus']),
//             buildDetailContainer(
//                 'Load Current', widget.transformerData['LoadCurrent']),
//             buildDetailContainer('Load Current Measured Date',
//                 widget.transformerData['LoadCurrentDate']),
//             buildDetailContainer('Energy Consumption',
//                 widget.transformerData['EnergyConsumption']),
//             buildDetailContainer('Energy Consumption Date',
//                 widget.transformerData['EnergyConsumptionDate']),
//             buildDetailContainer(
//                 'Service Provider', widget.transformerData['ServiceProvider']),
//             buildDetailContainer(
//                 'AMC Available', widget.transformerData['AMCAvailable']),
//             buildDetailContainer(
//                 'Supplier Contact', widget.transformerData['SupplierContact']),
//             buildDetailContainer(
//                 'Supplier Email', widget.transformerData['SupplierEmail']),
//             buildDetailContainer('Location Latitude',
//                 widget.transformerData['LocationLatitude']),
//             buildDetailContainer('Location Longitude',
//                 widget.transformerData['LocationLongitude']),
//             buildDetailContainer('Remarks', widget.transformerData['Remarks']),
//             buildDetailContainer(
//                 'Uploaded By', widget.transformerData['uploadedBy']),
//             buildDetailContainer(
//                 'Uploaded Time', widget.transformerData['uploadedTime']),
//           ],
//         ),
//       ),
//     );
//   }
// }
