
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//import '../../ACMaintenancePage.dart';

class HttpPostPrecisionAc {
  static const String precisionPostUrl =
      'https://powerprox.sltidc.lk/POST_PrecisionAC.php';

  static Future<bool> postPrecisionUnits(Map<String, dynamic> precisionData) async {
    try {
      final response = await http
          .post(Uri.parse(precisionPostUrl), body: precisionData)
          .timeout(Duration(seconds: 10));

      // Print status code for debugging
      print('HTTP status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Success! Echoed response: ${response.body}');
        return true;
      } else {
        // Log response body in case of an error
        print('Error response body: ${response.body}');
        return false;
      }
    } on http.ClientException catch (e) {
      // Handle general client-side exceptions
      print('ClientException: $e');
      return false;
    } on TimeoutException catch (e) {
      // Handle timeout
      print('Request timed out: $e');
      return false;
    } on SocketException catch (e) {
      // Handle network issues
      print('Network error: $e');
      return false;
    } catch (e) {
      // Catch any other exceptions
      print('Unexpected error: $e');
      return false;
    }
  }
}


class HttpPostPrecision extends StatefulWidget {
  final Map<String, dynamic> formDataList;

  final String ? User;

  HttpPostPrecision({required this.formDataList,required this.User});

  @override
  _HttpPostPrecisionState createState() =>
      _HttpPostPrecisionState(formDataList: formDataList,User: User);
}

class _HttpPostPrecisionState extends State<HttpPostPrecision> {
  final Map<String, dynamic> formDataList;
  String ? User;

  _HttpPostPrecisionState({required this.formDataList, required this.User});

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
      body: Center(
        child: CircularProgressIndicator(color: Colors.green),
      ),
    );
  }

  void _uploadData() async {


    final precisionData = {
      // 'ID': formDataList['ID'] ?? '',
      'Region': formDataList['Region'] ?? '',
      'RTOM': formDataList['RTOM'] ?? '',
      'Station': formDataList['Station'] ?? '',

      //newly added
      'building_id': formDataList['building_id'] ?? '',
      'floor_number': formDataList['floor_number'] ?? '',

      'Office_No': formDataList['Office_No'] ?? '',
      'Location': formDataList['Location'] ?? '',


      'QRTag': formDataList['QRTag'] ?? '',
      'Model': formDataList['Model'] ?? '',
      'Serial_Number': formDataList['Serial_Number'] ?? '',
      'Manufacturer': formDataList['Manufacturer'] ?? '',
      'Installation_Date': formDataList['Installation_Date'] ?? '',
      'Status': formDataList['Status'] ?? '',
      'UpdatedBy': formDataList['UpdatedBy'] = User,
      'Cooling_Capacity': formDataList['Cooling_Capacity'] ?? '',
      'Power_Supply': formDataList['Power_Supply'] ?? '',
      'Refrigerant_Type': formDataList['Refrigerant_Type'] ?? '',
      'Dimensions': formDataList['Dimensions'] ?? '',
      'Weight': formDataList['Weight'] ?? '5',
      'Noise_Level': formDataList['Noise_Level'] ?? '',
      'No_of_Compressors': formDataList['No_of_Compressors'] ?? '',
      'Serial_Number_of_the_Compressors': formDataList['Serial_Number_of_the_Compressors'].toString() ?? '',



      'Condition_Indoor_Air_Filters': formDataList['Condition_Indoor_Air_Filters'] ?? '',
      'Condition_Indoor_Unit': formDataList['Condition_Indoor_Unit'] ?? '',
      'Condition_Outdoor_Unit': formDataList['Condition_Outdoor_Unit'] ?? '',
      'Other_Specifications': formDataList['Other_Specifications'] ?? '',

      'Airflow': formDataList['Airflow'] ?? '',
      'Airflow_Type': formDataList['Airflow_Type'] ?? '',


      'No_of_Refrigerant_Circuits': formDataList['No_of_Refrigerant_Circuits'] ?? '',
      'No_of_Evaporator_Coils': formDataList['No_of_Evaporator_Coils'] ?? '',
      'No_of_Condenser_Circuits': formDataList['No_of_Condenser_Circuits'] ?? '',
      'No_of_Condenser_Fans': formDataList['No_of_Condenser_Fans'] ?? '',


      'No_of_Indoor_Fans': formDataList['No_of_Indoor_Fans'] ?? '',//new


      'Condenser_Mounting_Method': formDataList['Condenser_Mounting_Method'] ?? '',

      'Supplier_Name': formDataList['Supplier_Name'] ?? '',
      'Supplier_email': formDataList['Supplier_email'] ?? '',
      'Supplier_contact_no': formDataList['Supplier_contact_no'] ?? '',

      'Warranty_Details': formDataList['Warranty_Details'].toString() ?? '',

      'Warranty_Expire_Date': formDataList['Warranty_Expire_Date'] ?? '',
      'AMC_Expire_Date': formDataList['AMC_Expire_Date'] ?? '0',

      "Latitude": formDataList['Latitude'].toString() ?? '3',
      "Longitude": formDataList['Longitude'].toString() ?? '4',

    };

    print(precisionData);


      bool success = await HttpPostPrecisionAc.postPrecisionUnits(precisionData);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(isSuccess: success),
        ),
      );

  }
}

class ResultPage extends StatefulWidget {
  final bool isSuccess;

  ResultPage({required this.isSuccess});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSuccess ? 'Success' : 'Failure'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _animation.value,
                  child: Icon(
                    widget.isSuccess ? Icons.check_circle : Icons.error,
                    size: 80,
                    color: widget.isSuccess ? Colors.green : Colors.red,
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Text(
              widget.isSuccess ? 'Data upload successful!' : 'Failed to upload data.',
              style: TextStyle(fontSize: 20, color: widget.isSuccess ? Colors.green : Colors.red),
            ),
            SizedBox(height: 20),
            CupertinoButton(
              child: Text('Return'),
              color: Color(0xFF00AEE4),
              onPressed: () {
                // Navigator.pushReplacement(
                //   context,
                //   CupertinoPageRoute(builder: (context) => ACMaintenancePage()),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}