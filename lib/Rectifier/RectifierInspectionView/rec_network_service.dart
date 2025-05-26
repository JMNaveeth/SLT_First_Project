import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:powerprox/Screens/Other%20Assets/Rectifier/RectifierInspectionView/rec_inspection_data.dart';
import 'package:theme_update/Rectifier/RectifierInspectionView/rec_inspection_data.dart';


Future<List<RecInspectionData>> recFetchInspectionData() async {
  final response =
      await http.get(Uri.parse('https://powerprox.sltidc.lk/GETDailyRECCheck.php'));
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    return body
        .map((dynamic item) => RecInspectionData.fromJson(item))
        .toList();
  } else {
    throw Exception('Failed to load inspection data');
  }
}

Future<List<RecRemarkData>> recFetchRemarkData() async {
  final response =
      await http.get(Uri.parse('https://powerprox.sltidc.lk/GETDailyRECRemarks.php'));
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    return body.map((dynamic item) => RecRemarkData.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load remark data');
  }
}

Future<List<RectifierDetails>> rectifierDetailsFetchData() async {
  final response =
      await http.get(Uri.parse('https://powerprox.sltidc.lk/RectifierView.php'));
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    print(body.toString());

    return body.map((dynamic item) => RectifierDetails.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load inspection data');
  }
}


class RectifierInspectionViewSelect extends StatefulWidget {
  const RectifierInspectionViewSelect({super.key});

  @override
  _RectifierInspectionViewSelectState createState() =>
      _RectifierInspectionViewSelectState();
}

class _RectifierInspectionViewSelectState
    extends State<RectifierInspectionViewSelect> {
  late Future<List<RecInspectionData>> recInspectionData;
  late Future<List<RecRemarkData>> recRemarkData;
  late Future<List<RectifierDetails>> rectifierDetails;
  String? selectedRegion = 'ALL';
  String? checkByPerson = 'ALL';
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
  Map<String, Set<String>> regionSubmitters = {};

  List<RecInspectionData> recFilterDataByRegion(
      List<RecInspectionData> data, String? region) {
    if (region == null || region.isEmpty || region == 'ALL') {
      return data;
    } else {
      return data.where((item) => item.region == region).toList();
    }
  }

  List<RecInspectionData> recFilterDataByPerson(
      List<RecInspectionData> data, String? person) {
    if (person == null || person.isEmpty || person == 'ALL') {
      return data;
    } else {
      return data.where((item) => item.userName == person).toList();
    }
  }

  RecRemarkData? getRemarkForInspection(
      List<RecRemarkData> remarks, String remarkId) {
    try {
      return remarks.firstWhere((remark) => remark.id == remarkId);
    } catch (e) {
      return null;
    }
  }

  RectifierDetails? getRectifierDetails(
      List<RectifierDetails> rectifierDetails, String recId) {
    try {
      return rectifierDetails.firstWhere((details) => details.recID == recId);
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    recInspectionData = recFetchInspectionData().then((data) {
      setState(() {
        for (var item in data) {
          if (!regionSubmitters.containsKey(item.region)) {
            regionSubmitters[item.region] = {};
          }
          regionSubmitters[item.region]?.add('ALL');
          regionSubmitters[item.region]?.add(item.userName);
        }
      });
      return data;
    });
    recRemarkData = recFetchRemarkData();
    rectifierDetails = rectifierDetailsFetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:mainBackgroundColor,
      appBar: AppBar(
        title: Text('Inspection Data',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff2B3136),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownButton<String>(
                hint: Text('Select Region'),
                value: selectedRegion,
                dropdownColor: suqarBackgroundColor,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRegion = newValue;
                    // checkByPerson =
                    //     null; // Reset person selection when region changes
                  });
                },
                items: regions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: subTextColor)),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                hint: Text('Checked By', style: TextStyle(color: subTextColor)),
                value: checkByPerson,
                onChanged: (String? newValue) {
                  setState(() {
                    checkByPerson = newValue;
                  });
                },
                items: selectedRegion != null &&
                    regionSubmitters[selectedRegion] != null
                    ? regionSubmitters[selectedRegion]!.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList()
                    : [],
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: Future.wait(
                  [recInspectionData, recRemarkData, rectifierDetails]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData ||
                    (snapshot.data![0] as List).isEmpty ||
                    (snapshot.data![1] as List).isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  List<RecInspectionData> inspectionDataList =
                  snapshot.data![0] as List<RecInspectionData>;
                  List<RecRemarkData> remarkDataList =
                  snapshot.data![1] as List<RecRemarkData>;
                  List<RectifierDetails> rectifierDetailsList =
                  snapsho