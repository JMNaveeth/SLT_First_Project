import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/utils/utils/colors.dart';
import '../../widgets/searchWidget.dart';

// import '../AddSolar/http_get_service.dart';
import 'http_get_service.dart';
import 'search_helper.dart';
import 'site_detail_screen.dart';

class ViewDataScreen extends StatefulWidget {
  @override
  _ViewDataScreenState createState() => _ViewDataScreenState();
}

class _ViewDataScreenState extends State<ViewDataScreen> {
  String? selectedRegion;
  String? selectedStation;
  String? selectedRtom;
  String searchQuery = '';

  final List<String> regions = [
    'ALL',
    'CPN',
    'CPS',
    'EPN',
    'EPS',
    'EPN–TC',
    'HQ',
    'NCP',
    'NPN',
    'NPS',
    'NWPE',
    'NWPW',
    'PITI',
    'SAB',
    'SMW5'
        'SMW6',
    'SPE',
    'SPW',
    'WEL',
    'WPC',
    'WPE',
    'WPN',
    'WPNE',
    'WPS',
    'WPSE',
    'WPSW',
    'UVA',
  ];

  List<String> stations = [];
  List<String> rToms = [];

  List<Map<String, dynamic>> siteData = [];
  List<Map<String, dynamic>> filteredSiteData = [];
  List<Map<String, dynamic>> panelData = [];
  List<Map<String, dynamic>> inverterData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      HttpGetService service = HttpGetService();
      List<Map<String, dynamic>> data =
          await service.getSolarData(); // Fetch data from solar table
      panelData = await service.getPanelsData();
      inverterData = await service.getInverterData();

