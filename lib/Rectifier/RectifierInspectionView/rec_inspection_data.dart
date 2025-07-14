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
  });

  factory RecInspectionData.fromJson(Map<String, dynamic> json) {
    return RecInspectionData(
      id: json['DailyRECCheckID'] ?? '',
      userName: json['userName'] ?? '',
      recId: json['recId'] ?? '',
      clockTime: json['clockTime'] ?? '',
      shift: json['shift'] ?? '',
      region: json['region'] ?? '',
      room: json['room'] ?? '',
      roomClean: json['roomClean'] ?? '',
      cubicleClean: json['cubicleClean'] ?? '',
      roomTemp: json['roomTemp'] ?? '',
      h2gasEmission: json['h2gasEmission'] ?? '',
      checkMCB: json['checkMCB'] ?? '',
      dcPDB: json['dcPDB'] ?? '',
      remoteAlarm: json['remoteAlarm'] ?? '',
      noOfWorkingLine: json['noOfWorkingLine'] ?? '',
      capacity: json['capacity'] ?? '',
      type: json['type'] ?? '',
      voltagePs1: json['voltagePs1'] ?? '',
      voltagePs2: json['voltagePs2'] ?? '',
      voltagePs3: json['voltagePs3'] ?? '',
      currentPs1: json['currentPs1'] ?? '',
      currentPs2: json['currentPs2'] ?? '',
      currentPs3: json['currentPs3'] ?? '',
      dcVoltage: json['dcVoltage'] ?? '',
      dcCurrent: json['dcCurrent'] ?? '',
      recCapacity: json['recCapacity'] ?? '',
      recAlarmStatus: json['recAlarmStatus'] ?? '',
      recIndicatorStatus: json['recIndicatorStatus'] ?? '',
      remarkId: json["DailyRECRemarkID"] ?? '',
      problemStatus: json['problemStatus']??'0'
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
  });

  factory RecRemarkData.fromJson(Map<String, dynamic> json) {
    return RecRemarkData(
      id: json['DailyRECRemarkID'] ?? '',
      roomCleanRemark: json['roomCleanRemark'] ?? '',
      cubicleCleanRemark: json['CubicleCleanRemark'] ?? '',
      roomTempRemark: json['roomTempRemark'] ?? '',
      h2gasEmissionRemark: json['h2gasEmissionRemark'] ?? '',
      checkMCBRemark: json['checkMCBRemark'] ?? '',
      dcPDBRemark: json['dcPDBRemark'] ?? '',
      remoteAlarmRemark: json['remoteAlarmRemark'] ?? '',
      recAlarmRemark: json['recAlarmRemark'] ?? '',
      indRemark: json['indRemark'] ?? '',
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
      recID: json['RecID'] ?? "",
      region: json['Region'] ?? "",
      rtom: json['RTOM'] ?? "",
      station: json['Station'] ?? "",
      brand: json['Brand'] ?? "",
      model: json['Model'] ?? "",
      Latitude: json['Latitude'] != null
        ? double.tryParse(json['Latitude'].toString())
        : null,
    Longitude: json['Longitude'] != null
        ? double.tryParse(json['Longitude'].toString())
        : null,
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
