class Generator {
  String ID;
  String province;
  String Rtom_name;
  String station;
  String? Available;
  String? category;
  String? brand_alt;
  String? brand_eng;
  String? brand_set;
  String? model_alt;
  String? model_eng;
  String? model_set;
  String? serial_alt;
  String? serial_eng;
  String? serial_set;
  String? mode;
  String? phase_eng;
  String? set_cap;
  String? tank_prime;
  String? dayTank;
  String? dayTankSze;
  String? feederSize;
  String? RatingMCCB;
  String? RatingATS;
  String? BrandATS;
  String? ModelATS;
  String? LocalAgent;
  String? Agent_Addr;
  String? Agent_Tel;
  String? YoM;
  String? Yo_Install;
  String? Battery_Capacity;
  String? Battery_Brand;
  String? Battery_Count;
  String? Controller;
  String? controller_model;
  String? Updated_By;
  String? updated;
  String? Latitude;
  String? Longitude;


  Generator({
    required this.ID,
    required this.province,
    required this.Rtom_name,
    required this.station,
    this.Available,
    this.category,
    this.brand_alt,
    this.brand_eng,
    this.brand_set,
    this.model_alt,
    this.model_eng,
    this.model_set,
    this.serial_alt,
    this.serial_eng,
    this.serial_set,
    this.mode,
    this.phase_eng,
    this.set_cap,
    this.tank_prime,
    this.dayTank,
    this.dayTankSze,
    this.feederSize,
    this.RatingMCCB,
    this.RatingATS,
    this.BrandATS,
    this.ModelATS,
    this.LocalAgent,
    this.Agent_Addr,
    this.Agent_Tel,
    this.YoM,
    this.Yo_Install,
    this.Battery_Capacity,
    this.Battery_Brand,
    this.Battery_Count,
    this.Controller,
    this.controller_model,
    this.Updated_By,
    this.updated,
    this.Latitude,
    this.Longitude,
  });

  factory Generator.fromJson(Map<String, dynamic> json) {
    return Generator(
      ID: json['ID'] ?? "",
      province: json['province'] ?? "",
      Rtom_name: json['Rtom_name'] ?? "",
      station: json['station'] ?? "",
      Available: json['Available'],
      category: json['category'],
      brand_alt: json['brand_alt'],
      brand_eng: json['brand_eng'],
      brand_set: json['brand_set'],
      model_alt: json['model_alt'],
      model_eng: json['model_eng'],
      model_set: json['model_set'],
      serial_alt: json['serial_alt'],
      serial_eng: json['serial_eng'],
      serial_set: json['serial_set'],
      mode: json['mode'],
      phase_eng: json['phase_eng'],
      set_cap: json['set_cap'],
      tank_prime: json['tank_prime'],
      dayTank: json['dayTank'],
      dayTankSze: json['dayTankSze'],
      feederSize: json['feederSize'],
      RatingMCCB: json['RatingMCCB'],
      RatingATS: json['RatingATS'],
      BrandATS: json['BrandATS'],
      ModelATS: json['ModelATS'],
      LocalAgent: json['LocalAgent'],
      Agent_Addr: json['Agent_Addr'],
      Agent_Tel: json['Agent_Tel'],
      YoM: json['YoM'],
      Yo_Install: json['Yo_Install'],
      Battery_Capacity: json['Battery_Capacity'],
      Battery_Brand: json['Battery_Brand'],
      Battery_Count: json['Battery_Count'],
      Controller: json['Controller'],
      controller_model:json['controller_model'],
      Updated_By: json['Updated_By'],
      updated: json['updated'],
      Latitude:json['Latitude'],
      Longitude:json['Longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': ID,
      'province': province,
      'Rtom_name': Rtom_name,
      'station': station,
      'Available': Available,
      'category': category,
      'brand_alt': brand_alt,
      'brand_eng': brand_eng,
      'brand_set': brand_set,
      'model_alt': model_alt,
      'model_eng': model_eng,
      'model_set': model_set,
      'serial_alt': serial_alt,
      'serial_eng': serial_eng,
      'serial_set': serial_set,
      'mode': mode,
      'phase_eng': phase_eng,
      'set_cap': set_cap,
      'tank_prime': tank_prime,
      'dayTank': dayTank,
      'dayTankSze': dayTankSze,
      'feederSize': feederSize,
      'RatingMCCB': RatingMCCB,
      'RatingATS': RatingATS,
      'BrandATS': BrandATS,
      'ModelATS': ModelATS,
      'LocalAgent': LocalAgent,
      'Agent_Addr': Agent_Addr,
      'Agent_Tel': Agent_Tel,
      'YoM': YoM,
      'Yo_Install': Yo_Install,
      'Battery_Capacity': Battery_Capacity,
      'Battery_Brand': Battery_Brand,
      'Battery_Count': Battery_Count,
      'Controller': Controller,
      'controller_model':controller_model,
      'Updated_By': Updated_By,
      'updated': updated,
      'Latitude':Latitude,
      'Longitude':Longitude,
    };
  }
}
