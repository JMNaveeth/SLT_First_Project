import 'package:flutter/material.dart';
// import 'package:flutter_application_1/notification/notificationPage.dart';
// import 'package:flutter_application_1/utils/colors.dart';
// import 'package:flutter_application_1/widgets/AppBar.dart';
// import 'package:flutter_application_1/widgets/gps_location_widget.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:theme_update/theme_provider.dart';
// import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/utils/utils/colors.dart';
import 'package:theme_update/widgets/theme%20change%20related%20widjets/theme_provider.dart';
import 'package:theme_update/widgets/theme%20change%20related%20widjets/theme_toggle_button.dart';

// import '../../../Widgets/GPSGrab/gps_location_widget.dart';
// import '../../HomePage/notification/notificationPage.dart';
// import '../../HomePage/utils/colors.dart';
// import '../../HomePage/widgets/AppBar.dart';
// import '../../UserAccess.dart';
import 'generator_details_model.dart';
import 'httpPostGeneratorUpdate.dart';

class GeneratorDetailUpdatePage extends StatefulWidget {
  final Generator generator;
  final String updator;
  final List brandeng;
  final List contBrand;
  final List brandset;
  final List brandAlt;
  final List brandAts;
  final List batBrand;

  GeneratorDetailUpdatePage({
    Key? key,
    required this.generator,
    required this.updator,
    required this.brandeng,
    required this.contBrand,
    required this.brandset,
    required this.brandAlt,
    required this.brandAts,
    required this.batBrand,
  }) : super(key: key);

  @override
  _GeneratorDetailUpdatePageState createState() =>
      _GeneratorDetailUpdatePageState();
}

