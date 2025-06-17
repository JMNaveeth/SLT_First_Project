import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//import 'locationModel.dart';

class LocationProvider extends ChangeNotifier {
  // Existing lists
  // List<Region> _allRegions = [];
  // List<Rtom> _allRtoms = [];
  // List<Station> _allStations = [];

  // // Filtered lists
  // List<Region> _regions = [];
  // List<Rtom> _rtoms = [];
  // List<Station> _stations = [];

  // Loading state
  bool _isLoading = false;

  // Selected items
  String? _selectedRegion;
  String? _selectedRtom;
  String? _selectedStation;

  // Custom values
  String? customRegion;
  String? customRtom;
  String? customStation;

  // To track if 'Other' is selected
  bool isCustomRegion = false;
  bool isCustomRtom = false;
  bool isCustomStation = false;

  // Getters for filtered lists and loading states
  // List<Region> get regions => _regions;
  // List<Rtom> get rtoms => _rtoms;
  // List<Station> get stations => _stations;

  bool get isLoading => _isLoading;

  // Getters and setters for selected items
  String? get selectedRegion => _selectedRegion;
  set selectedRegion(String? value) {
    _selectedRegion = value;
    if (value == 'Other') {
      isCustomRegion = true;
      customRegion = null;
      // _rtoms = [];
      // _stations = [];
      _resetRtomAndStation(); // Reset RTOM and Station when Region is 'Other'
    } else {
      isCustomRegion = false;
      customRegion = null;

      _selectedRtom = null;
      _selectedStation = null;

      _filterRtomsByRegion(value);
    }
    notifyListeners();
  }

  String? get selectedRtom => _selectedRtom;
  set selectedRtom(String? value) {
    _selectedRtom = value;
    if (value == 'Other') {
      isCustomRtom = true;
      customRtom = null;
   //   _stations = [];
    } else {
      isCustomRtom = false;
      customRtom = null;

      _selectedStation = null;
      _filterStationsByRtom(value);
    }
    notifyListeners();
  }

  String? get selectedStation => _selectedStation;
  set selectedStation(String? value) {
    _selectedStation = value;
    if (value == 'Other') {
      isCustomStation = true;
      customStation = null;
    } else {
      isCustomStation = false;
      customStation = null;
    }
    notifyListeners();
  }

  // Function to load all data initially
  Future<void> loadAllData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch regions
      final regionsResponse = await http.get(Uri.parse('https://powerprox.sltidc.lk/GETLocationRegion.php'));
      if (regionsResponse.statusCode == 200) {
        final List<dynamic> regionsData = json.decode(regionsResponse.body);
        // _allRegions = regionsData.map((item) => Region(
        //   Region_ID: item['Region_ID'].toString(),
        //   RegionName: item['Region'].toString(),
        // )).toList();
        // _regions = _allRegions; // Set initial regions
      } else {
        throw Exception('Failed to load regions');
      }

      // Fetch RTOMs
      final rtomsResponse = await http.get(Uri.parse('https://powerprox.sltidc.lk/GETLocationRTOM.php'));
      if (rtomsResponse.statusCode == 200) {
        final List<dynamic> rtomsData = json.decode(rtomsResponse.body);
        // _allRtoms = rtomsData.map((item) => Rtom(
        //   RTOM_ID: item['RTOM_ID'].toString(),
        //   Region_ID: item['Region_ID'].toString(),
        //   RTOM: item['RTOM'].toString(),
        // )).toList();
      } else {
        throw Exception('Failed to load RTOMs');
      }

      // Fetch Stations
      final stationsResponse = await http.get(Uri.parse('https://powerprox.sltidc.lk/GETLocationStationTable.php'));
      if (stationsResponse.statusCode == 200) {
        final List<dynamic> stationsData = json.decode(stationsResponse.body);
        // _allStations = stationsData.map((item) => Station(
        //   Station_ID: item['Station_ID'].toString(),
        //   Region_ID: item['Region_ID'].toString(),
        //   RTOM_ID: item['RTOM_ID'].toString(),
        //   StationName: item['Station'].toString(),
        // )).toList();
      } else {
        throw Exception('Failed to load stations');
      }
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter RTOMs based on selected Region
  void _filterRtomsByRegion(String? regionId) {
    // if (regionId != null) {
    //   _rtoms = _allRtoms.where((rtom) => rtom.Region_ID == regionId).toList();
    // } else {
    //   _rtoms = [];
    // }
    _resetStation(); // Reset station when RTOMs are filtered
    notifyListeners();
  }

