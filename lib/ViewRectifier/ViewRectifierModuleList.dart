import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/utils/utils/colors.dart' as customColors;
// import '../../HomePage/widgets/colors.dart';
import '../utils/utils/colors.dart';
import 'ViewRectifierModuleDetails.dart';
import 'ViewRectifierUnit.dart';

class ViewRectifierModuleList extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _ViewRectifierModuleListState createState() => _ViewRectifierModuleListState();
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
        builder: (context) => ViewRectifierModuleDetails(RectifierUnit: RectifierUnit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:mainBackgroundColor,
      appBar: AppBar(
        title: const Text('Rectifier Details',
          style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: appbarColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Toggle button for switching themes
          IconButton(
            icon: Icon(
                Provider.of<ThemeProvider>(context).isDarkMode
                  ? Icons.dark_mode
                  : Icons.light_mode,
              color: customColors.mainTextColor, // Dynamic icon color
            ),
            onPressed: () {
              // Toggles between light and dark themes
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),

      body: Column(
        children: [

          Expanded(
            child: isLoading
                ? const Center(
              child: CircularProgressIndicator(), // Show loading indicator
            )
                : ListView.builder(
              itemCount: RectifierSystems.length,
              itemBuilder: (context, index) {
                final system = RectifierSystems[index];

                return ListTile(
                  title: Text('Module ID: ${system['ModuleID']}',
                    style: const TextStyle(color: subTextColor),),
                  subtitle: Text('Rectifier ID: ${system['RecID']}',
                    style: const TextStyle(color: subTextColor),),
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
