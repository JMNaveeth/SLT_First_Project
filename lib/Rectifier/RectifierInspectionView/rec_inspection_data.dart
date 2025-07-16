//import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

class RecInspectionData {
  final String id;
  final String userName;
  final String recId;
  final String clockTime;
  final String shift;
  final String region;
  final String room;
  final String roomClean;
  final String cubicleClean;
  final String roomTemp;
  final String h2gasEmission;
  final String checkMCB;
  final String dcPDB;
  final String remoteAlarm;
  final String noOfWorkingLine;
  final String capacity;
  final String type;
  final String voltagePs1;
  final String voltagePs2;
  final String voltagePs3;
  final String currentPs1;
  final String currentPs2;
  final String currentPs3;
  final String dcVoltage;
  final String dcCurrent;
  final String recCapacity;
  final String recAlarmStatus;
  final String recIndicatorStatus;
  final String remarkId;
  final String problemStatus;
  final double Latitude;
  final double Longitude;

  RecInspectionData({
    required this.id,
    required this.userName,
    required this.recId,
    required this.clockTime,
    required this.shift,
    required this.region,
    required this.room,
    required this.roomClean,
    required this.cubicleClean,
    required this.roomTemp,
    required this.h2gasEmission,
    required this.checkMCB,
    required this.dcPDB,
    required this.remoteAlarm,
    required this.noOfWorkingLine,
    required this.capacity,
    required this.type,
    required this.voltagePs1,
    required this.voltagePs2,
    required this.voltagePs3,
    required this.currentPs1,
    required this.currentPs2,
    required this.currentPs3,
    required this.dcVoltage,
    required this.dcCurrent,
    required this.recCapacity,
    required this.recAlarmStatus,
    required this.recIndicatorStatus,
    required this.remarkId,
    required this.problemStatus,
    required this.Latitude,
    required this.Longitude,
  });

  factory RecInspectionData.fromJson(Map<String, dynamic> json) {
    return RecInspectionData(
      id: json['DailyRECCheckID']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      recId: json['recId']?.toString() ?? '',
      clockTime: json['clockTime']?.toString() ?? '',
      shift: json['shift']?.toString() ?? '',
      region: json['region']?.toString() ?? '',
      room: json['room']?.toString() ?? '',
      roomClean: json['roomClean']?.toString() ?? '',
      cubicleClean: json['cubicleClean']?.toString() ?? '',
      roomTemp: json['roomTemp']?.toString() ?? '',
      h2gasEmission: json['h2gasEmission']?.toString() ?? '',
      checkMCB: json['checkMCB']?.toString() ?? '',
      dcPDB: json['dcPDB']?.toString() ?? '',
      remoteAlarm: json['remoteAlarm']?.toString() ?? '',
      noOfWorkingLine: json['noOfWorkingLine']?.toString() ?? '',
      capacity: json['capacity']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      voltagePs1: json['voltagePs1']?.toString() ?? '',
      voltagePs2: json['voltagePs2']?.toString() ?? '',
      voltagePs3: json['voltagePs3']?.toString() ?? '',
      currentPs1: json['currentPs1']?.toString() ?? '',
      currentPs2: json['currentPs2']?.toString() ?? '',
      currentPs3: json['currentPs3']?.toString() ?? '',
      dcVoltage: json['dcVoltage']?.toString() ?? '',
      dcCurrent: json['dcCurrent']?.toString() ?? '',
      recCapacity: json['recCapacity']?.toString() ?? '',
      recAlarmStatus: json['recAlarmStatus']?.toString() ?? '',
      recIndicatorStatus: json['recIndicatorStatus']?.toString() ?? '',
      remarkId: json["DailyRECRemarkID"]?.toString() ?? '',
      problemStatus: json['problemStatus']?.toString() ?? '0',
      Latitude:
          json['Latitude'] != null
              ? double.tryParse(json['Latitude'].toString()) ?? 0.0
              : 0.0,
      Longitude:
          json['Longitude'] != null
              ? double.tryParse(json['Longitude'].toString()) ?? 0.0
              : 0.0,
    );
  }
}

class RecRemarkData {
  final String id;
  final String roomCleanRemark;
  final String cubicleCleanRemark;
  final String roomTempRemark;
  final String h2gasEmissionRemark;
  final String checkMCBRemark;
  final String dcPDBRemark;
  final String remoteAlarmRemark;
  final String recAlarmRemark;
  final String indRemark;
  final double Latitude;
  final double Longitude;
  RecRemarkData({
    required this.id,
    required this.roomCleanRemark,
    required this.cubicleCleanRemark,
    required this.roomTempRemark,
    required this.h2gasEmissionRemark,
    required this.checkMCBRemark,
    required this.dcPDBRemark,
    required this.remoteAlarmRemark,
    required this.recAlarmRemark,
    required this.indRemark,
    required this.Latitude,
    required this.Longitude,
  });

  factory RecRemarkData.fromJson(Map<String, dynamic> json) {
    return RecRemarkData(
      id: json['DailyRECRemarkID']?.toString() ?? '',
      roomCleanRemark: json['roomCleanRemark']?.toString() ?? '',
      cubicleCleanRemark: json['CubicleCleanRemark']?.toString() ?? '',
      roomTempRemark: json['roomTempRemark']?.toString() ?? '',
      h2gasEmissionRemark: json['h2gasEmissionRemark']?.toString() ?? '',
      checkMCBRemark: json['checkMCBRemark']?.toString() ?? '',
      dcPDBRemark: json['dcPDBRemark']?.toString() ?? '',
      remoteAlarmRemark: json['remoteAlarmRemark']?.toString() ?? '',
      recAlarmRemark: json['recAlarmRemark']?.toString() ?? '',
      indRemark: json['indRemark']?.toString() ?? '',
      Latitude:
          json['Latitude'] != null
              ? double.tryParse(json['Latitude'].toString()) ?? 0.0
              : 0.0,
      Longitude:
          json['Longitude'] != null
              ? double.tryParse(json['Longitude'].toString()) ?? 0.0
              : 0.0,
    );
  }
}

class RectifierDetails {
  String recID;
  String region;
  String rtom;
  String station;
  String brand;
  String? model;

  double? Latitude;
  double? Longitude;

  RectifierDetails({
    required this.recID,
    required this.region,
    required this.rtom,
    required this.station,
    required this.brand,
    required this.model,
    required this.Latitude,
    required this.Longitude,
  });

  factory RectifierDetails.fromJson(Map<String, dynamic> json) {
    return RectifierDetails(
      recID: json['RecID']?.toString() ?? "",
      region: json['Region']?.toString() ?? "",
      rtom: json['RTOM']?.toString() ?? "",
      station: json['Station']?.toString() ?? "",
      brand: json['Brand']?.toString() ?? "",
      model: json['Model']?.toString(),
      Latitude:
          json['Latitude'] != null
              ? double.tryParse(json['Latitude'].toString()) ?? 0.0
              : 0.0,
      Longitude:
          json['Longitude'] != null
              ? double.tryParse(json['Longitude'].toString()) ?? 0.0
              : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RecID': recID,
      'Region': region,
      'RTOM': rtom,
      'Station': station,
      'Brand': brand,
      'Model': model,
      'Latitude': Latitude,
      'Longitude': Longitude,
    };
  }
}
