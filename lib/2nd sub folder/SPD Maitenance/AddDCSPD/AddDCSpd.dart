//Gathering of Generator data though user forum

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:theme_update/theme_provider.dart';
// import 'package:theme_update/theme_toggle_button.dart';

//import '../../../UserAccess.dart';
import '../../../widgets/theme change related widjets/theme_provider.dart';
import '../../../widgets/theme change related widjets/theme_toggle_button.dart';
import '../AddACSPD/httpPostSPD.dart';

class AddDCSpd extends StatefulWidget {
  @override
  _AddDCSpdState createState() => _AddDCSpdState();
}

class _AddDCSpdState extends State<AddDCSpd> {
  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add dc SPD Info',
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
  bool autoValidate = true;
  bool readOnly = false;
  Map<String, dynamic> updatedValues = {};

  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _regionHasError = false;
  bool _eBrandHasError = false;
  bool _aBrandHasError = false;
  bool _validator1 = false;
  bool _validator2 = false;
  bool _validator3 = false;
  bool _validator4 = false;
  bool _validator5 = false;
  bool _validator6 = false;
  bool _validator7 = false;
  bool _validator8 = false;
  bool _validator9 = false;

  double _sliderValue = 0.0;
  bool _burned = false;
  bool _dcSPD = false;
  bool _dcFlag = true;
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

