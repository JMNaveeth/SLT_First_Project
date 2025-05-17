import 'package:flutter/material.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/utils/utils/colors.dart';

import 'ac_details_model.dart';

class ViewComfortACUnit extends StatefulWidget {
  final AcIndoorData? indoorData;
  final AcOutdoorData? outdoorData;
  final AcLogData logData;
  final String searchQuery;

  ViewComfortACUnit({
    required this.indoorData,
    required this.outdoorData,
    required this.logData,
    this.searchQuery = '',
  });

  @override
  State<ViewComfortACUnit> createState() => _ViewComfortACUnitState();
}

class _ViewComfortACUnitState extends State<ViewComfortACUnit> {
  int currentState = 0;
  List<Widget> listData = [];

  @override
  void initState() {
    super.initState();
    listData = [
      indoorList(widget.indoorData, widget.logData, widget.searchQuery),
      widget.outdoorData == null
          ? const Center(child: Text("Not Submitted Those datas Yet"))
          : outDoorList(widget.outdoorData!, widget.searchQuery),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AC Detail',
          style: TextStyle(color: customColors.mainTextColor),
        ),
        backgroundColor: customColors.appbarColor,
        iconTheme: IconThemeData(color: customColors.mainTextColor),
        actions: [ThemeToggleButton()],
      ),
      body: Container(
        color: customColors.mainBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Tab Row with 3 tabs: SITE INFO, INDOOR, OUTDOOR
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: customColors.suqarBackgroundColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // SITE INFO tab
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          currentState = 0;
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.055,
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          color:
                              currentState == 0
                                  ? Colors.grey
                                  : customColors.suqarBackgroundColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(
                          child: Text(
                            "SITE INFO",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: customColors.mainTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // INDOOR tab
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          currentState = 1;
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.055,
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          color:
                              currentState == 1
                                  ? Colors.grey
                                  : customColors.suqarBackgroundColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(
                          child: Text(
                            "INDOOR",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: customColors.mainTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // OUTDOOR tab
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          currentState = 2;
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.055,
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          color:
                              currentState == 2
                                  ? Colors.grey
                                  : customColors.suqarBackgroundColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(
                          child: Text(
                            "OUTDOOR",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: customColors.mainTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              // --- Always show this summary card below the tabs ---
              Card(
                color: customColors.suqarBackgroundColor,
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.indoorData?.acIndoorId ?? ''}",
                        style: TextStyle(color: customColors.mainTextColor),
                      ),
                      widget.outdoorData != null
                          ? Text(
                            "${widget.outdoorData!.acOutdoorId}",
                            style: TextStyle(color: customColors.mainTextColor),
                          )
                          : const Text(""),
                    ],
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Region: ${widget.logData.region}',
                            style: TextStyle(color: customColors.mainTextColor),
                          ),
                          Text(
                            'Brand: ${widget.indoorData?.brand ?? ""}',
                            style: TextStyle(color: customColors.mainTextColor),
                          ),
                        ],
                      ),
                      Text(
                        'Location: ${widget.logData.location}',
                        style: TextStyle(color: customColors.mainTextColor),
                      ),
                      Text(
                        "Last Updated: ${widget.indoorData?.lastUpdated ?? ""}",
                        style: TextStyle(color: customColors.mainTextColor),
                      ),
                    ],
                  ),
                ),
              ),
              // --- Tab content below the summary card ---
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (currentState == 0)
                        siteInfoCardList(
                          widget.indoorData,
                          widget.outdoorData,
                          widget.logData,
                          widget.searchQuery,
                        )
                      else if (currentState == 1)
                        listData[0]
                      else if (currentState == 2)
                        listData[1],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomOneDetailsCard extends StatefulWidget {
  const CustomOneDetailsCard({
    super.key,
    required this.title,
    required this.titleResponse,
    this.shouldHighlight = false,
  });

  final String title;
  final String? titleResponse;
  final bool shouldHighlight;

  @override
  State<CustomOneDetailsCard> createState() => _CustomOneDetailsCardState();
}

class _CustomOneDetailsCardState extends State<CustomOneDetailsCard> {
  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final searchQuery =
        (context
                .findAncestorStateOfType<_ViewComfortACUnitState>()
                ?.widget
                .searchQuery ??
            '');

    InlineSpan getHighlightedText(
      String text,
      String searchQuery,
      Color textColor,
      Color highlightColor,
    ) {
      if (searchQuery.isEmpty) {
        return TextSpan(text: text, style: TextStyle(color: textColor));
      }
      final lowerText = text.toLowerCase();
      final lowerQuery = searchQuery.toLowerCase();
      final start = lowerText.indexOf(lowerQuery);
      if (start == -1) {
        return TextSpan(text: text, style: TextStyle(color: textColor));
      }
      final end = start + lowerQuery.length;
      return TextSpan(
        children: [
          if (start > 0)
            TextSpan(
              text: text.substring(0, start),
              style: TextStyle(color: textColor),
            ),
          TextSpan(
            text: text.substring(start, end),
            style: TextStyle(color: textColor, backgroundColor: highlightColor),
          ),
          if (end < text.length)
            TextSpan(
              text: text.substring(end),
              style: TextStyle(color: textColor),
            ),
        ],
      );
    }

