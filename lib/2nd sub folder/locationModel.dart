class Region {
  final String Region_ID;
  final String RegionName;

  Region({required this.Region_ID, required this.RegionName});
}

class Rtom {
  final String RTOM_ID;
  final String Region_ID;
  final String RTOM;


  Rtom({required this.RTOM_ID, required this.Region_ID, required this.RTOM});
}

class Station {
  final String Station_ID;
  final String Region_ID;
  final String RTOM_ID;
  final String StationName;

  Station({required this.Station_ID, required this.Region_ID, required this.RTOM_ID, required this.StationName});
}
