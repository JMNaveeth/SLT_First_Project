import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:powerprox/Screens/Generators/ViewGeneratorV2/search_helper_generator.dart';

import '../../../Widgets/SearchWidget/searchWidget.dart';
import '../../HomePage/widgets/colors.dart';
import 'GenInfoPage.dart';




class ViewGenerator extends StatefulWidget {
  @override
  _ViewGeneratorState createState() => _ViewGeneratorState();
}

class _ViewGeneratorState extends State<ViewGenerator> {
  List<dynamic> generators = [];
  List<dynamic> filteredGenerators = [];
  bool isLoading = true;
  String searchQuery = '';
  int _selectedTabIndex = 0;
  final List<String> tabs = ['Fixed', 'Mobile', 'Portable'];
  List<String> provinces = ['All'];
  String selectedProvince = 'All';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchGenerators();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchGenerators() async {
    const url = 'https://powerprox.sltidc.lk/GETGenerators.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          generators = data;
          filteredGenerators = data;
          provinces = ['All', ..._getUniqueProvinces(data)];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data: ${response.body}');
      }
    } catch (error) {
      // print('Error fetching data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<String> _getUniqueProvinces(List<dynamic> generators) {
    Set<String> uniqueProvinces = {};
    for (var generator in generators) {
      if (generator['province'] != null) {
        uniqueProvinces.add(generator['province']);
      }
    }
    return uniqueProvinces.toList();
  }

  void applyFilters() {
    setState(() {
      // First filter by province
      var tempFiltered = selectedProvince == 'All'
          ? generators
          : generators
          .where((gen) => gen['province'] == selectedProvince)
          .toList();

      // Then filter by search query if it exists
      if (searchQuery.isNotEmpty) {
        tempFiltered = tempFiltered
            .where((gen) =>
            SearchHelperGenerator.matchesGeneratorQuery(gen, searchQuery))
            .toList();
      }

      filteredGenerators = tempFiltered;
    });
  }

  void handleSearch(String query) {
    setState(() {
      searchQuery = query;
      applyFilters();
    });
  }

  void handleProvinceChange(String? province) {
    if (province != null) {
      setState(() {
        selectedProvince = province;
        applyFilters();
      });
    }
  }

  List<dynamic> _getGeneratorsByCategory(String category) {
    return filteredGenerators
        .where((gen) => gen['category'] == category)
        .toList();
  }

  Widget _buildSummaryCard() {
    return Card(
      color: suqarBackgroundColor,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Generator Info',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: mainTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Total Number of Generators: ${filteredGenerators.length}',
              style: const TextStyle(
                fontSize: 16,
                color: subTextColor,
              ),
            ),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(color: Colors.white, width: 1.0),
              children: [
                const TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Fixed',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: mainTextColor,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Mobile',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: mainTextColor,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Portable',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: mainTextColor,
                          )),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          '${filteredGenerators.where((gen) => gen['category'] == 'Fixed').length}',
                          style: const TextStyle(color: subTextColor)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          '${filteredGenerators.where((gen) => gen['category'] == 'Mobile').length}',
                          style: const TextStyle(color: subTextColor)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          '${filteredGenerators.where((gen) => gen['category'] == 'Portable').length}',
                          style: const TextStyle(color: subTextColor)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneratorList(String category) {
    final categoryGenerators = _getGeneratorsByCategory(category);

    if (categoryGenerators.isEmpty) {
      return Center(
        child: Text(
          'No ${category.toLowerCase()} generators found',
          style: const TextStyle(
            color: mainTextColor,
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: categoryGenerators.length,
      itemBuilder: (context, index) {
        final generator = categoryGenerators[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GenInfoPage(data: generator),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 16),
            color: suqarBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    generator['station'] ?? 'Unknown Station',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: mainTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${generator['Rtom_name'] ?? 'Unknown Location'} (${generator['province'] ?? ''})',
                    style: const TextStyle(
                      fontSize: 16,
                      color: subTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Capacity: ${generator['set_cap'] ?? 'N/A'} kVA',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generator View Page',
            style: TextStyle(color: mainTextColor)),
        iconTheme: const IconThemeData(color: mainTextColor),
        backgroundColor: appbarColor,
        foregroundColor: mainTextColor,
      ),
      backgroundColor: mainBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: selectedProvince,
                        decoration: const InputDecoration(
                          labelText: 'Select Province',
                          labelStyle: TextStyle(color: subTextColor),
                          filled: true,
                          fillColor: mainBackgroundColor,
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                        style: const TextStyle(color: mainTextColor),
                        dropdownColor: suqarBackgroundColor,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white),
                        onChanged: handleProvinceChange,
                        items: provinces.map((String province) {
                          return DropdownMenuItem<String>(
                            value: province,
                            child: Text(province),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: SearchWidget(
                        onSearch: handleSearch,
                        hintText: 'Search Generator...',
                      ),
                    ),
                  ],
                ),
              ),
              isLoading
                  ? const Expanded(
                  child: Center(child: CircularProgressIndicator()))
                  : Expanded(
                child: DefaultTabController(
                  length: tabs.length,
                  child: Column(
                    children: [
                      Flexible(
                        flex: 2,
                        child: SingleChildScrollView(
                          child: _buildSummaryCard(),
                        ),
                      ),
                      Container(
                        margin:
                        const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: TabBar(
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                              width: 2.0,
                            ),
                          ),
                          labelColor: Colors.blueAccent,
                          unselectedLabelColor: subTextColor,
                          tabs:
                          tabs.map((tab) => Tab(text: tab)).toList(),
                          onTap: (index) {
                            setState(() {
                              _selectedTabIndex = index;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        flex: 3,
                        child: TabBarView(
                          children: tabs.map((tab) {
                            return _buildGeneratorList(tab);
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:powerprox/Screens/Generators/ViewGeneratorV2/search_helper_generator.dart';
//
// import '../../../Widgets/SearchWidget/searchWidget.dart';
// import '../../HomePage/widgets/colors.dart';
// import 'GenInfoPage.dart';
//
// class ViewGenerator extends StatefulWidget {
//   @override
//   _ViewGeneratorState createState() => _ViewGeneratorState();
// }
//
// class _ViewGeneratorState extends State<ViewGenerator> {
//   List<dynamic> generators = [];
//   List<dynamic> filteredGenerators = [];
//   bool isLoading = true;
//   String searchQuery = '';
//   int _selectedTabIndex = 0;
//   final List<String> tabs = ['Fixed', 'Mobile', 'Portable'];
//   List<String> provinces = ['All'];
//   String selectedProvince = 'All';
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchGenerators();
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   Future<void> fetchGenerators() async {
//     const url = 'https://powerprox.sltidc.lk/GETGenerators.php';
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           generators = data;
//           filteredGenerators = data;
//           provinces = ['All', ..._getUniqueProvinces(data)];
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load data: ${response.body}');
//       }
//     } catch (error) {
//       // print('Error fetching data: $error');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   List<String> _getUniqueProvinces(List<dynamic> generators) {
//     Set<String> uniqueProvinces = {};
//     for (var generator in generators) {
//       if (generator['province'] != null) {
//         uniqueProvinces.add(generator['province']);
//       }
//     }
//     return uniqueProvinces.toList();
//   }
//
//   void applyFilters() {
//     setState(() {
//       // First filter by province
//       var tempFiltered = selectedProvince == 'All'
//           ? generators
//           : generators
//           .where((gen) => gen['province'] == selectedProvince)
//           .toList();
//
//       // Then filter by search query if it exists
//       if (searchQuery.isNotEmpty) {
//         tempFiltered = tempFiltered
//             .where((gen) =>
//             SearchHelperGenerator.matchesGeneratorQuery(gen, searchQuery))
//             .toList();
//       }
//
//       filteredGenerators = tempFiltered;
//     });
//   }
//
//   void handleSearch(String query) {
//     setState(() {
//       searchQuery = query;
//       applyFilters();
//     });
//   }
//
//   void handleProvinceChange(String? province) {
//     if (province != null) {
//       setState(() {
//         selectedProvince = province;
//         applyFilters();
//       });
//     }
//   }
//
//   List<dynamic> _getGeneratorsByCategory(String category) {
//     return filteredGenerators
//         .where((gen) => gen['category'] == category)
//         .toList();
//   }
//
//   Widget _buildSummaryCard() {
//     return Card(
//       color: suqarBackgroundColor,
//       margin: const EdgeInsets.all(16),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Generator Info',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: mainTextColor,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Total Number of Generators: ${filteredGenerators.length}',
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: subTextColor,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Table(
//               border: TableBorder.all(color: Colors.white, width: 1.0),
//               children: [
//                 const TableRow(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text('Fixed',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: mainTextColor,
//                           )),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text('Mobile',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: mainTextColor,
//                           )),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text('Portable',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: mainTextColor,
//                           )),
//                     ),
//                   ],
//                 ),
//                 TableRow(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                           '${filteredGenerators.where((gen) => gen['category'] == 'Fixed').length}',
//                           style: const TextStyle(color: subTextColor)),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                           '${filteredGenerators.where((gen) => gen['category'] == 'Mobile').length}',
//                           style: const TextStyle(color: subTextColor)),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                           '${filteredGenerators.where((gen) => gen['category'] == 'Portable').length}',
//                           style: const TextStyle(color: subTextColor)),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Widget _buildGeneratorList(String category) {
//   //   final categoryGenerators = _getGeneratorsByCategory(category);
//
//   //   if (categoryGenerators.isEmpty) {
//   //     return Center(
//   //       child: Text(
//   //         'No ${category.toLowerCase()} generators found',
//   //         style: const TextStyle(
//   //           color: mainTextColor,
//   //           fontSize: 16,
//   //         ),
//   //       ),
//   //     );
//   //   }
//
//   //   return ListView.builder(
//   //     controller: _scrollController,
//   //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//   //     itemCount: categoryGenerators.length,
//   //     itemBuilder: (context, index) {
//   //       final generator = categoryGenerators[index];
//   //       return Card(
//   //         margin: const EdgeInsets.only(bottom: 16),
//   //         color: suqarBackgroundColor,
//   //         child: Padding(
//   //           padding: const EdgeInsets.all(16.0),
//   //           child: Column(
//   //             crossAxisAlignment: CrossAxisAlignment.start,
//   //             children: [
//   //               Text(
//   //                 generator['station'] ?? 'Unknown Station',
//   //                 style: const TextStyle(
//   //                   fontWeight: FontWeight.bold,
//   //                   fontSize: 18,
//   //                   color: mainTextColor,
//   //                 ),
//   //               ),
//   //               const SizedBox(height: 8),
//   //               Text(
//   //                 '${generator['Rtom_name'] ?? 'Unknown Location'} (${generator['province'] ?? ''})',
//   //                 style: const TextStyle(
//   //                   fontSize: 16,
//   //                   color: subTextColor,
//   //                 ),
//   //               ),
//   //               const SizedBox(height: 8),
//   //               Text(
//   //                 'Capacity: ${generator['set_cap'] ?? 'N/A'} kVA',
//   //                 style: const TextStyle(
//   //                   fontSize: 14,
//   //                   color: subTextColor,
//   //                 ),
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }
//
//   Widget _buildGeneratorList(String category) {
//     final categoryGenerators = _getGeneratorsByCategory(category);
//
//     if (categoryGenerators.isEmpty) {
//       return Center(
//         child: Text(
//           'No ${category.toLowerCase()} generators found',
//           style: const TextStyle(
//             color: mainTextColor,
//             fontSize: 16,
//           ),
//         ),
//       );
//     }
//
//     return ListView.builder(
//       controller: _scrollController,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       itemCount: categoryGenerators.length,
//       itemBuilder: (context, index) {
//         final generator = categoryGenerators[index];
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => GenInfoPage(data: generator),
//               ),
//             );
//           },
//
//           child: Card(
//             margin: const EdgeInsets.only(bottom: 16),
//             color: suqarBackgroundColor,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     generator['station'] ?? 'Unknown Station',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                       color: mainTextColor,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     '${generator['Rtom_name'] ?? 'Unknown Location'} (${generator['province'] ?? ''})',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: subTextColor,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Capacity: ${generator['set_cap'] ?? 'N/A'} kVA',
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: subTextColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Generator View Page',
//             style: TextStyle(color: mainTextColor)),
//         iconTheme: const IconThemeData(color: mainTextColor),
//         backgroundColor: appbarColor,
//         foregroundColor: mainTextColor,
//       ),
//       backgroundColor: mainBackgroundColor,
//       body: SafeArea(
//         child: GestureDetector(
//           onTap: () => FocusScope.of(context).unfocus(),
//           behavior: HitTestBehavior.opaque,
//           child: Column(
//             children: [
//               // Search and filter section with reduced padding
//               Padding(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: DropdownButtonFormField<String>(
//                         value: selectedProvince,
//                         decoration: const InputDecoration(
//                           labelText: 'Select Province',
//                           labelStyle: TextStyle(color: subTextColor),
//                           filled: true,
//                           fillColor: mainBackgroundColor,
//                           contentPadding:
//                           EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                           border: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide:
//                             BorderSide(color: Colors.grey, width: 2.0),
//                           ),
//                         ),
//                         style: const TextStyle(color: mainTextColor),
//                         dropdownColor: suqarBackgroundColor,
//                         icon: const Icon(Icons.arrow_drop_down,
//                             color: Colors.white),
//                         onChanged: handleProvinceChange,
//                         items: provinces.map((String province) {
//                           return DropdownMenuItem<String>(
//                             value: province,
//                             child: Text(province),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       flex: 3,
//                       child: SearchWidget(
//                         onSearch: handleSearch,
//                         hintText: 'Search Generator...',
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               isLoading
//                   ? const Expanded(
//                   child: Center(child: CircularProgressIndicator()))
//                   : Expanded(
//                 child: DefaultTabController(
//                   length: tabs.length,
//                   child: Column(
//                     children: [
//                       // Make the summary card scrollable if needed
//                       Expanded(
//                         flex: 2,
//                         child: SingleChildScrollView(
//                           child: _buildSummaryCard(),
//                         ),
//                       ),
//                       // Tab bar with reduced margins
//                       Container(
//                         margin:
//                         const EdgeInsets.symmetric(horizontal: 16),
//                         decoration: BoxDecoration(
//                           border: Border(
//                             bottom: BorderSide(
//                               color: Colors.grey,
//                               width: 1.0,
//                             ),
//                           ),
//                         ),
//                         child: TabBar(
//                           indicator: UnderlineTabIndicator(
//                             borderSide: BorderSide(
//                               color: Colors.blueAccent,
//                               width: 2.0,
//                             ),
//                           ),
//                           labelColor: Colors.blueAccent,
//                           unselectedLabelColor: subTextColor,
//                           tabs:
//                           tabs.map((tab) => Tab(text: tab)).toList(),
//                           onTap: (index) {
//                             setState(() {
//                               _selectedTabIndex = index;
//                             });
//                           },
//                         ),
//                       ),
//                       // Small spacing
//                       const SizedBox(height: 4),
//                       // TabBarView with flex ratio
//                       Expanded(
//                         flex: 3,
//                         child: TabBarView(
//                           children: tabs.map((tab) {
//                             return _buildGeneratorList(tab);
//                           }).toList(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
