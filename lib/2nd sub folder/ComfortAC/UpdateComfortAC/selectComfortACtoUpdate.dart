
import '../../../../../Widgets/LoadLocations/httpGetLocations.dart';
import '../../../../UserAccess.dart';
import 'httpComfortACUpdatePost.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:provider/provider.dart';

import 'edit_comfort_ac.dart';

class ComfortAcUpdate extends StatefulWidget {
  const ComfortAcUpdate({super.key});

  @override
  _ComfortAcUpdateState createState() => _ComfortAcUpdateState();
}

class _ComfortAcUpdateState extends State<ComfortAcUpdate> {
  List<dynamic> indoorUnits = [];
  List<dynamic> outdoorUnits = [];
  List<dynamic> connections = [];
  bool isLoading = true;
  String userName = "";
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final indoorResponse = await http.get(
          Uri.parse('https://powerprox.sltidc.lk/GET_AC_Indoor_Units.php'));
      final outdoorResponse = await http.get(
          Uri.parse('https://powerprox.sltidc.lk/GET_AC_Outdoor_Units.php'));
      final connectionsResponse = await http
          .get(Uri.parse('https://powerprox.sltidc.lk/GET_AC_Connection.php'));

      if (indoorResponse.statusCode == 200) {
        indoorUnits = json.decode(indoorResponse.body);
      }
      if (outdoorResponse.statusCode == 200) {
        outdoorUnits = json.decode(outdoorResponse.body);
      }
      if (connectionsResponse.statusCode == 200) {
        connections = json.decode(connectionsResponse.body);
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserAccess userAccess = Provider.of<UserAccess>(context, listen: true); // Use listen: true to rebuild the widget when the data changes
    userName=userAccess.username!;
    return ChangeNotifierProvider(
      create: (context) => LocationProvider()..loadAllData(),
      child: Consumer<LocationProvider>(
          builder: (context, locationProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('AC Comfort Units'),
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: indoorUnits.length,
                  itemBuilder: (context, index) {
                    final unit = indoorUnits[index];
                    final ConnectionUnits = connections[index];

                    if (unit == null) {
                      return Container();
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        title: Text('Brand : ${unit['brand'] ?? 'No Brand'}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Model : ${unit['model'] ?? 'No model'}'),
                            // Text('Rtom: ${ConnectionUnits['rtom'] ?? 'No rtom'}'),
                            Text(
                              'Location: ${ConnectionUnits['region'] ?? 'No region'}'
                              '| ${ConnectionUnits['rtom'] ?? 'No RTOM'}'
                              '| ${ConnectionUnits['station'] ?? 'No station'}'
                              '| ${ConnectionUnits['office_number'] ?? 'No office_number'}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditComfortAcPage(
                                indoorData: unit,
                                outdoorUnitData: outdoorUnits.length > index
                                    ? outdoorUnits[index]
                                    : {},
                                connectionData: connections.length > index
                                    ? connections[index]
                                    : {},
                                user: userName,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        );
      }),
    );
  }
}
