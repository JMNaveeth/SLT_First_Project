import 'package:flutter/material.dart';
// import 'package:flutter_application_1/notification/notificationPage.dart';
// import 'package:flutter_application_1/utils/colors.dart';
// import 'package:flutter_application_1/widgets/AppBar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:theme_update/utils/utils/colors.dart';

// import '../../HomePage/notification/notificationPage.dart';
// import '../../HomePage/utils/colors.dart';
// import '../../HomePage/widgets/AppBar.dart';
// import '../../UserAccess.dart';
import 'GatherUpdateGeneratorSelector.dart';




class HttpGeneratorUpdatePostPage extends StatefulWidget {
  final Map<String, dynamic> formData;
  final String username;

  const HttpGeneratorUpdatePostPage({
    super.key,
    required this.formData,
    required this.username,
  });

  @override
  // ignore: library_private_types_in_public_api
  _HttpGeneratorUpdatePostPageState createState() =>
      _HttpGeneratorUpdatePostPageState();
}

class _HttpGeneratorUpdatePostPageState
    extends State<HttpGeneratorUpdatePostPage> {
  bool _isLoading = true;
  String? _errorMessage;
  late String formattedTime;

  @override
  void initState() {
    super.initState();
    _submitData();
    print('I am printing form data');
    print("form data = ${widget.formData.toString()}");
  }



  // Submit data to the server
  Future<void> _submitData() async {
    final updatedValues = widget.formData;
    final instance = updatedValues['instance']?.toString() ?? "";

    final updatedData = {
      'GenID': updatedValues['ID'] ?? '',
      'province': updatedValues['Province'] ?? '',
      'Rtom_name': updatedValues['Rtom Name'] ?? '',
      'station': updatedValues['Station'] ?? '',
      'Available': updatedValues['Available'] ?? '',
      'category': updatedValues['Category'] ?? '',
      'brand_alt': updatedValues['Brand Alt'] ?? '',
      'brand_eng': updatedValues['Brand Eng'] ?? '',
      'brand_set': updatedValues['Brand Set'] ?? '',
      'model_alt': updatedValues['Model Alt'] ?? '',
      'model_eng': updatedValues['Model Eng'] ?? '',
      'model_set': updatedValues['Model Set'] ?? '',
      'serial_alt': updatedValues['Serial Alt'] ?? '',
      'serial_eng': updatedValues['Serial Eng'] ?? '',
      'serial_set': updatedValues['Serial Set'] ?? '',
      'mode': updatedValues['Mode'] ?? '',
      'phase_eng': updatedValues['Phase Eng'] ?? '',
      'set_cap': updatedValues['Set Cap'] ?? '',
      'tank_prime': updatedValues['Tank Prime'] ?? '',
      'dayTank': updatedValues['Day Tank'] ?? '',
      'dayTankSze': updatedValues['Day Tank Size'] ?? '',
      'feederSize': updatedValues['Feeder Size'] ?? '',
      'RatingMCCB': updatedValues['Rating MCCB'] ?? '',
      'RatingATS': updatedValues['Rating ATS'] ?? '',
      'BrandATS': updatedValues['Brand ATS'] ?? '',
      'ModelATS': updatedValues['Model ATS'] ?? '',
      'LocalAgent': updatedValues['Local Agent'] ?? '',
      'Agent_Addr': updatedValues['Agent Addr'] ?? '',
      'Agent_Tel': updatedValues['Agent Tel'] ?? '',
      'YoM': updatedValues['Year of Manufacture'] ?? '',
      'Yo_Install': updatedValues['Year of Install'] ?? '',
      'Battery_Capacity': updatedValues['Battery Capacity'] ?? '',
      'Battery_Brand': updatedValues['Battery Brand'] ?? '',
      'Battery_Count': updatedValues['Battery Count'] ?? '',
      'Controller': updatedValues['Controller'] ?? '',
      'controller_model': updatedValues['Controller Model'] ?? '',
      'updated': updatedValues['Updated'] ?? '',
      'Updated_By': updatedValues['Updated By'] ?? '',
      'Latitude': updatedValues['Latitude'] ?? '',
      'Longitude': updatedValues['Longitude'] ?? '',
      'approvalStatus': '0', //0= pending, 1= approved, 2= rejected
      'updateRequestedBy': widget.username,



};

    try {
      final updatePostResponse = await http
          .post(Uri.parse('https://powerprox.sltidc.lk/POSTGenerator_temp.php'),
              body: updatedData)
          .timeout(const Duration(seconds: 10));

      if (updatePostResponse.statusCode == 200) {

        print("Response 200 OK");
        print("Server response body: ${updatePostResponse.body}");

        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Error inserting data: ${updatePostResponse.statusCode}, Body: ${updatePostResponse.body}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: ${e.toString()}';
        print(_errorMessage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {


    final GlobalKey<ScaffoldState> _scaffoldKey =
    new GlobalKey<ScaffoldState>();
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        title: const Text('Send Approval'),
      ),
      // appBar: CommonAppBar(
      //     menuenabled: true,
      //     notificationenabled: true,
      //     ontap: () {
      //       _scaffoldKey.currentState?.openDrawer();
      //     },
      //     notificationOnTap: () {
      //     // Navigator.push(
      //     //   context,
      //     //   MaterialPageRoute(builder: (context) => NotificationPage()),
      //     // );
      //   },
      //     title: "Send Approval",
      //   ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _errorMessage != null
                ? Text(_errorMessage!)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Updates send For Approval successfully',
                        style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w500,color: mainTextColor),
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        child: const Text('Back'),
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(mainTextColor),
                              minimumSize: MaterialStateProperty.all(Size(150, 40)), // Change size (width, height)
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11), // Change border radius
                                ),
                              ),
                              ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GeneratorSelectPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
      ),
    );
  }
}