  // Filter Stations based on selected RTOM
  void _filterStationsByRtom(String? rtomId) {
    if (rtomId != null) {
    //   _stations = _allStations.where((station) => station.RTOM_ID == rtomId).toList();
    // } else {
    //   _stations = [];
    }
    notifyListeners(); // Notify listeners to update UI
  }

  // Helper method to reset RTOM and Station when Region changes
  void _resetRtomAndStation() {
    _selectedRtom = null;
    isCustomRtom = false;
    customRtom = null;
 //   _rtoms = [];

    _resetStation(); // Also reset station when RTOM changes
  }

  // Helper method to reset Station
  void _resetStation() {
    _selectedStation = null;
    isCustomStation = false;
    customStation = null;
  //  _stations = [];
  }

  // Add a custom region to the list
  void addCustomRegion(String customRegion) {
    if (customRegion.isNotEmpty) {
      // _regions.add(Region(
      //   Region_ID: customRegion, // Use custom Region name as ID
      //   RegionName: customRegion,
      // ));
      notifyListeners();
    }
  }

  // Add a custom RTOM to the list
  void addCustomRtom(String customRtom) {
    if (customRtom.isNotEmpty) {
      // _rtoms.add(Rtom(
      //   RTOM_ID: customRtom, // Use custom RTOM name as ID
      //   Region_ID: '', // Set appropriate values if needed
      //   RTOM: customRtom,
      // ));
      notifyListeners();
    }
  }

  // Add a custom station to the list and update the selected value
  void addCustomStation(String customStation) {
    // Add custom station to the list of stations
    // _allStations.add(Station(
    //   Station_ID: customStation, // Use the custom value as ID
    //   Region_ID: '', // Set appropriate values as needed
    //   RTOM_ID: '',  // Set appropriate values as needed
    //   StationName: customStation,
    // ));
    // _stations.add(Station(
    //   Station_ID: customStation, // Use the custom value as ID
    //   Region_ID: '', // Set appropriate values as needed
    //   RTOM_ID: '',  // Set appropriate values as needed
    //   StationName: customStation,
    // ));
    // Set the newly added custom station as the selected value
    _selectedStation = customStation;
    isCustomStation = false;
    notifyListeners(); // Notify listeners to update UI
  }
}




