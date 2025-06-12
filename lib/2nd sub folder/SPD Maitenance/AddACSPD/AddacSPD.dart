// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// // import 'package:provider/provider.dart';
// //
// //
// // import '../../../UserAccess.dart';
// import '../../../UserAccess.dart';
// import 'httpPostSPD.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// bool _showDTcapacity = true; // default value
//
// class AddacSPD extends StatefulWidget {
//   @override
//   _AddacSPDState createState() => _AddacSPDState();
// }
//
// class _AddacSPDState extends State<AddacSPD> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add AC SPD Info'),
//       ),
//       body: Center(
//         child: CompleteForm(),
//       ),
//     );
//   }
// }
//
// class CompleteForm extends StatefulWidget {
//   const CompleteForm({Key? key}) : super(key: key);
//
//   @override
//   State<CompleteForm> createState() {
//     return _CompleteFormState();
//   }
// }
//
// class _CompleteFormState extends State<CompleteForm> {
//   final _formKey = GlobalKey<FormBuilderState>();
//   String? selectedRegion;
//   Map<String, String> regionMap = {}; // Store region and Region_ID
//   List<String> rtoms = [];
//   String? selectedRTOM;
//   String? selectedSPDManufacturer;
//   bool _showOtherField = false;
//   String? selectedSPDType;
//
//
//   List<dynamic> _station = [];
//   List<dynamic> _filteredStation = [];
//   String? _selectedStation;
//   bool _isStationLoading = true;
//   String _status = '';
//   List<String> SPDManufacturers = [];
//   List<String> SPDTypes = ['Type 1', 'Type1+2', 'Type 2', 'Type 3', 'Unknown']; // Default SPD Types
//
//
//   // Map to store SPD Manufacturer data (use the actual data structure in your API)
//   Map<String, String> SPDManufacturerMap = {};
//
//   // Declare SPDTypeMap and SPDTypeName
//   Map<String, String> SPDTypeMap = {}; // Map region names to SPD Type IDs
//   String? SPDTypeName; // Current selected SPD type
//
//
//
//   // String? selectedRTOM;
//   // String? selectedRegion;
//   bool autoValidate = true;
//   bool readOnly = false;
//   bool showSegmentedControl = true;
//   // final _formKey = GlobalKey<FormBuilderState>();
//   bool _regionHasError = false;
//   bool _eBrandHasError = false;
//   bool _aBrandHasError = false;
//   bool _spdUnitary = false;
//   bool _validator1 = false;
//   bool _3phase = false;
//   bool _validator3 = false;
//   bool _validator4 = false;
//   bool _validator5 = false;
//   bool _validator6 = false;
//   bool _validator7 = false;
//   bool _validator8 = false;
//   bool _validator9 = false;
//   bool _validator10 = false;
//   bool _validator11 = false;
//   bool _validator12 = false;
//   bool _validator13 = false;
//   bool _validator14 = false;
//   bool _validator15 = false;
//   bool _validator16 = false;
//   String userName = "";
//
//   double _sliderValue = 0.0;
//   bool _burned = false;
//   bool _dcSPD = false;
//   bool _dischargeAll = false;
//   bool _discharge10_350 = false;
//   bool _dicharge8_20 = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchRegions(); // Fetch regions on widget initialization
//     _loadStation(); // Load stations on initialization
//
//     debugPrint("Form Key Initialized: $_formKey"); // Print form key during initialization
//   }
//
//
// //string array
//   Map<String, String> _selectedValues = {};
//
//
//   var Regions = [
//     'CPN',
//     'CPS',
//     'EPN',
//     'EPS',
//     'EPN–TC',
//     'HQ',
//     'NCP',
//     'NPN',
//     'NPS',
//     'NWPE',
//     'NWPW',
//     'PITI',
//     'SAB',
//     'SMW6',
//     'SPE',
//     'SPW',
//     'WEL',
//     'WPC',
//     'WPE',
//     'WPN',
//     'WPNE',
//     'WPS',
//     'WPSE',
//     'WPSW',
//     'UVA'
//   ];
//   //var SPDTypes = ['Type 1', 'Type1+2', 'Type 2', 'Type 3', 'Unknown'];
//   var SPDBrands = [
//     'Citel',
//     'Critec',
//     'DEHN',
//     'Erico',
//     'OBO',
//     'XW2',
//     'Zone Guard',
//     'Other'
//   ];
//
//   Map<String, List<String>> regionToDistricts = {
//     "CPN": ['Kandy', 'Dambulla', 'Matale'],
//     "CPS": [
//       'Gampola',
//       'Nuwaraeliya',
//       'Haton',
//       'Peradeniya',
//       'Nawalapitiya',
//       'Gampola'
//     ],
//     "EPN": ['Batticaloa'],
//     'EPNTC': ['Trincomalee'],
//     'EPS': ['Ampara', 'Kalmunai'],
//     'HQ': ['Head Office'],
//     'NCP': ['Anuradhapura', 'Polonnaruwa'],
//     'NPN': ['Jaffna'],
//     'NPS': ['MB', 'Vaunia', 'Mulativ', 'Kilinochchi'],
//     'NWPE': ['Kurunagala', 'Kuliyapitiya'],
//     'NWPW': ['Chilaw', 'Puttalam', 'Chilaw-01', 'Chilaw-02', 'Chilaw-03'],
//     'PITI': ['Pitipana'],
//     'SAB': ['Ratnapura', 'Kegalle'],
//     'SPE': ['Matara', 'Hambantota'],
//     'SPW': ['Galle', 'Ambalangoda'],
//     'UVA': ['Bandarawela', 'Badulla', 'Monaragala'],
//     'WEL': ['Welikada'],
//     'WPC': ['Colombo Central', 'Havelock Town', 'Maradana'],
//     'WPE': ['Kotte', 'Kolonnawa'],
//     'WPN': ['Wattala', 'Negombo'],
//     'WPNE': ['Kelaniya', 'Gampaha', 'Nittambuwa'],
//     'WPS': ['Horana', 'Panadura'],
//     'WPSE': ['Maharagama', 'Homagama', 'Awissawella'],
//     'WPSW': ['Rathmalana', 'Nugegoda'],
//   };
//
//   String? _validateAtLeastOneInput(Map<String, dynamic> values) {
//     final inLive =
//     values['Nominal Discharge Current rating (In)-Live (8/20µs)'];
//     final iimpLive =
//     values['Impulse Discharge Current rating (Iimp)-Live (10/350µs)'];
//
//     if (inLive != null || iimpLive != null) {
//       return null; // At least one field is filled, validation passes.
//     } else {
//       return 'At least one of these fields is required.';
//     }
//   }
//
//   List<String> years =
//   List.generate(40, (index) => (DateTime.now().year - index).toString());
//
//   void _onChanged(dynamic val) => debugPrint(val.toString());
//
//   // Fetch Regions from the API and store Region with Region_ID
//   Future<void> _fetchRegions() async {
//     try {
//       final response = await http
//           .get(Uri.parse('https://powerprox.sltidc.lk/GETLocationRegion.php'));
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//
//         setState(() {
//           regionMap = {
//             for (var item in data)
//               item['Region'].toString(): item['Region_ID'].toString(),
//           };
//         });
//       } else {
//         throw Exception('Failed to load regions');
//       }
//     } catch (e) {
//       print(e);
//       _showErrorSnackBar('Failed to load regions.');
//     }
//   }
//
//   // Fetch RTOMs based on selected Region_ID
//   Future<void> _fetchRTOMs(String regionName) async {
//     setState(() {
//       rtoms.clear(); // Clear any previous data
//     });
//
//     final regionId = regionMap[regionName];
//     if (regionId == null) {
//       _showErrorSnackBar('Invalid region selected.');
//       return;
//     }
//
//     try {
//       final response = await http
//           .get(Uri.parse('https://powerprox.sltidc.lk/GETLocationRTOM.php'));
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//
//         setState(() {
//           rtoms = data
//               .where((item) => item['Region_ID'].toString() == regionId)
//               .map((item) => item['RTOM'].toString())
//               .toList();
//         });
//       } else {
//         throw Exception('Failed to load RTOM data');
//       }
//     } catch (e) {
//       print(e);
//       _showErrorSnackBar('An error occurred while loading RTOM data.');
//     }
//   }
//
//
//   // select spd type
//   Future<void> _fetchSPDTypes(String regionName) async {
//     setState(() {
//       SPDTypes.clear(); // Clear any previous data
//     });
//
//     final SPDTypeId = SPDTypeMap[SPDTypeName];
//     if (SPDTypeId == null) {
//       _showErrorSnackBar('Invalid SPD Type selected.');
//       return;
//     }
//
//     try {
//       final response = await http
//           .get(Uri.parse('https://powerprox.sltidc.lk/GETLocationSPDType.php'));
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//
//         setState(() {
//           SPDTypes = data
//               .where((item) =>
//           item['SPDType_ID'].toString() == SPDTypeId)
//               .map((item) => item['SPDType'].toString())
//               .toList();
//         });
//       } else {
//         throw Exception('Failed to load SPD Type data');
//       }
//     } catch (e) {
//       print(e);
//       _showErrorSnackBar(
//           'An error occurred while loading SPD Type data.');
//     }
//   }
//
//   // Fetch SPD Manufacturers
//   Future<void> _fetchSPDManufacturers(String regionName) async {
//     setState(() {
//       SPDManufacturers.clear(); // Clear any previous data
//     });
//
//     final SPDManufacturerId = SPDManufacturerMap[regionName];
//     if (SPDManufacturerId == null) {
//       _showErrorSnackBar('Invalid SPD Manufacturer selected.');
//       return;
//     }
//
//     try {
//       final response = await http
//           .get(Uri.parse('https://powerprox.sltidc.lk/GETLocationSPDManufacturer.php'));
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//
//         setState(() {
//           SPDManufacturers = data
//               .where((item) =>
//           item['SPDManufacturer_ID'].toString() == SPDManufacturerId)
//               .map((item) => item['SPDManufacturer'].toString())
//               .toList();
//         });
//       } else {
//         throw Exception('Failed to load SPD Manufacturer data');
//       }
//     } catch (e) {
//       print(e);
//       _showErrorSnackBar(
//           'An error occurred while loading SPD Manufacturer data.');
//     }
//   }
//
//
//
//   // Function to show a SnackBar error message
//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(message),
//       backgroundColor: Colors.red,
//     ));
//   }
//
//   void _showAddNewRTOMDialog() {
//     final TextEditingController _rtomController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Add New RTOM'),
//           content: TextField(
//             controller: _rtomController,
//             decoration: const InputDecoration(hintText: 'Enter new RTOM'),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog without saving
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (_rtomController.text.isNotEmpty) {
//                   setState(() {
//                     // Add the custom RTOM to the dropdown options
//                     rtoms.add(_rtomController.text);
//                     selectedRTOM = _rtomController.text;
//                   });
//                 }
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//
//   void _showAddNewSPDTypeDialog() {
//     final TextEditingController newSPDTypeController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Add New SPD Type'),
//         content: TextField(
//           controller: newSPDTypeController,
//           decoration: const InputDecoration(hintText: 'Enter new SPD Type'),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(); // Close the dialog
//             },
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               if (newSPDTypeController.text.isNotEmpty) {
//                 setState(() {
//                   SPDTypes.add(newSPDTypeController.text); // Add the new SPD Type
//                   selectedSPDType = newSPDTypeController.text;
//                 });
//               }
//               Navigator.of(context).pop(); // Close the dialog
//             },
//             child: const Text('Add'),
//           ),
//         ],
//       ),);
//
//   }
//
//
//
//   //spd manu
//   void _showAddNewSPDManufacturerDialog() {
//     TextEditingController _customManufacturerController =
//     TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Add New SPD Manufacturer'),
//           content: TextField(
//             controller: _customManufacturerController,
//             decoration: const InputDecoration(hintText: 'Enter Manufacturer Name'),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog without saving
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (_customManufacturerController.text.isNotEmpty) {
//                   setState(() {
//                     // Add the custom RTOM to the dropdown options
//                     SPDManufacturers.add(_customManufacturerController.text);
//                     selectedSPDManufacturer = _customManufacturerController.text;
//                   });
//                 }
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//
//   // Function to load Stations
//   Future<void> _loadStation() async {
//     setState(() {
//       _isStationLoading = true; // Start loading
//     });
//
//     try {
//       final response = await http.get(
//           Uri.parse('https://powerprox.sltidc.lk/GETLocationStationTable.php'));
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//
//         setState(() {
//           _station = data.map((item) => item['Station'].toString()).toList();
//           _filteredStation = List.from(_station); // Copy list for filtering
//           _isStationLoading = false; // Stop loading
//         });
//       } else {
//         throw Exception('Failed to load Station data');
//       }
//     } catch (e) {
//       print(e);
//       setState(() {
//         _isStationLoading = false;
//       });
//       _showErrorSnackBar('An error occurred while loading Station data.');
//     }
//   }
//
//   // Filter stations
//   void _filterStations(String rtom) {
//     setState(() {
//       _filteredStation = rtom.isEmpty
//           ? List.from(_station)
//           : _station
//           .where((station) =>
//           station.toLowerCase().contains(rtom.toLowerCase()))
//           .toList();
//     });
//   }
//
//   // Function to Show Dialog for Adding New Station
//   void _showAddNewStationDialog(String key, String label) {
//     TextEditingController _newStationController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Add New $label'),
//           content: TextField(
//             controller: _newStationController,
//             decoration: InputDecoration(hintText: 'Enter new $label'),
//           ),
//           actions: [
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Add'),
//               onPressed: () {
//                 if (_newStationController.text.isNotEmpty) {
//                   setState(() {
//                     _filteredStation.add(_newStationController
//                         .text); // Add new station to filtered list
//                     _station.add(_newStationController
//                         .text); // Add to the main station list
//                     //_formData[key] = _newStationController.text; // Automatically select new station
//                     _selectedStation = _newStationController
//                         .text; // Set selected value in the dropdown
//                     _showSnackBar(
//                         'New station added: ${_newStationController.text}'); // Show confirmation snack bar
//                   });
//                   Navigator.of(context).pop();
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(message),
//       backgroundColor: Colors.green,
//     ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     UserAccess userAccess = Provider.of<UserAccess>(context, listen: true); // Use listen: true to rebuild the widget when the data changes
//     userName = userAccess.username!;
//
//     return Scaffold(
//         body: Padding(
//             padding: const EdgeInsets.all(10),
//             // Correct usage of Padding with named argument `padding`
//             child: SingleChildScrollView(
//                 child: FormBuilder(
//                     key: _formKey,
//                     child: Column(children: <Widget>[
//                       const SizedBox(height: 50),
//                       // Region Dropdown
//                       Container(
//                         margin: const EdgeInsets.all(10),
//                         width: 600,
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.green),
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         child: FormBuilderDropdown<String>(
//                           name: 'region',
//                           decoration: const InputDecoration(
//                             hintText: 'Region',
//                             border: InputBorder.none,
//                           ),
//                           items: regionMap.keys.map((region) {
//                             return DropdownMenuItem<String>(
//                               value: region,
//                               child: Text(region),
//                             );
//                           }).toList(),
//                           onChanged: (String? newValue) {
//                             setState(() {
//                               selectedRegion = newValue;
//                               if (newValue != null) {
//                                 _fetchRTOMs(
//                                     newValue); // Fetch RTOMs based on selected region
//                                 selectedRTOM =
//                                 null; // Reset selected RTOM when region changes
//                                 _filteredStation.clear(); // Clear station list
//                                 _selectedStation = null; // Reset station selection
//                               }
//                             });
//                           },
//                           validator: FormBuilderValidators.required(
//                             errorText: 'Please select a region.',
//                           ),
//                         ),
//                       ),
//
//                       // RTOM Dropdown (Populated after region selection)
//                       Container(
//                         margin: const EdgeInsets.all(10),
//                         width: 600,
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.green),
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         child: FormBuilderDropdown<String>(
//                           name: 'rtom',
//                           initialValue: selectedRTOM,
//                           // Bind the selected RTOM to the dropdown
//                           decoration: const InputDecoration(
//                             hintText: 'RTOM',
//                             border: InputBorder.none,
//                           ),
//                           items: [
//                             ...rtoms.map((rtom) {
//                               return DropdownMenuItem<String>(
//                                 value: rtom,
//                                 child: Text(rtom),
//                               );
//                             }).toList(),
//                             const DropdownMenuItem<String>(
//                               value: 'Other',
//                               child: Text('Other'),
//                             ),
//                           ],
//                           onChanged: (String? newValue) {
//                             if (newValue == 'Other') {
//                               _showAddNewRTOMDialog(); // Show dialog to add a new RTOM
//                             } else {
//                               setState(() {
//                                 selectedRTOM = newValue;
//                                 _filterStations(newValue ??
//                                     ''); // Filter stations based on selected RTOM
//                                 _selectedStation = null; // Reset station selection
//                               });
//                             }
//                           },
//                           validator: FormBuilderValidators.required(
//                             errorText: 'Please select an RTOM.',
//                           ),
//                           enabled: selectedRegion !=
//                               null, // Disable if no region is selected
//                         ),
//                       ),
//
//                       // Station Dropdown
//                       Container(
//                         margin: const EdgeInsets.all(10),
//                         width: 600,
//                         child: _isStationLoading
//                             ? const Center(child: CircularProgressIndicator())
//                             : FormBuilderDropdown<String>(
//                           name: 'station',
//                           initialValue: _selectedStation,
//                           // It will be null if no station selected
//                           decoration: const InputDecoration(
//                             hintText: 'Station',
//                             border: OutlineInputBorder(),
//                           ),
//                           items: [
//                             ..._filteredStation.map((station) {
//                               return DropdownMenuItem<String>(
//                                 value: station,
//                                 child: Text(station),
//                               );
//                             }).toList(),
//                             const DropdownMenuItem<String>(
//                               value: 'Other',
//                               child: Text('Other'),
//                             ),
//                           ],
//                           onChanged: (String? newValue) {
//                             if (newValue == 'Other') {
//                               // Show the dialog to add a new station
//                               _showAddNewStationDialog('station', 'Station');
//                             } else {
//                               setState(() {
//                                 //_formData['station'] = newValue ?? ''; // Update form data
//                                 _selectedStation =
//                                     newValue; // Set the selected station
//                               });
//                             }
//                           },
//                           validator: FormBuilderValidators.required(
//                             errorText: 'Please select a station.',
//                           ),
//                           enabled:
//                           selectedRTOM != null, // Disable if no RTOM selected
//                         ),
//                       ),
// //               FormBuilder(
// //                 key: _formKey,
// // // enabled: false,
// //                 onChanged: () {
// //                   _formKey.currentState!.save();
// //                   debugPrint(_formKey.currentState!.value.toString());
// //                 },
// //                 autovalidateMode: AutovalidateMode.disabled,
// //
// //                 skipDisabled: true,
// //                 child: Column(
// //                   children: <Widget>[
// //                     const SizedBox(height: 15),
// //
// // //Region Select
// //                     FormBuilderDropdown<String>(
// //                       name: 'province',
// //                       decoration: InputDecoration(
// //                         labelText: 'Region',
// //                         suffix: _regionHasError
// //                             ? const Icon(Icons.error)
// //                             : const Icon(Icons.check, color: Colors.green),
// //                         hintText: 'Select Region',
// //                       ),
// //                       validator: FormBuilderValidators.compose(
// //                           [FormBuilderValidators.required()]),
// //                       items: Regions
// //                           .map((Regions) => DropdownMenuItem(
// //                         alignment: AlignmentDirectional.center,
// //                         value: Regions,
// //                         child: Text(Regions),
// //                       ))
// //                           .toList(),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           _selectedValues['province'] = val!;
// //                           selectedRegion = val;
// //                           selectedRTOM=null;
// //                           _regionHasError = !(_formKey.currentState?.fields['province']?.validate() ?? false);
// // // Reset the 'Rtom_name' field value and clear validation errors
// //                           _formKey.currentState?.fields['Rtom_name']?.didChange(null);
// //                         });
// // //  print('Region: ' + _selectedValues['Region'].toString());
// //                       },
// //                       valueTransformer: (val) => val?.toString(),
// //                     ),
// //
// //
// //                     FormBuilderDropdown<String>(
// //                       name: 'Rtom_name',
// //                       decoration: InputDecoration(
// //                         labelText: 'RTOM',
// //                       ),
// //                       validator: FormBuilderValidators.required(),
// //
// //                       items: (selectedRegion != null) ? (regionToDistricts[selectedRegion] ?? []).map((RTOM) => DropdownMenuItem(
// //                         value: RTOM,
// //                         child: Text(RTOM),
// //                       )).toList() : [],
// //
// //
// //                       onChanged: (value) => setState(() {
// // //  print('RTOM: ' + _selectedValues['RTOM'].toString());
// //                       }),
// //                     ),
// // // Show tick mark if data is entered
// //                     _formKey.currentState?.fields['Rtom_name']?.value?.toString()?.isNotEmpty ?? false
// //                         ? Icon(
// //                       Icons.check,
// //                       color: Colors.green,
// //                     )
// //                         : SizedBox(),
// //
// //
// //
// //
// // //Station Text Field
// //                     Stack(
// //                       alignment: Alignment.centerRight,
// //                       children: [
// //                         FormBuilderTextField(
// //                           name: 'station',
// // // enabled: false,
// //                           decoration: InputDecoration(
// //                             labelText: 'Station (QR Code ID)',
// //                           ),
// //                           validator: FormBuilderValidators.required(),
// //                           onChanged: (value) => setState(() {}),
// //                         ),
// // // Show tick mark if data is entered
// //                         _formKey.currentState?.fields['station']?.value?.toString()?.isNotEmpty ?? false
// //                             ? Icon(
// //                           Icons.check,
// //                           color: Colors.green,
// //                         )
// //                             : SizedBox(),
// //                       ],
// //                     ),
//
// //SPD Location that is to be typed
//                       Stack(
//                         alignment: Alignment.centerRight,
//                         children: [
//                           FormBuilderTextField(
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             name: 'SPDLoc',
//                             decoration: InputDecoration(
//                               labelText: 'SPD Location (DB Location)',
//                             ),
//                             validator: FormBuilderValidators.required(),
//                             onChanged: (value) => setState(() {
//                               _selectedValues['SPDLoc'] = value!;
//
//                             }),
//                           ),
//
//
//
//
//                         ],
//                       ),
//
// //SPD Phase
//                       FormBuilderChoiceChips<String>(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         decoration: const InputDecoration(labelText: 'Unit Type'),
//                         name: 'modular',
//                         initialValue: 'N/A',
//                         selectedColor: Colors.lightBlueAccent,
//                         options: const [
//                           FormBuilderChipOption(
//                             value: 'Modular', //this is 3 phase
//                             child: Text('Modular'),
//                             avatar: CircleAvatar(child: Text('')),
//                           ),
//                           FormBuilderChipOption(
//                             value: 'Unitary', //this is 3 phase
//                             child: Text('Unitary'),
//                             avatar: CircleAvatar(child: Text('')),
//                           ),
//                         ],
//                         onChanged: (val) {
//                           _onChanged;
//                           setState(() {
//                             _spdUnitary = val == 'Unitary'
//                                 ? true
//                                 : false; // Update the flag based on the selected value
//                           });
//                         },
//                       ),
//
// // SPD Type (DC/AC)
//                       FormBuilderChoiceChip<String>(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         decoration: const InputDecoration(labelText: 'SPD Type'),
//                         name: 'poles',
//                         initialValue: '',
//                         enabled: !_spdUnitary,
//                         selectedColor: Colors.lightBlueAccent,
//                         options: const [
//                           FormBuilderChipOption(
//                             value: '2',
//                             child: Text('Two Pole'),
//                             avatar: CircleAvatar(child: Text('')),
//                           ),
//                           FormBuilderChipOption(
//                             value: '3',
//                             child: Text('Three Pole'),
//                             avatar: CircleAvatar(child: Text('')),
//                           ),
//                           FormBuilderChipOption(
//                             value: '4',
//                             child: Text('Four Pole'),
//                             avatar: CircleAvatar(child: Text('')),
//                           ),
//                           FormBuilderChipOption(
//                             value: '5',
//                             child: Text('Five Pole'),
//                             avatar: CircleAvatar(child: Text('')),
//                           ),
//                         ],
// // onChanged: _onChanged,
//                         onChanged: (val) {
//                           _onChanged;
//                           setState(() {
// //_dcSPD = val=='DC'? false:true; // Update the flag based on the selected value
//                           });
//                         },
//                       ),
//
// //SPD Phase
//                       FormBuilderChoiceChip<String>(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         decoration: const InputDecoration(labelText: 'SPD Phase'),
//                         name: 'phase',
//                         initialValue: 'N/A',
//                         selectedColor: Colors.lightBlueAccent,
//                         options: const [
//                           FormBuilderChipOption(
//                             value: '1', //this is 3 phase
//                             child: Text('Phase'),
//                             avatar: CircleAvatar(child: Text('1')),
//                           ),
//                           FormBuilderChipOption(
//                             value: '3', //this is 3 phase
//                             child: Text('Phase'),
//                             avatar: CircleAvatar(child: Text('3')),
//                           ),
//                         ],
//                         onChanged: (val) {
//                           _onChanged;
//                           setState(() {
//                             _3phase = val == '1'
//                                 ? false
//                                 : true; // Update the flag based on the selected value
//                           });
//                         },
//                       ),
//
// //
// //
// //Alternator Brand
//                       FormBuilderDropdown<String>(
//                         name: 'SPDType',
//                         initialValue: selectedSPDType,
//                         decoration: InputDecoration(
//                           labelText: 'Select SPD Type',
//
//                           hintText: 'Select SPD Type',
//                         ),
//                         validator: FormBuilderValidators.compose(
//                             [FormBuilderValidators.required(errorText: 'Please select an SPD Type.')]),
//                         items: [
//                           ...SPDTypes.map((aBrand) => DropdownMenuItem(
//                             alignment: AlignmentDirectional.center,
//                             value: aBrand,
//                             child: Text(aBrand),
//                           )),
//                           const DropdownMenuItem<String>(
//                             value: 'Other',
//                             child: Text('Other'),
//                           ),
//                         ],
//                         onChanged: (val) {
//                           if (val == 'Other') {
//                             _showAddNewSPDTypeDialog();
//                           } else {
//                             setState(() {
//
//                               _aBrandHasError = !(_formKey.currentState?.fields['SPDType']
//                                   ?.validate() ??
//                                   false);
//                             });
//                           }
//                         },
//                         valueTransformer: (val) => val?.toString(),
//                       ),
//
// //SPD Manufacturer
//                       //SPD Manufacturer
//                       FormBuilderDropdown<String>(
//                         name: 'SPDManufacturer',
//                         initialValue: selectedSPDManufacturer,
//                         decoration: const InputDecoration(
//                           labelText: 'Select SPD Manufacturer',
//                           hintText: 'SPD Manufacturer',
//                           border: InputBorder.none,
//                         ),
//                         items: [
//                           ...SPDManufacturers.map((SPDManufacturer) {
//                             return DropdownMenuItem<String>(
//                               value: SPDManufacturer,
//                               child: Text(SPDManufacturer),
//                             );
//                           }).toList(),
//                           const DropdownMenuItem<String>(
//                             value: 'Other',
//                             child: Text('Other'),
//                           ),
//                         ],
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             selectedSPDManufacturer = newValue;
//                             _showOtherField = newValue == 'Other'; // Update visibility
//                           });
//                         },
//                         validator: FormBuilderValidators.required(
//                           errorText: 'Please select an SPD Manufacturer.',
//                         ),
//                         enabled: true,
//                       ),
//                       if (_showOtherField)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: FormBuilderTextField(
//                             name: 'OtherSPDManufacturer',
//                             decoration: const InputDecoration(
//                               labelText: 'Enter SPD Manufacturer',
//                               border: OutlineInputBorder(),
//                             ),
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(
//                                   errorText: 'Please enter the manufacturer name.'),
//                             ]),
//                           ),
//                         ),
//
//
// //SPD Model Text Field
//                       Stack(
//                         alignment: Alignment.centerRight,
//                         children: [
//                           FormBuilderTextField(
//                             name: 'model_SPD',
//                             decoration: InputDecoration(
//                               labelText: 'SPD Model',
//                             ),
// //validator: FormBuilderValidators.required(),
//                             onChanged: (value) => setState(() {}),
//                           ),
// // Show tick mark if data is entered
//
//                         ],
//                       ),
//
// //SPD Status
//                       FormBuilderChoiceChip<String>(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         decoration: const InputDecoration(labelText: 'SPD Status'),
//                         name: 'status',
//                         initialValue: '',
//                         selectedColor: Colors.lightBlueAccent,
//                         options: const [
//                           FormBuilderChipOption(
//                             value: 'Active',
//                             avatar: CircleAvatar(child: Text('')),
//                           ),
//                           FormBuilderChipOption(
//                             value: 'Burned',
//                             avatar: CircleAvatar(child: Text('')),
//                           ),
//                         ],
// // onChanged: _onChanged,
//
//                         onChanged: (val) {
//                           _onChanged;
//                           setState(() {
//                             _burned = val == 'Burned'
//                                 ? false
//                                 : true; // Update the flag based on the selected value
//                           });
//                         },
//                       ),
//
//                       FormBuilderSlider(
//                         name: 'PercentageR',
// // validator: FormBuilderValidators.compose([
// //   FormBuilderValidators.min(context, 6),
// // ]),
//                         onChanged: _onChanged,
//                         min: 0.0,
//                         max: 100.0,
//                         initialValue: 0.0,
//                         divisions: 10,
//                         activeColor: Colors.red,
//                         inactiveColor: Colors.pink[100],
//                         enabled: _burned,
//                         decoration: InputDecoration(
//                           labelText: 'Percentage Level %  (Phase 1)',
//                         ),
//                       ),
//
//                       FormBuilderSlider(
//                         name: 'PercentageY',
// // validator: FormBuilderValidators.compose([
// //   FormBuilderValidators.min(context, 6),
// // ]),
//                         onChanged: _onChanged,
//                         min: 0.0,
//                         max: 100.0,
//                         initialValue: 0.0,
//                         divisions: 10,
//                         activeColor: Colors.red,
//                         inactiveColor: Colors.pink[100],
//                         enabled: _burned && _3phase,
//                         decoration: InputDecoration(
//                           labelText: 'Percentage Level %  (Phase 2)',
//                         ),
//                       ),
//
//                       FormBuilderSlider(
//                         name: 'PercentageB',
// // validator: FormBuilderValidators.compose([
// //   FormBuilderValidators.min(context, 6),
// // ]),
//                         onChanged: _onChanged,
//                         min: 0.0,
//                         max: 100.0,
//                         initialValue: 0.0,
//                         divisions: 10,
//                         activeColor: Colors.red,
//                         inactiveColor: Colors.pink[100],
//                         enabled: _burned && _3phase,
//                         decoration: InputDecoration(
//                           labelText: 'Percentage Level % (Phase 3)',
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         'Nominal Voltage (U_n)',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold, // Set the fontWeight to bold
//                         ),
//                       ),
//
// //SPD Nominal Voltage Text Field
//                       FormBuilderTextField(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         name: 'nom_volt',
//                         decoration: InputDecoration(
//                           labelText: 'Nominal Voltage (V)',
//
//                         ),
//                         onChanged: (val) {
//                           setState(() {
//                             _validator1 = !(_formKey.currentState?.fields['nom_volt']
//                                 ?.validate() ??
//                                 false);
//                           });
//                         },
// // valueTransformer: (text) => num.tryParse(text),
//                         validator: FormBuilderValidators.compose([
// //FormBuilderValidators.required(),
//                           FormBuilderValidators.numeric(),
//                           FormBuilderValidators.max(500),
//                         ]),
// // initialValue: '12',
//                         keyboardType: TextInputType.number,
//                         textInputAction: TextInputAction.next,
//                       ),
//
//                       SizedBox(height: 10),
//                       Text(
//                         'Maximum continuous operating voltage (Uc) -Live',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold, // Set the fontWeight to bold
//                         ),
//                       ),
//
// //SPD Status
//                       FormBuilderChoiceChip<String>(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         decoration: const InputDecoration(
//                             labelText: 'Uc Live to neutral or Live to earth'),
//                         name: 'UcLiveMode',
//                         initialValue: '',
//                         selectedColor: Colors.lightBlueAccent,
//                         options: const [
//                           FormBuilderChipOption(
//                             value: 'L-N',
//                             avatar: CircleAvatar(child: Text('')),
//                           ),
//                           FormBuilderChipOption(
//                             value: 'L-E',
//                             avatar: CircleAvatar(child: Text('')),
//                           ),
//                         ],
// // onChanged: _onChanged,
//                       ),
//
// //SPD Voltage Protection Level
//                       FormBuilderTextField(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         name: 'UcLiveVolt',
//                         decoration: InputDecoration(
//                           labelText: 'Uc (Live) in Volt',
//
//                         ),
//                         onChanged: (val) {
//                           setState(() {
//                             _validator15 = !(_formKey.currentState?.fields['UcLiveVolt']
//                                 ?.validate() ??
//                                 false);
//                           });
//                         },
// // valueTransformer: (text) => num.tryParse(text),
//                         validator: FormBuilderValidators.compose([
// //  FormBuilderValidators.required(),
//                           FormBuilderValidators.numeric(),
//                           FormBuilderValidators.max(500),
//                         ]),
// // initialValue: '12',
//                         keyboardType: TextInputType.number,
//                         textInputAction: TextInputAction.next,
//                       ),
//
//                       SizedBox(height: 10),
//                       Text(
//                         'Maximum continuous operating voltage (Uc)- Neutral',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold, // Set the fontWeight to bold
//                         ),
//                       ),
//
//                       FormBuilderTextField(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         name: 'UcNeutralVolt',
//                         decoration: InputDecoration(
//                           labelText: 'Uc (Neutral) in Volt',
//
//                         ),
//                         onChanged: (val) {
//                           setState(() {
//                             _validator14 = !(_formKey
//                                 .currentState?.fields['UcNeutralVolt']
//                                 ?.validate() ??
//                                 false);
//                           });
//                         },
// // valueTransformer: (text) => num.tryParse(text),
//                         validator: FormBuilderValidators.compose([
// //   FormBuilderValidators.required(),
//                           FormBuilderValidators.numeric(),
//                           FormBuilderValidators.max(500),
//                         ]),
// // initialValue: '12',
//                         keyboardType: TextInputType.number,
//                         textInputAction: TextInputAction.next,
//                       ),
//
//                       SizedBox(height: 10),
//                       Text(
//                         'Voltage Protection Level (Up)- Live',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold, // Set the fontWeight to bold
//                         ),
//                       ),
//
//                       FormBuilderTextField(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         name: 'UpLiveVolt',
//                         decoration: InputDecoration(
//                           labelText: 'Up (Live) in Volt',
//
//                         ),
//                         onChanged: (val) {
//                           setState(() {
//                             _validator13 = !(_formKey
//                                 .currentState?.fields['UpNeutralVolt']
//                                 ?.validate() ??
//                                 false);
//                           });
//                         },
//
// // valueTransformer: (text) => num.tryParse(text),
//                         validator: (value) {
//                           if (_dcSPD) {
//                             return FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                               FormBuilderValidators.numeric(),
//                               FormBuilderValidators.max(5000),
//                             ])(value);
//                           }
// // If _dcSPD is true (field is disabled), return null to bypass the validation.
//                           return null;
//                         },
// // initialValue: '12',
//                         keyboardType: TextInputType.number,
//                         textInputAction: TextInputAction.next,
//                       ),
//
//                       SizedBox(height: 10),
//                       Text(
//                         'Voltage Protection Level- Neutral',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold, // Set the fontWeight to bold
//                         ),
//                       ),
//
//                       FormBuilderTextField(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         name: 'UpNeutralVolt',
//                         decoration: InputDecoration(
//                           labelText: 'Up (Neutral) in Volt',
//
//                         ),
//                         onChanged: (val) {
//                           setState(() {
//                             _validator12 = !(_formKey.currentState?.fields['Up_Neutral']
//                                 ?.validate() ??
//                                 false);
//                           });
//                         },
// // valueTransformer: (text) => num.tryParse(text),
//                         validator: (value) {
//                           if (_dcSPD) {
//                             return FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                               FormBuilderValidators.numeric(),
//                               FormBuilderValidators.max(5000),
//                             ])(value);
//                           }
// // If _dcSPD is true (field is disabled), return null to bypass the validation.
//                           return null;
//                         },
// // initialValue: '12',
//                         keyboardType: TextInputType.number,
//                         textInputAction: TextInputAction.next,
//                       ),
//
//                       SizedBox(height: 10),
//                       Text(
//                         'Discharge Current',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold, // Set the fontWeight to bold
//                         ),
//                       ),
//
//                       FormBuilderChoiceChip<String>(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         decoration: const InputDecoration(
//                             labelText: 'Discharge Current Rating Types Available'),
//                         name: 'dischargeType',
//                         initialValue: '',
//                         selectedColor: Colors.lightBlueAccent,
//                         options: const [
//                           FormBuilderChipOption(
//                             value: '8/20us+10/350us',
//                             avatar: CircleAvatar(child: Text('')),
//                           ),
//                           FormBuilderChipOption(
//                             value: '8/20us',
//                             avatar: CircleAvatar(child: Text('')),
//                           ),
//                           FormBuilderChipOption(
//                             value: '10/350us',
//                             avatar: CircleAvatar(child: Text('')),
//                           ),
//                         ],
// // onChanged: _onChanged,
//
//                         onChanged: (val) {
//                           _onChanged;
//                           setState(() {
//                             _dischargeAll = val == '8/20us+10/350us' ? true : false;
//                             _dicharge8_20 = val == '8/20us' ? true : false;
//                             _discharge10_350 = val == '10/350us' ? true : false;
//                           });
//                         },
//                       ),
//
//                       FormBuilderTextField(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         name: 'L8to20NomD',
//                         decoration: InputDecoration(
//                           labelText:
//                           'Nominal Discharge Current rating (In)-Live (8/20µs) (kA)',
//
//                         ),
//                         enabled: (_dischargeAll || _dicharge8_20),
//                         onChanged: (val) {
//                           setState(() {
//                             _validator11 = !(_formKey.currentState?.fields['L8to20NomD']
//                                 ?.validate() ??
//                                 false);
//                           });
//                         },
// // valueTransformer: (text) => num.tryParse(text),
//                         validator: (value) {
//                           if (((_dischargeAll || _dicharge8_20))) {
//                             return FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                               FormBuilderValidators.numeric(),
//                               FormBuilderValidators.max(100),
//                             ])(value);
//                           }
// // If _dcSPD is true (field is disabled), return null to bypass the validation.
//                           return null;
//                         },
// // initialValue: '12',
//                         keyboardType: TextInputType.number,
//                         textInputAction: TextInputAction.next,
//                       ),
//
//                       FormBuilderTextField(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         name: 'N8to20NomD',
//                         decoration: InputDecoration(
//                           labelText:
//                           'Nominal Discharge Current rating (In)-Neutral (8/20µs) (kA)',
//
//                         ),
//                         enabled: (_dischargeAll || _dicharge8_20),
//                         onChanged: (val) {
//                           setState(() {
//                             _validator10 = !(_formKey.currentState?.fields['N8to20NomD']
//                                 ?.validate() ??
//                                 false);
//                           });
//                         },
// // valueTransformer: (text) => num.tryParse(text),
//                         validator: (value) {
//                           if (((_dischargeAll || _dicharge8_20))) {
//                             return FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                               FormBuilderValidators.numeric(),
//                               FormBuilderValidators.max(100),
//                             ])(value);
//                           }
// // If _dcSPD is true (field is disabled), return null to bypass the validation.
//                           return null;
//                         },
// // initialValue: '12',
//                         keyboardType: TextInputType.number,
//                         textInputAction: TextInputAction.next,
//                       ),
//
//                       FormBuilderTextField(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         name: 'L10to350ImpD',
//                         decoration: InputDecoration(
//                           labelText:
//                           'Impulse Discharge Current rating (Iimp)-Live (10/350µs) (kA)',
//
//                         ),
//                         enabled: (_dischargeAll || _discharge10_350),
//                         onChanged: (val) {
//                           setState(() {
//                             _validator8 = !(_formKey
//                                 .currentState?.fields['L10to350ImpD']
//                                 ?.validate() ??
//                                 false);
//                           });
//                         },
// // valueTransformer: (text) => num.tryParse(text),
//                         validator: (value) {
//                           if (((_dischargeAll || _discharge10_350))) {
//                             return FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                               FormBuilderValidators.numeric(),
//                               FormBuilderValidators.max(200),
//                             ])(value);
//                           }
// // If _dcSPD is true (field is disabled), return null to bypass the validation.
//                           return null;
//                         },
// // initialValue: '12',
//                         keyboardType: TextInputType.number,
//                         textInputAction: TextInputAction.next,
//                       ),
// //
// //
//
//                       FormBuilderTextField(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         name: 'N10to350ImpD',
//                         decoration: InputDecoration(
//                           labelText:
//                           'Impulse Discharge Current rating (Iimp)-Neutral (10/350µs)',
//
//                         ),
//                         enabled: (_dischargeAll || _discharge10_350),
//                         onChanged: (val) {
//                           setState(() {
//                             _validator7 = !(_formKey
//                                 .currentState?.fields['N10to350ImpD']
//                                 ?.validate() ??
//                                 false);
//                           });
//                         },
// // valueTransformer: (text) => num.tryParse(text),
//                         validator: (value) {
//                           if (((_dischargeAll || _discharge10_350))) {
//                             return FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                               FormBuilderValidators.numeric(),
//                               FormBuilderValidators.max(200),
//                             ])(value);
//                           }
// // If _dcSPD is true (field is disabled), return null to bypass the validation.
//                           return null;
//                         },
// // initialValue: '12',
//                         keyboardType: TextInputType.number,
//                         textInputAction: TextInputAction.next,
//                       ),
//
//                       SizedBox(height: 10),
//                       Text(
//                         'Other Ratings',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold, // Set the fontWeight to bold
//                         ),
//                       ),
//
//                       FormBuilderTextField(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         name: 'mcbRating',
//                         decoration: InputDecoration(
//                           labelText: 'Backup fuse/mcb rating (A)',
//
//                         ),
//                         onChanged: (val) {
//                           setState(() {
//                             _validator5 = !(_formKey.currentState?.fields['mcbRating']
//                                 ?.validate() ??
//                                 false);
//                           });
//                         },
// // valueTransformer: (text) => num.tryParse(text),
//                         validator: FormBuilderValidators.compose([
// //  FormBuilderValidators.required(),
//                           FormBuilderValidators.numeric(),
//                           FormBuilderValidators.max(200),
//                         ]),
// // initialValue: '12',
//                         keyboardType: TextInputType.number,
//                         textInputAction: TextInputAction.next,
//                       ),
//
//                       FormBuilderTextField(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         name: 'responseTime',
//                         decoration: InputDecoration(
//                           labelText: 'Response Time (nS)',
//
//                         ),
//                         onChanged: (val) {
//                           setState(() {
//                             _validator6 = !(_formKey
//                                 .currentState?.fields['responseTime']
//                                 ?.validate() ??
//                                 false);
//                           });
//                         },
// // valueTransformer: (text) => num.tryParse(text),
//                         validator: FormBuilderValidators.compose([
// // FormBuilderValidators.required(),
//                           FormBuilderValidators.numeric(),
//                           FormBuilderValidators.max(1000),
//                         ]),
// // initialValue: '12',
//                         keyboardType: TextInputType.number,
//                         textInputAction: TextInputAction.next,
//                       ),
//
//                       SizedBox(height: 10),
//                       Text(
//                         'SPD Time Details',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold, // Set the fontWeight to bold
//                         ),
//                       ),
//
// //SPD Date of Install
//                       FormBuilderDateTimePicker(
//                         name: 'installDt',
//                         decoration: InputDecoration(
//                           labelText: 'Date of Install',
//                         ),
//                         validator: FormBuilderValidators.required(),
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime(2000),
//                         lastDate: DateTime(2100),
//                         inputType: InputType.date,
//                       ),
//
// //SPD Date of Warrenty
//                       FormBuilderDateTimePicker(
//                         name: 'warrentyDt',
//                         decoration: InputDecoration(
//                           labelText: 'Date of Warrenty',
//                         ),
//                         validator: FormBuilderValidators.required(),
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime(2000),
//                         lastDate: DateTime(2100),
//                         inputType: InputType.date,
//                       ),
//
//                       SizedBox(height: 10),
//                       Text(
//                         'Notes',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold, // Set the fontWeight to bold
//                         ),
//                       ),
//
//                       Stack(
//                         alignment: Alignment.centerRight,
//                         children: [
//                           FormBuilderTextField(
//                             autovalidateMode: AutovalidateMode.always,
//                             name: 'Notes',
//                             decoration: const InputDecoration(
//                               labelText: 'Remarks',
//                             ),
//                             // Remove the required validator to make the field optional
//                             validator: (value) {
//                               if (value != null && value.length > 100) {
//                                 return 'Remarks cannot exceed 100 characters'; // Optional custom validation (e.g., max length)
//                               }
//                               return null;
//                             },
//                             onChanged: (value) => setState(() {
//                               // Handle any state updates if needed
//                             }),
//                           ),
//
//                           const SizedBox(),
//                         ],
//                       ),
//
//
//                       FormBuilderCheckbox(
//                         name: 'accept_terms',
//                         initialValue: false,
//                         onChanged: _onChanged,
//                         title: RichText(
//                           text: const TextSpan(
//                             children: [
//                               TextSpan(
//                                 text:
//                                 'I Verify that submitted details are true and correct ',
//                                 style: TextStyle(color: Colors.black),
//                               ),
//                             ],
//                           ),
//                         ),
//                         validator: FormBuilderValidators.equal(
//                           true,
//                           errorText: 'You must accept terms and conditions to continue',
//                         ),
//                       ),
//
//                       // 2 buttons in 1 row
//                       Row(
//                         children: <Widget>[
//                           Expanded(
//                             child: OutlinedButton(
//                               onPressed: () {
//                                 _formKey.currentState?.reset();
//                               },
//                               style: ButtonStyle(
//                                 foregroundColor:
//                                 MaterialStateProperty.all<Color>(Colors.green),
//                                 backgroundColor:
//                                 MaterialStateProperty.all<Color>(Colors.white24),
//                               ),
//                               child: Text(
//                                 'Reset',
//                                 style: TextStyle(
//                                   color: Theme.of(context).colorScheme.secondary,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 20),
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 if (_formKey.currentState?.saveAndValidate() ?? false) {
//                                   debugPrint(_formKey.currentState?.value.toString());
//                                   Map<String, dynamic>? formData =
//                                       _formKey.currentState?.value;
//                                   formData = formData
//                                       ?.map((key, value) => MapEntry(key, value ?? ''));
//
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => httpPostSPD(
//                                         formData: formData ?? {},
//                                         dcFlag: false,
//                                         userAccess: userAccess,
//                                       ),
//                                     ),
//                                   );
//                                 } else {
//                                   debugPrint(_formKey.currentState?.value.toString());
//                                   debugPrint('validation failed');
//                                 }
//                               },
//                               child: const Text(
//                                 'Submit',
//                                 style: TextStyle(color: Colors.blue),
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     ])))));
//   }
// }

