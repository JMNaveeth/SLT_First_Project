
import 'package:flutter/material.dart';
// import 'package:flutter_application_1/widgets/UserAccess.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/utils/utils/colors.dart';

import '../../../Widgets/GPSGrab/gps_location_widget.dart';
import '../../../Widgets/ThemeToggle/theme_provider.dart';
import '../../HomePage/utils/colors.dart';
import '../../../Widgets/ThemeAdaptiveDropDown/ThemeAdaptiveDropDownWidget.dart';


class GeneratorDetailAddPage  extends StatefulWidget {



  GeneratorDetailAddPage({Key? key}) : super(key: key);


  @override
  _GeneratorDetailAddPageState createState() => _GeneratorDetailAddPageState();

}

class _GeneratorDetailAddPageState extends State<GeneratorDetailAddPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  String updator="";
  //late Map<String, dynamic> originalValues;
  Map<String, dynamic> updatedValues = {};
  bool _isLoading = false;
  bool _isManual = false;
  bool _isAuto = false;

  String _latitude = '';
  String _longitude = '';
  String _error = '';
  bool isControllerModelEnabled = true;
  bool isAtsFieldsEnabled = true;
  bool isDayTankSizeEnabled = true;
  bool _areFieldsDisabled = false;


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
    'Other'
  ];

  List<String> brandeng = ['Caterpillar', 'Chana', 'Cummins', 'Deutz', 'Detroit', 'Denyo', 'Greaves', 'Honda', 'Hyundai', 'Isuzu', 'John Deere', 'Komatsu', 'Kohler', 'Kubota', 'Lester', 'Mitsubishi', 'Onan', 'Perkins', 'Rusten', 'Unknown', 'Valmet', 'Volvo', 'Yanmar','Other'];
  List<String> contBrand = ['DSE', 'HMI', 'Unknown','Other'];
  List<String> brandset = ['Caterpillar', 'Cummins', 'Dale', 'Denyo', 'F.G.Wilson', 'Foracity', 'Greaves', 'John Deere', 'Jubilee', 'Kohler', 'Mitsui - Deutz', 'Mosa', 'Olympian', 'Onan', 'Pramac', 'Sanyo Denki', 'Siemens', 'Tempest', 'Unknown', 'Wega', 'Welland Power','Other'];
  List<String> brandAlt=['Alsthom', 'Aulturdyne', 'Bosch', 'Caterpillar', 'Denyo', 'Greaves', 'Iskra', 'Kohler', 'Leroy Somer', 'Marelli', 'Mecc Alte', 'Mitsubishi', 'Perkins', 'Sanyo Denki', 'Siemens', 'Stamford', 'Taiyo', 'Tempest', 'Unknown', 'Wega','Other'];
  List<String> brandAts=['Schnider', 'Cummins', 'Socomec','Unknown','Other'];
  List<String> batBrand=['Amaron', 'Exide', 'Luminous','Volta','Okaya','LivGuard','Su-Kam','Shield','Other'];


  void _fetchLocation() async {
    setState(() {
      _isLoading = true;
      _error = ''; // Reset error message when starting to fetch location
    });

    // try {
    //   GPSLocationFetcher locationFetcher = GPSLocationFetcher();
    //   Map<String, String> location = await locationFetcher.fetchLocation();

    //   // Debug print to check the location map
    //   debugPrint("Fetched location data: $location");

    //   if (location.containsKey('latitude') && location.containsKey('longitude')) {
    //     setState(() {
    //       _latitude = location['latitude'] ?? '';
    //       _longitude = location['longitude'] ?? '';
    //       updatedValues['Latitude'] = _latitude; // Ensure you use 'Latitude' if it needs to be uppercase
    //       updatedValues['Longitude'] = _longitude; // Ensure you use 'Longitude' if it needs to be uppercase
    //       _isLoading = false;
    //       debugPrint("Location $_latitude, $_longitude");
    //     });
    //   } else {
    //     throw Exception('Location data is missing');
    //   }
    // } catch (e) {
    //   setState(() {
    //     _error = e.toString();
    //     debugPrint("Error: $_error");
    //     _isLoading = false;
    //   });
    // }
  }



  @override
  void initState() {
    super.initState();

    updatedValues.addAll({"clockTime": ""});
  }

  void _onChanged(
      dynamic val, Map<String, dynamic> formData, String fieldName) {
    setState(() {
      formData[fieldName] = val;

      //updatedValues[fieldName] = val;
    });
  }

  // void _selectDate(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     //initialDate: _selectedDate ?? DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //
  //   if (pickedDate != null && pickedDate != _selectedDate) {
  //     setState(() {
  //       _selectedDate = pickedDate;
  //       _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
  //       updatedValues['Installed Date'] =
  //           DateFormat('yyyy-MM-dd').format(pickedDate);
  //     });
  //   }
  // }

  // void _showCustomBrandDialog({
  //   required String key,
  //   required List<String?> brandList,
  //   required Map<String, dynamic> formData,
  //   required String formKey, // A unique key for the form
  // }) {
  //   TextEditingController customBrandController = TextEditingController();
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Theme(
  //         data: ThemeData.light().copyWith(
  //           colorScheme: const ColorScheme.light(primary: Colors.green),
  //         ),
  //         child: AlertDialog(
  //           title: const Text("Add Custom Brand"),
  //           content: TextField(
  //             controller: customBrandController,
  //             decoration: const InputDecoration(
  //               hintText: "Enter your brand name",
  //             ),
  //           ),
  //           actions: <Widget>[
  //             TextButton(
  //               child: const Text("Cancel"),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             TextButton(
  //               child: const Text("OK"),
  //               onPressed: () {
  //                 String customBrand = customBrandController.text.trim();
  //                 if (customBrand.isNotEmpty) {
  //                   setState(() {
  //                     if (!brandList.contains(customBrand)) {
  //                       brandList.add(customBrand);
  //                     }
  //                     formData[formKey] = customBrand;
  //                   });
  //                 }
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
  // Method to show a custom brand dialog that adapts to the current theme
  void _showCustomBrandDialog({
    required String key,
    required List<String?> brandList,
    required Map<String, dynamic> formData,
    required String formKey,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final customColors = Theme.of(context).extension<CustomColors>()!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: themeProvider.currentTheme.copyWith(
            dialogBackgroundColor: customColors.suqarBackgroundColor,
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(color: customColors.mainTextColor),
              hintStyle: TextStyle(color: customColors.mainTextColor.withOpacity(0.7)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: customColors.mainTextColor.withOpacity(0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
          child: AlertDialog(
            title: Text(
              "Add Custom Brand",
              style: TextStyle(color: customColors.mainTextColor),
            ),
            content: TextField(
              style: TextStyle(color: customColors.mainTextColor),
              decoration: InputDecoration(
                hintText: "Enter your brand name",
                hintStyle: TextStyle(color: customColors.mainTextColor.withOpacity(0.7)),
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
                child: Text(
                  "OK",
                  style: TextStyle(color: customColors.mainTextColor),
                ),
                onPressed: () {
                  // Existing logic for adding custom brand
                  // ...
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
    //  UserAccess userAccess = Provider.of<UserAccess>(context, listen: true); // Use listen: true to rebuild the widget when the data changes
    //  updator=userAccess.username!;
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: customColors.mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: customColors.appbarColor,
        title: Center(child: Text('Add DEG Details',style: TextStyle(              color: customColors.mainTextColor , fontSize: 20),)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 8.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Location",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: mainTextColor),
                ),
              ),

              //Province
              Card(
                color: customColors.suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Province :",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: mainTextColor,
                        ),
                      ),
                      SizedBox(width:10,),// Add some space between the label and the dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: Regions.contains(updatedValues["Province"])
                              ? updatedValues["Province"]
                              : null, // Default value


                          items: [
                            ...Regions.where((String value) => value != "Other").map((String value) {
                              return DropdownMenuItem<String>(

                                value: value,
                                child: Text(value,style: const TextStyle(fontSize: 12, color: mainTextColor),),

                              );
                            }).toList(),
                            const DropdownMenuItem<String>(
                              value: "Other",
                              child: Text("Other",style: const TextStyle(fontSize: 12, color: mainTextColor),),
                            ),
                          ],
                          onChanged: (val) {
                            if (val == "Other") {
                              _showCustomBrandDialog(
                                key: "Province",
                                brandList: Regions,
                                formData: updatedValues,
                                formKey: "Province",
                              );
                            } else {
                              _onChanged(val, updatedValues, "Province");
                            }
                          },
                          validator: FormBuilderValidators.compose([
                            // Uncomment or add validators as needed
                            // FormBuilderValidators.required(),
                          ]),
                         // customColors.suqarBackgroundColor,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF252525),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //Rtom
              CustomTextField(
                textTitle: "Rtom Name :",
                isWantEdit: true,
                onChanged: (val) => _onChanged(val, updatedValues, "Rtom Name"),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                keyboardType: TextInputType.name,
              ),
              //Station
              CustomTextField(
                textTitle: "Station :",
                isWantEdit: true,
                onChanged: (val) => _onChanged(val, updatedValues, "Station"),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                keyboardType: TextInputType.name,
              ),
              // GPS Location Card
              Card(
                color: suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text(
                        "Location Set As :",
                        style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 12,color: mainTextColor,),
                      ),
                      SizedBox(width:10,),
                      Row(
                        children: [
                          Checkbox(
                            value: _isManual,
                            onChanged: (bool? value) {
                              setState(() {
                                _isManual = value!;
                                if (value == true) _isAuto = false;
                                if (_isAuto) _fetchLocation(); // Fetch location only if auto is true
                              });
                            },
                          ),
                          const Text("Manual",style: TextStyle(fontSize: 12,color: mainTextColor,),),
                        ],
                      ),

                      Row(
                        children: [
                          Checkbox(
                            value: _isAuto,
                            onChanged: (bool? value) {
                              setState(() {
                                _isAuto = value!;
                                if (value == true) _isManual = false;
                                if (_isAuto) _fetchLocation(); // Fetch location only if auto is true
                              });
                            },
                          ),
                          const Text("Auto",style: TextStyle(fontSize: 12,color: mainTextColor,),),
                        ],
                      ),

                    ],
                  ),
                ),
              ),

// Display Location or Manual Entry
              _isManual
                  ? Column(
                children: [
                  CustomTextField(
                    textTitle: "Latitude",
                    isWantEdit: true,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      _onChanged(val, updatedValues, "Latitude");
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric()
                    ]),
                  ),
                  CustomTextField(
                    textTitle: "Longitude",
                    isWantEdit: true,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      _onChanged(val, updatedValues, "Longitude");
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric()
                    ]),
                  ),
                ],
              )
                  : Card(
                color: suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const Text(
                        "Location :",
                        style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 12,color: mainTextColor,),
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Text("Latitude : ${updatedValues['Latitude'] ?? 'N/A'}",style: TextStyle(fontSize: 12,color: mainTextColor,)),
                          Text("Longitude : ${updatedValues['Longitude'] ?? 'N/A'}",style: TextStyle(fontSize: 12,color: mainTextColor,)),
                        ],
                      ),
                      SizedBox(width:30,),

                      if (_isLoading)
                        const CircularProgressIndicator(), // Show progress indicator when loading
                      if (_error.isNotEmpty)
                        Text(
                          "Error turn on location",
                          style: const TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),
              ),

              const Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
                child: Text(
                  "Genaral Details",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: mainTextColor),
                ),
              ),

              //Available
              Card(
                color: suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const Text(
                        "DEG Available :",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: mainTextColor,
                        ),
                      ),
                      SizedBox(width: 10,),
                      Spacer(),
                      Expanded(
                        child: FormBuilderChoiceChips<String>(
                          backgroundColor: Color(0xFF252525),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          name: 'Available',
                          initialValue: updatedValues['Available'],
                          selectedColor: Colors.lightBlueAccent,
                          options: const [
                            FormBuilderChipOption(
                              value: 'Yes',
                              avatar: CircleAvatar(child: Text('')),
                              child: Text(
                                'Yes',
                                style: const TextStyle(
                                  fontSize: 12, // Adjust text size
                                  color: mainTextColor, // Adjust text color
                                ),
                              ),

                            ),
                            FormBuilderChipOption(
                              value: 'No',
                              avatar: CircleAvatar(child: Text('')),
                              child: Text(
                                'No',
                                style: const TextStyle(
                                  fontSize: 12, // Adjust text size
                                  color: mainTextColor, // Adjust text color
                                ),
                              ),
                            ),
                          ],
                          onChanged: (val) {
                            setState(() {
                              _onChanged(val, updatedValues, 'Available');
                              _areFieldsDisabled = val == 'No'; // Disable fields if 'No' is selected
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //Category
              Card(
                color: suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const Text(
                        "DEG Category :",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12, color: mainTextColor),
                      ),
                      const Spacer(),
                      Expanded(
                        child: FormBuilderChoiceChips<String>(
                          backgroundColor:Color(0xFF252525),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          //decoration: const InputDecoration(labelText: 'Type'),
                          name: 'Category',
                          initialValue: updatedValues['Category'],
                          selectedColor: Colors.lightBlueAccent,
                          options: const [
                            FormBuilderChipOption(
                              value: 'Fixed',
                              avatar: CircleAvatar(child: Text('')),
                              child: Text(
                                'Fixed',
                                style: const TextStyle(
                                  fontSize: 12, // Adjust text size
                                  color: mainTextColor, // Adjust text color
                                ),
                              ),

                            ),
                            FormBuilderChipOption(
                              value: 'Mobile',
                              avatar: CircleAvatar(child: Text('')),
                              child: Text(
                                'Mobile',
                                style: const TextStyle(
                                  fontSize: 12, // Adjust text size
                                  color:mainTextColor, // Adjust text color
                                ),
                              ),

                            ),
                            FormBuilderChipOption(
                              value: 'Portable',
                              avatar: CircleAvatar(child: Text('')),
                              child: Text(
                                'Portable',
                                style: const TextStyle(
                                  fontSize: 12, // Adjust text size
                                  color: mainTextColor, // Adjust text color
                                ),
                              ),
                            ),
                          ],
                          // onChanged: _onChanged,

                          onChanged: _areFieldsDisabled ? null : (val) { // Disable onChanged if fields are disabled
                            setState(() {
                              _onChanged(val, updatedValues, 'Category');
                              print(updatedValues['Category']);
                            });
                          },
                          enabled: !_areFieldsDisabled,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //Mode
              Card(
                color: suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const Text(
                        "Mode :",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12, color: mainTextColor),
                      ),
                      const Spacer(),
                      Expanded(
                        child: FormBuilderChoiceChips<String>(
                          backgroundColor: Color(0xFF252525),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          //decoration: const InputDecoration(labelText: 'Type'),
                          name: 'Mode',
                          initialValue: updatedValues['Mode'],
                          selectedColor: Colors.lightBlueAccent,
                          options: const [
                            FormBuilderChipOption(
                              value: 'A',
                              child: Text('Auto',style: TextStyle(color: mainTextColor,fontSize: 12),),
                              // avatar: CircleAvatar(child: Text('')),
                            ),
                            FormBuilderChipOption(
                              value: 'M',
                              child: Text('Manual',style: TextStyle(color: mainTextColor,fontSize: 12)),
                              //avatar: CircleAvatar(child: Text('')),
                            ),
                          ],
                          // onChanged: _onChanged,

                          onChanged: _areFieldsDisabled ? null : (val) { // Disable onChanged if fields are disabled
                            setState(() {
                              _onChanged(val, updatedValues, 'Mode');
                              print(updatedValues['Mode']);
                            });
                          },
                          enabled: !_areFieldsDisabled,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //Phase
              Card(
                color: suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const Text(
                        "Phase Eng :",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12, color: mainTextColor),
                      ),
                      const Spacer(),
                      Expanded(
                        child: FormBuilderChoiceChips<String>(
                          backgroundColor: Color(0xFF252525),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          //decoration: const InputDecoration(labelText: 'Type'),
                          name: 'Phase Eng',
                          initialValue: updatedValues['Phase Eng'],
                          selectedColor: Colors.lightBlueAccent,
                          options: const [
                            FormBuilderChipOption(
                              value: '1',
                              avatar: CircleAvatar(child: Text('')),
                              child: Text(
                                '1',
                                style: const TextStyle(
                                  fontSize: 12, // Adjust text size
                                  color: mainTextColor, // Adjust text color
                                ),
                              ),
                            ),
                            FormBuilderChipOption(
                              value: '3',
                              avatar: CircleAvatar(child: Text('')),
                              child: Text(
                                '3',
                                style: const TextStyle(
                                  fontSize: 12, // Adjust text size
                                  color: mainTextColor, // Adjust text color
                                ),
                              ),
                            ),
                          ],
                          // onChanged: _onChanged,

                          onChanged: _areFieldsDisabled ? null : (val) { // Disable onChanged if fields are disabled
                            setState(() {
                              _onChanged(val, updatedValues, 'Phase Eng');
                              print(updatedValues['Phase Eng']);
                            });
                          },
                          enabled: !_areFieldsDisabled,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //YOM
              CustomTextField(
                textTitle: "Year of Manufacture :",
                isWantEdit: !_areFieldsDisabled,
                onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Year of Manufacture"),
                validator: (value) {
                  if (_areFieldsDisabled) {
                    return null; // Disable validation when fields are disabled
                  }

                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }

                  // Check if the input is a valid number
                  final number = int.tryParse(value);
                  if (number == null) {
                    return 'Please enter a\n valid number';
                  }

                  // Check if the number is within the specified range
                  if (number < 1900 || number > 3000) {
                    return 'Please enter a number\n between 1900 and 3000';
                  }

                  // Check if the input length is exactly 4 digits
                  if (value.length != 4) {
                    return 'Please enter exactly\n 4 digits';
                  }

                  return null; // Valid input
                },
                keyboardType: TextInputType.number,
              ),
              //YOI
              CustomTextField(
                textTitle: "Year of Install :",
                isWantEdit: !_areFieldsDisabled,
                onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Year of Install"),
                validator: (value) {
                  if (_areFieldsDisabled) {
                    return null; // Disable validation when fields are disabled
                  }

                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }

                  // Check if the input is a valid number
                  final number = int.tryParse(value);
                  if (number == null) {
                    return 'Please enter a\n valid number';
                  }

                  // Check if the number is within the specified range
                  if (number < 1900 || number > 3000) {
                    return 'Please enter a number\n between 1900 and 3000';
                  }

                  // Check if the input length is exactly 4 digits
                  if (value.length != 4) {
                    return 'Please enter exactly\n 4 digits';
                  }

                  return null; // Valid input
                },
                keyboardType: TextInputType.number,
              ),
              //Set Capacity
              CustomTextField(
                textTitle: "Set Capacity(kVA) :",
                isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
                onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Set Cap"),
                validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                keyboardType: TextInputType.number,

              ),

              const Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
                child: Text(
                  "Generator Specifications",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: mainTextColor),
                ),
              ),

              //Brand Alt
              Card(
                color: suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Alternator Brand :",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: mainTextColor,
                        ),
                      ),
                      const SizedBox(width: 10), // Add some space between the label and the dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: brandAlt.contains(updatedValues["Brand Alt"])
                              ? updatedValues["Brand Alt"]
                              : null, // Default value
                          items: [
                            ...brandAlt.where((String value) => value != "Other").map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(fontSize: 12, color: mainTextColor),),
                              );
                            }).toList(),
                            const DropdownMenuItem<String>(
                              value: "Other",
                              child: Text("Other",style: const TextStyle(fontSize: 12, color: mainTextColor),),
                            ),
                          ],
                          onChanged: _areFieldsDisabled ? null : (val) {
                            if (val == "Other") {
                              _showCustomBrandDialog(
                                key: "Brand Alt",
                                brandList: brandAlt,
                                formData: updatedValues,
                                formKey: "Brand Alt",
                              );
                            } else {
                              _onChanged(val, updatedValues, "Brand Alt");
                            }
                          },
                          validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
                            // Uncomment or add validators as needed
                            FormBuilderValidators.required(),
                          ]),
                          dropdownColor: Colors.grey,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF252525),
                            isDense: true, // Reduce vertical padding of the field
                            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ), // Add a border around the dropdown
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //Model Alt
              CustomTextField(
                textTitle: "Alternator Model :",
                isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
                onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Model Alt"),
                validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                keyboardType: TextInputType.name,
              ),
              //Serial Alt
              CustomTextField(
                textTitle: "Alternator serial :",
                isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
                onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Serial Alt"),
                validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                keyboardType: TextInputType.number,
              ),

              //Brand Eng
              Card(
                color: suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Engine Brand :",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: mainTextColor,
                        ),
                      ),
                      const SizedBox(width:10,), // Add some space between the label and the dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: brandeng.contains(updatedValues["Brand Eng"])
                              ? updatedValues["Brand Eng"]
                              : null, // Default value
                          items: [
                            ...brandeng.where((String value) => value != "Other").map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(fontSize: 12, color: mainTextColor),),
                              );
                            }).toList(),
                            const DropdownMenuItem<String>(
                              value: "Other",
                              child: Text("Other",style: const TextStyle(fontSize: 12, color: mainTextColor),),
                            ),
                          ],
                          onChanged: _areFieldsDisabled ? null : (val){
                            if (val == "Other") {
                              _showCustomBrandDialog(
                                key: "Brand Eng",
                                brandList: brandeng,
                                formData: updatedValues,
                                formKey: "Brand Eng",
                              );
                            } else {
                              _onChanged(val, updatedValues, "Brand Eng");
                            }
                          },
                          validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                          dropdownColor: Colors.grey,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF252525),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //Model eng
              CustomTextField(
                textTitle: "Engine Model :",
                isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
                onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Model Eng"),
                validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                keyboardType: TextInputType.name,
              ),
              //Serial Eng
              CustomTextField(
                textTitle: "Engine Serial :",
                isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
                onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Serial Eng"),
                validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                keyboardType: TextInputType.number,
              ),

              //Brand Set
              Card(
                color: suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Set Brand :",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: mainTextColor,
                        ),
                      ),
                      const SizedBox(width:10,), // Add some space between the label and the dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: brandset.contains(updatedValues["Brand Set"])
                              ? updatedValues["Brand Set"]
                              : null, // Default value
                          items: [
                            ...brandset.where((String value) => value != "Other").map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(fontSize: 12, color: mainTextColor),),
                              );
                            }).toList(),
                            const DropdownMenuItem<String>(
                              value: "Other",
                              child: Text("Other",style: const TextStyle(fontSize: 12, color: mainTextColor),),
                            ),
                          ],
                          onChanged: _areFieldsDisabled ? null : (val) {
                            if (val == "Other") {
                              _showCustomBrandDialog(
                                key: "Brand Set",
                                brandList: brandset,
                                formData: updatedValues,
                                formKey: "Brand Set",
                              );
                            } else {
                              _onChanged(val, updatedValues, "Brand Set");
                            }
                          },
                          validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                          dropdownColor: Colors.grey,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF252525),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //Model Set
              CustomTextField(
                textTitle: "Set Model :",
                isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
                onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Model Set"),
                validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                keyboardType: TextInputType.name,
              ),
              //Serial Set
              CustomTextField(
                textTitle: "Set Serial :",
                isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
                onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Serial Set"),
                validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                keyboardType: TextInputType.number,
              ),

              const Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
                child: Text(
                  "Controller Details",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: mainTextColor),
                ),
              ),

              //Controller
              Card(
                color: suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Controller Brand :",
                        style: TextStyle(
                          fontSize: 12,
                          color: mainTextColor,
                        ),
                      ),
                      const SizedBox(width:10,), // Add some space between the label and the dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: contBrand.contains(updatedValues["Controller"])
                              ? updatedValues["Controller"]
                              : null, // Default value
                          items: [
                            ...contBrand.where((String value) => value != "Other").map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(fontSize: 12, color: mainTextColor),),
                              );
                            }).toList(),
                            const DropdownMenuItem<String>(
                              value: "Other",
                              child: Text("Other",style: const TextStyle(fontSize: 12, color: mainTextColor),),
                            ),
                            const DropdownMenuItem<String>(
                              value: "Not Available",
                              child: Text("Not Available",style: const TextStyle(fontSize: 12, color: mainTextColor),),
                            ),
                          ],
                          onChanged: _areFieldsDisabled ? null : (val) {
                            if (val == "Not Available") {
                              setState(() {
                                isControllerModelEnabled = false;
                              });
                              _onChanged(null, updatedValues, "Controller Model"); // Clear the model value if disabled
                            } else {
                              setState(() {
                                isControllerModelEnabled = true;
                              });
                              _onChanged(val, updatedValues, "Controller");
                            }

                            if (val == "Other") {
                              _showCustomBrandDialog(
                                key: "Controller",
                                brandList: contBrand,
                                formData: updatedValues,
                                formKey: "Controller",
                              );
                            } else {
                              _onChanged(val, updatedValues, "Controller");
                            }
                          },
                          validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
                            // Uncomment or add validators as needed
                            //FormBuilderValidators.required(),
                          ]),
                          dropdownColor: Colors.grey,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF252525),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              //Controller Model
              CustomTextField(
                textTitle: "Controller Model :",
                isWantEdit: isControllerModelEnabled,
                onChanged: (val) =>
                    _onChanged(val, updatedValues, "Controller Model"),
                validator: isControllerModelEnabled
                    ? FormBuilderValidators.compose([
                  //FormBuilderValidators.required(),
                ])
                    : null,
                keyboardType: TextInputType.name,
                enabled: isControllerModelEnabled, // This will disable the field if false
              ),


              const Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
                child: Text(
                  "Tank Details",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: mainTextColor),
                ),
              ),

              //Tank cap Prime
              CustomTextField(
                textTitle: "Day Tank Capacity(L) :",
                isWantEdit: !_areFieldsDisabled,
                onChanged: !_areFieldsDisabled
                    ? (val) => _onChanged(val, updatedValues, "Tank Prime")
                    : null,
                validator: !_areFieldsDisabled
                    ? FormBuilderValidators.compose([
                  // FormBuilderValidators.required(),
                  // Add other validators here if needed
                ])
                    : null,
                keyboardType: TextInputType.number,
                enabled: !_areFieldsDisabled, // Ensure this field respects the disabled state
              ),



              //Bulk tank Available
              Card(
                color: suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const Text(
                        "Bulk Tank Available :",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12, color: mainTextColor),
                      ),
                      const Spacer(),
                      Expanded(
                        child: FormBuilderChoiceChips<String>(
                          backgroundColor: Color(0xFF252525),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          name: 'Bulk Tank',
                          initialValue: updatedValues['Bulk Tank'],
                          selectedColor: Colors.lightBlueAccent,
                          options: const [
                            FormBuilderChipOption(
                              value: '1',
                              child: Text('Yes',style: TextStyle(fontSize: 12,color: mainTextColor),),

                            ),
                            FormBuilderChipOption(
                              value: '0',
                              child: Text('No',style: TextStyle(fontSize: 12,color: mainTextColor)),
                            ),
                          ],
                          onChanged: !_areFieldsDisabled ? (val) {
                            setState(() {
                              if (val == '0') {
                                isDayTankSizeEnabled = false;
                                _onChanged(null, updatedValues, 'Day Tank Size');
                              } else {
                                isDayTankSizeEnabled = true;
                              }
                              _onChanged(val, updatedValues, 'Day Tank');
                            });
                          } : null, // Disable onChanged if fields are disabled
                          enabled: !_areFieldsDisabled, // Disable the chip if fields are disabled
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              //Bulk Tank Size(L)
              CustomTextField(
                textTitle: "Bulk Tank Size(L) :",
                isWantEdit: !_areFieldsDisabled && isDayTankSizeEnabled,
                onChanged: (!_areFieldsDisabled && isDayTankSizeEnabled)
                    ? (val) => _onChanged(val, updatedValues, "Bulk Tank Size")
                    : null,
                validator: (!_areFieldsDisabled && isDayTankSizeEnabled)
                    ? FormBuilderValidators.compose([
                  // FormBuilderValidators.required(),
                  // Add other validators here if needed
                ])
                    : null,
                keyboardType: TextInputType.number,
                enabled: !_areFieldsDisabled && isDayTankSizeEnabled, // Ensure this field respects both states
              ),




              const Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
                child: Text(
                  "ATS and Cabling",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: mainTextColor),
                ),
              ),

              //Brand ATS
              Card(
                color: suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "ATS Brand :",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: mainTextColor,
                        ),
                      ),
                      const  SizedBox(width:10,), // Add some space between the label and the dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: brandAts.contains(updatedValues["BrandATS"])
                              ? updatedValues["BrandATS"]
                              : null, // Default value
                          items: [
                            ...brandAts.where((String value) => value != "Other").map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(fontSize: 12, color: mainTextColor),),
                              );
                            }).toList(),
                            const DropdownMenuItem<String>(
                              value: "Other",
                              child: Text("Other",style: const TextStyle(fontSize: 12, color: mainTextColor),),
                            ),
                            const DropdownMenuItem<String>(
                              value: "Not Available",
                              child: Text("Not Available",style: const TextStyle(fontSize: 12, color: mainTextColor),),
                            ),
                          ],
                          onChanged: !_areFieldsDisabled
                              ? (val) {
                            setState(() {
                              if (val == "Not Available") {
                                isAtsFieldsEnabled = false;
                                // Clear the values and validators for the disabled fields
                                _onChanged(null, updatedValues, "Rating ATS");
                                _onChanged(null, updatedValues, "Model ATS");
                              } else {
                                isAtsFieldsEnabled = true;
                              }
                              _onChanged(val, updatedValues, "BrandATS");
                            });

                            if (val == "Other") {
                              _showCustomBrandDialog(
                                key: "BrandATS",
                                brandList: brandAts,
                                formData: updatedValues,
                                formKey: "BrandATS",
                              );
                            } else {
                              _onChanged(val, updatedValues, "BrandATS");
                            }
                          }
                              : null, // Disable onChanged if _areFieldsDisabled is true
                          validator: !_areFieldsDisabled
                              ? FormBuilderValidators.compose([
                            // Uncomment or add validators as needed
                            // FormBuilderValidators.required(),
                          ])
                              : null, // Disable validators if _areFieldsDisabled is true
                          dropdownColor: Colors.grey,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF252525),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                          disabledHint: const Text(""),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Rating ATS
              CustomTextField(
                textTitle: "ATS Rating(A) :",
                isWantEdit: !_areFieldsDisabled && isAtsFieldsEnabled,
                onChanged: !_areFieldsDisabled && isAtsFieldsEnabled
                    ? (val) => _onChanged(val, updatedValues, "Rating ATS")
                    : null,
                validator: !_areFieldsDisabled && isAtsFieldsEnabled
                    ? FormBuilderValidators.compose([
                  // FormBuilderValidators.required(),
                ])
                    : null,
                keyboardType: TextInputType.number,
                enabled: !_areFieldsDisabled && isAtsFieldsEnabled,
              ),

              // Model ATS
              CustomTextField(
                textTitle: "ATS Model :",
                isWantEdit: !_areFieldsDisabled && isAtsFieldsEnabled,
                onChanged: !_areFieldsDisabled && isAtsFieldsEnabled
                    ? (val) => _onChanged(val, updatedValues, "Model ATS")
                    : null,
                validator: !_areFieldsDisabled && isAtsFieldsEnabled
                    ? FormBuilderValidators.compose([
                  // FormBuilderValidators.required(),
                ])
                    : null,
                keyboardType: TextInputType.name,
                enabled: !_areFieldsDisabled && isAtsFieldsEnabled, // Ensure this field respects the enabled state
              ),

              //Feeder Cable
              CustomTextField(
                textTitle: "Feeder Cable Size(mm^2) :",
                isWantEdit: !_areFieldsDisabled,
                onChanged: !_areFieldsDisabled
                    ? (val) => _onChanged(val, updatedValues, "Feeder Size")
                    : null,
                validator: !_areFieldsDisabled
                    ? FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ])
                    : null,
                keyboardType: TextInputType.number,
              ),

              //MCCB
              CustomTextField(
                textTitle: "MCCB Rating(A) :",
                isWantEdit: !_areFieldsDisabled,
                onChanged: !_areFieldsDisabled
                    ? (val) => _onChanged(val, updatedValues, "Rating MCCB")
                    : null,
                validator: !_areFieldsDisabled
                    ? FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ])
                    : null,
                keyboardType: TextInputType.number,
              ),


              const Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
                child: Text(
                  "Battery Details",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: mainTextColor),
                ),
              ),

              //Bat count
              CustomTextField(
                textTitle: "Battery Count :",
                isWantEdit: !_areFieldsDisabled,
                onChanged: !_areFieldsDisabled
                    ? (val) => _onChanged(val, updatedValues, "Battery Count")
                    : null,
                validator: !_areFieldsDisabled
                    ? FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ])
                    : null,
                keyboardType: TextInputType.number,
              ),

              //Bat Brand
              Card(
                color: suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Battery Brand :",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: mainTextColor,
                        ),
                      ),
                      const SizedBox(width:10,), // Add some space between the label and the dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: batBrand.contains(updatedValues["Battery Brand"])
                              ? updatedValues["Battery Brand"]
                              : null, // Default value
                          items: [
                            ...batBrand.where((String value) => value != "Other").map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(fontSize: 12, color: mainTextColor),),
                              );
                            }).toList(),
                            const DropdownMenuItem<String>(
                              value: "Other",
                              child: Text("Other",style: const TextStyle(fontSize: 12, color: mainTextColor),),
                            ),
                          ],
                          onChanged: !_areFieldsDisabled
                              ? (val) {
                            if (val == "Other") {
                              _showCustomBrandDialog(
                                key: "Battery Brand",
                                brandList: batBrand,
                                formData: updatedValues,
                                formKey: "Battery Brand",
                              );
                            } else {
                              _onChanged(val, updatedValues, "Battery Brand");
                            }
                          }
                              : null, // Disable onChanged if _areFieldsDisabled is true
                          validator: !_areFieldsDisabled
                              ? FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ])
                              : null, // Disable validators if _areFieldsDisabled is true
                          dropdownColor: Colors.grey,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF252525),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                          disabledHint: const Text(""),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //Bat Capacity
              CustomTextField(
                textTitle: "Battery Capacity(Ah) :",
                isWantEdit: !_areFieldsDisabled,
                onChanged: !_areFieldsDisabled
                    ? (val) => _onChanged(val, updatedValues, "Battery Capacity")
                    : null,
                validator: !_areFieldsDisabled
                    ? FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ])
                    : null,
                keyboardType: TextInputType.number,
              ),


              const Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
                child: Text(
                  "Service Provider",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: mainTextColor),
                ),
              ),

              CustomTextField(
                textTitle: "Local Agent :",
                isWantEdit: !_areFieldsDisabled,
                onChanged: !_areFieldsDisabled
                    ? (val) => _onChanged(val, updatedValues, "Local Agent")
                    : null,
                validator: !_areFieldsDisabled
                    ? FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ])
                    : null,
                keyboardType: TextInputType.name,
              ),

              CustomTextField(
                textTitle: "Agent Address :",
                isWantEdit: !_areFieldsDisabled,
                onChanged: !_areFieldsDisabled
                    ? (val) => _onChanged(val, updatedValues, "Agent Addr")
                    : null,
                validator: !_areFieldsDisabled
                    ? FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ])
                    : null,
                keyboardType: TextInputType.name,
              ),

              CustomTextField(
                textTitle: "Agent Telephone :",
                isWantEdit: !_areFieldsDisabled,
                onChanged: !_areFieldsDisabled
                    ? (val) => _onChanged(val, updatedValues, "Agent Tel")
                    : null,
                validator: !_areFieldsDisabled
                    ? (value) {
                  if (value == null || value.isEmpty) {
                    return null; // No validation error if the field is empty
                  }
                  if (value.length < 10) {
                    return 'Please enter between\n 1 and 10 digits';
                  }
                  return null; // Valid input
                }
                    : null,
                keyboardType: TextInputType.number,
              ),



              // Center(
              //   child: Text(
              //     "Update Details",
              //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              //   ),
              // ),
              //
              // CustomTextField(
              //   textTitle: "Updated By",
              //   isWantEdit: true,
              //   onChanged: (val) =>
              //       _onChanged(val, updatedValues, "Updated By"),
              //   // validator: FormBuilderValidators.compose([
              //   //   FormBuilderValidators.required(),
              //   // ]),
              //   keyboardType: TextInputType.name,
              // ),
              // GestureDetector(
              //   onTap: () {},
              //   //_selectDate(context, "Last Updated"),
              //   child: Card(
              //     child: Padding(
              //       padding: const EdgeInsets.all(10.0),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceAround,
              //         children: [
              //           Text(
              //             "Updated",
              //             style: TextStyle(
              //                 fontWeight: FontWeight.w500, fontSize: 15),
              //           ),
              //           Spacer(),
              //           Text(
              //             updatedValues['Updated'] ?? 'Not Set',
              //             style: TextStyle(fontSize: 15),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                      WidgetStatePropertyAll(mainTextColor),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6), // Customize the radius
                        ),
                      ),


                    ),
                    onPressed: () {
                      if (_formKey.currentState!.saveAndValidate()) {
                        print(updatedValues.toString());

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => HttpGeneratorGetPostPage(
                        //       formData: updatedValues,
                        //       Updator: updator,
                        //     ),
                        //   ),
                        // );
                      }
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Color.fromARGB(255, 122, 76, 146)),
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

// Map<String, dynamic> _getEditedFields(
//     Map<String, dynamic> updatedGeneratorDetails) {
//   final editedFields = <String, dynamic>{};
//   updatedGeneratorDetails.forEach((key, value) {
//     if (originalValues[key] != value) {
//       editedFields[key] = value;
//     }
//   });
//   print(editedFields.toString());
//   return editedFields;
// }
}

