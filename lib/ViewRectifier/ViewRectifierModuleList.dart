import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:theme_update/theme_provider.dart';
// import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/utils/utils/colors.dart';
import 'package:theme_update/widgets/theme%20change%20related%20widjets/theme_provider.dart';
import 'package:theme_update/widgets/theme%20change%20related%20widjets/theme_toggle_button.dart';
// import '../../HomePage/widgets/colors.dart';
import 'ViewRectifierModuleDetails.dart';
import 'ViewRectifierUnit.dart';

class ViewRectifierModuleList extends StatefulWidget {
  @override
  _ViewRectifierModuleListState createState() =>
      _ViewRectifierModuleListState();
}

class _ViewRectifierModuleListState extends State<ViewRectifierModuleList> {
  List<dynamic> RectifierSystems = []; // List to store Rectifier system data
  bool isLoading = true; // Flag to track if data is being loaded

  Future<void> fetchRectifierSystems() async {
    final url =
        'https://powerprox.sltidc.lk/GetRecModule.php'; // Replace with the URL of your PHP script

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        RectifierSystems = json.decode(response.body);
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
    fetchRectifierSystems();
  }

  void navigateToRectifierUnitDetails(dynamic RectifierUnit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                ViewRectifierModuleDetails(RectifierUnit: RectifierUnit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: customColors.mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: customColors.appbarColor,
        title: Text(
          'Rectifier Details',
          style: TextStyle(color: customColors.mainTextColor),
        ),
        iconTheme: IconThemeData(color: customColors.mainTextColor),
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                isLoading
                    ? const Center(
                      child:
                          CircularProgressIndicator(), // Show loading indicator
                    )
                    : ListView.builder(
                      itemCount: RectifierSystems.length,
                      itemBuilder: (context, index) {
                        final system = RectifierSystems[index];

                        return ListTile(
                          title: Text(
                            'Module ID: ${system['ModuleID']}',
                            style: TextStyle(color: customColors.subTextColor),
                          ),
                          subtitle: Text(
                            'Rectifier ID: ${system['RecID']}',
                            style: TextStyle(color: customColors.subTextColor),
                          ),
                          onTap: () {
                            navigateToRectifierUnitDetails(system);
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}



//v2
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../../HomePage/widgets/colors.dart';
// import 'ViewRectifierModuleDetails.dart';
// import 'ViewRectifierUnit.dart';
//
// class ViewRectifierModuleList extends StatefulWidget {
//   @override
//   _ViewRectifierModuleListState createState() => _ViewRectifierModuleListState();
// }
//
// class _ViewRectifierModuleListState extends State<ViewRectifierModuleList> {
//
//
//   List<dynamic> RectifierSystems = []; // List to store Rectifier system data
//   bool isLoading = true; // Flag to track if data is being loaded
//
//   Future<void> fetchRectifierSystems() async {
//     final url =
//         'https://powerprox.sltidc.lk/GetRecModule.php'; // Replace with the URL of your PHP script
//
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       setState(() {
//         RectifierSystems = json.decode(response.body);
//         isLoading = false; // Set isLoading to false once data is loaded
//       });
//     } else {
//       // Handle the error case
//       print('Failed to fetch Rectifier systems');
//       isLoading = false; // Set isLoading to false in case of an error
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchRectifierSystems();
//   }
//
//   void navigateToRectifierUnitDetails(dynamic RectifierUnit) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ViewRectifierModuleDetails(RectifierUnit: RectifierUnit),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor:mainBackgroundColor,
//       appBar: AppBar(
//         title: Text('Rectifier Details',
//           style: TextStyle(color: Colors.white),),
//         centerTitle: true,
//         backgroundColor: appbarColor,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Column(
//         children: [
//
//           Expanded(
//             child: isLoading
//                 ? Center(
//               child: CircularProgressIndicator(), // Show loading indicator
//             )
//                 : ListView.builder(
//               itemCount: RectifierSystems.length,
//               itemBuilder: (context, index) {
//                 final system = RectifierSystems[index];
//
//                 return ListTile(
//                   title: Text('Module ID: ${system['ModuleID']}',
//                     style: TextStyle(color: subTextColor),),
//                   subtitle: Text('Rectifier ID: ${system['RecID']}',
//                     style: TextStyle(color: subTextColor),),
//                   onTap: () {
//                     navigateToRectifierUnitDetails(system);
//                   },
//                 );
//
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


//v1
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'ViewRectifierModuleDetails.dart';
// import 'ViewRectifierUnit.dart';
//
// class ViewRectifierModuleList extends StatefulWidget {
//   @override
//   _ViewRectifierModuleListState createState() => _ViewRectifierModuleListState();
// }
//
// class _ViewRectifierModuleListState extends State<ViewRectifierModuleList> {
//
//
//   List<dynamic> RectifierSystems = []; // List to store Rectifier system data
//   bool isLoading = true; // Flag to track if data is being loaded
//
//   Future<void> fetchRectifierSystems() async {
//     final url =
//         'https://powerprox.sltidc.lk/GetRecModule.php'; // Replace with the URL of your PHP script
//
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       setState(() {
//         RectifierSystems = json.decode(response.body);
//         isLoading = false; // Set isLoading to false once data is loaded
//       });
//     } else {
//       // Handle the error case
//       print('Failed to fetch Rectifier systems');
//       isLoading = false; // Set isLoading to false in case of an error
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchRectifierSystems();
//   }
//
//   void navigateToRectifierUnitDetails(dynamic RectifierUnit) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ViewRectifierModuleDetails(RectifierUnit: RectifierUnit),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Rectifier Details'),
//       ),
//       body: Column(
//         children: [
//
//           Expanded(
//             child: isLoading
//                 ? Center(
//               child: CircularProgressIndicator(), // Show loading indicator
//             )
//                 : ListView.builder(
//               itemCount: RectifierSystems.length,
//               itemBuilder: (context, index) {
//                 final system = RectifierSystems[index];
//
//                   return ListTile(
//                     title: Text('Module ID: ${system['ModuleID']}'),
//                     subtitle: Text('Rectifier ID: ${system['RecID']}'),
//                     onTap: () {
//                       navigateToRectifierUnitDetails(system);
//                     },
//                   );
//
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
