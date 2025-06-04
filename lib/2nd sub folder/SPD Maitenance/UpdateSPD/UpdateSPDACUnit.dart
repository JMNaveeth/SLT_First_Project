import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';
import 'HttpUpdateSPD.dart';

class UpdateACUnit extends StatefulWidget {
  final Map<String, dynamic> record;

  const UpdateACUnit({Key? key, required this.record}) : super(key: key);

  @override
  _UpdateACUnitState createState() => _UpdateACUnitState();
}

class _UpdateACUnitState extends State<UpdateACUnit> {
  final _formKey = GlobalKey<FormBuilderState>();
  String? selectedRegion;  Map<String, dynamic> updatedValues = {};

  bool _spdUnitary = false;
  bool _3phase = false;
  bool _burned = true;
  bool _dischargeAll = false;
  bool _discharge10_350 = false;
  bool _dicharge8_20 = false;
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
    'UVA', 'Other',
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
    _spdUnitary =
        widget.record['poles'] == null || widget.record['poles'].isEmpty;
    _3phase = widget.record['phase'] == '3';
    _burned = widget.record['status'] != 'Burned';

    String dischargeType = widget.record['dischargeType'] ?? '';
    _dischargeAll = dischargeType == '8/20us+10/350us';
    _dicharge8_20 = dischargeType == '8/20us';
    _discharge10_350 = dischargeType == '10/350us';
  }


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
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: customColors.mainBackgroundColor,

      appBar: AppBar(
        title: Text(
          'Update AC SPD Info',
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
                      style: TextStyle(color: customColors.mainTextColor),
                      dropdownColor: customColors.suqarBackgroundColor,

                      decoration: const InputDecoration(labelText: 'Region'),
                      items:
                          Regions.map(
                            (region) => DropdownMenuItem(
                              value: region,
                              child: Text(region),
                            ),
                          ).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRegion = value;
                        });
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

                    // Unit Type (Modular or Unitary)
                    FormBuilderChoiceChips<String>(
                      name: 'modular',
                      decoration: const InputDecoration(labelText: 'Unit Type'),
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: 'Modular',
                          child: Text('Modular'),
                          avatar: CircleAvatar(child: Text('')),
                        ),
                        FormBuilderChipOption(
                          value: 'Unitary',
                          child: Text('Unitary'),
                          avatar: CircleAvatar(child: Text('')),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _spdUnitary = val == 'Unitary';
                        });
                      },
                    ),
                    SizedBox(height: 10),

                    // Pole Type (Enabled only if Modular is selected)
                    FormBuilderChoiceChips<String>(
                      name: 'poles',
                      decoration: const InputDecoration(labelText: 'Pole Type'),
                      selectedColor: Colors.lightBlueAccent,
                      enabled: !_spdUnitary,
                      // Disable if Unit Type is Unitary
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
                    ),
                    SizedBox(height: 10),

                    // SPD Model TextField
                    FormBuilderTextField(
                      name: 'model_SPD',
                      style: TextStyle(color: customColors.mainTextColor),

                      decoration: const InputDecoration(labelText: 'SPD Model'),
                    ),
                    SizedBox(height: 10),

                    // SPD Phase
                    FormBuilderChoiceChips<String>(
                      decoration: const InputDecoration(labelText: 'SPD Phase'),
                      name: 'phase',
                      initialValue: widget.record['phase'] ?? 'N/A',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: '1', // Single phase
                          child: Text('Phase'),
                          avatar: CircleAvatar(child: Text('1')),
                        ),
                        FormBuilderChipOption(
                          value: '3', // Three phase
                          child: Text('Phase'),
                          avatar: CircleAvatar(child: Text('3')),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _3phase = val == '1' ? false : true;
                        });
                      },
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
                        labelText: 'Percentage Level % (Phase 1)',
                      ),
                    ),
                    SizedBox(height: 10),

                    FormBuilderSlider(
                      name: 'PercentageY',
                      min: 0.0,
                      max: 100.0,
                      initialValue:
                          widget.record['PercentageY'] != null
                              ? double.tryParse(
                                    widget.record['PercentageY'].toString(),
                                  ) ??
                                  0.0
                              : 0.0,
                      divisions: 10,
                      activeColor: Colors.red,
                      inactiveColor: Colors.pink[100],
                      enabled: _burned && _3phase,
                      decoration: const InputDecoration(
                        labelText: 'Percentage Level % (Phase 2)',
                      ),
                    ),
                    SizedBox(height: 10),

                    FormBuilderSlider(
                      name: 'PercentageB',
                      min: 0.0,
                      max: 100.0,
                      initialValue:
                          widget.record['PercentageB'] != null
                              ? double.tryParse(
                                    widget.record['PercentageB'].toString(),
                                  ) ??
                                  0.0
                              : 0.0,
                      divisions: 10,
                      activeColor: Colors.red,
                      inactiveColor: Colors.pink[100],
                      enabled: _burned && _3phase,
                      decoration: const InputDecoration(
                        labelText: 'Percentage Level % (Phase 3)',
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

                    // SPD Status
                    FormBuilderChoiceChips<String>(
                      decoration: const InputDecoration(
                        labelText: 'Uc Live to neutral or Live to earth',
                      ),
                      name: 'UcLiveMode',
                      initialValue: widget.record['UcLiveMode'] ?? '',
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
                    ),
                    SizedBox(height: 10),

                    // SPD Voltage Protection Level - Live
                    FormBuilderTextField(
                      name: 'UcLiveVolt',
                      style: TextStyle(color: customColors.mainTextColor),

                      initialValue:
                          widget.record['UcLiveVolt']?.toString() ?? '',
                      decoration: const InputDecoration(
                        labelText: 'Uc (Live) in Volt',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),

                    FormBuilderTextField(
                      name: 'UcNeutralVolt',
                      style: TextStyle(color: customColors.mainTextColor),

                      initialValue:
                          widget.record['UcNeutralVolt']?.toString() ?? '',
                      decoration: const InputDecoration(
                        labelText: 'Uc (Neutral) in Volt',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),

                    FormBuilderTextField(
                      name: 'UpLiveVolt',
                      style: TextStyle(color: customColors.mainTextColor),

                      initialValue:
                          widget.record['UpLiveVolt']?.toString() ?? '',
                      decoration: const InputDecoration(
                        labelText: 'Up (Live) in Volt',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),

                    FormBuilderTextField(
                      name: 'UpNeutralVolt',
                      style: TextStyle(color: customColors.mainTextColor),

                      initialValue:
                          widget.record['UpNeutralVolt']?.toString() ?? '',
                      decoration: const InputDecoration(
                        labelText: 'Up (Neutral) in Volt',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),

                    FormBuilderChoiceChips<String>(
                      decoration: const InputDecoration(
                        labelText: 'Discharge Current Rating Types Available',
                      ),
                      name: 'dischargeType',
                      initialValue: widget.record['dischargeType'] ?? '',
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
                      onChanged: (val) {
                        setState(() {
                          _dischargeAll = val == '8/20us+10/350us';
                          _dicharge8_20 = val == '8/20us';
                          _discharge10_350 = val == '10/350us';
                        });
                      },
                    ),
                    SizedBox(height: 10),

                    // Nominal Discharge Current - Live (8/20µs)
                    FormBuilderTextField(
                      name: 'L8to20NomD',
                                                style: TextStyle(color: customColors.mainTextColor),

                      decoration: const InputDecoration(
                        labelText:
                            'Nominal Discharge Current rating (In)-Live (8/20µs) (kA)',
                      ),
                      initialValue: widget.record['L8to20NomD']?.toString(),
                      enabled: (_dischargeAll || _dicharge8_20),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),

                    // Nominal Discharge Current - Neutral (8/20µs)
                    FormBuilderTextField(
                      name: 'N8to20NomD',                          style: TextStyle(color: customColors.mainTextColor),

                      decoration: const InputDecoration(
                        labelText:
                            'Nominal Discharge Current rating (In)-Neutral (8/20µs) (kA)',
                      ),
                      initialValue: widget.record['N8to20NomD']?.toString(),
                      enabled: (_dischargeAll || _dicharge8_20),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),

                    // Impulse Discharge Current - Live (10/350µs)
                    FormBuilderTextField(
                      name: 'L10to350ImpD',                          style: TextStyle(color: customColors.mainTextColor),

                      decoration: const InputDecoration(
                        labelText:
                            'Impulse Discharge Current rating (Iimp)-Live (10/350µs) (kA)',
                      ),
                      initialValue: widget.record['L10to350ImpD']?.toString(),
                      enabled: (_dischargeAll || _discharge10_350),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),

                    // Impulse Discharge Current - Neutral (10/350µs)
                    FormBuilderTextField(
                      name: 'N10to350ImpD',                          style: TextStyle(color: customColors.mainTextColor),

                      decoration: const InputDecoration(
                        labelText:
                            'Impulse Discharge Current rating (Iimp)-Neutral (10/350µs)',
                      ),
                      initialValue: widget.record['N10to350ImpD']?.toString(),
                      enabled: (_dischargeAll || _discharge10_350),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),

                    FormBuilderTextField(
                      name: 'mcbRating',                          style: TextStyle(color: customColors.mainTextColor),

                      decoration: const InputDecoration(
                        labelText: 'Backup fuse/mcb rating (A)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),

                    FormBuilderTextField(
                      name: 'responseTime',                          style: TextStyle(color: customColors.mainTextColor),

                      decoration: const InputDecoration(
                        labelText: 'Response Time (nS)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),

                    // Date Pickers
                    FormBuilderDateTimePicker(
                      name: 'installDt',                          style: TextStyle(color: customColors.mainTextColor),

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
                      name: 'warrentyDt',                          style: TextStyle(color: customColors.mainTextColor),

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
                      name: 'Notes',                          style: TextStyle(color: customColors.mainTextColor),

                      decoration: const InputDecoration(labelText: 'Remarks'),
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
                      title:  Text(
                        'I verify that submitted details are true and correct',
                          style: TextStyle(color: customColors.mainTextColor),
                      ),
                    ),

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
