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
  final double Latitude;
  final double Longitude;

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
    required this.Latitude,
    required this.Longitude,
  });

  factory DegInspectionData.fromJson(Map<String, dynamic> json) {
    return DegInspectionData(
      DailyDEGCheckID: json['DailyDEGCheckID']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      degId: json['degId']?.toString() ?? '',
      clockTime: json['clockTime']?.toString() ?? '',
      shift: json['shift']?.toString() ?? '',
      region: json['region']?.toString() ?? '',
      degClean: json['degClean']?.toString() ?? '',
      surroundClean: json['surroundClean']?.toString() ?? '',
      alarm: json['alarm']?.toString() ?? '',
      warning: json['warning']?.toString() ?? '',
      issue: json['issue']?.toString() ?? '',
      leak: json['leak']?.toString() ?? '',
      waterLevel: json['waterLevel']?.toString() ?? '',
      exterior: json['exterior']?.toString() ?? '',
      fuelLeak: json['fuelLeak']?.toString() ?? '',
      airFilter: json['airFilter']?.toString() ?? '',
      gasEmission: json['gasEmission']?.toString() ?? '',
      oilLeak: json['oilLeak']?.toString() ?? '',
      tankLeak: json['tankLeak']?.toString() ?? '',
      tankSwell: json['tankSwell']?.toString() ?? '',
      batClean: json['batClean']?.toString() ?? '',
      batVoltage: json['batVoltage']?.toString() ?? '',
      batCharger: json['batCharger']?.toString() ?? '',
      bat1: json['bat1']?.toString(),
      bat2: json['bat2']?.toString(),
      bat3: json['bat3']?.toString(),
      bat4: json['bat4']?.toString(),
      problemStatus: json["problemStatus"]?.toString(),
      DailyDEGRemarkID: json["DailyDEGRemarkID"]?.toString() ?? '',
      last_updated: json['last_updated']?.toString() ?? '',
     Latitude: json['Latitude'] != null
        ? double.tryParse(json['Latitude'].toString()) ?? 0.0
        : 0.0,
    Longitude: json['Longitude'] != null
        ? double.tryParse(json['Longitude'].toString()) ?? 0.0
        : 0.0,
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
  final double Latitude;
  final double Longitude;

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
    required this.Latitude,
    required this.Longitude,
  });

  factory DegRemarkData.fromJson(Map<String, dynamic> json) {
    return DegRemarkData(
      DailyDEGRemarkID: json['DailyDEGRemarkID']?.toString() ?? '',
      degCleanRemark: json['degCleanRemark']?.toString() ?? '',
      surroundCleanRemark: json['surroundCleanRemark']?.toString() ?? '',
      vbeltRemark: json['vbeltRemark']?.toString() ?? '',
      alarmRemark: json['alarmRemark']?.toString() ?? '',
      warningRemark: json['warningRemark']?.toString() ?? '',
      issueRemark: json['issueRemark']?.toString() ?? '',
      leakRemark: json['leakRemark']?.toString() ?? '',
      waterLevelRemark: json['waterLevelRemark']?.toString() ?? '',
      exteriorRemark: json['exteriorRemark']?.toString() ?? '',
      fuelLeakRemark: json['fuelLeakRemark']?.toString() ?? '',
      airFilterRemark: json['airFilterRemark']?.toString() ?? '',
      gasEmissionRemark: json['gasEmissionRemark']?.toString() ?? '',
      oilLeakRemark: json['oilLeakRemark']?.toString() ?? '',
      batCleanRemark: json['batCleanRemark']?.toString() ?? '',
      batVoltageRemark: json['batVoltageRemark']?.toString() ?? '',
      batChargerRemark: json['batChargerRemark']?.toString() ?? '',
      tankLeakRemark: json['tankLeakRemark']?.toString() ?? '',
      tankSwellRemark: json['tankSwellRemark']?.toString() ?? '',
      addiRemark: json['addiRemark']?.toString() ?? '',
      Latitude: json['Latitude'] != null
        ? double.tryParse(json['Latitude'].toString()) ?? 0.0
        : 0.0,
    Longitude: json['Longitude'] != null
        ? double.tryParse(json['Longitude'].toString()) ?? 0.0
        : 0.0,
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
  double? Latitude;
  double? Longitude;

  DEGDetails({
    required this.ID,
    required this.region,
    required this.rtom,
    required this.station,
    required this.brand_set,
    required this.serial_set,
    required this.Latitude,
    required this.Longitude,
  });

  factory DEGDetails.fromJson(Map<String, dynamic> json) {
    return DEGDetails(
      ID: json['ID']?.toString() ?? "",
      region: json['Region']?.toString() ?? "",
      rtom: json['RTOM']?.toString() ?? "",
      station: json['station']?.toString() ?? "",
      brand_set: json['brand_set']?.toString() ?? "",
      serial_set: json['serial_set']?.toString() ?? "",
       Latitude: json['Latitude'] != null
        ? double.tryParse(json['Latitude'].toString()) ?? 0.0
        : 0.0,
    Longitude: json['Longitude'] != null
        ? double.tryParse(json['Longitude'].toString()) ?? 0.0
        : 0.0,
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
      'Latitude': Latitude,
      'Longitude': Longitude,
    };
  }
}


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
  final double Latitude;
  final double Longitude;

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
    required this.Latitude,
    required this.Longitude,
  });

  factory DegInspectionData.fromJson(Map<String, dynamic> json) {
    return DegInspectionData(
      DailyDEGCheckID: json['DailyDEGCheckID']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      degId: json['degId']?.toString() ?? '',
      clockTime: json['clockTime']?.toString() ?? '',
      shift: json['shift']?.toString() ?? '',
      region: json['region']?.toString() ?? '',
      degClean: json['degClean']?.toString() ?? '',
      surroundClean: json['surroundClean']?.toString() ?? '',
      alarm: json['alarm']?.toString() ?? '',
      warning: json['warning']?.toString() ?? '',
      issue: json['issue']?.toString() ?? '',
      leak: json['leak']?.toString() ?? '',
      waterLevel: json['waterLevel']?.toString() ?? '',
      exterior: json['exterior']?.toString() ?? '',
      fuelLeak: json['fuelLeak']?.toString() ?? '',
      airFilter: json['airFilter']?.toString() ?? '',
      gasEmission: json['gasEmission']?.toString() ?? '',
      oilLeak: json['oilLeak']?.toString() ?? '',
      tankLeak: json['tankLeak']?.toString() ?? '',
      tankSwell: json['tankSwell']?.toString() ?? '',
      batClean: json['batClean']?.toString() ?? '',
      batVoltage: json['batVoltage']?.toString() ?? '',
      batCharger: json['batCharger']?.toString() ?? '',
      bat1: json['bat1']?.toString(),
      bat2: json['bat2']?.toString(),
      bat3: json['bat3']?.toString(),
      bat4: json['bat4']?.toString(),
      problemStatus: json["problemStatus"]?.toString(),
      DailyDEGRemarkID: json["DailyDEGRemarkID"]?.toString() ?? '',
      last_updated: json['last_updated']?.toString() ?? '',
     Latitude: json['Latitude'] != null
        ? double.tryParse(json['Latitude'].toString()) ?? 0.0
        : 0.0,
    Longitude: json['Longitude'] != null
        ? double.tryParse(json['Longitude'].toString()) ?? 0.0
        : 0.0,
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
  final double Latitude;
  final double Longitude;

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
    required this.Latitude,
    required this.Longitude,
  });

  factory DegRemarkData.fromJson(Map<String, dynamic> json) {
    return DegRemarkData(
      DailyDEGRemarkID: json['DailyDEGRemarkID']?.toString() ?? '',
      degCleanRemark: json['degCleanRemark']?.toString() ?? '',
      surroundCleanRemark: json['surroundCleanRemark']?.toString() ?? '',
      vbeltRemark: json['vbeltRemark']?.toString() ?? '',
      alarmRemark: json['alarmRemark']?.toString() ?? '',
      warningRemark: json['warningRemark']?.toString() ?? '',
      issueRemark: json['issueRemark']?.toString() ?? '',
      leakRemark: json['leakRemark']?.toString() ?? '',
      waterLevelRemark: json['waterLevelRemark']?.toString() ?? '',
      exteriorRemark: json['exteriorRemark']?.toString() ?? '',
      fuelLeakRemark: json['fuelLeakRemark']?.toString() ?? '',
      airFilterRemark: json['airFilterRemark']?.toString() ?? '',
      gasEmissionRemark: json['gasEmissionRemark']?.toString() ?? '',
      oilLeakRemark: json['oilLeakRemark']?.toString() ?? '',
      batCleanRemark: json['batCleanRemark']?.toString() ?? '',
      batVoltageRemark: json['batVoltageRemark']?.toString() ?? '',
      batChargerRemark: json['batChargerRemark']?.toString() ?? '',
      tankLeakRemark: json['tankLeakRemark']?.toString() ?? '',
      tankSwellRemark: json['tankSwellRemark']?.toString() ?? '',
      addiRemark: json['addiRemark']?.toString() ?? '',
      Latitude: json['Latitude'] != null
        ? double.tryParse(json['Latitude'].toString()) ?? 0.0
        : 0.0,
    Longitude: json['Longitude'] != null
        ? double.tryParse(json['Longitude'].toString()) ?? 0.0
        : 0.0,
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
  double? Latitude;
  double? Longitude;

  DEGDetails({
    required this.ID,
    required this.region,
    required this.rtom,
    required this.station,
    required this.brand_set,
    required this.serial_set,
    required this.Latitude,
    required this.Longitude,
  });

  factory DEGDetails.fromJson(Map<String, dynamic> json) {
    return DEGDetails(
      ID: json['ID']?.toString() ?? "",
      region: json['Region']?.toString() ?? "",
      rtom: json['RTOM']?.toString() ?? "",
      station: json['station']?.toString() ?? "",
      brand_set: json['brand_set']?.toString() ?? "",
      serial_set: json['serial_set']?.toString() ?? "",
       Latitude: json['Latitude'] != null
        ? double.tryParse(json['Latitude'].toString()) ?? 0.0
        : 0.0,
    Longitude: json['Longitude'] != null
        ? double.tryParse(json['Longitude'].toString()) ?? 0.0
        : 0.0,
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
      'Latitude': Latitude,
      'Longitude': Longitude,
    };
  }
}