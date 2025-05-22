import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';

//import '../../../UserAccess.dart';
import 'DEGRoutineInspection.dart';

class selectDEGToInspect extends StatefulWidget {
  @override
  _selectDEGToInspectState createState() => _selectDEGToInspectState();
}

class _selectDEGToInspectState extends State<selectDEGToInspect> {
  var regions = [
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
    'UVA',
  ];

  String selectedRegion = 'ALL'; // Initial selected region
  List<dynamic> DEGSystems = []; // List to store Rectifier system data
  bool isLoading = true; // Flag to track if data is being loaded

  Future<void> fetchDEGSystems() async {
    final url =
        'https://powerprox.sltidc.lk/getdata.php'; // Replace with the URL of your PHP script

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        DEGSystems = json.decode(response.body);
        isLoading = false; // Set isLoading to false once data is loaded
      });
    } else {
      // Handle the error case
      print('Failed to fetch Rectifier systems');
      isLoading = false; // Set isLoading to false in case of an error
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDEGSystems();
  }

  void navigateToDEGUnitDetails({required DEGUnit, required String region}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DEGRoutineInspection(DEGUnit: DEGUnit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //  UserAccess userAccess = Provider.of<UserAccess>(context, listen: true); // Use listen: true to rebuild the widget when the data changes
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: customColors.appbarColor,
        title: Text(
          'Generator Details',
          style: TextStyle(color: customColors.mainTextColor),
        ),
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
        iconTheme: IconThemeData(color: customColors.mainTextColor),
      ),
      body: Container(
        // Add Container widget
        color:
            customColors.mainBackgroundColor, // Set background color to white
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<String>(
                value: selectedRegion,
                style: TextStyle(color: customColors.mainTextColor),
                decoration: InputDecoration(labelText: 'Select Region'),
                dropdownColor: customColors.suqarBackgroundColor,
                onChanged: (value) {
                  setState(() {
                    selectedRegion = value!;
                  });
                },
                items:
                    regions.map((region) {
                      return DropdownMenuItem<String>(
                        value: region,
                        child: Text(region),
                      );
                    }).toList(),
              ),
            ),
            Expanded(
              child:
                  isLoading
                      ? Center(
                        child:
                            CircularProgressIndicator(), // Show loading indicator
                      )
                      : ListView.builder(
                        itemCount: DEGSystems.length,
                        itemBuilder: (context, index) {
                          final system = DEGSystems[index];
                          if (selectedRegion == 'ALL' ||
                              system['province'] == selectedRegion) {
                            return Card( // This is our new pretty box!
                              elevation: 5, // A little shadow
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16, // Space on the sides
                                vertical: 8,    // Space top and bottom
                              ),
                              color: customColors.suqarBackgroundColor, // Background color from your theme
                              shape: RoundedRectangleBorder( // Rounded corners
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ListTile(
                                title: Text(
                                  '${system['brand_set']} - ${system['model_set']}',
                                  style: TextStyle(color: customColors.mainTextColor), // Text color for the title
                                ),
                                subtitle: Text(
                                  'Location: ${system['station']}',
                                  style: TextStyle(color: customColors.subTextColor), // Text color for the subtitle
                                ),
                                onTap: () {
                                  navigateToDEGUnitDetails(
                                    DEGUnit: system,
                                    region:
                                        "${system['province']}-${system['Rtom_name']}",
                                  );
                                },
                              ),
                            );
                          } else {
                            return SizedBox.shrink(); // Return an empty SizedBox for non-matching regions
                          }
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
