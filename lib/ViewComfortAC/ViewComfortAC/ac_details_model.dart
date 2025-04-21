class AcIndoorData {
  final String acIndoorId;
  final String? status;
  final String? brand;
  final String? model;
  final String? capacity;
  final String? type;
  final String? category;
  final String? serialNumber;
  final String? installationType;
  final String? refrigerantType;
  final String? powerSupply;
  final String? supplierName;
  final String? poNumber;
  final String? remoteAvailable;
  final String? notes;
  final String? lastUpdated;
  final String? conditionIdUnit;
  final String? dateOfManufacture;
  final String? installationDate;
  final String? warrantyExpiryDate;
  final String? qrIn;

  AcIndoorData({
    required this.acIndoorId,
    this.status,
    this.brand,
    this.model,
    this.capacity,
    this.type,
    this.category,
    this.serialNumber,
    this.installationType,
    this.refrigerantType,
    this.powerSupply,
    this.supplierName,
    this.poNumber,
    this.remoteAvailable,
    this.notes,
    this.lastUpdated,
    this.conditionIdUnit,
    this.dateOfManufacture,
    this.installationDate,
    this.warrantyExpiryDate,
    this.qrIn,
  });

  factory AcIndoorData.fromJson(Map<String?, dynamic> json) {
    return AcIndoorData(
      acIndoorId: json['ac_indoor_id'],
      status: json['status'],
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      capacity: json['capacity'] ?? '',
      type: json['Type'] ?? '',
      category: json['category'] ?? '',
      serialNumber: json['serial_number'] ?? '',
      installationType: json['installation_type'] ?? '',
      refrigerantType: json['refrigerant_type'] ?? '',
      powerSupply: json['power_supply'] ?? '',
      supplierName: json['supplier_name'],
      poNumber: json['po_number'],
      remoteAvailable: json['remote_available'],
      notes: json['notes'],
      lastUpdated: json['last_updated'] ?? '',
      conditionIdUnit: json['condition_ID_unit'] ?? '',
      dateOfManufacture: json['DoM'] ?? '',
      installationDate: json['installation_date'] ?? '',
      warrantyExpiryDate: json['warranty_expiry_date'],
      qrIn: json['QR_In'],
    );
  }
}

class AcOutdoorData {
  final String? acOutdoorId;
  final String? status;
  final String? brand;
  final String? model;
  final String? capacity;
  final String? powerSupply;
  final String? compressorMountedWith;
  final String? compressorCapacity;
  final String? compressorBrand;
  final String? compressorModel;
  final String? compressorSerialNumber;
  final String? outdoorFanModel;
  final String? supplierName;
  final String? poNumber;
  final String? notes;
  final String? conditionOdUnit;
  final String? lastUpdated;
  final String? dateOfManufacture;
  final String? installationDate;
  final String? warrantyExpiryDate;
  final String? qrOut;

  AcOutdoorData({
    required this.acOutdoorId,
    this.status,
    this.brand,
    this.model,
    this.capacity,
    this.powerSupply,
    this.compressorMountedWith,
    this.compressorCapacity,
    this.compressorBrand,
    this.compressorModel,
    this.compressorSerialNumber,
    this.outdoorFanModel,
    this.supplierName,
    this.poNumber,
    this.notes,
    this.conditionOdUnit,
    this.lastUpdated,
    this.dateOfManufacture,
    this.installationDate,
    this.warrantyExpiryDate,
    this.qrOut,
  });

  factory AcOutdoorData.fromJson(Map<String?, dynamic> json) {
    return AcOutdoorData(
      acOutdoorId: json['ac_outdoor_id'],
      status: json['status'],
      brand: json['brand'] ?? '',
      model: json['model'],
      capacity: json['capacity'] ?? '',
      powerSupply: json['power_supply'] ?? '',
      compressorMountedWith: json['compressor_mounted_with'],
      compressorCapacity: json['compressor_capacity'],
      compressorBrand: json['compressor_brand'],
      compressorModel: json['compressor_model'],
      compressorSerialNumber: json['compressor_serial_number'],
      outdoorFanModel: json['outdoor_fan_model'] ?? '',
      supplierName: json['supplier_name'],
      poNumber: json['po_number'],
      notes: json['notes'],
      conditionOdUnit: json['condition_OD_unit'] ?? '',
      lastUpdated: json['last_updated'] ?? '',
      dateOfManufacture: json['DoM'],
      installationDate: json['Installation_Date'],
      warrantyExpiryDate: json['warranty_expiry_date'],
      qrOut: json['QR_Out'],
    );
  }
}

