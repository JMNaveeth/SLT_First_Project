import 'package:flutter/material.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/utils/utils/colors.dart';
import 'package:theme_update/viewBatterySystem/viewBatterySystem/combinedSet.dart';

//import '../../HomePage/utils/colors.dart';
//import '../../HomePage/widgets/AppBar.dart';
// import '../UpdateGenInfoPage.dart';
// import '../UpdateGenerator/GatherUpdateGeneratorDetails.dart';
// import '../UpdateGenerator/generator_details_model.dart'; // Import the UpdateGenInfoPage

class GenInfoPage extends StatefulWidget {
  final Map<String, dynamic> data;
  final String searchQuery;

  const GenInfoPage({
    Key? key,
    required this.data,
    required this.searchQuery,
  }) : super(key: key);

  @override
  State<GenInfoPage> createState() => _GenInfoPageState();
}

class _GenInfoPageState extends State<GenInfoPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  Widget highlightText(BuildContext context, String text, String query) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    if (query.isEmpty)
      return Text(text, style: TextStyle(color: customColors.subTextColor));
    final lcText = text.toLowerCase(), lcQuery = query.toLowerCase();
    if (!lcText.contains(lcQuery))
      return Text(text, style: TextStyle(color: customColors.subTextColor));
    final spans = <TextSpan>[];
    int start = 0, idx;
    while ((idx = lcText.indexOf(lcQuery, start)) != -1) {
      if (idx > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, idx),
            style: TextStyle(color: customColors.subTextColor),
          ),
        );
      }
      spans.add(
        TextSpan(
          text: text.substring(idx, idx + query.length),
          style: TextStyle(
            backgroundColor: customColors.highlightColor,
            color: customColors.mainTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      start = idx + query.length;
    }
    if (start < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(start),
          style: TextStyle(color: customColors.subTextColor),
        ),
      );
    }
    return RichText(text: TextSpan(children: spans));
  }

  ListTile makeListTile(
    BuildContext context,
    String subjectName,
    String variable,
  ) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 5.0),
        decoration: new BoxDecoration(
          border: new Border(
            right: new BorderSide(width: 2.0, color: customColors.subTextColor),
          ),
        ),
        child: Text(
          subjectName,
          style: TextStyle(
            color: customColors.mainTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      title: highlightText(context, variable, widget.searchQuery),
    );
  }

  Card makeCard(BuildContext context, Lesson lesson) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Card(
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: customColors.suqarBackgroundColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: customColors.subTextColor, // Shadow color
              blurRadius: 2.0, // Softening the shadow
              spreadRadius: 1.0, // Extent of shadow
              offset: Offset(0, 2.0), // Shadow position
            ),
          ],
        ),
        child: makeListTile(context, lesson.subjectName, lesson.variable),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

       final data = widget.data;


    return Scaffold(
   
      // appBar: CommonAppBar(
      //   title: 'Station: ${data['station']}',
      //   menuenabled: true,
      //   notificationenabled: true,
      //   ontap: () {
      //     _scaffoldKey.currentState?.openDrawer();
      //   },
      // ),
      appBar: AppBar(
        backgroundColor: customColors.appbarColor,
        iconTheme: IconThemeData(
          color: customColors.mainTextColor,
        ), // Set icon theme color to white
        title: Text(
          'Station: ${data['station']}',
          style: TextStyle(color: customColors.mainTextColor),
        ),
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),
      body: Container(
        color:
            customColors.mainBackgroundColor, // <-- Set background color here
        child: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          child: ListView(
             controller: _scrollController,
            children: [
              SizedBox(height: 12.0),
              makeCard(
                context,
                Lesson(subjectName: 'GenID', variable: data['ID'] ?? 'N/A'),
              ),
              makeCard(
                context,
                Lesson(subjectName: 'QR Tag', variable: data['QRTag'] ?? 'N/A'),
              ),
              makeCard(
                context,
                Lesson(
                  subjectName: 'Station',
                  variable: data['station'] ?? 'N/A',
                ),
              ),
              makeCard(
                context,
                Lesson(
                  subjectName: 'Province',
                  variable: data['province'] ?? 'N/A',
                ),
              ),
              makeCard(
                context,
                Lesson(
                  subjectName: 'RTOM Name',
                  variable: data['Rtom_name'] ?? 'N/A',
                ),
              ),
              makeCard(
                context,
                Lesson(
                  subjectName: 'Longitude',
                  variable: data['Longitude'] ?? 'N/A',
                ),
              ),
              makeCard(
                context,
                Lesson(
                  subjectName: 'Latitude',
                  variable: data['Latitude'] ?? 'N/A',
                ),
              ),
              makeCard(
                context,
                Lesson(
                  subjectName: 'Availability',
                  variable: data['Available'] ?? 'N/A',
                ),
              ),
              if (data['Available'] != 'No')
                Column(
                  children: [
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Category',
                        variable: data['category'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Brand of Alternator',
                        variable: data['brand_alt'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Brand of Set',
                        variable: data['brand_set'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Brand of Engine',
                        variable: data['brand_eng'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Engine Capacity (KVA)',
                        variable: data['set_cap'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Model of Alternator',
                        variable: data['model_alt'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Model of Engine',
                        variable: data['model_eng'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'DEG Controller',
                        variable: data['Controller'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'DEG Controller Model',
                        variable: data['controller_model'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Model of Set',
                        variable: data['model_set'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Serial Number of Alternator',
                        variable: data['serial_alt'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Serial Number of Engine',
                        variable: data['serial_eng'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Serial Number of Set',
                        variable: data['serial_set'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Mode (Auto/Manual)',
                        variable: data['mode'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Phase (Single/Three)',
                        variable: data['phase_eng'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Day Tank Size',
                        variable: data['tank_prime'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Has Secondary Tank',
                        variable: data['dayTank'] == 1 ? "Yes" : "No",
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Bulk Tank Size',
                        variable: data['dayTankSze'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Feeder Cable Size',
                        variable: data['feederSize'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'MCCB Rating',
                        variable: data['RatingMCCB'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'ATS Rating',
                        variable: data['RatingATS'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'ATS Brand',
                        variable: data['BrandATS'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'ATS Model',
                        variable: data['ModelATS'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Number of Batteries',
                        variable: data['Battery_Count'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Battery Brand',
                        variable: data['Battery_Brand'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Battery Capacity (Ah)',
                        variable: data['Battery_Capacity'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Local Agent',
                        variable: data['LocalAgent'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Local Agent Address',
                        variable: data['Agent_Addr'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Local Agent Contact Number',
                        variable: data['Agent_Tel'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Year of Manufacture',
                        variable: data['YoM'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Year of Install',
                        variable: data['Yo_Install'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Submitted By',
                        variable: data['Updated_By'] ?? 'N/A',
                      ),
                    ),
                    makeCard(
                      context,
                      Lesson(
                        subjectName: 'Updated Date',
                        variable: data['updated'] ?? 'N/A',
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: customColors.mainBackgroundColor,
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //context,
                  // MaterialPageRoute(
                  //   builder:
                  //       (context) => GeneratorDetailUpdatePage(
                  //         generator: Generator(
                  //           ID: data['ID'] ?? 'N/A',
                  //           province: data['province'] ?? 'N/A',
                  //           Rtom_name: data['Rtom_name'] ?? 'N/A',
                  //           station: data['station'] ?? 'N/A',
                  //           Available: data['Available'] ?? 'N/A',
                  //           category: data['category'] ?? 'N/A',
                  //           brand_alt: data['brand_alt'] ?? 'N/A',
                  //           brand_eng: data['brand_eng'] ?? 'N/A',
                  //           brand_set: data['brand_set'] ?? 'N/A',

                  //           model_alt: data['model_alt'] ?? 'N/A',
                  //           model_eng: data['model_eng'] ?? 'N/A',
                  //           model_set: data['model_set'] ?? 'N/A',
                  //           serial_alt: data['serial_alt'] ?? 'N/A',
                  //           serial_eng: data['serial_eng'] ?? 'N/A',
                  //           serial_set: data['serial_set'] ?? 'N/A',
                  //           mode: data['mode'] ?? 'N/A',
                  //           phase_eng: data['phase_eng'] ?? 'N/A',
                  //           set_cap: data['set_cap'] ?? 'N/A',
                  //           tank_prime: data['tank_prime'] ?? 'N/A',
                  //           dayTank: data['dayTank'] == 1 ? "Yes" : "No",
                  //           dayTankSze: data['tank_prime'] ?? 'N/A',
                  //           feederSize: data['feederSize'] ?? 'N/A',
                  //           RatingMCCB: data['RatingMCCB'] ?? 'N/A',
                  //           RatingATS: data['RatingATS'] ?? 'N/A',
                  //           BrandATS: data['BrandATS'] ?? 'N/A',
                  //           ModelATS: data['ModelATS'] ?? 'N/A',
                  //           LocalAgent: data['LocalAgent'] ?? 'N/A',
                  //           Agent_Addr: data['Agent_Addr'] ?? 'N/A',
                  //           Agent_Tel: data['Agent_Tel'] ?? 'N/A',
                  //           YoM: data['YoM'] ?? 'N/A',
                  //           Yo_Install: data['Yo_Install'] ?? 'N/A',
                  //           Battery_Capacity: data['Battery_Capacity'] ?? 'N/A',
                  //           Battery_Brand: data['Battery_Brand'] ?? 'N/A',
                  //           Battery_Count: data['Battery_Count'] ?? 'N/A',
                  //           Controller: data['Controller'] ?? 'N/A',
                  //           controller_model: data['controller_model'] ?? 'N/A',
                  //           Updated_By: data['Updated_By'] ?? 'N/A',
                  //           updated: data['updated'] ?? 'N/A',
                  //           Latitude: data['Latitude'] ?? 'N/A',
                  //           Longitude: data['Longitude'] ?? 'N/A',
                  //         ),
                  //         updator: data['Updated_By'] ?? 'N/A', // Pass updator
                  //         brandeng: [data['brand_eng'] ?? 'N/A'],
                  //         contBrand: [data['Controller'] ?? 'N/A'],
                  //         brandset: [data['brand_set'] ?? 'N/A'],
                  //         brandAlt: [data['brand_alt'] ?? 'N/A'],
                  //         brandAts: [data['BrandATS'] ?? 'N/A'],
                  //         batBrand: [data['Battery_Brand'] ?? 'N/A'],
                  //       ),
                  // ),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // Adjust for roundness
                  ),
                ),
                child: Text('Edit'),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },

                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // Adjust the value for desired roundness
                  ),
                ),
                child: Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Lesson {
  final String subjectName;
  final String variable;

  Lesson({required this.subjectName, required this.variable});
}
