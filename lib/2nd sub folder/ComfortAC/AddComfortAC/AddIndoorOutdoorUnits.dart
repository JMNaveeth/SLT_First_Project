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


import '../../../../../Widgets/GPSGrab/gps_location_widget.dart';
import '../../../../../Widgets/LoadLocations/httpGetLocations.dart';
import '../../../../UserAccess.dart';
import 'httpPostAc.dart';



class ACFormPage extends StatefulWidget {
  final Map<String, dynamic>? initialData;


  const ACFormPage({super.key, this.initialData});

  @override
  _ACFormPageState createState() => _ACFormPageState();
}

class _ACFormPageState extends State<ACFormPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  Map<String, bool> _isOtherSelected = {};
  Map<String, String> newValues = {};
  //user variable

  String userName = 'testUser';

  // final Map<String, String> _customValues = {}; // Track custom values


  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _formData.addAll(widget.initialData!);
      _isOtherSelected['brand'] = false;
    }
  }




  final GPSLocationFetcher _locationFetcher = GPSLocationFetcher();



  TextEditingController _latitudeController1 = TextEditingController();
  TextEditingController _longitudeController1 = TextEditingController();


  void _fetchLocation() async {
    try {
      final location = await _locationFetcher.fetchLocation();
      setState(() {
        _latitudeController1.text = location['latitude']!;
        _longitudeController1.text = location['longitude']!;
      });

      // Update _formData with fetched location
      _formData['Latitude'] = _latitudeController1.text;
      _formData['Longitude'] = _longitudeController1.text;
    } catch (e) {
      // Show CupertinoAlertDialog with warning animation
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Row(
              children: [
                Icon(CupertinoIcons.exclamationmark_triangle, color: Color(
                    0xFFFC4C16)),
                SizedBox(width: 10),
                Text('Error'),
              ],
            ),
            content: Text('Location Service is Disabled. Please Enable them to use auto-location'),
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
    UserAccess userAccess = Provider.of<UserAccess>(context, listen: true); // Use listen: true to rebuild the widget when the data changes
    userName=userAccess.username!;

    return ChangeNotifierProvider(
      create: (context) => LocationProvider()..loadAllData(),
      child: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          var _isVerified;
          return Scaffold(
            appBar: AppBar(
              title: Text('Add new AC Unit', style: TextStyle(color: Colors.white)),
              backgroundColor: Color(0xFF0056A2),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Indoor Units Form Fields
                      Text('AC Indoor Unit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Text('Location Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      _RegionDropdownComfort('region', 'region', locationProvider, _formData, context),
                      _RtomDropdownComfort('rtom', 'rtom', locationProvider, _formData, context),
                      _StationDropdownComfort('station', 'station', locationProvider, _formData, context),
                      _buildTextField('rtom_building_id', 'RTOM Building ID (eg:Building A)'),
                      _buildTextField('indoor_floor_number', 'Floor Number (eg:OTS-1-AC-No)'),
                      _buildTextFieldModelValidated('indoor_office_number', 'Office Number (eg: 01)'),
                      _buildTextFieldLocationValidated('indoor_location', 'Location (eg:OTS UPS room)'),
                      SizedBox(height: 40),
                      // GPS Location fields
                      Text('Mark GPS Location of the Unit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      _buildGPSLatitudeField('Latitude', 'Latitude (Enter Manually or press Get Location)', _latitudeController1),
                      _buildGPSLongitudeField('Longitude', 'Longitude (Enter manually or press Get Location)', _longitudeController1),
                      SizedBox(height: 20),
                      CupertinoButton(
                        onPressed: _fetchLocation,
                        color: Color(0xFF00AEE4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_on, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Get Location'),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Asset Details for Indoor Unit
                      Text('Asset Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      _buildTextField('QR_In', 'Indoor Tag Code(eg:AI:0001)'),
                      _BrandDropdown('indoor_brand', 'Brand'),
                      _buildTextFieldModelValidated('indoor_model', 'Model'),
                      _CustomCapacityDropdown('indoor_capacity', 'Capacity'),
                      _buildNumValTextField('serial_number', 'Serial code'),
                      _InstallationCategoryDropdown('installation_type', 'Installation Type'),
                      _RefrigDropdown('refrigerant_type', 'Refrigerant Type'),
                      _PowerSupplyDropdown('indoor_power_supply', 'Power Supply'),
                      _ConditionDropdown('condition_ID_unit', 'Condition ID Unit'),
                      _RemoteDropdown('remote_available', 'Remote Available'),
                      _buildNotesTextField('indoor_notes', 'Notes'),
                      SizedBox(height: 40),
                      // Supplier and Warranty Details for Indoor Unit
                      Text('Supplier and Warranty Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      _buildCustomDateField('installation_date', 'Installation Date (YYYY-MM-DD)'),
                      _buildDatePicker('indoor_warranty_expiry_date', 'Warranty Expiry Date (YYYY-MM-DD)'),
                      _buildTextFieldNonValidated('indoor_supplier_name', 'Supplier Name'),
                      _buildPoNumberTextField('indoor_po_number', 'PO Number'),
                      SizedBox(height: 40),
                      // AC Outdoor Unit Form Fields
                      Text('AC Outdoor Unit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Asset Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      _buildTextField('QR_Out', 'Outdoor Tag Code(eg:AO:0001)'),
                      _BrandDropdown('brand', 'Brand'),
                      _buildTextFieldModelValidated('model', 'Model'),
                      _CustomCapacityDropdown('capacity', 'Capacity'),
                      _buildTextFieldNonValidated('outdoor_fan_model', 'Outdoor Fan Model'),
                      _PowerSupplyDropdown('outdoor_power_supply', 'Power Supply'),
                      _CompressormountedDropdown('compressor_mounted_with', 'Compressor Mounted With'),
                      _CustomCapacityDropdown('compressor_capacity', 'Compressor Capacity'),
                      _BrandDropdown('compressor_brand', 'Compressor Brand'),
                      _buildTextFieldModelValidated('compressor_model', 'Compressor Model'),
                      _buildNumValTextField('compressor_serial_number', 'Compressor Serial Number'),
                      _ConditionDropdown('condition_OD_unit', 'Condition OD Unit'),
                      _buildNotesTextField('outdoor_notes', 'Notes'),
                      _CategoryDropdown('category', 'Category'),
                      _buildCustomDateField('Installation_Date', 'Outdoor Installation Date (YYYY-MM-DD)'),
                      SizedBox(height: 20),
                      // Supplier and Warranty Details for Outdoor Unit
                      Text('Supplier and Warranty Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      _buildDatePicker('outdoor_warranty_expiry_date', 'Warranty Expiry Date (YYYY-MM-DD)'),
                      _buildDatePicker('DoM', 'Date Of Manufactured'),
                      _buildTextFieldNonValidated('outdoor_supplier_name', 'Supplier Name'),
                      _buildPoNumberTextField('outdoor_po_number', 'PO Number'),
                      SizedBox(height: 20),
                      // Verification Checkbox
                      FormBuilderCheckbox(
                        name: 'verify',
                        initialValue: _isVerified,
                        title: Text('I verify that submitted details are true and correct'),
                        onChanged: (value) {
                          setState(() {
                            _isVerified = value;
                          });
                        },
                        checkColor: Colors.white,
                        activeColor: Color(0xFF0056A2),
                        validator: (value) {
                          if (value != true) {
                            return 'You must verify the details to proceed.';
                          }
                          return null;
                        },
                      ),
                      // Submit and Reset Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CupertinoButton(
                              onPressed: _resetForm,
                              child: const Text('Reset'),
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                              color: const Color(0xFF00AEE4),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CupertinoButton(
                              onPressed: _submitData,
                              child: const Text('Submit'),
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                              color: const Color(0xFF0056A2),
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



  //================================formBuilderTextfields With Validations====================================================================================================

  Widget _buildTextField(String key, String label) {
    return FormBuilderTextField(
      name: key,
      initialValue: _formData[key]?.toString() ?? '',
      decoration: InputDecoration(

        labelText: label,
        errorStyle: TextStyle(color: Colors.red), // Optional: Customize error text style
      ),



      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Please enter $label'),
        FormBuilderValidators.match(
            RegExp(r'^[-a-z A-Z 0-9 _:]+$'),
            errorText: '$label must contain only letters and numbers'),
        // FormBuilderValidators.minLength(1, errorText: 'Minimum 5 characters.'),
        FormBuilderValidators.maxLength(
            25, errorText: 'Maximum 25 characters.'),

      ]),

      autovalidateMode: AutovalidateMode.onUserInteraction,//validation on input

      onChanged: (value) {
        _formData[key] = value ?? '';
      },
    );
  }


  Widget _buildNotesTextField(String key, String label) {
    return FormBuilderTextField(
      name: key,
      initialValue: _formData[key]?.toString() ?? '',
      decoration: InputDecoration(

        labelText: label,
        errorStyle: TextStyle(color: Colors.red), // Optional: Customize error text style
      ),



      // validator: FormBuilderValidators.compose([
      //
      //   FormBuilderValidators.match(
      //       RegExp(r'^[a-z A-Z 0-9 _: .,/#-@+=]+$'),
      //       errorText: '$label must contain only letters and numbers'),
      //   // FormBuilderValidators.minLength(1, errorText: 'Minimum 5 characters.'),
      //   FormBuilderValidators.maxLength(
      //       200, errorText: 'Maximum 200 characters.'),
      //
      // ]),

      // autovalidateMode: AutovalidateMode.onUserInteraction,//validation on input

      onChanged: (value) {
        _formData[key] = value ?? '';
      },
    );
  }


  Widget _CompressormountedDropdown(String key, String label) {
    return FormBuilderDropdown(
      name: key,
      initialValue: _formData[key],
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items: ['Indoor','Outdoor',]
          .map((status) => DropdownMenuItem(value: status, child: Text(status)))
          .toList(),
      validator: (value) {
        if (value == null || value
            .toString()
            .isEmpty) {
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



  Widget _buildTextFieldLocationValidated(String key, String label) {
    return FormBuilderTextField(
      name: key,
      initialValue: _formData[key]?.toString() ?? '',
      decoration: InputDecoration(
        labelText: label,
        errorStyle: TextStyle(color: Colors.red), // Optional: Customize error text style
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Please enter $label'),
        FormBuilderValidators.match(
            RegExp(r'^[a-zA-Z0-9&_: /#-.@]+$'),
            errorText: '$label must contain letters, numbers, and allowed symbols (&, _, :).'),
        FormBuilderValidators.maxLength(50, errorText: 'Maximum 50 characters allowed.'),
      ]),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        _formData[key] = value ?? '';
      },
    );
  }



  Widget _buildGPSLatitudeField(String name, String label, TextEditingController controller) {
    return FormBuilderTextField(
      name: name,

      controller: controller,
      decoration: InputDecoration(labelText: label),
      readOnly: false,

      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Please enter $label'),
      ]),

    );
  }


  Widget _buildGPSLongitudeField(String key, String label, TextEditingController controller) {
    return FormBuilderTextField(
      name: key,


      controller: controller,
      decoration: InputDecoration(labelText: label),
      readOnly: false,

      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Please enter $label'),
      ]),

    );
  }


  Widget _buildTextFieldNonValidated(String key, String label) {
    return FormBuilderTextField(
      name: key,
      initialValue: _formData[key]?.toString() ?? '',
      decoration: InputDecoration(
        labelText: label,
        errorStyle: TextStyle(color: Colors.red), // Optional: Customize error text style
      ),

      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        setState(() {
          _formData[key] = value ?? '';
        });
      },

      validator: FormBuilderValidators.compose([
        // Max length of 25 characters
        FormBuilderValidators.maxLength(25, errorText: 'Max length is 25 characters'),
        // Allow only English capital letters and colons
        FormBuilderValidators.match(
          RegExp(r'^[A-Za-z:0-9 :/#-@]*$'),
          errorText: 'Only English capital letters and Numbers are allowed',
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
        errorStyle: TextStyle(color: Colors.red), // Optional: Customize error text style

      ),
      validator: FormBuilderValidators.compose([
        // FormBuilderValidators.required(errorText: 'Please enter $label'),
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
            RegExp(r'^[a-zA-Z0-9&_: /# -.@]+$'),
            errorText: '$label must contain only numbers and letters'),
      ]),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        _formData[key] = value ?? '';
      },
    );
  }




  Widget _buildPoNumberTextField(String key, String label) {
    return FormBuilderTextField(
      keyboardType: TextInputType.text,
      name: key,
      initialValue: _formData[key]?.toString() ?? '',
      decoration: InputDecoration(
        labelText: label,
        errorStyle: TextStyle(color: Colors.red), // Optional: Customize error text style

      ),

      onChanged: (value) {
        _formData[key] = value ?? '';
      },
    );
  }


  Widget _buildDatePicker(String key, String label) {
    return FormBuilderDateTimePicker(
      name: key,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      inputType: InputType.date,
      decoration: InputDecoration(
        labelText: label,
      ),
      onChanged: (value) {
        setState(() {
          _formData[key] = value?.toString().split(' ')[0];
        });
      },
    );
  }



  Widget _buildCustomDateField(String fieldName, String labelText) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(text: _formData[fieldName] ?? ''),
      decoration: InputDecoration(
        labelText: labelText,
      ),
      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return 'Please select a date';
      //   }
      //   return null;
      // },
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
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    return picked != null ? DateTime(picked.year, picked.month, picked.day) : null;
  }

  //installation date picker

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
        FormBuilderValidators.maxLength(50, errorText: 'Max length is 50 characters'),
        // Allow only English capital letters and colons
        FormBuilderValidators.match(
          RegExp(r'^[ -_A-Za-z0-9:]*$'),
          errorText: 'Only English capital letters and colons are allowed',
        ),
      ]),
    );
  }




  //dropdowns
  //===========================================================================================================================

  Widget _RegionDropdownComfort(String key, String label, LocationProvider locationProvider, Map<String, dynamic> _formData, BuildContext context) {
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
        ...locationProvider.regions.map((region) => DropdownMenuItem<String>(
          value: region.Region_ID,
          child: Text(region.RegionName),
        )),
        DropdownMenuItem<String>(
          value: 'Other',
          child: Text('Other'),
        ),
      ],
      validator: (value) => value == null || value.isEmpty ? 'Please select $label' : null,
      onChanged: (value) {
        if (value == 'Other') {
          _showAddNewValueDialogComfort(context, key, label, locationProvider);
        } else {
          // Get the region name based on selected Region_ID
          String? selectedRegionName = locationProvider.regions.firstWhere(
                (region) => region.Region_ID == value,
            // orElse: () => null, // In case the region is not found
          )?.RegionName;



          setState(() {
            // Store the region name in the formData
            _formData[key] = selectedRegionName;
            locationProvider.selectedRegion = value;
          });


        }
      },
    );
  }



  Widget _RtomDropdownComfort(String key, String label, LocationProvider locationProvider, Map<String, dynamic> _formData, BuildContext context) {
    if (locationProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    String? initialRtomValue = locationProvider.rtoms
        .any((rtom) => rtom.RTOM_ID == locationProvider.selectedRtom)
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
        ...locationProvider.rtoms.map((rtom) => DropdownMenuItem<String>(
          value: rtom.RTOM_ID,
          child: Text(rtom.RTOM),
        )),
        DropdownMenuItem<String>(
          value: 'Other',
          child: Text('Other'),
        ),
      ],
      validator: (value) => value == null || value.isEmpty ? 'Please select $label' : null,
      onChanged: (value) {
        if (value == 'Other') {
          _showAddNewValueDialogComfort(context, key, label, locationProvider);
        } else {
          // Get the RTOM name based on selected RTOM_ID
          String? selectedRtomName = locationProvider.rtoms.firstWhere(
                (rtom) => rtom.RTOM_ID == value,
            // orElse: () => null, // Handle if RTOM is not found
          ).RTOM;

          setState(() {
            // Store the RTOM name in the formData
            _formData[key] = selectedRtomName;
            locationProvider.selectedRtom = value;
          });
        }
      },
    );
  }

  Widget _StationDropdownComfort(String key, String label, LocationProvider locationProvider, Map<String, dynamic> _formData, BuildContext context) {
    if (locationProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    String? initialStationValue = locationProvider.stations
        .any((station) => station.Station_ID == locationProvider.selectedStation)
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
        ...locationProvider.stations.map((station) => DropdownMenuItem<String>(
          value: station.Station_ID,
          child: Text(station.StationName),
        )),
        DropdownMenuItem<String>(
          value: 'Other',
          child: Text('Other'),
        ),
      ],
      validator: (value) => value == null || value.isEmpty ? 'Please select $label' : null,
      onChanged: (value) {
        if (value == 'Other') {
          _showAddNewValueDialogComfort(context, key, label, locationProvider);
        } else {
          // Get the station name based on selected Station_ID
          String? selectedStationName = locationProvider.stations.firstWhere(
                (station) => station.Station_ID == value,
            // orElse: () => null, // Handle if station is not found
          ).StationName;

          setState(() {
            // Store the station name in the formData
            _formData[key] = selectedStationName;
            locationProvider.selectedStation = value;
          });

        }
      },
    );
  }


  //===========reusable dialogbox

  void _showAddNewValueDialogComfort(BuildContext context, String key, String label, LocationProvider locationProvider) {
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
                    case 'region':
                      locationProvider.addCustomRegion(newValue); // Add custom Region to list
                      locationProvider.selectedRegion = newValue; // Set as selected value
                      break;
                    case 'rtom':
                      locationProvider.addCustomRtom(newValue); // Add custom RTOM to list
                      locationProvider.selectedRtom = newValue; // Set as selected value
                      break;
                    case 'station':
                      locationProvider.addCustomStation(newValue); // Add custom station to list
                      locationProvider.selectedStation = newValue; // Set as selected value
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

  //===========reusable dialogbox




  List<String> brands = [
    'Mitsubishi', 'Abans', 'LG', 'Panasonic', 'York', 'Hitachi', 'Other'
  ];


  //brand dropdown

  Widget _BrandDropdown(String key, String label) {
    return FormBuilderDropdown(
      name: key,
      initialValue: _formData[key],
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),

      items: brands.map((brand) => DropdownMenuItem(
          value: brand,
          child: Text(brand)
      )).toList(),
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
          _showCustomBrandDialog(key);
        }
      },
    );
  }

  void _showCustomBrandDialog(String key) {
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
              decoration: InputDecoration(
                hintText: "Enter your brand name",
              ),
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
                      brands.insert(brands.length - 1, customBrand);
                      _formData[key] = customBrand;
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

//brand dropdown



  //capacity dropdown dropdown

  List<String> Capacity = [
    '0.75'+'TR', '1.00'+'TR', '1.50'+'TR', '2.00'+'TR', '2.50'+'TR', '3.00'+'TR', 'Other'
  ];


  Widget _CustomCapacityDropdown(String key, String label) {
    return FormBuilderDropdown(
      name: key,
      initialValue: _formData[key],
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items: Capacity.map((Capacity) => DropdownMenuItem(
          value: Capacity,
          child: Text(Capacity)
      )).toList(),
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
          _showCustomCapacityDialog(key);
        }
      },
    );
  }

  void _showCustomCapacityDialog(String key) {
    TextEditingController customCapacityController = TextEditingController();

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
              controller: customCapacityController,
              decoration: InputDecoration(
                hintText: "Enter Capacity(4.00TR)",
              ),
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
                  String customCapacity = customCapacityController.text.trim();
                  if (customCapacity.isNotEmpty) {
                    setState(() {
                      Capacity.insert(Capacity.length - 1, customCapacity);
                      _formData[key] = customCapacity;
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




  Widget _InstallationCategoryDropdown(String key, String label) {
    return FormBuilderDropdown(
      name: key,
      initialValue: _formData[key],
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items: ['Wall Mount', 'Floor Stand', 'Ceiling Mount', 'Ceiling Cassette',]
          .map((status) => DropdownMenuItem(value: status, child: Text(status)))
          .toList(),
      validator: (value) {
        if (value == null || value
            .toString()
            .isEmpty) {
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
      items: ['R410','R410A', 'R22', 'R32','R407C']
          .map((status) => DropdownMenuItem(value: status, child: Text(status)))
          .toList(),
      validator: (value) {
        if (value == null || value
            .toString()
            .isEmpty) {
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
      items: ['1','3',]
          .map((status) => DropdownMenuItem(value: status, child: Text(status)))
          .toList(),
      validator: (value) {
        if (value == null || value
            .toString()
            .isEmpty) {
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


  Widget _ConditionDropdown(String key, String label) {
    return FormBuilderDropdown(
      name: key,
      initialValue: _formData[key],
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items: ['Good', 'Faulty', 'Standby', 'Stopped', 'Waiting to dispose']
          .map((status) => DropdownMenuItem(value: status, child: Text(status)))
          .toList(),
      validator: (value) {
        if (value == null || value
            .toString()
            .isEmpty) {
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


  Widget _RemoteDropdown(String key, String label) {
    return FormBuilderDropdown(
      name: key,
      initialValue: _formData[key],
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items: ['Yes', 'No']
          .map((status) => DropdownMenuItem(value: status, child: Text(status)))
          .toList(),
      validator: (value) {
        if (value == null || value
            .toString()
            .isEmpty) {
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


  Widget _CategoryDropdown(String key, String label) {
    return FormBuilderDropdown(
      name: key,
      initialValue: _formData[key],
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items: ['Inverter', 'Non Inverter']
          .map((status) => DropdownMenuItem(value: status, child: Text(status)))
          .toList(),
      validator: (value) {
        if (value == null || value
            .toString()
            .isEmpty) {
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

  void _resetForm() {
    setState(() {
      _formKey.currentState?.reset(); // Reset the form fields
      _formData.clear(); // Clear the form data
      _isOtherSelected.clear(); // Reset any additional state variables
    });
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      print("Form Data: $_formData");  // Debug print for form data

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  HttpPostAcUnits(formDataList: _formData, User:userName),
        ),
      );
    }
  }
}



//v2
// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../../../Widgets/GPSGrab/gps_location_widget.dart';
// import 'httpPostAc.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:intl/intl.dart';
//
//
// class ACFormPage extends StatefulWidget {
//   final Map<String, dynamic>? initialData;
//
//
//   ACFormPage({this.initialData});
//
//   @override
//   _ACFormPageState createState() => _ACFormPageState();
// }
//
// class _ACFormPageState extends State<ACFormPage> {
//   final _formKey = GlobalKey<FormState>();
//   final Map<String, dynamic> _formData = {};
//   Map<String, bool> _isOtherSelected = {};
//
//   //user variable
//
//   String user = 'testUser';
//
//   // final Map<String, String> _customValues = {}; // Track custom values
//
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.initialData != null) {
//       _formData.addAll(widget.initialData!);
//       _isOtherSelected['brand'] = false;
//     }
//   }
//
//
//
//
//   final GPSLocationFetcher _locationFetcher = GPSLocationFetcher();
//
//
//   TextEditingController _latitudeController1 = TextEditingController();
//   TextEditingController _longitudeController1 = TextEditingController();
//
//
//   void _fetchLocation() async {
//     try {
//       final location = await _locationFetcher.fetchLocation();
//       setState(() {
//         _latitudeController1.text = location['latitude']!;
//         _longitudeController1.text = location['longitude']!;
//       });
//
//       // Update _formData with fetched location
//       _formData['Latitude'] = _latitudeController1.text;
//       _formData['Longitude'] = _longitudeController1.text;
//     } catch (e) {
//       // Show CupertinoAlertDialog with warning animation
//       showCupertinoDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return CupertinoAlertDialog(
//             title: Row(
//               children: [
//                 Icon(CupertinoIcons.exclamationmark_triangle, color: Color(
//                     0xFFFC4C16)),
//                 SizedBox(width: 10),
//                 Text('Error'),
//               ],
//             ),
//             content: Text('Location Service is Disabled. Please Enable them to use auto-location'),
//             actions: <Widget>[
//               CupertinoDialogAction(
//                 child: Text('OK'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     bool? _isVerified;
//     return Scaffold(
//
//       appBar: AppBar(
//         title: Text('Add new Ac Unit',style: TextStyle(color:Colors.white)),
//         backgroundColor: Color(0xFF0056A2),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // Indoor Units Form Fields
//                 Text('AC Indoor Unit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//
//                 SizedBox(height: 20),
//                 Text('Location Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 _RegionDropdown('region', 'Region'),
//                 _buildTextField('rtom', 'RTOM (eg:Central Rec Room)'),
//                 _buildTextField('station', 'Station (eg: R:OTS_1)'),
//                 _buildTextField('rtom_building_id', 'RTOM Building ID (eg:Building A)'),
//                 _buildTextField('indoor_floor_number', 'Floor Number (eg:OTS-1-AC-No)'),
//                 _buildTextFieldModelValidated('indoor_office_number', 'Office Number (eg: 01)'),
//                 _buildTextFieldLocationValidated('indoor_location', 'Location (eg:OTS UPS room)'),
//                 // _buildNoAcPlantsTextField('no_AC_plants', 'No Of AC Plants'),
//
//                 SizedBox(height: 40),
//                 // GPS Location fields
//                 Text('Mark GPS Location of the Unit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 _buildGPSLatitudeField('Latitude','Latitude (Enter Manually or press Get Location)',_latitudeController1),
//                 _buildGPSLongitudeField('Longitude','Longitude (Enter manually or press Get Location)',_longitudeController1),
//
//                 SizedBox(height: 20),
//                 // Fetch Location Button
//                 CupertinoButton(
//                   onPressed: _fetchLocation,
//                   color: Color(0xFF00AEE4),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min, // Keeps the button size compact
//                     children: [
//                       Icon(
//                         Icons.location_on, // choose any icon you prefer
//                         color: Colors.white, // Adjust the color of the icon
//                       ),
//                       SizedBox(width: 8), // space between the icon and text
//                       Text('Get Location'),
//                     ],
//                   ),
//                 ),
//
//                 SizedBox(height: 20),
//
//                 SizedBox(height: 20),
//                 Text('Asset Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 _buildTextField('QR_In', 'Indoor Tag Code(eg:AI:0001)'),
//                 _BrandDropdown('indoor_brand', 'Brand'),
//                 _buildTextFieldModelValidated('indoor_model', 'Model'),
//                 _CustomCapacityDropdown('indoor_capacity', 'Capacity'),
//                 _buildNumValTextField('serial_number', 'Serial Number'),
//                 _InstallationCategoryDropdown('installation_type', 'Installation Type'),
//                 _RefrigDropdown('refrigerant_type', 'Refrigerant Type'),
//                 _PowerSupplyDropdown('indoor_power_supply', 'Power Supply'),
//                 _ConditionDropdown('condition_ID_unit', 'Condition ID Unit'),
//                 _RemoteDropdown('remote_available', 'Remote Available'),
//                 _buildNotesTextField('indoor_notes', 'Notes'),
//                 // _StatusDropdown('indoor_status', 'Status'),
//
//
//                 SizedBox(height: 20),
//                 Text('Supplier and Warranty Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 _buildCustomDateField('installation_date', 'Installation Date (YYYY-MM-DD)'),
//                 _buildDatePicker('indoor_warranty_expiry_date', 'Warranty Expiry Date (YYYY-MM-DD)'),
//                 _buildTextFieldNonValidated('indoor_supplier_name', 'Supplier Name'),
//                 _buildPoNumberTextField('indoor_po_number', 'PO Number'),
//
//                 SizedBox(height: 40),
//
//                 Text('AC Outdoor Unit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//
//                 // SizedBox(height: 20),
//                 // Text('Location Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 // Add any location-specific fields for outdoor units if necessary
//
//                 SizedBox(height: 20),
//                 Text('Asset Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 _buildTextField('QR_Out', 'Outdoor Tag Code(eg:AO:0001)'),
//                 _BrandDropdown('brand', 'Brand'),
//                 _buildTextFieldModelValidated('model', 'Model'),
//                 _CustomCapacityDropdown('capacity', 'Capacity'),
//                 _buildTextFieldNonValidated('outdoor_fan_model', 'Outdoor Fan Model'),
//                 _PowerSupplyDropdown('outdoor_power_supply', 'Power Supply'),
//                 _CompressormountedDropdown('compressor_mounted_with', 'Compressor Mounted With'),
//                 _CustomCapacityDropdown('compressor_capacity', 'Compressor Capacity'),
//                 _BrandDropdown('compressor_brand', 'Compressor Brand'),
//                 _buildTextFieldModelValidated('compressor_model', 'Compressor Model'),
//                 _buildNumValTextField('compressor_serial_number', 'Compressor Serial Number'),
//                 _ConditionDropdown('condition_OD_unit', 'Condition OD Unit'),
//                 _buildNotesTextField('outdoor_notes', 'Notes'),
//                 // _StatusDropdown('outdoor_status', 'Status'),
//                 _CategoryDropdown('category', 'Category'),
//                 _buildCustomDateField('Installation_Date', 'Outdoor Installation Date (YYYY-MM-DD)'),
//
//
//                 SizedBox(height: 20),
//                 Text('Supplier and Warranty Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//
//                 _buildDatePicker('outdoor_warranty_expiry_date', 'Warranty Expiry Date (YYYY-MM-DD)'),
//
//                 _buildDatePicker('DoM', 'Date Of Manufactured'),
//                 _buildTextFieldNonValidated('outdoor_supplier_name', 'Supplier Name'),
//                 _buildPoNumberTextField('outdoor_po_number', 'PO Number'),
//
//                 SizedBox(height: 20),
//
//
//
//                 FormBuilderCheckbox(
//                   name: 'verify',
//                   initialValue: _isVerified,
//                   title: Text('I verify that submitted details are true and correct'),
//                   onChanged: (value) {
//                     setState(() {
//                       _isVerified = value;
//                     });
//                   },
//
//                   checkColor: Colors.white,
//                   activeColor: Color(0xFF0056A2),
//
//                   validator: (value) {
//                     if (value != true) {
//                       return 'You must verify the details to proceed.';
//                     }
//                     return null;
//                   },
//                 ),
//
//
//
//                 // Submit Button
//                 // Buttons Row
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: CupertinoButton(
//                         onPressed: _resetForm,
//                         child: const Text('Reset'),
//                         padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
//                         color: const Color(0xFF00AEE4),
//                       ),
//                     ),
//                     const SizedBox(width: 10), // Add spacing between buttons
//                     Expanded(
//                       child: CupertinoButton(
//                         onPressed: _submitData,
//                         child: const Text('Submit'),
//                         padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
//                         color: const Color(0xFF0056A2),
//                       ),
//                     ),
//                   ],
//                 )
//
//
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//
//
//
//
//   //================================formBuilderTextfields With Validations====================================================================================================
//
//   Widget _buildTextField(String key, String label) {
//     return FormBuilderTextField(
//       name: key,
//       initialValue: _formData[key]?.toString() ?? '',
//       decoration: InputDecoration(
//
//         labelText: label,
//         errorStyle: TextStyle(color: Colors.red), // Optional: Customize error text style
//       ),
//
//
//
//       validator: FormBuilderValidators.compose([
//         FormBuilderValidators.required(errorText: 'Please enter $label'),
//         FormBuilderValidators.match(
//             RegExp(r'^[a-zA-Z0-9&_: ]+$'),
//             errorText: '$label must contain only letters and numbers'),
//         // FormBuilderValidators.minLength(1, errorText: 'Minimum 5 characters.'),
//         FormBuilderValidators.maxLength(
//             25, errorText: 'Maximum 25 characters.'),
//
//       ]),
//
//       autovalidateMode: AutovalidateMode.onUserInteraction,//validation on input
//
//       onChanged: (value) {
//         _formData[key] = value ?? '';
//       },
//     );
//   }
//
//
//   Widget _buildNotesTextField(String key, String label) {
//     return FormBuilderTextField(
//       name: key,
//       initialValue: _formData[key]?.toString() ?? '',
//       decoration: InputDecoration(
//
//         labelText: label,
//         errorStyle: TextStyle(color: Colors.red), // Optional: Customize error text style
//       ),
//
//
//
//       validator: FormBuilderValidators.compose([
//
//         FormBuilderValidators.match(
//             RegExp(r'^[a-zA-Z0-9&_: ]+$'),
//             errorText: '$label must contain only letters and numbers'),
//         // FormBuilderValidators.minLength(1, errorText: 'Minimum 5 characters.'),
//         FormBuilderValidators.maxLength(
//             200, errorText: 'Maximum 200 characters.'),
//
//       ]),
//
//       autovalidateMode: AutovalidateMode.onUserInteraction,//validation on input
//
//       onChanged: (value) {
//         _formData[key] = value ?? '';
//       },
//     );
//   }
//
//
//   Widget _CompressormountedDropdown(String key, String label) {
//     return FormBuilderDropdown(
//       name: key,
//       initialValue: _formData[key],
//       decoration: InputDecoration(
//         labelText: label,
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//       items: ['Indoor','Outdoor',]
//           .map((status) => DropdownMenuItem(value: status, child: Text(status)))
//           .toList(),
//       validator: (value) {
//         if (value == null || value
//             .toString()
//             .isEmpty) {
//           return 'Please select $label';
//         }
//         return null;
//       },
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value;
//         });
//       },
//     );
//   }
//
//
//
//   Widget _buildTextFieldLocationValidated(String key, String label) {
//     return FormBuilderTextField(
//       name: key,
//       initialValue: _formData[key]?.toString() ?? '',
//       decoration: InputDecoration(
//         labelText: label,
//         errorStyle: TextStyle(color: Colors.red), // Optional: Customize error text style
//       ),
//       validator: FormBuilderValidators.compose([
//         FormBuilderValidators.required(errorText: 'Please enter $label'),
//         FormBuilderValidators.match(
//             RegExp(r'^[a-zA-Z0-9&_: ]+$'),
//             errorText: '$label must contain letters, numbers, and allowed symbols (&, _, :).'),
//         FormBuilderValidators.maxLength(20, errorText: 'Maximum 20 characters allowed.'),
//       ]),
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       onChanged: (value) {
//         _formData[key] = value ?? '';
//       },
//     );
//   }
//
//
//
//   Widget _buildGPSLatitudeField(String name, String label, TextEditingController controller) {
//     return FormBuilderTextField(
//       name: name,
//
//       controller: controller,
//       decoration: InputDecoration(labelText: label),
//       readOnly: false,
//
//       validator: FormBuilderValidators.compose([
//         FormBuilderValidators.required(errorText: 'Please enter $label'),
//       ]),
//
//     );
//   }
//
//
//   Widget _buildGPSLongitudeField(String key, String label, TextEditingController controller) {
//     return FormBuilderTextField(
//       name: key,
//
//
//       controller: controller,
//       decoration: InputDecoration(labelText: label),
//       readOnly: false,
//
//       validator: FormBuilderValidators.compose([
//         FormBuilderValidators.required(errorText: 'Please enter $label'),
//       ]),
//
//     );
//   }
//
//
//   Widget _buildTextFieldNonValidated(String key, String label) {
//     return FormBuilderTextField(
//       name: key,
//       initialValue: _formData[key]?.toString() ?? '',
//       decoration: InputDecoration(
//         labelText: label,
//         errorStyle: TextStyle(color: Colors.red), // Optional: Customize error text style
//       ),
//
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value ?? '';
//         });
//       },
//
//       validator: FormBuilderValidators.compose([
//         // Max length of 25 characters
//         FormBuilderValidators.maxLength(25, errorText: 'Max length is 25 characters'),
//         // Allow only English capital letters and colons
//         FormBuilderValidators.match(
//           RegExp(r'^[a-zA-Z0-9&_: ]+$'),
//           errorText: 'Only English capital letters and Numbers are allowed',
//         ),
//       ]),
//
//
//     );
//   }
//
//
//
//   Widget _buildNumValTextField(String key, String label) {
//     return FormBuilderTextField(
//       keyboardType: TextInputType.text,
//       name: key,
//       initialValue: _formData[key]?.toString() ?? '',
//       decoration: InputDecoration(
//         labelText: label,
//         errorStyle: TextStyle(color: Colors.red), // Optional: Customize error text style
//
//       ),
//       validator: FormBuilderValidators.compose([
//         FormBuilderValidators.required(errorText: 'Please enter $label'),
//         // FormBuilderValidators.numeric(errorText: '$label must be a number'),
//         // Custom validator to ensure the number is an integer
//         //     (value) {
//         //   final numValue = num.tryParse(value ?? '');
//         //   if (numValue == null) {
//         //     return '$label must be a number';
//         //   }
//         //   if (numValue % 1 != 0) {
//         //     return '$label must be an integer';
//         //   }
//         //   return null;
//         // },
//         // FormBuilderValidators.min(1, errorText: '$label must be at least 1'),
//         // FormBuilderValidators.maxLength(
//         //     10, errorText: '$label cannot be more than 10 characters'),
//         // FormBuilderValidators.match(
//         //     r'^[0-9]+$', errorText: '$label must contain only numbers'),
//       ]),
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       onChanged: (value) {
//         _formData[key] = value ?? '';
//       },
//     );
//   }
//
//
//   Widget _buildPoNumberTextField(String key, String label) {
//     return FormBuilderTextField(
//       keyboardType: TextInputType.text,
//       name: key,
//       initialValue: _formData[key]?.toString() ?? '',
//       decoration: InputDecoration(
//         labelText: label,
//         errorStyle: TextStyle(color: Colors.red), // Optional: Customize error text style
//
//       ),
//
//       onChanged: (value) {
//         _formData[key] = value ?? '';
//       },
//     );
//   }
//
//
//   Widget _buildDatePicker(String key, String label) {
//     return FormBuilderDateTimePicker(
//       name: key,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//       inputType: InputType.date,
//       decoration: InputDecoration(
//         labelText: label,
//       ),
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value?.toString().split(' ')[0];
//         });
//       },
//     );
//   }
//
//
//
//   Widget _buildCustomDateField(String fieldName, String labelText) {
//     return TextFormField(
//       readOnly: true,
//       controller: TextEditingController(text: _formData[fieldName] ?? ''),
//       decoration: InputDecoration(
//         labelText: labelText,
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please select a date';
//         }
//         return null;
//       },
//       onTap: () async {
//         DateTime? pickedDate = await _selectDate(context);
//         if (pickedDate != null) {
//           setState(() {
//             _formData[fieldName] =
//             _formData[fieldName] = DateFormat.yMd().format(pickedDate);
//           });
//         }
//       },
//     );
//   }
//
//   Future<DateTime?> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     return picked != null ? DateTime(picked.year, picked.month, picked.day) : null;
//   }
//
//   //installation date picker
//
//   Widget _buildTextFieldModelValidated(String key, String label) {
//     return FormBuilderTextField(
//       name: key,
//       initialValue: _formData[key]?.toString() ?? '',
//       decoration: InputDecoration(
//
//         labelText: label,
//         errorStyle: TextStyle(color: Colors.red),
//
//       ),
//
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value ?? '';
//         });
//       },
//       validator: FormBuilderValidators.compose([
//
//         // Max length of 25 characters
//         FormBuilderValidators.maxLength(25, errorText: 'Max length is 25 characters'),
//         // Allow only English capital letters and colons
//         FormBuilderValidators.match(
//           RegExp(r'^[a-zA-Z0-9&_: ]+$'),
//           errorText: 'Only English capital letters and colons are allowed',
//         ),
//       ]),
//     );
//   }
//
//
//
//
//   //dropdowns
//   //===========================================================================================================================
//
//   Widget _RegionDropdown(String key, String label) {
//     return FormBuilderDropdown(
//       name: key,
//       initialValue: _formData[key],
//       decoration: InputDecoration(
//         labelText: label,
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//       items: ['CPN',
//         'CPS',
//         'EPN',
//         'EPS',
//         'EPN–TC',
//         'HQ',
//         'NCP',
//         'NPN',
//         'NPS',
//         'NWPE',
//         'NWPW',
//         'PITI',
//         'SAB',
//         'SMW5',
//         'SMW6',
//         'SPE',
//         'SPW',
//         'WEL',
//         'WPC',
//         'WPE',
//         'WPN',
//         'WPNE',
//         'WPS',
//         'WPSE',
//         'WPSW',
//         'UVA']
//           .map((status) => DropdownMenuItem(value: status, child: Text(status)))
//           .toList(),
//       validator: (value) {
//         if (value == null || value
//             .toString()
//             .isEmpty) {
//           return 'Please select $label';
//         }
//         return null;
//       },
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value;
//         });
//       },
//     );
//   }
//
//   List<String> brands = [
//     'Mitsubishi', 'Abans', 'LG', 'Panasonic', 'York', 'Hitachi', 'Other'
//   ];
//
//
//   //brand dropdown
//
//   Widget _BrandDropdown(String key, String label) {
//     return FormBuilderDropdown(
//       name: key,
//       initialValue: _formData[key],
//       decoration: InputDecoration(
//         labelText: label,
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//
//       items: brands.map((brand) => DropdownMenuItem(
//           value: brand,
//           child: Text(brand)
//       )).toList(),
//       validator: (value) {
//         if (value == null || value.toString().isEmpty) {
//           return 'Please select $label';
//         }
//         return null;
//       },
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value;
//         });
//
//         if (value == 'Other') {
//           _showCustomBrandDialog(key);
//         }
//       },
//     );
//   }
//
//   void _showCustomBrandDialog(String key) {
//     TextEditingController customBrandController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: ColorScheme.light(primary: Colors.green),
//           ),
//           child: AlertDialog(
//             title: Text("Add Custom Brand"),
//             content: TextField(
//               controller: customBrandController,
//               decoration: InputDecoration(
//                 hintText: "Enter your brand name",
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: Text("Cancel"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               TextButton(
//                 child: Text("OK"),
//                 onPressed: () {
//                   String customBrand = customBrandController.text.trim();
//                   if (customBrand.isNotEmpty) {
//                     setState(() {
//                       brands.insert(brands.length - 1, customBrand);
//                       _formData[key] = customBrand;
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
// //brand dropdown
//
//
//
//   //capacity dropdown dropdown
//
//   List<String> Capacity = [
//     '0.75'+'TR', '1.00'+'TR', '1.50'+'TR', '2.00'+'TR', '2.50'+'TR', '3.00'+'TR', 'Other'
//   ];
//
//
//   Widget _CustomCapacityDropdown(String key, String label) {
//     return FormBuilderDropdown(
//       name: key,
//       initialValue: _formData[key],
//       decoration: InputDecoration(
//         labelText: label,
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//       items: Capacity.map((Capacity) => DropdownMenuItem(
//           value: Capacity,
//           child: Text(Capacity)
//       )).toList(),
//       validator: (value) {
//         if (value == null || value.toString().isEmpty) {
//           return 'Please select $label';
//         }
//         return null;
//       },
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value;
//         });
//
//         if (value == 'Other') {
//           _showCustomCapacityDialog(key);
//         }
//       },
//     );
//   }
//
//   void _showCustomCapacityDialog(String key) {
//     TextEditingController customCapacityController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: ColorScheme.light(primary: Colors.green),
//           ),
//           child: AlertDialog(
//             title: Text("Add Custom Brand"),
//             content: TextField(
//               controller: customCapacityController,
//               decoration: InputDecoration(
//                 hintText: "Enter Capacity(4.00TR)",
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: Text("Cancel"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               TextButton(
//                 child: Text("OK"),
//                 onPressed: () {
//                   String customCapacity = customCapacityController.text.trim();
//                   if (customCapacity.isNotEmpty) {
//                     setState(() {
//                       Capacity.insert(Capacity.length - 1, customCapacity);
//                       _formData[key] = customCapacity;
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
//
//   Widget _InstallationCategoryDropdown(String key, String label) {
//     return FormBuilderDropdown(
//       name: key,
//       initialValue: _formData[key],
//       decoration: InputDecoration(
//         labelText: label,
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//       items: ['Wall Mount', 'Floor Stand', 'Celing Mount', 'Celing Casette',]
//           .map((status) => DropdownMenuItem(value: status, child: Text(status)))
//           .toList(),
//       validator: (value) {
//         if (value == null || value
//             .toString()
//             .isEmpty) {
//           return 'Please select $label';
//         }
//         return null;
//       },
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value;
//         });
//       },
//     );
//   }
//
//
//   Widget _RefrigDropdown(String key, String label) {
//     return FormBuilderDropdown(
//       name: key,
//       initialValue: _formData[key],
//       decoration: InputDecoration(
//         labelText: label,
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//       items: ['R410', 'R22', 'R32',]
//           .map((status) => DropdownMenuItem(value: status, child: Text(status)))
//           .toList(),
//       validator: (value) {
//         if (value == null || value
//             .toString()
//             .isEmpty) {
//           return 'Please select $label';
//         }
//         return null;
//       },
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value;
//         });
//       },
//     );
//   }
//
//   Widget _PowerSupplyDropdown(String key, String label) {
//     return FormBuilderDropdown(
//       name: key,
//       initialValue: _formData[key],
//       decoration: InputDecoration(
//         labelText: label,
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//       items: ['1 Phase','3 Phase',]
//           .map((status) => DropdownMenuItem(value: status, child: Text(status)))
//           .toList(),
//       validator: (value) {
//         if (value == null || value
//             .toString()
//             .isEmpty) {
//           return 'Please select $label';
//         }
//         return null;
//       },
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value;
//         });
//       },
//     );
//   }
//
//
//   Widget _ConditionDropdown(String key, String label) {
//     return FormBuilderDropdown(
//       name: key,
//       initialValue: _formData[key],
//       decoration: InputDecoration(
//         labelText: label,
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//       items: ['Good', 'Faulty', 'Standby', 'Stopped', 'Waiting to dispose']
//           .map((status) => DropdownMenuItem(value: status, child: Text(status)))
//           .toList(),
//       validator: (value) {
//         if (value == null || value
//             .toString()
//             .isEmpty) {
//           return 'Please select $label';
//         }
//         return null;
//       },
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value;
//         });
//       },
//     );
//   }
//
//
//   Widget _RemoteDropdown(String key, String label) {
//     return FormBuilderDropdown(
//       name: key,
//       initialValue: _formData[key],
//       decoration: InputDecoration(
//         labelText: label,
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//       items: ['Yes', 'No']
//           .map((status) => DropdownMenuItem(value: status, child: Text(status)))
//           .toList(),
//       validator: (value) {
//         if (value == null || value
//             .toString()
//             .isEmpty) {
//           return 'Please select $label';
//         }
//         return null;
//       },
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value;
//         });
//       },
//     );
//   }
//
//
//   Widget _CategoryDropdown(String key, String label) {
//     return FormBuilderDropdown(
//       name: key,
//       initialValue: _formData[key],
//       decoration: InputDecoration(
//         labelText: label,
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//       items: ['Inverter', 'Non Inverter']
//           .map((status) => DropdownMenuItem(value: status, child: Text(status)))
//           .toList(),
//       validator: (value) {
//         if (value == null || value
//             .toString()
//             .isEmpty) {
//           return 'Please select $label';
//         }
//         return null;
//       },
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value;
//         });
//       },
//     );
//   }
//
//   void _resetForm() {
//     setState(() {
//       _formKey.currentState?.reset(); // Reset the form fields
//       _formData.clear(); // Clear the form data
//       _isOtherSelected.clear(); // Reset any additional state variables
//     });
//   }
//
//   Future<void> _submitData() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//
//       print("Form Data: $_formData");  // Debug print for form data
//
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => HttpPostAcUnits(formDataList: _formData, User:user),
//         ),
//       );
//     }
//   }
// }



//v1
// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import '../../../../Widgets/GPSGrab/gps_location_widget.dart';
// import '../../../UserAccess.dart';
// import 'httpPostAc.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:intl/intl.dart';
//
//
// class ACFormPage extends StatefulWidget {
//   final Map<String, dynamic>? initialData;
//
//
//   ACFormPage({this.initialData});
//
//   @override
//   _ACFormPageState createState() => _ACFormPageState();
// }
//
// class _ACFormPageState extends State<ACFormPage> {
//   final _formKey = GlobalKey<FormState>();
//   final Map<String, dynamic> _formData = {};
//   Map<String, bool> _isOtherSelected = {};
//
//   //user variable
//
//   String user = '';
//
//   // final Map<String, String> _customValues = {}; // Track custom values
//
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.initialData != null) {
//       _formData.addAll(widget.initialData!);
//       _isOtherSelected['brand'] = false;
//     }
//   }
//
//
//
//
//   final GPSLocationFetcher _locationFetcher = GPSLocationFetcher();
//   bool _isSubmitting = false;
//
//
//   TextEditingController _latitudeController1 = TextEditingController();
//   TextEditingController _longitudeController1 = TextEditingController();
//
//
//   void _fetchLocation() async {
//     try {
//       final location = await _locationFetcher.fetchLocation();
//       setState(() {
//         _latitudeController1.text = location['latitude']!;
//         _longitudeController1.text = location['longitude']!;
//       });
//
//       // Update _formData with fetched location
//       _formData['Latitude'] = _latitudeController1.text;
//       _formData['Longitude'] = _longitudeController1.text;
//     } catch (e) {
//       // Show CupertinoAlertDialog with warning animation
//       showCupertinoDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return CupertinoAlertDialog(
//             title: Row(
//               children: [
//                 Icon(CupertinoIcons.exclamationmark_triangle, color: Color(
//                     0xFFFC4C16)),
//                 SizedBox(width: 10),
//                 Text('Error'),
//               ],
//             ),
//             content: Text('Location Service is Disabled. Please Enable them to use auto-location'),
//             actions: <Widget>[
//               CupertinoDialogAction(
//                 child: Text('OK'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     UserAccess userAccess = Provider.of<UserAccess>(context, listen: true); // Use listen: true to rebuild the widget when the data changes
//     user=userAccess.username!;
//
//
//     bool? _isVerified;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('AC Units Form'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // Indoor Units Form Fields
//                 Text('AC Indoor Unit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//
//                 SizedBox(height: 20),
//                 Text('Location Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 _RegionDropdown('region', 'Region'),
//                 _buildTextField('rtom', 'RTOM (eg:Central Rec Room)'),
//                 _buildTextField('station', 'Station (eg: R:OTS_1)'),
//                 _buildTextField('rtom_building_id', 'RTOM Building ID (eg:Building A)'),
//                 _buildTextField('indoor_floor_number', 'Floor Number (eg:OTS-1-AC-No)'),
//                 _buildTextFieldModelValidated('indoor_office_number', 'Office Number (eg: 01)'),
//                 _buildTextFieldLocationValidated('indoor_location', 'Location (eg:OTS UPS room)'),
//                 // _buildNoAcPlantsTextField('no_AC_plants', 'No Of AC Plants'),
//
//                 // GPS Location fields
//                 _buildGPSLatitudeField('Latitude','Latitude (Enter Manually or press Get Location)',_latitudeController1),
//                 _buildGPSLongitudeField('Longitude','Longitude (Enter manually or press Get Location)',_longitudeController1),
//
//                 SizedBox(height: 20),
//                 // Fetch Location Button
//                 CupertinoButton(
//                   onPressed: _fetchLocation,
//                   color: Color(0xFF00AEE4),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min, // Keeps the button size compact
//                     children: [
//                       Icon(
//                         Icons.location_on, // choose any icon you prefer
//                         color: Colors.white, // Adjust the color of the icon
//                       ),
//                       SizedBox(width: 8), // space between the icon and text
//                       Text('Get Location'),
//                     ],
//                   ),
//                 ),
//
//                 SizedBox(height: 20),
//
//                 SizedBox(height: 20),
//                 Text('Asset Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 _buildTextField('QR_In', 'Indoor Tag Code(eg:AI:0001)'),
//                 _BrandDropdown('indoor_brand', 'Brand'),
//                 _buildTextFieldModelValidated('indoor_model', 'Model'),
//                 _CustomCapacityDropdown('indoor_capacity', 'Capacity'),
//                 _buildNumValTextField('serial_number', 'Serial Number'),
//                 _InstallationCategoryDropdown('installation_type', 'Installation Type'),
//                 _RefrigDropdown('refrigerant_type', 'Refrigerant Type'),
//                 _PowerSupplyDropdown('indoor_power_supply', 'Power Supply'),
//                 _ConditionDropdown('condition_ID_unit', 'Condition ID Unit'),
//                 _RemoteDropdown('remote_available', 'Remote Available'),
//                 _buildNotesTextField('indoor_notes', 'Notes'),
//                 // _StatusDropdown('indoor_status', 'Status'),
//
//
//                 SizedBox(height: 20),
//                 Text('Supplier and Warranty Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 _buildCustomDateField('installation_date', 'Installation Date (YYYY-MM-DD)'),
//                 _buildDatePicker('indoor_warranty_expiry_date', 'Warranty Expiry Date (YYYY-MM-DD)'),
//                 _buildTextFieldNonValidated('indoor_supplier_name', 'Supplier Name'),
//                 _buildNumValTextField('indoor_po_number', 'PO Number'),
//
//                 SizedBox(height: 40),
//
//                 Text('AC Outdoor Unit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//
//                 // SizedBox(height: 20),
//                 // Text('Location Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 // Add any location-specific fields for outdoor units if necessary
//
//                 SizedBox(height: 20),
//                 Text('Asset Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 _buildTextField('QR_Out', 'Outdoor Tag Code(eg:AO:0001)'),
//                 _BrandDropdown('brand', 'Brand'),
//                 _buildTextFieldModelValidated('model', 'Model'),
//                 _CustomCapacityDropdown('capacity', 'Capacity'),
//                 _buildTextFieldNonValidated('outdoor_fan_model', 'Outdoor Fan Model'),
//                 _PowerSupplyDropdown('outdoor_power_supply', 'Power Supply'),
//                 _CompressormountedDropdown('compressor_mounted_with', 'Compressor Mounted With'),
//                 _CustomCapacityDropdown('compressor_capacity', 'Compressor Capacity'),
//                 _BrandDropdown('compressor_brand', 'Compressor Brand'),
//                 _buildTextFieldModelValidated('compressor_model', 'Compressor Model'),
//                 _buildNumValTextField('compressor_serial_number', 'Compressor Serial Number'),
//                 _ConditionDropdown('condition_OD_unit', 'Condition OD Unit'),
//                 _buildNotesTextField('outdoor_notes', 'Notes'),
//                 // _StatusDropdown('outdoor_status', 'Status'),
//                 _CategoryDropdown('category', 'Category'),
//                 _buildCustomDateField('Installation_Date', 'Outdoor Installation Date (YYYY-MM-DD)'),
//
//
//                 SizedBox(height: 20),
//                 Text('Supplier and Warranty Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//
//                 _buildDatePicker('outdoor_warranty_expiry_date', 'Warranty Expiry Date (YYYY-MM-DD)'),
//
//                 _buildDatePicker('DoM', 'Date Of Manufactured'),
//                 _buildTextFieldNonValidated('outdoor_supplier_name', 'Supplier Name'),
//                 _buildNumValTextField('outdoor_po_number', 'PO Number'),
//
//                 SizedBox(height: 20),
//
//
//
//                 FormBuilderCheckbox(
//                   name: 'verify',
//                   initialValue: _isVerified,
//                   title: Text('I verify that submitted details are true and correct'),
//                   onChanged: (value) {
//                     setState(() {
//                       _isVerified = value;
//                     });
//                   },
//
//                   checkColor: Colors.white,
//                   activeColor: Color(0xFF0056A2),
//
//                   validator: (value) {
//                     if (value != true) {
//                       return 'You must verify the details to proceed.';
//                     }
//                     return null;
//                   },
//                 ),
//
//
//                 Row(
//                   children: <Widget>[
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () {
//                           _formKey.currentState?.reset();
//                         },
//                         style: ButtonStyle(
//                           foregroundColor:
//                           MaterialStateProperty.all<Color>(Colors.green),
//                           backgroundColor:
//                           MaterialStateProperty.all<Color>(Colors.white24),
//                         ),
//                         child: const Text(
//                           'Reset',
//                           style: TextStyle(
//                             color: Colors.redAccent,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     Expanded(
//                       child: ElevatedButton(
//                         style: ButtonStyle(
//                           backgroundColor:
//                           MaterialStateProperty.all<Color>(Colors.blueAccent),
//                         ),
//                         onPressed: _submitData,
//
//                         child: const Text(
//                           'Submit',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 // Submit Button
//                 // Buttons Row
//
//
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //   children: [
//                 //
//                 //     CupertinoButton(
//                 //       onPressed: _resetForm,
//                 //       child: const Text('Reset'),
//                 //       padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 70.0),
//                 //       color: Color(0xFF00AEE4),
//                 //     ),
//                 //
//                 //     CupertinoButton(
//                 //       onPressed:_submitData,
//                 //       child: const Text('Submit'),
//                 //       padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 70.0),
//                 //       color: Color(0xFF0056A2),
//                 //     ),
//                 //
//                 //
//                 //   ],
//                 //
//                 // ),
//
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//
//
//
//
//   //================================formBuilderTextfields With Validations====================================================================================================
//
//   Widget _buildTextField(String key, String label) {
//     return FormBuilderTextField(
//       name: key,
//       initialValue: _formData[key]?.toString() ?? '',
//       decoration: InputDecoration(
//
//           labelText: label,
//           errorStyle: TextStyle(color: Colors.red), // Optional: Customize error text style
//       ),
//
//
//
//       validator: FormBuilderValidators.compose([
//         FormBuilderValidators.required(errorText: 'Please enter $label'),
//         FormBuilderValidators.match(
//           RegExp(r'^[a-zA-Z0-9&_: ]+$'),
//           errorText: '$label must contain letters, numbers, and allowed symbols (&, _, :).',
//         ),
//         // FormBuilderValidators.minLength(1, errorText: 'Minimum 5 characters.'),
//         FormBuilderValidators.maxLength(
//             25, errorText: 'Maximum 25 characters.'),
//
//       ]),
//
//       autovalidateMode: AutovalidateMode.onUserInteraction,//validation on input
//
//       onChanged: (value) {
//         _formData[key] = value ?? '';
//       },
//     );
//   }
//
//
//   Widget _buildNotesTextField(String key, String label) {
//     return FormBuilderTextField(
//       name: key,
//       initialValue: _formData[key]?.toString() ?? '',
//       decoration: InputDecoration(
//
//         labelText: label,
//         errorStyle: TextStyle(color: Colors.red), // Optional: Customize error text style
//       ),
//
//
//
//       validator: FormBuilderValidators.compose([
//
//         FormBuilderValidators.match(
//           RegExp(r'^[a-zA-Z0-9&_: ]+$'),
//           errorText: '$label must contain letters, numbers, and allowed symbols (&, _, :).',
//         ),
//         // FormBuilderValidators.minLength(1, errorText: 'Minimum 5 characters.'),
//         FormBuilderValidators.maxLength(
//             200, errorText: 'Maximum 200 characters.'),
//
//       ]),
//
//       autovalidateMode: AutovalidateMode.onUserInteraction,//validation on input
//
//       onChanged: (value) {
//         _formData[key] = value ?? '';
//       },
//     );
//   }
//
//
//   Widget _CompressormountedDropdown(String key, String label) {
//     return FormBuilderDropdown(
//       name: key,
//       initialValue: _formData[key],
//       decoration: InputDecoration(
//         labelText: label,
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//       items: ['Indoor','Outdoor',]
//           .map((status) => DropdownMenuItem(value: status, child: Text(status)))
//           .toList(),
//       validator: (value) {
//         if (value == null || value
//             .toString()
//             .isEmpty) {
//           return 'Please select $label';
//         }
//         return null;
//       },
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value;
//         });
//       },
//     );
//   }
//
//
//
//   Widget _buildTextFieldLocationValidated(String key, String label) {
//     return FormBuilderTextField(
//       name: key,
//       initialValue: _formData[key]?.toString() ?? '',
//       decoration: InputDecoration(
//         labelText: label,
//         errorStyle: TextStyle(color: Colors.red), // Optional: Customize error text style
//       ),
//       validator: FormBuilderValidators.compose([
//         FormBuilderValidators.required(errorText: 'Please enter $label'),
//         FormBuilderValidators.match(
//           RegExp(r'^[a-zA-Z0-9&_: ]+$'),
//           errorText: '$label must contain letters, numbers, and allowed symbols (&, _, :).',
//         ),
//         FormBuilderValidators.maxLength(20, errorText: 'Maximum 20 characters allowed.'),
//       ]),
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       onChanged: (value) {
//         _formData[key] = value ?? '';
//       },
//     );
//   }
//
//
//
//   Widget _buildGPSLatitudeField(String name, String label, TextEditingController controller) {
//     return FormBuilderTextField(
//       name: name,
//
//       controller: controller,
//       decoration: InputDecoration(labelText: label),
//       readOnly: false,
//
//     validator: FormBuilderValidators.compose([
//       FormBuilderValidators.required(errorText: 'Please enter $label'),
//     ]),
//
//     );
//   }
//
//
//   Widget _buildGPSLongitudeField(String key, String label, TextEditingController controller) {
//     return FormBuilderTextField(
//       name: key,
//
//
//       controller: controller,
//       decoration: InputDecoration(labelText: label),
//       readOnly: false,
//
//       validator: FormBuilderValidators.compose([
//         FormBuilderValidators.required(errorText: 'Please enter $label'),
//       ]),
//
//     );
//   }
//
//
//   Widget _buildTextFieldNonValidated(String key, String label) {
//     return FormBuilderTextField(
//       name: key,
//       initialValue: _formData[key]?.toString() ?? '',
//       decoration: InputDecoration(
//           labelText: label,
//         errorStyle: TextStyle(color: Colors.red), // Optional: Customize error text style
//       ),
//
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value ?? '';
//         });
//       },
//
//       validator: FormBuilderValidators.compose([
//         // Max length of 25 characters
//         FormBuilderValidators.maxLength(25, errorText: 'Max length is 25 characters'),
//         // Allow only English capital letters and colons
//         FormBuilderValidators.match(
//           RegExp(r'^[a-zA-Z0-9&_: ]+$'),
//           errorText: '$label must contain letters, numbers, and allowed symbols (&, _, :).',
//         ),
//       ]),
//
//
//     );
//   }
//
//
//
//   Widget _buildNumValTextField(String key, String label) {
//     return FormBuilderTextField(
//       keyboardType: TextInputType.number,
//       name: key,
//       initialValue: _formData[key]?.toString() ?? '',
//       decoration: InputDecoration(
//           labelText: label,
//           errorStyle: TextStyle(color: Colors.red), // Optional: Customize error text style
//
//       ),
//       validator: FormBuilderValidators.compose([
//         // FormBuilderValidators.required(errorText: 'Please enter $label'),
//         FormBuilderValidators.numeric(errorText: '$label must be a number'),
//         // Custom validator to ensure the number is an integer
//         //     (value) {
//         //   final numValue = num.tryParse(value ?? '');
//         //   if (numValue == null) {
//         //     return '$label must be a number';
//         //   }
//         //   if (numValue % 1 != 0) {
//         //     return '$label must be an integer';
//         //   }
//         //   return null;
//         // },
//         // FormBuilderValidators.min(1, errorText: '$label must be at least 1'),
//         // FormBuilderValidators.maxLength(
//         //     10, errorText: '$label cannot be more than 10 characters'),
//         // FormBuilderValidators.match(
//         //     r'^[0-9]+$', errorText: '$label must contain only numbers'),
//       ]),
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       onChanged: (value) {
//         _formData[key] = value ?? '';
//       },
//     );
//   }
//
//
//   Widget _buildNoAcPlantsTextField(String key, String label) {
//     return FormBuilderTextField(
//       keyboardType: TextInputType.number,
//       name: key,
//       initialValue: _formData[key]?.toString() ?? '',
//       decoration: InputDecoration(labelText: label),
//       validator: FormBuilderValidators.compose([
//         FormBuilderValidators.required(errorText: 'Please enter $label'),
//
//         FormBuilderValidators.numeric(errorText: '$label must be a number'),
//
//             (value) {
//           final numValue = num.tryParse(value ?? '');
//           if (numValue == null) {
//             return '$label must be a number';
//           }
//           if (numValue % 1 != 0) {
//             return '$label must be an integer';
//           }
//           return null;
//         },
//
//         // FormBuilderValidators.match(
//         //     r'^[0-9]+$', errorText: '$label must contain only numbers'),
//         FormBuilderValidators.min(1, errorText: 'Minimum value must be 1.'),
//         FormBuilderValidators.max(10, errorText: 'cannot be more than 10.'),
//
//
//       ]),
//       onChanged: (value) {
//         _formData[key] = value ?? '';
//       },
//     );
//   }
//
//
//   Widget _buildDatePicker(String key, String label) {
//     return FormBuilderDateTimePicker(
//       name: key,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//       inputType: InputType.date,
//       decoration: InputDecoration(
//         labelText: label,
//       ),
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value?.toString().split(' ')[0];
//         });
//       },
//     );
//   }
//
//
//
//   Widget _buildCustomDateField(String fieldName, String labelText) {
//     return TextFormField(
//       readOnly: true,
//       controller: TextEditingController(text: _formData[fieldName] ?? ''),
//       decoration: InputDecoration(
//         labelText: labelText,
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please select a date';
//         }
//         return null;
//       },
//       onTap: () async {
//         DateTime? pickedDate = await _selectDate(context);
//         if (pickedDate != null) {
//           setState(() {
//             _formData[fieldName] =
//             _formData[fieldName] = DateFormat.yMd().format(pickedDate);
//           });
//         }
//       },
//     );
//   }
//
//   Future<DateTime?> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     return picked != null ? DateTime(picked.year, picked.month, picked.day) : null;
//   }
//
//   //installation date picker
//
//   Widget _buildTextFieldModelValidated(String key, String label) {
//     return FormBuilderTextField(
//       name: key,
//       initialValue: _formData[key]?.toString() ?? '',
//       decoration: InputDecoration(
//
//           labelText: label,
//         errorStyle: TextStyle(color: Colors.red),
//
//       ),
//
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value ?? '';
//         });
//       },
//       validator: FormBuilderValidators.compose([
//         // Max length of 25 characters
//         FormBuilderValidators.maxLength(25, errorText: 'Max length is 25 characters'),
//         // Allow only English capital letters and colons
//         FormBuilderValidators.match(
//           RegExp(r'^[a-zA-Z0-9&_: ]+$'),
//           errorText: '$label must contain letters, numbers, and allowed symbols (&, _, :).',
//         ),
//       ]),
//     );
//   }
//
//
//
//
//   //dropdowns
//   //===========================================================================================================================
//
//   Widget _RegionDropdown(String key, String label) {
//     return FormBuilderDropdown(
//       name: key,
//       initialValue: _formData[key],
//       decoration: InputDecoration(
//         labelText: label,
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//       items: ['CPN',
//         'CPS',
//         'EPN',
//         'EPS',
//         'EPN–TC',
//         'HQ',
//         'NCP',
//         'NPN',
//         'NPS',
//         'NWPE',
//         'NWPW',
//         'PITI',
//         'SAB',
//         'SMW5',
//         'SMW6',
//         'SPE',
//         'SPW',
//         'WEL',
//         'WPC',
//         'WPE',
//         'WPN',
//         'WPNE',
//         'WPS',
//         'WPSE',
//         'WPSW',
//         'UVA']
//           .map((status) => DropdownMenuItem(value: status, child: Text(status)))
//           .toList(),
//       validator: (value) {
//         if (value == null || value
//             .toString()
//             .isEmpty) {
//           return 'Please select $label';
//         }
//         return null;
//       },
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value;
//         });
//       },
//     );
//   }
//
//   List<String> brands = [
//     'Mitsubishi', 'Abans', 'LG', 'Panasonic', 'York', 'Hitachi', 'Other'
//   ];
//
//
//   //brand dropdown
//
//   Widget _BrandDropdown(String key, String label) {
//     return FormBuilderDropdown(
//       name: key,
//       initialValue: _formData[key],
//       decoration: InputDecoration(
//         labelText: label,
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//
//       items: brands.map((brand) => DropdownMenuItem(
//           value: brand,
//           child: Text(brand)
//       )).toList(),
//       validator: (value) {
//         if (value == null || value.toString().isEmpty) {
//           return 'Please select $label';
//         }
//         return null;
//       },
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value;
//         });
//
//         if (value == 'Other') {
//           _showCustomBrandDialog(key);
//         }
//       },
//     );
//   }
//
//   void _showCustomBrandDialog(String key) {
//     TextEditingController customBrandController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: ColorScheme.light(primary: Colors.green),
//           ),
//           child: AlertDialog(
//             title: Text("Add Custom Brand"),
//             content: TextField(
//               controller: customBrandController,
//               decoration: InputDecoration(
//                 hintText: "Enter your brand name",
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: Text("Cancel"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               TextButton(
//                 child: Text("OK"),
//                 onPressed: () {
//                   String customBrand = customBrandController.text.trim();
//                   if (customBrand.isNotEmpty) {
//                     setState(() {
//                       brands.insert(brands.length - 1, customBrand);
//                       _formData[key] = customBrand;
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
// //brand dropdown
//
//
//
//   //capacity dropdown dropdown
//
//   List<String> Capacity = [
//     '0.75'+'TR', '1.00'+'TR', '1.50'+'TR', '2.00'+'TR', '2.50'+'TR', '3.00'+'TR', 'Other'
//   ];
//
//
//   Widget _CustomCapacityDropdown(String key, String label) {
//     return FormBuilderDropdown(
//       name: key,
//       initialValue: _formData[key],
//       decoration: InputDecoration(
//         labelText: label,
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//       items: Capacity.map((Capacity) => DropdownMenuItem(
//           value: Capacity,
//           child: Text(Capacity)
//       )).toList(),
//       validator: (value) {
//         if (value == null || value.toString().isEmpty) {
//           return 'Please select $label';
//         }
//         return null;
//       },
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value;
//         });
//
//         if (value == 'Other') {
//           _showCustomCapacityDialog(key);
//         }
//       },
//     );
//   }
//
//   void _showCustomCapacityDialog(String key) {
//     TextEditingController customCapacityController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: ColorScheme.light(primary: Colors.green),
//           ),
//           child: AlertDialog(
//             title: Text("Add Custom Brand"),
//             content: TextField(
//               controller: customCapacityController,
//               decoration: InputDecoration(
//                 hintText: "Enter Capacity(4.00TR)",
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: Text("Cancel"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               TextButton(
//                 child: Text("OK"),
//                 onPressed: () {
//                   String customCapacity = customCapacityController.text.trim();
//                   if (customCapacity.isNotEmpty) {
//                     setState(() {
//                       Capacity.insert(Capacity.length - 1, customCapacity);
//                       _formData[key] = customCapacity;
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
//
//   Widget _InstallationCategoryDropdown(String key, String label) {
//     return FormBuilderDropdown(
//       name: key,
//       initialValue: _formData[key],
//       decoration: InputDecoration(
//         labelText: label,
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//       items: ['Wall Mount', 'Floor Stand', 'Celing Mount', 'Celing Casette',]
//           .map((status) => DropdownMenuItem(value: status, child: Text(status)))
//           .toList(),
//       validator: (value) {
//         if (value == null || value
//             .toString()
//             .isEmpty) {
//           return 'Please select $label';
//         }
//         return null;
//       },
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value;
//         });
//       },
//     );
//   }
//
//
//   Widget _RefrigDropdown(String key, String label) {
//     return FormBuilderDropdown(
//       name: key,
//       initialValue: _formData[key],
//       decoration: InputDecoration(
//         labelText: label,
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//       items: ['R410', 'R22', 'R32',]
//           .map((status) => DropdownMenuItem(value: status, child: Text(status)))
//           .toList(),
//       validator: (value) {
//         if (value == null || value
//             .toString()
//             .isEmpty) {
//           return 'Please select $label';
//         }
//         return null;
//       },
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value;
//         });
//       },
//     );
//   }
//
//   Widget _PowerSupplyDropdown(String key, String label) {
//     return FormBuilderDropdown(
//       name: key,
//       initialValue: _formData[key],
//       decoration: InputDecoration(
//         labelText: label,
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//       items: ['1 Phase','3 Phase',]
//           .map((status) => DropdownMenuItem(value: status, child: Text(status)))
//           .toList(),
//       validator: (value) {
//         if (value == null || value
//             .toString()
//             .isEmpty) {
//           return 'Please select $label';
//         }
//         return null;
//       },
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value;
//         });
//       },
//     );
//   }
//
//
//   Widget _ConditionDropdown(String key, String label) {
//     return FormBuilderDropdown(
//       name: key,
//       initialValue: _formData[key],
//       decoration: InputDecoration(
//         labelText: label,
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//       items: ['Good', 'Faulty', 'Standby', 'Stopped', 'Waiting to dispose']
//           .map((status) => DropdownMenuItem(value: status, child: Text(status)))
//           .toList(),
//       validator: (value) {
//         if (value == null || value
//             .toString()
//             .isEmpty) {
//           return 'Please select $label';
//         }
//         return null;
//       },
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value;
//         });
//       },
//     );
//   }
//
//
//   Widget _RemoteDropdown(String key, String label) {
//     return FormBuilderDropdown(
//       name: key,
//       initialValue: _formData[key],
//       decoration: InputDecoration(
//         labelText: label,
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//       items: ['Yes', 'No']
//           .map((status) => DropdownMenuItem(value: status, child: Text(status)))
//           .toList(),
//       validator: (value) {
//         if (value == null || value
//             .toString()
//             .isEmpty) {
//           return 'Please select $label';
//         }
//         return null;
//       },
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value;
//         });
//       },
//     );
//   }
//
//
//   Widget _CategoryDropdown(String key, String label) {
//     return FormBuilderDropdown(
//       name: key,
//       initialValue: _formData[key],
//       decoration: InputDecoration(
//         labelText: label,
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//       items: ['Inverter', 'Non Inverter']
//           .map((status) => DropdownMenuItem(value: status, child: Text(status)))
//           .toList(),
//       validator: (value) {
//         if (value == null || value
//             .toString()
//             .isEmpty) {
//           return 'Please select $label';
//         }
//         return null;
//       },
//       onChanged: (value) {
//         setState(() {
//           _formData[key] = value;
//         });
//       },
//     );
//   }
//
//   void _resetForm() {
//     setState(() {
//       _formKey.currentState?.reset(); // Reset the form fields
//       _formData.clear(); // Clear the form data
//       _isOtherSelected.clear(); // Reset any additional state variables
//     });
//   }
//
//   Future<void> _submitData() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//
//       print("Form Data: $_formData");  // Debug print for form data
//
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => HttpPostAcUnits(formDataList: _formData, User:user),
//         ),
//       );
//     }
//   }
// }