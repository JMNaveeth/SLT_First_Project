import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:theme_update/theme_provider.dart';
// import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/widgets/theme%20change%20related%20widjets/theme_provider.dart';
import 'package:theme_update/widgets/theme%20change%20related%20widjets/theme_toggle_button.dart';
import 'dart:convert';
import '../../utils/utils/colors.dart';
import '../../widgets/searchWidget.dart';
import 'lv_breaker_detail_page.dart';
import 'search_helper_lv_breaker.dart';

class ViewLVBreaker extends StatefulWidget {
  @override
  _ViewLVBreakerState createState() => _ViewLVBreakerState();
}

class _ViewLVBreakerState extends State<ViewLVBreaker> {
  List<dynamic> lvBreakers = [];
  List<dynamic> filteredLvBreakers = [];
  List<String> regions = [];
  String selectedRegion = 'All';
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchLVBreakers();
  }

  // Fetch LV Breakers and regions from the API
  Future<void> fetchLVBreakers() async {
    const url = 'https://powerprox.sltidc.lk/GET_LV_Panel_ACPDB.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          lvBreakers = json.decode(response.body);
          filteredLvBreakers = lvBreakers;
          regions = getUniqueRegions(lvBreakers);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data: ${response.body}');
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to get unique regions from LV Breakers
  List<String> getUniqueRegions(List<dynamic> lvBreakers) {
    Set<String> uniqueRegions = {};
    for (var panel in lvBreakers) {
      if (panel['Region'] != null) {
        // Ensures no null values
        uniqueRegions.add(panel['Region']);
      }
    }
    return ['All', ...uniqueRegions.toList()];
  }

  void applyFilters() {
    setState(() {
      // First filter by region
      var tempFiltered =
          selectedRegion == 'All'
              ? lvBreakers
              : lvBreakers
                  .where((panel) => panel['Region'] == selectedRegion)
                  .toList();

      // Then filter by search query if it exists
      if (searchQuery.isNotEmpty) {
        tempFiltered =
            tempFiltered
                .where(
                  (panel) => SearchHelperLVBreaker.matchesLVBreakerQuery(
                    panel,
                    searchQuery,
                  ),
                )
                .toList();
      }

      filteredLvBreakers = tempFiltered;
    });
  }

  // Handle search query changes
  void handleSearch(String query) {
    setState(() {
      searchQuery = query;
      applyFilters();
    });
  }

  // Handle region selection changes
  void handleRegionChange(String? region) {
    if (region != null) {
      setState(() {
        selectedRegion = region;
        applyFilters();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View LV Breaker Panels',
          style: TextStyle(color: customColors.mainTextColor),
        ),
        iconTheme: IconThemeData(color: customColors.mainTextColor),
        backgroundColor: customColors.appbarColor,
        foregroundColor: customColors.mainTextColor,
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),
      backgroundColor: customColors.mainBackgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: selectedRegion,
                      decoration: InputDecoration(
                        labelText: 'Select Region',
                        labelStyle: TextStyle(color: customColors.subTextColor),
                        filled: true,
                        fillColor: customColors.mainBackgroundColor,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: customColors.subTextColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: customColors.subTextColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: customColors.subTextColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                      style: TextStyle(color: customColors.mainTextColor),
                      dropdownColor: customColors.suqarBackgroundColor,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: customColors.mainTextColor,
                      ),
                      onChanged: handleRegionChange,
                      items:
                          [
                            'All',
                            ...lvBreakers
                                .map(
                                  (panel) => (panel['Region'] ?? '').toString(),
                                )
                                .where(
                                  (region) => region.trim().isNotEmpty,
                                ) // <-- Only non-empty regions
                                .toSet()
                                .toList(),
                          ].map((region) {
                            return DropdownMenuItem<String>(
                              value: region,
                              child: Text(region),
                            );
                          }).toList(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: SearchWidget(
                      onSearch: handleSearch,
                      hintText: 'Search...',
                    ),
                  ),
                ],
              ),
            ),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                  child: Column(
                    children: [
                      // Summary Table
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Table(
                          border: TableBorder.all(
                            color: customColors.subTextColor,
                            width: 1.0,
                          ),
                          children: [
                            // Table Header
                            TableRow(
                              decoration: BoxDecoration(
                                color: customColors.mainBackgroundColor,
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Summary',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: customColors.mainTextColor,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Count',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: customColors.mainTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Table Row for Total Panels
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Total Panels',
                                    style: TextStyle(
                                      color:
                                          customColors
                                              .subTextColor, // White text
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${filteredLvBreakers.length}',
                                    style: TextStyle(
                                      color:
                                          customColors
                                              .subTextColor, // White text
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // List of LV Breakers
                      Expanded(
                        child:
                            filteredLvBreakers.isEmpty
                                ? Center(
                                  child: Text(
                                    'No results found for "$searchQuery"',
                                    style: TextStyle(
                                      color: customColors.mainTextColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                                : ListView.builder(
                                  itemCount: filteredLvBreakers.length,
                                  itemBuilder: (context, index) {
                                    final panel = filteredLvBreakers[index];
                                    return GestureDetector(
                                      onTap: () {
                                        // Navigate to the detail page when tapped
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    LVBreakerDetailPage(
                                                      breaker: panel,
                                                      searchQuery: searchQuery,
                                                    ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        elevation: 5,
                                        // margin: const EdgeInsets.symmetric(
                                        //   horizontal: 30,
                                        //   vertical: 10,
                                        // ),
                                        color:
                                            customColors.suqarBackgroundColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4.0,
                                          ),
                                        ),
                                        shadowColor: customColors.subTextColor,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Display summarized information
                                              Text(
                                                '${panel['Building']} - ${panel['Room']}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color:
                                                      customColors.subTextColor,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Location - ${panel['Region']} ${panel['RTOM']}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color:
                                                      customColors.subTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