class AcLogData {
  final String logId;
  final String acIndoorId;
  final String acOutdoorId;
  final String? region;
  final String? rtom;
  final String? station;
  final String? rtomBuildingId;
  final String? floorNumber;
  final String? officeNumber;
  final String? location;
  final String? noAcPlants;
  final String? qrLoc;
  final String? type; // Add this property to store the AC type

  AcLogData({
    required this.logId,
    required this.acIndoorId,
    required this.acOutdoorId,
    this.region,
    this.rtom,
    this.station,
    this.rtomBuildingId,
    this.floorNumber,
    this.officeNumber,
    this.location,
    this.noAcPlants,
    this.qrLoc,
    this.type, // Initialize the new property
  });

  factory AcLogData.fromJson(Map<String?, dynamic> json) {
    return AcLogData(
      logId: json["log_id"],
      acIndoorId: json["ac_indoor_id"],
      acOutdoorId: json["ac_outdoor_id"],
      region: json["region"],
      rtom: json["rtom"],
      station: json["station"],
      rtomBuildingId: json["rtom_building_id"],
      floorNumber: json["floor_number"],
      officeNumber: json["office_number"],
      location: json["location"],
      noAcPlants: json["no_AC_plants"],
      qrLoc: json["QR_loc"],
      type: json["type"], // Map the new property from JSON
    );
  }
}

class PrecisionAC {
  final String? precisionACId;
  final String? region;
  final String? rtom;
  final String? station;
  final String? location;
  final String? qrTag;
  final String? model;
  final String? serialNumber;
  final String? manufacturer;
  final String? installationDate;
  final String? status;
  final String? updatedBy;
  final String? updatedTime;
  final String? coolingCapacity;
  final String? powerSupply;
  final String? refrigerantType;
  final String? dimensions;
  final String? weight;
  final String? noiseLevel;
  final String? noOfCompressors;
  final String? serialNumberOfTheCompressors;
  final String? conditionIndoorAirFilters;
  final String? conditionIndoorUnit;
  final String? conditionOutdoorUnit;
  final String? otherSpecifications;
  final String? airflow;
  final String? noOfRefrigerantCircuits;
  final String? noOfEvaporatorCoils;
  final String? noOfCondenserCircuits;
  final String? noOfCondenserFans;
  final String? condenserMountingMethod;
  final String? supplierName;
  final String? supplierContactDetails;
  final String? warrantyDetails;
  final String? warrantyExpireDate;
  final String? amcExpireDate;
  final String? latitude;
  final String? longitude;

  PrecisionAC({
    required this.precisionACId,
    this.region,
    this.rtom,
    this.station,
    this.location,
    this.qrTag,
    this.model,
    this.serialNumber,
    this.manufacturer,
    this.installationDate,
    this.status,
    this.updatedBy,
    this.updatedTime,
    this.coolingCapacity,
    this.powerSupply,
    this.refrigerantType,
    this.dimensions,
    this.weight,
    this.noiseLevel,
    this.noOfCompressors,
    this.serialNumberOfTheCompressors,
    this.conditionIndoorAirFilters,
    this.conditionIndoorUnit,
    this.conditionOutdoorUnit,
    this.otherSpecifications,
    this.airflow,
    this.noOfRefrigerantCircuits,
    this.noOfEvaporatorCoils,
    this.noOfCondenserCircuits,
    this.noOfCondenserFans,
    this.condenserMountingMethod,
    this.supplierName,
    this.supplierContactDetails,
    this.warrantyDetails,
    this.warrantyExpireDate,
    this.amcExpireDate,
    this.latitude,
    this.longitude,
  });

