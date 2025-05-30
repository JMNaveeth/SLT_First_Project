import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import '../SPDMaintenancePage.dart';

class HttpUpdateSPD extends StatefulWidget {
  final Map<String, dynamic> updatedData;

  const HttpUpdateSPD({
    Key? key,
    required this.updatedData,
  }) : super(key: key);

  @override
  _HttpUpdateSPDState createState() => _HttpUpdateSPDState();
}

class _HttpUpdateSPDState extends State<HttpUpdateSPD> {
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  Future<void> _updateData() async {
    final url = 'https://powerprox.sltidc.lk/POSTSPD_temp.php';

    try {
      final response = await http.post(Uri.parse(url), body: {
        'SPDid': widget.updatedData['SPDid'] != null
            ? widget.updatedData['SPDid'].toString()
            : '',
        'province': widget.updatedData['province'].toString() ?? '',
        'Rtom_name': widget.updatedData['Rtom_name'].toString() ?? '',
        'station': widget.updatedData['station'].toString() ?? '',
        'SPDLoc': widget.updatedData['SPDLoc'].toString() ?? '',
        'poles': widget.updatedData['poles'].toString() ?? '',
        'SPDType': widget.updatedData['SPDType'].toString() ?? '',
        'SPD_Manu': widget.updatedData['SPD_Manu'].toString() ?? '',
        'model_SPD': widget.updatedData['model_SPD'].toString() ?? '',
        'status': widget.updatedData['status'].toString() ?? '',
        'PercentageR': widget.updatedData['PercentageR'].toString() ?? '',
        'PercentageY': widget.updatedData['PercentageY'].toString() ?? '',
        'PercentageB': widget.updatedData['PercentageB'].toString() ?? '',
        'nom_volt': widget.updatedData['nom_volt'].toString() ?? '',
        'UcDCVolt': widget.updatedData['UcDCVolt'].toString() ?? '',
        'UpDCVolt': widget.updatedData['UpDCVolt'].toString() ?? '',
        'Nom_Dis8_20': widget.updatedData['Nom_Dis8_20'].toString() ?? '',
        'Nom_Dis10_350': widget.updatedData['Nom_Dis10_350'].toString() ?? '',
        'installDt': widget.updatedData['installDt'].toString() ?? '',
        'warrentyDt': widget.updatedData['warrentyDt'].toString() ?? '',
        'Notes': widget.updatedData['Notes'].toString() ?? '',
        'modular': widget.updatedData['modular'].toString() ?? '',
        'phase': widget.updatedData['phase'].toString() ?? '',
        'UcLiveMode': widget.updatedData['UcLiveMode'].toString() ?? '',
        'UcLiveVolt': widget.updatedData['UcLiveVolt'].toString() ?? '',
        'UcNeutralVolt': widget.updatedData['UcNeutralVolt'].toString() ?? '',
        'UpLiveVolt': widget.updatedData['UpLiveVolt'].toString() ?? '',
        'UpNeutralVolt': widget.updatedData['UpNeutralVolt'].toString() ?? '',
        'dischargeType': widget.updatedData['dischargeType'].toString() ?? '',
        'L8to20NomD': widget.updatedData['L8to20NomD'].toString() ?? '',
        'N8to20NomD': widget.updatedData['N8to20NomD'].toString() ?? '',
        'L10to350ImpD': widget.updatedData['L10to350ImpD'].toString() ?? '',
        'N10to350ImpD': widget.updatedData['N10to350ImpD'].toString() ?? '',
        'mcbRating': widget.updatedData['mcbRating'].toString() ?? '',
        'responseTime': widget.updatedData['responseTime'].toString() ?? '',
        'Submitter': 'Test User',
        'approvalStatus': '1',
      });

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error inserting data: ${response.statusCode}';
        });
        throw Exception('Failed to update data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Update'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _errorMessage != null
                ? Text(_errorMessage!)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Data Updated',
                        style: TextStyle(fontSize: 24.0),
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        child: const Text('Back'),
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => SPDMaintenancePage(),
                          //   ),
                          // );
                        },
                      ),
                    ],
                  ),
      ),
    );
  }
}