//v1 working as of 25-12-24
//Gathering of Generator data though user forum

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';

//import '../../../UserAccess.dart';
import 'httpPostSPD.dart';

bool _showDTcapacity = true; // default value

class AddacSPD extends StatefulWidget {
  @override
  _AddacSPDState createState() => _AddacSPDState();
}

class _AddacSPDState extends State<AddacSPD> {
  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add AC SPD Info',
          style: TextStyle(color: customColors.mainTextColor),
        ),
        backgroundColor: customColors.appbarColor,
        iconTheme: IconThemeData(color: customColors.mainTextColor),

        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),
      body: Center(child: CompleteForm()),
    );
  }
}

class CompleteForm extends StatefulWidget {
  const CompleteForm({Key? key}) : super(key: key);

  @override
  State<CompleteForm> createState() {
    return _CompleteFormState();
  }
}

class _CompleteFormState extends State<CompleteForm> {
  String _status = '';
  String? selectedRTOM;
  String? selectedRegion;
  Map<String, dynamic> updatedValues = {};

  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _regionHasError = false;
  bool _eBrandHasError = false;
  bool _aBrandHasError = false;
  bool _spdUnitary = false;
  bool _validator1 = false;
  bool _3phase = false;
  bool _validator3 = false;
  bool _validator4 = false;
  bool _validator5 = false;
  bool _validator6 = false;
  bool _validator7 = false;
  bool _validator8 = false;
  bool _validator9 = false;
  bool _validator10 = false;
  bool _validator11 = false;
  bool _validator12 = false;
  bool _validator13 = false;
  bool _validator14 = false;
  bool _validator15 = false;
  bool _validator16 = false;

