import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../ACMaintenancePage.dart';
import 'selectComfortACtoUpdate.dart';



class ComfortAcPostService {
  static const String comfortPostUrl =
      'https://powerprox.sltidc.lk/POST_AC_Comfort_Temp.php';

  static Future<bool> postComfortData(String encodedData) async {
    try {
      final response = await http
          .post(
            Uri.parse(comfortPostUrl),
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: encodedData,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('Data posted successfully.');
        print('Response: ${response.body}');
        return true;
      } else {
        print('Server error with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } on http.ClientException catch (e) {
      print('Client error occurred: $e');
      return false;
    } on FormatException catch (e) {
      print('Response format error: $e');
      return false;
    }
  }
}

class ComfortTestUpdatePost extends StatefulWidget {
  final Map<String, dynamic> formDataList;
  final String? user;

  const ComfortTestUpdatePost(
      {super.key, required this.formDataList, required this.user});

  @override
  _ComfortTestUpdatePostState createState() =>
      _ComfortTestUpdatePostState(formDataList: formDataList, user: user);
}

class _ComfortTestUpdatePostState extends State<ComfortTestUpdatePost> {
  final Map<String, dynamic> formDataList;
  final String? user;

  _ComfortTestUpdatePostState({required this.formDataList, required this.user});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _uploadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comfort Test Update')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.blue),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _printFormData,
              child: const Text('Print Form Data'),
            ),
          ],
        ),
      ),
    );
  }

  void _uploadData() async {
    // Check if location data is valid
    // if (locationData == null) {
    //   print('Please turn on the location');
    //   return;
    // }

    // Prepare data to send
    final comfortData = {
      'AC_Connection': jsonEncode({
        'ConnectionLogID': formDataList['ConnectionLogID'] ?? '',
        'ConnectionIndoorID': formDataList['ConnectionIndoorID'] ?? '',
        'ConnectionOutdoorID': formDataList['ConnectionOutdoorID'] ?? '',
        'Region': formDataList['Region'] ?? '',
        'RTOM': formDataList['RTOM'] ?? '',
        'Station': formDataList['Station'] ?? '',
        // 'rtom_building_id': formDataList['rtom_building_id'] ?? '',
        'RTOMBuildingID': formDataList['RTOMBuildingID'] ?? '',
        'NoAcPlants': formDataList['NoAcPlants'] ?? '',
        'floor_number': formDataList['floor_number'] ?? '',
        'Office_No': formDataList['Office_No'] ?? '',
        'Location': formDataList['Location'] ?? '',
        // 'latitude': formDataList['latitude'] ?? '',
        // 'longitude': formDataList['longitude'] ?? '',
        "Latitude": formDataList['Latitude'].toString() ?? '6',
        "Longitude": formDataList['Longitude'].toString() ?? '4',

        'ConnectionLastUpdated': formDataList['ConnectionLastUpdated'] ?? '',
        'ConnectionUploadedBy': formDataList['ConnectionUploadedBy'] ?? '',
      }),

      'AC_Indoor_Units': jsonEncode({
        'comfortAC_ID': formDataList['comfortAC_ID'] ?? '',
        'QRIn': formDataList['QRIn'] ?? '',
        'Model': formDataList['Model'] ?? '',
        'SerialNumber': formDataList['SerialNumber'] ?? '',
        'RefrigerantType': formDataList['RefrigerantType'] ?? '',
        'Installation_Date': formDataList['Installation_Date'] ?? '',
        'Status': formDataList['Status'] ?? '',
        'UploadedBy': formDataList['UploadedBy'] ?? '',
        // 'Refrigerant_Type': formDataList['Refrigerant_Type'] ?? '',
        'Supplier_Name': formDataList['Supplier_Name'] ?? '',
        'WarrantyExpiryDate': formDataList['WarrantyExpiryDate'] ?? '',
        // 'AMC_Expire_Date': formDataList['AMC_Expire_Date'] ?? '0',
        //////////////////////////////////////////////////////////////
        'IndoorBrand': formDataList['IndoorBrand'] ?? '',
        'IndoorCapacity': formDataList['IndoorCapacity'] ?? '',
        'Type': formDataList['type'] ?? '',
        'Category': formDataList['category'] ?? '',
        'InstallationType': formDataList['installationType'] ?? '',
        'PowerSupply': formDataList['powerSupply'] ?? '',
        'IndoorPONumber': formDataList['IndoorPONumber'] ?? '',
        'RemoteAvailable': formDataList['remoteAvailable'] ?? '',
        'IndoorNotes': formDataList['IndoorNotes'] ?? '',
        'indoor_last_updated': formDataList['indoor_last_updated'] ?? '',
        'IndoorConditionIDUnit': formDataList['IndoorConditionIDUnit'] ?? '',
        'IndoorDoM': formDataList['IndoorDoM'] ?? '',
        /////////////////////////////////////////////////////////////
      }),

      'AC_Outdoor_Units': jsonEncode({
        'OutdoorUnitID': formDataList['OutdoorUnitID'] ?? '',
        'OutdoorBrand': formDataList['OutdoorBrand'] ?? '',
        'OutdoorModel': formDataList['OutdoorModel'] ?? '',
        'OutdoorCapacity': formDataList['OutdoorCapacity'] ?? '',
        'OutdoorFanModel': formDataList['OutdoorFanModel'] ?? '',
        'OutdoorStatus': formDataList['OutdoorStatus'] ?? '',
        'OutdoorPowerSupply': formDataList['OutdoorPowerSupply'] ?? '',
        'OutdoorCompressorMountedWith':
            formDataList['OutdoorCompressorMountedWith'] ?? '',
        'OutdoorCompressorCapacity':
            formDataList['OutdoorCompressorCapacity'] ?? '',
        'OutdoorCompressorBrand': formDataList['OutdoorCompressorBrand'] ?? '',
        'OutdoorCompressorModel': formDataList['OutdoorCompressorModel'] ?? '',
        'OutdoorCompressorSerialNumber':
            formDataList['OutdoorCompressorSerialNumber'] ?? '',
        'OutdoorSupplierName': formDataList['OutdoorSupplierName'] ?? '',
        'OutdoorPONumber': formDataList['OutdoorPONumber'] ?? '',
        'OutdoorNotes': formDataList['OutdoorNotes'] ?? '',
        'OutdoorConditionID': formDataList['OutdoorConditionID'] ?? '',
        'OutdoorLastUpdated': formDataList['OutdoorLastUpdated'] ?? '',
        'OutdoorDoM': formDataList['OutdoorDoM'] ?? '',
        'OutdoorInstallationDate':
            formDataList['OutdoorInstallationDate'] ?? '',
        'OutdoorWarrantyExpiryDate':
            formDataList['OutdoorWarrantyExpiryDate'] ?? '',
        'OutdoorQROut': formDataList['OutdoorQROut'] ?? '',
        'OutdoorUploadedBy': formDataList['OutdoorUploadedBy'] ?? '',
      }), // Assuming no outdoor unit data is available

      'updatedBy': user ?? ''.toString(),
      'approvalStatus': formDataList['approvalStatus'] ?? '1',
    };

    // Convert data to URL-encoded format
    final encodedData = Uri(queryParameters: comfortData).query;

    print('Comfort Data to be sent: $comfortData'); // Debugging

    // Send data
    bool success = await ComfortAcPostService.postComfortData(encodedData);

    // Navigate to result page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(isSuccess: success),
      ),
    );
  }

  // Method to print the formDataList to console
  void _printFormData() {
    print('Form Data List:');
    formDataList.forEach((key, value) {
      print('$key: $value');
    });
  }
}

class ResultPage extends StatelessWidget {
  final bool isSuccess;

  const ResultPage({super.key, required this.isSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSuccess ? 'Success' : 'Failure'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              size: 80,
              color: isSuccess ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              isSuccess ? 'Data upload successful!' : 'Failed to upload data.',
              style: TextStyle(
                  fontSize: 20, color: isSuccess ? Colors.green : Colors.red),
            ),
            const SizedBox(height: 20),
            CupertinoButton(
              color: const Color(0xFF00AEE4),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => ACMaintenancePage()
                )
                );
              },
              child: Text('Go to Comfort AC Main Page'),
            ),
          ],
        ),
      ),
    );
  }
}
