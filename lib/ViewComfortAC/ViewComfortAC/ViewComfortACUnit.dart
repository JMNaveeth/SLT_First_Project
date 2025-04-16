import 'package:flutter/material.dart';

import '../../utils/utils/colors.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('AC Detail', style: TextStyle(color: mainTextColor)),
        backgroundColor: appbarColor,
        iconTheme: IconThemeData(
          color: mainTextColor,
        ),
      ),
      body: Container(
        color: mainBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: suqarBackgroundColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          currentState = 0;
                          debugPrint(currentState.toString());
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.055,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          color: currentState == 0
                              ? Colors.grey
                              : suqarBackgroundColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Center(
                          child: Text(
                            "INDOOR",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: mainTextColor),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          currentState = 1;
                          debugPrint(currentState.toString());
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.055,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          color: currentState == 1
                              ? Colors.grey
                              : suqarBackgroundColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Center(
                          child: Text(
                            "OUTDOOR",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: mainTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        color: suqarBackgroundColor,
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${widget.indoorData!.acIndoorId}",
                                style: TextStyle(color: mainTextColor),
                              ),
                              widget.outdoorData != null
                                  ? Text(
                                      "${widget.outdoorData!.acOutdoorId}",
                                      style: TextStyle(color: mainTextColor),
                                    )
                                  : const Text(""),
                            ],
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Region: ${widget.logData.region}',
                                    style: TextStyle(color: mainTextColor),
                                  ),
                                  Text(
                                    'Brand: ${widget.indoorData!.brand ?? ""}',
                                    style: TextStyle(color: mainTextColor),
                                  ),
                                ],
                              ),
                              Text(
                                'Location: ${widget.logData.location}',
                                style: TextStyle(color: mainTextColor),
                              ),
                              Text(
                                "Last Updated: ${widget.indoorData!.lastUpdated ?? ""}",
                                style: TextStyle(color: mainTextColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      listData[currentState],
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
    return Card(
      color: suqarBackgroundColor,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, top: 20, bottom: 20, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: TextStyle(color: mainTextColor),
            ),
            widget.title == "Condition ID Unit"
                ? widget.titleResponse == "Good"
                    ? Row(
                        children: [
                          Container(
                            color:
                                widget.shouldHighlight ? highlightColor : null,
                            child: Text(
                              widget.titleResponse ?? "",
                              style: TextStyle(color: mainTextColor),
                            ),
                          ),
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        ],
                      )
                    : Row(
                        children: [
                          Container(
                            color:
                                widget.shouldHighlight ? highlightColor : null,
                            child: Text(
                              widget.titleResponse ?? "",
                              style: TextStyle(color: mainTextColor),
                            ),
                          ),
                          const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          )
                        ],
                      )
                : Container(
                    color: widget.shouldHighlight ? highlightColor : null,
                    child: Text(
                      widget.titleResponse ?? "",
                      style: TextStyle(color: mainTextColor),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

Widget indoorList(
    AcIndoorData? indoorData, AcLogData logData, String searchQuery) {
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