//v2
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// import 'locationModel.dart';
//
// class LocationProvider extends ChangeNotifier {
//   // Existing lists
//   List<Region> _allRegions = [];
//   List<Rtom> _allRtoms = [];
//   List<Station> _allStations = [];
//
//   // Filtered lists
//   List<Region> _regions = [];
//   List<Rtom> _rtoms = [];
//   List<Station> _stations = [];
//
//   // Loading state
//   bool _isLoading = false;
//
//   // Selected items
//   String? _selectedRegion;
//   String? _selectedRtom;
//   String? _selectedStation;
//
//   // Custom values
//   String? customRegion;
//   String? customRtom;
//   String? customStation;
//
//   // To track if 'Other' is selected
//   bool isCustomRegion = false;
//   bool isCustomRtom = false;
//   bool isCustomStation = false;
//
//   // Getters for filtered lists and loading states
//   List<Region> get regions => _regions;
//   List<Rtom> get rtoms => _rtoms;
//   List<Station> get stations => _stations;
//
//   bool get isLoading => _isLoading;
//
//   // Getters and setters for selected items
//   String? get selectedRegion => _selectedRegion;
//   set selectedRegion(String? value) {
//     _selectedRegion = value;
//     if (value == 'Other') {
//       isCustomRegion = true;
//       customRegion = null;
//       _rtoms = [];
//       _stations = [];
//     } else {
//       isCustomRegion = false;
//       customRegion = null;
//       _filterRtomsByRegion(value);
//     }
//     notifyListeners();
//   }
//
//   String? get selectedRtom => _selectedRtom;
//   set selectedRtom(String? value) {
//     _selectedRtom = value;
//     if (value == 'Other') {
//       isCustomRtom = true;
//       customRtom = null;
//       _stations = [];
//     } else {
//       isCustomRtom = false;
//       customRtom = null;
//       _filterStationsByRtom(value);
//     }
//     notifyListeners();
//   }
//
//   String? get selectedStation => _selectedStation;
//   set selectedStation(String? value) {
//     _selectedStation = value;
//     if (value == 'Other') {
//       isCustomStation = true;
//       customStation = null;
//     } else {
//       isCustomStation = false;
//       customStation = null;
//     }
//     notifyListeners();
//   }
//
//   // Function to load all data initially
//   Future<void> loadAllData() async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       // Fetch regions
//       final regionsResponse = await http.get(Uri.parse('https://powerprox.sltidc.lk/GETLocationRegion.php'));
//       if (regionsResponse.statusCode == 200) {
//         final List<dynamic> regionsData = json.decode(regionsResponse.body);
//         _allRegions = regionsData.map((item) => Region(
//           Region_ID: item['Region_ID'].toString(),
//           RegionName: item['Region'].toString(),
//         )).toList();
//         _regions = _allRegions; // Set initial regions
//       } else {
//         throw Exception('Failed to load regions');
//       }
//
//       // Fetch RTOMs
//       final rtomsResponse = await http.get(Uri.parse('https://powerprox.sltidc.lk/GETLocationRTOM.php'));
//       if (rtomsResponse.statusCode == 200) {
//         final List<dynamic> rtomsData = json.decode(rtomsResponse.body);
//         _allRtoms = rtomsData.map((item) => Rtom(
//           RTOM_ID: item['RTOM_ID'].toString(),
//           Region_ID: item['Region_ID'].toString(),
//           RTOM: item['RTOM'].toString(),
//         )).toList();
//       } else {
//         throw Exception('Failed to load RTOMs');
//       }
//
//       // Fetch Stations
//       final stationsResponse = await http.get(Uri.parse('https://powerprox.sltidc.lk/GETLocationStationTable.php'));
//       if (stationsResponse.statusCode == 200) {
//         final List<dynamic> stationsData = json.decode(stationsResponse.body);
//         _allStations = stationsData.map((item) => Station(
//           Station_ID: item['Station_ID'].toString(),
//           Region_ID: item['Region_ID'].toString(),
//           RTOM_ID: item['RTOM_ID'].toString(),
//           StationName: item['Station'].toString(),
//         )).toList();
//       } else {
//         throw Exception('Failed to load stations');
//       }
//     } catch (e) {
//       print('Error loading data: $e');
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   // Filter RTOMs based on selected Region
//   void _filterRtomsByRegion(String? regionId) {
//     if (regionId != null) {
//       _rtoms = _allRtoms.where((rtom) => rtom.Region_ID == regionId).toList();
//     } else {
//       _rtoms = [];
//     }
//     notifyListeners(); // Notify listeners to update UI
//   }
//
//   // Filter Stations based on selected RTOM
//   void _filterStationsByRtom(String? rtomId) {
//     if (rtomId != null) {
//       _stations = _allStations.where((station) => station.RTOM_ID == rtomId).toList();
//     } else {
//       _stations = [];
//     }
//     notifyListeners(); // Notify listeners to update UI
//   }
//
//
//   void addCustomRegion(String customRegion) {
//     if (customRegion.isNotEmpty) {
//       _regions.add(Region(
//         Region_ID: customRegion, // Use custom Region name as ID
//         RegionName: customRegion,
//       ));
//       notifyListeners();
//     }
//   }
//   // Filter Stations based on selected RTOM
//   void addCustomRtom(String customRtom) {
//     if (customRtom.isNotEmpty) {
//       _rtoms.add(Rtom(
//         RTOM_ID: customRtom, // Use custom RTOM name as ID
//         Region_ID: '', // Set appropriate values if needed
//         RTOM: customRtom,
//       ));
//       notifyListeners();
//     }
//   }
//
//   // Add a custom station to the list and update the selected value
//   void addCustomStation(String customStation) {
//     // Add custom station to the list of stations
//     _allStations.add(Station(
//       Station_ID: customStation, // Use the custom value as ID
//       Region_ID: '', // Set appropriate values as needed
//       RTOM_ID: '',  // Set appropriate values as needed
//       StationName: customStation,
//     ));
//     _stations.add(Station(
//       Station_ID: customStation, // Use the custom value as ID
//       Region_ID: '', // Set appropriate values as needed
//       RTOM_ID: '',  // Set appropriate values as needed
//       StationName: customStation,
//     ));
//     // Set the newly added custom station as the selected value
//     _selectedStation = customStation;
//     isCustomStation = false;
//     notifyListeners(); // Notify listeners to update UI
//   }
// }
//


