import 'package:flutter/material.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/utils/colors.dart';

class LVBreakerDetailPage extends StatelessWidget {
  final Map<String, dynamic> breaker;
  final String searchQuery;

  const LVBreakerDetailPage({
    Key? key,
    required this.breaker,
    this.searchQuery = '',
  }) : super(key: key);
  InlineSpan getHighlightedText(
    String text,
    String searchQuery,
    Color textColor,
    Color highlightColor,
  ) {
    if (searchQuery.isEmpty) {
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

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LV Breaker Details',
          style: TextStyle(color: customColors.mainTextColor),
        ),
        iconTheme: IconThemeData(color: customColors.mainTextColor),
        backgroundColor: customColors.appbarColor,
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),
      backgroundColor: customColors.mainBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard('Panel Information', [
              _buildDetailRow('Panel ID:', breaker['PanelID'], context),
              _buildDetailRow('QR Tag:', breaker['QRtag'], context),
            ], context),
            const SizedBox(height: 16),
            _buildInfoCard('Location', [
              _buildDetailRow('Region:', breaker['Region'], context),
              _buildDetailRow('RTOM:', breaker['RTOM'], context),
              _buildDetailRow('Station:', breaker['Station'], context),
              _buildDetailRow('Building:', breaker['Building'], context),
              _buildDetailRow('Room:', breaker['Room'], context),
              _buildDetailRow(
                'Latitude:',
                breaker['LocationLatitude'],
                context,
              ),
              _buildDetailRow(
                'Longitude:',
                breaker['LocationLongitude'],
                context,
              ),
            ], context),
            const SizedBox(height: 16),
            _buildInfoCard('General Details', [
              _buildDetailRow('Panel Type:', breaker['PanelType'], context),
              _buildDetailRow('Panel Serial:', breaker['PanelSerial'], context),
              _buildDetailRow(
                'Manufacturer:',
                breaker['Manufacturer'],
                context,
              ),
              _buildDetailRow(
                'Installation Date:',
                breaker['InstallationDate'],
                context,
              ),
              _buildDetailRow(
                'Last Maintenance Date:',
                breaker['LastMaintenanceDate'],
                context,
              ),
              _buildDetailRow(
                'Busbar Details:',
                breaker['BusbarDetails'],
                context,
              ),
              _buildDetailRow(
                'Breaker Current Capacity:',
                '${breaker['BreakerCurrentCapacity']} A',
                context,
              ),
              _buildDetailRow(
                'Breaker Brand:',
                breaker['BreakerBrand'],
                context,
              ),
              _buildDetailRow(
                'Breaker Model:',
                breaker['BreakerModel'],
                context,
              ),
              _buildDetailRow(
                'Connection Bus:',
                breaker['ConnectionBus'],
                context,
              ),
              _buildDetailRow('Cable Type:', breaker['CableType'], context),
              _buildDetailRow('Cable Size:', breaker['CableSize'], context),
            ], context),
            const SizedBox(height: 16),
            _buildInfoCard('Supplier Details', [
              _buildDetailRow(
                'Supplier Name:',
                breaker['ServiceProvider'],
                context,
              ),
              _buildDetailRow(
                'AMC Available:',
                breaker['AMCAvailable'],
                context,
              ),
              _buildDetailRow(
                'Supplier Contact:',
                breaker['SupplierContact'],
                context,
              ),
              _buildDetailRow(
                'Supplier Email:',
                breaker['SupplierEmail'],
                context,
              ),
            ], context),
            const SizedBox(height: 16),
            _buildInfoCard('Other Equipment Details', [
              _buildDetailRow(
                'Power Analyzer Brand:',
                breaker['PowerAnalyzerBrand'],
                context,
              ),
              _buildDetailRow(
                'Power Analyzer Model:',
                breaker['PowerAnalyzerModel'],
                context,
              ),
              _buildDetailRow(
                'Earth Fault Relay:',
                breaker['EarthFaultRelay'],
                context,
              ),
            ], context),
            const SizedBox(height: 16),
            _buildInfoCard('Other Details', [
              _buildDetailRow('Remarks:', breaker['Remarks'], context),
              _buildDetailRow('Uploaded By:', breaker['uploadedBy'], context),
              _buildDetailRow(
                'Uploaded Time:',
                breaker['uploadedTime'],
                context,
              ),
            ], context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    List<Widget> details,
    BuildContext context,
  ) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      color: customColors.suqarBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: customColors.mainTextColor,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            ...details,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    if (value == 'N/A' || value == null) return const SizedBox.shrink();
    final bool isMatch =
        searchQuery.isNotEmpty &&
        value.toLowerCase().contains(searchQuery.toLowerCase());

