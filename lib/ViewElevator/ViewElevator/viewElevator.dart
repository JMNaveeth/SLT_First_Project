import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../utils/utils/colors.dart';
import '../../widgets/searchWidget.dart';
import 'search_helper_elevator.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher.dart';

class ViewElevatorDetails extends StatefulWidget {
  @override
  _ViewElevatorDetailsState createState() => _ViewElevatorDetailsState();
}

class _ViewElevatorDetailsState extends State<ViewElevatorDetails> {
  List<dynamic> elevators = [];
  List<dynamic> filteredElevators = [];
  bool isLoading = true;
  String errorMessage = '';
  String selectedRegion = 'ALL';
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
    'UVA'
  ];

  @override
  void initState() {
    super.initState();
    fetchElevatorDetails();
  }

  Future<void> fetchElevatorDetails() async {
    final url = 'https://powerprox.sltidc.lk/GETElevators.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          setState(() {
            elevators = data;
            filteredElevators = elevators;
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Invalid data format received from server.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage =
          'Failed to load elevators. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load elevators. Error: $e';
        isLoading = false;
      });
    }
  }

  void applyFilters() {
    setState(() {
      // First filter by region
      var tempFiltered = selectedRegion == 'ALL'
          ? elevators
          : elevators.where((elevator) {
        return (elevator['Region'] ?? '').toString().toUpperCase() ==
            selectedRegion.toUpperCase();
      }).toList();

      // Then filter by search query if it exists
      if (searchQuery.isNotEmpty) {
        tempFiltered = tempFiltered.where((elevator) =>
            SearchHelperElevator.matchesElevatorQuery(elevator, searchQuery))
            .toList();
      }

      filteredElevators = tempFiltered;
    });
  }

  void handleSearch(String query) {
    setState(() {
      searchQuery = query;
      applyFilters();
    });
  }

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
        title: const Text('Elevator Details'),
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
                : errorMessage.isNotEmpty
                ? Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
            )
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
                        // Table Row for Total Elevators
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Total Elevators',
                                style: TextStyle(
                                  color: subTextColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${filteredElevators.length}',
                                style: const TextStyle(
                                  color: subTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // List of Elevators
                  Expanded(
                    child: filteredElevators.isEmpty
                        ? Center(
                      child: Text(
                        searchQuery.isEmpty
                            ? 'No elevators found'
                            : 'No results found for "$searchQuery"',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    )
                        : ListView.builder(
                      itemCount: filteredElevators.length,
                      itemBuilder: (context, index) {
                        final elevator = filteredElevators[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewElevatorUnit(
                                        elevator: elevator,
                                      searchQuery: searchQuery,),
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
                                  Text(
                                    'Elevator ID: ${elevator['LiftID']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: subTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Location: ${elevator['Region']} - ${elevator['RTOM']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: subTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Building: ${elevator['eBuilding']}',
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

// class _ViewElevatorDetailsState extends State<ViewElevatorDetails> {
//   List<dynamic> elevators = [];
//   List<dynamic> filteredElevators = [];
//   bool isLoading = true;
//   String errorMessage = '';
//   String selectedRegion = 'ALL';
//
//   final List<String> regions = [
//     'ALL',
//     'CPN',
//     'CPS',
//     'EPN',
//     'EPS',
//     'EPN–TC',
//     'HQ',
//     'NCP',
//     'NPN',
//     'NPS',
//     'NWPE',
//     'NWPW',
//     'PITI',
//     'SAB',
//     'SMW6',
//     'SPE',
//     'SPW',
//     'WEL',
//     'WPC',
//     'WPE',
//     'WPN',
//     'WPNE',
//     'WPS',
//     'WPSE',
//     'WPSW',
//     'UVA'
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchElevatorDetails();
//   }
//
//   Future<void> fetchElevatorDetails() async {
//     final url = 'https://powerprox.sltidc.lk/GETElevators.php';
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data is List) {
//           setState(() {
//             elevators = data;
//             filteredElevators = elevators;
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             errorMessage = 'Invalid data format received from server.';
//             isLoading = false;
//           });
//         }
//       } else {
//         setState(() {
//           errorMessage =
//               'Failed to load elevators. Status code: ${response.statusCode}';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Failed to load elevators. Error: $e';
//         isLoading = false;
//       });
//     }
//   }
//
//   void filterElevatorsByRegion(String region) {
//     setState(() {
//       if (region == 'ALL') {
//         filteredElevators = elevators;
//       } else {
//         filteredElevators = elevators.where((elevator) {
//           return (elevator['Region'] ?? '').toString().toUpperCase() ==
//               region.toUpperCase();
//         }).toList();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Elevator Details', style: TextStyle(color: Colors.white)),
//         backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : errorMessage.isNotEmpty
//               ? Center(child: Text(errorMessage))
//               : Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16.0, vertical: 8.0),
//                       child: DropdownButtonFormField<String>(
//                         decoration: InputDecoration(
//                           labelText: 'Select Region',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 16),
//                         ),
//                         value:
//                             selectedRegion.isNotEmpty ? selectedRegion : null,
//                         hint: const Text('Choose a region'),
//                         onChanged: (String? newValue) {
//                           if (newValue != null) {
//                             setState(() {
//                               selectedRegion = newValue;
//                               filterElevatorsByRegion(selectedRegion);
//                             });
//                           }
//                         },
//                         items: regions
//                             .map<DropdownMenuItem<String>>((String region) {
//                           return DropdownMenuItem<String>(
//                             value: region,
//                             child: Text(region),
//                           );
//                         }).toList(),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please select a region';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     Expanded(
//                       child: filteredElevators.isNotEmpty
//                           ? ListView.builder(
//                               itemCount: filteredElevators.length,
//                               itemBuilder: (context, index) {
//                                 final elevator = filteredElevators[index];
//                                 return Card(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   elevation: 2,
//                                   color: const Color.fromARGB(255, 255, 255,
//                                       255), // Light background color for the card
//                                   margin: const EdgeInsets.symmetric(
//                                       vertical: 3, horizontal: 12),
//                                   child: ListTile(
//                                     contentPadding: const EdgeInsets.symmetric(
//                                       vertical: 10,
//                                       horizontal: 16,
//                                     ),
//                                     title: Text(
//                                       'Elevator ID: ${elevator['LiftID']}',
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w500,
//                                         color:
//                                             const Color.fromARGB(255, 0, 0, 0),
//                                       ),
//                                     ),
//                                     subtitle: Text(
//                                       'Region: ${elevator['Region']} : RTOM: ${elevator['RTOM']} : Station: ${elevator['Station']} : Building: ${elevator['eBuilding']}',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: const Color.fromARGB(
//                                             255, 34, 33, 33),
//                                       ),
//                                     ),
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               ViewElevatorUnit(
//                                                   elevator: elevator),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 );
//                               },
//                             )
//                           : Center(
//                               child: Text(
//                                 'No elevators found for the selected region.',
//                                 style:
//                                     TextStyle(fontSize: 16, color: Colors.grey),
//                               ),
//                             ),
//                     ),
//                   ],
//                 ),
//     );
//   }
// }

class ViewElevatorUnit extends StatelessWidget {
  final dynamic elevator;
  final String searchQuery;

  ViewElevatorUnit({required this.elevator, this.searchQuery = ''});

  String getFieldValue(dynamic data, List<String> possibleKeys) {
    for (var key in possibleKeys) {
      if (data.containsKey(key) &&
          data[key] != null &&
          data[key].toString().isNotEmpty) {
        return data[key].toString();
      }
    }
    return 'N/A';
  }

  String formatDateTime(String dateTimeStr) {
    List<String> formats = [
      'yyyy-MM-dd HH:mm:ss',
      'yyyy-MM-ddTHH:mm:ssZ',
      'dd-MM-yyyy HH:mm'
    ];
    for (var format in formats) {
      try {
        DateFormat formatter = DateFormat(format);
        DateTime dateTime = formatter.parseStrict(dateTimeStr);
        final DateFormat outputFormatter = DateFormat('dd-MM-yyyy HH:mm');
        return outputFormatter.format(dateTime);
      } catch (e) {
        continue;
      }
    }
    return dateTimeStr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,
        title:
            Text('Elevator Details - ${getFieldValue(elevator, ['LiftID'])}',
              style: const TextStyle(color: mainTextColor),),
        iconTheme: IconThemeData(
          color: mainTextColor,
        ),
      ),
      backgroundColor: mainBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard('Elevator Identification', [
              // _buildDetailRow('Lift ID:', getFieldValue(elevator, ['LiftID'])),
              _buildDetailRow('QR Tag:', getFieldValue(elevator, ['QrTag'])),
              _buildDetailRow('Region:', getFieldValue(elevator, ['Region'])),
              _buildDetailRow('RTOM:', getFieldValue(elevator, ['RTOM'])),
              _buildDetailRow('Station:', getFieldValue(elevator, ['Station'])),
              _buildDetailRow(
                  'Building:', getFieldValue(elevator, ['eBuilding'])),
              _buildDetailRow('Number of Floors:',
                  getFieldValue(elevator, ['eNoOfFloors'])),
              _buildDetailRow(
                  'Latitude:', getFieldValue(elevator, ['latitude'])),
              _buildDetailRow(
                  'Longitude:', getFieldValue(elevator, ['longitude'])),
            ]),
            const SizedBox(height: 16),
            // _buildInfoCard('Location', []),
            const SizedBox(height: 16),
            _buildInfoCard('Specifications', [
              _buildDetailRow(
                  'Lift Capacity:', getFieldValue(elevator, ['eLiftCapacity'])),
              _buildDetailRow(
                  'Lift Type:', getFieldValue(elevator, ['eLiftType'])),
              _buildDetailRow(
                  'Manufacturer:', getFieldValue(elevator, ['eManufacturer'])),
            ]),
            const SizedBox(height: 16),
            _buildInfoCard('Maintenance Details', [
              _buildDetailRow('Status:', getFieldValue(elevator, ['eStatus'])),
              _buildDetailRow('Installation Date:',
                  getFieldValue(elevator, ['eInstallationDate'])),
              // _buildDetailRow('Last Maintenance Date:',
              //     getFieldValue(elevator, ['eLastMaintenanceDate'])),
              // _buildDetailRow('Next Maintenance Due:',
              //     getFieldValue(elevator, ['eNextMaintenanceDue'])),
            ]),
            const SizedBox(height: 16),
            _buildInfoCard('AMC & Service Provider Details', [
              _buildDetailRow(
                  'AMC Available:', getFieldValue(elevator, ['eAmcAvailable'])),
              _buildDetailRow('Service Provider Name:',
                  getFieldValue(elevator, ['eServiceProvider'])),
              // _buildDetailRow('Contact Number:',
              //     getFieldValue(elevator, ['contactNumber'])),
              // _buildDetailRow('Email:', getFieldValue(elevator, ['email'])),
              // _buildDetailRowCallable(
              //   'Contact Number:',
              //   getFieldValue(elevator, ['contactNumber']) ?? 'N/A',
              //   uri: Uri(
              //     scheme: 'tel',
              //     path: getFieldValue(elevator, ['contactNumber']),
              //   ),
              // ),

              // _buildDetailRowCallable(
              //   'Email:',
              //   getFieldValue(elevator, ['email']) ?? 'N/A',
              //   uri: Uri(
              //     scheme: 'mailto',
              //     path: getFieldValue(elevator, ['email']),
              //   ),
              // ),
              _buildDetailRow2(
                'Contact Number:',
                getFieldValue(elevator, ['contactNumber']),
                isContact: true,
              ),
              _buildDetailRow2(
                'Email:',
                getFieldValue(elevator, ['email']),
                isEmail: true,
              ),
            ]),
            const SizedBox(height: 16),
            // _buildInfoCard('Contact Details', []),
            const SizedBox(height: 16),
            // _buildInfoCard('Additional Information', [
            // ]),
            const SizedBox(height: 16),
            _buildInfoCard('Update Information', [
              _buildDetailRow('Updated Time:',
                  formatDateTime(getFieldValue(elevator, ['updatedTime']))),
              _buildDetailRow(
                  'Updated By:', getFieldValue(elevator, ['updatedBy'])),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> details) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      color: suqarBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: mainTextColor)),
            const SizedBox(height: 10),
            const Divider(),
            ...details,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    if (value == 'N/A') return const SizedBox.shrink();
    final bool isMatch = searchQuery.isNotEmpty &&
        value.toLowerCase().contains(searchQuery.toLowerCase());

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 6.0, horizontal: 8.0), // Margins between rows
      child: Container(
        decoration: BoxDecoration(
          color: isMatch ? highlightColor : suqarBackgroundColor,
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
        ),
        padding: const EdgeInsets.all(12.0), // Inner padding for content
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: mainTextColor, // Label color
              ),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: subTextColor,
                  backgroundColor: isMatch ? highlightColor : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow2(String label, String value,
      {bool isContact = false, bool isEmail = false}) {
    if (value == 'N/A') return const SizedBox.shrink();

    final bool isMatch = searchQuery.isNotEmpty &&
        value.toLowerCase().contains(searchQuery.toLowerCase());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: isMatch ? highlightColor : suqarBackgroundColor,
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
        ),
        padding: const EdgeInsets.all(12.0), // Inner padding for content
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: mainTextColor, // Label color
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (isContact) {
                    // Make the number callable
                    // launchUrl(Uri.parse('tel:$value'));
                  } else if (isEmail) {
                    // Open the default email client
                    // launchUrl(Uri.parse('mailto:$value'));
                  }
                },
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isContact || isEmail ? const Color.fromARGB(255, 5, 129, 231) : mainTextColor,
                    decoration: isContact || isEmail
                        ? TextDecoration.underline
                        : TextDecoration.none,
                    backgroundColor: isMatch ? highlightColor : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
