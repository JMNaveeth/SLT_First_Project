import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
      var tempFiltered = selectedRegion == 'All'
          ? lvBreakers
          : lvBreakers.where((panel) => panel['Region'] == selectedRegion)
          .toList();

      // Then filter by search query if it exists
      if (searchQuery.isNotEmpty) {
        tempFiltered = tempFiltered.where((panel) =>
            SearchHelperLVBreaker.matchesLVBreakerQuery(panel, searchQuery))
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('View LV Breaker Panels', style: TextStyle(color: mainTextColor),),
        iconTheme: IconThemeData(
          color: mainTextColor,
        ),
        backgroundColor: appbarColor,
        foregroundColor: mainTextColor,
      ),
      backgroundColor: mainBackgroundColor,
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
                      decoration: const InputDecoration(
                        labelText: 'Select Region',
                        labelStyle: TextStyle(color: subTextColor),
                        filled: true,
                        fillColor: mainBackgroundColor,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 2.0),
                        ),
                      ),
                      style: const TextStyle(
                        color: mainTextColor,
                      ),
                      dropdownColor: suqarBackgroundColor,
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.white),
                      onChanged: handleRegionChange,
                      items: regions.map((String region) {
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
                              color: Colors.white,
                              width: 1.0,
                            ),
                            children: [
                              // Table Header
                              const TableRow(
                                decoration: BoxDecoration(
                                  color: mainBackgroundColor,
                                ),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Summary',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: mainTextColor,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Count',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: mainTextColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Table Row for Total Panels
                              TableRow(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Total Panels',
                                      style: TextStyle(
                                        color: subTextColor, // White text
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${filteredLvBreakers.length}',
                                      style: const TextStyle(
                                        color: subTextColor, // White text
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
                          child: filteredLvBreakers.isEmpty
                              ? Center(
                                  child: Text(
                                    'No results found for "$searchQuery"',
                                    style: const TextStyle(
                                      color: mainTextColor,
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
                                            builder: (context) =>
                                                LVBreakerDetailPage(
                                                    breaker: panel,
                                                  searchQuery: searchQuery,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        elevation: 5,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 30,
                                          vertical: 10,
                                        ),
                                        color: suqarBackgroundColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        shadowColor: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Display summarized information
                                              Text(
                                                '${panel['Building']} - ${panel['Room']}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: subTextColor),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Location - ${panel['Region']} ${panel['RTOM']}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: subTextColor,
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
