import 'package:flutter/material.dart';

import '../../utils/utils/colors.dart';

class LVBreakerDetailPage extends StatelessWidget {
  final Map<String, dynamic> breaker;
  final String searchQuery;

  const LVBreakerDetailPage(
      {Key? key, required this.breaker, this.searchQuery = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LV Breaker Details',
          style: TextStyle(color: mainTextColor),
        ),
        iconTheme: const IconThemeData(
          color: mainTextColor,
        ),
        backgroundColor: appbarColor,
      ),
      backgroundColor: mainBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard('Panel Information', [
              _buildDetailRow('Panel ID:', breaker['PanelID']),
              _buildDetailRow('QR Tag:', breaker['QRtag']),
            ]),
            const SizedBox(height: 16),
            _buildInfoCard('Location', [
              _buildDetailRow('Region:', breaker['Region']),
              _buildDetailRow('RTOM:', breaker['RTOM']),
              _buildDetailRow('Station:', breaker['Station']),
              _buildDetailRow('Building:', breaker['Building']),
              _buildDetailRow('Room:', breaker['Room']),
              _buildDetailRow('Latitude:', breaker['LocationLatitude']),
              _buildDetailRow('Longitude:', breaker['LocationLongitude']),
            ]),
            const SizedBox(height: 16),
            _buildInfoCard('General Details', [
              _buildDetailRow('Panel Type:', breaker['PanelType']),
              _buildDetailRow('Panel Serial:', breaker['PanelSerial']),
              _buildDetailRow('Manufacturer:', breaker['Manufacturer']),
              _buildDetailRow(
                  'Installation Date:', breaker['InstallationDate']),
              _buildDetailRow(
                  'Last Maintenance Date:', breaker['LastMaintenanceDate']),
              _buildDetailRow('Busbar Details:', breaker['BusbarDetails']),
              _buildDetailRow('Breaker Current Capacity:',
                  '${breaker['BreakerCurrentCapacity']} A'),
              _buildDetailRow('Breaker Brand:', breaker['BreakerBrand']),
              _buildDetailRow('Breaker Model:', breaker['BreakerModel']),
              _buildDetailRow('Connection Bus:', breaker['ConnectionBus']),
              _buildDetailRow('Cable Type:', breaker['CableType']),
              _buildDetailRow('Cable Size:', breaker['CableSize']),
            ]),
            const SizedBox(height: 16),
            _buildInfoCard('Supplier Details', [
              _buildDetailRow('Supplier Name:', breaker['ServiceProvider']),
              _buildDetailRow('AMC Available:', breaker['AMCAvailable']),
              _buildDetailRow('Supplier Contact:', breaker['SupplierContact']),
              _buildDetailRow('Supplier Email:', breaker['SupplierEmail']),
            ]),
            const SizedBox(height: 16),
            _buildInfoCard('Other Equipment Details', [
              _buildDetailRow(
                  'Power Analyzer Brand:', breaker['PowerAnalyzerBrand']),
              _buildDetailRow(
                  'Power Analyzer Model:', breaker['PowerAnalyzerModel']),
              _buildDetailRow('Earth Fault Relay:', breaker['EarthFaultRelay']),
            ]),
            const SizedBox(height: 16),
            _buildInfoCard('Other Details', [
              _buildDetailRow('Remarks:', breaker['Remarks']),
              _buildDetailRow('Uploaded By:', breaker['uploadedBy']),
              _buildDetailRow('Uploaded Time:', breaker['uploadedTime']),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> details) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      color: suqarBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: mainTextColor)),
            const SizedBox(height: 10),
            const Divider(),
            ...details,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    if (value == 'N/A' || value == null) return const SizedBox.shrink();
    final bool isMatch = searchQuery.isNotEmpty &&
        value.toLowerCase().contains(searchQuery.toLowerCase());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: isMatch ? highlightColor : suqarBackgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: mainTextColor,
              ),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: subTextColor,
                  backgroundColor: isMatch ? highlightColor : null,
                ),
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
