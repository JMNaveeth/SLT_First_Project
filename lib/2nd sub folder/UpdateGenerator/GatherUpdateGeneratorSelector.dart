import 'package:flutter/material.dart';
import 'package:theme_update/utils/utils/colors.dart';
// import 'package:flutter_application_1/notification/notificationPage.dart';
// import 'package:flutter_application_1/utils/colors.dart';
// import 'package:flutter_application_1/widgets/AppBar.dart';

// import '../../HomePage/notification/notificationPage.dart';
// import '../../HomePage/utils/colors.dart';
// import '../../HomePage/widgets/AppBar.dart';
import 'GatherUpdateGeneratorDetails.dart';
import 'generator_details_model.dart';
import 'httpGetGenerators.dart';


class GeneratorSelectPage extends StatefulWidget {
  const GeneratorSelectPage({super.key});

  @override
  _GeneratorSelectPageState createState() => _GeneratorSelectPageState();
}

class _GeneratorSelectPageState extends State<GeneratorSelectPage> {
  late Future<List<Generator>> GeneratorData;
  String updator = "Testuser";// update Updator name

  Set<String?> brand_engSet = {'Other'};
  List<String?> brand_eng = [];

  Set<String?> brand_setSet = {'Other'};
  List<String?> brand_set = [];

  Set<String?> ControllerSet = {'Other'};
  List<String?> Controller = [];

  Set<String?> brand_altSet = {'Other'};
  List<String?> brand_alt = [];

  Set<String?> BrandATSSet = {'Other'};
  List<String?> BrandATS = [];

  Set<String?> Battery_BrandSet = {'Other'};
  List<String?> Battery_Brand = [];

  String? selectedRegion = 'ALL';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  List<Generator> recFilterDataByRegion(List<Generator> data, String? region) {
    if (region == null || region.isEmpty || region == 'ALL') {
      return data;
    } else {
      return data.where((item) => item.province == region).toList();
    }
  }

  @override
  void initState() {
    super.initState();
    GeneratorData = GeneratorFetchData().then((data) {
      setState(() {
        for (var element in data) {
          if (element.brand_eng != null && element.brand_eng!.isNotEmpty) {
            brand_engSet.add(element.brand_eng);
          }
        }
        brand_eng = brand_engSet.toList();

        for (var element in data) {
          if (element.Controller != null && element.Controller!.isNotEmpty) {
            ControllerSet.add(element.Controller);
          }
        }
        Controller = ControllerSet.toList();

        for (var element in data) {
          if (element.brand_set != null && element.brand_set!.isNotEmpty) {
            brand_setSet.add(element.brand_set);
          }
        }
        brand_set = brand_setSet.toList();

        for (var element in data) {
          if (element.brand_alt != null && element.brand_alt!.isNotEmpty) {
            brand_altSet.add(element.brand_alt);
          }
        }
        brand_alt = brand_altSet.toList();

        for (var element in data) {
          if (element.BrandATS != null && element.BrandATS!.isNotEmpty) {
            BrandATSSet.add(element.BrandATS);
          }
        }
        BrandATS = BrandATSSet.toList();

        for (var element in data) {
          if (element.Battery_Brand != null && element.Battery_Brand!.isNotEmpty) {
            Battery_BrandSet.add(element.Battery_Brand);
          }
        }
        Battery_Brand = Battery_BrandSet.toList();
      });
      return data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the key to the Scaffold
      backgroundColor: mainBackgroundColor, 
      appBar: AppBar(
        title: const Text('Update Data'),
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
      //     title: "Update Data",
      //   ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey, // Set the border color
                  width: 1.0,         // Set the border width
                ),
                borderRadius: BorderRadius.circular(8.0), // Set rounded corners if desired
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB( 20.0,0, 20.0,0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text('Select Region'),
                    value: selectedRegion,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRegion = newValue;
                      });
                    },
                    items: regions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(color: qrcodeiconColor1),),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Generator>>(
                future: GeneratorData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No data available'));
                  } else {
                    List<Generator> GeneratorDataList = snapshot.data!;
        
                    // Filter data based on selected region
                    GeneratorDataList =
                        recFilterDataByRegion(GeneratorDataList, selectedRegion);
        
                    if (GeneratorDataList.isEmpty) {
                      return Center(
                          child:
                              Text('No data available for the selected region'));
                    }
        
                    return ListView.builder(
                      itemCount: GeneratorDataList.length,
                      itemBuilder: (context, index) {
                        Generator data = GeneratorDataList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GeneratorDetailUpdatePage(
                                    generator: data,
                                    updator: updator, //update updator name
                                    brandeng:brand_eng,
                                    contBrand:Controller,
                                    brandset:brand_set,
                                    brandAlt:brand_set,
                                    brandAts:BrandATS,
                                    batBrand:Battery_Brand,
                                  ),
                                ));
                            // Handle onTap
                          },
                          
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: suqarBackgroundColor,
                                borderRadius: BorderRadius.circular(8.0), // Rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: mainTextColor, // Set the shadow color and opacity
                                    blurRadius: 8.0, // Softness of the shadow
                                    offset: Offset(2, 2), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text('${data.ID} - ${data.station}',style: TextStyle(color: mainTextColor),),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Region: ${data.province}',style: TextStyle(color: Color(0xFFBEBCBC))),
                                    Text('RTom: ${data.Rtom_name}',style: TextStyle(color:Color(0xFFBEBCBC))),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
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
