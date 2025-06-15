import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// import '../../../../../Widgets/GPSGrab/gps_location_widget.dart';
 import '../../../../../Widgets/LoadLocations/httpGetLocations.dart';
// import '../../../../UserAccess.dart';
import 'httpPostPrecision.dart';

class AddPrecisionAcUnit extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const AddPrecisionAcUnit({super.key, this.initialData});

  @override
  _AddPrecisionAcUnitState createState() => _AddPrecisionAcUnitState();
}

class _AddPrecisionAcUnitState extends State<AddPrecisionAcUnit> {
  final _formKey = GlobalKey<FormBuilderState>();
  final Map<String, dynamic> _formData = {};
  int _noOfCompressors = 1; // Default value for number of compressors
  Map<String, String> newValues = {};
  String userName = 'testUser';

  //user variable

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _formData.addAll(widget.initialData!);
    }
  }

  void _resetForm() {
    setState(() {
      _formKey.currentState?.reset();
      _formData.clear();
      _serialNumbersList.clear();
      // _serialNumberControllers.clear();
    });
  }

  //final GPSLocationFetcher _locationFetcher = GPSLocationFetcher();

  TextEditingController _latitudeController = TextEditingController();
  TextEditingController _longitudeController = TextEditingController();

  void _fetchLocation() async {
    try {
      //final location = await _locationFetcher.fetchLocation();
      setState(() {
        // _latitudeController.text = location['latitude']!;
        // _longitudeController.text = location['longitude']!;
      });

      // Update _formData with fetched location
      _formData['Latitude'] = _latitudeController.text;
      _formData['Longitude'] = _longitudeController.text;
    } catch (e) {
      // Handle error, show a message to the user
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Row(
              children: [
                Icon(
                  CupertinoIcons.exclamationmark_triangle,
                  color: Color(0xFFFC4C16),
                ),
                SizedBox(width: 10),
                Text('Error'),
              ],
            ),
            content: Text(
              'Location Service is Disabled. Please Enable them to use auto-location',
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // UserAccess userAccess = Provider.of<UserAccess>(context, listen: true); // Use listen: true to rebuild the widget when the data changes
    // userName=userAccess.username!;

    return ChangeNotifierProvider(
      create: (context) => null,
    //  create: (context) => LocationProvider()..loadAllData(),
    // child: Consumer<LocationProvider>(
         child: Consumer<dynamic>(
        builder: (context, locationProvider, child) {
          var _isVerified;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Add Precision AC Unit',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Color(0xFF0056A2),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FormBuilder(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Location Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // _RegionDropdown('Region', 'Region',locationProvider),
                      _RegionDropdown(
                        'Region',
                        'Region',
                        locationProvider,
                        _formData,
                        context,
                      ),
                      _RtomDropdown(
                        'RTOM',
                        'RTOM',
                        locationProvider,
                        _formData,
                        context,
                      ),
                      _StationDropdown(
                        'Station',
                        'Station',
                        locationProvider,
                        _formData,
                        context,
                      ),

                      _buildTextField(
                        'building_id',
                        'Building Id(eg: Building A)',
                      ),
                      _buildTextField(
                        'floor_number',
                        'Floor Number (eg:OTS-1-AC-No)',
                      ),
                      _buildTextFieldModelValidated(
                        'Office_No',
                        'Office Number (eg: 01)',
                      ),
                      _buildTextFieldLocationValidated(
                        'Location',
                        'Location (eg:OTS UPS room)',
                      ),

                      SizedBox(height: 20),
                      // GPS Location fields
                      Text(
                        'Mark GPS Location of the Unit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // GPS Location fields
                      _buildGPSLatitudeField(
                        'Latitude',
                        'Latitude(Enter Manually or press Get Location)',
                        _latitudeController,
                      ),
                      _buildGPSLongitudeField(
                        'Longitude',
                        'Longitude(Enter Manually or press Get Location)',
                        _longitudeController,
                      ),

                      SizedBox(height: 20),
                      // Fetch Location Button
                      CupertinoButton(
                        onPressed: _fetchLocation,
                        color: Color(0xFF00AEE4),
                        child: Row(
                          mainAxisSize:
                              MainAxisSize.min, // Keeps the button size compact
                          children: [
                            Icon(
                              Icons.location_on, // choose any icon you prefer
                              color:
                                  Colors.white, // Adjust the color of the icon
                            ),
                            SizedBox(
                              width: 8,
                            ), // space between the icon and text
                            Text('Get Location'),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      Text(
                        'General Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),

                      _buildTextField('QRTag', 'Tag code(eg:PR:0001)'),
                      _buildTextFieldModelValidated(
                        'Model',
                        'Model(eg:Brand_Name-model)',
                      ),
                      _buildNumValTextField('Serial_Number', 'Serial Number'),
                      _ManufacturerDropdown('Manufacturer', 'Manufacturer'),
                      _buildCustomDateField(
                        'Installation_Date',
                        'Installation Date(YYYY-MM-DD)',
                      ),
                      _StatusDropdown('Status', 'Status'),

                      SizedBox(height: 5),

                      _buildAnnualMaintenanceContractField(
                        'AMC_Expire_Date',
                        'Annual Maintenance Contract',
                      ),

                      // _buildTextField('UpdatedBy', 'Updated By(Officer name)'),
                      // _buildDatePicker('UpdatedTime', 'Updated Time(YYYY-MM-DD)'),
                      SizedBox(height: 40),

                      Text(
                        'Technical Specifications',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // More fields
                      _buildCoolingCapacityTextField(
                        'Cooling_Capacity',
                        'Cooling Capacity (in BTU/hr)',
                      ),
                      _PowerSupplyDropdown('Power_Supply', 'Power Supply'),
                      _RefrigDropdown('Refrigerant_Type', 'Refrigerant Type'),
                      _buildDimensionTextField(
                        'Dimensions',
                        'Dimensions (eg:cm x cm x cm)',
                      ),
                      _buildNumWeightTextField('Weight', 'Weight (in Kg)'),
                      _buildNoiseLevelTextField(
                        'Noise_Level',
                        'Noise Level (in dbm)',
                      ),

                      SizedBox(height: 20),
                      Text(
                        'Compressor details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Compressor Details Section
                      _buildAlphanumericTextField(
                        'No_of_Compressors',
                        'No of Compressors',
                      ),

                      SizedBox(height: 10),

                      _buildSerialNumberDisplayFields(),
                      _buildEnterSerialNumbersField(),
                      SizedBox(height: 5),

                      _ConditionAirFilterDropdown(
                        'Condition_Indoor_Air_Filters',
                        'Condition of the Indoor Air Filters',
                      ),
                      _ConditionIndoorDropdown(
                        'Condition_Indoor_Unit',
                        'Condition of the Indoor Unit',
                      ),
                      _ConditionIndoorDropdown(
                        'Condition_Outdoor_Unit',
                        'Condition of the Outdoor Unit',
                      ),
                      _buildUnvalidatedTextField(
                        'Other_Specifications',
                        'Other Specifications',
                      ),
                      _buildNumAirflowTextField(
                        'Airflow',
                        'Airflow Rate( In CFM)',
                      ),
                      _AirflowTypeDropdown('Airflow_Type', 'Airflow Type'),

                      //need airflow type
                      _buildNumValueFieldsTextField(
                        'No_of_Refrigerant_Circuits',
                        'No of Refrigerant Circuits',
                      ),
                      _buildNumValueFieldsTextField(
                        'No_of_Evaporator_Coils',
                        'No of Evaporator Coils',
                      ),
                      _buildNumValueFieldsTextField(
                        'No_of_Condenser_Circuits',
                        'No of Condenser Circuits',
                      ),
                      _buildNumValueFieldsTextField(
                        'No_of_Condenser_Fans',
                        'No of Condenser Fans',
                      ),

                      _buildNumValueFieldsTextField(
                        'No_of_Indoor_Fans',
                        'No of indoor Fans',
                      ),

                      _CondensorMountedDropdown(
                        'Condenser_Mounting_Method',
                        'Condenser Mounting Method',
                      ),

                      SizedBox(height: 40),

                      Text(
                        'Supplier And Warranty',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Supplier details
                      _buildTextFieldNonValidated(
                        'Supplier_Name',
                        'Supplier Name',
                      ),
                      _buildTextFieldEmailValidated(
                        'Supplier_email',
                        'Supplier Email',
                      ),
                      _buildTextFieldMobileValidated(
                        'Supplier_contact_no',
                        'Supplier Contact no',
                      ),
                      // _buildTextFieldContactDetails('Supplier_Contact_Details', 'Supplier Contact Details'),
                      _buildWarrantyAvailableField(
                        'Warranty_Details',
                        'Warranty Available ?',
                      ),
                      _buildDatePicker(
                        'Warranty_Expire_Date',
                        'Warranty Expire Date',
                      ),

                      SizedBox(height: 10),

                      FormBuilderCheckbox(
                        name: 'verify',
                        initialValue: _isVerified,
                        title: Text(
                          'I verify that submitted details are true and correct',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _isVerified = value;
                          });
                        },

                        checkColor: Colors.white,
                        activeColor: Color(0xFF4FB846),

                        validator: (value) {
                          if (value != true) {
                            return 'You must verify the details to proceed.';
                          }
                          return null;
                        },
                      ),

                      // Submit Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CupertinoButton(
                              onPressed: _resetForm,
                              child: const Text('Reset'),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 10.0,
                              ),
                              color: Color(0xFF4DB146),
                            ),
                          ),

                          const SizedBox(
                            width: 10,
                          ), // Add spacing between buttons

                          Expanded(
                            child: CupertinoButton(
                              onPressed: _submitData,
                              child: const Text('Submit'),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 10.0,
                              ),
                              color: Color(0xFF00AEE4),
                            ),
                          ),

                          // ElevatedButton(
                          //   onPressed: () {
                          //     print(_formData); // Print collected data to console
                          //   }, child: null,
                          // )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGPSLatitudeField(
    String name,
    String label,
    TextEditingController controller,
  ) {
    return FormBuilderTextField(
      name: name,
      keyboardType: TextInputType.number,

      controller: controller,
      decoration: InputDecoration(labelText: label),
      readOnly: false,

      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Please enter $label'),
      ]),
    );
  }

  Widget _buildGPSLongitudeField(
    String key,
    String label,
    TextEditingController controller,
  ) {
    return FormBuilderTextField(
      name: key,
      keyboardType: TextInputType.number,

      controller: controller,
      decoration: InputDecoration(labelText: label),
      readOnly: false,

      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Please enter $label'),
      ]),
    );
  }

  //===================================

  List<dynamic> _serialNumbersList = []; // List to store serial numbers
  List<TextEditingController> _serialNumberControllers =
      []; // List to manage controllers persistently
  bool _showEnterSerialNumbersField =
      false; // Toggle for showing Enter Serial Numbers button/field

  Widget _buildAlphanumericTextField(String key, String label) {
    return FormBuilderTextField(
      name: key,
      initialValue: _formData[key]?.toString() ?? '',
      decoration: InputDecoration(labelText: label),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Please enter $label'),
        FormBuilderValidators.integer(errorText: 'Please enter a valid number'),
        FormBuilderValidators.min(
          1,
          errorText: 'Minimum 1 compressor required',
        ),
        FormBuilderValidators.max(
          4,
          errorText: 'Maximum 4 compressors allowed',
        ),
      ]),

      autovalidateMode:
          AutovalidateMode.onUserInteraction, // Enable auto-validation

      onChanged: (value) {
        _formData[key] = value ?? '';

        if (key == 'No_of_Compressors') {
          int numberOfCompressors = int.tryParse(value ?? '0') ?? 0;

          if (numberOfCompressors > 0) {
            setState(() {
              _showEnterSerialNumbersField =
                  true; // Show the enter serial numbers field
              _serialNumbersList.clear(); // Clear previous serial numbers
              _serialNumberControllers.clear(); // Clear previous controllers
            });
          } else {
            setState(() {
              _showEnterSerialNumbersField =
                  false; // Hide the enter serial numbers field
              _serialNumbersList.clear();
              _serialNumberControllers.clear();
              _formData['Serial_Number_of_the_Compressors'] = '';
            });
          }
        }
      },
    );
  }

  // Method to build the "Enter Serial Numbers" button
  Widget _buildEnterSerialNumbersField() {
    if (!_showEnterSerialNumbersField)
      return Container(); // Return empty container if field is hidden

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: CupertinoButton(
        onPressed: () {
          _showSerialNumbersDialog();
        },
        color: const Color(0xFF4DB146),
        child: Text('Enter Serial Numbers'),
      ),
    );
  }

  Future<void> _showSerialNumbersDialog() async {
    int numberOfCompressors =
        int.tryParse(_formData['No_of_Compressors'] ?? '0') ?? 0;

    if (_serialNumberControllers.length != numberOfCompressors) {
      _serialNumberControllers = List.generate(
        numberOfCompressors,
        (index) => TextEditingController(
          text:
              _serialNumbersList.length > index
                  ? _serialNumbersList[index]
                  : '',
        ),
      );
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Serial Numbers'),
          content: SingleChildScrollView(
            child: Column(
              children:
                  _serialNumberControllers.map((controller) {
                    return TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText:
                            'Serial Number ${_serialNumberControllers.indexOf(controller) + 1}',
                      ),
                    );
                  }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Update the serial numbers list based on user input
                setState(() {
                  _serialNumbersList =
                      _serialNumberControllers.map((c) => c.text).toList();
                  _formData['Serial_Number_of_the_Compressors'] =
                      _serialNumbersList.join(', ');
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Method to build uneditable text fields to display serial numbers
  Widget _buildSerialNumberDisplayFields() {
    if (_serialNumbersList.isEmpty)
      return Container(); // Return an empty container if there are no serial numbers

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            'Serial Numbers of Compressors:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ..._serialNumberControllers.map((controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              controller: TextEditingController(text: controller.text),
              decoration: InputDecoration(
                labelText: 'Serial Number',
                border: OutlineInputBorder(),
              ),
              readOnly: true, // Make the text field uneditable
            ),
          );
        }).toList(),
      ],
    );
  }

  //=====================================

  Widget _buildUnvalidatedTextField(String key, String label) {
    return FormBuilderTextField(
      name: key,
      initialValue: _formData[key]?.toString() ?? '',
      decoration: InputDecoration(labelText: label),
      // validator: FormBuilderValidators.required(errorText: 'Please enter $label'),
      onChanged: (value) {
        _formData[key] = value ?? '';
      },
    );
  }

  Widget _buildDimensionTextField(String key, String label) {
    return FormBuilderTextField(
      name: key,
      keyboardType: TextInputType.number,
      initialValue: _formData[key]?.toString() ?? '',
      decoration: InputDecoration(labelText: label),
      validator: FormBuilderValidators.required(
        errorText: 'Please enter $label',
      ),
      onChanged: (value) {
        _formData[key] = value ?? '';
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildCoolingCapacityTextField(String key, String label) {
    return FormBuilderTextField(
      name: key,
      keyboardType: TextInputType.number,
      initialValue: _formData[key]?.toString() ?? '',
      decoration: InputDecoration(labelText: label),

      onChanged: (value) {
        _formData[key] = value ?? '';
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormBuilderValidators.compose([
        // Max length of 25 characters
        FormBuilderValidators.required(errorText: 'Please enter $label'),
        // Allow only English capital letters and colons
        FormBuilderValidators.match(
          RegExp(r'^[a-zA-Z0-9&_: ]+$'),
          errorText: 'Only English capital letters and Numbers are allowed',
        ),
      ]),
    );
  }

  Widget _buildDatePicker(String key, String label) {
    return FormBuilderDateTimePicker(
      name: key,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
      inputType: InputType.date,
      decoration: InputDecoration(labelText: label),
      onChanged: (value) {
        setState(() {
          _formData[key] = value?.toString().split(' ')[0];
        });
      },
    );
  }

  Widget _buildAnnualMaintenanceContractField(String key, String label) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label, // Display the provided label
              style: TextStyle(
                fontSize: 16, // Increase label text size
              ),
            ),
            SizedBox(height: 2),
            // Add gap between label and choice chips
            FormBuilderChoiceChips(
              name: key, // Use the provided key for form field name
              initialValue:
                  _formData[key]?.toString() ?? '', // Set initial value
              options: [
                FormBuilderChipOption(value: "1", child: Text('Available')),
                FormBuilderChipOption(value: "0", child: Text('Not Available')),
              ],
              spacing: 10,
              selectedColor: Colors.green, // Change color to match your theme
              selectedShadowColor:
                  Colors.greenAccent.shade700, // Change shadow color
              onChanged: (value) {
                _formData[key] = value ?? '';
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWarrantyAvailableField(String key, String label) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label, // Display the provided label
              style: TextStyle(
                fontSize: 16, // Increase label text size
              ),
            ),
            SizedBox(height: 2), // Add gap between label and choice chips
            FormBuilderChoiceChips(
              name: key, // Use the provided key for form field name
              initialValue:
                  _formData[key]?.toString() ?? '', // Set initial value
              options: [
                FormBuilderChipOption(value: "1", child: Text('Yes')),
                FormBuilderChipOption(value: "0", child: Text('No')),
              ],
              spacing: 10,
              selectedColor: Colors.green, // Change color to match your theme
              selectedShadowColor:
                  Colors.greenAccent.shade700, // Change shadow color
              onChanged: (value) {
                _formData[key] = value ?? '';
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomDateField(String fieldName, String labelText) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(text: _formData[fieldName] ?? ''),
      decoration: InputDecoration(labelText: labelText),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a date';
        }
        return null;
      },
      onTap: () async {
        DateTime? pickedDate = await _selectDate(context);
        if (pickedDate != null) {
          setState(() {
            _formData[fieldName] =
                _formData[fieldName] = DateFormat.yMd().format(pickedDate);
          });
        }
      },
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    return picked != null
        ? DateTime(picked.year, picked.month, picked.day)
        : null;
  }

  //installation date picker

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(_formData);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  HttpPostPrecision(formDataList: _formData, User: userName),
        ),
      );
    }
  }

  Widget _buildTextFieldNonValidated(String key, String label) {
    return FormBuilderTextField(
      name: key,
      initialValue: _formData[key]?.toString() ?? '',
      decoration: InputDecoration(
        labelText: label,
        errorStyle: TextStyle(
          color: Colors.red,
        ), // Optional: Customize error text style
      ),

      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        setState(() {
          _formData[key] = value ?? '';
        });
      },

      validator: FormBuilderValidators.compose([
        // Max length of 25 characters
        FormBuilderValidators.maxLength(
          25,
          errorText: 'Max length is 25 characters',
        ),
        // Allow only English capital letters and colons
        FormBuilderValidators.match(
          RegExp(r'^[a-zA-Z0-9&_: @]+$'),
          errorText: 'Only English letters and Numbers are allowed',
        ),
      ]),
    );
  }

  Widget _buildTextFieldEmailValidated(String key, String label) {
    return FormBuilderTextField(
      name: key,
      initialValue: _formData[key]?.toString() ?? '',
      decoration: InputDecoration(
        labelText: label,
        errorStyle: TextStyle(color: Colors.red), // Customize error text style
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        setState(() {
          _formData[key] = value ?? '';
        });
      },
      validator: FormBuilderValidators.compose([
        // FormBuilderValidators.required(errorText: 'Email is required'), // Make email mandatory
        FormBuilderValidators.email(
          errorText: 'Invalid email format',
        ), // Validate email format
        FormBuilderValidators.maxLength(
          50,
          errorText: 'Max length is 50 characters',
        ), // Increased max length for typical email lengths
      ]),
    );
  }

  Widget _buildTextFieldMobileValidated(String key, String label) {
    return FormBuilderTextField(
      name: key,
      initialValue: _formData[key]?.toString() ?? '',
      decoration: InputDecoration(
        labelText: label,
        errorStyle: TextStyle(color: Colors.red), // Customize error text style
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        setState(() {
          _formData[key] = value ?? '';
        });
      },
      validator: FormBuilderValidators.compose([
        // FormBuilderValidators.required(errorText: 'Mobile number is required'), // Ensure the field is not empty
        FormBuilderValidators.match(
          RegExp(
            r'^[a-zA-Z0-9&_: ]+$',
          ), // Regex for mobile number starting with '0' and exactly 10 digits
          errorText: 'must start with 0 and have exactly 10 digits.',
        ),
      ]),
      keyboardType: TextInputType.phone, // Set keyboard type to phone
    );
  }

  List<String> Manufacturers = ['STULZ', 'Vertiv Liebert', 'Other'];

  Widget _ManufacturerDropdown(String key, String label) {
    return FormBuilderDropdown(
      name: key,
      initialValue: _formData[key] ?? '', // Ensure there's a default value
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items:
          Manufacturers.map(
            (Manufacturer) => DropdownMenuItem(
              value: Manufacturer,
              child: Text(Manufacturer),
            ),
          ).toList(),
      validator: (value) {
        if (value == null || value.toString().isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _formData[key] = value;
        });

        if (value == 'Other') {
          _showCustomManufacturerDialog(key);
        }
      },
    );
  }

  void _showCustomManufacturerDialog(String key) {
    TextEditingController customManufacturerController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: Colors.green),
          ),
          child: AlertDialog(
            title: Text("Add Manufacturer"),
            content: TextField(
              controller: customManufacturerController,
              decoration: InputDecoration(hintText: "Enter Manufacturer name"),
              autofocus: true, // Automatically focus on the input field
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
                  String customManufacturer =
                      customManufacturerController.text.trim();
                  if (customManufacturer.isNotEmpty &&
                      !Manufacturers.contains(customManufacturer)) {
                    setState(() {
                      Manufacturers.insert(
                        Manufacturers.length - 1,
                        customManufacturer,
                      );
                      _formData[key] = customManufacturer;
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

  List<String> AirflowTypes = ['STULZ', 'Vertiv Liebert', 'Other'];

  Widget _AirflowTypesDropdown(String key, String label) {
    return FormBuilderDropdown(
      name: key,
      initialValue: _formData[key] ?? '', // Ensure there's a default value
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items:
          AirflowTypes.map(
            (AirflowType) =>
                DropdownMenuItem(value: AirflowType, child: Text(AirflowType)),
          ).toList(),
      validator: (value) {
        if (value == null || value.toString().isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _formData[key] = value;
        });

        if (value == 'Other') {
          _showCustomAirflowTypesDialog(key);
        }
      },
    );
  }

  void _showCustomAirflowTypesDialog(String key) {
    TextEditingController customManufacturerController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: Colors.green),
          ),
          child: AlertDialog(
            title: Text("Add Manufacturer"),
            content: TextField(
              controller: customManufacturerController,
              decoration: InputDecoration(hintText: "Enter Manufacturer name"),
              autofocus: true, // Automatically focus on the input field
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
                  String customManufacturer =
                      customManufacturerController.text.trim();
                  if (customManufacturer.isNotEmpty &&
                      !Manufacturers.contains(customManufacturer)) {
                    setState(() {
                      Manufacturers.insert(
                        Manufacturers.length - 1,
                        customManufacturer,
                      );
                      _formData[key] = customManufacturer;
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

  //======================================txtfields=====================================================

  Widget _buildTextField(String key, String label) {
    return FormBuilderTextField(
      name: key,
      initialValue: _formData[key]?.toString() ?? '',
      decoration: InputDecoration(
        labelText: label,
        errorStyle: TextStyle(
          color: Colors.red,
        ), // Optional: Customize error text style
      ),

      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Please enter $label'),
        FormBuilderValidators.match(
          RegExp(r'^[a-zA-Z0-9&_: ]+$'),
          errorText: '$label must contain only letters and numbers',
        ),
        // FormBuilderValidators.minLength(1, errorText: 'Minimum 5 characters.'),
        FormBuilderValidators.maxLength(
          25,
          errorText: 'Maximum 25 characters.',
        ),
      ]),

      autovalidateMode:
          AutovalidateMode.onUserInteraction, //validation on input

      onChanged: (value) {
        _formData[key] = value ?? '';
      },
    );
  }

  Widget _buildTextFieldLocationValidated(String key, String label) {
    return FormBuilderTextField(
      name: key,
      initialValue: _formData[key]?.toString() ?? '',
      decoration: InputDecoration(
        labelText: label,
        errorStyle: TextStyle(
          color: Colors.red,
        ), // Optional: Customize error text style
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Please enter $label'),
        FormBuilderValidators.match(
          RegExp(r'^[#/a-zA-Z0-9&_: /#-.@]+$'),
          errorText:
              '$label must contain letters, numbers, and allowed symbols (&, _, :).',
        ),
        FormBuilderValidators.maxLength(
          20,
          errorText: 'Maximum 20 characters allowed.',
        ),
      ]),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        _formData[key] = value ?? '';
      },
    );
  }

  Widget _buildTextFieldModelValidated(String key, String label) {
    return FormBuilderTextField(
      name: key,
      initialValue: _formData[key]?.toString() ?? '',
      decoration: InputDecoration(
        labelText: label,
        errorStyle: TextStyle(color: Colors.red),
      ),

      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        setState(() {
          _formData[key] = value ?? '';
        });
      },
      validator: FormBuilderValidators.compose([
        // Max length of 25 characters
        FormBuilderValidators.maxLength(
          25,
          errorText: 'Max length is 25 characters',
        ),
        // Allow only English capital letters and colons
        FormBuilderValidators.match(
          RegExp(r'^[-a-zA-Z0-9&_: ]+$'),
          errorText: 'Only English capital letters and colons are allowed',
        ),
      ]),
    );
  }

  Widget _buildNumValTextField(String key, String label) {
    return FormBuilderTextField(
      keyboardType: TextInputType.text,
      name: key,
      initialValue: _formData[key]?.toString() ?? '',

      decoration: InputDecoration(
        labelText: label,
        errorStyle: TextStyle(
          color: Colors.red,
        ), // Optional: Customize error text style
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Please enter $label'),
        // FormBuilderValidators.numeric(errorText: '$label must be a number'),
        // Custom validator to ensure the number is an integer
        //     (value) {
        //   final numValue = num.tryParse(value ?? '');
        //   if (numValue == null) {
        //     return '$label must be a number';
        //   }
        //   if (numValue % 1 != 0) {
        //     return '$label must be an integer';
        //   }
        //   return null;
        // },
        // FormBuilderValidators.min(1, errorText: '$label must be at least 1'),
        // FormBuilderValidators.maxLength(
        //     10, errorText: '$label cannot be more than 10 characters'),
        FormBuilderValidators.match(
          RegExp(r'^[a-zA-Z0-9&_: /#-.@]+$'),
          errorText: '$label must contain only numbers',
        ),
      ]),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        _formData[key] = value ?? '';
      },
    );
  }

  Widget _buildNumValueFieldsTextField(String key, String label) {
    return FormBuilderTextField(
      keyboardType: TextInputType.number,
      name: key,
      initialValue: _formData[key]?.toString() ?? '',

      decoration: InputDecoration(
        labelText: label,
        errorStyle: TextStyle(
          color: Colors.red,
        ), // Optional: Customize error text style
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Please enter $label'),
        FormBuilderValidators.numeric(errorText: '$label must be a number'),
        // Custom validator to ensure the number is an integer
        //     (value) {
        //   final numValue = num.tryParse(value ?? '');
        //   if (numValue == null) {
        //     return '$label must be a number';
        //   }
        //   if (numValue % 1 != 0) {
        //     return '$label must be an integer';
        //   }
        //   return null;
        // },
        // FormBuilderValidators.min(1, errorText: '$label must be at least 1'),
        // FormBuilderValidators.maxLength(
        //     10, errorText: '$label cannot be more than 10 characters'),
        FormBuilderValidators.match(
          RegExp(r'^[a-zA-Z0-9&_: ]+$'),
          errorText: '$label must contain only numbers and letters',
        ),
      ]),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        _formData[key] = value ?? '';
      },
    );
  }

  Widget _buildNoiseLevelTextField(String key, String label) {
    return FormBuilderTextField(
      keyboardType: TextInputType.number,
      name: key,
      initialValue: _formData[key]?.toString() ?? '',

      decoration: InputDecoration(
        labelText: label,
        errorStyle: TextStyle(
          color: Colors.red,
        ), // Optional: Customize error text style
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Please enter $label'),
        // FormBuilderValidators.numeric(errorText: '$label must be a number'),
        // Custom validator to ensure the number is an integer
        //     (value) {
        //   final numValue = num.tryParse(value ?? '');
        //   if (numValue == null) {
        //     return '$label must be a number';
        //   }
        //   if (numValue % 1 != 0) {
        //     return '$label must be an integer';
        //   }
        //   return null;
        // },
        // FormBuilderValidators.min(1, errorText: '$label must be at least 1'),
        // FormBuilderValidators.maxLength(
        //     10, errorText: '$label cannot be more than 10 characters'),
        FormBuilderValidators.match(
          RegExp(r'^[/#.a-zA-Z0-9&_:]+$'),
          errorText: '$label must contain only numbers',
        ),
      ]),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        _formData[key] = value ?? '';
      },
    );
  }

  Widget _buildNumWeightTextField(String key, String label) {
    return FormBuilderTextField(
      keyboardType: TextInputType.number,
      name: key,
      initialValue: _formData[key]?.toString() ?? '',

      decoration: InputDecoration(
        labelText: label,
        errorStyle: TextStyle(
          color: Colors.red,
        ), // Optional: Customize error text style
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Please enter $label'),
        // FormBuilderValidators.numeric(errorText: '$label must be a number'),
        // Custom validator to ensure the number is an integer
        //     (value) {
        //   final numValue = num.tryParse(value ?? '');
        //   if (numValue == null) {
        //     return '$label must be a number';
        //   }
        //   if (numValue % 1 != 0) {
        //     return '$label must be an integer';
        //   }
        //   return null;
        // },
        // FormBuilderValidators.min(1, errorText: '$label must be at least 1'),
        // FormBuilderValidators.maxLength(
        //     10, errorText: '$label cannot be more than 10 characters'),
        FormBuilderValidators.match(
          RegExp(r'^[.a-zA-Z0-9&_: /@+=]+$'),
          errorText: '$label must contain only numbers',
        ),
      ]),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        _formData[key] = value ?? '';
      },
    );
  }

  Widget _AirflowTypeDropdown(String key, String label) {
    return FormBuilderDropdown(
      name: key,
      initialValue: _formData[key],
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items:
          ['Upblow', 'DownBlow']
              .map(
                (status) =>
                    DropdownMenuItem(value: status, child: Text(status)),
              )
              .toList(),
      validator: (value) {
        if (value == null || value.toString().isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _formData[key] = value;
        });
      },
    );
  }

  Widget _buildNumAirflowTextField(String key, String label) {
    return FormBuilderTextField(
      keyboardType: TextInputType.number,
      name: key,
      initialValue: _formData[key]?.toString() ?? '',

      decoration: InputDecoration(
        labelText: label,
        errorStyle: TextStyle(
          color: Colors.red,
        ), // Optional: Customize error text style
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Please enter $label'),
        // FormBuilderValidators.numeric(errorText: '$label must be a number'),
        // Custom validator to ensure the number is an integer
        //     (value) {
        //   final numValue = num.tryParse(value ?? '');
        //   if (numValue == null) {
        //     return '$label must be a number';
        //   }
        //   if (numValue % 1 != 0) {
        //     return '$label must be an integer';
        //   }
        //   return null;
        // },
        // FormBuilderValidators.min(1, errorText: '$label must be at least 1'),
        // FormBuilderValidators.maxLength(
        //     10, errorText: '$label cannot be more than 10 characters'),
        FormBuilderValidators.match(
          RegExp(r'^[.-/#.a-zA-Z0-9&_: ]+$'),
          errorText: '$label must contain only numbers',
        ),
      ]),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        _formData[key] = value ?? '';
      },
    );
  }

  //dynamic serial number logic

  // Compressor Details Section
  Widget _buildCompressorDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Compressor Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        _buildNoOfCompressorsTextFieldDynamic(
          'No_of_Compressors',
          'No of Compressors',
        ),
        ..._buildSerialNumberFields(
          _noOfCompressors,
        ), // Dynamically generated serial number fields
      ],
    );
  }

  Widget _buildNoOfCompressorsTextFieldDynamic(String key, String label) {
    return FormBuilderTextField(
      name: key,
      keyboardType: TextInputType.number,
      initialValue: _formData[key],

      decoration: InputDecoration(
        labelText: label,
        suffixIcon: Icon(Icons.format_list_numbered),
      ),
      // keyboardType: TextInputType.number,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.numeric(),
        FormBuilderValidators.min(1), // Minimum number of compressors
      ]),
      onChanged: (value) {
        setState(() {
          _noOfCompressors = int.tryParse(value ?? '1') ?? 1;

          // Update dynamically
        });
      },
    );
  }

  List<Widget> _buildSerialNumberFields(int count) {
    return List.generate(count, (index) {
      return _buildAlphanumericTextField(
        'Serial_Number_of_Compressor_$index',
        'Serial Number of Compressor ${index + 1}',
      );
    });
  }

  //===================================================================================================================
  // Region Dropdown Widget

  Widget _RegionDropdown(
    String key,
    String label,
    //  LocationProvider
    locationProvider,
    Map<String, dynamic> _formData,
    BuildContext context,
  ) {
    if (locationProvider.isLoading || locationProvider.isCustomRegion) {
      return Center(child: CircularProgressIndicator());
    }

    return FormBuilderDropdown<String>(
      name: key,
      initialValue: locationProvider.selectedRegion,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items: [
        ...locationProvider.regions.map(
          (region) => DropdownMenuItem<String>(
            value: region.Region_ID,
            child: Text(region.RegionName),
          ),
        ),
        DropdownMenuItem<String>(value: 'Other', child: Text('Other')),
      ],
      validator:
          (value) =>
              value == null || value.isEmpty ? 'Please select $label' : null,
      onChanged: (value) {
        if (value == 'Other') {
          _showAddNewValueDialog(context, key, label, locationProvider);
        } else {
          // Get the region name based on selected Region_ID
          String? selectedRegionName =
              locationProvider.regions
                  .firstWhere(
                    (region) => region.Region_ID == value,
                    // orElse: () => null, // In case the region is not found
                  )
                  ?.RegionName;

          setState(() {
            // Store the region name in the formData
            _formData[key] = selectedRegionName;
            locationProvider.selectedRegion = value;
          });
        }
      },
    );
  }

  Widget _RtomDropdown(
    String key,
    String label,
    // LocationProvider
    locationProvider,
    Map<String, dynamic> _formData,
    BuildContext context,
  ) {
    if (locationProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    String? initialRtomValue =
        locationProvider.rtoms.any(
              (rtom) => rtom.RTOM_ID == locationProvider.selectedRtom,
            )
            ? locationProvider.selectedRtom
            : null;

    return FormBuilderDropdown<String>(
      name: key,
      initialValue: initialRtomValue,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items: [
        ...locationProvider.rtoms.map(
          (rtom) => DropdownMenuItem<String>(
            value: rtom.RTOM_ID,
            child: Text(rtom.RTOM),
          ),
        ),
        DropdownMenuItem<String>(value: 'Other', child: Text('Other')),
      ],
      validator:
          (value) =>
              value == null || value.isEmpty ? 'Please select $label' : null,
      onChanged: (value) {
        if (value == 'Other') {
          _showAddNewValueDialog(context, key, label, locationProvider);
        } else {
          // Get the RTOM name based on selected RTOM_ID
          String? selectedRtomName =
              locationProvider.rtoms
                  .firstWhere(
                    (rtom) => rtom.RTOM_ID == value,
                    // orElse: () => null, // Handle if RTOM is not found
                  )
                  ?.RTOM;

          setState(() {
            // Store the RTOM name in the formData
            _formData[key] = selectedRtomName;
            locationProvider.selectedRtom = value;
          });
        }
      },
    );
  }

  Widget _StationDropdown(
    String key,
    String label,
  //  LocationProvider 
    locationProvider,
    Map<String, dynamic> _formData,
    BuildContext context,
  ) {
    if (locationProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    String? initialStationValue =
        locationProvider.stations.any(
              (station) =>
                  station.Station_ID == locationProvider.selectedStation,
            )
            ? locationProvider.selectedStation
            : null;

    return FormBuilderDropdown<String>(
      name: key,
      initialValue: initialStationValue,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items: [
        ...locationProvider.stations.map(
          (station) => DropdownMenuItem<String>(
            value: station.Station_ID,
            child: Text(station.StationName),
          ),
        ),
        DropdownMenuItem<String>(value: 'Other', child: Text('Other')),
      ],
      validator:
          (value) =>
              value == null || value.isEmpty ? 'Please select $label' : null,
      onChanged: (value) {
        if (value == 'Other') {
          _showAddNewValueDialog(context, key, label, locationProvider);
        } else {
          // Get the station name based on selected Station_ID
          String? selectedStationName =
              locationProvider.stations
                  .firstWhere(
                    (station) => station.Station_ID == value,
                    // orElse: () => null, // Handle if station is not found
                  )
                  ?.StationName;

          setState(() {
            // Store the station name in the formData
            _formData[key] = selectedStationName;
            locationProvider.selectedStation = value;
          });
        }
      },
    );
  }

  void _showAddNewValueDialog(
    BuildContext context,
    String key,
    String label,
   // LocationProvider 
    locationProvider,
  ) {
    TextEditingController _newValueController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green[50],
          title: Text('Add New $label'),
          content: TextField(
            controller: _newValueController,
            decoration: InputDecoration(hintText: 'Enter new $label'),
            style: TextStyle(color: Colors.green[800]),
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.green[700])),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add', style: TextStyle(color: Colors.green[700])),
              onPressed: () {
                if (_newValueController.text.isNotEmpty) {
                  String newValue = _newValueController.text;

                  setState(() {
                    // Store the new value in the map using the key
                    newValues[key] = newValue;
                  });

                  switch (key) {
                    case 'Region':
                      locationProvider.addCustomRegion(
                        newValue!,
                      ); // Add custom Region to list
                      locationProvider.selectedRegion =
                          newValue; // Set as selected value
                      break;
                    case 'RTOM':
                      locationProvider.addCustomRtom(
                        newValue,
                      ); // Add custom RTOM to list
                      locationProvider.selectedRtom =
                          newValue; // Set as selected value
                      break;
                    case 'Station':
                      locationProvider.addCustomStation(
                        newValue,
                      ); // Add custom station to list
                      locationProvider.selectedStation =
                          newValue; // Set as selected value
                      break;
                  }

                  setState(() {
                    _formData[key] = newValue;
                  });

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  //===================================================================================================================

  Widget _StatusDropdown(String key, String label) {
    return FormBuilderDropdown(
      name: key,
      initialValue: _formData[key],
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items:
          ['StandBy', 'Running', 'Stopped', 'Waiting to dispose']
              .map(
                (status) =>
                    DropdownMenuItem(value: status, child: Text(status)),
              )
              .toList(),
      validator: (value) {
        if (value == null || value.toString().isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _formData[key] = value;
        });
      },
    );
  }

  Widget _PowerSupplyDropdown(String key, String label) {
    return FormBuilderDropdown(
      name: key,
      initialValue: _formData[key],
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items:
          ['1', '3']
              .map(
                (status) =>
                    DropdownMenuItem(value: status, child: Text(status)),
              )
              .toList(),
      validator: (value) {
        if (value == null || value.toString().isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _formData[key] = value;
        });
      },
    );
  }

  List<String> Refrigerants = ['R-134a', 'R-407C', 'R-410A', 'Other'];

  Widget _RefrigDropdown(String key, String label) {
    return FormBuilderDropdown(
      name: key,
      initialValue: _formData[key],
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items:
          Refrigerants.map(
            (refrigerants) => DropdownMenuItem(
              value: refrigerants,
              child: Text(refrigerants),
            ),
          ).toList(),
      validator: (value) {
        if (value == null || value.toString().isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _formData[key] = value;
        });

        if (value == 'Other') {
          _showCustomModelDialog(key);
        }
      },
    );
  }

  void _showCustomModelDialog(String key) {
    TextEditingController customModelController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: Colors.green),
          ),
          child: AlertDialog(
            title: Text("Add Custom refrigerants"),
            content: TextField(
              controller: customModelController,
              decoration: InputDecoration(hintText: "Enter refrigerant name"),
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
                  String customModel = customModelController.text.trim();
                  if (customModel.isNotEmpty) {
                    setState(() {
                      Refrigerants.insert(Refrigerants.length - 1, customModel);
                      _formData[key] = customModel;
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

  //refrig dropdown

  Widget _ConditionAirFilterDropdown(String key, String label) {
    return FormBuilderDropdown(
      name: key,
      initialValue: _formData[key],
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items:
          ['Good', 'Fair', 'Poor', 'Not Available']
              .map(
                (status) =>
                    DropdownMenuItem(value: status, child: Text(status)),
              )
              .toList(),
      validator: (value) {
        if (value == null || value.toString().isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _formData[key] = value;
        });
      },
    );
  }

  Widget _ConditionIndoorDropdown(String key, String label) {
    return FormBuilderDropdown(
      name: key,
      initialValue: _formData[key],
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items:
          ['Good', 'Faulty', 'Standby', 'Stopped', 'Waiting to dispose']
              .map(
                (status) =>
                    DropdownMenuItem(value: status, child: Text(status)),
              )
              .toList(),
      validator: (value) {
        if (value == null || value.toString().isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _formData[key] = value;
        });
      },
    );
  }

  Widget _CondensorMountedDropdown(String key, String label) {
    return FormBuilderDropdown(
      name: key,
      initialValue: _formData[key],
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items:
          ['Vertical', 'Horizontal']
              .map(
                (status) =>
                    DropdownMenuItem(value: status, child: Text(status)),
              )
              .toList(),
      validator: (value) {
        if (value == null || value.toString().isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _formData[key] = value;
        });
      },
    );
  }
}