    return Card(
      color: customColors.suqarBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          top: 20,
          bottom: 20,
          right: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: TextStyle(color: customColors.mainTextColor),
            ),
            widget.title == "Condition ID Unit"
                ? Row(
                  children: [
                    Text.rich(
                      getHighlightedText(
                        widget.titleResponse ?? "",
                        widget.shouldHighlight ? searchQuery : '',
                        customColors.mainTextColor,
                        customColors.hinttColor,
                      ),
                    ),
                    Icon(
                      widget.titleResponse == "Good"
                          ? Icons.check_circle
                          : Icons.cancel,
                      color:
                          widget.titleResponse == "Good"
                              ? Colors.green
                              : Colors.red,
                    ),
                  ],
                )
                : Text.rich(
                  getHighlightedText(
                    widget.titleResponse ?? "",
                    widget.shouldHighlight ? searchQuery : '',
                    customColors.mainTextColor,
                    customColors.hinttColor,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

Widget siteInfoCardList(
  AcIndoorData? indoor,
  AcOutdoorData? outdoor,
  AcLogData log,
  String searchQuery,
) {
  bool shouldHighlight(String? value) {
    if (value == null || searchQuery.isEmpty) return false;
    return value.toLowerCase().contains(searchQuery.toLowerCase());
  }

  return Column(
    children: [
      CustomOneDetailsCard(
        title: "AC Indoor ID",
        titleResponse: indoor?.acIndoorId ?? 'N/A',
        shouldHighlight: shouldHighlight(indoor?.acIndoorId),
      ),
      CustomOneDetailsCard(
        title: "AC Outdoor ID",
        titleResponse: outdoor?.acOutdoorId ?? 'N/A',
        shouldHighlight: shouldHighlight(outdoor?.acOutdoorId),
      ),
      CustomOneDetailsCard(
        title: "Building ID",
        titleResponse: log.rtomBuildingId ?? 'N/A',
        shouldHighlight: shouldHighlight(log.rtomBuildingId),
      ),
      CustomOneDetailsCard(
        title: "Floor Number",
        titleResponse: log.floorNumber ?? 'N/A',
        shouldHighlight: shouldHighlight(log.floorNumber),
      ),
      CustomOneDetailsCard(
        title: "Last Updated",
        titleResponse: indoor?.lastUpdated ?? 'N/A',
        shouldHighlight: shouldHighlight(indoor?.lastUpdated),
      ),
      CustomOneDetailsCard(
        title: "Latitude",
        titleResponse: log.latitude ?? 'N/A',
        shouldHighlight: shouldHighlight(log.latitude),
      ),
      CustomOneDetailsCard(
        title: "Location",
        titleResponse: log.location ?? 'N/A',
        shouldHighlight: shouldHighlight(log.location),
      ),
      CustomOneDetailsCard(
        title: "Log ID",
        titleResponse: log.logId,
        shouldHighlight: shouldHighlight(log.logId),
      ),
      CustomOneDetailsCard(
        title: "Longitude",
        titleResponse: log.longitude ?? 'N/A',
        shouldHighlight: shouldHighlight(log.longitude),
      ),
      CustomOneDetailsCard(
        title: "Number of AC Plants",
        titleResponse: log.noAcPlants ?? 'N/A',
        shouldHighlight: shouldHighlight(log.noAcPlants),
      ),
      CustomOneDetailsCard(
        title: "Office Number",
        titleResponse: log.officeNumber ?? 'N/A',
        shouldHighlight: shouldHighlight(log.officeNumber),
      ),
      CustomOneDetailsCard(
        title: "QR Location",
        titleResponse: indoor?.qrIn ?? 'N/A',
        shouldHighlight: shouldHighlight(indoor?.qrIn),
      ),
      CustomOneDetailsCard(
        title: "RTOM",
        titleResponse: log.rtom ?? 'N/A',
        shouldHighlight: shouldHighlight(log.rtom),
      ),
      CustomOneDetailsCard(
        title: "Region",
        titleResponse: log.region ?? 'N/A',
        shouldHighlight: shouldHighlight(log.region),
      ),
      CustomOneDetailsCard(
        title: "Station",
        titleResponse: log.station ?? 'N/A',
        shouldHighlight: shouldHighlight(log.station),
      ),
      CustomOneDetailsCard(
        title: "Uploaded By",
        titleResponse: log.uploadedBy,
        shouldHighlight: shouldHighlight(log.uploadedBy),
      ),
    ],
  );
}

Widget indoorList(
  AcIndoorData? indoorData,
  AcLogData logData,
  String searchQuery,
) {
  bool shouldHighlight(String? value) {
    if (value == null || searchQuery.isEmpty) return false;
    return value.toLowerCase().contains(searchQuery.toLowerCase());
  }

  return Column(
    children: [
      CustomOneDetailsCard(
        title: "AC Indoor ID",
        titleResponse: indoorData!.acIndoorId,
        shouldHighlight: shouldHighlight(indoorData.acIndoorId),
      ),
      CustomOneDetailsCard(
        title: "Region",
        titleResponse: logData.region,
        shouldHighlight: shouldHighlight(logData.region),
      ),
      CustomOneDetailsCard(
        title: "RTOM",
        titleResponse: logData.rtom,
        shouldHighlight: shouldHighlight(logData.rtom),
      ),
      CustomOneDetailsCard(
        title: "Station",
        titleResponse: logData.station ?? 'N/A',
        shouldHighlight: shouldHighlight(logData.station),
      ),
      CustomOneDetailsCard(
        title: "RTOM Building ID",
        titleResponse: logData.rtomBuildingId ?? 'N/A',
        shouldHighlight: shouldHighlight(logData.rtomBuildingId),
      ),
      CustomOneDetailsCard(
        title: "Floor Number",
        titleResponse: logData.floorNumber ?? 'N/A',
        shouldHighlight: shouldHighlight(logData.floorNumber),
      ),
      CustomOneDetailsCard(
        title: "Office Number",
        titleResponse: logData.officeNumber ?? 'N/A',
        shouldHighlight: shouldHighlight(logData.officeNumber),
      ),
      CustomOneDetailsCard(
        title: "Location",
        titleResponse: logData.location,
        shouldHighlight: shouldHighlight(logData.location),
      ),
      CustomOneDetailsCard(
        title: "QR",
        titleResponse: indoorData.qrIn,
        shouldHighlight: shouldHighlight(indoorData.qrIn),
      ),
      CustomOneDetailsCard(
        title: "Number of AC Plants",
        titleResponse: logData.noAcPlants,
        shouldHighlight: shouldHighlight(logData.noAcPlants),
      ),
      CustomOneDetailsCard(
        title: "Category",
        titleResponse: indoorData.category,
        shouldHighlight: shouldHighlight(indoorData.category),
      ),
      CustomOneDetailsCard(
        title: "Brand",
        titleResponse: indoorData.brand,
        shouldHighlight: shouldHighlight(indoorData.brand),
      ),
      CustomOneDetailsCard(
        title: "Model",
        titleResponse: indoorData.model,
        shouldHighlight: shouldHighlight(indoorData.model),
      ),
      CustomOneDetailsCard(
        title: "Capacity",
        titleResponse: indoorData.capacity,
        shouldHighlight: shouldHighlight(indoorData.capacity),
      ),
      CustomOneDetailsCard(
        title: "Type",
        titleResponse: indoorData.type,
        shouldHighlight: shouldHighlight(indoorData.type),
      ),
      CustomOneDetailsCard(
        title: "Serial Number",
        titleResponse: indoorData.serialNumber,
        shouldHighlight: shouldHighlight(indoorData.serialNumber),
      ),
      CustomOneDetailsCard(
        title: "Installation Type",
        titleResponse: indoorData.installationType,
        shouldHighlight: shouldHighlight(indoorData.installationType),
      ),
      CustomOneDetailsCard(
        title: "Refrigerant Type",
        titleResponse: indoorData.refrigerantType,
        shouldHighlight: shouldHighlight(indoorData.refrigerantType),
      ),
      CustomOneDetailsCard(
        title: "Power Supply",
        titleResponse: indoorData.powerSupply,
        shouldHighlight: shouldHighlight(indoorData.powerSupply),
      ),
      CustomOneDetailsCard(
        title: "Installation Date",
        titleResponse: indoorData.installationDate,
        shouldHighlight: shouldHighlight(indoorData.installationDate),
      ),
      CustomOneDetailsCard(
        title: "Last Updated",
        titleResponse: indoorData.lastUpdated,
        shouldHighlight: shouldHighlight(indoorData.lastUpdated),
      ),
      CustomOneDetailsCard(
        title: "Date of Manufacture",
        titleResponse: indoorData.dateOfManufacture,
        shouldHighlight: shouldHighlight(indoorData.dateOfManufacture),
      ),
      CustomOneDetailsCard(
        title: "Condition ID Unit",
        titleResponse: indoorData.conditionIdUnit,
        shouldHighlight: shouldHighlight(indoorData.conditionIdUnit),
      ),
      // CustomOneDetailsCard(
      //   title: "Comfort Precision",
      //   titleResponse: logData.comfortPrecision,
      // ),
      CustomOneDetailsCard(
        title: "Supplier Name",
        titleResponse: indoorData.supplierName ?? 'N/A',
        shouldHighlight: shouldHighlight(indoorData.supplierName),
      ),
      CustomOneDetailsCard(
        title: "PO Number",
        titleResponse: indoorData.poNumber ?? 'N/A',
        shouldHighlight: shouldHighlight(indoorData.poNumber),
      ),
      CustomOneDetailsCard(
        title: "Remote Available",
        titleResponse: indoorData.remoteAvailable ?? 'N/A',
        shouldHighlight: shouldHighlight(indoorData.remoteAvailable),
      ),
      CustomOneDetailsCard(
        title: "Notes",
        titleResponse: indoorData.notes ?? 'N/A',
        shouldHighlight: shouldHighlight(indoorData.notes),
      ),
      CustomOneDetailsCard(
        title: "Status",
        titleResponse: indoorData.status ?? 'N/A',
        shouldHighlight: shouldHighlight(indoorData.status),
      ),
      CustomOneDetailsCard(
        title: "Warranty Expiry Date",
        titleResponse: indoorData.warrantyExpiryDate ?? 'N/A',
        shouldHighlight: shouldHighlight(indoorData.warrantyExpiryDate),
      ),
    ],
  );
}

Widget outDoorList(AcOutdoorData outdoorData, String searchQuery) {
  bool shouldHighlight(String? value) {
    if (value == null || searchQuery.isEmpty) return false;
    return value.toLowerCase().contains(searchQuery.toLowerCase());
  }

  return
  //  AcOutdoorData == null
  //     ? Center(child: Text("Not Submitted Those datas Yet"))
  //     :
  Column(
    children: [
      CustomOneDetailsCard(
        title: "AC Outdoor ID",
        titleResponse: outdoorData.acOutdoorId ?? 'N/A',
        shouldHighlight: shouldHighlight(outdoorData.acOutdoorId),
      ),
      CustomOneDetailsCard(
        title: "QR",
        titleResponse: outdoorData.qrOut,
        shouldHighlight: shouldHighlight(outdoorData.qrOut),
      ),
      CustomOneDetailsCard(
        title: "Brand",
        titleResponse: outdoorData.brand ?? "N/A",
        shouldHighlight: shouldHighlight(outdoorData.brand),
      ),
      CustomOneDetailsCard(
        title: "Model",
        titleResponse: outdoorData.model ?? 'N/A',
        shouldHighlight: shouldHighlight(outdoorData.model),
      ),
      CustomOneDetailsCard(
        title: "Capacity",
        titleResponse: outdoorData.capacity ?? 'N/A',
        shouldHighlight: shouldHighlight(outdoorData.capacity),
      ),
      CustomOneDetailsCard(
        title: "Outdoor Fan Model",
        titleResponse: outdoorData.outdoorFanModel ?? 'N/A',
        shouldHighlight: shouldHighlight(outdoorData.outdoorFanModel),
      ),
      CustomOneDetailsCard(
        title: "Out Door Fan Unit",
        titleResponse: outdoorData.outdoorFanModel,
        shouldHighlight: shouldHighlight(outdoorData.outdoorFanModel),
      ),
      CustomOneDetailsCard(
        title: "Power Supply",
        titleResponse: outdoorData.powerSupply ?? 'N/A',
        shouldHighlight: shouldHighlight(outdoorData.powerSupply),
      ),
      CustomOneDetailsCard(
        title: "Compressor Mounted With",
        titleResponse: outdoorData.compressorMountedWith ?? 'N/A',
        shouldHighlight: shouldHighlight(outdoorData.compressorMountedWith),
      ),
      CustomOneDetailsCard(
        title: "Compressor Capacity",
        titleResponse: outdoorData.compressorCapacity ?? 'N/A',
        shouldHighlight: shouldHighlight(outdoorData.compressorCapacity),
      ),
      CustomOneDetailsCard(
        title: "Compressor Brand",
        titleResponse: outdoorData.compressorBrand ?? 'N/A',
        shouldHighlight: shouldHighlight(outdoorData.compressorBrand),
      ),
      CustomOneDetailsCard(
        title: "Compressor Model",
        titleResponse: outdoorData.compressorModel ?? 'N/A',
        shouldHighlight: shouldHighlight(outdoorData.compressorModel),
      ),
      CustomOneDetailsCard(
        title: "Compressor Serial Number",
        titleResponse: outdoorData.compressorSerialNumber ?? 'N/A',
        shouldHighlight: shouldHighlight(outdoorData.compressorSerialNumber),
      ),
      CustomOneDetailsCard(
        title: "Supplier Name",
        titleResponse: outdoorData.supplierName ?? 'N/A',
        shouldHighlight: shouldHighlight(outdoorData.supplierName),
      ),
      CustomOneDetailsCard(
        title: "PO Number",
        titleResponse: outdoorData.poNumber ?? 'N/A',
        shouldHighlight: shouldHighlight(outdoorData.poNumber),
      ),
      CustomOneDetailsCard(
        title: "Notes",
        titleResponse: outdoorData.notes ?? 'N/A',
        shouldHighlight: shouldHighlight(outdoorData.notes),
      ),
      CustomOneDetailsCard(
        title: "Last Updated",
        titleResponse: outdoorData.lastUpdated ?? 'N/A',
        shouldHighlight: shouldHighlight(outdoorData.lastUpdated),
      ),
      CustomOneDetailsCard(
        title: "Status",
        titleResponse: outdoorData.status ?? 'N/A',
        shouldHighlight: shouldHighlight(outdoorData.status),
      ),
      CustomOneDetailsCard(
        title: "Warranty Expiry Date",
        titleResponse: outdoorData.warrantyExpiryDate ?? 'N/A',
        shouldHighlight: shouldHighlight(outdoorData.warrantyExpiryDate),
      ),
      CustomOneDetailsCard(
        title: "Condition OD Unit",
        titleResponse: outdoorData.conditionOdUnit ?? 'N/A',
        shouldHighlight: shouldHighlight(outdoorData.conditionOdUnit),
      ),
      CustomOneDetailsCard(
        title: "Date of Manufacture",
        titleResponse: outdoorData.dateOfManufacture ?? 'N/A',
        shouldHighlight: shouldHighlight(outdoorData.dateOfManufacture),
      ),
      CustomOneDetailsCard(
        title: "Installation Date",
        titleResponse: outdoorData.installationDate ?? 'N/A',
        shouldHighlight: shouldHighlight(outdoorData.installationDate),
      ),
    ],
  );
}



//v2
// import 'package:flutter/material.dart';
//
// // import '../../../HomePage/utils/colors.dart';
// import '../../../HomePage/widgets/colors.dart';
// import 'ac_details_model.dart';
//
// class ViewComfortACUnit extends StatefulWidget {
//   final AcIndoorData? indoorData;
//   final AcOutdoorData? outdoorData;
//   final AcLogData logData;
//
//   const ViewComfortACUnit({
//     super.key,
//     required this.indoorData,
//     required this.outdoorData,
//     required this.logData,
//   });
//
//   @override
//   State<ViewComfortACUnit> createState() => _ViewComfortACUnitState();
// }
//
// class _ViewComfortACUnitState extends State<ViewComfortACUnit> {
//   int currentState = 0;
//   List<Widget> listData = [];
//
//   @override
//   void initState() {
//     super.initState();
//     listData = [
//       indoorList(widget.indoorData, widget.logData),
//       widget.outdoorData == null
//           ? Center(child: Text("Not Submitted Those datas Yet"))
//           : outDoorList(widget.outdoorData!),
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('AC  Detail', style: TextStyle(color: mainTextColor)),
//         backgroundColor: appbarColor,
//       ),
//       body: Container(
//         color: mainBackgroundColor,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.07,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(18),
//                   color: suqarBackgroundColor,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           currentState = 0;
//                           debugPrint(currentState.toString());
//                         });
//                       },
//                       child: Container(
//                         height: MediaQuery.of(context).size.height * 0.055,
//                         width: MediaQuery.of(context).size.width * 0.45,
//                         decoration: BoxDecoration(
//                           color:
//                           currentState == 0
//                               ? Colors.grey
//                               : suqarBackgroundColor,
//                           borderRadius: BorderRadius.circular(18),
//                         ),
//                         child: const Center(
//                           child: Text(
//                             "INDOOR",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: mainTextColor,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           currentState = 1;
//                           debugPrint(currentState.toString());
//                         });
//                       },
//                       child: Container(
//                         height: MediaQuery.of(context).size.height * 0.055,
//                         width: MediaQuery.of(context).size.width * 0.45,
//                         decoration: BoxDecoration(
//                           color:
//                           currentState == 1
//                               ? Colors.grey
//                               : suqarBackgroundColor,
//                           borderRadius: BorderRadius.circular(18),
//                         ),
//                         child: const Center(
//                           child: Text(
//                             "OUTDOOR",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: mainTextColor,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 5),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       Card(
//                         color: suqarBackgroundColor,
//                         child: ListTile(
//                           title: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 widget.indoorData!.acIndoorId,
//                                 style: const TextStyle(color: mainTextColor),
//                               ),
//                               widget.outdoorData != null
//                                   ? Text(
//                                 "${widget.outdoorData!.acOutdoorId}",
//                                 style: const TextStyle(color: mainTextColor),
//                               )
//                                   : const Text(""),
//                             ],
//                           ),
//                           subtitle: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'Region: ${widget.logData.region}',
//                                     style: const TextStyle(color: mainTextColor),
//                                   ),
//                                   Text(
//                                     'Brand: ${widget.indoorData!.brand ?? ""}',
//                                     style: const TextStyle(color: mainTextColor),
//                                   ),
//                                 ],
//                               ),
//                               Text(
//                                 'Location: ${widget.logData.location}',
//                                 style: const TextStyle(color: mainTextColor),
//                               ),
//                               Text(
//                                 "Last Updated: ${widget.indoorData!.lastUpdated ?? ""}",
//                                 style: const TextStyle(color: mainTextColor),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       listData[currentState],
//                     ],
//                   ),
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
// class CustomDetailsCard extends StatefulWidget {
//   const CustomDetailsCard({
//     super.key,
//     required this.title,
//     required this.titleResponse,
//   });
//
//   final String title;
//   final String? titleResponse;
//
//   @override
//   State<CustomDetailsCard> createState() => _CustomDetailsCardState();
// }
//
// class _CustomDetailsCardState extends State<CustomDetailsCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.only(
//           left: 15,
//           top: 20,
//           bottom: 20,
//           right: 15,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(widget.title),
//             widget.title == "Condition ID Unit"
//                 ? widget.titleResponse == "Good"
//                 ? Row(
//               children: [
//                 Text(widget.titleResponse ?? ""),
//                 const Icon(Icons.check_circle, color: Colors.green),
//               ],
//             )
//                 : Row(
//               children: [
//                 Text(widget.titleResponse ?? ""),
//                 const Icon(Icons.cancel, color: Colors.red),
//               ],
//             )
//                 : Text(widget.titleResponse ?? ""),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// Widget indoorList(AcIndoorData? indoorData, AcLogData logData) {
//   return Column(
//     children: [
//       CustomOneDetailsCard(
//         title: "AC Indoor ID",
//         titleResponse: indoorData!.acIndoorId,
//       ),
//       CustomOneDetailsCard(title: "Region", titleResponse: logData.region),
//       CustomOneDetailsCard(title: "RTOM", titleResponse: logData.rtom),
//       CustomOneDetailsCard(
//         title: "Station",
//         titleResponse: logData.station ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "RTOM Building ID",
//         titleResponse: logData.rtomBuildingId ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Floor Number",
//         titleResponse: logData.floorNumber ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Office Number",
//         titleResponse: logData.officeNumber ?? 'N/A',
//       ),
//       CustomOneDetailsCard(title: "Location", titleResponse: logData.location),
//       CustomOneDetailsCard(title: "QR", titleResponse: indoorData.qrIn),
//       CustomOneDetailsCard(
//         title: "Number of AC Plants",
//         titleResponse: logData.noAcPlants,
//       ),
//       CustomOneDetailsCard(
//         title: "Category",
//         titleResponse: indoorData.category,
//       ),
//       CustomOneDetailsCard(title: "Brand", titleResponse: indoorData.brand),
//       CustomOneDetailsCard(title: "Model", titleResponse: indoorData.model),
//       CustomOneDetailsCard(
//         title: "Capacity",
//         titleResponse: indoorData.capacity,
//       ),
//       CustomOneDetailsCard(title: "Type", titleResponse: indoorData.type),
//       CustomOneDetailsCard(
//         title: "Serial Number",
//         titleResponse: indoorData.serialNumber,
//       ),
//       CustomOneDetailsCard(
//         title: "Installation Type",
//         titleResponse: indoorData.installationType,
//       ),
//       CustomOneDetailsCard(
//         title: "Refrigerant Type",
//         titleResponse: indoorData.refrigerantType,
//       ),
//       CustomOneDetailsCard(
//         title: "Power Supply",
//         titleResponse: indoorData.powerSupply,
//       ),
//       CustomOneDetailsCard(
//         title: "Installation Date",
//         titleResponse: indoorData.installationDate,
//       ),
//       CustomOneDetailsCard(
//         title: "Last Updated",
//         titleResponse: indoorData.lastUpdated,
//       ),
//       CustomOneDetailsCard(
//         title: "Date of Manufacture",
//         titleResponse: indoorData.dateOfManufacture,
//       ),
//       CustomOneDetailsCard(
//         title: "Condition ID Unit",
//         titleResponse: indoorData.conditionIdUnit,
//       ),
//       CustomOneDetailsCard(
//         title: "Supplier Name",
//         titleResponse: indoorData.supplierName ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "PO Number",
//         titleResponse: indoorData.poNumber ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Remote Available",
//         titleResponse: indoorData.remoteAvailable ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Notes",
//         titleResponse: indoorData.notes ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Status",
//         titleResponse: indoorData.status ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Warranty Expiry Date",
//         titleResponse: indoorData.warrantyExpiryDate ?? 'N/A',
//       ),
//     ],
//   );
// }
//
// Widget outDoorList(AcOutdoorData outdoorData) {
//   return Column(
//     children: [
//       CustomOneDetailsCard(
//         title: "AC Outdoor ID",
//         titleResponse: outdoorData.acOutdoorId ?? 'N/A',
//       ),
//       CustomOneDetailsCard(title: "QR", titleResponse: outdoorData.qrOut),
//       CustomOneDetailsCard(
//         title: "Brand",
//         titleResponse: outdoorData.brand ?? "N/A",
//       ),
//       CustomOneDetailsCard(
//         title: "Model",
//         titleResponse: outdoorData.model ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Capacity",
//         titleResponse: outdoorData.capacity ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Outdoor Fan Model",
//         titleResponse: outdoorData.outdoorFanModel ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Out Door Fan Unit",
//         titleResponse: outdoorData.outdoorFanModel,
//       ),
//       CustomOneDetailsCard(
//         title: "Power Supply",
//         titleResponse: outdoorData.powerSupply ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Compressor Mounted With",
//         titleResponse: outdoorData.compressorMountedWith ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Compressor Capacity",
//         titleResponse: outdoorData.compressorCapacity ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Compressor Brand",
//         titleResponse: outdoorData.compressorBrand ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Compressor Model",
//         titleResponse: outdoorData.compressorModel ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Compressor Serial Number",
//         titleResponse: outdoorData.compressorSerialNumber ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Supplier Name",
//         titleResponse: outdoorData.supplierName ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "PO Number",
//         titleResponse: outdoorData.poNumber ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Notes",
//         titleResponse: outdoorData.notes ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Last Updated",
//         titleResponse: outdoorData.lastUpdated ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Status",
//         titleResponse: outdoorData.status ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Warranty Expiry Date",
//         titleResponse: outdoorData.warrantyExpiryDate ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Condition OD Unit",
//         titleResponse: outdoorData.conditionOdUnit ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Date of Manufacture",
//         titleResponse: outdoorData.dateOfManufacture ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Installation Date",
//         titleResponse: outdoorData.installationDate ?? 'N/A',
//       ),
//     ],
//   );
// }
//
// class CustomOneDetailsCard extends StatefulWidget {
//   const CustomOneDetailsCard({
//     super.key,
//     required this.title,
//     required this.titleResponse,
//   });
//
//   final String title;
//   final String? titleResponse;
//
//   @override
//   State<CustomOneDetailsCard> createState() => _CustomOneDetailsCardState();
// }
//
// class _CustomOneDetailsCardState extends State<CustomOneDetailsCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: suqarBackgroundColor,
//       child: Padding(
//         padding: const EdgeInsets.only(
//           left: 15,
//           top: 20,
//           bottom: 20,
//           right: 15,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               widget.title,
//               style: const TextStyle(color: mainTextColor),
//             ),
//             widget.title == "Condition ID Unit"
//                 ? widget.titleResponse == "Good"
//                 ? Row(
//               children: [
//                 Text(
//                   widget.titleResponse ?? "",
//                   style: const TextStyle(color: mainTextColor),
//                 ),
//                 const Icon(Icons.check_circle, color: Colors.green),
//               ],
//             )
//                 : Row(
//               children: [
//                 Text(
//                   widget.titleResponse ?? "",
//                   style: const TextStyle(color: mainTextColor),
//                 ),
//                 const Icon(Icons.cancel, color: Colors.red),
//               ],
//             )
//                 : Text(
//               widget.titleResponse ?? "",
//               style: const TextStyle(color: mainTextColor),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//


//v1
// import 'package:flutter/material.dart';
//
// import 'ac_details_model.dart';
//
// class ViewComfortACUnit extends StatefulWidget {
//   final AcIndoorData? indoorData;
//   final AcOutdoorData? outdoorData;
//   final AcLogData logData;
//
//   ViewComfortACUnit({
//     required this.indoorData,
//     required this.outdoorData,
//     required this.logData,
//   });
//
//   @override
//   State<ViewComfortACUnit> createState() => _ViewComfortACUnitState();
// }
//
// class _ViewComfortACUnitState extends State<ViewComfortACUnit> {
//   int currentState = 0;
//   List<Widget> listData = [];
//
//   @override
//   void initState() {
//     super.initState();
//     listData = [
//       indoorList(widget.indoorData, widget.logData),
//       widget.outdoorData == null
//           ? Center(child: Text("Not Submitted Those datas Yet"))
//           : outDoorList(widget.outdoorData!),
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('AC  Detail'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Container(
//               height: MediaQuery.of(context).size.height * 0.07,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(18),
//                 color: Colors.grey.shade100,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         currentState = 0;
//                         debugPrint(currentState.toString());
//                       });
//                     },
//                     child: Container(
//                       height: MediaQuery.of(context).size.height * 0.055,
//                       width: MediaQuery.of(context).size.width * 0.45,
//                       decoration: BoxDecoration(
//                         color: currentState == 0
//                             ? Colors.blue.shade300
//                             : Colors.grey.shade100,
//                         borderRadius: BorderRadius.circular(18),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           "INDOOR",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         currentState = 1;
//                         debugPrint(currentState.toString());
//                       });
//                     },
//                     child: Container(
//                       height: MediaQuery.of(context).size.height * 0.055,
//                       width: MediaQuery.of(context).size.width * 0.45,
//                       decoration: BoxDecoration(
//                         color: currentState == 1
//                             ? Colors.blue.shade300
//                             : Colors.grey.shade100,
//                         borderRadius: BorderRadius.circular(18),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           "OUTDOOR",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 5),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Card(
//                       child: ListTile(
//                         title: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("${widget.indoorData!.acIndoorId}"),
//                             widget.outdoorData != null
//                                 ? Text("${widget.outdoorData!.acOutdoorId}")
//                                 : const Text(""),
//                           ],
//                         ),
//                         subtitle: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text('Region: ${widget.logData.region}'),
//                                 Text(
//                                     'Brand: ${widget.indoorData!.brand ?? ""}'),
//                               ],
//                             ),
//                             Text('Location: ${widget.logData.location}'),
//                             Text(
//                                 "Last Updated: ${widget.indoorData!.lastUpdated ?? ""}"),
//                           ],
//                         ),
//                       ),
//                     ),
//                     listData[currentState],
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class CustomOneDetailsCard extends StatefulWidget {
//   const CustomOneDetailsCard(
//       {super.key, required this.title, required this.titleResponse});
//
//   final String title;
//   final String? titleResponse;
//
//   @override
//   State<CustomOneDetailsCard> createState() => _CustomOneDetailsCardState();
// }
//
// class _CustomOneDetailsCardState extends State<CustomOneDetailsCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding:
//             const EdgeInsets.only(left: 15, top: 20, bottom: 20, right: 15),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(widget.title),
//             widget.title == "Condition ID Unit"
//                 ? widget.titleResponse == "Good"
//                     ? Row(
//                         children: [
//                           Text(widget.titleResponse ?? ""),
//                           const Icon(
//                             Icons.check_circle,
//                             color: Colors.green,
//                           )
//                         ],
//                       )
//                     : Row(
//                         children: [
//                           Text(widget.titleResponse ?? ""),
//                           const Icon(
//                             Icons.cancel,
//                             color: Colors.red,
//                           )
//                         ],
//                       )
//                 : Text(widget.titleResponse ?? ""),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// Widget indoorList(AcIndoorData? indoorData, AcLogData logData) {
//   return Column(
//     children: [
//       CustomOneDetailsCard(
//         title: "AC Indoor ID",
//         titleResponse: indoorData!.acIndoorId,
//       ),
//       CustomOneDetailsCard(
//         title: "Region",
//         titleResponse: logData.region,
//       ),
//       CustomOneDetailsCard(
//         title: "RTOM",
//         titleResponse: logData.rtom,
//       ),
//       CustomOneDetailsCard(
//         title: "Station",
//         titleResponse: logData.station ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "RTOM Building ID",
//         titleResponse: logData.rtomBuildingId ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Floor Number",
//         titleResponse: logData.floorNumber ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Office Number",
//         titleResponse: logData.officeNumber ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Location",
//         titleResponse: logData.location,
//       ),
//       CustomOneDetailsCard(
//         title: "QR",
//         titleResponse: indoorData.qrIn,
//       ),
//       CustomOneDetailsCard(
//         title: "Number of AC Plants",
//         titleResponse: logData.noAcPlants,
//       ),
//       CustomOneDetailsCard(
//         title: "Category",
//         titleResponse: indoorData.category,
//       ),
//       CustomOneDetailsCard(
//         title: "Brand",
//         titleResponse: indoorData.brand,
//       ),
//       CustomOneDetailsCard(
//         title: "Model",
//         titleResponse: indoorData.model,
//       ),
//       CustomOneDetailsCard(
//         title: "Capacity",
//         titleResponse: indoorData.capacity,
//       ),
//       CustomOneDetailsCard(title: "Type", titleResponse: indoorData.type),
//       CustomOneDetailsCard(
//         title: "Serial Number",
//         titleResponse: indoorData.serialNumber,
//       ),
//       CustomOneDetailsCard(
//         title: "Installation Type",
//         titleResponse: indoorData.installationType,
//       ),
//       CustomOneDetailsCard(
//         title: "Refrigerant Type",
//         titleResponse: indoorData.refrigerantType,
//       ),
//       CustomOneDetailsCard(
//         title: "Power Supply",
//         titleResponse: indoorData.powerSupply,
//       ),
//       CustomOneDetailsCard(
//         title: "Installation Date",
//         titleResponse: indoorData.installationDate,
//       ),
//       CustomOneDetailsCard(
//         title: "Last Updated",
//         titleResponse: indoorData.lastUpdated,
//       ),
//       CustomOneDetailsCard(
//         title: "Date of Manufacture",
//         titleResponse: indoorData.dateOfManufacture,
//       ),
//       CustomOneDetailsCard(
//         title: "Condition ID Unit",
//         titleResponse: indoorData.conditionIdUnit,
//       ),
//       // CustomOneDetailsCard(
//       //   title: "Comfort Precision",
//       //   titleResponse: logData.comfortPrecision,
//       // ),
//       CustomOneDetailsCard(
//         title: "Supplier Name",
//         titleResponse: indoorData.supplierName ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "PO Number",
//         titleResponse: indoorData.poNumber ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Remote Available",
//         titleResponse: indoorData.remoteAvailable ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Notes",
//         titleResponse: indoorData.notes ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Status",
//         titleResponse: indoorData.status ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Warranty Expiry Date",
//         titleResponse: indoorData.warrantyExpiryDate ?? 'N/A',
//       ),
//     ],
//   );
// }
//
// Widget outDoorList(AcOutdoorData outdoorData) {
//   return
//       //  AcOutdoorData == null
//       //     ? Center(child: Text("Not Submitted Those datas Yet"))
//       //     :
//       Column(
//     children: [
//       CustomOneDetailsCard(
//         title: "AC Outdoor ID",
//         titleResponse: outdoorData.acOutdoorId ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "QR",
//         titleResponse: outdoorData.qrOut,
//       ),
//       CustomOneDetailsCard(
//         title: "Brand",
//         titleResponse: outdoorData.brand ?? "N/A",
//       ),
//       CustomOneDetailsCard(
//         title: "Model",
//         titleResponse: outdoorData.model ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Capacity",
//         titleResponse: outdoorData.capacity ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Outdoor Fan Model",
//         titleResponse: outdoorData.outdoorFanModel ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Out Door Fan Unit",
//         titleResponse: outdoorData.outdoorFanModel,
//       ),
//       CustomOneDetailsCard(
//         title: "Power Supply",
//         titleResponse: outdoorData.powerSupply ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Compressor Mounted With",
//         titleResponse: outdoorData.compressorMountedWith ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Compressor Capacity",
//         titleResponse: outdoorData.compressorCapacity ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Compressor Brand",
//         titleResponse: outdoorData.compressorBrand ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Compressor Model",
//         titleResponse: outdoorData.compressorModel ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Compressor Serial Number",
//         titleResponse: outdoorData.compressorSerialNumber ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Supplier Name",
//         titleResponse: outdoorData.supplierName ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "PO Number",
//         titleResponse: outdoorData.poNumber ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Notes",
//         titleResponse: outdoorData.notes ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Last Updated",
//         titleResponse: outdoorData.lastUpdated ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Status",
//         titleResponse: outdoorData.status ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Warranty Expiry Date",
//         titleResponse: outdoorData.warrantyExpiryDate ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Condition OD Unit",
//         titleResponse: outdoorData.conditionOdUnit ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Date of Manufacture",
//         titleResponse: outdoorData.dateOfManufacture ?? 'N/A',
//       ),
//       CustomOneDetailsCard(
//         title: "Installation Date",
//         titleResponse: outdoorData.installationDate ?? 'N/A',
//       ),
//     ],
//   );
// }
