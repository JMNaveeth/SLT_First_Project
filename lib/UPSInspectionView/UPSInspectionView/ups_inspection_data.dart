class UpsInspectionData {
  final String id;
  final String userName;
  final String recId;
  final String clockTime;
  final String shift;
  final String region;
  final String ventilation;
  final String cabinTemp;
  final String h2GasEmission;
  final String dust;
  final String batClean;
  final String trmVolt;
  final String leak;
  final String mimicLED;
  final String meterPara;
  final String warningAlarm;
  final String overHeat;
  final String voltagePs1;
  final String voltagePs2;
  final String voltagePs3;
  final String currentPs1;
  final String currentPs2;
  final String currentPs3;
  final String upsCapacity;
  final String remarkId;
  final String? problemStatus;
  final double? latitude;
  final double? longitude;

  UpsInspectionData({
    required this.id,
    required this.userName,
    required this.recId,
    required this.clockTime,
    required this.shift,
    required this.region,
    required this.ventilation,
    required this.cabinTemp,
    required this.h2GasEmission,
    required this.dust,
    required this.batClean,
    required this.trmVolt,
    required this.leak,
    required this.mimicLED,
    required this.meterPara,
    required this.warningAlarm,
    required this.overHeat,
    required this.voltagePs1,
    required this.voltagePs2,
    required this.voltagePs3,
    required this.currentPs1,
    required this.currentPs2,
    required this.currentPs3,
    required this.upsCapacity,
    required this.remarkId,
    required this.problemStatus,
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  factory UpsInspectionData.fromJson(Map<String, dynamic> json) {
    return UpsInspectionData(
      id: json['DailyRECCheckID'] ?? '',
      userName: json['userName'] ?? '',
      recId: json['recId'] ?? '',
      clockTime: json['clockTime'] ?? '',
      shift: json['shift'] ?? '',
      region: json['location'] ?? '',
      ventilation: json['ventilation'] ?? '',
      cabinTemp: json['cabinTemp'] ?? '',
      h2GasEmission: json['h2GasEmission'] ?? '',
      dust: json['dust'] ?? '',
      batClean: json['batClean'] ?? '',
      trmVolt: json['trmVolt'] ?? '',
      leak: json['leak'] ?? '',
      mimicLED: json['mimicLED'] ?? '',
      meterPara: json['meterPara'] ?? '',
      warningAlarm: json['warningAlarm'] ?? '',
      overHeat: json['overHeat'] ?? '',
      voltagePs1: json['voltagePs1'] ?? '',
      voltagePs2: json['voltagePs2'] ?? '',
      voltagePs3: json['voltagePs3'] ?? '',
      currentPs1: json['currentPs1'] ?? '',
      currentPs2: json['currentPs2'] ?? '',
      currentPs3: json['currentPs3'] ?? '',
      upsCapacity: json['upsCapacity'] ?? '',
      remarkId: json["DailyUPSRemarksID"] ?? '',
      problemStatus: json["problemStatus"]??"0",
      latitude: json['latitude'] != null ? double.parse(json['latitude'].toString()) : 0.0,
      longitude: json['longitude'] != null ? double.parse(json['longitude'].toString()) : 0.0,
    );  }
}

class UpsRemarkData {
  final String id;
  final String ventilationRemark;
  final String cabinTempRemark;
  final String h2GasEmissionRemark;
  final String dustRemark;
  final String batCleanRemark;
  final String trmVoltRemark;
  final String leakRemark;
  final String mimicLEDRemark;
  final String meterParaRemark;
  final String warningAlarmRemark;
  final String overHeatRemark;
  final String addiRemark;

  UpsRemarkData({
    required this.id,
    required this.ventilationRemark,
    required this.cabinTempRemark,
    required this.h2GasEmissionRemark,
    required this.dustRemark,
    required this.batCleanRemark,
    required this.trmVoltRemark,
    required this.leakRemark,
    required this.mimicLEDRemark,
    required this.meterParaRemark,
    required this.warningAlarmRemark,
    required this.overHeatRemark,
    required this.addiRemark,
  });

  factory UpsRemarkData.fromJson(Map<String, dynamic> json) {
    return UpsRemarkData(
      id: json['DailyUPSRemarksID'] ?? '',
      ventilationRemark: json['ventilationRemark'] ?? '',
      cabinTempRemark: json['cabinTempRemark'] ?? '',
      h2GasEmissionRemark: json['h2GasEmissionRemark'] ?? '',
      dustRemark: json['dustRemark'] ?? '',
      batCleanRemark: json['batCleanRemark'] ?? '',
      trmVoltRemark: json['trmVoltRemark'] ?? '',
      leakRemark: json['leakRemark'] ?? '',
      mimicLEDRemark: json['mimicLEDRemark'] ?? '',
      meterParaRemark: json['meterParaRemark'] ?? '',
      warningAlarmRemark: json['warningAlarmRemark'] ?? '',
      overHeatRemark: json['overHeatRemark'] ?? '',
      addiRemark: json['addiRemark'] ?? '',
    );
  }
}

class UPSDetails {
  String upsID;
  String region;
  String rtom;
  String station;
  String brand;
  String model;

  double? latitude;
  double? longitude;

  UPSDetails({
    required this.upsID,
    required this.region,
    required this.rtom,
    required this.station,
    required this.brand,
    required this.model,
    required this.latitude,
    required this.longitude,
  });

  factory UPSDetails.fromJson(Map<String, dynamic> json) {
    return UPSDetails(
      upsID: json['upsID'] ?? "",
      region: json['Region'] ?? "",
      rtom: json['RTOM'] ?? "",
      station: json['Station'] ?? "",
      brand: json['Brand'] ?? "",
      model: json['Model'] ?? "",
       latitude: json['latitude'] != null ? 
        double.tryParse(json['latitude'].toString()) : null,
    longitude: json['longitude'] != null ? 
        double.tryParse(json['longitude'].toString()) : null,
  );
  }

  Map<String, dynamic> toJson() {
    return {
      'upsID': upsID,
      'Region': region,
      'RTOM': rtom,
      'Station': station,
      'Brand': brand,
      'Model': model,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