      setState(() {
        siteData = data;
        filteredSiteData = data;
      });
    } catch (e) {
      print('Failed to fetch data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchStations(String region) async {
    setState(() {
      isLoading = true;
    });

    try {
      HttpGetService service = HttpGetService();
      List<String> fetchedStations = await service.getStationsByRegion(region);
      setState(() {
        stations = fetchedStations;
      });
    } catch (e) {
      print('Failed to fetch stations: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchRtoms(String region, String station) async {
    setState(() {
      isLoading = true;
    });

    try {
      HttpGetService service = HttpGetService();
      List<String> fetchedRtoms = await service.getRtomsByRegionAndStation(
        region,
        station,
      );
      setState(() {
        rToms = fetchedRtoms;
      });
    } catch (e) {
      print('Failed to fetch RTOMs: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterData() {
    List<Map<String, dynamic>> tempData =
        siteData.where((site) {
          // Filter by dropdown selections
          if (selectedRegion != null &&
              selectedRegion != 'ALL' &&
              site['region'] != selectedRegion) {
            return false;
          }
          if (selectedStation != null && site['station'] != selectedStation) {
            return false;
          }
          if (selectedRtom != null && site['rtom'] != selectedRtom) {
            return false;
          }

          // Filter by search query if it exists
          if (searchQuery.isNotEmpty) {
            bool siteMatches = SearchHelper.matchesSiteQuery(site, searchQuery);
            if (siteMatches) return true;

            // Then search in panels for this site
            bool panelMatches = panelData.any(
              (panel) =>
                  panel['site_id'] == site['site_id'] &&
                  SearchHelper.matchesPanelQuery(panel, searchQuery),
            );
            if (panelMatches) return true;

            // Then search in inverters for this site
            bool inverterMatches = inverterData.any(
              (inverter) =>
                  inverter['site_id'] == site['site_id'] &&
                  SearchHelper.matchesInverterQuery(inverter, searchQuery),
            );
            if (inverterMatches) return true;

            return false;
          }

          return true;
        }).toList();

    setState(() {
      filteredSiteData = tempData;
    });
  }

  void handleSearch(String query) {
    setState(() {
      searchQuery = query;
      filterData();
    });
  }

  // void filterData() {
  //   List<Map<String, dynamic>> tempData = siteData.where((site) {
  //     if (selectedRegion != null && selectedRegion != 'ALL' && site['region'] != selectedRegion) {
  //       return false;
  //     }
  //     if (selectedStation != null && site['station'] != selectedStation) {
  //       return false;
  //     }
  //     if (selectedRtom != null && site['rtom'] != selectedRtom) {
  //       return false;
  //     }
  //     return true;
  //   }).toList();
  //
  //   setState(() {
  //     filteredSiteData = tempData;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Data',
          style: TextStyle(
            color: customColors.mainTextColor,
            fontFamily: 'outfit',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: customColors.appbarColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: customColors.mainTextColor),
        actions: [
        ThemeToggleButton(), // Use the reusable widget
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          color:
              customColors
                  .mainBackgroundColor, // Set the body background color to black
          child:
              isLoading
                  ? const Center(
                    child: CircularProgressIndicator(),
                  ) // Show spinner
                  : filteredSiteData.isEmpty
                  ? const Center(
                    child: Text(
                      'No data found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SearchWidget(
                          onSearch: handleSearch,
                          hintText: 'Search...',
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          dropdownColor: customColors.suqarBackgroundColor,
                          value: selectedRegion,
                          hint: Text(
                            'ALL',
                            style: TextStyle(color: customColors.mainTextColor),
                          ),
                          items:
                              regions.map((String region) {
                                return DropdownMenuItem<String>(
                                  value: region,
                                  child: Text(
                                    region,
                                    style: TextStyle(
                                      color: customColors.mainTextColor,
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedRegion = value;
                              selectedStation = null;
                              selectedRtom = null;
                              stations = [];
                              rToms = [];
                              if (value != null) {
                                filterData();
                                if (value != 'ALL') {
                                  fetchStations(value);
                                }
                              }
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          dropdownColor: customColors.suqarBackgroundColor,
                          value: selectedStation,
                          hint: Text(
                            'Select Station',
                            style: TextStyle(color: customColors.mainTextColor),
                          ),
                          items:
                              stations.map((String station) {
                                return DropdownMenuItem<String>(
                                  value: station,
                                  child: Text(
                                    station,
                                    style: TextStyle(
                                      color: customColors.mainTextColor,
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedStation = value;
                              selectedRtom = null;
                              rToms = [];
                              if (value != null) {
                                filterData();
                                fetchRtoms(selectedRegion!, value);
                              }
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          dropdownColor: customColors.suqarBackgroundColor,
                          value: selectedRtom,
                          hint: Text(
                            'Select RTOM',
                            style: TextStyle(color: customColors.mainTextColor),
                          ),
                          items:
                              rToms.map((String rtom) {
                                return DropdownMenuItem<String>(
                                  value: rtom,
                                  child: Text(
                                    rtom,
                                    style: TextStyle(
                                      color: customColors.mainTextColor,
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedRtom = value;
                              filterData();
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (isLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (filteredSiteData.isEmpty)
                          const Center(
                            child: Text(
                              'No data found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        else
                          ...filteredSiteData.map((data) {
                            return Card(
                              color:
                                  customColors
                                      .suqarBackgroundColor, // Square background color
                              child: ListTile(
                                title: Text(
                                  'Station: ${data['station']}',
                                  style: TextStyle(
                                    color: customColors.mainTextColor,
                                  ), // Main text color
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Region: ${data['region']}',
                                      style: TextStyle(
                                        color: customColors.subTextColor,
                                      ), // Subtext color
                                    ),
                                    Text(
                                      'Station address: ${data['station_address']}',
                                      style: TextStyle(
                                        color: customColors.subTextColor,
                                      ), // Subtext color
                                    ),
                                    Text(
                                      'RTOM: ${data['rtom']}',
                                      style: TextStyle(
                                        color: customColors.subTextColor,
                                      ), // Subtext color
                                    ),
                                    Text(
                                      'Capacity: ${data['solar_system_capacity_kWp']} kWp',
                                      style: TextStyle(
                                        color: customColors.subTextColor,
                                      ), // Subtext color
                                    ),
                                  ],
                                ),

                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => SiteDetailScreen(
                                            siteData: data,
                                            searchQuery: searchQuery,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }).toList(),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}