  double _sliderValue = 0.0;
  bool _burned = false;
  bool _dcSPD = false;
  bool _dischargeAll = false;
  bool _discharge10_350 = false;
  bool _dicharge8_20 = false;

  //string array
  Map<String, String> _selectedValues = {};

  var Regions = [
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
    'NWPW',
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
    'UVA',
    'Other',
  ];
  var SPDTypes = ['Type 1', 'Type1+2', 'Type 2', 'Type 3', 'Unknown', 'Other'];
  var SPDBrands = [
    'Citel',
    'Critec',
    'DEHN',
    'Erico',
    'OBO',
    'XW2',
    'Zone Guard',
    'Other',
  ];

  Map<String, List<String>> regionToDistricts = {
    "CPN": ['Kandy', 'Dambulla', 'Matale'],
    "CPS": [
      'Gampola',
      'Nuwaraeliya',
      'Haton',
      'Peradeniya',
      'Nawalapitiya',
      'Gampola',
    ],
    "EPN": ['Batticaloa'],
    'EPNTC': ['Trincomalee'],
    'EPS': ['Ampara', 'Kalmunai'],
    'HQ': ['Head Office'],
    'NCP': ['Anuradhapura', 'Polonnaruwa'],
    'NPN': ['Jaffna'],
    'NPS': ['MB', 'Vaunia', 'Mulativ', 'Kilinochchi'],
    'NWPE': ['Kurunagala', 'Kuliyapitiya'],
    'NWPW': ['Chilaw', 'Puttalam', 'Chilaw-01', 'Chilaw-02', 'Chilaw-03'],
    'PITI': ['Pitipana'],
    'SAB': ['Ratnapura', 'Kegalle'],
    'SPE': ['Matara', 'Hambantota'],
    'SPW': ['Galle', 'Ambalangoda'],
    'UVA': ['Bandarawela', 'Badulla', 'Monaragala'],
    'WEL': ['Welikada'],
    'WPC': ['Colombo Central', 'Havelock Town', 'Maradana'],
    'WPE': ['Kotte', 'Kolonnawa'],
    'WPN': ['Wattala', 'Negombo'],
    'WPNE': ['Kelaniya', 'Gampaha', 'Nittambuwa'],
    'WPS': ['Horana', 'Panadura'],
    'WPSE': ['Maharagama', 'Homagama', 'Awissawella'],
    'WPSW': ['Rathmalana', 'Nugegoda'],
  };

