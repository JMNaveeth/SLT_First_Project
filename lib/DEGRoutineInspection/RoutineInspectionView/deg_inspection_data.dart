class DegInspectionData {
  final String DailyDEGCheckID;
  final String username;
  final String degId;
  final String clockTime;
  final String shift;
  final String region;
  final String degClean;
  final String surroundClean;
  final String alarm;
  final String warning;
  final String issue;
  final String leak;
  final String waterLevel;
  final String exterior;
  final String fuelLeak;
  final String airFilter;
  final String gasEmission;
  final String oilLeak;
  final String tankLeak;
  final String tankSwell;
  final String batClean;
  final String batVoltage;
  final String batCharger;
  final String? bat1;
  final String? bat2;
  final String? bat3;
  final String? bat4;
  final String? problemStatus;
  final String DailyDEGRemarkID;
  final String last_updated;

  DegInspectionData({
    required this.DailyDEGCheckID,
    required this.username,
    required this.degId,
    required this.clockTime,
    required this.shift,
    required this.region,
    required this.degClean,
    required this.surroundClean,
    required this.alarm,
    required this.warning,
    required this.issue,
    required this.leak,
    required this.waterLevel,
    required this.exterior,
    required this.fuelLeak,
    required this.airFilter,
    required this.gasEmission,
    required this.oilLeak,
    required this.tankLeak,
    required this.tankSwell,
    required this.batClean,
    required this.batVoltage,
    required this.batCharger,
    this.bat1,
    this.bat2,
    this.bat3,
    this.bat4,
    this.problemStatus,
    required this.DailyDEGRemarkID,
    required this.last_updated,
  });

  factory DegInspectionData.fromJson(Map<String, dynamic> json) {
    return DegInspectionData(
      DailyDEGCheckID: json['DailyDEGCheckID'] ?? '',
      username: json['username'] ?? '',
      degId: json['degId'] ?? '',
      clockTime: json['clockTime'] ?? '',
      shift: json['shift'] ?? '',
      region: json['region'] ?? '',
      degClean: json['degClean'] ?? '',
      surroundClean: json['surroundClean'] ?? '',
      alarm: json['alarm'] ?? '',
      warning: json['warning'] ?? '',
      issue: json['issue'] ?? '',
      leak: json['leak'] ?? '',
      waterLevel: json['waterLevel'] ?? '',
      exterior: json['exterior'] ?? '',
      fuelLeak: json['fuelLeak'] ?? '',
      airFilter: json['airFilter'] ?? '',
      gasEmission: json['gasEmission'] ?? '',
      oilLeak: json['oilLeak'] ?? '',
      tankLeak: json['tankLeak'] ?? '',
      tankSwell: json['tankSwell'] ?? '',
      batClean: json['batClean'] ?? '',
      batVoltage: json['batVoltage'] ?? '',
      batCharger: json['batCharger'] ?? '',
      bat1: json['bat1'] ?? '',
      bat2: json['bat2'] ?? '',
      bat3: json['bat3'] ?? '',
      bat4: json['bat4'] ?? '',
      problemStatus: json["problemStatus"] ?? "0",
      DailyDEGRemarkID: json["DailyDEGRemarkID"] ?? '',
      last_updated: json['last_updated'] ?? '',
    );
  }
}

class DegRemarkData {
  final String DailyDEGRemarkID;
  final String degCleanRemark;
  final String surroundCleanRemark;
  final String vbeltRemark;
  final String alarmRemark;
  final String warningRemark;
  final String issueRemark;
  final String leakRemark;
  final String waterLevelRemark;
  final String exteriorRemark;
  final String fuelLeakRemark;
  final String airFilterRemark;
  final String gasEmissionRemark;
  final String oilLeakRemark;
  final String batCleanRemark;
  final String batVoltageRemark;
  final String batChargerRemark;
  final String tankLeakRemark;
  final String tankSwellRemark;
  final String addiRemark;


  DegRemarkData({
    required this.DailyDEGRemarkID,
    required this.degCleanRemark,
    required this.surroundCleanRemark,
    required this.vbeltRemark,
    required this.alarmRemark,
    required this.warningRemark,
    required this.issueRemark,
    required this.leakRemark,
    required this.waterLevelRemark,
    required this.exteriorRemark,
    required this.fuelLeakRemark,
    required this.airFilterRemark,
    required this.gasEmissionRemark,
    required this.oilLeakRemark,
    required this.batCleanRemark,
    required this.batVoltageRemark,
    required this.batChargerRemark,
    required this.tankLeakRemark,
    required this.tankSwellRemark,
    required this.addiRemark,
  });

  factory DegRemarkData.fromJson(Map<String, dynamic> json) {
    return DegRemarkData(
      DailyDEGRemarkID: json['DailyDEGRemarkID'] ?? '',
      degCleanRemark: json['degCleanRemark'] ?? '',
      surroundCleanRemark: json['surroundCleanRemark'] ?? '',
      vbeltRemark: json['vbeltRemark'] ?? '',
      alarmRemark: json['alarmRemark'] ?? '',
      warningRemark: json['warningRemark'] ?? '',
      issueRemark: json['issueRemark'] ?? '',
      leakRemark: json['leakRemark'] ?? '',
      waterLevelRemark: json['waterLevelRemark'] ?? '',
      exteriorRemark: json['exteriorRemark'] ?? '',
      fuelLeakRemark: json['fuelLeakRemark'] ?? '',
      airFilterRemark: json['airFilterRemark'] ?? '',
      gasEmissionRemark: json['gasEmissionRemark'] ?? '',
      oilLeakRemark: json['oilLeakRemark'] ?? '',
      batCleanRemark: json['batCleanRemark'] ?? '',
      batVoltageRemark: json['batVoltageRemark'] ?? '',
      batChargerRemark: json['batChargerRemark'] ?? '',
      tankLeakRemark: json['tankLeakRemark'] ?? '',
      tankSwellRemark: json['tankSwellRemark'] ?? '',
      addiRemark: json['addiRemark'] ?? '',
    );
  }
}

class DEGDetails {
  String ID;
  String region;
  String rtom;
  String station;
  String brand_set;
  String serial_set;

  String? latitude;
  String? longitude;

  DEGDetails({
    required this.ID,
    required this.region,
    required this.rtom,
    required this.station,
    required this.brand_set,
    required this.serial_set,
    required this.latitude,
    required this.longitude,
  });

  factory DEGDetails.fromJson(Map<String, dynamic> json) {
    return DEGDetails(
      ID: json['ID'] ?? "",
      region: json['Region'] ?? "",
      rtom: json['RTOM'] ?? "",
      station: json['station'] ?? "",
      brand_set: json['brand_set'] ?? "",
      serial_set: json['serial_set'] ?? "",
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': ID,
      'Region': region,
      'RTOM': rtom,
      'station': station,
      'brand_set': brand_set,
      'serial_set': serial_set,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
