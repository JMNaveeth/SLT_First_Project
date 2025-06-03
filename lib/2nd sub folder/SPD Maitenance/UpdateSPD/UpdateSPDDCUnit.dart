import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';
import 'HttpUpdateSPD.dart';

class UpdateDCUnit extends StatefulWidget {
  final Map<String, dynamic> record;

  const UpdateDCUnit({Key? key, required this.record}) : super(key: key);

  @override
  _UpdateDCUnitState createState() => _UpdateDCUnitState();
}

class _UpdateDCUnitState extends State<UpdateDCUnit> {
  final _formKey = GlobalKey<FormBuilderState>();
  String? selectedRegion;
  bool _burned = true;
  bool _isVerified = false;

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
  Map<String, List<String>> regionToDistricts = {
    "CPN": ['Kandy', 'Dambulla', 'Matale'],
    "CPS": ['Gampola', 'Nuwaraeliya', 'Haton', 'Peradeniya', 'Nawalapitiya'],
    "EPN": ['Batticaloa'],
    'EPNTC': ['Trincomalee'],
    'EPS': ['Ampara', 'Kalmunai'],
    'HQ': ['Head Office'],
    'NCP': ['Anuradhapura', 'Polonnaruwa'],
    'NPN': ['Jaffna'],
    'NPS': ['MB', 'Vaunia', 'Mulativ', 'Kilinochchi'],
    'NWPE': ['Kurunagala', 'Kuliyapitiya'],
    'NWPW': ['Chilaw', 'Puttalam'],
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
  var SPDTypes = ['Type 1', 'Type1+2', 'Type 2', 'Type 3', 'Unknown', 'Other'];

  List<String> getRtomOptions() {
    return selectedRegion != null &&
            regionToDistricts.containsKey(selectedRegion!)
        ? regionToDistricts[selectedRegion!]!
        : [];
  }

  @override
  void initState() {
    super.initState();
    selectedRegion = widget.record['province'];
  }

  void _showAddOtherRegionDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final TextEditingController customRegionController =
        TextEditingController();

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
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: customColors.mainTextColor,
              ),
            ),
          ),
          child: AlertDialog(
            backgroundColor: customColors.suqarBackgroundColor,
            title: Text(
              "Add Custom Region",
              style: TextStyle(color: customColors.mainTextColor),
            ),
            content: TextField(
              controller: customRegionController,
              style: TextStyle(color: customColors.mainTextColor),
              decoration: InputDecoration(
                hintText: "Enter your region name",
                hintStyle: TextStyle(
                  color: customColors.mainTextColor.withOpacity(0.7),
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  if (_formKey.currentState?.fields['province']?.value ==
                      'Other') {
                    _formKey.currentState?.fields['province']?.didChange(
                      widget.record['province'] ?? null,
                    );
                    setState(() {
                      selectedRegion = widget.record['province'] ?? null;
                      _formKey.currentState?.fields['Rtom_name']?.didChange(
                        widget.record['Rtom_name'] ?? null,
                      );
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("OK", style: TextStyle(color: Colors.blue)),
                onPressed: () {
                  String customRegion = customRegionController.text.trim();
                  if (customRegion.isNotEmpty) {
                    setState(() {
                      if (!Regions.contains(customRegion)) {
                        int otherIndex = Regions.indexOf("Other");
                        if (otherIndex != -1) {
                          Regions.insert(otherIndex, customRegion);
                        } else {
                          Regions.add(customRegion);
                        }
                      }
                      selectedRegion = customRegion;
                      _formKey.currentState?.fields['province']?.didChange(
                        customRegion,
                      );
                      _formKey.currentState?.fields['Rtom_name']?.didChange(
                        null,
                      ); // Reset RTOM as region changed
                    });
                  } else {
                    _formKey.currentState?.fields['province']?.didChange(
                      widget.record['province'] ?? null,
                    );
                    setState(() {
                      selectedRegion = widget.record['province'] ?? null;
                      _formKey.currentState?.fields['Rtom_name']?.didChange(
                        widget.record['Rtom_name'] ?? null,
                      );
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

  void _showAddOtherSPDTypeDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final TextEditingController customSPDTypeController =
        TextEditingController();

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
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: customColors.mainTextColor,
              ),
            ),
          ),
          child: AlertDialog(
            backgroundColor: customColors.suqarBackgroundColor,
            title: Text(
              "Add Custom SPD Type",
              style: TextStyle(color: customColors.mainTextColor),
            ),
            content: TextField(
              controller: customSPDTypeController,
              style: TextStyle(color: customColors.mainTextColor),
              decoration: InputDecoration(
                hintText: "Enter your SPD Type",
                hintStyle: TextStyle(
                  color: customColors.mainTextColor.withOpacity(0.7),
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  if (_formKey.currentState?.fields['SPDType']?.value ==
                      'Other') {
                    _formKey.currentState?.fields['SPDType']?.didChange(
                      widget.record['SPDType'] ?? 'Unknown',
                    );
                  }
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("OK", style: TextStyle(color: Colors.blue)),
                onPressed: () {
                  String customSPDType = customSPDTypeController.text.trim();
                  if (customSPDType.isNotEmpty) {
                    setState(() {
                      if (!SPDTypes.contains(customSPDType)) {
                        int otherIndex = SPDTypes.indexOf("Other");
                        if (otherIndex != -1) {
                          SPDTypes.insert(otherIndex, customSPDType);
                        } else {
                          SPDTypes.add(customSPDType);
                        }
                      }
                      _formKey.currentState?.fields['SPDType']?.didChange(
                        customSPDType,
                      );
                    });
                  } else {
                    _formKey.currentState?.fields['SPDType']?.didChange(
                      widget.record['SPDType'] ?? 'Unknown',
                    );
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

  void _showAddOtherSPDBrandDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final TextEditingController customSPDBrandController =
        TextEditingController();

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
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: customColors.mainTextColor,
              ),
            ),
          ),
          child: AlertDialog(
            backgroundColor: customColors.suqarBackgroundColor,
            title: Text(
              "Add Custom SPD Brand/Manufacturer",
              style: TextStyle(color: customColors.mainTextColor),
            ),
            content: TextField(
              controller: customSPDBrandController,
              style: TextStyle(color: customColors.mainTextColor),
              decoration: InputDecoration(
                hintText: "Enter SPD Brand/Manufacturer",
                hintStyle: TextStyle(
                  color: customColors.mainTextColor.withOpacity(0.7),
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  if (_formKey.currentState?.fields['SPD_Manu']?.value ==
                      'Other') {
                    _formKey.currentState?.fields['SPD_Manu']?.didChange(
                      widget.record['SPD_Manu'] ?? null,
                    );
                  }
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("OK", style: TextStyle(color: Colors.blue)),
                onPressed: () {
                  String customSPDBrand = customSPDBrandController.text.trim();
                  if (customSPDBrand.isNotEmpty) {
                    setState(() {
                      if (!SPDBrands.contains(customSPDBrand)) {
                        int otherIndex = SPDBrands.indexOf("Other");
                        if (otherIndex != -1) {
                          SPDBrands.insert(otherIndex, customSPDBrand);
                        } else {
                          SPDBrands.add(customSPDBrand);
                        }
                      }
                      _formKey.currentState?.fields['SPD_Manu']?.didChange(
                        customSPDBrand,
                      );
                    });
                  } else {
                    _formKey.currentState?.fields['SPD_Manu']?.didChange(
                      widget.record['SPD_Manu'] ?? null,
                    );
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

    return Scaffold(
      backgroundColor: customColors.mainBackgroundColor,

      appBar: AppBar(
        title: Text(
          'Update DC SPD Info',
          style: TextStyle(color: customColors.mainTextColor),
        ),
        backgroundColor: customColors.appbarColor,
        iconTheme: IconThemeData(color: customColors.mainTextColor),

        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FormBuilder(
                key: _formKey,
                initialValue: widget.record,
                child: Column(
                  children: [
                    // SPDid (Read-only field)
                    FormBuilderTextField(
                      name: 'SPDid',
                      style: TextStyle(color: customColors.mainTextColor),

                      initialValue: widget.record['SPDid'],
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'SPDid (Read-Only)',
                      ),
                    ),
                    SizedBox(height: 10),

                    // Region Dropdown
                    FormBuilderDropdown<String>(
                      name: 'province',
                      dropdownColor: customColors.suqarBackgroundColor,

                      style: TextStyle(color: customColors.mainTextColor),
                      decoration: const InputDecoration(labelText: 'Region'),
                      items:
                          Regions.map(
                            (region) => DropdownMenuItem(
                              value: region,
                              child: Text(region),
                            ),
                          ).toList(),
                      onChanged: (value) {
                        if (value == 'Other') {
                          _showAddOtherRegionDialog();
                        } else {
                          setState(() {
                            selectedRegion = value;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 10),

                    // RTOM Dropdown
                    FormBuilderDropdown<String>(
                      name: 'Rtom_name',
                      style: TextStyle(color: customColors.mainTextColor),
                      dropdownColor: customColors.suqarBackgroundColor,

                      decoration: const InputDecoration(labelText: 'RTOM'),
                      items:
                          getRtomOptions()
                              .map(
                                (rtom) => DropdownMenuItem(
                                  value: rtom,
                                  child: Text(rtom),
                                ),
                              )
                              .toList(),
                    ),
                    SizedBox(height: 10),

                    // Station TextField
                    FormBuilderTextField(
                      name: 'station',
                      style: TextStyle(color: customColors.mainTextColor),

                      decoration: const InputDecoration(
                        labelText: 'Station (QR Code ID)',
                      ),
                    ),
                    SizedBox(height: 10),

                    // SPD Location
                    FormBuilderTextField(
                      name: 'SPDLoc',
                      style: TextStyle(color: customColors.mainTextColor),

                      decoration: const InputDecoration(
                        labelText: 'SPD Location (DB Location)',
                      ),
                    ),
                    SizedBox(height: 10),

                    // Unit Type (Poles)
                    FormBuilderChoiceChips<String>(
                      decoration: const InputDecoration(labelText: 'Unit Type'),
                      name: 'poles',
                      initialValue: widget.record['poles'] ?? 'N/A',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: '2', // Two Pole
                          child: Text('Two Pole'),
                          avatar: CircleAvatar(child: Text('2')),
                        ),
                        FormBuilderChipOption(
                          value: '3', // Three Pole
                          child: Text('Three Pole'),
                          avatar: CircleAvatar(child: Text('3')),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // SPD Type Dropdown
                    FormBuilderDropdown<String>(
                      name: 'SPDType',
                      style: TextStyle(color: customColors.mainTextColor),
                      dropdownColor: customColors.suqarBackgroundColor,

                      decoration: const InputDecoration(labelText: 'SPD Type'),
                      items:
                          SPDTypes.map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          ).toList(),
                           onChanged: (value) {
                        if (value == 'Other') {
                          _showAddOtherSPDTypeDialog();
                        } else {
                        }
                      },
                    ),
                    SizedBox(height: 10),

                    // Manufacturer Dropdown
                    FormBuilderDropdown<String>(
                      name: 'SPD_Manu',
                      style: TextStyle(color: customColors.mainTextColor),

                      dropdownColor: customColors.suqarBackgroundColor,

                      decoration: const InputDecoration(
                        labelText: 'SPD Manufacturer',
                      ),
                      items:
                          SPDBrands.map(
                            (brand) => DropdownMenuItem(
                              value: brand,
                              child: Text(brand),
                            ),
                          ).toList(),
                           onChanged: (value) {
                        if (value == 'Other') {
                          _showAddOtherSPDBrandDialog();
                        } else {
                        }
                      },
                    ),
                    SizedBox(height: 10),

                    // SPD Model TextField
                    FormBuilderTextField(
                      name: 'model_SPD',
                      style: TextStyle(color: customColors.mainTextColor),

                      decoration: const InputDecoration(labelText: 'SPD Model'),
                    ),
                    SizedBox(height: 10),

                    // SPD Status Selection
                    FormBuilderChoiceChips<String>(
                      name: 'status',
                      decoration: const InputDecoration(
                        labelText: 'SPD Status',
                      ),
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: 'Active',
                          child: Text('Active'),
                          avatar: CircleAvatar(child: Text('')),
                        ),
                        FormBuilderChipOption(
                          value: 'Burned',
                          child: Text('Burned'),
                          avatar: CircleAvatar(child: Text('')),
                        ),
                      ],
                      initialValue: widget.record['status'],
                      onChanged: (val) {
                        setState(() {
                          _burned = val != 'Burned';
                        });
                      },
                    ),
                    SizedBox(height: 10),

                    // Percentage Sliders (Enable only if Active)
                    FormBuilderSlider(
                      name: 'PercentageR',
                      min: 0.0,
                      max: 100.0,
                      initialValue:
                          widget.record['PercentageR'] != null
                              ? double.tryParse(
                                    widget.record['PercentageR'].toString(),
                                  ) ??
                                  0.0
                              : 0.0,
                      divisions: 10,
                      activeColor: Colors.red,
                      inactiveColor: Colors.pink[100],
                      enabled: _burned,
                      decoration: const InputDecoration(
                        labelText: 'Percentage Level %',
                      ),
                    ),
                    SizedBox(height: 10),

                    // Nominal Voltage
                    FormBuilderTextField(
                      name: 'nom_volt',
                      style: TextStyle(color: customColors.mainTextColor),

                      decoration: const InputDecoration(
                        labelText: 'Nominal Voltage (V)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),

                    FormBuilderTextField(
                      name: 'UcDCVolt',
                      style: TextStyle(color: customColors.mainTextColor),

                      decoration: const InputDecoration(
                        labelText: 'Uc in Volt',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),

                    // Voltage Protection Level
                    FormBuilderTextField(
                      name: 'UpDCVolt',
                      style: TextStyle(color: customColors.mainTextColor),

                      decoration: const InputDecoration(
                        labelText: 'Up (DC) in kV',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),

                    // Discharge Current Rating
                    FormBuilderTextField(
                      name: 'Nom_Dis8_20',
                      style: TextStyle(color: customColors.mainTextColor),

                      decoration: const InputDecoration(
                        labelText: 'Nominal Current (In) (8/20µs) (kA)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),

                    FormBuilderTextField(
                      name: 'Nom_Dis10_350',
                      style: TextStyle(color: customColors.mainTextColor),

                      decoration: const InputDecoration(
                        labelText: 'Impulse Current (I_imp) (10/350µs) (kA)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),

                    FormBuilderTextField(
                      name: 'responseTime',
                      style: TextStyle(color: customColors.mainTextColor),

                      decoration: const InputDecoration(
                        labelText: 'Response Time (nS)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),

                    // Date Pickers
                    FormBuilderDateTimePicker(
                      name: 'installDt',
                      style: TextStyle(color: customColors.mainTextColor),

                      decoration: const InputDecoration(
                        labelText: 'Installation Date',
                      ),
                      initialValue: DateTime.tryParse(
                        widget.record['installDt'],
                      ),
                      inputType: InputType.date,
                    ),
                    SizedBox(height: 10),

                    FormBuilderDateTimePicker(
                      name: 'warrentyDt',
                      style: TextStyle(color: customColors.mainTextColor),

                      decoration: const InputDecoration(
                        labelText: 'Warranty Date',
                      ),
                      initialValue: DateTime.tryParse(
                        widget.record['warrentyDt'],
                      ),
                      inputType: InputType.date,
                    ),
                    SizedBox(height: 10),

                    // Notes
                    FormBuilderTextField(
                      name: 'Notes',
                      style: TextStyle(color: customColors.mainTextColor),

                      decoration: const InputDecoration(labelText: 'Remarks'),
                      // maxLines: 4,
                    ),
                    SizedBox(height: 10),

                    // Checkbox for verification
                    FormBuilderCheckbox(
                      name: 'accept_terms',
                      initialValue: false,
                      onChanged: (value) {
                        setState(() {
                          _isVerified = value ?? false;
                        });
                      },
                      title: Text(
                        'I verify that submitted details are true and correct',
                        style: TextStyle(color: customColors.mainTextColor),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Update Button
                    ElevatedButton(
                      onPressed:
                          _isVerified
                              ? () {
                                if (_formKey.currentState!.saveAndValidate()) {
                                  final updatedData =
                                      _formKey.currentState!.value;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => HttpUpdateSPD(
                                            updatedData: updatedData,
                                          ),
                                    ),
                                  );
                                  print('updatedData: $updatedData');
                                } else {
                                  debugPrint('Validation failed');
                                }
                              }
                              : null,
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