//v1
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// import 'locationModel.dart';
//
// class LocationProvider extends ChangeNotifier {
//   // Complete lists of all data
//   List<Region> _allRegions = [];
//   List<Rtom> _allRtoms = [];
//   List<Station> _allStations = [];
//
//   // Filtered lists for display in the dropdowns
//   List<Region> _regions = [];
//   List<Rtom> _rtoms = [];
//   List<Station> _stations = [];
//
//   // Loading states
//   bool _isLoading = false;
//
//   // Selected items for dropdowns
//   String? _selectedRegion;
//   String? _selectedRtom;
//   String? _selectedStation;
//
//   // Custom values
//   String? customRegion;
//   String? customRtom;
//   String? customStation;
//
//   // To track if 'Other' is selected
//   bool isCustomRegion = false;
//   bool isCustomRtom = false;
//   bool isCustomStation = false;
//
//   // Getters for filtered lists and loading states
//   List<Region> get regions => _regions;
//   List<Rtom> get rtoms => _rtoms;
//   List<Station> get stations => _stations;
//
//   bool get isLoading => _isLoading;
//
//   // Getters and setters for selected items
//   String? get selectedRegion => _selectedRegion;
//   set selectedRegion(String? value) {
//     _selectedRegion = value;
//     if (value == 'Other') {
//       isCustomRegion = true;
//       customRegion = null;
//       _rtoms = [];
//       _stations = [];
//     } else {
//       isCustomRegion = false;
//       customRegion = null;
//       _filterRtomsByRegion(value);
//     }
//     notifyListeners();
//   }
//
//   String? get selectedRtom => _selectedRtom;
//   set selectedRtom(String? value) {
//     _selectedRtom = value;
//     if (value == 'Other') {
//       isCustomRtom = true;
//       customRtom = null;
//       _stations = [];
//     } else {
//       isCustomRtom = false;
//       customRtom = null;
//       _filterStationsByRtom(value);
//     }
//     notifyListeners();
//   }
//
//   String? get selectedStation => _selectedStation;
//   set selectedStation(String? value) {
//     _selectedStation = value;
//     if (value == 'Other') {
//       isCustomStation = true;
//       customStation = null;
//     } else {
//       isCustomStation = false;
//       customStation = null;
//     }
//     notifyListeners();
//   }
//
//   // Function to load all data initially
//   Future<void> loadAllData() async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       // Fetch regions
//       final regionsResponse = await http.get(Uri.parse('https://powerprox.sltidc.lk/GETLocationRegion.php'));
//       if (regionsResponse.statusCode == 200) {
//         final List<dynamic> regionsData = json.decode(regionsResponse.body);
//         _allRegions = regionsData.map((item) => Region(
//           Region_ID: item['Region_ID'].toString(),
//           RegionName: item['Region'].toString(),
//         )).toList();
//         _regions = _allRegions; // Set initial regions
//       } else {
//         throw Exception('Failed to load regions');
//       }
//
//       // Fetch RTOMs
//       final rtomsResponse = await http.get(Uri.parse('https://powerprox.sltidc.lk/GETLocationRTOM.php'));
//       if (rtomsResponse.statusCode == 200) {
//         final List<dynamic> rtomsData = json.decode(rtomsResponse.body);
//         _allRtoms = rtomsData.map((item) => Rtom(
//           RTOM_ID: item['RTOM_ID'].toString(),
//           Region_ID: item['Region_ID'].toString(),
//           RTOM: item['RTOM'].toString(),
//         )).toList();
//       } else {
//         throw Exception('Failed to load RTOMs');
//       }
//
//       // Fetch Stations
//       final stationsResponse = await http.get(Uri.parse('https://powerprox.sltidc.lk/GETLocationStationTable.php'));
//       if (stationsResponse.statusCode == 200) {
//         final List<dynamic> stationsData = json.decode(stationsResponse.body);
//         _allStations = stationsData.map((item) => Station(
//           Station_ID: item['Station_ID'].toString(),
//           Region_ID: item['Region_ID'].toString(),
//           RTOM_ID: item['RTOM_ID'].toString(),
//           StationName: item['Station'].toString(),
//         )).toList();
//       } else {
//         throw Exception('Failed to load stations');
//       }
//     } catch (e) {
//       print('Error loading data: $e');
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   // Filter RTOMs based on selected Region
//   void _filterRtomsByRegion(String? regionId) {
//     if (regionId != null) {
//       _rtoms = _allRtoms.where((rtom) => rtom.Region_ID == regionId).toList();
//     } else {
//       _rtoms = [];
//     }
//     notifyListeners(); // Notify listeners to update UI
//   }
//
//   // Filter Stations based on selected RTOM
//   void _filterStationsByRtom(String? rtomId) {
//     if (rtomId != null) {
//       _stations = _allStations.where((station) => station.RTOM_ID == rtomId).toList();
//     } else {
//       _stations = [];
//     }
//     notifyListeners(); // Notify listeners to update UI
//   }
// }