                  // ...existing code...
                    //Region Select
                    FormBuilderDropdown<String>(
                      name: 'province',
                      style: TextStyle(color: customColors.mainTextColor),
                      initialValue:
                          Regions.contains(updatedValues["province"])
                              ? updatedValues["province"] as String?
                              : null, // Default value
                      decoration: InputDecoration(
                        labelText: 'Region',
                        suffix:
                            _regionHasError
                                ? const Icon(Icons.error)
                                : const Icon(Icons.check, color: Colors.green),
                        hintText: 'Select Region',
                      ),
                      dropdownColor: customColors.suqarBackgroundColor,
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
                            key: "province", // Dialog key
                            brandList: Regions, // Pass the Regions list
                            formData: updatedValues, // Pass the map to be updated
                            formKey: "province", // Key in formData to update
                          );
                        } else {
                          setState(() {
                            updatedValues['province'] = val; // Update the central map
                            _selectedValues['province'] = val!; // Your existing logic
                            // selectedRegion = val; // If you have a specific state variable like selectedRegion
                            _regionHasError =
                                !(_formKey.currentState?.fields['province']
                                        ?.validate() ??
                                    false);
                            // If selecting a region should reset RTOM or other dependent fields, do it here.
                            // Example: _formKey.currentState?.fields['Rtom_name']?.didChange(null);
                          });
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
                      name: 'poles',
                      initialValue: 'N/A',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: '2', //this is 3 phase
                          child: Text('Two Pole'),
                          avatar: CircleAvatar(child: Text('')),
                        ),
                        FormBuilderChipOption(
                          value: '3', //this is 3 phase
                          child: Text('Three Pole'),
                          avatar: CircleAvatar(child: Text('')),
                        ),
                      ],

                      // onChanged: _onChanged,
                    ),
                    SizedBox(height: 10),
        
                    //Alternator Brand
                    FormBuilderDropdown<String>(
                      name: 'SPDType',
                      style: TextStyle(color: customColors.mainTextColor),
                      initialValue:
                          SPDTypes.contains(updatedValues["SPDType"]) // Check against SPDTypes
                              ? updatedValues["SPDType"] as String?
                              : (SPDTypes.contains("Unknown") ? "Unknown" : null), // Default to "Unknown" if available, else null
                      decoration: InputDecoration(
                        labelText: 'Select SPD Type',
                        suffix:
                            _aBrandHasError
                                ? const Icon(Icons.error)
                                : const Icon(Icons.check, color: Colors.green),
                        hintText: 'Select SPD Type',
                      ),
                      dropdownColor: customColors.suqarBackgroundColor,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      items: [
                        ...SPDTypes.where(
                          (String value) => value != "Other",
                        ).map((String value) {
                          return DropdownMenuItem<String>(
                            alignment: AlignmentDirectional.center,
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
                          alignment: AlignmentDirectional.center,
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
                            key: "SPDType_dialog", // Unique key for the dialog
                            brandList: SPDTypes,
                            formData: updatedValues,
                            formKey: "SPDType", // Key in updatedValues
                          );
                        } else {
                          setState(() {
                            updatedValues['SPDType'] = val; // Update the central map
                            _selectedValues['SPDType'] = val!; // Your existing logic
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
                          SPDBrands.contains(updatedValues["SPD_Manu"]) // Check against SPDBrands
                              ? updatedValues["SPD_Manu"] as String?
                              : null, // Default value
                      decoration: InputDecoration(
                        labelText: 'SPD Manufacturer',
                        suffix:
                            _eBrandHasError
                                ? const Icon(Icons.error)
                                : const Icon(Icons.check, color: Colors.green),
                        hintText: 'Select SPD Manufacturer', // Corrected hint
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
                            alignment: AlignmentDirectional.center,
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
                          alignment: AlignmentDirectional.center,
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
                            key: "SPD_Manu_dialog", // Unique key for the dialog
                            brandList: SPDBrands,
                            formData: updatedValues,
                            formKey: "SPD_Manu", // Key in updatedValues
                          );
                        } else {
                          setState(() {
                            updatedValues['SPD_Manu'] = val; // Update the central map
                            _selectedValues['SPD_Manu'] = val!; // Your existing logic
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
                        labelText: 'Percentage Level %',
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
                        FormBuilderValidators.max(2500),
                      ]),
                      // initialValue: '12',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),

                    SizedBox(height: 10),
                    Text(
                      'Maximum continuous operating voltage (Uc)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold, // Set the fontWeight to bold
                      ),
                    ),

                    SizedBox(height: 10),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'UcDCVolt',
                      style: TextStyle(color: customColors.mainTextColor),

                      decoration: InputDecoration(
                        labelText: 'Uc in Volt',
                        suffixIcon:
                            _validator2
                                ? const Icon(Icons.error, color: Colors.red)
                                : const Icon(Icons.check, color: Colors.green),
                      ),
                      enabled: !_dcSPD,

                      onChanged: (val) {
                        setState(() {
                          _validator2 =
                              !(_formKey.currentState?.fields['UcDCVolt']
                                      ?.validate() ??
                                  false);
                        });
                      },

                      // valueTransformer: (text) => num.tryParse(text),
                      validator: FormBuilderValidators.compose([
                        //FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.max(2500),
                      ]),

                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),

                    SizedBox(height: 10),
                    Text(
                      'Voltage Protection Level',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold, // Set the fontWeight to bold
                      ),
                    ),
                    SizedBox(height: 10),

                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'UpDCVolt',
                      style: TextStyle(color: customColors.mainTextColor),

                      decoration: InputDecoration(
                        labelText: 'Up (DC) in kV',
                        suffixIcon:
                            _validator3
                                ? const Icon(Icons.error, color: Colors.red)
                                : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _validator3 =
                              !(_formKey.currentState?.fields['UpDCVolt']
                                      ?.validate() ??
                                  false);
                        });
                      },
                      // valueTransformer: (text) => num.tryParse(text),
                      validator: FormBuilderValidators.compose([
                        //FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.max(5),
                      ]),
                      // initialValue: '12',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),

                    SizedBox(height: 10),
                    Text(
                      'Discharge Current Rating',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold, // Set the fontWeight to bold
                      ),
                    ),
                    SizedBox(height: 10),

                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'Nom_Dis8_20',
                      style: TextStyle(color: customColors.mainTextColor),

                      decoration: InputDecoration(
                        labelText: 'Nominal Current(In) (8/20µs) (kA)',
                        suffixIcon:
                            _validator4
                                ? const Icon(Icons.error, color: Colors.red)
                                : const Icon(Icons.check, color: Colors.green),
                      ),
                      enabled: !_dcSPD,
                      onChanged: (val) {
                        setState(() {
                          _validator4 =
                              !(_formKey.currentState?.fields['Nom_DisDC']
                                      ?.validate() ??
                                  false);
                        });
                      },
                      // valueTransformer: (text) => num.tryParse(text),
                      validator: FormBuilderValidators.compose([
                        //FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.max(100),
                      ]),
                      // initialValue: '12',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 10),

                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'Nom_Dis10_350',
                      style: TextStyle(color: customColors.mainTextColor),

                      decoration: InputDecoration(
                        labelText: 'Impulse Current (I_imp) (10/350µs) (kA)',
                        suffixIcon:
                            _validator9
                                ? const Icon(Icons.error, color: Colors.red)
                                : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _validator9 =
                              !(_formKey.currentState?.fields['Nom_DisDC']
                                      ?.validate() ??
                                  false);
                        });
                      },
                      // valueTransformer: (text) => num.tryParse(text),
                      validator: FormBuilderValidators.compose([
                        // FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.max(200),
                      ]),
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
                          // validator: FormBuilderValidators.required(),
                          onChanged:
                              (value) => setState(() {
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

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => httpPostSPD(
                                    formData: formData ?? {},
                                    dcFlag: true,
                                    //  userAccess: userAccess,
                                  ),
                            ),
                          );
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