  String? _validateAtLeastOneInput(Map<String, dynamic> values) {
    final inLive =
        values['Nominal Discharge Current rating (In)-Live (8/20µs)'];
    final iimpLive =
        values['Impulse Discharge Current rating (Iimp)-Live (10/350µs)'];

    if (inLive != null || iimpLive != null) {
      return null; // At least one field is filled, validation passes.
    } else {
      return 'At least one of these fields is required.';
    }
  }

  List<String> years = List.generate(
    40,
    (index) => (DateTime.now().year - index).toString(),
  );

  void _onChanged(dynamic val) => debugPrint(val.toString());

  void _showCustomBrandDialog({
    required String key,
    required List<String?> brandList,
    required Map<String, dynamic> formData,
    required String formKey,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final TextEditingController customBrandController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: themeProvider.currentTheme.copyWith(
            dialogBackgroundColor: customColors.suqarBackgroundColor,
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(color: customColors.mainTextColor),
              hintStyle: TextStyle(
                color: customColors.mainTextColor.withOpacity(0.7),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: customColors.mainTextColor.withOpacity(0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
          child: AlertDialog(
            backgroundColor: customColors.suqarBackgroundColor,
            title: Text(
              "Add Custom Brand",
              style: TextStyle(color: customColors.mainTextColor),
            ),
            content: TextField(
              controller: customBrandController,
              style: TextStyle(color: customColors.mainTextColor),
              decoration: InputDecoration(
                hintText: "Enter your brand name",
                hintStyle: TextStyle(
                  color: customColors.mainTextColor.withOpacity(0.7),
                ),
              ),
              onChanged: (value) {
                // You can add validation or other logic here if needed
              },
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: customColors.mainTextColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  String customBrand = customBrandController.text.trim();
                  if (customBrand.isNotEmpty) {
                    setState(() {
                      // Remove if already exists (avoid duplicates)
                      brandList.remove(customBrand);
                      // Insert before "Other" if present, else add to end
                      int otherIndex = brandList.indexOf("Other");
                      if (otherIndex != -1) {
                        brandList.insert(otherIndex, customBrand);
                      } else {
                        brandList.add(customBrand);
                      }
                      formData[formKey] = customBrand; // Set as selected
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // UserAccess userAccess = Provider.of<UserAccess>(context, listen: true); // Use listen: true to rebuild the widget when the data changes
    // String? username = userAccess.username;
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: customColors.mainBackgroundColor,

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: _formKey,
                // enabled: false,
                onChanged: () {
                  _formKey.currentState!.save();
                  debugPrint(_formKey.currentState!.value.toString());
                },
                autovalidateMode: AutovalidateMode.disabled,

                skipDisabled: true,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 15),

                    //Region Select
                    FormBuilderDropdown<String>(
                      name: 'province',
                      initialValue:
                          Regions.contains(updatedValues["province"])
                              ? updatedValues["province"] as String?
                              : null, // Default value
                      style: TextStyle(color: customColors.mainTextColor),

                      decoration: InputDecoration(
                        labelText: 'Region',
                        suffix:
                            _regionHasError
                                ? const Icon(Icons.error)
                                : const Icon(Icons.check, color: Colors.green),
                        hintText: 'Select Region',
                      ),
                      dropdownColor:
                          customColors
                              .suqarBackgroundColor, // This sets the dropdown menu color

                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      items: [
                        ...Regions.where(
                          (String value) => value != "Other",
                        ).map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 12,
                                color: customColors.mainTextColor,
                              ),
                            ),
                          );
                        }).toList(),
                        DropdownMenuItem<String>(
                          value: "Other",
                          child: Text(
                            "Other",
                            style: TextStyle(
                              fontSize: 12,
                              color: customColors.mainTextColor,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        if (val == "Other") {
                          _showCustomBrandDialog(
                            key: "province",
                            brandList: Regions,
                            formData: updatedValues,
                            formKey: "province",
                          );
                        } else {
                          setState(() {
                            _selectedValues['province'] = val!;
                            selectedRegion = val;
                            selectedRTOM = null;
                            _regionHasError =
                                !(_formKey.currentState?.fields['province']
                                        ?.validate() ??
                                    false);
                            // Reset the 'Rtom_name' field value and clear validation errors
                            _formKey.currentState?.fields['Rtom_name']
                                ?.didChange(null);
                          });
                          //  print('Region: ' + _selectedValues['Region'].toString());
                        }
                      },
                      valueTransformer: (val) => val?.toString(),
                    ),

                    SizedBox(height: 10),

                  //RTOM Entering
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        FormBuilderTextField(
                          name: 'Rtom_name',
                          style: TextStyle(color: customColors.mainTextColor),
                          decoration: InputDecoration(labelText: 'RTOM'),
                          validator: FormBuilderValidators.required(),
                          onChanged:
                              (value) => setState(() {
                                _selectedValues['Rtom_name'] = value!;
                                //  print('RTOM: ' + _selectedValues['RTOM'].toString());
                              }),
                        ),
                        // Show tick mark if data is entered
                        _formKey.currentState?.fields['Rtom_name']?.value
                                    ?.toString()
                                    ?.isNotEmpty ??
                                false
                            ? Icon(Icons.check, color: Colors.green)
                            : SizedBox(),
                      ],
                    ),
                    SizedBox(height: 10),

                    //Station Text Field
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        FormBuilderTextField(
                          name: 'station',
                          style: TextStyle(color: customColors.mainTextColor),

                          // enabled: false,
                          decoration: InputDecoration(
                            labelText: 'Station (QR Code ID)',
                          ),
                          validator: FormBuilderValidators.required(),
                          onChanged: (value) => setState(() {}),
                        ),
                        // Show tick mark if data is entered
                        _formKey.currentState?.fields['station']?.value
                                    ?.toString()
                                    ?.isNotEmpty ??
                                false
                            ? Icon(Icons.check, color: Colors.green)
                            : SizedBox(),
                      ],
                    ),

                    SizedBox(height: 10),

                    //SPD Location that is to be typed
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        FormBuilderTextField(
                          name: 'SPDLoc',
                          style: TextStyle(color: customColors.mainTextColor),

                          decoration: InputDecoration(
                            labelText: 'SPD Location (DB Location)',
                          ),
                          validator: FormBuilderValidators.required(),
                          onChanged:
                              (value) => setState(() {
                                _selectedValues['SPDLoc'] = value!;
                                //  print('RTOM: ' + _selectedValues['RTOM'].toString());
                              }),
                        ),
                        // Show tick mark if data is entered
                        _formKey.currentState?.fields['SPDLoc']?.value
                                    ?.toString()
                                    ?.isNotEmpty ??
                                false
                            ? Icon(Icons.check, color: Colors.green)
                            : SizedBox(),
                      ],
                    ),

                    SizedBox(height: 10),

                    //SPD Phase
                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(labelText: 'Unit Type'),
                      name: 'modular',
                      initialValue: 'N/A',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: 'Modular', //this is 3 phase
                          child: Text('Modular'),
                          avatar: CircleAvatar(child: Text('')),
                        ),
                        FormBuilderChipOption(
                          value: 'Unitary', //this is 3 phase
                          child: Text('Unitary'),
                          avatar: CircleAvatar(child: Text('')),
                        ),
                      ],
                      onChanged: (val) {
                        _onChanged;
                        setState(() {
                          _spdUnitary =
                              val == 'Unitary'
                                  ? true
                                  : false; // Update the flag based on the selected value
                        });
                      },
                    ),

                    SizedBox(height: 10),

                    // SPD Type (DC/AC)
                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(labelText: 'SPD Type'),
                      name: 'poles',
                      initialValue: '',
                      enabled: !_spdUnitary,
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: '2',
                          child: Text('Two Pole'),
                          avatar: CircleAvatar(child: Text('')),
                        ),
                        FormBuilderChipOption(
                          value: '3',
                          child: Text('Three Pole'),
                          avatar: CircleAvatar(child: Text('')),
                        ),
                        FormBuilderChipOption(
                          value: '4',
                          child: Text('Four Pole'),
                          avatar: CircleAvatar(child: Text('')),
                        ),
                        FormBuilderChipOption(
                          value: '5',
                          child: Text('Five Pole'),
                          avatar: CircleAvatar(child: Text('')),
                        ),
                      ],
                      // onChanged: _onChanged,
                      onChanged: (val) {
                        _onChanged;
                        setState(() {
                          //_dcSPD = val=='DC'? false:true; // Update the flag based on the selected value
                        });
                      },
                    ),

                    SizedBox(height: 10),

                    //SPD Phase
                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(labelText: 'SPD Phase'),
                      name: 'phase',
                      initialValue: 'N/A',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: '1', //this is 3 phase
                          child: Text('Phase'),
                          avatar: CircleAvatar(child: Text('1')),
                        ),
                        FormBuilderChipOption(
                          value: '3', //this is 3 phase
                          child: Text('Phase'),
                          avatar: CircleAvatar(child: Text('3')),
                        ),
                      ],
                      onChanged: (val) {
                        _onChanged;
                        setState(() {
                          _3phase =
                              val == '1'
                                  ? false
                                  : true; // Update the flag based on the selected value
                        });
                      },
                    ),

                    SizedBox(height: 10),

                    //Alternator Brand
                    FormBuilderDropdown<String>(
                      name: 'SPDType',
                      style: TextStyle(color: customColors.mainTextColor),

                      initialValue:
                          SPDTypes.contains(updatedValues["SPDType"])
                              ? updatedValues["SPDType"] as String?
                              : null, // Default value
                      decoration: InputDecoration(
                        labelText: 'Select SPD Type',
                        suffix:
                            _aBrandHasError
                                ? const Icon(Icons.error)
                                : const Icon(Icons.check, color: Colors.green),
                        hintText: 'Select SPD Type',
                      ),
                      dropdownColor:
                          customColors
                              .suqarBackgroundColor, // This sets the dropdown menu color

                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),

                      items: [
                        ...SPDTypes.where(
                          (String value) => value != "Other",
                        ).map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 12,
                                color: customColors.mainTextColor,
                              ),
                            ),
                          );
                        }).toList(),
                        DropdownMenuItem<String>(
                          value: "Other",
                          child: Text(
                            "Other",
                            style: TextStyle(
                              fontSize: 12,
                              color: customColors.mainTextColor,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        if (val == "Other") {
                          _showCustomBrandDialog(
                            key: "SPDType", // Dialog key
                            brandList: SPDTypes,
                            formData: updatedValues,
                            formKey:
                                "SPDType", // Form field key in updatedValues
                          );
                        } else {
                          setState(() {
                            updatedValues['SPDType'] =
                                val; // Update the central map
                            _selectedValues['SPDType'] =
                                val!; // If you use this elsewhere
                            // selectedSPDType = val; // If you have a specific state variable
                            _aBrandHasError =
                                !(_formKey.currentState?.fields['SPDType']
                                        ?.validate() ??
                                    false);
                          });
                        }
                      },
                      valueTransformer: (val) => val?.toString(),
                    ),

                    SizedBox(height: 10),

                    //SPD Manufacturer
                    FormBuilderDropdown<String>(
                      name: 'SPD_Manu',
                      style: TextStyle(color: customColors.mainTextColor),
                      initialValue:
                          SPDBrands.contains(
                                updatedValues["SPD_Manu"],
                              ) // Use SPDBrands list
                              ? updatedValues["SPD_Manu"] as String?
                              : null, // Default value
                      decoration: InputDecoration(
                        labelText: 'SPD Manufacturer',
                        suffix:
                            _eBrandHasError
                                ? const Icon(Icons.error)
                                : const Icon(Icons.check, color: Colors.green),
                        hintText: 'Select SPD Model',
                      ),
                      dropdownColor: customColors.suqarBackgroundColor,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      items: [
                        ...SPDBrands.where(
                          (String value) => value != "Other",
                        ).map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle( // Added style for consistency
                                fontSize: 12,
                                color: customColors.mainTextColor,
                              ),
                            ),
                          );
                        }).toList(),
                        DropdownMenuItem<String>(
                          value: "Other",
                          child: Text(
                            "Other",
                            style: TextStyle(
                              fontSize: 12,
                              color: customColors.mainTextColor,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        if (val == "Other") {
                          _showCustomBrandDialog(
                            key: "SPD_Manu", // Dialog key
                            brandList: SPDBrands,
                            formData: updatedValues,
                            formKey: "SPD_Manu", // Form field key in updatedValues
                          );
                        } else {
                          setState(() {
                            updatedValues['SPD_Manu'] = val; // Update the central map
                            _selectedValues['SPD_Manu'] = val!; // If you use this elsewhere
                            // selectedSPDManufacturer = val; // If you have a specific state variable
                            _eBrandHasError =
                                !(_formKey.currentState?.fields['SPD_Manu']
                                        ?.validate() ??
                                    false);
                          });
                        }
                      },
                      valueTransformer: (val) => val?.toString(),
                    ),

                    SizedBox(height: 10),

                    //SPD Model Text Field
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        FormBuilderTextField(
                          name: 'model_SPD',
                          style: TextStyle(color: customColors.mainTextColor),
                          decoration: InputDecoration(labelText: 'SPD Model'),
                          //validator: FormBuilderValidators.required(),
                          onChanged: (value) => setState(() {}),
                        ),
                        // Show tick mark if data is entered
                        _formKey.currentState?.fields['model_SPD']?.value
                                    ?.toString()
                                    ?.isNotEmpty ??
                                false
                            ? Icon(Icons.check, color: Colors.green)
                            : SizedBox(),
                      ],
                    ),

                    SizedBox(height: 10),

                    //SPD Status
                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        labelText: 'SPD Status',
                      ),
                      name: 'status',
                      initialValue: '',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: 'Active',
                          avatar: CircleAvatar(child: Text('')),
                        ),
                        FormBuilderChipOption(
                          value: 'Burned',
                          avatar: CircleAvatar(child: Text('')),
                        ),
                      ],

                      // onChanged: _onChanged,
                      onChanged: (val) {
                        _onChanged;
                        setState(() {
                          _burned =
                              val == 'Burned'
                                  ? false
                                  : true; // Update the flag based on the selected value
                        });
                      },
                    ),

                    SizedBox(height: 10),

                    FormBuilderSlider(
                      name: 'PercentageR',
                      // validator: FormBuilderValidators.compose([
                      //   FormBuilderValidators.min(context, 6),
                      // ]),
                      onChanged: _onChanged,
                      min: 0.0,
                      max: 100.0,
                      initialValue: 0.0,
                      divisions: 10,
                      activeColor: Colors.red,
                      inactiveColor: Colors.pink[100],
                      enabled: _burned,
                      decoration: InputDecoration(
                        labelText: 'Percentage Level %  (Phase 1)',
                      ),
                    ),

                    SizedBox(height: 10),

                    FormBuilderSlider(
                      name: 'PercentageY',
                      // validator: FormBuilderValidators.compose([
                      //   FormBuilderValidators.min(context, 6),
                      // ]),
                      onChanged: _onChanged,
                      min: 0.0,
                      max: 100.0,
                      initialValue: 0.0,
                      divisions: 10,
                      activeColor: Colors.red,
                      inactiveColor: Colors.pink[100],
                      enabled: _burned && _3phase,
                      decoration: InputDecoration(
                        labelText: 'Percentage Level %  (Phase 2)',
                      ),
                    ),

                    SizedBox(height: 10),

                    FormBuilderSlider(
                      name: 'PercentageB',
                      // validator: FormBuilderValidators.compose([
                      //   FormBuilderValidators.min(context, 6),
                      // ]),
                      onChanged: _onChanged,
                      min: 0.0,
                      max: 100.0,
                      initialValue: 0.0,
                      divisions: 10,
                      activeColor: Colors.red,
                      inactiveColor: Colors.pink[100],
                      enabled: _burned && _3phase,
                      decoration: InputDecoration(
                        labelText: 'Percentage Level % (Phase 3)',
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Nominal Voltage (U_n)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold, // Set the fontWeight to bold
                      ),
                    ),
                    SizedBox(height: 10),

                    //SPD Nominal Voltage Text Field
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'nom_volt',
                      style: TextStyle(color: customColors.mainTextColor),
                      decoration: InputDecoration(
                        labelText: 'Nominal Voltage (V)',
                        suffixIcon:
                            _validator1
                                ? const Icon(Icons.error, color: Colors.red)
                                : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _validator1 =
                              !(_formKey.currentState?.fields['nom_volt']
                                      ?.validate() ??
                                  false);
                        });
                      },
                      // valueTransformer: (text) => num.tryParse(text),
                      validator: FormBuilderValidators.compose([
                        //FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.max(500),
                      ]),
                      // initialValue: '12',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),

                    SizedBox(height: 10),
                    Text(
                      'Maximum continuous operating voltage (Uc) -Live',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold, // Set the fontWeight to bold
                      ),
                    ),

                    SizedBox(height: 10),

                    //SPD Status
                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        labelText: 'Uc Live to neutral or Live to earth',
                      ),
                      name: 'UcLiveMode',
                      initialValue: '',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: 'L-N',
                          avatar: CircleAvatar(child: Text('')),
                        ),
                        FormBuilderChipOption(
                          value: 'L-E',
                          avatar: CircleAvatar(child: Text('')),
                        ),
                      ],

                      // onChanged: _onChanged,
                    ),
                    SizedBox(height: 10),
                    //SPD Voltage Protection Level
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'UcLiveVolt',
                      style: TextStyle(color: customColors.mainTextColor),
                      decoration: InputDecoration(
                        labelText: 'Uc (Live) in Volt',
                        suffixIcon:
                            _validator15
                                ? const Icon(Icons.error, color: Colors.red)
                                : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _validator15 =
                              !(_formKey.currentState?.fields['UcLiveVolt']
                                      ?.validate() ??
                                  false);
                        });
                      },
                      // valueTransformer: (text) => num.tryParse(text),
                      validator: FormBuilderValidators.compose([
                        //  FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.max(500),
                      ]),
                      // initialValue: '12',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),

                    SizedBox(height: 10),
                    Text(
                      'Maximum continuous operating voltage (Uc)- Neutral',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold, // Set the fontWeight to bold
                      ),
                    ),
                    SizedBox(height: 10),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      name: 'UcNeutralVolt',
                      style: TextStyle(color: customColors.mainTextColor),
                      decoration: InputDecoration(
                        labelText: 'Uc (Neutral) in Volt',
                        suffixIcon:
                            _validator14
                                ? const Icon(Icons.error, color: Colors.red)
                                : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _validator14 =
                              !(_formKey.currentState?.fields['UcNeutralVolt']
                                      ?.validate() ??
                                  false);
                        });
                      },
                      // valueTransformer: (text) => num.tryParse(text),
                      validator: FormBuilderValidators.compose([
                        //   FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.max(500),
                      ]),
                      // initialValue: '12',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),

                    SizedBox(height: 10),
                    Text(
                      'Voltage Protection Level (Up)- Live',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold, // Set the fontWeight to bold
                      ),
                    ),

                    SizedBox(height: 10),

                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'UpLiveVolt',
                      style: TextStyle(color: customColors.mainTextColor),
                      decoration: InputDecoration(
                        labelText: 'Up (Live) in Volt',
                        suffixIcon:
                            _validator13
                                ? const Icon(Icons.error, color: Colors.red)
                                : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _validator13 =
                              !(_formKey.currentState?.fields['UpNeutralVolt']
                                      ?.validate() ??
                                  false);
                        });
                      },

                      // valueTransformer: (text) => num.tryParse(text),
                      validator: (value) {
                        if (_dcSPD) {
                          return FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.max(5000),
                          ])(value);
                        }
                        // If _dcSPD is true (field is disabled), return null to bypass the validation.
                        return null;
                      },
                      // initialValue: '12',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),

                    SizedBox(height: 10),
                    Text(
                      'Voltage Protection Level- Neutral',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold, // Set the fontWeight to bold
                      ),
                    ),

                    SizedBox(height: 10),

                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'UpNeutralVolt',
                      style: TextStyle(color: customColors.mainTextColor),
                      decoration: InputDecoration(
                        labelText: 'Up (Neutral) in Volt',
                        suffixIcon:
                            _validator12
                                ? const Icon(Icons.error, color: Colors.red)
                                : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _validator12 =
                              !(_formKey.currentState?.fields['UpNeutralVolt']
                                      ?.validate() ??
                                  false);
                        });
                      },
                      // valueTransformer: (text) => num.tryParse(text),
                      validator: (value) {
                        if (_dcSPD) {
                          return FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.max(5000),
                          ])(value);
                        }
                        // If _dcSPD is true (field is disabled), return null to bypass the validation.
                        return null;
                      },
                      // initialValue: '12',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),

                    SizedBox(height: 10),
                    Text(
                      'Discharge Current',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold, // Set the fontWeight to bold
                      ),
                    ),

                    SizedBox(height: 10),

                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        labelText: 'Discharge Current Rating Types Available',
                      ),
                      name: 'dischargeType',
                      initialValue: '',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: '8/20us+10/350us',
                          avatar: CircleAvatar(child: Text('')),
                        ),
                        FormBuilderChipOption(
                          value: '8/20us',
                          avatar: CircleAvatar(child: Text('')),
                        ),
                        FormBuilderChipOption(
                          value: '10/350us',
                          avatar: CircleAvatar(child: Text('')),
                        ),
                      ],

                      // onChanged: _onChanged,
                      onChanged: (val) {
                        _onChanged;
                        setState(() {
                          _dischargeAll =
                              val == '8/20us+10/350us' ? true : false;
                          _dicharge8_20 = val == '8/20us' ? true : false;
                          _discharge10_350 = val == '10/350us' ? true : false;
                        });
                      },
                    ),
                    SizedBox(height: 10),

                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'L8to20NomD',
                      style: TextStyle(color: customColors.mainTextColor),

                      decoration: InputDecoration(
                        labelText:
                            'Nominal Discharge Current rating (In)-Live (8/20µs) (kA)',
                        suffixIcon:
                            _validator11
                                ? const Icon(Icons.error, color: Colors.red)
                                : const Icon(Icons.check, color: Colors.green),
                      ),
                      enabled: (_dischargeAll || _dicharge8_20),
                      onChanged: (val) {
                        setState(() {
                          _validator11 =
                              !(_formKey.currentState?.fields['L8to20NomD']
                                      ?.validate() ??
                                  false);
                        });
                      },
                      // valueTransformer: (text) => num.tryParse(text),
                      validator: (value) {
                        if (((_dischargeAll || _dicharge8_20))) {
                          return FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.max(100),
                          ])(value);
                        }
                        // If _dcSPD is true (field is disabled), return null to bypass the validation.
                        return null;
                      },
                      // initialValue: '12',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 10),

                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'N8to20NomD',
                      style: TextStyle(color: customColors.mainTextColor),

                      decoration: InputDecoration(
                        labelText:
                            'Nominal Discharge Current rating (In)-Neutral (8/20µs) (kA)',
                        suffixIcon:
                            _validator10
                                ? const Icon(Icons.error, color: Colors.red)
                                : const Icon(Icons.check, color: Colors.green),
                      ),
                      enabled: (_dischargeAll || _dicharge8_20),
                      onChanged: (val) {
                        setState(() {
                          _validator10 =
                              !(_formKey.currentState?.fields['N8to20NomD']
                                      ?.validate() ??
                                  false);
                        });
                      },
                      // valueTransformer: (text) => num.tryParse(text),
                      validator: (value) {
                        if (((_dischargeAll || _dicharge8_20))) {
                          return FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.max(100),
                          ])(value);
                        }
                        // If _dcSPD is true (field is disabled), return null to bypass the validation.
                        return null;
                      },
                      // initialValue: '12',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 10),

                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'L10to350ImpD',
                      style: TextStyle(color: customColors.mainTextColor),

                      decoration: InputDecoration(
                        labelText:
                            'Impulse Discharge Current rating (Iimp)-Live (10/350µs) (kA)',
                        suffixIcon:
                            _validator8
                                ? const Icon(Icons.error, color: Colors.red)
                                : const Icon(Icons.check, color: Colors.green),
                      ),
                      enabled: (_dischargeAll || _discharge10_350),
                      onChanged: (val) {
                        setState(() {
                          _validator8 =
                              !(_formKey.currentState?.fields['L10to350ImpD']
                                      ?.validate() ??
                                  false);
                        });
                      },
                      // valueTransformer: (text) => num.tryParse(text),
                      validator: (value) {
                        if (((_dischargeAll || _discharge10_350))) {
                          return FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.max(200),
                          ])(value);
                        }
                        // If _dcSPD is true (field is disabled), return null to bypass the validation.
                        return null;
                      },
                      // initialValue: '12',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),

                    SizedBox(height: 10),

                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'N10to350ImpD',
                      style: TextStyle(color: customColors.mainTextColor),

                      decoration: InputDecoration(
                        labelText:
                            'Impulse Discharge Current rating (Iimp)-Neutral (10/350µs)',
                        suffixIcon:
                            _validator7
                                ? const Icon(Icons.error, color: Colors.red)
                                : const Icon(Icons.check, color: Colors.green),
                      ),
                      enabled: (_dischargeAll || _discharge10_350),
                      onChanged: (val) {
                        setState(() {
                          _validator7 =
                              !(_formKey.currentState?.fields['N10to350ImpD']
                                      ?.validate() ??
                                  false);
                        });
                      },
                      // valueTransformer: (text) => num.tryParse(text),
                      validator: (value) {
                        if (((_dischargeAll || _discharge10_350))) {
                          return FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.max(200),
                          ])(value);
                        }
                        // If _dcSPD is true (field is disabled), return null to bypass the validation.
                        return null;
                      },
                      // initialValue: '12',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),

                    SizedBox(height: 10),
                    Text(
                      'Other Ratings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold, // Set the fontWeight to bold
                      ),
                    ),
                    SizedBox(height: 10),

                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'mcbRating',
                      style: TextStyle(color: customColors.mainTextColor),
                      decoration: InputDecoration(
                        labelText: 'Backup fuse/mcb rating (A)',
                        suffixIcon:
                            _validator5
                                ? const Icon(Icons.error, color: Colors.red)
                                : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _validator5 =
                              !(_formKey.currentState?.fields['mcbRating']
                                      ?.validate() ??
                                  false);
                        });
                      },
                      // valueTransformer: (text) => num.tryParse(text),
                      validator: FormBuilderValidators.compose([
                        //  FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.max(200),
                      ]),
                      // initialValue: '12',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 10),

                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'responseTime',
                      style: TextStyle(color: customColors.mainTextColor),
                      decoration: InputDecoration(
                        labelText: 'Response Time (nS)',
                        suffixIcon:
                            _validator6
                                ? const Icon(Icons.error, color: Colors.red)
                                : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _validator6 =
                              !(_formKey.currentState?.fields['responseTime']
                                      ?.validate() ??
                                  false);
                        });
                      },
                      // valueTransformer: (text) => num.tryParse(text),
                      validator: FormBuilderValidators.compose([
                        // FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.max(1000),
                      ]),
                      // initialValue: '12',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),

                    SizedBox(height: 10),
                    Text(
                      'SPD Time Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold, // Set the fontWeight to bold
                      ),
                    ),

                    SizedBox(height: 10),

                    //SPD Date of Install
                    FormBuilderDateTimePicker(
                      name: 'installDt',
                      style: TextStyle(color: customColors.mainTextColor),
                      decoration: InputDecoration(labelText: 'Date of Install'),
                      validator: FormBuilderValidators.required(),
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      inputType: InputType.date,
                    ),

                    SizedBox(height: 10),

                    //SPD Date of Warrenty
                    FormBuilderDateTimePicker(
                      name: 'warrentyDt',
                      style: TextStyle(color: customColors.mainTextColor),
                      decoration: InputDecoration(
                        labelText: 'Date of Warrenty',
                      ),
                      validator: FormBuilderValidators.required(),
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      inputType: InputType.date,
                    ),

                    SizedBox(height: 10),
                    Text(
                      'Notes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold, // Set the fontWeight to bold
                      ),
                    ),

                    SizedBox(height: 10),

                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        FormBuilderTextField(
                          name: 'Notes',
                          style: TextStyle(color: customColors.mainTextColor),
                          decoration: InputDecoration(labelText: 'Remarks'),
                          validator: FormBuilderValidators.required(),
                          onChanged:
                              (value) => setState(() {
                                //  print('RTOM: ' + _selectedValues['RTOM'].toString());
                              }),
                        ),
                        // Show tick mark if data is entered
                        _formKey.currentState?.fields['Notes']?.value
                                    ?.toString()
                                    ?.isNotEmpty ??
                                false
                            ? Icon(Icons.check, color: Colors.green)
                            : SizedBox(),
                      ],
                    ),

                    FormBuilderCheckbox(
                      name: 'accept_terms',
                      initialValue: false,
                      onChanged: _onChanged,
                      title: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'I Verify that submitted details are true and correct ',
                              style: TextStyle(
                                color: customColors.mainTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      validator: FormBuilderValidators.equal(
                        true,
                        errorText:
                            'You must accept terms and conditions to continue',
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _formKey.currentState?.reset();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.blue,
                        ), // Set the button color here
                      ),
                      child: const Text(
                        'Reset',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          debugPrint(_formKey.currentState?.value.toString());
                          Map<String, dynamic>? formData =
                              _formKey.currentState?.value;
                          formData = formData?.map(
                            (key, value) => MapEntry(key, value ?? ''),
                          );

                          // String rtom = _formKey.currentState?.value['Rtom_name'];
                          // debugPrint('RTOM value: $rtom');
                          //pass _formkey.currenState.value to a page called httpPostGen

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => httpPostSPD(formData: formData??{}, dcFlag: false,userAccess: userAccess,)),
                          // );
                        } else {
                          debugPrint(_formKey.currentState?.value.toString());
                          debugPrint('validation failed');
                        }
                      },

                      style: buttonStyle(),
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

ButtonStyle buttonStyle() {
  return ElevatedButton.styleFrom();
}