  factory PrecisionAC.fromJson(Map<String, dynamic> json) {
    return PrecisionAC(
      precisionACId: json['precisionAC_ID'] ?? "",
      region: json['Region'] ?? "",
      rtom: json['RTOM'] ?? "",
      station: json['Station'] ?? "",
      location: json['Location'] ?? "",
      qrTag: json['QRTag'] ?? "",
      model: json['Model'] ?? "",
      serialNumber: json['Serial_Number'] ?? "",
      manufacturer: json['Manufacturer'] ?? "",
      installationDate: json['Installation_Date'] ?? "",
      status: json['Status'] ?? "",
      updatedBy: json['UpdatedBy'] ?? "",
      updatedTime: json['UpdatedTime'] ?? "",
      coolingCapacity: json['Cooling_Capacity'] ?? "",
      powerSupply: json['Power_Supply'] ?? "",
      refrigerantType: json['Refrigerant_Type'] ?? "",
      dimensions: json['Dimensions'] ?? "",
      weight: json['Weight'] ?? "",
      noiseLevel: json['Noise_Level'] ?? "",
      noOfCompressors: json['No_of_Compressors'] ?? "",
      serialNumberOfTheCompressors:
          json['Serial_Number_of_the_Compressors'] ?? "",
      conditionIndoorAirFilters: json['Condition_Indoor_Air_Filters'] ?? "",
      conditionIndoorUnit: json['Condition_Indoor_Unit'] ?? "",
      conditionOutdoorUnit: json['Condition_Outdoor_Unit'] ?? "",
      otherSpecifications: json['Other_Specifications'] ?? "",
      airflow: json['Airflow'] ?? "",
      noOfRefrigerantCircuits: json['No_of_Refrigerant_Circuits'] ?? "",
      noOfEvaporatorCoils: json['No_of_Evaporator_Coils'] ?? "",
      noOfCondenserCircuits: json['No_of_Condenser_Circuits'] ?? "",
      noOfCondenserFans: json['No_of_Condenser_Fans'] ?? "",
      condenserMountingMethod: json['Condenser_Mounting_Method'] ?? "",
      supplierName: json['Supplier_Name'] ?? "",
      supplierContactDetails: json['Supplier_Contact_Details'] ?? "",
      warrantyDetails: json['Warranty_Details'] ?? "",
      warrantyExpireDate: json['Warranty_Expire_Date'] ?? "",
      amcExpireDate: json['AMC_Expire_Date'] ?? "",
      latitude: json['Latitude'] ?? "",
      longitude: json['Longitude'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'precisionAC_test_ID': precisionACId,
      'Region': region,
      'RTOM': rtom,
      'Station': station,
      'Location': location,
      'QRTag': qrTag,
      'Model': model,
      'Serial_Number': serialNumber,
      'Manufacturer': manufacturer,
      'Installation_Date': installationDate,
      'Status': status,
      'UpdatedBy': updatedBy,
      'UpdatedTime': updatedTime,
      'Cooling_Capacity': coolingCapacity,
      'Power_Supply': powerSupply,
      'Refrigerant_Type': refrigerantType,
      'Dimensions': dimensions,
      'Weight': weight,
      'Noise_Level': noiseLevel,
      'No_of_Compressors': noOfCompressors,
      'Serial_Number_of_the_Compressors': serialNumberOfTheCompressors,
      'Condition_Indoor_Air_Filters': conditionIndoorAirFilters,
      'Condition_Indoor_Unit': conditionIndoorUnit,
      'Condition_Outdoor_Unit': conditionOutdoorUnit,
      'Other_Specifications': otherSpecifications,
      'Airflow': airflow,
      'No_of_Refrigerant_Circuits': noOfRefrigerantCircuits,
      'No_of_Evaporator_Coils': noOfEvaporatorCoils,
      'No_of_Condenser_Circuits': noOfCondenserCircuits,
      'No_of_Condenser_Fans': noOfCondenserFans,
      'Condenser_Mounting_Method': condenserMountingMethod,
      'Supplier_Name': supplierName,
      'Supplier_Contact_Details': supplierContactDetails,
      'Warranty_Details': warrantyDetails,
      'Warranty_Expire_Date': warrantyExpireDate,
      'AMC_Expire_Date': amcExpireDate,
      'Latitude': latitude,
      'Longitude': longitude,
    };
  }
}
