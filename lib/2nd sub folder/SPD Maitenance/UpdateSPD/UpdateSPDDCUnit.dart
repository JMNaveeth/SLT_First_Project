import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
    'UVA'
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
    'Other'
  ];
  var SPDTypes = ['Type 1', 'Type1+2', 'Type 2', 'Type 3', 'Unknown'];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update DC SPD Info'),
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
                      initialValue: widget.record['SPDid'],
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'SPDid (Read-Only)',
                      ),
                    ),

                    // Region Dropdown
                    FormBuilderDropdown<String>(
                      name: 'province',
                      decoration: const InputDecoration(labelText: 'Region'),
                      items: Regions.map((region) => DropdownMenuItem(
                            value: region,
                            child: Text(region),
                          )).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRegion = value;
                        });
                      },
                    ),

                    // RTOM Dropdown
                    FormBuilderDropdown<String>(
                      name: 'Rtom_name',
                      decoration: const InputDecoration(labelText: 'RTOM'),
                      items: getRtomOptions()
                          .map((rtom) => DropdownMenuItem(
                                value: rtom,
                                child: Text(rtom),
                              ))
                          .toList(),
                    ),

                    // Station TextField
                    FormBuilderTextField(
                      name: 'station',
                      decoration: const InputDecoration(
                          labelText: 'Station (QR Code ID)'),
                    ),

                    // SPD Location
                    FormBuilderTextField(
                      name: 'SPDLoc',
                      decoration: const InputDecoration(
                          labelText: 'SPD Location (DB Location)'),
                    ),

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

                    // SPD Type Dropdown
                    FormBuilderDropdown<String>(
                      name: 'SPDType',
                      decoration: const InputDecoration(labelText: 'SPD Type'),
                      items: SPDTypes.map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          )).toList(),
                    ),

                    // Manufacturer Dropdown
                    FormBuilderDropdown<String>(
                      name: 'SPD_Manu',
                      decoration:
                          const InputDecoration(labelText: 'SPD Manufacturer'),
                      items: SPDBrands.map((brand) => DropdownMenuItem(
                            value: brand,
                            child: Text(brand),
                          )).toList(),
                    ),

                    // SPD Model TextField
                    FormBuilderTextField(
                      name: 'model_SPD',
                      decoration: const InputDecoration(labelText: 'SPD Model'),
                    ),

                    // SPD Status Selection
                    FormBuilderChoiceChips<String>(
                      name: 'status',
                      decoration:
                          const InputDecoration(labelText: 'SPD Status'),
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                            value: 'Active',
                            child: Text('Active'),
                            avatar: CircleAvatar(child: Text(''))),
                        FormBuilderChipOption(
                            value: 'Burned',
                            child: Text('Burned'),
                            avatar: CircleAvatar(child: Text(''))),
                      ],
                      initialValue: widget.record['status'],
                      onChanged: (val) {
                        setState(() {
                          _burned = val != 'Burned';
                        });
                      },
                    ),

                    // Percentage Sliders (Enable only if Active)
                    FormBuilderSlider(
                      name: 'PercentageR',
                      min: 0.0,
                      max: 100.0,
                      initialValue: widget.record['PercentageR'] != null
                          ? double.tryParse(
                                  widget.record['PercentageR'].toString()) ??
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

                    // Nominal Voltage
                    FormBuilderTextField(
                      name: 'nom_volt',
                      decoration: const InputDecoration(
                          labelText: 'Nominal Voltage (V)'),
                      keyboardType: TextInputType.number,
                    ),

                    FormBuilderTextField(
                      name: 'UcDCVolt',
                      decoration: const InputDecoration(
                        labelText: 'Uc in Volt',
                      ),
                      keyboardType: TextInputType.number,
                    ),

                    // Voltage Protection Level
                    FormBuilderTextField(
                      name: 'UpDCVolt',
                      decoration: const InputDecoration(
                        labelText: 'Up (DC) in kV',
                      ),
                      keyboardType: TextInputType.number,
                    ),

                    // Discharge Current Rating
                    FormBuilderTextField(
                      name: 'Nom_Dis8_20',
                      decoration: const InputDecoration(
                        labelText: 'Nominal Current (In) (8/20µs) (kA)',
                      ),
                      keyboardType: TextInputType.number,
                    ),

                    FormBuilderTextField(
                      name: 'Nom_Dis10_350',
                      decoration: const InputDecoration(
                        labelText: 'Impulse Current (I_imp) (10/350µs) (kA)',
                      ),
                      keyboardType: TextInputType.number,
                    ),

                    FormBuilderTextField(
                      name: 'responseTime',
                      decoration: const InputDecoration(
                        labelText: 'Response Time (nS)',
                      ),
                      keyboardType: TextInputType.number,
                    ),

                    // Date Pickers
                    FormBuilderDateTimePicker(
                      name: 'installDt',
                      decoration:
                          const InputDecoration(labelText: 'Installation Date'),
                      initialValue:
                          DateTime.tryParse(widget.record['installDt']),
                      inputType: InputType.date,
                    ),

                    FormBuilderDateTimePicker(
                      name: 'warrentyDt',
                      decoration:
                          const InputDecoration(labelText: 'Warranty Date'),
                      initialValue:
                          DateTime.tryParse(widget.record['warrentyDt']),
                      inputType: InputType.date,
                    ),

                    // Notes
                    FormBuilderTextField(
                      name: 'Notes',
                      decoration: const InputDecoration(labelText: 'Remarks'),
                      // maxLines: 4,
                    ),

                    // Checkbox for verification
                    FormBuilderCheckbox(
                      name: 'accept_terms',
                      initialValue: false,
                      onChanged: (value) {
                        setState(() {
                          _isVerified = value ?? false;
                        });
                      },
                      title: const Text(
                        'I verify that submitted details are true and correct',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),

                    // Update Button
                    ElevatedButton(
                      onPressed: _isVerified
                          ? () {
                              if (_formKey.currentState!.saveAndValidate()) {
                                final updatedData =
                                    _formKey.currentState!.value;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HttpUpdateSPD(updatedData: updatedData),
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