class _GeneratorDetailUpdatePageState extends State<GeneratorDetailUpdatePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  late Map<String, dynamic> originalValues;
  late Map<String, dynamic> updatedValues;
  bool _isLoading = false;
  bool _isManual = false;
  bool _isAuto = false;

  String _latitude = '';
  String _longitude = '';
  String _error = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
  ];

  late List<String> brandeng = [];
  late List<String> contBrand = [];
  late List<String> brandset = [];
  late List<String> brandAlt = [];
  late List<String> brandAts = [];
  late List<String> batBrand = [];

  var myChoice = ['Yes', 'No'];
  void _fetchLocation() async {
    setState(() {
      _isLoading = true;
      _error = ''; // Reset error message when starting to fetch location
    });

    try {
      // GPSLocationFetcher locationFetcher = GPSLocationFetcher();
      // Map<String, String> location = await locationFetcher.fetchLocation();

      // // Debug print to check the location map
      // debugPrint("Fetched location data: $location");

      // if (location.containsKey('latitude') && location.containsKey('longitude')) {
      //   setState(() {
      //     _latitude = location['latitude'] ?? '';
      //     _longitude = location['longitude'] ?? '';
      //     updatedValues['Latitude'] = _latitude; // Ensure you use 'Latitude' if it needs to be uppercase
      //     updatedValues['Longitude'] = _longitude; // Ensure you use 'Longitude' if it needs to be uppercase
      //     _isLoading = false;
      //     debugPrint("Location $_latitude, $_longitude");
      //   });
      // } else {
      //   throw Exception('Location data is missing');
      // }
    } catch (e) {
      setState(() {
        _error = e.toString();
        debugPrint("Error: $_error");
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    brandeng = List<String>.from(widget.brandeng);
    contBrand = List<String>.from(widget.contBrand);
    brandset = List<String>.from(widget.brandset);
    brandAlt = List<String>.from(widget.brandAlt);
    brandAts = List<String>.from(widget.brandAts);
    batBrand = List<String>.from(widget.batBrand);
    originalValues = {
      'ID': widget.generator.ID,
      'Province': widget.generator.province,
      'Rtom Name': widget.generator.Rtom_name,
      'Station': widget.generator.station,
      'Available': widget.generator.Available ?? "",
      'Category': widget.generator.category ?? "",
      'Brand Alt': widget.generator.brand_alt ?? "",
      'Brand Eng': widget.generator.brand_eng ?? "",
      'Brand Set': widget.generator.brand_set ?? "",
      'Model Alt': widget.generator.model_alt ?? "",
      'Model Eng': widget.generator.model_eng ?? "",
      'Model Set': widget.generator.model_set ?? "",
      'Serial Alt': widget.generator.serial_alt ?? "",
      'Serial Eng': widget.generator.serial_eng ?? "",
      'Serial Set': widget.generator.serial_set ?? "",
      'Mode': widget.generator.mode ?? "",
      'Phase Eng': widget.generator.phase_eng ?? "",
      'Set Cap': widget.generator.set_cap ?? "",
      'Tank Prime': widget.generator.tank_prime ?? "",
      'Day Tank': widget.generator.dayTank ?? "",
      'Day Tank Size': widget.generator.dayTankSze ?? "",
      'Feeder Size': widget.generator.feederSize ?? "",
      'Rating MCCB': widget.generator.RatingMCCB ?? "",
      'Rating ATS': widget.generator.RatingATS ?? "",
      'Brand ATS': widget.generator.BrandATS ?? "",
      'Model ATS': widget.generator.ModelATS ?? "",
      'Local Agent': widget.generator.LocalAgent ?? "",
      'Agent Addr': widget.generator.Agent_Addr ?? "",
      'Agent Tel': widget.generator.Agent_Tel ?? "",
      'Year of Manufacture': widget.generator.YoM ?? "",
      'Year of Install': widget.generator.Yo_Install ?? "",
      'Battery Capacity': widget.generator.Battery_Capacity ?? "",
      'Battery Brand': widget.generator.Battery_Brand ?? "",
      'Battery Count': widget.generator.Battery_Count ?? "",
      'Controller': widget.generator.Controller ?? "",
      'Controller Model': widget.generator.controller_model ?? "",
      'Updated By': widget.generator.Updated_By ?? "",
      'Updated': widget.generator.updated ?? "",
      'Latitude': widget.generator.Latitude ?? "",
      'Longitude': widget.generator.Longitude ?? "",
    };
    updatedValues = Map.from(originalValues);
  }

  void _onChanged(
    dynamic val,
    Map<String, dynamic> formData,
    String fieldName,
  ) {
    setState(() {
      formData[fieldName] = val;

      if (originalValues[fieldName] != val) {
        updatedValues[fieldName] = val;
      }
    });
  }

  Future<void> _selectDate(BuildContext context, String fieldName) async {
    final currentDate =
        originalValues[fieldName] != null
            ? DateTime.parse(originalValues[fieldName])
            : DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1970),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(pickedDate);
        updatedValues[fieldName] = formattedDate;
      });
    }
  }

  void _showCustomBrandDialog({
    required String key,
    required List<String?> brandList,
    required Map<String, dynamic> formData,
    required String formKey, // A unique key for the form
  }) {
    TextEditingController customBrandController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: Colors.green),
          ),
          child: AlertDialog(
            title: Text("Add Custom Brand"),
            content: TextField(
              controller: customBrandController,
              decoration: InputDecoration(hintText: "Enter your brand name"),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  String customBrand = customBrandController.text.trim();
                  if (customBrand.isNotEmpty) {
                    setState(() {
                      if (!brandList.contains(customBrand)) {
                        brandList.add(customBrand);
                      }
                      formData[formKey] = customBrand;
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
    final customColors = Theme.of(context).extension<CustomColors>()!;

    // UserAccess userAccess = Provider.of<UserAccess>(context, listen: true); // Use listen: true to rebuild the widget when the data changes
    // String userName=userAccess.username!;
    return Scaffold(
      key: _scaffoldKey, // Assign the key to the Scaffold
      backgroundColor: customColors.mainBackgroundColor,

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
      //     title: "${widget.generator.ID} - ${widget.generator.station} Details",
      //   ),
      appBar: AppBar(
        title: Text(
          '${widget.generator.ID} - ${widget.generator.station} Details',
          style: TextStyle(color: customColors.mainTextColor),
        ),
        backgroundColor: customColors.appbarColor,
        iconTheme: IconThemeData(color: customColors.mainTextColor),

        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          initialValue: originalValues,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  textTitle: "ID",
                  isWantEdit: false,
                  generatorData: widget.generator.ID,
                  onChanged: (val) => _onChanged(val, updatedValues, "ID"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric(),
                  ]),
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 15),

                Text(
                  "Location",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: customColors.mainTextColor,
                  ),
                ),

                const SizedBox(height: 10),

                //Provine
                //Provine
                Card(
                  color: customColors.suqarBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                    child: Row(
                      children: [
                        Text(
                          "Province",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: customColors.mainTextColor,
                          ),
                        ),
                        const SizedBox(width: 122),
                        Flexible(
                          child: DropdownButtonFormField<String>(
                            value: widget.generator.province, // Default value

                            items:
                                Regions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                        color: customColors.mainTextColor,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (val) {
                              _onChanged(val, updatedValues, "Province");
                            },
                            style: TextStyle(
                              color: customColors.mainTextColor,
                            ), // Set the dropdown selected text color here
                            dropdownColor: customColors.suqarBackgroundColor,
                            decoration: InputDecoration(),
                            validator: FormBuilderValidators.compose([
                              //FormBuilderValidators.required(),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Rtom
                CustomTextField(
                  textTitle: "Rtom Name",
                  isWantEdit: true,
                  generatorData: widget.generator.Rtom_name,
                  onChanged:
                      (val) => _onChanged(val, updatedValues, "Rtom Name"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  keyboardType: TextInputType.name,
                ),
                //Station
                CustomTextField(
                  textTitle: "Station",
                  isWantEdit: true,
                  generatorData: widget.generator.station,
                  onChanged: (val) => _onChanged(val, updatedValues, "Station"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  keyboardType: TextInputType.name,
                ),
                // GPS Location Card
                Card(
                  color: customColors.suqarBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Location Set As",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: customColors.mainTextColor,
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Checkbox(
                              value: _isManual,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isManual = value!;
                                  if (value == true) _isAuto = false;
                                  if (_isAuto)
                                    _fetchLocation(); // Fetch location only if auto is true
                                });
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Manual",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  color: customColors.mainTextColor,
                                ),
                              ),
                            ),
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
                                  if (_isAuto)
                                    _fetchLocation(); // Fetch location only if auto is true
                                });
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Auto",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  color: customColors.mainTextColor,
                                ),
                              ),
                            ),
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
                          generatorData: updatedValues['Latitude'],
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            _onChanged(val, updatedValues, "Latitude");
                          },
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric(),
                          ]),
                        ),
                        CustomTextField(
                          textTitle: "Longitude",
                          isWantEdit: true,
                          generatorData: updatedValues['Longitude'],
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            _onChanged(val, updatedValues, "Longitude");
                          },
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric(),
                          ]),
                        ),
                      ],
                    )
                    : Card(
                      color: customColors.suqarBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              "Location",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: customColors.mainTextColor,
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Latitude : ${updatedValues['Latitude'] ?? 'N/A'}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  color: customColors.mainTextColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Longitude : ${updatedValues['Longitude'] ?? 'N/A'}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  color: customColors.mainTextColor,
                                ),
                              ),
                            ),
                            if (_isLoading)
                              CircularProgressIndicator(), // Show progress indicator when loading
                            if (_error.isNotEmpty)
                              Text(
                                "Error: $_error",
                                style: TextStyle(color: Colors.red),
                              ),
                          ],
                        ),
                      ),
                    ),

                const SizedBox(height: 20),

                Text(
                  "Genaral Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: customColors.mainTextColor,
                  ),
                ),

                const SizedBox(height: 10),

                //Available
                Card(
                  color: customColors.suqarBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                    child: Row(
                      children: [
                        Text(
                          "DEG Available",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: customColors.mainTextColor,
                          ),
                        ),
                        const SizedBox(width: 50),
                        Expanded(
                          child: FormBuilderChoiceChips<String>(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            //decoration: const InputDecoration(labelText: 'Type'),
                            name: 'Available',
                            initialValue: updatedValues['Available'],
                            selectedColor: Colors.lightBlueAccent,
                            backgroundColor: customColors.suqarBackgroundColor,
                            labelStyle: TextStyle(
                              fontSize: 10,
                              color: customColors.mainTextColor,
                            ),
                            spacing: 5,
                            runSpacing: 5,
                            options: const [
                              FormBuilderChipOption(
                                value: 'Yes',
                                avatar: CircleAvatar(child: Text('')),
                              ),
                              FormBuilderChipOption(
                                value: 'No',
                                avatar: CircleAvatar(child: Text('')),
                              ),
                            ],

                            // onChanged: _onChanged,
                            onChanged: (val) {
                              setState(() {
                                _onChanged(val, updatedValues, 'Available');
                                print(updatedValues['Available']);
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
                  color: customColors.suqarBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                    child: Row(
                      children: [
                        Text(
                          "DEG Category",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: customColors.mainTextColor,
                          ),
                        ),
                        const SizedBox(width: 100),
                        Expanded(
                          child: FormBuilderChoiceChips<String>(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            //decoration: const InputDecoration(labelText: 'Type'),
                            name: 'Category',
                            initialValue: updatedValues['Category'],
                            selectedColor: Colors.lightBlueAccent,
                            backgroundColor: customColors.suqarBackgroundColor,
                            labelStyle: TextStyle(
                              fontSize: 10,
                              color: customColors.mainTextColor,
                            ),
                            spacing: 5,
                            runSpacing: 5,
                            options: const [
                              FormBuilderChipOption(
                                value: 'Fixed',
                                avatar: CircleAvatar(child: Text('')),
                              ),
                              FormBuilderChipOption(
                                value: 'Mobile',
                                avatar: CircleAvatar(child: Text('')),
                              ),
                              FormBuilderChipOption(
                                value: 'Portable',
                                avatar: CircleAvatar(child: Text('')),
                              ),
                            ],

                            // onChanged: _onChanged,
                            onChanged: (val) {
                              setState(() {
                                _onChanged(val, updatedValues, 'Category');
                                print(updatedValues['Category']);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Mode
                Card(
                  color: customColors.suqarBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                    child: Row(
                      children: [
                        Text(
                          "Mode",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: customColors.mainTextColor,
                          ),
                        ),
                        const SizedBox(width: 90),
                        Expanded(
                          child: FormBuilderChoiceChips<String>(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            //decoration: const InputDecoration(labelText: 'Type'),
                            name: 'Mode',
                            initialValue: updatedValues['Mode'],
                            selectedColor: Colors.lightBlueAccent,
                            backgroundColor: customColors.suqarBackgroundColor,
                            labelStyle: TextStyle(
                              fontSize: 10,
                              color: customColors.mainTextColor,
                            ),
                            spacing: 5,
                            runSpacing: 5,
                            options: const [
                              FormBuilderChipOption(
                                value: 'A',
                                child: Text('Auto'),
                                // avatar: CircleAvatar(child: Text('')),
                              ),
                              FormBuilderChipOption(
                                value: 'M',
                                child: Text('Manual'),
                                //avatar: CircleAvatar(child: Text('')),
                              ),
                            ],

                            // onChanged: _onChanged,
                            onChanged: (val) {
                              setState(() {
                                _onChanged(val, updatedValues, 'Mode');
                                print(updatedValues['Mode']);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Phase
                Card(
                  color: customColors.suqarBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                    child: Row(
                      children: [
                        Text(
                          "Phase Eng",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: customColors.mainTextColor,
                          ),
                        ),
                        const SizedBox(width: 100),
                        Expanded(
                          child: FormBuilderChoiceChips<String>(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            //decoration: const InputDecoration(labelText: 'Type'),
                            name: 'Phase Eng',
                            initialValue: updatedValues['Phase Eng'],
                            selectedColor: Colors.lightBlueAccent,
                            backgroundColor: customColors.suqarBackgroundColor,
                            labelStyle: TextStyle(
                              fontSize: 10,
                              color: customColors.mainTextColor,
                            ),
                            spacing: 5,
                            runSpacing: 5,
                            options: const [
                              FormBuilderChipOption(
                                value: '1',
                                avatar: CircleAvatar(child: Text('')),
                              ),
                              FormBuilderChipOption(
                                value: '3',
                                avatar: CircleAvatar(child: Text('')),
                              ),
                            ],

                            // onChanged: _onChanged,
                            onChanged: (val) {
                              setState(() {
                                _onChanged(val, updatedValues, 'Phase Eng');
                                print(updatedValues['Phase Eng']);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //YOM
                CustomTextField(
                  textTitle: "Year of Manufacture",
                  isWantEdit: true,
                  generatorData: widget.generator.YoM ?? "",
                  onChanged:
                      (val) =>
                          _onChanged(val, updatedValues, "Year of Manufacture"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  keyboardType: TextInputType.number,
                ),
                //YOI
                CustomTextField(
                  textTitle: "Year of Install   ",
                  isWantEdit: true,
                  generatorData: widget.generator.Yo_Install ?? "",
                  onChanged:
                      (val) =>
                          _onChanged(val, updatedValues, "Year of Install"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  keyboardType: TextInputType.number,
                ),
                //Set Capacity
                CustomTextField(
                  textTitle: "Set Capacity(kVA)",
                  isWantEdit: true,
                  generatorData: widget.generator.set_cap ?? "",
                  onChanged: (val) => _onChanged(val, updatedValues, "Set Cap"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  keyboardType: TextInputType.name,
                ),

                const SizedBox(height: 20),

                Text(
                  "Generator Specifications",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: customColors.mainTextColor,
                  ),
                ),

                const SizedBox(height: 10),

                //Brand Alt
                Card(
                  color: customColors.suqarBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                    child: Row(
                      children: [
                        Text(
                          "Alternator Brand",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: customColors.mainTextColor,
                          ),
                        ),
                        // Spacer(),
                        const SizedBox(width: 70),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value:
                                brandAlt.contains(updatedValues["Brand Alt"])
                                    ? updatedValues["Brand Alt"]
                                    : "Other", // Default value

                            items: [
                              ...brandAlt
                                  .where((String value) => value != "Other")
                                  .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: customColors.mainTextColor,
                                        ),
                                      ),
                                    );
                                  })
                                  .toList(),
                              DropdownMenuItem<String>(
                                value: "Other",
                                child: Text(
                                  "Other",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                    color: customColors.mainTextColor,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (val) {
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
                            style: TextStyle(
                              color: customColors.mainTextColor,
                            ), // Set the dropdown selected text color here
                            dropdownColor:
                                customColors
                                    .suqarBackgroundColor, // Set the dropdown background color here
                            validator: FormBuilderValidators.compose([
                              //FormBuilderValidators.required(),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Model Alt
                CustomTextField(
                  textTitle: "Alternator Model",
                  isWantEdit: true,
                  generatorData: widget.generator.model_alt ?? "",
                  onChanged:
                      (val) => _onChanged(val, updatedValues, "Model Alt"),
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(),
                  // ]),
                  keyboardType: TextInputType.name,
                ),
                //Serial Alt
                CustomTextField(
                  textTitle: "Alternator serial",
                  isWantEdit: true,
                  generatorData: widget.generator.serial_alt ?? "",
                  onChanged:
                      (val) => _onChanged(val, updatedValues, "Serial Alt"),
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(),
                  // ]),
                  keyboardType: TextInputType.number,
                ),

                //Brand Eng
                Card(
                  color: customColors.suqarBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                    child: Row(
                      children: [
                        Text(
                          "Engine Brand",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: customColors.mainTextColor,
                          ),
                        ),
                        const SizedBox(width: 80),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value:
                                brandeng.contains(updatedValues["Brand Eng"])
                                    ? updatedValues["Brand Eng"]
                                    : "Other", // Default value

                            items: [
                              ...brandeng
                                  .where((String value) => value != "Other")
                                  .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: customColors.mainTextColor,
                                        ),
                                      ),
                                    );
                                  })
                                  .toList(),
                              DropdownMenuItem<String>(
                                value: "Other",
                                child: Text("Other"),
                              ),
                            ],
                            onChanged: (val) {
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
                            dropdownColor: customColors.suqarBackgroundColor,
                            // Set the dropdown background color here
                            validator: FormBuilderValidators.compose([
                              // FormBuilderValidators.required(), // Uncomment if needed
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Model eng
                CustomTextField(
                  textTitle: "Engine Model",
                  isWantEdit: true,
                  generatorData: widget.generator.model_eng ?? "",
                  onChanged:
                      (val) => _onChanged(val, updatedValues, "Model Eng"),
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(),
                  // ]),
                  keyboardType: TextInputType.name,
                ),
                //Serial Eng
                CustomTextField(
                  textTitle: "Engine Serial",
                  isWantEdit: true,
                  generatorData: widget.generator.serial_eng ?? "",
                  onChanged:
                      (val) => _onChanged(val, updatedValues, "Serial Eng"),
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(),
                  // ]),
                  keyboardType: TextInputType.number,
                ),

                //Brand Set
                Card(
                  color: customColors.suqarBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                    child: Row(
                      children: [
                        Text(
                          "Set Brand",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: customColors.mainTextColor,
                          ),
                        ),
                        const SizedBox(width: 100),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value:
                                brandset.contains(updatedValues["Brand Set"])
                                    ? updatedValues["Brand Set"]
                                    : "Other", // Default value

                            items: [
                              ...brandset
                                  .where((String value) => value != "Other")
                                  .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                        ),
                                      ),
                                    );
                                  })
                                  .toList(),
                              DropdownMenuItem<String>(
                                value: "Other",
                                child: Text("Other"),
                              ),
                            ],
                            onChanged: (val) {
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
                            style: TextStyle(
                              color: customColors.mainTextColor,
                            ), // Set the dropdown selected text color here
                            dropdownColor:
                                customColors
                                    .suqarBackgroundColor, // Set the dropdown background color here
                            validator: FormBuilderValidators.compose([
                              // Uncomment or add validators as needed
                              // FormBuilderValidators.required(),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Model Set
                CustomTextField(
                  textTitle: "Set Model",
                  isWantEdit: true,
                  generatorData: widget.generator.model_set ?? "",
                  onChanged:
                      (val) => _onChanged(val, updatedValues, "Model Set"),
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(),
                  // ]),
                  keyboardType: TextInputType.name,
                ),
                //Serial Set
                CustomTextField(
                  textTitle: "Set Serial",
                  isWantEdit: true,
                  generatorData: widget.generator.serial_set ?? "",
                  onChanged:
                      (val) => _onChanged(val, updatedValues, "Serial Set"),
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(),
                  // ]),
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 20),

                Text(
                  "Controller Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: customColors.mainTextColor,
                  ),
                ),

                const SizedBox(height: 10),

                //Controller
                Card(
                  color: customColors.suqarBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                    child: Row(
                      children: [
                        Text(
                          "Controller Brand",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: customColors.mainTextColor,
                          ),
                        ),
                        const SizedBox(width: 80),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value:
                                contBrand.contains(updatedValues["Controller"])
                                    ? updatedValues["Controller"]
                                    : "Other", // Default value

                            items: [
                              ...contBrand
                                  .where((String value) => value != "Other")
                                  .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: customColors.mainTextColor,
                                        ),
                                      ),
                                    );
                                  })
                                  .toList(),
                              DropdownMenuItem<String>(
                                value: "Other",
                                child: Text("Other"),
                              ),
                            ],
                            onChanged: (val) {
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
                            style: TextStyle(
                              color: customColors.mainTextColor,
                            ), // Set the dropdown selected text color here
                            dropdownColor: customColors.suqarBackgroundColor,
                            validator: FormBuilderValidators.compose([
                              // Uncomment or add validators as needed
                              // FormBuilderValidators.required(),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //Controller Model
                CustomTextField(
                  textTitle: "Controller Model",
                  isWantEdit: true,
                  generatorData: widget.generator.controller_model ?? "",
                  onChanged:
                      (val) =>
                          _onChanged(val, updatedValues, "Controller Model"),
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(),
                  // ]),
                  keyboardType: TextInputType.name,
                ),

                const SizedBox(height: 20),

                Text(
                  "Tank Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: customColors.mainTextColor,
                  ),
                ),

                const SizedBox(height: 10),

                CustomTextField(
                  textTitle: "Day Tank Capacity(L)",
                  isWantEdit: true,
                  generatorData: widget.generator.tank_prime ?? "",
                  onChanged:
                      (val) => _onChanged(val, updatedValues, "Tank Prime"),
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(),
                  // ]),
                  keyboardType: TextInputType.name,
                ),

                //Day tank Available
                Card(
                  color: customColors.suqarBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                    child: Row(
                      children: [
                        Text(
                          "Bulk Tank Available",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: customColors.mainTextColor,
                          ),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          child: FormBuilderChoiceChips<String>(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            //decoration: const InputDecoration(labelText: 'Type'),
                            name: 'Day Tank',
                            initialValue: updatedValues['Day Tank'],
                            selectedColor: Colors.lightBlueAccent,
                            backgroundColor: customColors.suqarBackgroundColor,
                            labelStyle: TextStyle(
                              fontSize: 10,
                              color: customColors.mainTextColor,
                            ),
                            spacing: 5,
                            runSpacing: 5,
                            options: const [
                              FormBuilderChipOption(
                                value: '1',
                                child: Text('Yes'),
                                //avatar: CircleAvatar(child: Text('')),
                              ),
                              FormBuilderChipOption(
                                value: '0',
                                child: Text('No'),
                                //avatar: CircleAvatar(child: Text('')),
                              ),
                            ],

                            // onChanged: _onChanged,
                            onChanged: (val) {
                              setState(() {
                                _onChanged(val, updatedValues, 'Day Tank');
                                print(updatedValues['Day Tank']);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Tank Cap day
                CustomTextField(
                  textTitle: "Bulk Tank Size(L)",
                  isWantEdit: true,
                  generatorData: widget.generator.dayTankSze ?? "",
                  onChanged:
                      (val) => _onChanged(val, updatedValues, "Day Tank Size"),
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(),
                  // ]),
                  keyboardType: TextInputType.name,
                ),

                //Tank cap Prime

                //   GestureDetector(
                //     onTap: () => _selectDate(context, "Installed Date"),
                //     child: Card(
                //       child: Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                //           children: [
                //             Text(
                //               "Installed Date",
                //               style: TextStyle(
                //                   fontWeight: FontWeight.w500, fontSize: 15),
                //             ),
                //             Spacer(),
                //             Text(
                //               updatedValues['Installed Date'] ?? 'Not Set',
                //               style: TextStyle(fontSize: 15),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                const SizedBox(height: 20),

                Text(
                  "ATS and Cabling",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: customColors.mainTextColor,
                  ),
                ),

                const SizedBox(height: 20),

                //Brand ATS
                Card(
                  color: customColors.suqarBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                    child: Row(
                      children: [
                        Text(
                          "ATS Brand",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: customColors.mainTextColor,
                          ),
                        ),
                        SizedBox(width: 80),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value:
                                brandAts.contains(updatedValues["BrandATS"])
                                    ? updatedValues["BrandATS"]
                                    : "Other", // Default value

                            items: [
                              ...brandAts
                                  .where((String value) => value != "Other")
                                  .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  })
                                  .toList(),
                              DropdownMenuItem<String>(
                                value: "Other",
                                child: Text(
                                  "Other",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                    color: customColors.mainTextColor,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (val) {
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
                            },
                            style: TextStyle(
                              color: customColors.mainTextColor,
                            ), // Set the dropdown selected text color here
                            dropdownColor: customColors.suqarBackgroundColor,
                            validator: FormBuilderValidators.compose([
                              // Uncomment or add validators as needed
                              // FormBuilderValidators.required(),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //Rating ATS
                CustomTextField(
                  textTitle: "ATS Rating(A)",
                  isWantEdit: true,
                  generatorData: widget.generator.RatingATS ?? "",
                  onChanged:
                      (val) => _onChanged(val, updatedValues, "Rating ATS"),
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(),
                  // ]),
                  keyboardType: TextInputType.number,
                ),
                //Model ATS
                CustomTextField(
                  textTitle: "ATS Model",
                  isWantEdit: true,
                  generatorData: widget.generator.ModelATS ?? "",
                  onChanged:
                      (val) => _onChanged(val, updatedValues, "Model ATS"),
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(),
                  // ]),
                  keyboardType: TextInputType.name,
                ),
                //Feeder Cable
                CustomTextField(
                  textTitle: "Feeder Cable Size(mm^2)",
                  isWantEdit: true,
                  generatorData: widget.generator.feederSize ?? "",
                  onChanged:
                      (val) => _onChanged(val, updatedValues, "Feeder Size"),
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(),
                  // ]),
                  keyboardType: TextInputType.number,
                ),
                //MCCB
                CustomTextField(
                  textTitle: "MCCB Rating(A)",
                  isWantEdit: true,
                  generatorData: widget.generator.RatingMCCB ?? "",
                  onChanged:
                      (val) => _onChanged(val, updatedValues, "Rating MCCB"),
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(),
                  // ]),
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 20),

                Text(
                  "Battery Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: customColors.mainTextColor,
                  ),
                ),

                const SizedBox(height: 10),
                //Bat count
                CustomTextField(
                  textTitle: "Battery Count",
                  isWantEdit: true,
                  generatorData: widget.generator.Battery_Count ?? "",
                  onChanged:
                      (val) => _onChanged(val, updatedValues, "Battery Count"),
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(),
                  // ]),
                  keyboardType: TextInputType.name,
                ),
                //Bat Brand
                Card(
                  color: customColors.suqarBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                    child: Row(
                      children: [
                        Text(
                          "Battery Brand",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: customColors.mainTextColor,
                          ),
                        ),
                        SizedBox(width: 70),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value:
                                batBrand.contains(
                                      updatedValues["Battery Brand"],
                                    )
                                    ? updatedValues["Battery Brand"]
                                    : "Other", // Default value

                            items: [
                              ...batBrand
                                  .where((String value) => value != "Other")
                                  .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: customColors.mainTextColor,
                                        ),
                                      ),
                                    );
                                  })
                                  .toList(),
                              DropdownMenuItem<String>(
                                value: "Other",
                                child: Text("Other"),
                              ),
                            ],
                            onChanged: (val) {
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
                            },
                            style: TextStyle(
                              color: customColors.mainTextColor,
                            ), // Set the dropdown selected text color here
                            dropdownColor: customColors.suqarBackgroundColor,
                            validator: FormBuilderValidators.compose([
                              // Uncomment or add validators as needed
                              // FormBuilderValidators.required(),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //Bat Capacity
                CustomTextField(
                  textTitle: "Battery Capacity(Ah)",
                  isWantEdit: true,
                  generatorData: widget.generator.Battery_Capacity ?? "",
                  onChanged:
                      (val) =>
                          _onChanged(val, updatedValues, "Battery Capacity"),
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(),
                  // ]),
                  keyboardType: TextInputType.name,
                ),

                const SizedBox(height: 20),

                Text(
                  "Service Provider",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: customColors.mainTextColor,
                  ),
                ),

                const SizedBox(height: 10),

                CustomTextField(
                  textTitle: "Local Agent",
                  isWantEdit: true,
                  generatorData: widget.generator.LocalAgent ?? "",
                  onChanged:
                      (val) => _onChanged(val, updatedValues, "Local Agent"),
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(),
                  // ]),
                  keyboardType: TextInputType.name,
                ),
                CustomTextField(
                  textTitle: "Agent Address",
                  isWantEdit: true,
                  generatorData: widget.generator.Agent_Addr ?? "",
                  onChanged:
                      (val) => _onChanged(val, updatedValues, "Agent Addr"),
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(),
                  // ]),
                  keyboardType: TextInputType.name,
                ),
                CustomTextField(
                  textTitle: "Agent Telephone",
                  isWantEdit: true,
                  generatorData: widget.generator.Agent_Tel ?? "",
                  onChanged:
                      (val) => _onChanged(val, updatedValues, "Agent Tel"),
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(),
                  // ]),
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 20),

                Text(
                  "Update Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: customColors.mainTextColor,
                  ),
                ),

                const SizedBox(height: 10),

                CustomTextField(
                  textTitle: "Updated By",
                  isWantEdit: false,
                  generatorData: widget.generator.Updated_By ?? "",
                  onChanged:
                      (val) => _onChanged(val, updatedValues, "Updated By"),
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(),
                  // ]),
                  keyboardType: TextInputType.name,
                ),
                GestureDetector(
                  onTap: () {},
                  //_selectDate(context, "Last Updated"),
                  child: Card(
                    color: customColors.suqarBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        10.0,
                        10.0,
                        20.0,
                        10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Updated",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: customColors.mainTextColor,
                            ),
                          ),
                          Spacer(),
                          Text(
                            updatedValues['Updated'] ?? 'Not Set',
                            style: TextStyle(
                              fontSize: 15,
                              color: customColors.mainTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //   CustomTextField(
                //     textTitle: "Updated By",
                //     isWantEdit: false,
                //     generatorData: widget.generator.updatedBy ?? "",
                //     onChanged: (val) =>
                //         _onChanged(val, updatedValues, "Updated By"),
                //     validator: FormBuilderValidators.compose([
                //       FormBuilderValidators.required(),
                //     ]),
                //     keyboardType: TextInputType.name,
                //   ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.blue,
                        ),
                        minimumSize: MaterialStateProperty.all(
                          Size(150, 50),
                        ), // Change size (width, height)
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  11,
                                ), // Change border radius
                              ),
                            ),
                      ),
                      onPressed: () {
                        Navigator.pop(
                          context,
                        ); // Navigate back to the previous screen
                      },
                      child: Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.white // Adjust color as needed
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.blue,
                        ),
                        minimumSize: MaterialStateProperty.all(
                          Size(150, 50), // Adjusted size for two buttons
                        ), // Change size (width, height)
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  11,
                                ), // Change border radius
                              ),
                            ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.saveAndValidate()) {
                          final editedFields = _getEditedFields(updatedValues);
                          print(editedFields);
                          print(updatedValues.toString());
                          //_saveDetails(updatedgeneratorDetails);
                        }
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => HttpGeneratorUpdatePostPage(
                        //       formData: updatedValues,
                        //       username: userName,
                        //     ),
                        //   ),
                        // );
                      },
                      child: Text(
                        'Send to Approval',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getEditedFields(
    Map<String, dynamic> updatedGeneratorDetails,
  ) {
    final editedFields = <String, dynamic>{};
    updatedGeneratorDetails.forEach((key, value) {
      if (originalValues[key] != value) {
        editedFields[key] = value;
      }
    });
    print(editedFields.toString());
    return editedFields;
  }
}

class CustomTextField extends StatelessWidget {
  final String textTitle;
  final bool isWantEdit;
  final String generatorData;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const CustomTextField({
    Key? key,
    required this.textTitle,
    required this.isWantEdit,
    required this.generatorData,
    this.onChanged,
    this.validator,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Card(
      color: customColors.suqarBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              textTitle,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: customColors.mainTextColor,
              ),
            ),
            Spacer(),
            Expanded(
              child: FormBuilderTextField(
                name: textTitle,
                initialValue: generatorData,
                enabled: isWantEdit,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: customColors.mainTextColor, // Set the text color here
                ),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(), // Underline border style
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: customColors.mainTextColor,
                    ), // Border color when enabled
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ), // Border color when focused
                  ),
                  contentPadding: EdgeInsets.only(
                    bottom: 0,
                  ), // Adjust padding if needed
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