    final bool isPhone = label.trim().toLowerCase() == 'supplier contact:';
    final bool isEmail = label.trim().toLowerCase() == 'supplier email:';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: customColors.suqarBackgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: customColors.mainTextColor,
              ),
            ),
            Expanded(
              child:
                  (isPhone || isEmail)
                      ? GestureDetector(
                        onTap: () async {
                          if (isPhone) {
                            final Uri telUri = Uri(scheme: 'tel', path: value);
                            if (await canLaunchUrl(telUri)) {
                              await launchUrl(telUri);
                            }
                          } else if (isEmail) {
                            final Uri emailUri = Uri(
                              scheme: 'mailto',
                              path: value,
                            );
                            if (await canLaunchUrl(emailUri)) {
                              await launchUrl(emailUri);
                            }
                          }
                        },
                        child: Text.rich(
                          getHighlightedText(
                            value,
                            searchQuery,
                            Colors.blue,
                            customColors.hinttColor,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      )
                      : Text.rich(
                        getHighlightedText(
                          value,
                          searchQuery,
                          customColors.subTextColor,
                          customColors.hinttColor,
                        ),
                        textAlign: TextAlign.right,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

//V1
// import 'package:flutter/material.dart';
// import 'package:search_option/utils/utils/colors.dart';
//
// class LVBreakerDetailPage extends StatelessWidget {
//   final Map<String, dynamic> breaker;
//   final String searchQuery;
//
//   const LVBreakerDetailPage(
//       {Key? key, required this.breaker, this.searchQuery = ''})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('LV Breaker Details', style: TextStyle(color: mainTextColor),),
//         iconTheme: IconThemeData(
//           color: mainTextColor,
//         ),
//         backgroundColor: appbarColor,
//       ),
//       body: Container(
//         color: mainBackgroundColor,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: ListView(
//             children: [
//               _buildDetailCard(context,'Panel Information', [
//                 _buildDetailRow('Panel ID:', breaker['PanelID']),
//                 _buildDetailRow('QR Tag:', breaker['QRtag']),
//               ]),
//               _buildDetailCard(context,'Location', [
//                 _buildDetailRow('Region:', breaker['Region']),
//                 _buildDetailRow('RTOM:', breaker['RTOM']),
//                 _buildDetailRow('Station:', breaker['Station']),
//                 _buildDetailRow('Building:', breaker['Building']),
//                 _buildDetailRow('Room:', breaker['Room']),
//                 _buildDetailRow('Latitude:', breaker['LocationLatitude']),
//                 _buildDetailRow('Longitude:', breaker['LocationLongitude']),
//               ]),
//               _buildDetailCard(context,'General Details', [
//                 _buildDetailRow('Panel Type:', breaker['PanelType']),
//                 _buildDetailRow('Panel Serial:', breaker['PanelSerial']),
//                 _buildDetailRow('Manufacturer:', breaker['Manufacturer']),
//                 _buildDetailRow('Installation Date:', breaker['InstallationDate']),
//                 _buildDetailRow('Last Maintenance Date:', breaker['LastMaintenanceDate']),
//                 _buildDetailRow('Busbar Details:', breaker['BusbarDetails']),
//                 _buildDetailRow('Breaker Current Capacity:', '${breaker['BreakerCurrentCapacity']} A'),
//                 _buildDetailRow('Breaker Brand:', breaker['BreakerBrand']),
//                 _buildDetailRow('Breaker Model:', breaker['BreakerModel']),
//                 _buildDetailRow('Connection Bus:', breaker['ConnectionBus']),
//                 _buildDetailRow('Cable Type:', breaker['CableType']),
//                 _buildDetailRow('Cable Size:', breaker['CableSize']),
//               ]),
//               _buildDetailCard(context,'Supplier Details', [
//                 _buildDetailRow('Supplier Name:', breaker['ServiceProvider']),
//                 _buildDetailRow('AMC Available:', breaker['AMCAvailable']),
//                 _buildDetailRow('Supplier Contact:', breaker['SupplierContact']),
//                 _buildDetailRow('Supplier Email:', breaker['SupplierEmail']),
//               ]),
//               _buildDetailCard(context,'Other Equipment Details', [
//                 _buildDetailRow('Power Analyzer Brand:', breaker['PowerAnalyzerBrand']),
//                 _buildDetailRow('Power Analyzer Model:', breaker['PowerAnalyzerModel']),
//                 _buildDetailRow('Earth Fault Relay:', breaker['EarthFaultRelay']),
//               ]),
//               _buildDetailCard(context,'Other Details', [
//                 _buildDetailRow('Remarks:', breaker['Remarks']),
//                 _buildDetailRow('Uploaded By:', breaker['uploadedBy']),
//                 _buildDetailRow('Uploaded Time:', breaker['uploadedTime']),
//               ]),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Helper method to build individual detail rows
//   Widget _buildDetailRow(String label, String value) {
//     final bool isMatch = searchQuery.isNotEmpty &&
//         value != null &&
//         value.toLowerCase().contains(searchQuery.toLowerCase());
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: isMatch ? highlightColor : null,
//           borderRadius: BorderRadius.circular(4.0),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//                 child: Text(label,
//                     style: const TextStyle(fontWeight: FontWeight.bold,color: mainTextColor))),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 value ?? 'N/A',
//                 style: TextStyle(
//                   color: subTextColor,
//                   backgroundColor: isMatch ? highlightColor : null,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailCard(BuildContext context, String title, List<Widget> children) {
//     return Card(
//       color: suqarBackgroundColor,
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                 color: mainTextColor,
//               ),
//             ),
//             const SizedBox(height: 8),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }
// }