class CustomTextField extends StatelessWidget {
  final String textTitle;
  final bool isWantEdit;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool enabled;

  const CustomTextField({
    Key? key,
    required this.textTitle,
    required this.isWantEdit,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: suqarBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              textTitle,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12,color: mainTextColor),
            ),
            SizedBox(width:10,),
            Expanded(
              child: FormBuilderTextField(
                name: textTitle, style: TextStyle(fontSize: 12,color: mainTextColor),
                enabled: isWantEdit,
                decoration: const InputDecoration(
                  filled: true, // Enables background color
                  fillColor: Color(0xFF252525), // Background color of the input field
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none, // Removes the border
                    borderRadius: BorderRadius.all(Radius.circular(5)), // Optional: Rounded corners
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  // Adjust padding if needed
                ),
                onChanged: onChanged,
                validator: validator,
                keyboardType: keyboardType,

                autovalidateMode: AutovalidateMode.onUserInteraction,

              ),
            ),
          ],
        ),
      ),
    );
  }
}



//v3
// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:provider/provider.dart';
//
// import '../../../Widgets/GPSGrab/gps_location_widget.dart';
// import '../../HomePage/utils/colors.dart';
// import '../../UserAccess.dart';
// import 'httpPostGen.dart';
//
//
//
// class GeneratorDetailAddPage  extends StatefulWidget {
//
//
//
//   GeneratorDetailAddPage({Key? key}) : super(key: key);
//
//
//   @override
//   _GeneratorDetailAddPageState createState() => _GeneratorDetailAddPageState();
//
// }
//
// class _GeneratorDetailAddPageState extends State<GeneratorDetailAddPage> {
//   final _formKey = GlobalKey<FormBuilderState>();
//   String updator="";
//   //late Map<String, dynamic> originalValues;
//   Map<String, dynamic> updatedValues = {};
//   bool _isLoading = false;
//   bool _isManual = false;
//   bool _isAuto = false;
//
//   String _latitude = '';
//   String _longitude = '';
//   String _error = '';
//   bool isControllerModelEnabled = true;
//   bool isAtsFieldsEnabled = true;
//   bool isDayTankSizeEnabled = true;
//   bool _areFieldsDisabled = false;
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
//     'UVA',
//     'Other'
//   ];
//
//   List<String> brandeng = ['Caterpillar', 'Chana', 'Cummins', 'Deutz', 'Detroit', 'Denyo', 'Greaves', 'Honda', 'Hyundai', 'Isuzu', 'John Deere', 'Komatsu', 'Kohler', 'Kubota', 'Lester', 'Mitsubishi', 'Onan', 'Perkins', 'Rusten', 'Unknown', 'Valmet', 'Volvo', 'Yanmar','Other'];
//   List<String> contBrand = ['DSE', 'HMI', 'Unknown','Other'];
//   List<String> brandset = ['Caterpillar', 'Cummins', 'Dale', 'Denyo', 'F.G.Wilson', 'Foracity', 'Greaves', 'John Deere', 'Jubilee', 'Kohler', 'Mitsui - Deutz', 'Mosa', 'Olympian', 'Onan', 'Pramac', 'Sanyo Denki', 'Siemens', 'Tempest', 'Unknown', 'Wega', 'Welland Power','Other'];
//   List<String> brandAlt=['Alsthom', 'Aulturdyne', 'Bosch', 'Caterpillar', 'Denyo', 'Greaves', 'Iskra', 'Kohler', 'Leroy Somer', 'Marelli', 'Mecc Alte', 'Mitsubishi', 'Perkins', 'Sanyo Denki', 'Siemens', 'Stamford', 'Taiyo', 'Tempest', 'Unknown', 'Wega','Other'];
//   List<String> brandAts=['Schnider', 'Cummins', 'Socomec','Unknown','Other'];
//   List<String> batBrand=['Amaron', 'Exide', 'Luminous','Volta','Okaya','LivGuard','Su-Kam','Shield','Other'];
//
//
//   void _fetchLocation() async {
//     setState(() {
//       _isLoading = true;
//       _error = ''; // Reset error message when starting to fetch location
//     });
//
//     try {
//       GPSLocationFetcher locationFetcher = GPSLocationFetcher();
//       Map<String, String> location = await locationFetcher.fetchLocation();
//
//       // Debug print to check the location map
//       debugPrint("Fetched location data: $location");
//
//       if (location.containsKey('latitude') && location.containsKey('longitude')) {
//         setState(() {
//           _latitude = location['latitude'] ?? '';
//           _longitude = location['longitude'] ?? '';
//           updatedValues['Latitude'] = _latitude; // Ensure you use 'Latitude' if it needs to be uppercase
//           updatedValues['Longitude'] = _longitude; // Ensure you use 'Longitude' if it needs to be uppercase
//           _isLoading = false;
//           debugPrint("Location $_latitude, $_longitude");
//         });
//       } else {
//         throw Exception('Location data is missing');
//       }
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//         debugPrint("Error: $_error");
//         _isLoading = false;
//       });
//     }
//   }
//
//
//
//   @override
//   void initState() {
//     super.initState();
//
//     updatedValues.addAll({"clockTime": ""});
//   }
//
//   void _onChanged(
//       dynamic val, Map<String, dynamic> formData, String fieldName) {
//     setState(() {
//       formData[fieldName] = val;
//
//       //updatedValues[fieldName] = val;
//     });
//   }
//
//   // void _selectDate(BuildContext context) async {
//   //   final DateTime? pickedDate = await showDatePicker(
//   //     context: context,
//   //     //initialDate: _selectedDate ?? DateTime.now(),
//   //     firstDate: DateTime(2000),
//   //     lastDate: DateTime(2101),
//   //   );
//   //
//   //   if (pickedDate != null && pickedDate != _selectedDate) {
//   //     setState(() {
//   //       _selectedDate = pickedDate;
//   //       _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
//   //       updatedValues['Installed Date'] =
//   //           DateFormat('yyyy-MM-dd').format(pickedDate);
//   //     });
//   //   }
//   // }
//
//   void _showCustomBrandDialog({
//     required String key,
//     required List<String?> brandList,
//     required Map<String, dynamic> formData,
//     required String formKey, // A unique key for the form
//   }) {
//     TextEditingController customBrandController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: const ColorScheme.light(primary: Colors.green),
//           ),
//           child: AlertDialog(
//             title: const Text("Add Custom Brand"),
//             content: TextField(
//               controller: customBrandController,
//               decoration: const InputDecoration(
//                 hintText: "Enter your brand name",
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text("Cancel"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               TextButton(
//                 child: const Text("OK"),
//                 onPressed: () {
//                   String customBrand = customBrandController.text.trim();
//                   if (customBrand.isNotEmpty) {
//                     setState(() {
//                       if (!brandList.contains(customBrand)) {
//                         brandList.add(customBrand);
//                       }
//                       formData[formKey] = customBrand;
//                     });
//                   }
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     UserAccess userAccess = Provider.of<UserAccess>(context, listen: true); // Use listen: true to rebuild the widget when the data changes
//     updator=userAccess.username!;
//
//     return Scaffold(
//       backgroundColor: mainBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: mainBackgroundColor,
//         title: const Center(child: Text('Add DEG Details',style: TextStyle(color: mainTextColor, fontSize: 20),)),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 8.0),
//         child: FormBuilder(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   "Location",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: mainTextColor),
//                 ),
//               ),
//
//               //Province
//               Card(
//                 color: suqarBackgroundColor,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const Text(
//                         "Province :",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12,
//                           color: mainTextColor,
//                         ),
//                       ),
//                       SizedBox(width:10,),// Add some space between the label and the dropdown
//                       Expanded(
//                         child: DropdownButtonFormField<String>(
//                           value: Regions.contains(updatedValues["Province"])
//                               ? updatedValues["Province"]
//                               : null, // Default value
//                           items: [
//                             ...Regions.where((String value) => value != "Other").map((String value) {
//                               return DropdownMenuItem<String>(
//
//                                 value: value,
//                                 child: Text(value,style: const TextStyle(fontSize: 12, color: mainTextColor),),
//
//                               );
//                             }).toList(),
//                             const DropdownMenuItem<String>(
//                               value: "Other",
//                               child: Text("Other",style: const TextStyle(fontSize: 12, color: mainTextColor),),
//                             ),
//                           ],
//                           onChanged: (val) {
//                             if (val == "Other") {
//                               _showCustomBrandDialog(
//                                 key: "Province",
//                                 brandList: Regions,
//                                 formData: updatedValues,
//                                 formKey: "Province",
//                               );
//                             } else {
//                               _onChanged(val, updatedValues, "Province");
//                             }
//                           },
//                           validator: FormBuilderValidators.compose([
//                             // Uncomment or add validators as needed
//                             // FormBuilderValidators.required(),
//                           ]),
//                          customColors.suqarBackgroundColor,
//                           decoration: const InputDecoration(
//                             filled: true,
//                             fillColor: Color(0xFF252525),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide.none,
//                               borderRadius: BorderRadius.all(Radius.circular(5)),
//                             ),
//                             isDense: true,
//                             contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //Rtom
//               CustomTextField(
//                 textTitle: "Rtom Name :",
//                 isWantEdit: true,
//                 onChanged: (val) => _onChanged(val, updatedValues, "Rtom Name"),
//                 validator: FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ]),
//                 keyboardType: TextInputType.name,
//               ),
//               //Station
//               CustomTextField(
//                 textTitle: "Station :",
//                 isWantEdit: true,
//                 onChanged: (val) => _onChanged(val, updatedValues, "Station"),
//                 validator: FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ]),
//                 keyboardType: TextInputType.name,
//               ),
//               // GPS Location Card
//               Card(
//                 color: suqarBackgroundColor,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       const Text(
//                         "Location Set As :",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500, fontSize: 12,color: mainTextColor,),
//                       ),
//                       SizedBox(width:10,),
//                       Row(
//                         children: [
//                           Checkbox(
//                             value: _isManual,
//                             onChanged: (bool? value) {
//                               setState(() {
//                                 _isManual = value!;
//                                 if (value == true) _isAuto = false;
//                                 if (_isAuto) _fetchLocation(); // Fetch location only if auto is true
//                               });
//                             },
//                           ),
//                           const Text("Manual",style: TextStyle(fontSize: 12,color: mainTextColor,),),
//                         ],
//                       ),
//
//                       Row(
//                         children: [
//                           Checkbox(
//                             value: _isAuto,
//                             onChanged: (bool? value) {
//                               setState(() {
//                                 _isAuto = value!;
//                                 if (value == true) _isManual = false;
//                                 if (_isAuto) _fetchLocation(); // Fetch location only if auto is true
//                               });
//                             },
//                           ),
//                           const Text("Auto",style: TextStyle(fontSize: 12,color: mainTextColor,),),
//                         ],
//                       ),
//
//                     ],
//                   ),
//                 ),
//               ),
//
// // Display Location or Manual Entry
//               _isManual
//                   ? Column(
//                 children: [
//                   CustomTextField(
//                     textTitle: "Latitude",
//                     isWantEdit: true,
//                     keyboardType: TextInputType.number,
//                     onChanged: (val) {
//                       _onChanged(val, updatedValues, "Latitude");
//                     },
//                     validator: FormBuilderValidators.compose([
//                       FormBuilderValidators.required(),
//                       FormBuilderValidators.numeric()
//                     ]),
//                   ),
//                   CustomTextField(
//                     textTitle: "Longitude",
//                     isWantEdit: true,
//                     keyboardType: TextInputType.number,
//                     onChanged: (val) {
//                       _onChanged(val, updatedValues, "Longitude");
//                     },
//                     validator: FormBuilderValidators.compose([
//                       FormBuilderValidators.required(),
//                       FormBuilderValidators.numeric()
//                     ]),
//                   ),
//                 ],
//               )
//                   : Card(
//                 color: suqarBackgroundColor,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     children: [
//                       const Text(
//                         "Location :",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500, fontSize: 12,color: mainTextColor,),
//                       ),
//                       Spacer(),
//                       Text("Latitude : ${updatedValues['Latitude'] ?? 'N/A'}",style: TextStyle(fontSize: 12,color: mainTextColor,)),
//                       SizedBox(width:30,),
//                       Text("Longitude : ${updatedValues['Longitude'] ?? 'N/A'}",style: TextStyle(fontSize: 12,color: mainTextColor,)),
//                       SizedBox(width:30,),
//                       if (_isLoading)
//                         const CircularProgressIndicator(), // Show progress indicator when loading
//                       if (_error.isNotEmpty)
//                         Text(
//                           "Error turn on location",
//                           style: const TextStyle(color: Colors.red),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               const Padding(
//                 padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
//                 child: Text(
//                   "Genaral Details",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: mainTextColor),
//                 ),
//               ),
//
//               //Available
//               Card(
//                 color: suqarBackgroundColor,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     children: [
//                       const Text(
//                         "DEG Available :",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12,
//                           color: mainTextColor,
//                         ),
//                       ),
//                       SizedBox(width: 10,),
//                       Spacer(),
//                       Expanded(
//                         child: FormBuilderChoiceChip<String>(
//                           backgroundColor: Color(0xFF252525),
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           name: 'Available',
//                           initialValue: updatedValues['Available'],
//                           selectedColor: Colors.lightBlueAccent,
//                           options: const [
//                             FormBuilderChipOption(
//                               value: 'Yes',
//                               avatar: CircleAvatar(child: Text('')),
//                               child: Text(
//                                 'Yes',
//                                 style: const TextStyle(
//                                   fontSize: 12, // Adjust text size
//                                   color: mainTextColor, // Adjust text color
//                                 ),
//                               ),
//
//                             ),
//                             FormBuilderChipOption(
//                               value: 'No',
//                               avatar: CircleAvatar(child: Text('')),
//                               child: Text(
//                                 'No',
//                                 style: const TextStyle(
//                                   fontSize: 12, // Adjust text size
//                                   color: mainTextColor, // Adjust text color
//                                 ),
//                               ),
//                             ),
//                           ],
//                           onChanged: (val) {
//                             setState(() {
//                               _onChanged(val, updatedValues, 'Available');
//                               _areFieldsDisabled = val == 'No'; // Disable fields if 'No' is selected
//                             });
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //Category
//               Card(
//                 color: suqarBackgroundColor,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     children: [
//                       const Text(
//                         "DEG Category :",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500, fontSize: 12, color: mainTextColor),
//                       ),
//                       const Spacer(),
//                       Expanded(
//                         child: FormBuilderChoiceChip<String>(
//                           backgroundColor:Color(0xFF252525),
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           //decoration: const InputDecoration(labelText: 'Type'),
//                           name: 'Category',
//                           initialValue: updatedValues['Category'],
//                           selectedColor: Colors.lightBlueAccent,
//                           options: const [
//                             FormBuilderChipOption(
//                               value: 'Fixed',
//                               avatar: CircleAvatar(child: Text('')),
//                               child: Text(
//                                 'Fixed',
//                                 style: const TextStyle(
//                                   fontSize: 12, // Adjust text size
//                                   color: mainTextColor, // Adjust text color
//                                 ),
//                               ),
//
//                             ),
//                             FormBuilderChipOption(
//                               value: 'Mobile',
//                               avatar: CircleAvatar(child: Text('')),
//                               child: Text(
//                                 'Mobile',
//                                 style: const TextStyle(
//                                   fontSize: 12, // Adjust text size
//                                   color:mainTextColor, // Adjust text color
//                                 ),
//                               ),
//
//                             ),
//                             FormBuilderChipOption(
//                               value: 'Portable',
//                               avatar: CircleAvatar(child: Text('')),
//                               child: Text(
//                                 'Portable',
//                                 style: const TextStyle(
//                                   fontSize: 12, // Adjust text size
//                                   color: mainTextColor, // Adjust text color
//                                 ),
//                               ),
//                             ),
//                           ],
//                           // onChanged: _onChanged,
//
//                           onChanged: _areFieldsDisabled ? null : (val) { // Disable onChanged if fields are disabled
//                             setState(() {
//                               _onChanged(val, updatedValues, 'Category');
//                               print(updatedValues['Category']);
//                             });
//                           },
//                           enabled: !_areFieldsDisabled,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //Mode
//               Card(
//                 color: suqarBackgroundColor,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     children: [
//                       const Text(
//                         "Mode :",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500, fontSize: 12, color: mainTextColor),
//                       ),
//                       const Spacer(),
//                       Expanded(
//                         child: FormBuilderChoiceChip<String>(
//                           backgroundColor: Color(0xFF252525),
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           //decoration: const InputDecoration(labelText: 'Type'),
//                           name: 'Mode',
//                           initialValue: updatedValues['Mode'],
//                           selectedColor: Colors.lightBlueAccent,
//                           options: const [
//                             FormBuilderChipOption(
//                               value: 'A',
//                               child: Text('Auto',style: TextStyle(color: mainTextColor,fontSize: 12),),
//                               // avatar: CircleAvatar(child: Text('')),
//                             ),
//                             FormBuilderChipOption(
//                               value: 'M',
//                               child: Text('Manual',style: TextStyle(color: mainTextColor,fontSize: 12)),
//                               //avatar: CircleAvatar(child: Text('')),
//                             ),
//                           ],
//                           // onChanged: _onChanged,
//
//                           onChanged: _areFieldsDisabled ? null : (val) { // Disable onChanged if fields are disabled
//                             setState(() {
//                               _onChanged(val, updatedValues, 'Mode');
//                               print(updatedValues['Mode']);
//                             });
//                           },
//                           enabled: !_areFieldsDisabled,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //Phase
//               Card(
//                 color: suqarBackgroundColor,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     children: [
//                       const Text(
//                         "Phase Eng :",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500, fontSize: 12, color: mainTextColor),
//                       ),
//                       const Spacer(),
//                       Expanded(
//                         child: FormBuilderChoiceChip<String>(
//                           backgroundColor: Color(0xFF252525),
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           //decoration: const InputDecoration(labelText: 'Type'),
//                           name: 'Phase Eng',
//                           initialValue: updatedValues['Phase Eng'],
//                           selectedColor: Colors.lightBlueAccent,
//                           options: const [
//                             FormBuilderChipOption(
//                               value: '1',
//                               avatar: CircleAvatar(child: Text('')),
//                               child: Text(
//                                 '1',
//                                 style: const TextStyle(
//                                   fontSize: 12, // Adjust text size
//                                   color: mainTextColor, // Adjust text color
//                                 ),
//                               ),
//                             ),
//                             FormBuilderChipOption(
//                               value: '3',
//                               avatar: CircleAvatar(child: Text('')),
//                               child: Text(
//                                 '3',
//                                 style: const TextStyle(
//                                   fontSize: 12, // Adjust text size
//                                   color: mainTextColor, // Adjust text color
//                                 ),
//                               ),
//                             ),
//                           ],
//                           // onChanged: _onChanged,
//
//                           onChanged: _areFieldsDisabled ? null : (val) { // Disable onChanged if fields are disabled
//                             setState(() {
//                               _onChanged(val, updatedValues, 'Phase Eng');
//                               print(updatedValues['Phase Eng']);
//                             });
//                           },
//                           enabled: !_areFieldsDisabled,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //YOM
//               CustomTextField(
//                 textTitle: "Year of Manufacture :",
//                 isWantEdit: !_areFieldsDisabled,
//                 onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Year of Manufacture"),
//                 validator: (value) {
//                   if (_areFieldsDisabled) {
//                     return null; // Disable validation when fields are disabled
//                   }
//
//                   if (value == null || value.isEmpty) {
//                     return 'This field is required';
//                   }
//
//                   // Check if the input is a valid number
//                   final number = int.tryParse(value);
//                   if (number == null) {
//                     return 'Please enter a\n valid number';
//                   }
//
//                   // Check if the number is within the specified range
//                   if (number < 1900 || number > 3000) {
//                     return 'Please enter a number\n between 1900 and 3000';
//                   }
//
//                   // Check if the input length is exactly 4 digits
//                   if (value.length != 4) {
//                     return 'Please enter exactly\n 4 digits';
//                   }
//
//                   return null; // Valid input
//                 },
//                 keyboardType: TextInputType.number,
//               ),
//               //YOI
//               CustomTextField(
//                 textTitle: "Year of Install :",
//                 isWantEdit: !_areFieldsDisabled,
//                 onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Year of Install"),
//                 validator: (value) {
//                   if (_areFieldsDisabled) {
//                     return null; // Disable validation when fields are disabled
//                   }
//
//                   if (value == null || value.isEmpty) {
//                     return 'This field is required';
//                   }
//
//                   // Check if the input is a valid number
//                   final number = int.tryParse(value);
//                   if (number == null) {
//                     return 'Please enter a\n valid number';
//                   }
//
//                   // Check if the number is within the specified range
//                   if (number < 1900 || number > 3000) {
//                     return 'Please enter a number\n between 1900 and 3000';
//                   }
//
//                   // Check if the input length is exactly 4 digits
//                   if (value.length != 4) {
//                     return 'Please enter exactly\n 4 digits';
//                   }
//
//                   return null; // Valid input
//                 },
//                 keyboardType: TextInputType.number,
//               ),
//               //Set Capacity
//               CustomTextField(
//                 textTitle: "Set Capacity(kVA) :",
//                 isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
//                 onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Set Cap"),
//                 validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ]),
//                 keyboardType: TextInputType.number,
//
//               ),
//
//               const Padding(
//                 padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
//                 child: Text(
//                   "Generator Specifications",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: mainTextColor),
//                 ),
//               ),
//
//               //Brand Alt
//               Card(
//                 color: suqarBackgroundColor,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const Text(
//                         "Alternator Brand :",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12,
//                           color: mainTextColor,
//                         ),
//                       ),
//                       const SizedBox(width: 10), // Add some space between the label and the dropdown
//                       Expanded(
//                         child: DropdownButtonFormField<String>(
//                           value: brandAlt.contains(updatedValues["Brand Alt"])
//                               ? updatedValues["Brand Alt"]
//                               : null, // Default value
//                           items: [
//                             ...brandAlt.where((String value) => value != "Other").map((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value,style: const TextStyle(fontSize: 12, color: mainTextColor),),
//                               );
//                             }).toList(),
//                             const DropdownMenuItem<String>(
//                               value: "Other",
//                               child: Text("Other",style: const TextStyle(fontSize: 12, color: mainTextColor),),
//                             ),
//                           ],
//                           onChanged: _areFieldsDisabled ? null : (val) {
//                             if (val == "Other") {
//                               _showCustomBrandDialog(
//                                 key: "Brand Alt",
//                                 brandList: brandAlt,
//                                 formData: updatedValues,
//                                 formKey: "Brand Alt",
//                               );
//                             } else {
//                               _onChanged(val, updatedValues, "Brand Alt");
//                             }
//                           },
//                           validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
//                             // Uncomment or add validators as needed
//                             FormBuilderValidators.required(),
//                           ]),
//                           dropdownColor: Colors.grey,
//                           decoration: const InputDecoration(
//                             filled: true,
//                             fillColor: Color(0xFF252525),
//                             isDense: true, // Reduce vertical padding of the field
//                             contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide.none,
//                               borderRadius: BorderRadius.all(Radius.circular(5)),
//                             ), // Add a border around the dropdown
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //Model Alt
//               CustomTextField(
//                 textTitle: "Alternator Model :",
//                 isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
//                 onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Model Alt"),
//                 validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ]),
//                 keyboardType: TextInputType.name,
//               ),
//               //Serial Alt
//               CustomTextField(
//                 textTitle: "Alternator serial :",
//                 isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
//                 onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Serial Alt"),
//                 validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ]),
//                 keyboardType: TextInputType.number,
//               ),
//
//               //Brand Eng
//               Card(
//                 color: suqarBackgroundColor,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const Text(
//                         "Engine Brand :",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12,
//                           color: mainTextColor,
//                         ),
//                       ),
//                       const SizedBox(width:10,), // Add some space between the label and the dropdown
//                       Expanded(
//                         child: DropdownButtonFormField<String>(
//                           value: brandeng.contains(updatedValues["Brand Eng"])
//                               ? updatedValues["Brand Eng"]
//                               : null, // Default value
//                           items: [
//                             ...brandeng.where((String value) => value != "Other").map((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                             const DropdownMenuItem<String>(
//                               value: "Other",
//                               child: Text("Other"),
//                             ),
//                           ],
//                           onChanged: _areFieldsDisabled ? null : (val){
//                             if (val == "Other") {
//                               _showCustomBrandDialog(
//                                 key: "Brand Eng",
//                                 brandList: brandeng,
//                                 formData: updatedValues,
//                                 formKey: "Brand Eng",
//                               );
//                             } else {
//                               _onChanged(val, updatedValues, "Brand Eng");
//                             }
//                           },
//                           validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
//                             FormBuilderValidators.required(),
//                           ]),
//                           dropdownColor: Colors.grey,
//                           decoration: const InputDecoration(
//                             filled: true,
//                             fillColor: Color(0xFF252525),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide.none,
//                               borderRadius: BorderRadius.all(Radius.circular(5)),
//                             ),
//                             isDense: true,
//                             contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //Model eng
//               CustomTextField(
//                 textTitle: "Engine Model :",
//                 isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
//                 onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Model Eng"),
//                 validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ]),
//                 keyboardType: TextInputType.name,
//               ),
//               //Serial Eng
//               CustomTextField(
//                 textTitle: "Engine Serial :",
//                 isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
//                 onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Serial Eng"),
//                 validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ]),
//                 keyboardType: TextInputType.number,
//               ),
//
//               //Brand Set
//               Card(
//                 color: suqarBackgroundColor,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const Text(
//                         "Set Brand :",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12,
//                           color: mainTextColor,
//                         ),
//                       ),
//                       const SizedBox(width:10,), // Add some space between the label and the dropdown
//                       Expanded(
//                         child: DropdownButtonFormField<String>(
//                           value: brandset.contains(updatedValues["Brand Set"])
//                               ? updatedValues["Brand Set"]
//                               : null, // Default value
//                           items: [
//                             ...brandset.where((String value) => value != "Other").map((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                             const DropdownMenuItem<String>(
//                               value: "Other",
//                               child: Text("Other"),
//                             ),
//                           ],
//                           onChanged: _areFieldsDisabled ? null : (val) {
//                             if (val == "Other") {
//                               _showCustomBrandDialog(
//                                 key: "Brand Set",
//                                 brandList: brandset,
//                                 formData: updatedValues,
//                                 formKey: "Brand Set",
//                               );
//                             } else {
//                               _onChanged(val, updatedValues, "Brand Set");
//                             }
//                           },
//                           validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
//                             FormBuilderValidators.required(),
//                           ]),
//                           dropdownColor: Colors.grey,
//                           decoration: const InputDecoration(
//                             filled: true,
//                             fillColor: Color(0xFF252525),
//                             isDense: true,
//                             contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide.none,
//                               borderRadius: BorderRadius.all(Radius.circular(5)),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //Model Set
//               CustomTextField(
//                 textTitle: "Set Model :",
//                 isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
//                 onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Model Set"),
//                 validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ]),
//                 keyboardType: TextInputType.name,
//               ),
//               //Serial Set
//               CustomTextField(
//                 textTitle: "Set Serial :",
//                 isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
//                 onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Serial Set"),
//                 validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ]),
//                 keyboardType: TextInputType.number,
//               ),
//
//               const Padding(
//                 padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
//                 child: Text(
//                   "Controller Details",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: mainTextColor),
//                 ),
//               ),
//
//               //Controller
//               Card(
//                 color: suqarBackgroundColor,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const Text(
//                         "Controller Brand :",
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: mainTextColor,
//                         ),
//                       ),
//                       const SizedBox(width:10,), // Add some space between the label and the dropdown
//                       Expanded(
//                         child: DropdownButtonFormField<String>(
//                           value: contBrand.contains(updatedValues["Controller"])
//                               ? updatedValues["Controller"]
//                               : null, // Default value
//                           items: [
//                             ...contBrand.where((String value) => value != "Other").map((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                             const DropdownMenuItem<String>(
//                               value: "Other",
//                               child: Text("Other"),
//                             ),
//                             const DropdownMenuItem<String>(
//                               value: "Not Available",
//                               child: Text("Not Available"),
//                             ),
//                           ],
//                           onChanged: _areFieldsDisabled ? null : (val) {
//                             if (val == "Not Available") {
//                               setState(() {
//                                 isControllerModelEnabled = false;
//                               });
//                               _onChanged(null, updatedValues, "Controller Model"); // Clear the model value if disabled
//                             } else {
//                               setState(() {
//                                 isControllerModelEnabled = true;
//                               });
//                               _onChanged(val, updatedValues, "Controller");
//                             }
//
//                             if (val == "Other") {
//                               _showCustomBrandDialog(
//                                 key: "Controller",
//                                 brandList: contBrand,
//                                 formData: updatedValues,
//                                 formKey: "Controller",
//                               );
//                             } else {
//                               _onChanged(val, updatedValues, "Controller");
//                             }
//                           },
//                           validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
//                             // Uncomment or add validators as needed
//                             //FormBuilderValidators.required(),
//                           ]),
//                           dropdownColor: Colors.grey,
//                           decoration: const InputDecoration(
//                             filled: true,
//                             fillColor: Color(0xFF252525),
//                             isDense: true,
//                             contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide.none,
//                               borderRadius: BorderRadius.all(Radius.circular(5)),
//                             ),
//                           ),
//                         ),
//                       ),
//
//                     ],
//                   ),
//                 ),
//               ),
//               //Controller Model
//               CustomTextField(
//                 textTitle: "Controller Model :",
//                 isWantEdit: isControllerModelEnabled,
//                 onChanged: (val) =>
//                     _onChanged(val, updatedValues, "Controller Model"),
//                 validator: isControllerModelEnabled
//                     ? FormBuilderValidators.compose([
//                   //FormBuilderValidators.required(),
//                 ])
//                     : null,
//                 keyboardType: TextInputType.name,
//                 enabled: isControllerModelEnabled, // This will disable the field if false
//               ),
//
//
//               const Padding(
//                 padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
//                 child: Text(
//                   "Tank Details",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: mainTextColor),
//                 ),
//               ),
//
//               //Tank cap Prime
//               CustomTextField(
//                 textTitle: "Day Tank Capacity(L) :",
//                 isWantEdit: !_areFieldsDisabled,
//                 onChanged: !_areFieldsDisabled
//                     ? (val) => _onChanged(val, updatedValues, "Tank Prime")
//                     : null,
//                 validator: !_areFieldsDisabled
//                     ? FormBuilderValidators.compose([
//                   // FormBuilderValidators.required(),
//                   // Add other validators here if needed
//                 ])
//                     : null,
//                 keyboardType: TextInputType.number,
//                 enabled: !_areFieldsDisabled, // Ensure this field respects the disabled state
//               ),
//
//
//
//               //Bulk tank Available
//               Card(
//                 color: suqarBackgroundColor,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     children: [
//                       const Text(
//                         "Bulk Tank Available :",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500, fontSize: 12, color: mainTextColor),
//                       ),
//                       const Spacer(),
//                       Expanded(
//                         child: FormBuilderChoiceChip<String>(
//                           backgroundColor: Color(0xFF252525),
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           name: 'Bulk Tank',
//                           initialValue: updatedValues['Bulk Tank'],
//                           selectedColor: Colors.lightBlueAccent,
//                           options: const [
//                             FormBuilderChipOption(
//                               value: '1',
//                               child: Text('Yes',style: TextStyle(fontSize: 12,color: mainTextColor),),
//
//                             ),
//                             FormBuilderChipOption(
//                               value: '0',
//                               child: Text('No',style: TextStyle(fontSize: 12,color: mainTextColor)),
//                             ),
//                           ],
//                           onChanged: !_areFieldsDisabled ? (val) {
//                             setState(() {
//                               if (val == '0') {
//                                 isDayTankSizeEnabled = false;
//                                 _onChanged(null, updatedValues, 'Day Tank Size');
//                               } else {
//                                 isDayTankSizeEnabled = true;
//                               }
//                               _onChanged(val, updatedValues, 'Day Tank');
//                             });
//                           } : null, // Disable onChanged if fields are disabled
//                           enabled: !_areFieldsDisabled, // Disable the chip if fields are disabled
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//
//               //Bulk Tank Size(L)
//               CustomTextField(
//                 textTitle: "Bulk Tank Size(L) :",
//                 isWantEdit: !_areFieldsDisabled && isDayTankSizeEnabled,
//                 onChanged: (!_areFieldsDisabled && isDayTankSizeEnabled)
//                     ? (val) => _onChanged(val, updatedValues, "Bulk Tank Size")
//                     : null,
//                 validator: (!_areFieldsDisabled && isDayTankSizeEnabled)
//                     ? FormBuilderValidators.compose([
//                   // FormBuilderValidators.required(),
//                   // Add other validators here if needed
//                 ])
//                     : null,
//                 keyboardType: TextInputType.number,
//                 enabled: !_areFieldsDisabled && isDayTankSizeEnabled, // Ensure this field respects both states
//               ),
//
//
//
//
//               const Padding(
//                 padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
//                 child: Text(
//                   "ATS and Cabling",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: mainTextColor),
//                 ),
//               ),
//
//               //Brand ATS
//               Card(
//                 color: suqarBackgroundColor,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const Text(
//                         "ATS Brand :",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12,
//                           color: mainTextColor,
//                         ),
//                       ),
//                       const  SizedBox(width:10,), // Add some space between the label and the dropdown
//                       Expanded(
//                         child: DropdownButtonFormField<String>(
//                           value: brandAts.contains(updatedValues["BrandATS"])
//                               ? updatedValues["BrandATS"]
//                               : null, // Default value
//                           items: [
//                             ...brandAts.where((String value) => value != "Other").map((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                             const DropdownMenuItem<String>(
//                               value: "Other",
//                               child: Text("Other"),
//                             ),
//                             const DropdownMenuItem<String>(
//                               value: "Not Available",
//                               child: Text("Not Available"),
//                             ),
//                           ],
//                           onChanged: !_areFieldsDisabled
//                               ? (val) {
//                             setState(() {
//                               if (val == "Not Available") {
//                                 isAtsFieldsEnabled = false;
//                                 // Clear the values and validators for the disabled fields
//                                 _onChanged(null, updatedValues, "Rating ATS");
//                                 _onChanged(null, updatedValues, "Model ATS");
//                               } else {
//                                 isAtsFieldsEnabled = true;
//                               }
//                               _onChanged(val, updatedValues, "BrandATS");
//                             });
//
//                             if (val == "Other") {
//                               _showCustomBrandDialog(
//                                 key: "BrandATS",
//                                 brandList: brandAts,
//                                 formData: updatedValues,
//                                 formKey: "BrandATS",
//                               );
//                             } else {
//                               _onChanged(val, updatedValues, "BrandATS");
//                             }
//                           }
//                               : null, // Disable onChanged if _areFieldsDisabled is true
//                           validator: !_areFieldsDisabled
//                               ? FormBuilderValidators.compose([
//                             // Uncomment or add validators as needed
//                             // FormBuilderValidators.required(),
//                           ])
//                               : null, // Disable validators if _areFieldsDisabled is true
//                           dropdownColor: Colors.grey,
//                           decoration: const InputDecoration(
//                             filled: true,
//                             fillColor: Color(0xFF252525),
//                             isDense: true,
//                             contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide.none,
//                               borderRadius: BorderRadius.all(Radius.circular(5)),
//                             ),
//                           ),
//                           disabledHint: const Text(""),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Rating ATS
//               CustomTextField(
//                 textTitle: "ATS Rating(A) :",
//                 isWantEdit: !_areFieldsDisabled && isAtsFieldsEnabled,
//                 onChanged: !_areFieldsDisabled && isAtsFieldsEnabled
//                     ? (val) => _onChanged(val, updatedValues, "Rating ATS")
//                     : null,
//                 validator: !_areFieldsDisabled && isAtsFieldsEnabled
//                     ? FormBuilderValidators.compose([
//                   // FormBuilderValidators.required(),
//                 ])
//                     : null,
//                 keyboardType: TextInputType.number,
//                 enabled: !_areFieldsDisabled && isAtsFieldsEnabled,
//               ),
//
//               // Model ATS
//               CustomTextField(
//                 textTitle: "ATS Model :",
//                 isWantEdit: !_areFieldsDisabled && isAtsFieldsEnabled,
//                 onChanged: !_areFieldsDisabled && isAtsFieldsEnabled
//                     ? (val) => _onChanged(val, updatedValues, "Model ATS")
//                     : null,
//                 validator: !_areFieldsDisabled && isAtsFieldsEnabled
//                     ? FormBuilderValidators.compose([
//                   // FormBuilderValidators.required(),
//                 ])
//                     : null,
//                 keyboardType: TextInputType.name,
//                 enabled: !_areFieldsDisabled && isAtsFieldsEnabled, // Ensure this field respects the enabled state
//               ),
//
//               //Feeder Cable
//               CustomTextField(
//                 textTitle: "Feeder Cable Size(mm^2) :",
//                 isWantEdit: !_areFieldsDisabled,
//                 onChanged: !_areFieldsDisabled
//                     ? (val) => _onChanged(val, updatedValues, "Feeder Size")
//                     : null,
//                 validator: !_areFieldsDisabled
//                     ? FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ])
//                     : null,
//                 keyboardType: TextInputType.number,
//               ),
//
//               //MCCB
//               CustomTextField(
//                 textTitle: "MCCB Rating(A) :",
//                 isWantEdit: !_areFieldsDisabled,
//                 onChanged: !_areFieldsDisabled
//                     ? (val) => _onChanged(val, updatedValues, "Rating MCCB")
//                     : null,
//                 validator: !_areFieldsDisabled
//                     ? FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ])
//                     : null,
//                 keyboardType: TextInputType.number,
//               ),
//
//
//               const Padding(
//                 padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
//                 child: Text(
//                   "Battery Details",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: mainTextColor),
//                 ),
//               ),
//
//               //Bat count
//               CustomTextField(
//                 textTitle: "Battery Count :",
//                 isWantEdit: !_areFieldsDisabled,
//                 onChanged: !_areFieldsDisabled
//                     ? (val) => _onChanged(val, updatedValues, "Battery Count")
//                     : null,
//                 validator: !_areFieldsDisabled
//                     ? FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ])
//                     : null,
//                 keyboardType: TextInputType.number,
//               ),
//
//               //Bat Brand
//               Card(
//                 color: suqarBackgroundColor,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const Text(
//                         "Battery Brand :",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12,
//                           color: mainTextColor,
//                         ),
//                       ),
//                       const SizedBox(width:10,), // Add some space between the label and the dropdown
//                       Expanded(
//                         child: DropdownButtonFormField<String>(
//                           value: batBrand.contains(updatedValues["Battery Brand"])
//                               ? updatedValues["Battery Brand"]
//                               : null, // Default value
//                           items: [
//                             ...batBrand.where((String value) => value != "Other").map((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                             const DropdownMenuItem<String>(
//                               value: "Other",
//                               child: Text("Other"),
//                             ),
//                           ],
//                           onChanged: !_areFieldsDisabled
//                               ? (val) {
//                             if (val == "Other") {
//                               _showCustomBrandDialog(
//                                 key: "Battery Brand",
//                                 brandList: batBrand,
//                                 formData: updatedValues,
//                                 formKey: "Battery Brand",
//                               );
//                             } else {
//                               _onChanged(val, updatedValues, "Battery Brand");
//                             }
//                           }
//                               : null, // Disable onChanged if _areFieldsDisabled is true
//                           validator: !_areFieldsDisabled
//                               ? FormBuilderValidators.compose([
//                             FormBuilderValidators.required(),
//                           ])
//                               : null, // Disable validators if _areFieldsDisabled is true
//                           dropdownColor: Colors.grey,
//                           decoration: const InputDecoration(
//                             filled: true,
//                             fillColor: Color(0xFF252525),
//                             isDense: true,
//                             contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide.none,
//                               borderRadius: BorderRadius.all(Radius.circular(5)),
//                             ),
//                           ),
//                           disabledHint: const Text(""),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               //Bat Capacity
//               CustomTextField(
//                 textTitle: "Battery Capacity(Ah) :",
//                 isWantEdit: !_areFieldsDisabled,
//                 onChanged: !_areFieldsDisabled
//                     ? (val) => _onChanged(val, updatedValues, "Battery Capacity")
//                     : null,
//                 validator: !_areFieldsDisabled
//                     ? FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ])
//                     : null,
//                 keyboardType: TextInputType.number,
//               ),
//
//
//               const Padding(
//                 padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
//                 child: Text(
//                   "Service Provider",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: mainTextColor),
//                 ),
//               ),
//
//               CustomTextField(
//                 textTitle: "Local Agent :",
//                 isWantEdit: !_areFieldsDisabled,
//                 onChanged: !_areFieldsDisabled
//                     ? (val) => _onChanged(val, updatedValues, "Local Agent")
//                     : null,
//                 validator: !_areFieldsDisabled
//                     ? FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ])
//                     : null,
//                 keyboardType: TextInputType.name,
//               ),
//
//               CustomTextField(
//                 textTitle: "Agent Address :",
//                 isWantEdit: !_areFieldsDisabled,
//                 onChanged: !_areFieldsDisabled
//                     ? (val) => _onChanged(val, updatedValues, "Agent Addr")
//                     : null,
//                 validator: !_areFieldsDisabled
//                     ? FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ])
//                     : null,
//                 keyboardType: TextInputType.name,
//               ),
//
//               CustomTextField(
//                 textTitle: "Agent Telephone :",
//                 isWantEdit: !_areFieldsDisabled,
//                 onChanged: !_areFieldsDisabled
//                     ? (val) => _onChanged(val, updatedValues, "Agent Tel")
//                     : null,
//                 validator: !_areFieldsDisabled
//                     ? (value) {
//                   if (value == null || value.isEmpty) {
//                     return null; // No validation error if the field is empty
//                   }
//                   if (value.length < 10) {
//                     return 'Please enter between\n 1 and 10 digits';
//                   }
//                   return null; // Valid input
//                 }
//                     : null,
//                 keyboardType: TextInputType.number,
//               ),
//
//
//
//               // Center(
//               //   child: Text(
//               //     "Update Details",
//               //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//               //   ),
//               // ),
//               //
//               // CustomTextField(
//               //   textTitle: "Updated By",
//               //   isWantEdit: true,
//               //   onChanged: (val) =>
//               //       _onChanged(val, updatedValues, "Updated By"),
//               //   // validator: FormBuilderValidators.compose([
//               //   //   FormBuilderValidators.required(),
//               //   // ]),
//               //   keyboardType: TextInputType.name,
//               // ),
//               // GestureDetector(
//               //   onTap: () {},
//               //   //_selectDate(context, "Last Updated"),
//               //   child: Card(
//               //     child: Padding(
//               //       padding: const EdgeInsets.all(10.0),
//               //       child: Row(
//               //         mainAxisAlignment: MainAxisAlignment.spaceAround,
//               //         children: [
//               //           Text(
//               //             "Updated",
//               //             style: TextStyle(
//               //                 fontWeight: FontWeight.w500, fontSize: 15),
//               //           ),
//               //           Spacer(),
//               //           Text(
//               //             updatedValues['Updated'] ?? 'Not Set',
//               //             style: TextStyle(fontSize: 15),
//               //           ),
//               //         ],
//               //       ),
//               //     ),
//               //   ),
//               // ),
//
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     style: ButtonStyle(
//                       backgroundColor:
//                       WidgetStatePropertyAll(mainTextColor),
//                       shape: MaterialStateProperty.all(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(6), // Customize the radius
//                         ),
//                       ),
//
//
//                     ),
//                     onPressed: () {
//                       if (_formKey.currentState!.saveAndValidate()) {
//                         print(updatedValues.toString());
//
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => HttpGeneratorGetPostPage(
//                               formData: updatedValues,
//                               Updator: updator,
//                             ),
//                           ),
//                         );
//                       }
//                     },
//                     child: const Text(
//                       'Submit',
//                       style: TextStyle(color: Color.fromARGB(255, 122, 76, 146)),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
// // Map<String, dynamic> _getEditedFields(
// //     Map<String, dynamic> updatedGeneratorDetails) {
// //   final editedFields = <String, dynamic>{};
// //   updatedGeneratorDetails.forEach((key, value) {
// //     if (originalValues[key] != value) {
// //       editedFields[key] = value;
// //     }
// //   });
// //   print(editedFields.toString());
// //   return editedFields;
// // }
// }
//
// class CustomTextField extends StatelessWidget {
//   final String textTitle;
//   final bool isWantEdit;
//   final void Function(String?)? onChanged;
//   final String? Function(String?)? validator;
//   final TextInputType keyboardType;
//   final bool enabled;
//
//   const CustomTextField({
//     Key? key,
//     required this.textTitle,
//     required this.isWantEdit,
//     this.onChanged,
//     this.validator,
//     this.enabled = true,
//     this.keyboardType = TextInputType.text,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: suqarBackgroundColor,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Text(
//               textTitle,
//               style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12,color: mainTextColor),
//             ),
//             SizedBox(width:10,),
//             Expanded(
//               child: FormBuilderTextField(
//                 name: textTitle, style: TextStyle(fontSize: 12,color: mainTextColor),
//                 enabled: isWantEdit,
//                 decoration: const InputDecoration(
//                   filled: true, // Enables background color
//                   fillColor: Color(0xFF252525), // Background color of the input field
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide.none, // Removes the border
//                     borderRadius: BorderRadius.all(Radius.circular(5)), // Optional: Rounded corners
//                   ),
//                   isDense: true,
//                   contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                   // Adjust padding if needed
//                 ),
//                 onChanged: onChanged,
//                 validator: validator,
//                 keyboardType: keyboardType,
//
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }






//
// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../../../Widgets/GPSGrab/gps_location_widget.dart';
// import '../../UserAccess.dart';
// import 'httpPostGen.dart';
//
//
//
// class GeneratorDetailAddPage  extends StatefulWidget {
//
//
//
//   GeneratorDetailAddPage({Key? key}) : super(key: key);
//
//
//   @override
//   _GeneratorDetailAddPageState createState() => _GeneratorDetailAddPageState();
//
// }
//
// class _GeneratorDetailAddPageState extends State<GeneratorDetailAddPage> {
//   final _formKey = GlobalKey<FormBuilderState>();
//   String updator="";
//   //late Map<String, dynamic> originalValues;
//   Map<String, dynamic> updatedValues = {};
//   bool _isLoading = false;
//   bool _isManual = false;
//   bool _isAuto = false;
//
//   String _latitude = '';
//   String _longitude = '';
//   String _error = '';
//   bool isControllerModelEnabled = true;
//   bool isAtsFieldsEnabled = true;
//   bool isDayTankSizeEnabled = true;
//   bool _areFieldsDisabled = false;
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
//     'UVA',
//     'Other'
//   ];
//
//   List<String> brandeng = ['Caterpillar', 'Chana', 'Cummins', 'Deutz', 'Detroit', 'Denyo', 'Greaves', 'Honda', 'Hyundai', 'Isuzu', 'John Deere', 'Komatsu', 'Kohler', 'Kubota', 'Lester', 'Mitsubishi', 'Onan', 'Perkins', 'Rusten', 'Unknown', 'Valmet', 'Volvo', 'Yanmar','Other'];
//   List<String> contBrand = ['DSE', 'HMI', 'Unknown','Other'];
//   List<String> brandset = ['Caterpillar', 'Cummins', 'Dale', 'Denyo', 'F.G.Wilson', 'Foracity', 'Greaves', 'John Deere', 'Jubilee', 'Kohler', 'Mitsui - Deutz', 'Mosa', 'Olympian', 'Onan', 'Pramac', 'Sanyo Denki', 'Siemens', 'Tempest', 'Unknown', 'Wega', 'Welland Power','Other'];
//   List<String> brandAlt=['Alsthom', 'Aulturdyne', 'Bosch', 'Caterpillar', 'Denyo', 'Greaves', 'Iskra', 'Kohler', 'Leroy Somer', 'Marelli', 'Mecc Alte', 'Mitsubishi', 'Perkins', 'Sanyo Denki', 'Siemens', 'Stamford', 'Taiyo', 'Tempest', 'Unknown', 'Wega','Other'];
//   List<String> brandAts=['Schnider', 'Cummins', 'Socomec','Unknown','Other'];
//   List<String> batBrand=['Amaron', 'Exide', 'Luminous','Volta','Okaya','LivGuard','Su-Kam','Shield','Other'];
//
//
//   void _fetchLocation() async {
//     setState(() {
//       _isLoading = true;
//       _error = ''; // Reset error message when starting to fetch location
//     });
//
//     try {
//       GPSLocationFetcher locationFetcher = GPSLocationFetcher();
//       Map<String, String> location = await locationFetcher.fetchLocation();
//
//       // Debug print to check the location map
//       debugPrint("Fetched location data: $location");
//
//       if (location.containsKey('latitude') && location.containsKey('longitude')) {
//         setState(() {
//           _latitude = location['latitude'] ?? '';
//           _longitude = location['longitude'] ?? '';
//           updatedValues['Latitude'] = _latitude; // Ensure you use 'Latitude' if it needs to be uppercase
//           updatedValues['Longitude'] = _longitude; // Ensure you use 'Longitude' if it needs to be uppercase
//           _isLoading = false;
//           debugPrint("Location $_latitude, $_longitude");
//         });
//       } else {
//         throw Exception('Location data is missing');
//       }
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//         debugPrint("Error: $_error");
//         _isLoading = false;
//       });
//     }
//   }
//
//
//
//   @override
//   void initState() {
//     super.initState();
//
//     updatedValues.addAll({"clockTime": ""});
//   }
//
//   void _onChanged(
//       dynamic val, Map<String, dynamic> formData, String fieldName) {
//     setState(() {
//       formData[fieldName] = val;
//
//       //updatedValues[fieldName] = val;
//     });
//   }
//
//   // void _selectDate(BuildContext context) async {
//   //   final DateTime? pickedDate = await showDatePicker(
//   //     context: context,
//   //     //initialDate: _selectedDate ?? DateTime.now(),
//   //     firstDate: DateTime(2000),
//   //     lastDate: DateTime(2101),
//   //   );
//   //
//   //   if (pickedDate != null && pickedDate != _selectedDate) {
//   //     setState(() {
//   //       _selectedDate = pickedDate;
//   //       _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
//   //       updatedValues['Installed Date'] =
//   //           DateFormat('yyyy-MM-dd').format(pickedDate);
//   //     });
//   //   }
//   // }
//
//   void _showCustomBrandDialog({
//     required String key,
//     required List<String?> brandList,
//     required Map<String, dynamic> formData,
//     required String formKey, // A unique key for the form
//   }) {
//     TextEditingController customBrandController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: const ColorScheme.light(primary: Colors.green),
//           ),
//           child: AlertDialog(
//             title: const Text("Add Custom Brand"),
//             content: TextField(
//               controller: customBrandController,
//               decoration: const InputDecoration(
//                 hintText: "Enter your brand name",
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text("Cancel"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               TextButton(
//                 child: const Text("OK"),
//                 onPressed: () {
//                   String customBrand = customBrandController.text.trim();
//                   if (customBrand.isNotEmpty) {
//                     setState(() {
//                       if (!brandList.contains(customBrand)) {
//                         brandList.add(customBrand);
//                       }
//                       formData[formKey] = customBrand;
//                     });
//                   }
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     UserAccess userAccess = Provider.of<UserAccess>(context, listen: true); // Use listen: true to rebuild the widget when the data changes
//     updator=userAccess.username!;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add DEG Details'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: FormBuilder(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               const Center(
//                 child: Text(
//                   "Location",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                 ),
//               ),
//
//               //Province
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Province",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 15,
//                         ),
//                       ),
//                       const SizedBox(height: 10), // Add some space between the label and the dropdown
//                       DropdownButtonFormField<String>(
//                         value: Regions.contains(updatedValues["Province"])
//                             ? updatedValues["Province"]
//                             : null, // Default value
//                         items: [
//                           ...Regions.where((String value) => value != "Other").map((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                           const DropdownMenuItem<String>(
//                             value: "Other",
//                             child: Text("Other"),
//                           ),
//                         ],
//                         onChanged: (val) {
//                           if (val == "Other") {
//                             _showCustomBrandDialog(
//                               key: "Province",
//                               brandList: Regions,
//                               formData: updatedValues,
//                               formKey: "Province",
//                             );
//                           } else {
//                             _onChanged(val, updatedValues, "Province");
//                           }
//                         },
//                         validator: FormBuilderValidators.compose([
//                           // Uncomment or add validators as needed
//                           // FormBuilderValidators.required(),
//                         ]),
//                         decoration: const InputDecoration(
//                           contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                           border: OutlineInputBorder(), // Add a border around the dropdown
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //Rtom
//               CustomTextField(
//                 textTitle: "Rtom Name",
//                 isWantEdit: true,
//                 onChanged: (val) => _onChanged(val, updatedValues, "Rtom Name"),
//                 validator: FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ]),
//                 keyboardType: TextInputType.name,
//               ),
//               //Station
//               CustomTextField(
//                 textTitle: "Station",
//                 isWantEdit: true,
//                 onChanged: (val) => _onChanged(val, updatedValues, "Station"),
//                 validator: FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ]),
//                 keyboardType: TextInputType.name,
//               ),
//               // GPS Location Card
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       const Text(
//                         "Location Set As",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500, fontSize: 15),
//                       ),
//                       const Spacer(),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Checkbox(
//                                 value: _isManual,
//                                 onChanged: (bool? value) {
//                                   setState(() {
//                                     _isManual = value!;
//                                     if (value == true) _isAuto = false;
//                                     if (_isAuto) _fetchLocation(); // Fetch location only if auto is true
//                                   });
//                                 },
//                               ),
//                               const Text("Manual"),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Checkbox(
//                                 value: _isAuto,
//                                 onChanged: (bool? value) {
//                                   setState(() {
//                                     _isAuto = value!;
//                                     if (value == true) _isManual = false;
//                                     if (_isAuto) _fetchLocation(); // Fetch location only if auto is true
//                                   });
//                                 },
//                               ),
//                               const Text("Auto"),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
// // Display Location or Manual Entry
//               _isManual
//                   ? Column(
//                 children: [
//                   CustomTextField(
//                     textTitle: "Latitude",
//                     isWantEdit: true,
//                     keyboardType: TextInputType.number,
//                     onChanged: (val) {
//                       _onChanged(val, updatedValues, "Latitude");
//                     },
//                     validator: FormBuilderValidators.compose([
//                       FormBuilderValidators.required(),
//                       FormBuilderValidators.numeric()
//                     ]),
//                   ),
//                   CustomTextField(
//                     textTitle: "Longitude",
//                     isWantEdit: true,
//                     keyboardType: TextInputType.number,
//                     onChanged: (val) {
//                       _onChanged(val, updatedValues, "Longitude");
//                     },
//                     validator: FormBuilderValidators.compose([
//                       FormBuilderValidators.required(),
//                       FormBuilderValidators.numeric()
//                     ]),
//                   ),
//                 ],
//               )
//                   : Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     children: [
//                       const Text(
//                         "Location",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500, fontSize: 15),
//                       ),
//                       const Spacer(),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Text("Latitude : ${updatedValues['Latitude'] ?? 'N/A'}"),
//                           Text("Longitude : ${updatedValues['Longitude'] ?? 'N/A'}"),
//                           if (_isLoading)
//                             const CircularProgressIndicator(), // Show progress indicator when loading
//                           if (_error.isNotEmpty)
//                             Text(
//                               "Error turn on location",
//                               style: const TextStyle(color: Colors.red),
//                             ), // Show error message if any
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               const Center(
//                 child: Text(
//                   "Genaral Details",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                 ),
//               ),
//
//               //Available
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     children: [
//                       const Text(
//                         "DEG Available",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 15,
//                         ),
//                       ),
//                       const Spacer(),
//                       Expanded(
//                         child: FormBuilderChoiceChip<String>(
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           name: 'Available',
//                           initialValue: updatedValues['Available'],
//                           selectedColor: Colors.lightBlueAccent,
//                           options: const [
//                             FormBuilderChipOption(
//                               value: 'Yes',
//                               avatar: CircleAvatar(child: Text('')),
//                             ),
//                             FormBuilderChipOption(
//                               value: 'No',
//                               avatar: CircleAvatar(child: Text('')),
//                             ),
//                           ],
//                           onChanged: (val) {
//                             setState(() {
//                               _onChanged(val, updatedValues, 'Available');
//                               _areFieldsDisabled = val == 'No'; // Disable fields if 'No' is selected
//                             });
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //Category
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     children: [
//                       const Text(
//                         "DEG Category",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500, fontSize: 15),
//                       ),
//                       const Spacer(),
//                       Expanded(
//                         child: FormBuilderChoiceChip<String>(
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           //decoration: const InputDecoration(labelText: 'Type'),
//                           name: 'Category',
//                           initialValue: updatedValues['Category'],
//                           selectedColor: Colors.lightBlueAccent,
//                           options: const [
//                             FormBuilderChipOption(
//                               value: 'Fixed',
//                               avatar: CircleAvatar(child: Text('')),
//                             ),
//                             FormBuilderChipOption(
//                               value: 'Mobile',
//                               avatar: CircleAvatar(child: Text('')),
//                             ),
//                             FormBuilderChipOption(
//                               value: 'Portable',
//                               avatar: CircleAvatar(child: Text('')),
//                             ),
//                           ],
//                           // onChanged: _onChanged,
//
//                           onChanged: _areFieldsDisabled ? null : (val) { // Disable onChanged if fields are disabled
//                             setState(() {
//                               _onChanged(val, updatedValues, 'Category');
//                               print(updatedValues['Category']);
//                             });
//                           },
//                           enabled: !_areFieldsDisabled,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //Mode
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     children: [
//                       const Text(
//                         "Mode",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500, fontSize: 15),
//                       ),
//                       const Spacer(),
//                       Expanded(
//                         child: FormBuilderChoiceChip<String>(
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           //decoration: const InputDecoration(labelText: 'Type'),
//                           name: 'Mode',
//                           initialValue: updatedValues['Mode'],
//                           selectedColor: Colors.lightBlueAccent,
//                           options: const [
//                             FormBuilderChipOption(
//                               value: 'A',
//                               child: Text('Auto'),
//                               // avatar: CircleAvatar(child: Text('')),
//                             ),
//                             FormBuilderChipOption(
//                               value: 'M',
//                               child: Text('Manual'),
//                               //avatar: CircleAvatar(child: Text('')),
//                             ),
//                           ],
//                           // onChanged: _onChanged,
//
//                           onChanged: _areFieldsDisabled ? null : (val) { // Disable onChanged if fields are disabled
//                             setState(() {
//                               _onChanged(val, updatedValues, 'Mode');
//                               print(updatedValues['Mode']);
//                             });
//                           },
//                           enabled: !_areFieldsDisabled,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //Phase
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     children: [
//                       const Text(
//                         "Phase Eng",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500, fontSize: 15),
//                       ),
//                       const Spacer(),
//                       Expanded(
//                         child: FormBuilderChoiceChip<String>(
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           //decoration: const InputDecoration(labelText: 'Type'),
//                           name: 'Phase Eng',
//                           initialValue: updatedValues['Phase Eng'],
//                           selectedColor: Colors.lightBlueAccent,
//                           options: const [
//                             FormBuilderChipOption(
//                               value: '1',
//                               avatar: CircleAvatar(child: Text('')),
//                             ),
//                             FormBuilderChipOption(
//                               value: '3',
//                               avatar: CircleAvatar(child: Text('')),
//                             ),
//                           ],
//                           // onChanged: _onChanged,
//
//                           onChanged: _areFieldsDisabled ? null : (val) { // Disable onChanged if fields are disabled
//                             setState(() {
//                               _onChanged(val, updatedValues, 'Phase Eng');
//                               print(updatedValues['Phase Eng']);
//                             });
//                           },
//                           enabled: !_areFieldsDisabled,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //YOM
//               CustomTextField(
//                 textTitle: "Year of Manufacture",
//                 isWantEdit: !_areFieldsDisabled,
//                 onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Year of Manufacture"),
//                 validator: (value) {
//                   if (_areFieldsDisabled) {
//                     return null; // Disable validation when fields are disabled
//                   }
//
//                   if (value == null || value.isEmpty) {
//                     return 'This field is required';
//                   }
//
//                   // Check if the input is a valid number
//                   final number = int.tryParse(value);
//                   if (number == null) {
//                     return 'Please enter a\n valid number';
//                   }
//
//                   // Check if the number is within the specified range
//                   if (number < 1900 || number > 3000) {
//                     return 'Please enter a number\n between 1900 and 3000';
//                   }
//
//                   // Check if the input length is exactly 4 digits
//                   if (value.length != 4) {
//                     return 'Please enter exactly\n 4 digits';
//                   }
//
//                   return null; // Valid input
//                 },
//                 keyboardType: TextInputType.number,
//               ),
//               //YOI
//               CustomTextField(
//                 textTitle: "Year of Install",
//                 isWantEdit: !_areFieldsDisabled,
//                 onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Year of Install"),
//                 validator: (value) {
//                   if (_areFieldsDisabled) {
//                     return null; // Disable validation when fields are disabled
//                   }
//
//                   if (value == null || value.isEmpty) {
//                     return 'This field is required';
//                   }
//
//                   // Check if the input is a valid number
//                   final number = int.tryParse(value);
//                   if (number == null) {
//                     return 'Please enter a\n valid number';
//                   }
//
//                   // Check if the number is within the specified range
//                   if (number < 1900 || number > 3000) {
//                     return 'Please enter a number\n between 1900 and 3000';
//                   }
//
//                   // Check if the input length is exactly 4 digits
//                   if (value.length != 4) {
//                     return 'Please enter exactly\n 4 digits';
//                   }
//
//                   return null; // Valid input
//                 },
//                 keyboardType: TextInputType.number,
//               ),
//               //Set Capacity
//               CustomTextField(
//                 textTitle: "Set Capacity(kVA)",
//                 isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
//                 onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Set Cap"),
//                 validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ]),
//                 keyboardType: TextInputType.number,
//
//               ),
//
//               const Center(
//                 child: Text(
//                   "Generator Specifications",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                 ),
//               ),
//
//               //Brand Alt
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Alternator Brand",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 15,
//                         ),
//                       ),
//                       const SizedBox(height: 10), // Add some space between the label and the dropdown
//                       DropdownButtonFormField<String>(
//                         value: brandAlt.contains(updatedValues["Brand Alt"])
//                             ? updatedValues["Brand Alt"]
//                             : null, // Default value
//                         items: [
//                           ...brandAlt.where((String value) => value != "Other").map((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                           const DropdownMenuItem<String>(
//                             value: "Other",
//                             child: Text("Other"),
//                           ),
//                         ],
//                         onChanged: _areFieldsDisabled ? null : (val) {
//                           if (val == "Other") {
//                             _showCustomBrandDialog(
//                               key: "Brand Alt",
//                               brandList: brandAlt,
//                               formData: updatedValues,
//                               formKey: "Brand Alt",
//                             );
//                           } else {
//                             _onChanged(val, updatedValues, "Brand Alt");
//                           }
//                         },
//                         validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
//                           // Uncomment or add validators as needed
//                           FormBuilderValidators.required(),
//                         ]),
//                         decoration: const InputDecoration(
//                           contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                           border: OutlineInputBorder(), // Add a border around the dropdown
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //Model Alt
//               CustomTextField(
//                 textTitle: "Alternator Model",
//                 isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
//                 onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Model Alt"),
//                 validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ]),
//                 keyboardType: TextInputType.name,
//               ),
//               //Serial Alt
//               CustomTextField(
//                 textTitle: "Alternator serial",
//                 isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
//                 onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Serial Alt"),
//                 validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ]),
//                 keyboardType: TextInputType.number,
//               ),
//
//               //Brand Eng
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Engine Brand",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 15,
//                         ),
//                       ),
//                       const SizedBox(height: 10), // Add some space between the label and the dropdown
//                       DropdownButtonFormField<String>(
//                         value: brandeng.contains(updatedValues["Brand Eng"])
//                             ? updatedValues["Brand Eng"]
//                             : null, // Default value
//                         items: [
//                           ...brandeng.where((String value) => value != "Other").map((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                           const DropdownMenuItem<String>(
//                             value: "Other",
//                             child: Text("Other"),
//                           ),
//                         ],
//                         onChanged: _areFieldsDisabled ? null : (val){
//                           if (val == "Other") {
//                             _showCustomBrandDialog(
//                               key: "Brand Eng",
//                               brandList: brandeng,
//                               formData: updatedValues,
//                               formKey: "Brand Eng",
//                             );
//                           } else {
//                             _onChanged(val, updatedValues, "Brand Eng");
//                           }
//                         },
//                         validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
//                           FormBuilderValidators.required(),
//                         ]),
//                         decoration: const InputDecoration(
//                           contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //Model eng
//               CustomTextField(
//                 textTitle: "Engine Model",
//                 isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
//                 onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Model Eng"),
//                 validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ]),
//                 keyboardType: TextInputType.name,
//               ),
//               //Serial Eng
//               CustomTextField(
//                 textTitle: "Engine Serial",
//                 isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
//                 onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Serial Eng"),
//                 validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ]),
//                 keyboardType: TextInputType.number,
//               ),
//
//               //Brand Set
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Set Brand",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 15,
//                         ),
//                       ),
//                       const SizedBox(height: 10), // Add some space between the label and the dropdown
//                       DropdownButtonFormField<String>(
//                         value: brandset.contains(updatedValues["Brand Set"])
//                             ? updatedValues["Brand Set"]
//                             : null, // Default value
//                         items: [
//                           ...brandset.where((String value) => value != "Other").map((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                           const DropdownMenuItem<String>(
//                             value: "Other",
//                             child: Text("Other"),
//                           ),
//                         ],
//                         onChanged: _areFieldsDisabled ? null : (val) {
//                           if (val == "Other") {
//                             _showCustomBrandDialog(
//                               key: "Brand Set",
//                               brandList: brandset,
//                               formData: updatedValues,
//                               formKey: "Brand Set",
//                             );
//                           } else {
//                             _onChanged(val, updatedValues, "Brand Set");
//                           }
//                         },
//                         validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
//                           FormBuilderValidators.required(),
//                         ]),
//                         decoration: const InputDecoration(
//                           contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //Model Set
//               CustomTextField(
//                 textTitle: "Set Model",
//                 isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
//                 onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Model Set"),
//                 validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ]),
//                 keyboardType: TextInputType.name,
//               ),
//               //Serial Set
//               CustomTextField(
//                 textTitle: "Set Serial",
//                 isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
//                 onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Serial Set"),
//                 validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ]),
//                 keyboardType: TextInputType.number,
//               ),
//
//               const Center(
//                 child: Text(
//                   "Controller Details",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                 ),
//               ),
//
//               //Controller
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Controller Brand",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 15,
//                         ),
//                       ),
//                       const SizedBox(height: 10), // Add some space between the label and the dropdown
//                       DropdownButtonFormField<String>(
//                         value: contBrand.contains(updatedValues["Controller"])
//                             ? updatedValues["Controller"]
//                             : null, // Default value
//                         items: [
//                           ...contBrand.where((String value) => value != "Other").map((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                           const DropdownMenuItem<String>(
//                             value: "Other",
//                             child: Text("Other"),
//                           ),
//                           const DropdownMenuItem<String>(
//                             value: "Not Available",
//                             child: Text("Not Available"),
//                           ),
//                         ],
//                         onChanged: _areFieldsDisabled ? null : (val) {
//                           if (val == "Not Available") {
//                             setState(() {
//                               isControllerModelEnabled = false;
//                             });
//                             _onChanged(null, updatedValues, "Controller Model"); // Clear the model value if disabled
//                           } else {
//                             setState(() {
//                               isControllerModelEnabled = true;
//                             });
//                             _onChanged(val, updatedValues, "Controller");
//                           }
//
//                           if (val == "Other") {
//                             _showCustomBrandDialog(
//                               key: "Controller",
//                               brandList: contBrand,
//                               formData: updatedValues,
//                               formKey: "Controller",
//                             );
//                           } else {
//                             _onChanged(val, updatedValues, "Controller");
//                           }
//                         },
//                         validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
//                           // Uncomment or add validators as needed
//                           //FormBuilderValidators.required(),
//                         ]),
//                         decoration: const InputDecoration(
//                           contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//
//                     ],
//                   ),
//                 ),
//               ),
//               //Controller Model
//               CustomTextField(
//                 textTitle: "Controller Model",
//                 isWantEdit: isControllerModelEnabled,
//                 onChanged: (val) =>
//                     _onChanged(val, updatedValues, "Controller Model"),
//                 validator: isControllerModelEnabled
//                     ? FormBuilderValidators.compose([
//                   //FormBuilderValidators.required(),
//                 ])
//                     : null,
//                 keyboardType: TextInputType.name,
//                 enabled: isControllerModelEnabled, // This will disable the field if false
//               ),
//
//
//               const Center(
//                 child: Text(
//                   "Tank Details",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                 ),
//               ),
//
//               //Tank cap Prime
//               CustomTextField(
//                 textTitle: "Day Tank Capacity(L)",
//                 isWantEdit: !_areFieldsDisabled,
//                 onChanged: !_areFieldsDisabled
//                     ? (val) => _onChanged(val, updatedValues, "Tank Prime")
//                     : null,
//                 validator: !_areFieldsDisabled
//                     ? FormBuilderValidators.compose([
//                   // FormBuilderValidators.required(),
//                   // Add other validators here if needed
//                 ])
//                     : null,
//                 keyboardType: TextInputType.number,
//                 enabled: !_areFieldsDisabled, // Ensure this field respects the disabled state
//               ),
//
//
//
//               //Bulk tank Available
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     children: [
//                       const Text(
//                         "Bulk Tank Available",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500, fontSize: 15),
//                       ),
//                       const Spacer(),
//                       Expanded(
//                         child: FormBuilderChoiceChip<String>(
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           name: 'Bulk Tank',
//                           initialValue: updatedValues['Bulk Tank'],
//                           selectedColor: Colors.lightBlueAccent,
//                           options: const [
//                             FormBuilderChipOption(
//                               value: '1',
//                               child: Text('Yes'),
//                             ),
//                             FormBuilderChipOption(
//                               value: '0',
//                               child: Text('No'),
//                             ),
//                           ],
//                           onChanged: !_areFieldsDisabled ? (val) {
//                             setState(() {
//                               if (val == '0') {
//                                 isDayTankSizeEnabled = false;
//                                 _onChanged(null, updatedValues, 'Day Tank Size');
//                               } else {
//                                 isDayTankSizeEnabled = true;
//                               }
//                               _onChanged(val, updatedValues, 'Day Tank');
//                             });
//                           } : null, // Disable onChanged if fields are disabled
//                           enabled: !_areFieldsDisabled, // Disable the chip if fields are disabled
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//
//               //Bulk Tank Size(L)
//               CustomTextField(
//                 textTitle: "Bulk Tank Size(L)",
//                 isWantEdit: !_areFieldsDisabled && isDayTankSizeEnabled,
//                 onChanged: (!_areFieldsDisabled && isDayTankSizeEnabled)
//                     ? (val) => _onChanged(val, updatedValues, "Bulk Tank Size")
//                     : null,
//                 validator: (!_areFieldsDisabled && isDayTankSizeEnabled)
//                     ? FormBuilderValidators.compose([
//                   // FormBuilderValidators.required(),
//                   // Add other validators here if needed
//                 ])
//                     : null,
//                 keyboardType: TextInputType.number,
//                 enabled: !_areFieldsDisabled && isDayTankSizeEnabled, // Ensure this field respects both states
//               ),
//
//
//
//
//               const Center(
//                 child: Text(
//                   "ATS and Cabling",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                 ),
//               ),
//
//               //Brand ATS
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "ATS Brand",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 15,
//                         ),
//                       ),
//                       const SizedBox(height: 10), // Add some space between the label and the dropdown
//                       DropdownButtonFormField<String>(
//                         value: brandAts.contains(updatedValues["BrandATS"])
//                             ? updatedValues["BrandATS"]
//                             : null, // Default value
//                         items: [
//                           ...brandAts.where((String value) => value != "Other").map((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                           const DropdownMenuItem<String>(
//                             value: "Other",
//                             child: Text("Other"),
//                           ),
//                           const DropdownMenuItem<String>(
//                             value: "Not Available",
//                             child: Text("Not Available"),
//                           ),
//                         ],
//                         onChanged: !_areFieldsDisabled
//                             ? (val) {
//                           setState(() {
//                             if (val == "Not Available") {
//                               isAtsFieldsEnabled = false;
//                               // Clear the values and validators for the disabled fields
//                               _onChanged(null, updatedValues, "Rating ATS");
//                               _onChanged(null, updatedValues, "Model ATS");
//                             } else {
//                               isAtsFieldsEnabled = true;
//                             }
//                             _onChanged(val, updatedValues, "BrandATS");
//                           });
//
//                           if (val == "Other") {
//                             _showCustomBrandDialog(
//                               key: "BrandATS",
//                               brandList: brandAts,
//                               formData: updatedValues,
//                               formKey: "BrandATS",
//                             );
//                           } else {
//                             _onChanged(val, updatedValues, "BrandATS");
//                           }
//                         }
//                             : null, // Disable onChanged if _areFieldsDisabled is true
//                         validator: !_areFieldsDisabled
//                             ? FormBuilderValidators.compose([
//                           // Uncomment or add validators as needed
//                           // FormBuilderValidators.required(),
//                         ])
//                             : null, // Disable validators if _areFieldsDisabled is true
//                         decoration: const InputDecoration(
//                           contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                           border: OutlineInputBorder(),
//                         ),
//                         disabledHint: const Text(""),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Rating ATS
//               CustomTextField(
//                 textTitle: "ATS Rating(A)",
//                 isWantEdit: !_areFieldsDisabled && isAtsFieldsEnabled,
//                 onChanged: !_areFieldsDisabled && isAtsFieldsEnabled
//                     ? (val) => _onChanged(val, updatedValues, "Rating ATS")
//                     : null,
//                 validator: !_areFieldsDisabled && isAtsFieldsEnabled
//                     ? FormBuilderValidators.compose([
//                   // FormBuilderValidators.required(),
//                 ])
//                     : null,
//                 keyboardType: TextInputType.number,
//                 enabled: !_areFieldsDisabled && isAtsFieldsEnabled,
//               ),
//
//               // Model ATS
//               CustomTextField(
//                 textTitle: "ATS Model",
//                 isWantEdit: !_areFieldsDisabled && isAtsFieldsEnabled,
//                 onChanged: !_areFieldsDisabled && isAtsFieldsEnabled
//                     ? (val) => _onChanged(val, updatedValues, "Model ATS")
//                     : null,
//                 validator: !_areFieldsDisabled && isAtsFieldsEnabled
//                     ? FormBuilderValidators.compose([
//                   // FormBuilderValidators.required(),
//                 ])
//                     : null,
//                 keyboardType: TextInputType.name,
//                 enabled: !_areFieldsDisabled && isAtsFieldsEnabled, // Ensure this field respects the enabled state
//               ),
//
//               //Feeder Cable
//               CustomTextField(
//                 textTitle: "Feeder Cable Size(mm^2)",
//                 isWantEdit: !_areFieldsDisabled,
//                 onChanged: !_areFieldsDisabled
//                     ? (val) => _onChanged(val, updatedValues, "Feeder Size")
//                     : null,
//                 validator: !_areFieldsDisabled
//                     ? FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ])
//                     : null,
//                 keyboardType: TextInputType.number,
//               ),
//
//               //MCCB
//               CustomTextField(
//                 textTitle: "MCCB Rating(A)",
//                 isWantEdit: !_areFieldsDisabled,
//                 onChanged: !_areFieldsDisabled
//                     ? (val) => _onChanged(val, updatedValues, "Rating MCCB")
//                     : null,
//                 validator: !_areFieldsDisabled
//                     ? FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ])
//                     : null,
//                 keyboardType: TextInputType.number,
//               ),
//
//
//               const Center(
//                 child: Text(
//                   "Battery Details",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                 ),
//               ),
//
//               //Bat count
//               CustomTextField(
//                 textTitle: "Battery Count",
//                 isWantEdit: !_areFieldsDisabled,
//                 onChanged: !_areFieldsDisabled
//                     ? (val) => _onChanged(val, updatedValues, "Battery Count")
//                     : null,
//                 validator: !_areFieldsDisabled
//                     ? FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ])
//                     : null,
//                 keyboardType: TextInputType.number,
//               ),
//
//               //Bat Brand
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Battery Brand",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 15,
//                         ),
//                       ),
//                       const SizedBox(height: 10), // Add some space between the label and the dropdown
//                       DropdownButtonFormField<String>(
//                         value: batBrand.contains(updatedValues["Battery Brand"])
//                             ? updatedValues["Battery Brand"]
//                             : null, // Default value
//                         items: [
//                           ...batBrand.where((String value) => value != "Other").map((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                           const DropdownMenuItem<String>(
//                             value: "Other",
//                             child: Text("Other"),
//                           ),
//                         ],
//                         onChanged: !_areFieldsDisabled
//                             ? (val) {
//                           if (val == "Other") {
//                             _showCustomBrandDialog(
//                               key: "Battery Brand",
//                               brandList: batBrand,
//                               formData: updatedValues,
//                               formKey: "Battery Brand",
//                             );
//                           } else {
//                             _onChanged(val, updatedValues, "Battery Brand");
//                           }
//                         }
//                             : null, // Disable onChanged if _areFieldsDisabled is true
//                         validator: !_areFieldsDisabled
//                             ? FormBuilderValidators.compose([
//                           FormBuilderValidators.required(),
//                         ])
//                             : null, // Disable validators if _areFieldsDisabled is true
//                         decoration: const InputDecoration(
//                           contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                           border: OutlineInputBorder(),
//                         ),
//                         disabledHint: const Text(""),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               //Bat Capacity
//               CustomTextField(
//                 textTitle: "Battery Capacity(Ah)",
//                 isWantEdit: !_areFieldsDisabled,
//                 onChanged: !_areFieldsDisabled
//                     ? (val) => _onChanged(val, updatedValues, "Battery Capacity")
//                     : null,
//                 validator: !_areFieldsDisabled
//                     ? FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ])
//                     : null,
//                 keyboardType: TextInputType.number,
//               ),
//
//
//               const Center(
//                 child: Text(
//                   "Service Provider",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                 ),
//               ),
//
//               CustomTextField(
//                 textTitle: "Local Agent",
//                 isWantEdit: !_areFieldsDisabled,
//                 onChanged: !_areFieldsDisabled
//                     ? (val) => _onChanged(val, updatedValues, "Local Agent")
//                     : null,
//                 validator: !_areFieldsDisabled
//                     ? FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ])
//                     : null,
//                 keyboardType: TextInputType.name,
//               ),
//
//               CustomTextField(
//                 textTitle: "Agent Address",
//                 isWantEdit: !_areFieldsDisabled,
//                 onChanged: !_areFieldsDisabled
//                     ? (val) => _onChanged(val, updatedValues, "Agent Addr")
//                     : null,
//                 validator: !_areFieldsDisabled
//                     ? FormBuilderValidators.compose([
//                   FormBuilderValidators.required(),
//                 ])
//                     : null,
//                 keyboardType: TextInputType.name,
//               ),
//
//               CustomTextField(
//                 textTitle: "Agent Telephone",
//                 isWantEdit: !_areFieldsDisabled,
//                 onChanged: !_areFieldsDisabled
//                     ? (val) => _onChanged(val, updatedValues, "Agent Tel")
//                     : null,
//                 validator: !_areFieldsDisabled
//                     ? (value) {
//                   if (value == null || value.isEmpty) {
//                     return null; // No validation error if the field is empty
//                   }
//                   if (value.length < 10) {
//                     return 'Please enter between\n 1 and 10 digits';
//                   }
//                   return null; // Valid input
//                 }
//                     : null,
//                 keyboardType: TextInputType.number,
//               ),
//
//
//
//               // Center(
//               //   child: Text(
//               //     "Update Details",
//               //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//               //   ),
//               // ),
//               //
//               // CustomTextField(
//               //   textTitle: "Updated By",
//               //   isWantEdit: true,
//               //   onChanged: (val) =>
//               //       _onChanged(val, updatedValues, "Updated By"),
//               //   // validator: FormBuilderValidators.compose([
//               //   //   FormBuilderValidators.required(),
//               //   // ]),
//               //   keyboardType: TextInputType.name,
//               // ),
//               // GestureDetector(
//               //   onTap: () {},
//               //   //_selectDate(context, "Last Updated"),
//               //   child: Card(
//               //     child: Padding(
//               //       padding: const EdgeInsets.all(10.0),
//               //       child: Row(
//               //         mainAxisAlignment: MainAxisAlignment.spaceAround,
//               //         children: [
//               //           Text(
//               //             "Updated",
//               //             style: TextStyle(
//               //                 fontWeight: FontWeight.w500, fontSize: 15),
//               //           ),
//               //           Spacer(),
//               //           Text(
//               //             updatedValues['Updated'] ?? 'Not Set',
//               //             style: TextStyle(fontSize: 15),
//               //           ),
//               //         ],
//               //       ),
//               //     ),
//               //   ),
//               // ),
//
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     style: const ButtonStyle(
//                         backgroundColor:
//                         WidgetStatePropertyAll(Colors.blueAccent)),
//                     onPressed: () {
//                       if (_formKey.currentState!.saveAndValidate()) {
//                         print(updatedValues.toString());
//
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => HttpGeneratorGetPostPage(
//                               formData: updatedValues,
//                               Updator: updator,
//                             ),
//                           ),
//                         );
//                       }
//                     },
//                     child: const Text(
//                       'Submit',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
// // Map<String, dynamic> _getEditedFields(
// //     Map<String, dynamic> updatedGeneratorDetails) {
// //   final editedFields = <String, dynamic>{};
// //   updatedGeneratorDetails.forEach((key, value) {
// //     if (originalValues[key] != value) {
// //       editedFields[key] = value;
// //     }
// //   });
// //   print(editedFields.toString());
// //   return editedFields;
// // }
// }
//
// class CustomTextField extends StatelessWidget {
//   final String textTitle;
//   final bool isWantEdit;
//   final void Function(String?)? onChanged;
//   final String? Function(String?)? validator;
//   final TextInputType keyboardType;
//   final bool enabled;
//
//   const CustomTextField({
//     Key? key,
//     required this.textTitle,
//     required this.isWantEdit,
//     this.onChanged,
//     this.validator,
//     this.enabled = true,
//     this.keyboardType = TextInputType.text,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Text(
//               textTitle,
//               style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
//             ),
//             const Spacer(),
//             Expanded(
//               child: FormBuilderTextField(
//                 name: textTitle,
//                 enabled: isWantEdit,
//                 decoration: const InputDecoration(
//                   border: UnderlineInputBorder(), // Underline border style
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey), // Border color when enabled
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue), // Border color when focused
//                   ),
//                   contentPadding: EdgeInsets.only(bottom: 8), // Adjust padding if needed
//                 ),
//                 onChanged: onChanged,
//                 validator: validator,
//                 keyboardType: keyboardType,
//
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// //v2 working
//
// // //Gathering of Generator data though user forum
// //
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter_form_builder/flutter_form_builder.dart';
// // import 'package:form_builder_validators/form_builder_validators.dart';
// //
// //
// // import '../../../Widgets/GPSGrab/gps_location_widget.dart';
// // import '../../UserAccess.dart';
// // import 'httpPostGen.dart';
// // import 'package:provider/provider.dart';
// //
// //
// //
// // class GatherGenData extends StatefulWidget {
// //   @override
// //   _GatherGenDataState createState() => _GatherGenDataState();
// // }
// //
// // class _GatherGenDataState extends State<GatherGenData> {
// //   @override
// //   Widget build(BuildContext context) {
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Add Gen Info'),
// //       ),
// //       body: Center(
// //         child: CompleteForm(),
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// // class CompleteForm extends StatefulWidget {
// //   const CompleteForm({Key? key}) : super(key: key);
// //
// //   @override
// //   State<CompleteForm> createState() {
// //     return _CompleteFormState();
// //   }
// // }
// //
// // class _CompleteFormState extends State<CompleteForm> {
// //
// //   String? _selectedBrand;
// //   bool isAutoLocation = false;
// //   bool isFetchingLocation = false;
// //   String latitude = '';
// //   String longitude = '';
// //   bool _isLoading = false;
// //   bool _isATSEnabled = true;
// //   bool _isControllerEnabled = true;
// //   bool _isControllerModelRequired = true;
// //   bool _isATSModelRequired = true; // Manage required/not required state
// //   bool _isATSRatingRequired = true; // Manage required/not required state
// //   bool _showDTcapacity = true;
// //
// //
// //   String _latitude = '';
// //   String _longitude = '';
// //
// //   late TextEditingController _latitudeController;
// //   late TextEditingController _longitudeController;
// //
// //   Future<void> fetchLocation() async {
// //     setState(() {
// //       isFetchingLocation = true;
// //     });
// //
// //     try {
// //       GPSLocationFetcher locationFetcher = GPSLocationFetcher();
// //       final location = await locationFetcher.fetchLocation();
// //
// //       setState(() {
// //         latitude = location['latitude'] ?? '';
// //         longitude = location['longitude'] ?? '';
// //         isFetchingLocation = false;
// //
// //         // Update text controllers
// //         _latitudeController.text = latitude;
// //         _longitudeController.text = longitude;
// //       });
// //
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Location fetched successfully!')),
// //       );
// //     } catch (e) {
// //       setState(() {
// //         isFetchingLocation = false;
// //       });
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text(e.toString())),
// //       );
// //     }
// //   }
// //
// //   void _showAddBrandDialog({
// //     required String title,
// //     required String hintText,
// //     required List<String> brandList,
// //     required String formFieldName,
// //     required void Function(String?) onValueAdded,
// //   }) {
// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //         String? newBrand;
// //         return AlertDialog(
// //           title: Text(title),
// //           content: TextField(
// //             onChanged: (value) {
// //               newBrand = value;
// //             },
// //             decoration: InputDecoration(hintText: hintText),
// //           ),
// //           actions: [
// //             TextButton(
// //               child: Text('Cancel'),
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //             TextButton(
// //               child: Text('OK'),
// //               onPressed: () {
// //                 if (newBrand != null && newBrand!.isNotEmpty) {
// //                   setState(() {
// //                     brandList.insert(brandList.length - 1, newBrand!);
// //                     onValueAdded(newBrand!); // Update the selected value
// //                   });
// //                 }
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //
// //   bool autoValidate = true;
// //   bool readOnly = false;
// //   bool showSegmentedControl = true;
// //   final _formKey = GlobalKey<FormBuilderState>();
// //   bool _ageHasError = false;
// //   bool _regionHasError = false;
// //   bool _eBrandHasError = false;
// //   bool _bBrandHasError = false;
// //   bool _aBrandHasError = false;
// //   bool _sBrandHasError = false;
// //   bool _cBrandHasError= false;
// //   bool _degControllerHasError=false;
// //   bool _capacityHasError = false;
// //   bool _PTcapacityHasError = false;
// //   bool _DTcapacityHasError = false;
// //   bool _FeederCableHasError= false;
// //   bool _MCCBRatingHasError = false;
// //   bool _BatCountHasError = false;
// //   bool _BatCapHasError = false;
// //   bool _ATSRatingHasError = false;
// //   bool _atsBrandHasError = false;
// //   bool _ATSModelHasError = false;
// //   bool _agentTelHasError = false;
// //   bool _agentAddrHasError = false;
// //   bool _agentHasError = false;
// //   bool _yearOfManufactureHasError = false;
// //   bool _yearOfInstallHasError = false;
// //   bool _isReadOnly = false;
// //   final GPSLocationFetcher _locationFetcher = GPSLocationFetcher();
// //
// //   Future<void> _fetchLocation() async {
// //     setState(() {
// //       _isLoading = true;
// //     });
// //
// //     try {
// //       Map<String, String> location = await _locationFetcher.fetchLocation();
// //       setState(() {
// //         _latitude = location['latitude']!;
// //         _longitude = location['longitude']!;
// //         // Update the form fields with the new values
// //         _formKey.currentState?.fields['Latitude']?.didChange(_latitude);
// //         _formKey.currentState?.fields['Longitude']?.didChange(_longitude);
// //
// //       });
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text(e.toString())),
// //       );
// //     } finally {
// //       setState(() {
// //         _isLoading = false;
// //       });
// //     }
// //   }
// //
// //
// //  //string array
// //   Map<String, String> _selectedValues = {};
// //
// //   var Regions = [ 'CPN','CPS','EPN','EPS','EPN–TC','HQ','NCP','NPN','NPS','NWPE','NWPW','PITI','SAB','SMW5','SMW6','SPE','SPW','WEL','WPC','WPE','WPN','WPNE','WPS','WPSE','WPSW','UVA','Other'];
// //   var setBrands = ['Caterpillar', 'Cummins', 'Dale', 'Denyo', 'F.G.Wilson', 'Foracity', 'Greaves', 'John Deere', 'Jubilee', 'Kohler', 'Mitsui - Deutz', 'Mosa', 'Olympian', 'Onan', 'Pramac', 'Sanyo Denki', 'Siemens', 'Tempest', 'Unknown', 'Wega', 'Welland Power','Other'];
// //   var ATSBrands = ['Not Available','Schnider', 'Cummins', 'Socomec','Unknown','Other'];
// //   var temp = ['sfs','gdc','gxdf','dgcf'];
// //   var ControllerBrands = ['Not Available','DSE', 'HMI', 'Unknown','Other'];
// //   var BatBrands = ['Amaron', 'Exide', 'Luminous','Volta','Okaya','LivGuard','Su-Kam','Shield','Other'];
// //
// //   var alternatorBrands = ['Alsthom', 'Aulturdyne', 'Bosch', 'Caterpillar', 'Denyo', 'Greaves', 'Iskra', 'Kohler', 'Leroy Somer', 'Marelli', 'Mecc Alte', 'Mitsubishi', 'Perkins', 'Sanyo Denki', 'Siemens', 'Stamford', 'Taiyo', 'Tempest', 'Unknown', 'Wega','Other'];
// //   var engineBrands = ['Caterpillar', 'Chana', 'Cummins', 'Deutz', 'Detroit', 'Denyo', 'Greaves', 'Honda', 'Hyundai', 'Isuzu', 'John Deere', 'Komatsu', 'Kohler', 'Kubota', 'Lester', 'Mitsubishi', 'Onan', 'Perkins', 'Rusten', 'Unknown', 'Valmet', 'Volvo', 'Yanmar','Other'];
// //
// //
// //
// //   void _onChanged(dynamic val) => debugPrint(val.toString());
// //
// //   @override
// //   Widget build(BuildContext context) {
// //
// //     UserAccess userAccess = Provider.of<UserAccess>(context, listen: true); // Use listen: true to rebuild the widget when the data changes
// //
// //     return Scaffold(
// //       body: Padding(
// //         padding: const EdgeInsets.all(10),
// //         child: SingleChildScrollView(
// //           child: Column(
// //             children: <Widget>[
// //               FormBuilder(
// //                 key: _formKey,
// //                 // enabled: false,
// //                 onChanged: () {
// //                   _formKey.currentState!.save();
// //                   debugPrint(_formKey.currentState!.value.toString());
// //                 },
// //                 autovalidateMode: AutovalidateMode.disabled,
// //
// //                 // skipDisabled: true,
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: <Widget>[
// //                     const SizedBox(height: 15),
// //
// //                     Text(
// //                       'Location',
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     SizedBox(height: 8),
// //
// //                     //Region Select
// //                     FormBuilderDropdown<String>(
// //                       name: 'province',
// //                       decoration: InputDecoration(
// //                         labelText: 'Region',
// //                         suffix: _regionHasError
// //                             ? const Icon(Icons.error)
// //                             : const Icon(Icons.check, color: Colors.green),
// //                         hintText: 'Select Region',
// //                       ),
// //                       validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
// //                       items: Regions
// //                           .map((region) => DropdownMenuItem(
// //                         alignment: AlignmentDirectional.center,
// //                         value: region,
// //                         child: Text(region),
// //                       ))
// //                           .toList(),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           _selectedValues['province'] = val!;
// //                           _regionHasError = !(_formKey.currentState?.fields['province']?.validate() ?? false);
// //
// //                           if (val == 'Other') {
// //                             _showAddBrandDialog(
// //                               title: 'Enter New Region',
// //                               hintText: 'Region Name',
// //                               brandList: Regions,
// //                               formFieldName: 'province',
// //                               onValueAdded: (newVal) {
// //                                 setState(() {
// //                                   _selectedValues['province'] = newVal!;
// //                                   _formKey.currentState?.fields['province']
// //                                       ?.didChange(newVal); // Set the new value
// //                                 });
// //                               },
// //
// //                             );
// //                           }
// //                         });
// //                       },
// //                       valueTransformer: (val) => val?.toString(),
// //                       initialValue: _selectedValues['province'],
// //                     ),
// //
// //                     //RTOM Entering
// //                     Stack(
// //                       alignment: Alignment.centerRight,
// //                       children: [
// //                         FormBuilderTextField(
// //                           name: 'Rtom_name',
// //                           decoration: InputDecoration(
// //                             labelText: 'RTOM',
// //                           ),
// //                           validator: FormBuilderValidators.required(),
// //                           onChanged: (value) => setState(() {
// //                             _selectedValues['Rtom_name'] = value!;
// //                           //  print('RTOM: ' + _selectedValues['RTOM'].toString());
// //                           }),
// //                         ),
// //                         // Show tick mark if data is entered
// //                         _formKey.currentState?.fields['Rtom_name']?.value?.toString()?.isNotEmpty ?? false
// //                             ? Icon(
// //                           Icons.check,
// //                           color: Colors.green,
// //                         )
// //                             : SizedBox(),
// //                       ],
// //                     ),
// //
// //                     //Station Text Field
// //                     Stack(
// //                       alignment: Alignment.centerRight,
// //                       children: [
// //                         FormBuilderTextField(
// //                           name: 'station',
// //                          // enabled: false,
// //                           decoration: InputDecoration(
// //                             labelText: 'Station (QR Code ID,ex- G:Badulla_1)',
// //
// //                           ),
// //                           validator: FormBuilderValidators.required(),
// //                           onChanged: (value) => setState(() {}),
// //                         ),
// //                         // Show tick mark if data is entered
// //                         _formKey.currentState?.fields['station']?.value?.toString()?.isNotEmpty ?? false
// //                             ? Icon(
// //                           Icons.check,
// //                           color: Colors.green,
// //                         )
// //                             : SizedBox(),
// //                       ],
// //                     ),
// //
// //                     Divider(
// //                       color: Colors.grey, // Color of the line
// //                       thickness: 1,       // Thickness of the line
// //                       height: 20,         // Space before and after the divider
// //                     ),
// //                     Text(
// //                       'GPS Location \n(Turn On GPS in the device and press the button or \nWithout pressing enter data manually)',
// //                       style: TextStyle(
// //                         fontSize: 15,
// //                         fontWeight: FontWeight.bold
// //                       ),
// //                     ),
// //                     SizedBox(height: 12),
// //
// //                     Align(
// //                       alignment: Alignment.centerLeft,
// //                       child: ElevatedButton(
// //                         onPressed: _isLoading
// //                             ? null
// //                             : () async {
// //                           setState(() {
// //                             _isLoading = true;
// //                           });
// //
// //                           await _fetchLocation(); // Fetch the location data here.
// //
// //                           setState(() {
// //                             _isReadOnly = true; // Make the fields read-only.
// //                             _isLoading = false;
// //                           });
// //                         },
// //                         child: _isLoading
// //                             ? CircularProgressIndicator()
// //                             : Text('Add Location Automatically'),
// //                       ),
// //                     ),
// //
// // // Allow user to enter Latitude
// //                     FormBuilderTextField(
// //                       name: 'Latitude',
// //                       keyboardType: TextInputType.number,
// //                       initialValue: _latitude,
// //                       readOnly: _isReadOnly, // Make field read-only based on the state
// //                       decoration: InputDecoration(
// //                         labelText: 'Latitude',
// //                         hintText: _latitude.isNotEmpty ? _latitude : 'Enter or fetch Latitude',
// //                       ),
// //                       onChanged: (val) {
// //                         if (!_isReadOnly) {
// //                           setState(() {
// //                             _latitude = val ?? '';
// //                           });
// //                         }
// //                       },
// //                     ),
// //
// // // Allow user to enter Longitude
// //                     FormBuilderTextField(
// //                       name: 'Longitude',
// //                       keyboardType: TextInputType.number,
// //                       initialValue: _longitude,
// //                       readOnly: _isReadOnly, // Make field read-only based on the state
// //                       decoration: InputDecoration(
// //                         labelText: 'Longitude',
// //                         hintText: _longitude.isNotEmpty ? _longitude : 'Enter or fetch Longitude',
// //                       ),
// //                       onChanged: (val) {
// //                         if (!_isReadOnly) {
// //                           setState(() {
// //                             _longitude = val ?? '';
// //                           });
// //                         }
// //                       },
// //                     ),
// //
// //                     Divider(
// //                       color: Colors.grey, // Color of the line
// //                       thickness: 1,       // Thickness of the line
// //                       height: 20,         // Space before and after the divider
// //                     ),
// //
// //                     const SizedBox(height: 15),
// //
// //                     Text(
// //                       'General Details',
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     SizedBox(height: 8),
// //
// //                     //Generator Availability
// //                     FormBuilderChoiceChip<String>(
// //                       autovalidateMode: AutovalidateMode.onUserInteraction,
// //                       decoration: const InputDecoration(
// //                           labelText: 'Generator Available?'),
// //                       name: 'Available',
// //                       initialValue: null,
// //                       selectedColor: Colors.lightBlueAccent,
// //                       options: const [
// //                         FormBuilderChipOption(
// //                           value: 'Yes',
// //                           avatar: CircleAvatar(child: Text('Y')),
// //                         ),
// //                         FormBuilderChipOption(
// //                           value: 'No',
// //                           avatar: CircleAvatar(child: Text('N')),
// //                         ),
// //                       ],
// //                       onChanged: _onChanged,
// //                     ),
// //
// //                     //Generator Type
// //                     FormBuilderChoiceChip<String>(
// //                       autovalidateMode: AutovalidateMode.onUserInteraction,
// //                       decoration: const InputDecoration(
// //                           labelText: 'Generator Type'),
// //                       name: 'category',
// //                       initialValue: null,
// //                       selectedColor: Colors.lightBlueAccent,
// //                       options: const [
// //                         FormBuilderChipOption(
// //                           value: 'Fixed',
// //                           avatar: CircleAvatar(child: Text('F')),
// //                         ),
// //                         FormBuilderChipOption(
// //                           value: 'Mobile',
// //                           avatar: CircleAvatar(child: Text('M')),
// //                         ),
// //                         FormBuilderChipOption(
// //                           value: 'Portable',
// //                           avatar: CircleAvatar(child: Text('P')),
// //                         ),
// //                       ],
// //                       onChanged: _onChanged,
// //                     ),
// //
// //                     //Generator mode
// //                     FormBuilderChoiceChip<String>(
// //                       autovalidateMode: AutovalidateMode.onUserInteraction,
// //                       decoration: const InputDecoration(
// //                           labelText: 'Generator Mode'),
// //                       name: 'mode',
// //                       initialValue: null,
// //                       selectedColor: Colors.lightBlueAccent,
// //                       options: const [
// //                         FormBuilderChipOption(
// //                           value: 'A',
// //                           child: Text('Auto'),
// //                           avatar: CircleAvatar(child: Text('A')),
// //                         ),
// //                         FormBuilderChipOption(
// //                           value: 'M',
// //                           child: Text('Manual'),
// //                           avatar: CircleAvatar(child: Text('M')),
// //                         ),
// //                       ],
// //                       onChanged: _onChanged,
// //
// //                     ),
// //
// //                     //Generator phase
// //                     FormBuilderChoiceChip<String>(
// //                       autovalidateMode: AutovalidateMode.onUserInteraction,
// //                       decoration: const InputDecoration(
// //                           labelText: 'Generator Phase'),
// //                       name: 'phase_eng',
// //                       initialValue: null,
// //                       selectedColor: Colors.lightBlueAccent,
// //                       options: const [
// //                         FormBuilderChipOption(
// //                           value: '3', //this is 3 phase
// //                           child: Text('Phase'),
// //                           avatar: CircleAvatar(child: Text('3')),
// //                         ),
// //                         FormBuilderChipOption(
// //                           value: '1',
// //                           child: Text('Phase'),
// //                           avatar: CircleAvatar(child: Text('1')),
// //                         ),
// //                       ],
// //                       onChanged: _onChanged,
// //                     ),
// //
// //                     // Year of Manufacture
// //                     FormBuilderTextField(
// //                       name: 'YoM',
// //                       decoration: InputDecoration(
// //                         labelText: 'Year of Manufacture (ex: 2010)',
// //                         hintText: 'Enter Year of Manufacture',
// //                         suffixIcon: _yearOfManufactureHasError
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : (_formKey.currentState?.fields['YoM']?.value != null
// //                             ? const Icon(Icons.check, color: Colors.green)
// //                             : null),
// //                       ),
// //                       validator: FormBuilderValidators.compose([
// //                         FormBuilderValidators.required(),
// //                         FormBuilderValidators.numeric(),
// //                         FormBuilderValidators.min(1900),
// //                         FormBuilderValidators.max(9999),
// //                         FormBuilderValidators.maxLength(4),
// //                         FormBuilderValidators.minLength(4),
// //                       ]),
// //                       keyboardType: TextInputType.number,
// //                       onChanged: (val) {
// //                         setState(() {
// //                           _yearOfManufactureHasError =
// //                           !(_formKey.currentState?.fields['YoM']?.validate() ?? false);
// //                         });
// //                       },
// //                     ),
// //
// //                     // Year of Installation
// //                     FormBuilderTextField(
// //                       name: 'Yo_Install',
// //                       decoration: InputDecoration(
// //                         labelText: 'Year of Installation (ex: 2010)',
// //                         hintText: 'Enter Year of Installation',
// //                         suffixIcon: _yearOfInstallHasError
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : (_formKey.currentState?.fields['Yo_Install']?.value != null
// //                             ? const Icon(Icons.check, color: Colors.green)
// //                             : null),
// //                       ),
// //                       validator: FormBuilderValidators.compose([
// //                         FormBuilderValidators.required(),
// //                         FormBuilderValidators.numeric(),
// //                         FormBuilderValidators.min(1900),
// //                         FormBuilderValidators.max(9999),
// //                         FormBuilderValidators.maxLength(4),
// //                         FormBuilderValidators.minLength(4),
// //                       ]),
// //                       keyboardType: TextInputType.number,
// //                       onChanged: (val) {
// //                         setState(() {
// //                           _yearOfInstallHasError =
// //                           !(_formKey.currentState?.fields['Yo_Install']?.validate() ?? false);
// //                         });
// //                       },
// //                     ),
// //
// //                     //Generator Capacity
// //                     FormBuilderTextField(
// //                       // autovalidateMode: AutovalidateMode.always,
// //                       name: 'set_cap',
// //                       decoration: InputDecoration(
// //                         labelText: 'Set Capacity (KVA)',
// //                         suffixIcon: _capacityHasError
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : const Icon(Icons.check, color: Colors.green),
// //                       ),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           _capacityHasError = !(_formKey.currentState?.fields['set_cap']
// //                               ?.validate() ??
// //                               false);
// //                         });
// //                       },
// //                       // valueTransformer: (text) => num.tryParse(text),
// //                       validator: FormBuilderValidators.compose([
// //                         FormBuilderValidators.required(),
// //                         FormBuilderValidators.numeric(),
// //                         FormBuilderValidators.max(10000),
// //                       ]),
// //                       // initialValue: '12',
// //                       keyboardType: TextInputType.number,
// //                       textInputAction: TextInputAction.next,
// //                     ),
// //
// //                     const SizedBox(height: 15),
// //
// //                     Text(
// //                       'Generator Specifications',
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     SizedBox(height: 8),
// //
// //                     //Alternator Brand
// //                     FormBuilderDropdown<String>(
// //                       name: 'brand_alt',
// //                       decoration: InputDecoration(
// //                         labelText: 'Alternator Brand',
// //                         suffix: _aBrandHasError
// //                             ? const Icon(Icons.error)
// //                             : const Icon(Icons.check, color: Colors.green),
// //                         hintText: 'Select Engine Brand',
// //                       ),
// //                       validator: FormBuilderValidators.compose(
// //                           [FormBuilderValidators.required()]),
// //                       items: alternatorBrands
// //                           .map((aBrand) => DropdownMenuItem(
// //                         alignment: AlignmentDirectional.center,
// //                         value: aBrand,
// //                         child: Text(aBrand),
// //                       ))
// //                           .toList(),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           _aBrandHasError = !(_formKey
// //                               .currentState?.fields['brand_alt']
// //                               ?.validate() ??
// //                               false);
// //                         });
// //                         if (val == 'Other') {
// //                           _showAddBrandDialog(
// //                             title: 'Enter Alternator Brand',
// //                             hintText: 'Alternator Brand',
// //                             brandList: alternatorBrands,
// //                             formFieldName: 'brand_alt',
// //                             onValueAdded: (newVal) {
// //                               setState(() {
// //                                 _selectedValues['brand_alt'] = newVal!;
// //                                 _formKey.currentState?.fields['brand_alt']
// //                                     ?.didChange(newVal); // Set the new value
// //                               });
// //                             },
// //                           );
// //                         }
// //
// //                       },
// //                       valueTransformer: (val) => val?.toString(),
// //                       initialValue: _selectedValues['brand_alt'],
// //                     ),
// //
// //                     //Alternator Model Text Field
// //                     Stack(
// //                       alignment: Alignment.centerRight,
// //                       children: [
// //                         FormBuilderTextField(
// //                           name: 'model_alt',
// //                           decoration: InputDecoration(
// //                             labelText: 'Alternator Model',
// //                           ),
// //                           //validator: FormBuilderValidators.required(),
// //                           onChanged: (value) => setState(() {}),
// //                         ),
// //                         // Show tick mark if data is entered
// //                         _formKey.currentState?.fields['model_alt']?.value?.toString()?.isNotEmpty ?? false
// //                             ? Icon(
// //                           Icons.check,
// //                           color: Colors.green,
// //                         )
// //                             : SizedBox(),
// //                       ],
// //                     ),
// //
// //                     //Alternator Serial Text Field
// //                     Stack(
// //                       alignment: Alignment.centerRight,
// //                       children: [
// //                         FormBuilderTextField(
// //                           name: 'serial_alt',
// //                           decoration: InputDecoration(
// //                             labelText: 'Alternator Serial',
// //                           ),
// //                           //validator: FormBuilderValidators.required(),
// //                           onChanged: (value) => setState(() {}),
// //                         ),
// //                         // Show tick mark if data is entered
// //                         _formKey.currentState?.fields['serial_alt']?.value?.toString()?.isNotEmpty ?? false
// //                             ? Icon(
// //                           Icons.check,
// //                           color: Colors.green,
// //                         )
// //                             : SizedBox(),
// //                       ],
// //                     ),
// //
// //                     //Engine Brand
// //                     FormBuilderDropdown<String>(
// //                       name: 'brand_eng',
// //                       decoration: InputDecoration(
// //                         labelText: 'Engine Brand',
// //                         suffix: _eBrandHasError
// //                             ? const Icon(Icons.error)
// //                             : const Icon(Icons.check, color: Colors.green),
// //                         hintText: 'Select Engine Brand',
// //                       ),
// //                       validator: FormBuilderValidators.compose(
// //                           [FormBuilderValidators.required()]),
// //                       items: engineBrands
// //                           .map((eBrand) => DropdownMenuItem(
// //                         alignment: AlignmentDirectional.center,
// //                         value: eBrand,
// //                         child: Text(eBrand),
// //                       ))
// //                           .toList(),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           _eBrandHasError = !(_formKey
// //                               .currentState?.fields['brand_eng']
// //                               ?.validate() ??
// //                               false);
// //                         });
// //                         if (val == 'Other') {
// //                           _showAddBrandDialog(
// //                             title: 'Enter Engine Brand',
// //                             hintText: 'Engine Brand',
// //                             brandList: engineBrands,
// //                             formFieldName: 'brand_eng',
// //                             onValueAdded: (newVal) {
// //                               setState(() {
// //                                 _selectedValues['brand_eng'] = newVal!;
// //                                 _formKey.currentState?.fields['brand_eng']
// //                                     ?.didChange(newVal); // Set the new value
// //                               });
// //                             },
// //                           );
// //                         }
// //
// //                       },
// //                       valueTransformer: (val) => val?.toString(),
// //                       initialValue: _selectedValues['brand_eng'],
// //                     ),
// //
// //                     //Engine Model Text Field
// //                     Stack(
// //                       alignment: Alignment.centerRight,
// //                       children: [
// //                         FormBuilderTextField(
// //                           name: 'model_eng',
// //                           decoration: InputDecoration(
// //                             labelText: 'Engine Model',
// //                           ),
// //                           //validator: FormBuilderValidators.required(),
// //                           onChanged: (value) => setState(() {}),
// //                         ),
// //                         // Show tick mark if data is entered
// //                         _formKey.currentState?.fields['model_eng']?.value?.toString()?.isNotEmpty ?? false
// //                             ? Icon(
// //                           Icons.check,
// //                           color: Colors.green,
// //                         )
// //                             : SizedBox(),
// //                       ],
// //                     ),
// //
// //                     //Engine Serial Text Field
// //                     Stack(
// //                       alignment: Alignment.centerRight,
// //                       children: [
// //                         FormBuilderTextField(
// //                           name: 'serial_eng',
// //                           decoration: InputDecoration(
// //                             labelText: 'Engine Serial',
// //                           ),
// //                           //validator: FormBuilderValidators.required(),
// //                           onChanged: (value) => setState(() {}),
// //                         ),
// //                         // Show tick mark if data is entered
// //                         _formKey.currentState?.fields['serial_eng']?.value?.toString()?.isNotEmpty ?? false
// //                             ? Icon(
// //                           Icons.check,
// //                           color: Colors.green,
// //                         )
// //                             : SizedBox(),
// //                       ],
// //                     ),
// //
// //                     //Set Brand
// //                     FormBuilderDropdown<String>(
// //                       name: 'brand_set',
// //                       decoration: InputDecoration(
// //                         labelText: 'Set Brand',
// //                         suffix: _sBrandHasError
// //                             ? const Icon(Icons.error)
// //                             : const Icon(Icons.check, color: Colors.green),
// //                         hintText: 'Select Engine Brand',
// //                       ),
// //                       validator: FormBuilderValidators.compose(
// //                           [FormBuilderValidators.required()]),
// //                       items: setBrands
// //                           .map((sBrand) => DropdownMenuItem(
// //                         alignment: AlignmentDirectional.center,
// //                         value: sBrand,
// //                         child: Text(sBrand),
// //                       ))
// //                           .toList(),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           _sBrandHasError = !(_formKey
// //                               .currentState?.fields['brand_set']
// //                               ?.validate() ??
// //                               false);
// //                         });
// //                         if (val == 'Other') {
// //                           _showAddBrandDialog(
// //                             title: 'Enter Engine Brand',
// //                             hintText: 'Engine Set Brand',
// //                             brandList: setBrands,
// //                             formFieldName: 'brand_set',
// //                             onValueAdded: (newVal) {
// //                               setState(() {
// //                                 _selectedValues['brand_set'] = newVal!;
// //                                 _formKey.currentState?.fields['brand_set']
// //                                     ?.didChange(newVal); // Set the new value
// //                               });
// //                             },
// //                           );
// //                         }
// //
// //                       },
// //                       valueTransformer: (val) => val?.toString(),
// //                       initialValue: _selectedValues['brand_set'],
// //                     ),
// //
// //                     //Set Model Text Field
// //                     Stack(
// //                       alignment: Alignment.centerRight,
// //                       children: [
// //                         FormBuilderTextField(
// //                           name: 'model_set',
// //                           decoration: InputDecoration(
// //                             labelText: 'Set Model',
// //                           ),
// //                           //validator: FormBuilderValidators.required(),
// //                           onChanged: (value) => setState(() {}),
// //                         ),
// //                         // Show tick mark if data is entered
// //                         _formKey.currentState?.fields['model_set']?.value?.toString()?.isNotEmpty ?? false
// //                             ? Icon(
// //                           Icons.check,
// //                           color: Colors.green,
// //                         )
// //                             : SizedBox(),
// //                       ],
// //                     ),
// //
// //                     //Set Serial Text Field
// //                     Stack(
// //                       alignment: Alignment.centerRight,
// //                       children: [
// //                         FormBuilderTextField(
// //                           name: 'serial_set',
// //                           decoration: InputDecoration(
// //                             labelText: 'Set Serial',
// //                           ),
// //                           //validator: FormBuilderValidators.required(),
// //                           onChanged: (value) => setState(() {}),
// //                         ),
// //                         // Show tick mark if data is entered
// //                         _formKey.currentState?.fields['serial_set']?.value?.toString()?.isNotEmpty ?? false
// //                             ? Icon(
// //                           Icons.check,
// //                           color: Colors.green,
// //                         )
// //                             : SizedBox(),
// //                       ],
// //                     ),
// //
// //                     const SizedBox(height: 15),
// //
// //                     Text(
// //                       'Controller Details',
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     SizedBox(height: 8),
// //
// //                     // Controller Brand
// //                     FormBuilderDropdown<String>(
// //                       name: 'Controller',
// //                       decoration: InputDecoration(
// //                         labelText: 'Controller Brand',
// //                         suffix: _cBrandHasError
// //                             ? const Icon(Icons.error)
// //                             : const Icon(Icons.check, color: Colors.green),
// //                         hintText: 'Select Controller Brand',
// //                       ),
// //                       validator: FormBuilderValidators.compose(
// //                           [FormBuilderValidators.required()]),
// //                       items: ControllerBrands
// //                           .map((cBrand) => DropdownMenuItem(
// //                         alignment: AlignmentDirectional.center,
// //                         value: cBrand,
// //                         child: Text(cBrand),
// //                       ))
// //                           .toList(),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           _cBrandHasError = !(_formKey.currentState?.fields['Controller']?.validate() ?? false);
// //
// //                           // Check if the selected brand is "Not Available" to disable/enable the controller model field
// //                           _isControllerEnabled = val != 'Not Available';
// //                           _isControllerModelRequired = val != 'Not Available';
// //                         });
// //
// //                         if (val == 'Other') {
// //                           _showAddBrandDialog(
// //                             title: 'Enter Controller Brand',
// //                             hintText: 'Controller Brand',
// //                             brandList: ControllerBrands,
// //                             formFieldName: 'Controller',
// //                             onValueAdded: (newVal) {
// //                               setState(() {
// //                                 _selectedValues['Controller'] = newVal!;
// //                                 _formKey.currentState?.fields['Controller']?.didChange(newVal);
// //                               });
// //                             },
// //                           );
// //                         }
// //                       },
// //                       valueTransformer: (val) => val?.toString(),
// //                       initialValue: _selectedValues['Controller'],
// //                     ),
// //
// //                     SizedBox(height: 8),
// // // Controller Model Text Field
// //                     Stack(
// //                       alignment: Alignment.centerLeft,
// //                       children: [
// //                         FormBuilderTextField(
// //                           name: 'controller_model',
// //                           decoration: InputDecoration(
// //                             labelText: 'Controller Model',
// //                             contentPadding: EdgeInsets.only(right: 40), // Add padding to the right
// //                           ),
// //                           onChanged: (value) => setState(() {}),
// //                           enabled: _isControllerEnabled, // Control enabled state based on the Controller Brand value
// //                           validator: _isControllerModelRequired
// //                               ? FormBuilderValidators.compose([
// //                             FormBuilderValidators.required(), // Add required validator only if required
// //                           ])
// //                               : null,
// //                         ),
// //                         Positioned(
// //                           right: 0, // Position the icon on the right
// //                           child: _formKey.currentState?.fields['controller_model']?.value?.toString()?.isNotEmpty ?? false
// //                               ? Icon(
// //                             Icons.check,
// //                             color: Colors.green,
// //                           )
// //                               : SizedBox(),
// //                         ),
// //                       ],
// //                     ),
// //
// //
// //                     const SizedBox(height: 15),
// //
// //                     Text(
// //                       'Tank Details',
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //
// //                     // Bulk Tank Availability
// //                     FormBuilderChoiceChip<String>(
// //                       autovalidateMode: AutovalidateMode.onUserInteraction,
// //                       decoration: const InputDecoration(
// //                         labelText: 'Bulk Tank Available?',
// //                       ),
// //                       name: 'dayTank',
// //                       initialValue: null,
// //                       selectedColor: Colors.lightBlueAccent,
// //                       options: const [
// //                         FormBuilderChipOption(
// //                           value: '1',
// //                           child: Text('Yes'),
// //                           avatar: CircleAvatar(child: Text('Y')),
// //                         ),
// //                         FormBuilderChipOption(
// //                           value: '0',
// //                           child: Text('No'),
// //                           avatar: CircleAvatar(child: Text('N')),
// //                         ),
// //                       ],
// //                       onChanged: (val) {
// //                         setState(() {
// //                           _showDTcapacity = val == '1'; // Show if Yes, hide if No
// //                         });
// //                       },
// //                     ),
// //
// // // Day Tank Capacity
// //                     FormBuilderTextField(
// //                       autovalidateMode: _showDTcapacity ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
// //                       name: 'dayTankSze',
// //                       enabled: _showDTcapacity,
// //                       decoration: InputDecoration(
// //                         labelText: 'Day Tank Capacity (L)',
// //                         suffixIcon: _DTcapacityHasError &&
// //                             _formKey.currentState?.fields['dayTankSze']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : _formKey.currentState?.fields['dayTankSze']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.check, color: Colors.green)
// //                             : null,
// //                       ),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           // Set the error state based on the validation result
// //                           _DTcapacityHasError = !(_formKey.currentState?.fields['dayTankSze']?.validate() ?? false);
// //                         });
// //                       },
// //                       validator: (value) {
// //                         if (_showDTcapacity && (value == null || value.isEmpty)) {
// //                           return 'This field is required.';
// //                         }
// //                         return null;
// //                       },
// //                       keyboardType: TextInputType.number,
// //                       textInputAction: TextInputAction.next,
// //                     ),
// //
// //                     SizedBox(height: 8),
// //                     //prime tank capacity
// //                     FormBuilderTextField(
// //                       // autovalidateMode: AutovalidateMode.always,
// //                       name: 'tank_prime',
// //                       decoration: InputDecoration(
// //                         labelText: 'Prime Tank Capacity (L)',
// //                         suffixIcon: _PTcapacityHasError
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : const Icon(Icons.check, color: Colors.green),
// //                       ),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           _PTcapacityHasError = !(_formKey.currentState?.fields['tank_prime']
// //                               ?.validate() ??
// //                               false);
// //                         });
// //                       },
// //                       // valueTransformer: (text) => num.tryParse(text),
// //                       validator: FormBuilderValidators.compose([
// //                         FormBuilderValidators.required(),
// //                         FormBuilderValidators.numeric(),
// //                         FormBuilderValidators.max(100000),
// //                       ]),
// //                       // initialValue: '12',
// //                       keyboardType: TextInputType.number,
// //                       textInputAction: TextInputAction.next,
// //                     ),
// //
// //                     const SizedBox(height: 15),
// //
// //                     Text(
// //                       'ATS & Cabling',
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //
// //                     //ATS Brand
// //                     FormBuilderDropdown<String>(
// //                       name: 'BrandATS',
// //                       decoration: InputDecoration(
// //                         labelText: 'ATS Brand',
// //                         suffix: _atsBrandHasError
// //                             ? const Icon(Icons.error)
// //                             : const Icon(Icons.check, color: Colors.green),
// //                         hintText: 'Select ATS Brand',
// //                       ),
// //                       validator: FormBuilderValidators.compose(
// //                           [FormBuilderValidators.required()]),
// //                       items: ATSBrands
// //                           .map((atsBrand) => DropdownMenuItem(
// //                         alignment: AlignmentDirectional.center,
// //                         value: atsBrand,
// //                         child: Text(atsBrand),
// //                       ))
// //                           .toList(),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           _atsBrandHasError = !(_formKey.currentState?.fields['BrandATS']?.validate() ?? false);
// //
// //                           // Check if the selected brand is "Not Available" to disable/enable fields
// //                           _isATSEnabled = val != 'Not Available';
// //                           _isATSModelRequired = val != 'Not Available'; // Update required status for ATS Model
// //                           _isATSRatingRequired = val != 'Not Available';
// //                         });
// //
// //                         if (val == 'Other') {
// //                           _showAddBrandDialog(
// //                             title: 'Enter ATS Brand',
// //                             hintText: 'ATS Brand',
// //                             brandList: ATSBrands,
// //                             formFieldName: 'BrandATS',
// //                             onValueAdded: (newVal) {
// //                               setState(() {
// //                                 _selectedValues['BrandATS'] = newVal!;
// //                                 _formKey.currentState?.fields['BrandATS']?.didChange(newVal);
// //                               });
// //                             },
// //                           );
// //                         }
// //                       },
// //                       valueTransformer: (val) => val?.toString(),
// //                       initialValue: _selectedValues['BrandATS'],
// //                     ),
// //
// // //ATS Rating
// //                     FormBuilderTextField(
// //                       // autovalidateMode: AutovalidateMode.always,
// //                       name: 'RatingATS',
// //                       decoration: InputDecoration(
// //                         labelText: 'ATS Rating (A)',
// //                         suffixIcon: _ATSRatingHasError && _formKey.currentState?.fields['RatingATS']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : _formKey.currentState?.fields['RatingATS']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.check, color: Colors.green)
// //                             : null,
// //                       ),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           _ATSRatingHasError = !(_formKey.currentState?.fields['RatingATS']?.validate() ?? false);
// //                         });
// //                       },
// //                       validator: _isATSRatingRequired
// //                           ? FormBuilderValidators.compose([
// //                         FormBuilderValidators.required(), // Add required validator only if required
// //                         FormBuilderValidators.numeric(),
// //                         FormBuilderValidators.max(10000),
// //                       ])
// //                           : null, // No validator if not required
// //                       keyboardType: TextInputType.number,
// //                       textInputAction: TextInputAction.next,
// //                       enabled: _isATSEnabled, // Control enabled state based on the ATS Brand value
// //                     ),
// //
// // //ATS Model
// //                     FormBuilderTextField(
// //                       // autovalidateMode: AutovalidateMode.always,
// //                       name: 'ModelATS',
// //                       decoration: InputDecoration(
// //                         labelText: 'ATS Model',
// //                         suffixIcon: _ATSModelHasError && _formKey.currentState?.fields['ModelATS']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : _formKey.currentState?.fields['ModelATS']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.check, color: Colors.green)
// //                             : null,
// //                       ),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           _ATSModelHasError = !(_formKey.currentState?.fields['ModelATS']?.validate() ?? false);
// //                         });
// //                       },
// //                       validator: _isATSModelRequired
// //                           ? FormBuilderValidators.required() // Add required validator only if required
// //                           : null, // No validator if not required
// //                       textInputAction: TextInputAction.next,
// //                       enabled: _isATSEnabled, // Control enabled state based on the ATS Brand value
// //                     ),
// //
// //
// //                     //Feeder Cable size
// //                     FormBuilderTextField(
// //                       // autovalidateMode: AutovalidateMode.always,
// //                       name: 'feederSize',
// //                       decoration: InputDecoration(
// //                         labelText: 'Feeder Cable size (mm^2)',
// //                         suffixIcon: _FeederCableHasError && _formKey.currentState?.fields['feederSize']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : _formKey.currentState?.fields['feederSize']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.check, color: Colors.green)
// //                             : null,
// //                       ),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           // Set the error state based on the validation result
// //                           _FeederCableHasError = !(_formKey.currentState?.fields['feederSize']?.validate() ?? false);
// //                         });
// //                       },
// //                       validator: FormBuilderValidators.compose([
// //                         FormBuilderValidators.numeric(),
// //                         FormBuilderValidators.max(1000),
// //                       ]),
// //                       keyboardType: TextInputType.number,
// //                       textInputAction: TextInputAction.next,
// //                     ),
// //
// //                     //MCCB Rating
// //                     FormBuilderTextField(
// //                       // autovalidateMode: AutovalidateMode.always,
// //                       name: 'RatingMCCB',
// //                       decoration: InputDecoration(
// //                         labelText: 'MCCB Rating (A)',
// //                         suffixIcon: _MCCBRatingHasError && _formKey.currentState?.fields['RatingMCCB']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : _formKey.currentState?.fields['RatingMCCB']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.check, color: Colors.green)
// //                             : null,
// //                       ),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           // Set the error state based on the validation result
// //                           _MCCBRatingHasError = !(_formKey.currentState?.fields['RatingMCCB']?.validate() ?? false);
// //                         });
// //                       },
// //                       validator: FormBuilderValidators.compose([
// //                         FormBuilderValidators.numeric(),
// //                         FormBuilderValidators.max(10000),
// //                       ]),
// //                       keyboardType: TextInputType.number,
// //                       textInputAction: TextInputAction.next,
// //                     ),
// //
// //                     const SizedBox(height: 15),
// //
// //                     Text(
// //                       'Battery Details',
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //
// //                     //Battery count
// //                     FormBuilderTextField(
// //                       // autovalidateMode: AutovalidateMode.always,
// //                       name: 'Battery_Count',
// //                       decoration: InputDecoration(
// //                         labelText: 'Battery Count',
// //                         suffixIcon: _MCCBRatingHasError && _formKey.currentState?.fields['Battery_Count']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : _formKey.currentState?.fields['Battery_Count']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.check, color: Colors.green)
// //                             : null,
// //                       ),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           // Set the error state based on the validation result
// //                           _BatCountHasError = !(_formKey.currentState?.fields['Battery_Count']?.validate() ?? false);
// //                         });
// //                       },
// //                       validator: FormBuilderValidators.compose([
// //                         FormBuilderValidators.numeric(),
// //                         FormBuilderValidators.max(10000),
// //                       ]),
// //                       keyboardType: TextInputType.number,
// //                       textInputAction: TextInputAction.next,
// //                     ),
// //
// //                     //Battery brand
// //                     FormBuilderDropdown<String>(
// //                       name: 'Battery_Brand',
// //                       decoration: InputDecoration(
// //                         labelText: 'Battery Brand',
// //                         suffix: _bBrandHasError
// //                             ? const Icon(Icons.error)
// //                             : const Icon(Icons.check, color: Colors.green),
// //                         hintText: 'Select Battery Brand',
// //                       ),
// //                       validator: FormBuilderValidators.compose(
// //                           [FormBuilderValidators.required()]),
// //                       items: BatBrands
// //                           .map((bBrand) => DropdownMenuItem(
// //                         alignment: AlignmentDirectional.center,
// //                         value: bBrand,
// //                         child: Text(bBrand),
// //                       ))
// //                           .toList(),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           _bBrandHasError = !(_formKey
// //                               .currentState?.fields['Battery_Brand']
// //                               ?.validate() ??
// //                               false);
// //                           _selectedBrand = val;
// //                         });
// //                         if (val == 'Other') {
// //                           _showAddBrandDialog(
// //                             title: 'Enter Battery Brand',
// //                             hintText: 'Battery Brand',
// //                             brandList: BatBrands,
// //                             formFieldName: 'Battery_Brand',
// //                             onValueAdded: (newVal) {
// //                               setState(() {
// //                                 _selectedValues['Battery_Brand'] = newVal!;
// //                                 _formKey.currentState?.fields['Battery_Brand']
// //                                     ?.didChange(newVal); // Set the new value
// //                               });
// //                             },
// //                           );
// //                         }
// //
// //                       },
// //                       valueTransformer: (val) => val?.toString(),
// //                       initialValue: _selectedValues['Battery_Brand'],
// //                     ),
// //
// //                     //Battery Capacity
// //                     FormBuilderTextField(
// //                       // autovalidateMode: AutovalidateMode.always,
// //                       name: 'Battery_Capacity',
// //                       decoration: InputDecoration(
// //                         labelText: 'Battery Capacity (Ah)',
// //                         suffixIcon: _MCCBRatingHasError && _formKey.currentState?.fields['Battery_Capacity']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : _formKey.currentState?.fields['Battery_Capacity']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.check, color: Colors.green)
// //                             : null,
// //                       ),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           // Set the error state based on the validation result
// //                           _BatCapHasError = !(_formKey.currentState?.fields['Battery_Capacity']?.validate() ?? false);
// //                         });
// //                       },
// //                       validator: FormBuilderValidators.compose([
// //                         FormBuilderValidators.numeric(),
// //                         FormBuilderValidators.max(10000),
// //                       ]),
// //                       keyboardType: TextInputType.number,
// //                       textInputAction: TextInputAction.next,
// //                     ),
// //
// //                     const SizedBox(height: 15),
// //
// //                     Text(
// //                       'Service Provider',
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //
// //                     //Local Agent
// //                     FormBuilderTextField(
// //                           autovalidateMode: AutovalidateMode.always,
// //                           name: 'LocalAgent',
// //                           decoration: InputDecoration(
// //                             labelText: 'Local Agent',
// //                             suffixIcon: _agentHasError && _formKey.currentState?.fields['LocalAgent']?.value.toString().isNotEmpty == true
// //                                 ? const Icon(Icons.error, color: Colors.red)
// //                                 : _formKey.currentState?.fields['LocalAgent']?.value.toString().isNotEmpty == true
// //                                 ? const Icon(Icons.check, color: Colors.green)
// //                                 : null,
// //                           ),
// //                           onChanged: (val) {
// //                             setState(() {
// //                               // Set the error state based on the validation result
// //                               _agentHasError = !(_formKey.currentState?.fields['LocalAgent']?.validate() ?? false);
// //                             });
// //                           },
// //                           validator: FormBuilderValidators.compose([
// //                             //FormBuilderValidators.numeric(),
// //                             //FormBuilderValidators.max(1000),
// //                           ]),
// //
// //                           textInputAction: TextInputAction.next,
// //                         ),
// //
// //                     //Local Agent address
// //                     FormBuilderTextField(
// //                       autovalidateMode: AutovalidateMode.always,
// //                       name: 'Agent_Addr',
// //                       decoration: InputDecoration(
// //                         labelText: 'Local Agent Address',
// //                         suffixIcon: _agentAddrHasError && _formKey.currentState?.fields['Local Agent Address']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : _formKey.currentState?.fields['Agent_Addr']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.check, color: Colors.green)
// //                             : null,
// //                       ),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           // Set the error state based on the validation result
// //                           _agentAddrHasError = !(_formKey.currentState?.fields['Agent_Addr']?.validate() ?? false);
// //                         });
// //                       },
// //                       validator: FormBuilderValidators.compose([
// //                         //FormBuilderValidators.numeric(),
// //                         //FormBuilderValidators.max(1000),
// //                       ]),
// //                       textInputAction: TextInputAction.next,
// //                     ),
// //
// //                     //Local Agent Tel
// //                     FormBuilderTextField(
// //                       autovalidateMode: AutovalidateMode.always,
// //                       name: 'Agent_Tel',
// //                       decoration: InputDecoration(
// //                         labelText: 'Local Agent Tel',
// //                         suffixIcon: _agentTelHasError && _formKey.currentState?.fields['Agent_Tel']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : _formKey.currentState?.fields['Agent_Tel']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.check, color: Colors.green)
// //                             : null,
// //                       ),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           // Set the error state based on the validation result
// //                           _agentTelHasError = !(_formKey.currentState?.fields['Agent_Tel']?.validate() ?? false);
// //                         });
// //                       },
// //                       validator: (val) {
// //                         // Skip validation if the field is empty (optional)
// //                         if (val == null || val.isEmpty) {
// //                           return null; // No error message if the field is empty
// //                         }
// //                         // Validate the length if the field is not empty
// //                         if (val.length < 10) {
// //                           return 'Maximum length is 10 digits';
// //                         }
// //                         return null; // Return null if validation passes
// //                       },
// //                       keyboardType: TextInputType.number,
// //                       textInputAction: TextInputAction.next,
// //                     ),
// //
// //                     FormBuilderCheckbox(
// //                       name: 'accept_terms',
// //                       initialValue: false,
// //                       onChanged: _onChanged,
// //                       title: RichText(
// //                         text: const TextSpan(
// //                           children: [
// //                             TextSpan(
// //                               text: 'I Verify that submitted details are true and correct ',
// //                               style: TextStyle(color: Colors.black),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       validator: FormBuilderValidators.equal(
// //                         true,
// //                         errorText:
// //                         'You must accept terms and conditions to continue',
// //                       ),
// //                     ),
// //
// //                   ],
// //                 ),
// //               ),
// //               Row(
// //                 children: <Widget>[
// //                   Expanded(
// //                     child: OutlinedButton(
// //                       onPressed: () {
// //                         _formKey.currentState?.reset();
// //                       },
// //                       style: ButtonStyle(
// //                         foregroundColor: WidgetStateProperty.all<Color>(Colors.green),
// //                         backgroundColor: WidgetStateProperty.all<Color>(Colors.white24),
// //                       ),
// //                       child: Text(
// //                         'Reset',
// //                         style: TextStyle(
// //                           color: Theme.of(context).colorScheme.secondary,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //
// //                   const SizedBox(width: 20),
// //                   Expanded(
// //                     child: ElevatedButton(
// //                       style: ButtonStyle(
// //                         foregroundColor: WidgetStateProperty.all<Color>(Colors.green),
// //                         backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
// //                       ),
// //                       onPressed: () {
// //                         if (_formKey.currentState?.saveAndValidate() ?? false) {
// //                           debugPrint(_formKey.currentState?.value.toString());
// //                           Map<String, dynamic> ? formData = _formKey.currentState?.value;
// //                           formData = formData?.map((key, value) => MapEntry(key, value ?? ''));
// //
// //                           // String rtom = _formKey.currentState?.value['Rtom_name'];
// //                           // debugPrint('RTOM value: $rtom');
// //                           //pass _formkey.currenState.value to a page called httpPostGen
// //
// //                           Navigator.push(
// //                             context,
// //                             MaterialPageRoute(builder: (context) => httpPostGen(formData: formData??{},userAccess: userAccess,)),
// //                           );
// //
// //
// //
// //                         } else {
// //                           debugPrint(_formKey.currentState?.value.toString());
// //                           debugPrint('validation failed');
// //                         }
// //                       },
// //
// //                       child: const Text(
// //                         'Submit',
// //                         style: TextStyle(color: Colors.black),
// //                       ),
// //                     ),
// //                   ),
// //
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// // }
//
//
//
// //V1 working
// // //Gathering of Generator data though user forum
// //
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter_form_builder/flutter_form_builder.dart';
// // import 'package:flutter_localizations/flutter_localizations.dart';
// // import 'package:form_builder_validators/form_builder_validators.dart';
// // import 'package:intl/intl.dart';
// //
// // import '../../Widgets/editHttp/httpPostGen.dart';
// //
// // class GatherGenData extends StatefulWidget {
// //   @override
// //   _GatherGenDataState createState() => _GatherGenDataState();
// // }
// //
// // class _GatherGenDataState extends State<GatherGenData> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Add Gen Info'),
// //       ),
// //       body: Center(
// //         child: CompleteForm(),
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// // class CompleteForm extends StatefulWidget {
// //   const CompleteForm({Key? key}) : super(key: key);
// //
// //   @override
// //   State<CompleteForm> createState() {
// //     return _CompleteFormState();
// //   }
// // }
// //
// // class _CompleteFormState extends State<CompleteForm> {
// //
// //
// //   bool autoValidate = true;
// //   bool readOnly = false;
// //   bool showSegmentedControl = true;
// //   final _formKey = GlobalKey<FormBuilderState>();
// //   bool _ageHasError = false;
// //   bool _regionHasError = false;
// //   bool _eBrandHasError = false;
// //   bool _aBrandHasError = false;
// //   bool _sBrandHasError = false;
// //   bool _capacityHasError = false;
// //   bool _PTcapacityHasError = false;
// //   bool _DTcapacityHasError = false;
// //   bool _FeederCableHasError= false;
// //   bool _MCCBRatingHasError = false;
// //   bool _ATSRatingHasError = false;
// //   bool _atsBrandHasError = false;
// //   bool _ATSModelHasError = false;
// //   bool _agentTelHasError = false;
// //   bool _agentAddrHasError = false;
// //   bool _agentHasError = false;
// //   bool _yearOfManufactureHasError = false;
// //   bool _yearOfInstallHasError = false;
// //
// //
// //   //string array
// //   Map<String, String> _selectedValues = {};
// //
// //   var Regions = [ 'CPN','CPS','EPN','EPS','EPN–TC','HQ','NCP','NPN','NPS','NWPE','NWPW','SAB','SPE','SPW','WEL','WPC','WPE','WPN','WPNE','WPS','WPSE','WPSW','UVA'];
// //   var setBrands = ['Caterpillar', 'Cummins', 'Denyo', 'Electromatic', 'Jubilee', 'Kohler', 'Mitsui - Deutz', 'Olympian', 'Pramac', 'Sanyo Denki', 'Wega', 'Siemens', 'Unknown'];
// //   var ATSBrands = ['Schnider', 'Cummins', 'Socomec','Unknown'];
// //
// //   var alternatorBrands = [  'Alsthom',  'Aulturdyne',  'Bosch',  'Caterpillar',  'Cummins',  'Dale',  'Denyo',  'Electromatic',  'F.G.Wilson',  'Foracity',  'Greaves',  'Hitachi',  'Iskra',  'John Deere',  'Jubilee',  'Kohler',  'Komatsu',  'Leroy Somer',  'Marelli',  'Mecc Alte',  'Mitsubishi',  'Olympian',  'Onan',  'Pramac',  'Sanyo Denki',  'Siemens',  'Stamford',  'Taiyo',  'Tempest',  'TVS Lucas',  'Unknown',  'Valmat',  'Volvo',  'Wega',  'Welland Power'];
// //   var engineBrands = ['Caterpillar', 'Chana', 'Cummins', 'Dale', 'Deutz', 'Electromatic', 'F.G.Wilson', 'Foracity', 'Greaves', 'Honda', 'Hyundai', 'Isuzu', 'John Deere', 'Kubota', 'Lester', 'Marelli', 'Mecc Alte', 'Mitsubishi', 'Mosa', 'Olympian', 'Onan', 'Pramac', 'Rusten', 'Sanyo Denki', 'Siemens', 'Stamford', 'Tempest', 'Valmet', 'Volvo', 'Wega', 'Yanmar', 'Unknown'];
// //
// //
// //   List<String> years = List.generate(40, (index) => (DateTime.now().year - index).toString());
// //
// //   void _onChanged(dynamic val) => debugPrint(val.toString());
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Padding(
// //         padding: const EdgeInsets.all(10),
// //         child: SingleChildScrollView(
// //           child: Column(
// //             children: <Widget>[
// //               FormBuilder(
// //                 key: _formKey,
// //                 // enabled: false,
// //                 onChanged: () {
// //                   _formKey.currentState!.save();
// //                   debugPrint(_formKey.currentState!.value.toString());
// //                 },
// //                 autovalidateMode: AutovalidateMode.disabled,
// //                 initialValue: const {
// //                   'movie_rating': 5,
// //                   'best_language': 'Dart',
// //                   'age': '13',
// //                   'gender': 'Male',
// //                   'languages_filter': ['Dart']
// //                 },
// //                 skipDisabled: true,
// //                 child: Column(
// //                   children: <Widget>[
// //                     const SizedBox(height: 15),
// //
// //                     //Region Select
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
// //                           _regionHasError = !(_formKey
// //                               .currentState?.fields['province']
// //                               ?.validate() ??
// //                               false);
// //                         });
// //                         //  print('Region: ' + _selectedValues['Region'].toString());
// //                       },
// //                       valueTransformer: (val) => val?.toString(),
// //                     ),
// //
// //
// //                     //RTOM Entering
// //                     Stack(
// //                       alignment: Alignment.centerRight,
// //                       children: [
// //                         FormBuilderTextField(
// //                           name: 'Rtom_name',
// //                           decoration: InputDecoration(
// //                             labelText: 'RTOM',
// //                           ),
// //                           validator: FormBuilderValidators.required(),
// //                           onChanged: (value) => setState(() {
// //                             _selectedValues['Rtom_name'] = value!;
// //                             //  print('RTOM: ' + _selectedValues['RTOM'].toString());
// //                           }),
// //                         ),
// //                         // Show tick mark if data is entered
// //                         _formKey.currentState?.fields['Rtom_name']?.value?.toString()?.isNotEmpty ?? false
// //                             ? Icon(
// //                           Icons.check,
// //                           color: Colors.green,
// //                         )
// //                             : SizedBox(),
// //                       ],
// //                     ),
// //
// //
// //                     //Station Text Field
// //                     Stack(
// //                       alignment: Alignment.centerRight,
// //                       children: [
// //                         FormBuilderTextField(
// //                           name: 'station',
// //                           decoration: InputDecoration(
// //                             labelText: 'Station',
// //                           ),
// //                           validator: FormBuilderValidators.required(),
// //                           onChanged: (value) => setState(() {}),
// //                         ),
// //                         // Show tick mark if data is entered
// //                         _formKey.currentState?.fields['station']?.value?.toString()?.isNotEmpty ?? false
// //                             ? Icon(
// //                           Icons.check,
// //                           color: Colors.green,
// //                         )
// //                             : SizedBox(),
// //                       ],
// //                     ),
// //
// //
// //                     //Generator Availability
// //                     FormBuilderChoiceChip<String>(
// //                       autovalidateMode: AutovalidateMode.onUserInteraction,
// //                       decoration: const InputDecoration(
// //                           labelText: 'Generator Available?'),
// //                       name: 'Available',
// //                       initialValue: 'Yes',
// //                       selectedColor: Colors.lightBlueAccent,
// //                       options: const [
// //                         FormBuilderChipOption(
// //                           value: 'Yes',
// //                           avatar: CircleAvatar(child: Text('Y')),
// //                         ),
// //                         FormBuilderChipOption(
// //                           value: 'No',
// //                           avatar: CircleAvatar(child: Text('N')),
// //                         ),
// //                       ],
// //                       onChanged: _onChanged,
// //                     ),
// //
// //                     //Generator Type
// //                     FormBuilderChoiceChip<String>(
// //                       autovalidateMode: AutovalidateMode.onUserInteraction,
// //                       decoration: const InputDecoration(
// //                           labelText: 'Generator Type'),
// //                       name: 'category',
// //                       initialValue: 'Fixed',
// //                       selectedColor: Colors.lightBlueAccent,
// //                       options: const [
// //                         FormBuilderChipOption(
// //                           value: 'Fixed',
// //                           avatar: CircleAvatar(child: Text('F')),
// //                         ),
// //                         FormBuilderChipOption(
// //                           value: 'Mobile',
// //                           avatar: CircleAvatar(child: Text('M')),
// //                         ),
// //                         FormBuilderChipOption(
// //                           value: 'Portable',
// //                           avatar: CircleAvatar(child: Text('P')),
// //                         ),
// //                       ],
// //                       onChanged: _onChanged,
// //                     ),
// //
// //                     //Alternator Brand
// //                     FormBuilderDropdown<String>(
// //                       name: 'brand_alt',
// //                       decoration: InputDecoration(
// //                         labelText: 'Alternator Brand',
// //                         suffix: _aBrandHasError
// //                             ? const Icon(Icons.error)
// //                             : const Icon(Icons.check, color: Colors.green),
// //                         hintText: 'Select Engine Brand',
// //                       ),
// //                       validator: FormBuilderValidators.compose(
// //                           [FormBuilderValidators.required()]),
// //                       items: alternatorBrands
// //                           .map((aBrand) => DropdownMenuItem(
// //                         alignment: AlignmentDirectional.center,
// //                         value: aBrand,
// //                         child: Text(aBrand),
// //                       ))
// //                           .toList(),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           _aBrandHasError = !(_formKey
// //                               .currentState?.fields['brand_alt']
// //                               ?.validate() ??
// //                               false);
// //                         });
// //                       },
// //                       valueTransformer: (val) => val?.toString(),
// //                     ),
// //
// //
// //                     //Engine Brand
// //                     FormBuilderDropdown<String>(
// //                       name: 'brand_eng',
// //                       decoration: InputDecoration(
// //                         labelText: 'Engine Brand',
// //                         suffix: _eBrandHasError
// //                             ? const Icon(Icons.error)
// //                             : const Icon(Icons.check, color: Colors.green),
// //                         hintText: 'Select Engine Brand',
// //                       ),
// //                       validator: FormBuilderValidators.compose(
// //                           [FormBuilderValidators.required()]),
// //                       items: engineBrands
// //                           .map((eBrand) => DropdownMenuItem(
// //                         alignment: AlignmentDirectional.center,
// //                         value: eBrand,
// //                         child: Text(eBrand),
// //                       ))
// //                           .toList(),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           _eBrandHasError = !(_formKey
// //                               .currentState?.fields['brand_eng']
// //                               ?.validate() ??
// //                               false);
// //                         });
// //                       },
// //                       valueTransformer: (val) => val?.toString(),
// //                     ),
// //
// //
// //
// //                     //Set Brand
// //                     FormBuilderDropdown<String>(
// //                       name: 'brand_set',
// //                       decoration: InputDecoration(
// //                         labelText: 'Set Brand',
// //                         suffix: _sBrandHasError
// //                             ? const Icon(Icons.error)
// //                             : const Icon(Icons.check, color: Colors.green),
// //                         hintText: 'Select Engine Brand',
// //                       ),
// //                       validator: FormBuilderValidators.compose(
// //                           [FormBuilderValidators.required()]),
// //                       items: setBrands
// //                           .map((sBrand) => DropdownMenuItem(
// //                         alignment: AlignmentDirectional.center,
// //                         value: sBrand,
// //                         child: Text(sBrand),
// //                       ))
// //                           .toList(),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           _sBrandHasError = !(_formKey
// //                               .currentState?.fields['brand_set']
// //                               ?.validate() ??
// //                               false);
// //                         });
// //                       },
// //                       valueTransformer: (val) => val?.toString(),
// //                     ),
// //
// //
// //                     //Alternator Model Text Field
// //                     Stack(
// //                       alignment: Alignment.centerRight,
// //                       children: [
// //                         FormBuilderTextField(
// //                           name: 'model_alt',
// //                           decoration: InputDecoration(
// //                             labelText: 'Alternator Model',
// //                           ),
// //                           //validator: FormBuilderValidators.required(),
// //                           onChanged: (value) => setState(() {}),
// //                         ),
// //                         // Show tick mark if data is entered
// //                         _formKey.currentState?.fields['model_alt']?.value?.toString()?.isNotEmpty ?? false
// //                             ? Icon(
// //                           Icons.check,
// //                           color: Colors.green,
// //                         )
// //                             : SizedBox(),
// //                       ],
// //                     ),
// //
// //
// //                     //Engine Model Text Field
// //                     Stack(
// //                       alignment: Alignment.centerRight,
// //                       children: [
// //                         FormBuilderTextField(
// //                           name: 'model_eng',
// //                           decoration: InputDecoration(
// //                             labelText: 'Engine Model',
// //                           ),
// //                           //validator: FormBuilderValidators.required(),
// //                           onChanged: (value) => setState(() {}),
// //                         ),
// //                         // Show tick mark if data is entered
// //                         _formKey.currentState?.fields['model_eng']?.value?.toString()?.isNotEmpty ?? false
// //                             ? Icon(
// //                           Icons.check,
// //                           color: Colors.green,
// //                         )
// //                             : SizedBox(),
// //                       ],
// //                     ),
// //
// //                     //Set Model Text Field
// //                     Stack(
// //                       alignment: Alignment.centerRight,
// //                       children: [
// //                         FormBuilderTextField(
// //                           name: 'model_set',
// //                           decoration: InputDecoration(
// //                             labelText: 'Set Model',
// //                           ),
// //                           //validator: FormBuilderValidators.required(),
// //                           onChanged: (value) => setState(() {}),
// //                         ),
// //                         // Show tick mark if data is entered
// //                         _formKey.currentState?.fields['model_set']?.value?.toString()?.isNotEmpty ?? false
// //                             ? Icon(
// //                           Icons.check,
// //                           color: Colors.green,
// //                         )
// //                             : SizedBox(),
// //                       ],
// //                     ),
// //
// //
// //                     //Alternator Serial Text Field
// //                     Stack(
// //                       alignment: Alignment.centerRight,
// //                       children: [
// //                         FormBuilderTextField(
// //                           name: 'serial_alt',
// //                           decoration: InputDecoration(
// //                             labelText: 'Alternator Serial',
// //                           ),
// //                           //validator: FormBuilderValidators.required(),
// //                           onChanged: (value) => setState(() {}),
// //                         ),
// //                         // Show tick mark if data is entered
// //                         _formKey.currentState?.fields['serial_alt']?.value?.toString()?.isNotEmpty ?? false
// //                             ? Icon(
// //                           Icons.check,
// //                           color: Colors.green,
// //                         )
// //                             : SizedBox(),
// //                       ],
// //                     ),
// //
// //
// //                     //Engine Serial Text Field
// //                     Stack(
// //                       alignment: Alignment.centerRight,
// //                       children: [
// //                         FormBuilderTextField(
// //                           name: 'serial_eng',
// //                           decoration: InputDecoration(
// //                             labelText: 'Engine Serial',
// //                           ),
// //                           //validator: FormBuilderValidators.required(),
// //                           onChanged: (value) => setState(() {}),
// //                         ),
// //                         // Show tick mark if data is entered
// //                         _formKey.currentState?.fields['serial_eng']?.value?.toString()?.isNotEmpty ?? false
// //                             ? Icon(
// //                           Icons.check,
// //                           color: Colors.green,
// //                         )
// //                             : SizedBox(),
// //                       ],
// //                     ),
// //
// //                     //Set Serial Text Field
// //                     Stack(
// //                       alignment: Alignment.centerRight,
// //                       children: [
// //                         FormBuilderTextField(
// //                           name: 'serial_set',
// //                           decoration: InputDecoration(
// //                             labelText: 'Set Serial',
// //                           ),
// //                           //validator: FormBuilderValidators.required(),
// //                           onChanged: (value) => setState(() {}),
// //                         ),
// //                         // Show tick mark if data is entered
// //                         _formKey.currentState?.fields['serial_set']?.value?.toString()?.isNotEmpty ?? false
// //                             ? Icon(
// //                           Icons.check,
// //                           color: Colors.green,
// //                         )
// //                             : SizedBox(),
// //                       ],
// //                     ),
// //
// //
// //                     //Generator mode
// //                     FormBuilderChoiceChip<String>(
// //                       autovalidateMode: AutovalidateMode.onUserInteraction,
// //                       decoration: const InputDecoration(
// //                           labelText: 'Generator Mode'),
// //                       name: 'mode',
// //                       initialValue: 'A',
// //                       selectedColor: Colors.lightBlueAccent,
// //                       options: const [
// //                         FormBuilderChipOption(
// //                           value: 'A',
// //                           avatar: CircleAvatar(child: Text('A')),
// //                         ),
// //                         FormBuilderChipOption(
// //                           value: 'M',
// //                           avatar: CircleAvatar(child: Text('M')),
// //                         ),
// //                       ],
// //                       onChanged: _onChanged,
// //                     ),
// //
// //                     //Generator phase
// //                     FormBuilderChoiceChip<String>(
// //                       autovalidateMode: AutovalidateMode.onUserInteraction,
// //                       decoration: const InputDecoration(
// //                           labelText: 'Generator Phase'),
// //                       name: 'phase_eng',
// //                       initialValue: '1',
// //                       selectedColor: Colors.lightBlueAccent,
// //                       options: const [
// //                         FormBuilderChipOption(
// //                           value: '1',
// //                           avatar: CircleAvatar(child: Text('3')),
// //                         ),
// //                         FormBuilderChipOption(
// //                           value: '3',
// //                           avatar: CircleAvatar(child: Text('1')),
// //                         ),
// //                       ],
// //                       onChanged: _onChanged,
// //                     ),
// //
// //                     //Generator Capacity
// //                     FormBuilderTextField(
// //                       autovalidateMode: AutovalidateMode.always,
// //                       name: 'set_cap',
// //                       decoration: InputDecoration(
// //                         labelText: 'Set Capacity (KVA)',
// //                         suffixIcon: _capacityHasError
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : const Icon(Icons.check, color: Colors.green),
// //                       ),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           _capacityHasError = !(_formKey.currentState?.fields['set_cap']
// //                               ?.validate() ??
// //                               false);
// //                         });
// //                       },
// //                       // valueTransformer: (text) => num.tryParse(text),
// //                       validator: FormBuilderValidators.compose([
// //                         FormBuilderValidators.required(),
// //                         FormBuilderValidators.numeric(),
// //                         FormBuilderValidators.max(10000),
// //                       ]),
// //                       // initialValue: '12',
// //                       keyboardType: TextInputType.number,
// //                       textInputAction: TextInputAction.next,
// //                     ),
// //
// //
// //                     //Prime Tank Capacity
// //                     FormBuilderTextField(
// //                       autovalidateMode: AutovalidateMode.always,
// //                       name: 'tank_prime',
// //                       decoration: InputDecoration(
// //                         labelText: 'Prime Tank Capacity (L)',
// //                         suffixIcon: _PTcapacityHasError
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : const Icon(Icons.check, color: Colors.green),
// //                       ),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           _PTcapacityHasError = !(_formKey.currentState?.fields['tank_prime']
// //                               ?.validate() ??
// //                               false);
// //                         });
// //                       },
// //                       // valueTransformer: (text) => num.tryParse(text),
// //                       validator: FormBuilderValidators.compose([
// //                         FormBuilderValidators.required(),
// //                         FormBuilderValidators.numeric(),
// //                         FormBuilderValidators.max(10000),
// //                       ]),
// //                       // initialValue: '12',
// //                       keyboardType: TextInputType.number,
// //                       textInputAction: TextInputAction.next,
// //                     ),
// //
// //
// //                     //Day Tank Available?
// //                     FormBuilderChoiceChip<String>(
// //                       autovalidateMode: AutovalidateMode.onUserInteraction,
// //                       decoration: const InputDecoration(
// //                           labelText: 'Day Tank Available?'),
// //                       name: 'dayTank',
// //                       initialValue: '0',
// //                       selectedColor: Colors.lightBlueAccent,
// //                       options: const [
// //                         FormBuilderChipOption(
// //                           value: '0',
// //                           avatar: CircleAvatar(child: Text('N')),
// //                         ),
// //                         FormBuilderChipOption(
// //                           value: '1',
// //                           avatar: CircleAvatar(child: Text('Y')),
// //                         ),
// //                       ],
// //                       onChanged: _onChanged,
// //                     ),
// //
// //                     //Day Tank Capacity
// //                     FormBuilderTextField(
// //                       autovalidateMode: AutovalidateMode.always,
// //                       name: 'dayTankSze',
// //                       decoration: InputDecoration(
// //                         labelText: 'Day Tank Capacity (L)',
// //                         suffixIcon: _DTcapacityHasError && _formKey.currentState?.fields['dayTankSze']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : _formKey.currentState?.fields['dayTankSze']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.check, color: Colors.green)
// //                             : null,
// //                       ),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           // Set the error state based on the validation result
// //                           _DTcapacityHasError = !(_formKey.currentState?.fields['dayTankSze']?.validate() ?? false);
// //                         });
// //                       },
// //                       validator: FormBuilderValidators.compose([
// //                         FormBuilderValidators.required(),
// //                         FormBuilderValidators.numeric(),
// //                         FormBuilderValidators.max(100000),
// //                       ]),
// //                       keyboardType: TextInputType.number,
// //                       textInputAction: TextInputAction.next,
// //                     ),
// //
// //
// //
// //                     //Feeder Cable size
// //                     FormBuilderTextField(
// //                       autovalidateMode: AutovalidateMode.always,
// //                       name: 'feederSize',
// //                       decoration: InputDecoration(
// //                         labelText: 'Feeder Cable size (mm^2)',
// //                         suffixIcon: _FeederCableHasError && _formKey.currentState?.fields['feederSize']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : _formKey.currentState?.fields['feederSize']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.check, color: Colors.green)
// //                             : null,
// //                       ),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           // Set the error state based on the validation result
// //                           _FeederCableHasError = !(_formKey.currentState?.fields['feederSize']?.validate() ?? false);
// //                         });
// //                       },
// //                       validator: FormBuilderValidators.compose([
// //                         FormBuilderValidators.numeric(),
// //                         FormBuilderValidators.max(1000),
// //                       ]),
// //                       keyboardType: TextInputType.number,
// //                       textInputAction: TextInputAction.next,
// //                     ),
// //
// //
// //                     //MCCB Rating
// //                     FormBuilderTextField(
// //                       autovalidateMode: AutovalidateMode.always,
// //                       name: 'RatingMCCB',
// //                       decoration: InputDecoration(
// //                         labelText: 'MCCB Rating (A)',
// //                         suffixIcon: _MCCBRatingHasError && _formKey.currentState?.fields['RatingMCCB']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : _formKey.currentState?.fields['RatingMCCB']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.check, color: Colors.green)
// //                             : null,
// //                       ),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           // Set the error state based on the validation result
// //                           _MCCBRatingHasError = !(_formKey.currentState?.fields['RatingMCCB']?.validate() ?? false);
// //                         });
// //                       },
// //                       validator: FormBuilderValidators.compose([
// //                         FormBuilderValidators.numeric(),
// //                         FormBuilderValidators.max(1000),
// //                       ]),
// //                       keyboardType: TextInputType.number,
// //                       textInputAction: TextInputAction.next,
// //                     ),
// //
// //
// //                     //ATS Rating
// //                     FormBuilderTextField(
// //                       autovalidateMode: AutovalidateMode.always,
// //                       name: 'RatingATS',
// //                       decoration: InputDecoration(
// //                         labelText: 'ATS Rating (A)',
// //                         suffixIcon: _ATSRatingHasError && _formKey.currentState?.fields['RatingATS']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : _formKey.currentState?.fields['RatingATS']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.check, color: Colors.green)
// //                             : null,
// //                       ),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           // Set the error state based on the validation result
// //                           _ATSRatingHasError = !(_formKey.currentState?.fields['RatingATS']?.validate() ?? false);
// //                         });
// //                       },
// //                       validator: FormBuilderValidators.compose([
// //                         FormBuilderValidators.numeric(),
// //                         FormBuilderValidators.max(1000),
// //                       ]),
// //                       keyboardType: TextInputType.number,
// //                       textInputAction: TextInputAction.next,
// //                     ),
// //
// //                     //ATS Brand
// //                     FormBuilderDropdown<String>(
// //                       name: 'BrandATS',
// //                       decoration: InputDecoration(
// //                         labelText: 'ATS Brand',
// //                         suffix: _atsBrandHasError
// //                             ? const Icon(Icons.error)
// //                             : const Icon(Icons.check, color: Colors.green),
// //                         hintText: 'Select ATS Brand',
// //                       ),
// //                       validator: FormBuilderValidators.compose(
// //                           [FormBuilderValidators.required()]),
// //                       items: ATSBrands
// //                           .map((atsBrand) => DropdownMenuItem(
// //                         alignment: AlignmentDirectional.center,
// //                         value: atsBrand,
// //                         child: Text(atsBrand),
// //                       ))
// //                           .toList(),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           _atsBrandHasError = !(_formKey
// //                               .currentState?.fields['BrandATS']
// //                               ?.validate() ??
// //                               false);
// //                         });
// //                       },
// //                       valueTransformer: (val) => val?.toString(),
// //                     ),
// //
// //
// //                     //ATS Model
// //                     FormBuilderTextField(
// //                       autovalidateMode: AutovalidateMode.always,
// //                       name: 'ModelATS',
// //                       decoration: InputDecoration(
// //                         labelText: 'ATS Model',
// //                         suffixIcon: _ATSModelHasError && _formKey.currentState?.fields['ModelATS']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : _formKey.currentState?.fields['ModelATS']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.check, color: Colors.green)
// //                             : null,
// //                       ),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           // Set the error state based on the validation result
// //                           _ATSModelHasError = !(_formKey.currentState?.fields['ModelATS']?.validate() ?? false);
// //                         });
// //                       },
// //                       validator: FormBuilderValidators.compose([
// //                         //FormBuilderValidators.numeric(),
// //                         //FormBuilderValidators.max(1000),
// //                       ]),
// //                       keyboardType: TextInputType.number,
// //                       textInputAction: TextInputAction.next,
// //                     ),
// //
// //
// //                     //Local Agent
// //                     FormBuilderTextField(
// //                       autovalidateMode: AutovalidateMode.always,
// //                       name: 'LocalAgent',
// //                       decoration: InputDecoration(
// //                         labelText: 'Local Agent',
// //                         suffixIcon: _agentHasError && _formKey.currentState?.fields['LocalAgent']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : _formKey.currentState?.fields['LocalAgent']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.check, color: Colors.green)
// //                             : null,
// //                       ),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           // Set the error state based on the validation result
// //                           _agentHasError = !(_formKey.currentState?.fields['LocalAgent']?.validate() ?? false);
// //                         });
// //                       },
// //                       validator: FormBuilderValidators.compose([
// //                         //FormBuilderValidators.numeric(),
// //                         //FormBuilderValidators.max(1000),
// //                       ]),
// //                       keyboardType: TextInputType.number,
// //                       textInputAction: TextInputAction.next,
// //                     ),
// //
// //                     //Local Agent address
// //                     FormBuilderTextField(
// //                       autovalidateMode: AutovalidateMode.always,
// //                       name: 'Agent_Addr',
// //                       decoration: InputDecoration(
// //                         labelText: 'Local Agent Address',
// //                         suffixIcon: _agentAddrHasError && _formKey.currentState?.fields['Local Agent Address']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : _formKey.currentState?.fields['Agent_Addr']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.check, color: Colors.green)
// //                             : null,
// //                       ),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           // Set the error state based on the validation result
// //                           _agentAddrHasError = !(_formKey.currentState?.fields['Agent_Addr']?.validate() ?? false);
// //                         });
// //                       },
// //                       validator: FormBuilderValidators.compose([
// //                         //FormBuilderValidators.numeric(),
// //                         //FormBuilderValidators.max(1000),
// //                       ]),
// //                       keyboardType: TextInputType.number,
// //                       textInputAction: TextInputAction.next,
// //                     ),
// //
// //
// //                     //Local Agent Tel
// //                     FormBuilderTextField(
// //                       autovalidateMode: AutovalidateMode.always,
// //                       name: 'Agent_Tel',
// //                       decoration: InputDecoration(
// //                         labelText: 'Local Agent Tel',
// //                         suffixIcon: _agentTelHasError && _formKey.currentState?.fields['Agent_Tel']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : _formKey.currentState?.fields['Agent_Tel']?.value.toString().isNotEmpty == true
// //                             ? const Icon(Icons.check, color: Colors.green)
// //                             : null,
// //                       ),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           // Set the error state based on the validation result
// //                           _agentTelHasError = !(_formKey.currentState?.fields['Agent_Tel']?.validate() ?? false);
// //                         });
// //                       },
// //                       validator: FormBuilderValidators.compose([
// //                         //FormBuilderValidators.numeric(),
// //                         //FormBuilderValidators.max(1000),
// //                       ]),
// //                       keyboardType: TextInputType.number,
// //                       textInputAction: TextInputAction.next,
// //                     ),
// //
// //
// //
// //                     //Year of Manufacture
// //                     FormBuilderDropdown<String>(
// //                       name: 'YoM',
// //                       decoration: InputDecoration(
// //                         labelText: 'Year of Manufacture',
// //                         hintText: 'Select Year of Manufacture',
// //                         suffixIcon: _yearOfManufactureHasError
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : (_formKey.currentState?.fields['YoM']?.value != null
// //                             ? const Icon(Icons.check, color: Colors.green)
// //                             : null),
// //                       ),
// //                       validator: FormBuilderValidators.required(),
// //                       items: years
// //                           .map((year) => DropdownMenuItem(
// //                         alignment: AlignmentDirectional.center,
// //                         value: year,
// //                         child: Text(year),
// //                       ))
// //                           .toList(),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           _yearOfManufactureHasError =
// //                           !(_formKey.currentState?.fields['YoM']?.validate() ?? false);
// //                         });
// //                       },
// //                       valueTransformer: (val) => val?.toString(),
// //                     ),
// //
// //
// //
// //                     //Year of Installation
// //                     FormBuilderDropdown<String>(
// //                       name: 'Yo_Install',
// //                       decoration: InputDecoration(
// //                         labelText: 'Year of Install',
// //                         hintText: 'Select Year of Installation',
// //                         suffixIcon: _yearOfInstallHasError
// //                             ? const Icon(Icons.error, color: Colors.red)
// //                             : (_formKey.currentState?.fields['Yo_Install']?.value != null
// //                             ? const Icon(Icons.check, color: Colors.green)
// //                             : null),
// //                       ),
// //                       validator: FormBuilderValidators.required(),
// //                       items: years
// //                           .map((year) => DropdownMenuItem(
// //                         alignment: AlignmentDirectional.center,
// //                         value: year,
// //                         child: Text(year),
// //                       ))
// //                           .toList(),
// //                       onChanged: (val) {
// //                         setState(() {
// //                           _yearOfInstallHasError =
// //                           !(_formKey.currentState?.fields['Yo_Install']?.validate() ?? false);
// //                         });
// //                       },
// //                       valueTransformer: (val) => val?.toString(),
// //                     ),
// //
// //
// //
// //                     FormBuilderCheckbox(
// //                       name: 'accept_terms',
// //                       initialValue: false,
// //                       onChanged: _onChanged,
// //                       title: RichText(
// //                         text: const TextSpan(
// //                           children: [
// //                             TextSpan(
// //                               text: 'I Verify that submitted details are true and correct ',
// //                               style: TextStyle(color: Colors.black),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       validator: FormBuilderValidators.equal(
// //                         true,
// //                         errorText:
// //                         'You must accept terms and conditions to continue',
// //                       ),
// //                     ),
// //
// //                   ],
// //                 ),
// //               ),
// //               Row(
// //                 children: <Widget>[
// //                   Expanded(
// //                     child: ElevatedButton(
// //                       onPressed: () {
// //                         if (_formKey.currentState?.saveAndValidate() ?? false) {
// //                           debugPrint(_formKey.currentState?.value.toString());
// //                           Map<String, dynamic> ? formData = _formKey.currentState?.value;
// //                           formData = formData?.map((key, value) => MapEntry(key, value ?? ''));
// //
// //                           // String rtom = _formKey.currentState?.value['Rtom_name'];
// //                           // debugPrint('RTOM value: $rtom');
// //                           //pass _formkey.currenState.value to a page called httpPostGen
// //
// //                           Navigator.push(
// //                             context,
// //                             MaterialPageRoute(builder: (context) => httpPostGen(formData: formData??{})),
// //                           );
// //
// //
// //
// //                         } else {
// //                           debugPrint(_formKey.currentState?.value.toString());
// //                           debugPrint('validation failed');
// //                         }
// //                       },
// //                       child: const Text(
// //                         'Submit',
// //                         style: TextStyle(color: Colors.white),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 20),
// //                   Expanded(
// //                     child: OutlinedButton(
// //                       onPressed: () {
// //                         _formKey.currentState?.reset();
// //                       },
// //                       // color: Theme.of(context).colorScheme.secondary,
// //                       child: Text(
// //                         'Reset',
// //                         style: TextStyle(
// //                             color: Theme.of(context).colorScheme.secondary),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// // }
