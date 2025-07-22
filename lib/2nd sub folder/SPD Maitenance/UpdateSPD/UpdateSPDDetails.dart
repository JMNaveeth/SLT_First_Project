import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:theme_update/theme_provider.dart';
// import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/widgets/theme%20change%20related%20widjets/theme_provider.dart';
import 'package:theme_update/widgets/theme%20change%20related%20widjets/theme_toggle_button.dart';
import 'UpdateSPDACUnit.dart';
import 'UpdateSPDDCUnit.dart';

class UpdateSPDDetails extends StatefulWidget {
  @override
  _UpdateSPDDetailsState createState() => _UpdateSPDDetailsState();
}

class _UpdateSPDDetailsState extends State<UpdateSPDDetails> {
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
  String selectedRegion = 'ALL';
  List<dynamic> SPDSystems = [];
  bool isLoading = true;
  int acCount = 0;
  int dcCount = 0;

  Future<void> fetchSPDSystems() async {
    final url = 'https://powerprox.sltidc.lk/GetSPDdetails.php';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        SPDSystems = json.decode(response.body);
        _calculateSummary();
        isLoading = false;
      });
    } else {
      print('Failed to fetch SPD systems');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _calculateSummary() {
    acCount = SPDSystems.where((system) => system['DCFlag'] == '0').length;
    dcCount = SPDSystems.where((system) => system['DCFlag'] == '1').length;
  }

  @override
  void initState() {
    super.initState();
    fetchSPDSystems();
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update SPD Details',
          style: TextStyle(color: customColors.mainTextColor),
        ),
        backgroundColor: customColors.appbarColor,
        iconTheme: IconThemeData(color: customColors.mainTextColor),

        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),
      body: Container(
        // Wrap Column with a Container
        color:
            customColors
                .mainBackgroundColor, // Set the background color to white
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<String>(
                value: selectedRegion,
                style: TextStyle(color: customColors.mainTextColor),

                decoration: InputDecoration(
                  labelText: 'Select Region',
                  labelStyle: TextStyle(color: customColors.mainTextColor),
                ),
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
            _buildSummaryTable(),
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: SPDSystems.length,
                        itemBuilder: (context, index) {
                          final system = SPDSystems[index];
                          if (selectedRegion == 'ALL' ||
                              system['province'] == selectedRegion) {
                            return Card(
                              // Wrap ListTile with Card
                              elevation: 5,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              color: customColors.suqarBackgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ListTile(
                                title: Text(
                                  'Site: ${system['Rtom_name']}',
                                  style: TextStyle(
                                    color: customColors.mainTextColor,
                                  ),
                                ),
                                subtitle: Text(
                                  'Location: ${system['station']}',
                                  style: TextStyle(
                                    color: customColors.mainTextColor,
                                  ),
                                ),
                                trailing: Text(
                                  system['DCFlag'] == '0' ? 'AC' : 'DC',
                                ),
                                onTap: () {
                                  if (system['DCFlag'] == '0') {
                                    // Navigate to AC Update Page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                UpdateACUnit(record: system),
                                      ),
                                    );
                                  } else if (system['DCFlag'] == '1') {
                                    //Navigate to DC Update Page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                UpdateDCUnit(record: system),
                                      ),
                                    );
                                  } else {
                                    // Handle invalid DCFlag value, if needed
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Invalid DCFlag value'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryTable() {
     final List<dynamic> systemsForSummary;
    if (selectedRegion == 'ALL') {
      systemsForSummary = SPDSystems;
    } else {
      systemsForSummary = SPDSystems.where((system) => system['province'] == selectedRegion).toList();
    }

    final int currentTotalCount = systemsForSummary.length;
    final int currentAcCount = systemsForSummary.where((system) => system['DCFlag'] == '0').length;
    final int currentDcCount = systemsForSummary.where((system) => system['DCFlag'] == '1').length;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Table(
        border: TableBorder.all(color: Colors.grey),
        children: [
          TableRow(
            children: [
              _buildSummaryCell('Total SPD Units'),
              _buildSummaryCell('$currentTotalCount'),
            ],
          ),
          TableRow(
            children: [
              _buildSummaryCell('AC Units'),
              _buildSummaryCell('$currentAcCount'),
            ],
          ),
          TableRow(
            children: [
              _buildSummaryCell('DC Units'),
              _buildSummaryCell('$currentDcCount'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCell(String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
