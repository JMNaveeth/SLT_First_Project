import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/widgets/gps_tag_widget.dart';

//import '../../UserAccess.dart';
import 'httpPostUPSInspection.dart';

class UPSRoutineInspection extends StatefulWidget {
  final dynamic UPSUnit;
  final String region;

  const UPSRoutineInspection({super.key, this.UPSUnit, required this.region});

  @override
  State<UPSRoutineInspection> createState() => _UPSRoutineInspectionState();
}

class _UPSRoutineInspectionState extends State<UPSRoutineInspection> {
  final _formKey = GlobalKey<FormBuilderState>();

  //locations
  var locations = [
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

  final List<String> userLocations = [
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

  //Define recForm Data map
  Map<String, dynamic> upsFormData = {'clockTime': DateTime.now(), 'shift': ""};
  String _shift = '';
  TimeOfDay? _selectedTime;

  //save data from checklist to http file
  void _onChanged(
    dynamic val,
    Map<String, dynamic> formData,
    String fieldName,
  ) {
    debugPrint(val.toString());
    debugPrint(upsFormData.toString());
    formData[fieldName] = val;
  }

  //passing data in remark
  void _onChangedRemark(dynamic val, Map<String, dynamic> formData) {
    debugPrint(val.toString());
    debugPrint(upsFormData.toString());
  }

  // Determine shift
  String _determineShift(TimeOfDay time) {
    final double hour = time.hour + time.minute / 60;
    if (hour >= 8.0 && hour < 16.0) {
      return 'Morning Shift';
    } else if (hour >= 16.0 && hour < 24.0) {
      return 'Evening Shift';
    } else {
      return 'Night Shift';
    }
  }

  // //SUBMIT FORM
  // void _submitForm() {
  //   if (_formKey.currentState!.saveAndValidate()) {
  //     // Navigate to httpMaintenancePost.dart with the form data
  //     _formKey.currentState!.save(); // Save form data
  //     debugPrint(
  //         "Form Data: ${upsFormData.toString()}"); // Debug print the form data
  //
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => httpPostRectifierInspection(
  //             formData: upsFormData, recId: widget.recId!, username: username),
  //       ),
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _selectedTime = TimeOfDay.now();
    _shift = _determineShift(_selectedTime!);
    // recFormData['shift'] = _shift;
  }

  @override
  Widget build(BuildContext context) {
    // UserAccess userAccess = Provider.of<UserAccess>
    (
      context,
      listen: true,
    ); // Use listen: true to rebuild the widget when the data changes
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: customColors.appbarColor,
          title: Text(
            "Daily Routine Checklist",
            style: TextStyle(color: customColors.mainTextColor),
          ),
          actions: [
            ThemeToggleButton(), // Use the reusable widget
          ],
          iconTheme: IconThemeData(color: customColors.mainTextColor),
        ),
        body: Container(
          // Wrap SingleChildScrollView with a Container
          color:
              customColors
                  .mainBackgroundColor, // Set your desired background color here
          child: SingleChildScrollView(
            child: FormBuilder(
              key: _formKey,
              onChanged: () {
                _formKey.currentState!.save();
                // Loop through all the fields and call _onChanged for each field
                _formKey.currentState!.fields.forEach((fieldKey, fieldState) {
                  _onChanged(fieldState.value, upsFormData, fieldKey);
                });
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "NOW ON :",
                          style: TextStyle(
                            color: customColors.mainTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: customColors.suqarBackgroundColor,
                          ),
                          child: Center(
                            child: Text(
                              _shift,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    //Location
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "LOCATION :",
                          style: TextStyle(
                            color: customColors.mainTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        Spacer(),
                        Text(
                          widget.region,
                          style: TextStyle(
                            color: customColors.mainTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Only show GPS widget if not HQ
                    ReusableGPSWidget(
                      region: widget.UPSUnit['Region'],
                      onLocationFound: (lat, lng) {
                        setState(() {
                          upsFormData['gpsLocation'] = {'lat': lat, 'lng': lng};
                        });
                        print('Got location: $lat, $lng');
                        // Save to database, use in form, etc.
                      },
                    ),

                    // FormBuilderDropdown(
                    //   name: "location",
                    //   decoration:
                    //       const InputDecoration(labelText: "Location"),
                    //   items: locations
                    //       .map((location) => DropdownMenuItem(
                    //             alignment: AlignmentDirectional.center,
                    //             value: location,
                    //             child: Text(location),
                    //           ))
                    //       .toList(),
                    //   validator: FormBuilderValidators.required(),
                    //   onChanged: (val) =>
                    //       _onChanged(val, upsFormData, "location"),
                    // ),
                    const SizedBox(height: 10),
                    Divider(),
                    const SizedBox(height: 10),
                    //Get Genaral Inspectin Date
                    const Text(
                      '01. Genaral Inspection',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    //Check ventilation of the room
                    const customText(title: "Check ventilation of the room"),
                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      name: 'ventilation',
                      initialValue: '',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: 'Ok',
                          child: Text("Ok"),
                          avatar: CircleAvatar(child: Text('O')),
                        ),
                        FormBuilderChipOption(
                          value: 'Not Ok',
                          child: Text("Not Ok"),
                          avatar: CircleAvatar(child: Text('N')),
                        ),
                      ],
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        (value) {
                          if (value == 'Not Ok' &&
                              (upsFormData['ventilationRemark'] == null ||
                                  upsFormData['ventilationRemark'].isEmpty)) {
                            return 'Remark is required when room ventilation not ok';
                          }
                          return null;
                        },
                      ]),
                      onChanged:
                          (val) => _onChanged(val, upsFormData, 'ventilation'),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "ventilationRemark",
                      formData: upsFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    ////////////////////////////////////////////////////////////////////////////////
                    //Check the battery cabinet temperature \n (20 -25 Centigrade)
                    const customText(
                      title:
                          "Check the battery cabinet temperature \n (20 -25 Centigrade)",
                    ),
                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      name: 'cabinTemp',
                      initialValue: '',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: 'Normal',
                          child: Text("Normal"),
                          avatar: CircleAvatar(child: Text('N')),
                        ),
                        FormBuilderChipOption(
                          value: 'Others',
                          child: Text("Others"),
                          avatar: CircleAvatar(child: Text('O')),
                        ),
                      ],
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        (value) {
                          if (value == 'Others' &&
                              (upsFormData['cabinTempRemark'] == null ||
                                  upsFormData['cabinTempRemark'].isEmpty)) {
                            return 'Remark is required when Cabin Temperature is not Normal';
                          }
                          return null;
                        },
                      ]),
                      onChanged:
                          (val) => _onChanged(val, upsFormData, 'cabinTemp'),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "cabinTempRemark",
                      formData: upsFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    //Measure Hidrogen gas emmision
                    const customText(title: "Measure Hidrogen gas emmision"),
                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      name: 'h2GasEmission',
                      initialValue: '',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: 'Yes',
                          child: Text("Yes"),
                          avatar: CircleAvatar(child: Text('Y')),
                        ),
                        FormBuilderChipOption(
                          value: 'No',
                          child: Text("No"),
                          avatar: CircleAvatar(child: Text('N')),
                        ),
                      ],
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        (value) {
                          if (value == 'Yes' &&
                              (upsFormData['h2GasEmissionRemark'] == null ||
                                  upsFormData['h2GasEmissionRemark'].isEmpty)) {
                            return 'Remark is required when the Hidrogen gas Emission';
                          }
                          return null;
                        },
                      ]),
                      onChanged:
                          (val) =>
                              _onChanged(val, upsFormData, 'h2GasEmission'),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "h2GasEmissionRemark",
                      formData: upsFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    ///////////////////////////////////////////////////////////////////////////////////////////
                    //Keep UPS free and clean of any dust
                    const customText(
                      title: "Keep UPS free and clean of any dust",
                    ),
                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // decoration: const InputDecoration(
                      //     labelText: 'Measure Hydrogen Gas Emmission'),
                      name: 'dust',
                      initialValue: '',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: 'Ok',
                          child: Text("Ok"),
                          avatar: CircleAvatar(child: Text('O')),
                        ),
                        FormBuilderChipOption(
                          value: 'Not Ok',
                          child: Text("Not Ok"),
                          avatar: CircleAvatar(child: Text('N')),
                        ),
                      ],
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        (value) {
                          if (value == 'Not Ok' &&
                              (upsFormData['dustRemark'] == null ||
                                  upsFormData['dustRemark'].isEmpty)) {
                            return 'Remark is required when the Not ok the free and clean of dusk';
                          }
                          return null;
                        },
                      ]),
                      onChanged: (val) => _onChanged(val, upsFormData, 'dust'),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "dustRemark",
                      formData: upsFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),
                    const SizedBox(height: 10),
                    Divider(),
                    const SizedBox(height: 10),

                    ////////////////////////////////////////////////////////////////////////////////////////
                    //Battery Inspectin
                    const Text(
                      '02. Battery Inspection',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //Check Cheanliness
                    const customText(title: "Check Cheanliness"),
                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // decoration: const InputDecoration(
                      //     labelText: 'Check Main Circuit Breakers'),
                      name: 'batClean',
                      initialValue: '',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: 'Ok',
                          child: Text("ok"),
                          avatar: CircleAvatar(child: Text('O')),
                        ),
                        FormBuilderChipOption(
                          value: 'Not Ok',
                          child: Text("Not ok"),
                          avatar: CircleAvatar(child: Text('N')),
                        ),
                      ],
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        (value) {
                          if (value == 'Not Ok' &&
                              (upsFormData['batCleanRemark'] == null ||
                                  upsFormData['batCleanRemark'].isEmpty)) {
                            return 'Remark is required when battery is not clean';
                          }
                          return null;
                        },
                      ]),
                      onChanged: (val) {
                        _onChanged(val, upsFormData, 'batClean');
                        _formKey.currentState?.validate();
                      },
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "batCleanRemark",
                      formData: upsFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    ///////////////////////////////////////////////////////////////////////////////////
                    //Check terminal voltage
                    const customText(title: "Check terminal voltage"),
                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // decoration: const InputDecoration(labelText: 'DC PDB'),
                      name: 'trmVolt',
                      initialValue: '',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: 'ok',
                          child: Text("ok"),
                          avatar: CircleAvatar(child: Text('O')),
                        ),
                        FormBuilderChipOption(
                          value: 'Not Ok',
                          child: Text("Not ok"),
                          avatar: CircleAvatar(child: Text('N')),
                        ),
                      ],
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        (value) {
                          if (value == 'Not Ok' &&
                              (upsFormData['trmVoltRemark'] == null ||
                                  upsFormData['trmVoltRemark'].isEmpty)) {
                            return 'Remark is required when Terminal Voltage Not ok';
                          }
                          return null;
                        },
                      ]),

                      onChanged: (val) => _onChanged(val, upsFormData, 'dcPDB'),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "trmVoltRemark",
                      formData: upsFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    ////////////////////////////////////////////////////////////////////////////////////////////
                    //Check for any leakages
                    const customText(title: "Check for any leakages"),
                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // decoration:
                      //     const InputDecoration(labelText: 'Test Remort Alarm'),
                      name: 'leak',
                      initialValue: '',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: 'Yes',
                          child: Text("Yes"),
                          avatar: CircleAvatar(child: Text('Y')),
                        ),
                        FormBuilderChipOption(
                          value: 'No',
                          child: Text("No"),
                          avatar: CircleAvatar(child: Text('N')),
                        ),
                      ],
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        (value) {
                          if (value == 'Yes' &&
                              (upsFormData['leakRemark'] == null ||
                                  upsFormData['leakRemark'].isEmpty)) {
                            return 'Remark is required when the any Leakage ';
                          }
                          return null;
                        },
                      ]),
                      onChanged: (val) => _onChanged(val, upsFormData, 'leak'),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "leakRemark",
                      formData: upsFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),
                    const SizedBox(height: 10),
                    Divider(),
                    const SizedBox(height: 10),

                    //Get Genaral Inspectin Date
                    const Text(
                      '03. Daily inspection of the UPS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    //MIMIC LED
                    const customText(title: "Mimic LED indications"),
                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      name: 'mimicLED',
                      initialValue: '',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: 'Work',
                          child: Text("Working"),
                          avatar: CircleAvatar(child: Text('W')),
                        ),
                        FormBuilderChipOption(
                          value: 'Not Work',
                          child: Text("Not Working"),
                          avatar: CircleAvatar(child: Text('N')),
                        ),
                      ],
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        (value) {
                          if (value == 'Not Work' &&
                              (upsFormData['mimicLEDRemark'] == null ||
                                  upsFormData['mimicLEDRemark'].isEmpty)) {
                            return 'Remark is required when the LED indications not working';
                          }
                          return null;
                        },
                      ]),
                      onChanged:
                          (val) => _onChanged(val, upsFormData, 'mimicLED'),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "mimicLEDRemark",
                      formData: upsFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    ////////////////////////////////////////////////////////////////////////////////
                    //All metered parameters
                    const customText(title: "All metered parameters"),
                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      name: 'meterPara',
                      initialValue: '',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: 'Ok',
                          child: Text("Ok"),
                          avatar: CircleAvatar(child: Text('O')),
                        ),
                        FormBuilderChipOption(
                          value: 'Not Ok',
                          child: Text("Not Ok"),
                          avatar: CircleAvatar(child: Text('N')),
                        ),
                      ],
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        (value) {
                          if (value == 'Not Ok' &&
                              (upsFormData['meterParaRemark'] == null ||
                                  upsFormData['meterParaRemark'].isEmpty)) {
                            return 'Remark is required when the parameters are not ok';
                          }
                          return null;
                        },
                      ]),
                      onChanged:
                          (val) => _onChanged(val, upsFormData, 'meterPara'),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "meterParaRemark",
                      formData: upsFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    //////////////////////////////////////////////////////////////////////////////////
                    //Warning or Alarm massages
                    const customText(title: "Warning or Alarm massages"),
                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // decoration: const InputDecoration(
                      //     labelText: 'Measure Room Temperature'),
                      name: 'warningAlarm',
                      initialValue: '',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: 'Yes',
                          child: Text("Yes"),
                          avatar: CircleAvatar(child: Text('Y')),
                        ),
                        FormBuilderChipOption(
                          value: 'No',
                          child: Text("No"),
                          avatar: CircleAvatar(child: Text('N')),
                        ),
                      ],
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        (value) {
                          if (value == 'Yes' &&
                              (upsFormData['warningAlarmRemark'] == null ||
                                  upsFormData['warningAlarmRemark'].isEmpty)) {
                            return 'Remark is required when show the  warning or Alarm Massage';
                          }
                          return null;
                        },
                      ]),
                      onChanged:
                          (val) => _onChanged(val, upsFormData, 'warningAlarm'),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "warningAlarmRemark",
                      formData: upsFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    ///////////////////////////////////////////////////////////////////////////////////////////
                    //Signs of Overheating
                    const customText(title: "Signs of Overheating"),
                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      name: 'overHeat',
                      initialValue: '',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: 'Yes',
                          child: Text("Yes"),
                          avatar: CircleAvatar(child: Text('Y')),
                        ),
                        FormBuilderChipOption(
                          value: 'No',
                          child: Text("No"),
                          avatar: CircleAvatar(child: Text('N')),
                        ),
                      ],
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        (value) {
                          if (value == 'Yes' &&
                              (upsFormData['overHeatRemark'] == null ||
                                  upsFormData['overHeatRemark'].isEmpty)) {
                            return 'Remark is required when see the Signs of Over Heating';
                          }
                          return null;
                        },
                      ]),
                      onChanged:
                          (val) =>
                              _onChanged(val, upsFormData, 'h2gasEmission'),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "overHeatRemark",
                      formData: upsFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    const SizedBox(height: 10),
                    Divider(),
                    const SizedBox(height: 10),

                    const Text(
                      '04. UPS Reading',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    //volatge Reading
                    const Text(
                      ' Voltage Measuremen',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: FormBuilderTextField(
                                  name: 'voltagePs1',
                                  style: TextStyle(
                                    color: customColors.mainTextColor,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Phase 1",
                                    suffixText: "V",
                                    suffixStyle: TextStyle(
                                      color: customColors.mainTextColor
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onChanged: (val) {
                                    print(
                                      val,
                                    ); // Print the text value write into TextField
                                    _onChanged(val, upsFormData, 'voltagePs1');
                                  },
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.numeric(
                                      errorText: "Value must be \n numeric",
                                    ),
                                    FormBuilderValidators.max(
                                      1000,
                                      inclusive: false,
                                      errorText:
                                          "Value should be \n less than 1000",
                                    ),
                                    (val) {
                                      if (val == null || val.isEmpty)
                                        return null;
                                      final number = num.tryParse(val);
                                      if (number == null)
                                        return 'Must be a number';
                                      return null;
                                    },
                                  ]),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ), // Add spacing between the text fields
                              Expanded(
                                child: FormBuilderTextField(
                                  name: 'voltagePs2',

                                  style: TextStyle(
                                    color: customColors.mainTextColor,
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    labelText: "Phase 2",
                                    suffixText: "V",

                                    suffixStyle: TextStyle(
                                      color: customColors.mainTextColor
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    print(
                                      val,
                                    ); // Print the text value write into TextField
                                    _onChanged(val, upsFormData, 'voltagePs2');
                                  },
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.numeric(
                                      errorText: "Value must be \n numeric",
                                    ),
                                    FormBuilderValidators.max(
                                      1000,
                                      inclusive: false,
                                      errorText:
                                          "Value should be \n less than 1000",
                                    ),
                                    (val) {
                                      if (val == null || val.isEmpty)
                                        return null;
                                      final number = num.tryParse(val);
                                      if (number == null)
                                        return 'Must be a number';
                                      return null;
                                    },
                                  ]),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ), // Add spacing between the text fields
                              Expanded(
                                child: FormBuilderTextField(
                                  name: 'voltagePs3',
                                  style: TextStyle(
                                    color: customColors.mainTextColor,
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    labelText: "Phase 3",
                                    suffixText: "V",
                                    suffixStyle: TextStyle(
                                      color: customColors.mainTextColor
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    print(
                                      val,
                                    ); // Print the text value write into TextField
                                    _onChanged(val, upsFormData, 'voltagePs3');
                                  },
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.numeric(
                                      errorText: "Value must be \n numeric",
                                    ),
                                    FormBuilderValidators.max(
                                      1000,
                                      inclusive: false,
                                      errorText:
                                          "Value should be \n less than 1000",
                                    ),
                                    (val) {
                                      if (val == null || val.isEmpty)
                                        return null;
                                      final number = num.tryParse(val);
                                      if (number == null)
                                        return 'Must be a number';
                                      return null;
                                    },
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    ///Curren Reading
                    const Text(
                      'Current Measurements ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: FormBuilderTextField(
                                  name: 'currentPs1',
                                  style: TextStyle(
                                    color: customColors.mainTextColor,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Phase 1",
                                    suffixText: "A",
                                    suffixStyle: TextStyle(
                                      color: customColors.mainTextColor
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onChanged: (val) {
                                    print(
                                      val,
                                    ); // Print the text value write into TextField
                                    _onChanged(val, upsFormData, 'currentPs1');
                                  },
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.numeric(
                                      errorText: "Value must be \n numeric",
                                    ),
                                    FormBuilderValidators.max(
                                      10000,
                                      inclusive: false,
                                      errorText:
                                          "Value should be \n less than 10000",
                                    ),
                                    (val) {
                                      if (val == null || val.isEmpty)
                                        return null;
                                      final number = num.tryParse(val);
                                      if (number == null)
                                        return 'Must be a number';
                                      return null;
                                    },
                                  ]),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ), // Add spacing between the text fields
                              Expanded(
                                child: FormBuilderTextField(
                                  name: 'currentPs2',
                                  style: TextStyle(
                                    color: customColors.mainTextColor,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Phase 2",
                                    suffixText: "A",
                                    suffixStyle: TextStyle(
                                      color: customColors.mainTextColor
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    print(
                                      val,
                                    ); // Print the text value write into TextField
                                    _onChanged(val, upsFormData, 'currentPs2');
                                  },
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.numeric(
                                      errorText: "Value must be \n numeric",
                                    ),
                                    FormBuilderValidators.max(
                                      10000,
                                      inclusive: false,
                                      errorText:
                                          "Value should be  \n less than 10000",
                                    ),
                                    (val) {
                                      if (val == null || val.isEmpty)
                                        return null;
                                      final number = num.tryParse(val);
                                      if (number == null)
                                        return 'Must be a number';
                                      return null;
                                    },
                                  ]),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ), // Add spacing between the text fields
                              Expanded(
                                child: FormBuilderTextField(
                                  name: 'currentPs3',
                                  style: TextStyle(
                                    color: customColors.mainTextColor,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Phase 3",
                                    suffixText: "A",
                                    suffixStyle: TextStyle(
                                      color: customColors.mainTextColor
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    print(
                                      val,
                                    ); // Print the text value write into TextField
                                    _onChanged(val, upsFormData, 'currentPs3');
                                  },
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.numeric(
                                      errorText: "Value must be \n numeric",
                                    ),
                                    FormBuilderValidators.max(
                                      10000,
                                      inclusive: false,
                                      errorText:
                                          "Value should be \n less than 10000",
                                    ),
                                    (val) {
                                      if (val == null || val.isEmpty)
                                        return null;
                                      final number = num.tryParse(val);
                                      if (number == null)
                                        return 'Must be a number';
                                      return null;
                                    },
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    const SizedBox(height: 15),

                    ///capacity
                    const Text(
                      'Capacity (A)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          FormBuilderTextField(
                            name: 'upsCapacity',
                            style: TextStyle(color: customColors.mainTextColor),

                            decoration: InputDecoration(
                              labelText: "Capacity",
                              suffixText: "A",
                              suffixStyle: TextStyle(
                                color: customColors.mainTextColor.withOpacity(
                                  0.7,
                                ),
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (val) {
                              print(
                                val,
                              ); // Print the text value write into TextField
                              _onChanged(val, upsFormData, 'upsCapacity');
                            },
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.numeric(),
                              FormBuilderValidators.max(100, inclusive: true),
                              (val) {
                                if (val == null || val.isEmpty) return null;
                                final number = num.tryParse(val);
                                if (number == null) return 'Must be a number';
                                return null;
                              },
                            ]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Divider(),
                    const SizedBox(height: 10),
                    const Text(
                      'Additional Remark :',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          FormBuilderTextField(
                            name: 'addiRemark',
                            style: TextStyle(color: customColors.mainTextColor),

                            decoration: InputDecoration(
                              labelText: "Additional Remarks",
                            ),
                            textInputAction: TextInputAction.done,
                            onChanged: (val) {
                              print(
                                val,
                              ); // Print the text value write into TextField
                              setState(() {
                                upsFormData['addiRemark'] = val;
                              });
                            },
                            validator: FormBuilderValidators.compose([]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    ///////////////////////////////////////////////////////////
                    FormBuilderCheckbox(
                      name: 'accept_terms',
                      initialValue: false,
                      onChanged:
                          (value) =>
                              _onChanged(value, upsFormData, 'accept_terms'),
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
                              // GPS required check
                              if (ReusableGPSWidget.isGPSRequiredAndMissing(
                                context: context,
                                region: widget.UPSUnit['Region'],
                                formData: upsFormData,
                              )) {
                                return;
                              }
                              if (_formKey.currentState?.saveAndValidate() ??
                                  false) {
                                _formKey.currentState!.save(); // Save form data
                                debugPrint(
                                  _formKey.currentState?.value.toString(),
                                );
                                Map<String, dynamic>? formData =
                                    _formKey.currentState?.value;
                                formData = formData?.map(
                                  (key, value) => MapEntry(key, value ?? ''),
                                );

                                // // Add latitude and longitude to upsFormData if GPS is present
                                // if (upsFormData['gpsLocation'] != null) {
                                //   upsFormData['latitude'] =
                                //       upsFormData['gpsLocation']['lat'];
                                //   upsFormData['longitude'] =
                                //       upsFormData['gpsLocation']['lng'];
                                // }
                                // String rtom = _formKey.currentState?.value['Rtom_name'];
                                // debugPrint('RTOM value: $rtom');
                                //pass _formkey.currenState.value to a page called httpPostGen

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => httpPostUPSInspection(
                                          formData: upsFormData,
                                          recId: widget.UPSUnit['upsID'],
                                          //  userAccess: userAccess,
                                          region: widget.region,
                                        ),
                                  ),
                                );
                              } else {
                                debugPrint(
                                  _formKey.currentState?.value.toString(),
                                );
                                debugPrint('validation failed');
                              }
                            },
                            style: buttonStyle(),
                            child: const Text('Submit'),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

ButtonStyle buttonStyle() {
  return ElevatedButton.styleFrom();
}

/////////////////////////////////////////////////////////////////////////////////////////
///custom remark widget
class CustomRemarkWidget extends StatefulWidget {
  final String title;
  final String formDataKey;
  final Map<String, dynamic> formData;
  final GlobalKey<FormBuilderState> formKey;
  final void Function(Map<String, dynamic>, Map<String, dynamic>)
  onChangedRemark;

  CustomRemarkWidget({
    required this.title,
    required this.formDataKey,
    required this.formData,
    required this.formKey,
    required this.onChangedRemark,
  });

  @override
  _CustomRemarkWidgetState createState() => _CustomRemarkWidgetState();
}

class _CustomRemarkWidgetState extends State<CustomRemarkWidget> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${widget.title}: ${widget.formData[widget.formDataKey] ?? ""}',
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            _textEditingController.text =
                widget.formData[widget.formDataKey] ?? "";
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Add ${widget.title}'),
                  content: FormBuilderTextField(
                    name: widget.formDataKey,
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Enter ${widget.title}',
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        widget.formKey.currentState!.save(); // Save form data
                        setState(() {
                          widget.formData[widget.formDataKey] =
                              _textEditingController.text;
                        });
                        widget.onChangedRemark(
                          widget.formKey.currentState!.value,
                          widget.formData,
                        );

                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          icon: Icon(Icons.add, color: Colors.black),
          label: Text(
            'Remarks',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

//custom Text
class customText extends StatelessWidget {
  final String title;
  const customText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final customColors =
        Theme.of(
          context,
        ).extension<CustomColors>()!; // Access CustomColors from the theme

    return Text(
      title,
      style: TextStyle(
        color: customColors.mainTextColor,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

//v1 01-07-2024
// import 'package:flutter/material.dart';
//
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:provider/provider.dart';
//
// import '../../UserAccess.dart';
// import '../../Rectifier/RectifierRoutineInspection/httpPostRectifierInspection.dart';
// import 'httpPostUPSInspection.dart';
//
//
// class UPSRoutineInspection extends StatefulWidget {
//   final dynamic UPSUnit;
//
//   const UPSRoutineInspection({
//     super.key,
//     this.UPSUnit,
//   });
//
//   @override
//   State<UPSRoutineInspection> createState() => _UPSRoutineInspectionState();
// }
//
// class _UPSRoutineInspectionState extends State<UPSRoutineInspection> {
//   final _formKey = GlobalKey<FormBuilderState>();
//
//   //locations
//   var locations = [
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
//
//   //Define recForm Data map
//   Map<String, dynamic> upsFormData = {
//     'clockTime': DateTime.now(),
//     'shift': "",
//   };
//   String _shift = '';
//   TimeOfDay? _selectedTime;
//
//   //save data from checklist to http file
//   void _onChanged(
//       dynamic val, Map<String, dynamic> formData, String fieldName) {
//     debugPrint(val.toString());
//     debugPrint(upsFormData.toString());
//     formData[fieldName] = val;
//   }
//
//   //passing data in remark
//   void _onChangedRemark(dynamic val, Map<String, dynamic> formData) {
//     debugPrint(val.toString());
//     debugPrint(upsFormData.toString());
//   }
//
// // Determine shift
//   String _determineShift(TimeOfDay time) {
//     final double hour = time.hour + time.minute / 60;
//     if (hour >= 8.0 && hour < 16.0) {
//       return 'Morning Shift';
//     } else if (hour >= 16.0 && hour < 24.0) {
//       return 'Evening Shift';
//     } else {
//       return 'Night Shift';
//     }
//   }
//
//   // //SUBMIT FORM
//   // void _submitForm() {
//   //   if (_formKey.currentState!.saveAndValidate()) {
//   //     // Navigate to httpMaintenancePost.dart with the form data
//   //     _formKey.currentState!.save(); // Save form data
//   //     debugPrint(
//   //         "Form Data: ${upsFormData.toString()}"); // Debug print the form data
//   //
//   //     Navigator.push(
//   //       context,
//   //       MaterialPageRoute(
//   //         builder: (context) => httpPostRectifierInspection(
//   //             formData: upsFormData, recId: widget.recId!, username: username),
//   //       ),
//   //     );
//   //   }
//   // }
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedTime = TimeOfDay.now();
//     _shift = _determineShift(_selectedTime!);
//     // recFormData['shift'] = _shift;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     UserAccess userAccess = Provider.of<UserAccess>(context, listen: true); // Use listen: true to rebuild the widget when the data changes
//
//     return SafeArea(
//         child: Scaffold(
//       appBar: AppBar(
//         title: const Text("Daily Routing Checklist"),
//       ),
//       body: SingleChildScrollView(
//         child: FormBuilder(
//             key: _formKey,
//             onChanged: () {
//               _formKey.currentState!.save();
//               // Loop through all the fields and call _onChanged for each field
//               _formKey.currentState!.fields.forEach((fieldKey, fieldState) {
//                 _onChanged(fieldState.value, upsFormData, fieldKey);
//               });
//             },
//             child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             "NOW ON :",
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 15),
//                           ),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.1,
//                           ),
//                           Container(
//                             width: MediaQuery.of(context).size.width * 0.6,
//                             height: 30,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color: Colors.grey.shade300),
//                             child: Center(
//                               child: Text(
//                                 _shift,
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 15),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//
//                       //Location
//
//                       FormBuilderDropdown(
//                         name: "location",
//                         decoration:
//                             const InputDecoration(labelText: "Location"),
//                         items: locations
//                             .map((location) => DropdownMenuItem(
//                                   alignment: AlignmentDirectional.center,
//                                   value: location,
//                                   child: Text(location),
//                                 ))
//                             .toList(),
//                         validator: FormBuilderValidators.required(),
//                         onChanged: (val) =>
//                             _onChanged(val, upsFormData, "location"),
//                       ),
//
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Divider(),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       //Get Genaral Inspectin Date
//                       const Text('01. Genaral Inspection',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           )),
//
//                       //Check ventilation of the room
//
//                       const customText(
//                         title: "Check ventilation of the room",
//                       ),
//                       FormBuilderChoiceChip<String>(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         name: 'ventilation',
//                         initialValue: '',
//                         selectedColor: Colors.lightBlueAccent,
//                         options: const [
//                           FormBuilderChipOption(
//                             value: 'Ok',
//                             child: Text("Ok"),
//                             avatar: CircleAvatar(child: Text('O')),
//                           ),
//                           FormBuilderChipOption(
//                             value: 'Not Ok',
//                             child: Text("Not Ok"),
//                             avatar: CircleAvatar(child: Text('N')),
//                           ),
//                         ],
//                         validator: FormBuilderValidators.compose([
//                           FormBuilderValidators.required(),
//                           (value) {
//                             if (value == 'Not Ok' &&
//                                 (upsFormData['ventilationRemark'] == null ||
//                                     upsFormData['ventilationRemark'].isEmpty)) {
//                               return 'Remark is required when room ventilation not ok';
//                             }
//                             return null;
//                           },
//                         ]),
//                         onChanged: (val) =>
//                             _onChanged(val, upsFormData, 'ventilation'),
//                       ),
//                       CustomRemarkWidget(
//                           title: "Remark",
//                           formDataKey: "ventilationRemark",
//                           formData: upsFormData,
//                           formKey: _formKey,
//                           onChangedRemark: (p0, p1) {
//                             _onChangedRemark(p0, p1);
//                             _formKey.currentState?.validate();
//                           }),
//
//                       ////////////////////////////////////////////////////////////////////////////////
//                       //Check the battery cabinet temperature \n (20 -25 Centigrade)
//                       const customText(
//                           title:
//                               "Check the battery cabinet temperature \n (20 -25 Centigrade)"),
//                       FormBuilderChoiceChip<String>(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         name: 'cabinTemp',
//                         initialValue: '',
//                         selectedColor: Colors.lightBlueAccent,
//                         options: const [
//                           FormBuilderChipOption(
//                             value: 'Normal',
//                             child: Text("Normal"),
//                             avatar: CircleAvatar(child: Text('N')),
//                           ),
//                           FormBuilderChipOption(
//                             value: 'Others',
//                             child: Text("Others"),
//                             avatar: CircleAvatar(child: Text('O')),
//                           ),
//                         ],
//                         validator: FormBuilderValidators.compose([
//                           FormBuilderValidators.required(),
//                           (value) {
//                             if (value == 'Others' &&
//                                 (upsFormData['cabinTempRemark'] == null ||
//                                     upsFormData['cabinTempRemark'].isEmpty)) {
//                               return 'Remark is required when Cabin Temperature is not Normal';
//                             }
//                             return null;
//                           },
//                         ]),
//                         onChanged: (val) =>
//                             _onChanged(val, upsFormData, 'cabinTemp'),
//                       ),
//                       CustomRemarkWidget(
//                           title: "Remark",
//                           formDataKey: "cabinTempRemark",
//                           formData: upsFormData,
//                           formKey: _formKey,
//                           onChangedRemark: (p0, p1) {
//                             _onChangedRemark(p0, p1);
//                             _formKey.currentState?.validate();
//                           }),
//
//                       //Measure Hidrogen gas emmision
//                       const customText(title: "Measure Hidrogen gas emmision"),
//                       FormBuilderChoiceChip<String>(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         name: 'h2GasEmission',
//                         initialValue: '',
//                         selectedColor: Colors.lightBlueAccent,
//                         options: const [
//                           FormBuilderChipOption(
//                             value: 'Yes',
//                             child: Text("Yes"),
//                             avatar: CircleAvatar(child: Text('Y')),
//                           ),
//                           FormBuilderChipOption(
//                             value: 'No',
//                             child: Text("No"),
//                             avatar: CircleAvatar(child: Text('N')),
//                           ),
//                         ],
//                         validator: FormBuilderValidators.compose([
//                           FormBuilderValidators.required(),
//                           (value) {
//                             if (value == 'Yes' &&
//                                 (upsFormData['h2GasEmissionRemark'] == null ||
//                                     upsFormData['h2GasEmissionRemark']
//                                         .isEmpty)) {
//                               return 'Remark is required when the Hidrogen gas Emission';
//                             }
//                             return null;
//                           },
//                         ]),
//                         onChanged: (val) =>
//                             _onChanged(val, upsFormData, 'h2GasEmission'),
//                       ),
//                       CustomRemarkWidget(
//                           title: "Remark",
//                           formDataKey: "h2GasEmissionRemark",
//                           formData: upsFormData,
//                           formKey: _formKey,
//                           onChangedRemark: (p0, p1) {
//                             _onChangedRemark(p0, p1);
//                             _formKey.currentState?.validate();
//                           }),
//
//                       ///////////////////////////////////////////////////////////////////////////////////////////
//                       //Keep UPS free and clean of any dust
//                       const customText(
//                           title: "Keep UPS free and clean of any dust"),
//                       FormBuilderChoiceChip<String>(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         // decoration: const InputDecoration(
//                         //     labelText: 'Measure Hydrogen Gas Emmission'),
//                         name: 'dust',
//                         initialValue: '',
//                         selectedColor: Colors.lightBlueAccent,
//                         options: const [
//                           FormBuilderChipOption(
//                             value: 'Ok',
//                             child: Text("Ok"),
//                             avatar: CircleAvatar(child: Text('O')),
//                           ),
//                           FormBuilderChipOption(
//                             value: 'Not Ok',
//                             child: Text("Not Ok"),
//                             avatar: CircleAvatar(child: Text('N')),
//                           ),
//                         ],
//                         validator: FormBuilderValidators.compose([
//                           FormBuilderValidators.required(),
//                           (value) {
//                             if (value == 'Not Ok' &&
//                                 (upsFormData['dustRemark'] == null ||
//                                     upsFormData['dustRemark'].isEmpty)) {
//                               return 'Remark is required when the Not ok the free and clean of dusk';
//                             }
//                             return null;
//                           },
//                         ]),
//                         onChanged: (val) =>
//                             _onChanged(val, upsFormData, 'dust'),
//                       ),
//                       CustomRemarkWidget(
//                           title: "Remark",
//                           formDataKey: "dustRemark",
//                           formData: upsFormData,
//                           formKey: _formKey,
//                           onChangedRemark: (p0, p1) {
//                             _onChangedRemark(p0, p1);
//                             _formKey.currentState?.validate();
//                           }),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Divider(),
//                       const SizedBox(
//                         height: 10,
//                       ),
//
// ////////////////////////////////////////////////////////////////////////////////////////
//                       //Battery Inspectin
//                       const Text('02. Battery Inspection',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           )),
//                       //Check Cheanliness
//                       const customText(title: "Check Cheanliness"),
//                       FormBuilderChoiceChip<String>(
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           // decoration: const InputDecoration(
//                           //     labelText: 'Check Main Circuit Breakers'),
//                           name: 'batClean',
//                           initialValue: '',
//                           selectedColor: Colors.lightBlueAccent,
//                           options: const [
//                             FormBuilderChipOption(
//                               value: 'Ok',
//                               child: Text("ok"),
//                               avatar: CircleAvatar(child: Text('O')),
//                             ),
//                             FormBuilderChipOption(
//                               value: 'Not Ok',
//                               child: Text("Not ok"),
//                               avatar: CircleAvatar(child: Text('N')),
//                             ),
//                           ],
//                           validator: FormBuilderValidators.compose([
//                             FormBuilderValidators.required(),
//                             (value) {
//                               if (value == 'Not Ok' &&
//                                   (upsFormData['batCleanRemark'] == null ||
//                                       upsFormData['batCleanRemark'].isEmpty)) {
//                                 return 'Remark is required when battery is not clean';
//                               }
//                               return null;
//                             },
//                           ]),
//                           onChanged: (val) {
//                             _onChanged(val, upsFormData, 'batClean');
//                             _formKey.currentState?.validate();
//                           }),
//                       CustomRemarkWidget(
//                           title: "Remark",
//                           formDataKey: "batCleanRemark",
//                           formData: upsFormData,
//                           formKey: _formKey,
//                           onChangedRemark: (p0, p1) {
//                             _onChangedRemark(p0, p1);
//                             _formKey.currentState?.validate();
//                           }),
//
// ///////////////////////////////////////////////////////////////////////////////////
//                       //Check terminal voltage
//                       const customText(title: "Check terminal voltage"),
//                       FormBuilderChoiceChip<String>(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         // decoration: const InputDecoration(labelText: 'DC PDB'),
//                         name: 'trmVolt',
//                         initialValue: '',
//                         selectedColor: Colors.lightBlueAccent,
//                         options: const [
//                           FormBuilderChipOption(
//                             value: 'ok',
//                             child: Text("ok"),
//                             avatar: CircleAvatar(child: Text('O')),
//                           ),
//                           FormBuilderChipOption(
//                             value: 'Not Ok',
//                             child: Text("Not ok"),
//                             avatar: CircleAvatar(child: Text('N')),
//                           ),
//                         ],
//                         validator: FormBuilderValidators.compose([
//                           FormBuilderValidators.required(),
//                           (value) {
//                             if (value == 'Not Ok' &&
//                                 (upsFormData['trmVoltRemark'] == null ||
//                                     upsFormData['trmVoltRemark'].isEmpty)) {
//                               return 'Remark is required when Terminal Voltage Not ok';
//                             }
//                             return null;
//                           },
//                         ]),
//
//                         onChanged: (val) =>
//                             _onChanged(val, upsFormData, 'dcPDB'),
//                       ),
//                       CustomRemarkWidget(
//                           title: "Remark",
//                           formDataKey: "trmVoltRemark",
//                           formData: upsFormData,
//                           formKey: _formKey,
//                           onChangedRemark: (p0, p1) {
//                             _onChangedRemark(p0, p1);
//                             _formKey.currentState?.validate();
//                           }),
//
// ////////////////////////////////////////////////////////////////////////////////////////////
//                       //Check for any leakages
//                       const customText(title: "Check for any leakages"),
//                       FormBuilderChoiceChip<String>(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         // decoration:
//                         //     const InputDecoration(labelText: 'Test Remort Alarm'),
//                         name: 'leak',
//                         initialValue: '',
//                         selectedColor: Colors.lightBlueAccent,
//                         options: const [
//                           FormBuilderChipOption(
//                             value: 'Yes',
//                             child: Text("Yes"),
//                             avatar: CircleAvatar(child: Text('Y')),
//                           ),
//                           FormBuilderChipOption(
//                             value: 'No',
//                             child: Text("No"),
//                             avatar: CircleAvatar(child: Text('N')),
//                           ),
//                         ],
//                         validator: FormBuilderValidators.compose([
//                           FormBuilderValidators.required(),
//                           (value) {
//                             if (value == 'Yes' &&
//                                 (upsFormData['leakRemark'] == null ||
//                                     upsFormData['leakRemark'].isEmpty)) {
//                               return 'Remark is required when the any Leakage ';
//                             }
//                             return null;
//                           },
//                         ]),
//                         onChanged: (val) =>
//                             _onChanged(val, upsFormData, 'leak'),
//                       ),
//                       CustomRemarkWidget(
//                           title: "Remark",
//                           formDataKey: "leakRemark",
//                           formData: upsFormData,
//                           formKey: _formKey,
//                           onChangedRemark: (p0, p1) {
//                             _onChangedRemark(p0, p1);
//                             _formKey.currentState?.validate();
//                           }),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Divider(),
//                       const SizedBox(
//                         height: 10,
//                       ),
//
//                       //Get Genaral Inspectin Date
//                       const Text('03. Daily inspection of the UPS',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           )),
//
//                       //MIMIC LED
//                       const customText(
//                         title: "Mimic LED indications",
//                       ),
//                       FormBuilderChoiceChip<String>(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         name: 'mimicLED',
//                         initialValue: '',
//                         selectedColor: Colors.lightBlueAccent,
//                         options: const [
//                           FormBuilderChipOption(
//                             value: 'Work',
//                             child: Text("Working"),
//                             avatar: CircleAvatar(child: Text('W')),
//                           ),
//                           FormBuilderChipOption(
//                             value: 'Not Work',
//                             child: Text("Not Working"),
//                             avatar: CircleAvatar(child: Text('N')),
//                           ),
//                         ],
//                         validator: FormBuilderValidators.compose([
//                           FormBuilderValidators.required(),
//                           (value) {
//                             if (value == 'Not Work' &&
//                                 (upsFormData['mimicLEDRemark'] == null ||
//                                     upsFormData['mimicLEDRemark'].isEmpty)) {
//                               return 'Remark is required when the LED indications not working';
//                             }
//                             return null;
//                           },
//                         ]),
//                         onChanged: (val) =>
//                             _onChanged(val, upsFormData, 'mimicLED'),
//                       ),
//                       CustomRemarkWidget(
//                           title: "Remark",
//                           formDataKey: "mimicLEDRemark",
//                           formData: upsFormData,
//                           formKey: _formKey,
//                           onChangedRemark: (p0, p1) {
//                             _onChangedRemark(p0, p1);
//                             _formKey.currentState?.validate();
//                           }),
//
// ////////////////////////////////////////////////////////////////////////////////
//                       //All metered parameters
//                       const customText(title: "All metered parameters"),
//                       FormBuilderChoiceChip<String>(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         name: 'meterPara',
//                         initialValue: '',
//                         selectedColor: Colors.lightBlueAccent,
//                         options: const [
//                           FormBuilderChipOption(
//                             value: 'Ok',
//                             child: Text("Ok"),
//                             avatar: CircleAvatar(child: Text('O')),
//                           ),
//                           FormBuilderChipOption(
//                             value: 'Not Ok',
//                             child: Text("Not Ok"),
//                             avatar: CircleAvatar(child: Text('N')),
//                           ),
//                         ],
//                         validator: FormBuilderValidators.compose([
//                           FormBuilderValidators.required(),
//                           (value) {
//                             if (value == 'Not Ok' &&
//                                 (upsFormData['meterParaRemark'] == null ||
//                                     upsFormData['meterParaRemark'].isEmpty)) {
//                               return 'Remark is required when the parameters are not ok';
//                             }
//                             return null;
//                           },
//                         ]),
//                         onChanged: (val) =>
//                             _onChanged(val, upsFormData, 'meterPara'),
//                       ),
//                       CustomRemarkWidget(
//                           title: "Remark",
//                           formDataKey: "meterParaRemark",
//                           formData: upsFormData,
//                           formKey: _formKey,
//                           onChangedRemark: (p0, p1) {
//                             _onChangedRemark(p0, p1);
//                             _formKey.currentState?.validate();
//                           }),
//
// //////////////////////////////////////////////////////////////////////////////////
//                       //Warning or Alarm massages
//                       const customText(title: "Warning or Alarm massages"),
//                       FormBuilderChoiceChip<String>(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         // decoration: const InputDecoration(
//                         //     labelText: 'Measure Room Temperature'),
//                         name: 'warningAlarm',
//                         initialValue: '',
//                         selectedColor: Colors.lightBlueAccent,
//                         options: const [
//                           FormBuilderChipOption(
//                             value: 'Yes',
//                             child: Text("Yes"),
//                             avatar: CircleAvatar(child: Text('Y')),
//                           ),
//                           FormBuilderChipOption(
//                             value: 'No',
//                             child: Text("No"),
//                             avatar: CircleAvatar(child: Text('N')),
//                           ),
//                         ],
//                         validator: FormBuilderValidators.compose([
//                           FormBuilderValidators.required(),
//                           (value) {
//                             if (value == 'Yes' &&
//                                 (upsFormData['warningAlarmRemark'] == null ||
//                                     upsFormData['warningAlarmRemark']
//                                         .isEmpty)) {
//                               return 'Remark is required when show the  warning or Alarm Massage';
//                             }
//                             return null;
//                           },
//                         ]),
//                         onChanged: (val) =>
//                             _onChanged(val, upsFormData, 'warningAlarm'),
//                       ),
//                       CustomRemarkWidget(
//                           title: "Remark",
//                           formDataKey: "warningAlarmRemark",
//                           formData: upsFormData,
//                           formKey: _formKey,
//                           onChangedRemark: (p0, p1) {
//                             _onChangedRemark(p0, p1);
//                             _formKey.currentState?.validate();
//                           }),
//
// ///////////////////////////////////////////////////////////////////////////////////////////
//                       //Signs of Overheating
//                       const customText(title: "Signs of Overheating"),
//                       FormBuilderChoiceChip<String>(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         name: 'overHeat',
//                         initialValue: '',
//                         selectedColor: Colors.lightBlueAccent,
//                         options: const [
//                           FormBuilderChipOption(
//                             value: 'Yes',
//                             child: Text("Yes"),
//                             avatar: CircleAvatar(child: Text('Y')),
//                           ),
//                           FormBuilderChipOption(
//                             value: 'No',
//                             child: Text("No"),
//                             avatar: CircleAvatar(child: Text('N')),
//                           ),
//                         ],
//                         validator: FormBuilderValidators.compose([
//                           FormBuilderValidators.required(),
//                           (value) {
//                             if (value == 'Yes' &&
//                                 (upsFormData['overHeatRemark'] == null ||
//                                     upsFormData['overHeatRemark'].isEmpty)) {
//                               return 'Remark is required when see the Signs of Over Heating';
//                             }
//                             return null;
//                           },
//                         ]),
//                         onChanged: (val) =>
//                             _onChanged(val, upsFormData, 'h2gasEmission'),
//                       ),
//                       CustomRemarkWidget(
//                           title: "Remark",
//                           formDataKey: "overHeatRemark",
//                           formData: upsFormData,
//                           formKey: _formKey,
//                           onChangedRemark: (p0, p1) {
//                             _onChangedRemark(p0, p1);
//                             _formKey.currentState?.validate();
//                           }),
//
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Divider(),
//                       const SizedBox(
//                         height: 10,
//                       ),
//
//                       const Text('04. UPS Reading',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           )),
//
//                       //volatge Reading
//                       const Text(' Voltage Measuremen',
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500,
//                           )),
//
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: FormBuilderTextField(
//                                     name: 'voltagePs1',
//                                     decoration: const InputDecoration(
//                                       labelText: "Phase 1",
//                                       suffixText: "V",
//                                     ),
//                                     textInputAction: TextInputAction.next,
//                                     keyboardType: TextInputType.number,
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                     onChanged: (val) {
//                                       print(
//                                           val); // Print the text value write into TextField
//                                       _onChanged(
//                                           val, upsFormData, 'voltagePs1');
//                                     },
//                                     validator: FormBuilderValidators.compose([
//                                       FormBuilderValidators.required(),
//                                       FormBuilderValidators.numeric(
//                                           errorText:
//                                               "Value must be \n numeric"),
//                                       FormBuilderValidators.max(1000,
//                                           inclusive: false,
//                                           errorText:
//                                               "Value should be \n less than 1000"),
//                                       (val) {
//                                         if (val == null || val.isEmpty)
//                                           return null;
//                                         final number = num.tryParse(val);
//                                         if (number == null)
//                                           return 'Must be a number';
//                                         return null;
//                                       },
//                                     ]),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                     width:
//                                         15), // Add spacing between the text fields
//                                 Expanded(
//                                   child: FormBuilderTextField(
//                                     name: 'voltagePs2',
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                     decoration: const InputDecoration(
//                                       labelText: "Phase 2",
//                                       suffixText: "V",
//                                     ),
//                                     textInputAction: TextInputAction.next,
//                                     keyboardType: TextInputType.number,
//                                     onChanged: (val) {
//                                       print(
//                                           val); // Print the text value write into TextField
//                                       _onChanged(
//                                           val, upsFormData, 'voltagePs2');
//                                     },
//                                     validator: FormBuilderValidators.compose([
//                                       FormBuilderValidators.required(),
//                                       FormBuilderValidators.numeric(
//                                           errorText:
//                                               "Value must be \n numeric"),
//                                       FormBuilderValidators.max(1000,
//                                           inclusive: false,
//                                           errorText:
//                                               "Value should be \n less than 1000"),
//                                       (val) {
//                                         if (val == null || val.isEmpty)
//                                           return null;
//                                         final number = num.tryParse(val);
//                                         if (number == null)
//                                           return 'Must be a number';
//                                         return null;
//                                       },
//                                     ]),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                     width:
//                                         15), // Add spacing between the text fields
//                                 Expanded(
//                                   child: FormBuilderTextField(
//                                     name: 'voltagePs3',
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                     decoration: const InputDecoration(
//                                       labelText: "Phase 3",
//                                       suffixText: "V",
//                                     ),
//                                     textInputAction: TextInputAction.next,
//                                     keyboardType: TextInputType.number,
//                                     onChanged: (val) {
//                                       print(
//                                           val); // Print the text value write into TextField
//                                       _onChanged(
//                                           val, upsFormData, 'voltagePs3');
//                                     },
//                                     validator: FormBuilderValidators.compose([
//                                       FormBuilderValidators.required(),
//                                       FormBuilderValidators.numeric(
//                                           errorText:
//                                               "Value must be \n numeric"),
//                                       FormBuilderValidators.max(1000,
//                                           inclusive: false,
//                                           errorText:
//                                               "Value should be \n less than 1000"),
//                                       (val) {
//                                         if (val == null || val.isEmpty)
//                                           return null;
//                                         final number = num.tryParse(val);
//                                         if (number == null)
//                                           return 'Must be a number';
//                                         return null;
//                                       },
//                                     ]),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       const SizedBox(
//                         height: 20,
//                       ),
//
//                       ///Curren Reading
//                       const Text('Current Measurements ',
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500,
//                           )),
//
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: FormBuilderTextField(
//                                     name: 'currentPs1',
//                                     decoration: const InputDecoration(
//                                       labelText: "Phase 1",
//                                       suffixText: "A",
//                                     ),
//                                     textInputAction: TextInputAction.next,
//                                     keyboardType: TextInputType.number,
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                     onChanged: (val) {
//                                       print(
//                                           val); // Print the text value write into TextField
//                                       _onChanged(
//                                           val, upsFormData, 'currentPs1');
//                                     },
//                                     validator: FormBuilderValidators.compose([
//                                       FormBuilderValidators.required(),
//                                       FormBuilderValidators.numeric(
//                                           errorText:
//                                               "Value must be \n numeric"),
//                                       FormBuilderValidators.max(10000,
//                                           inclusive: false,
//                                           errorText:
//                                               "Value should be \n less than 10000"),
//                                       (val) {
//                                         if (val == null || val.isEmpty)
//                                           return null;
//                                         final number = num.tryParse(val);
//                                         if (number == null)
//                                           return 'Must be a number';
//                                         return null;
//                                       },
//                                     ]),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                     width:
//                                         15), // Add spacing between the text fields
//                                 Expanded(
//                                   child: FormBuilderTextField(
//                                     name: 'currentPs2',
//                                     decoration: const InputDecoration(
//                                       labelText: "Phase 2",
//                                       suffixText: "A",
//                                     ),
//                                     textInputAction: TextInputAction.next,
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                     keyboardType: TextInputType.number,
//                                     onChanged: (val) {
//                                       print(
//                                           val); // Print the text value write into TextField
//                                       _onChanged(
//                                           val, upsFormData, 'currentPs2');
//                                     },
//                                     validator: FormBuilderValidators.compose([
//                                       FormBuilderValidators.required(),
//                                       FormBuilderValidators.numeric(
//                                           errorText:
//                                               "Value must be \n numeric"),
//                                       FormBuilderValidators.max(10000,
//                                           inclusive: false,
//                                           errorText:
//                                               "Value should be  \n less than 10000"),
//                                       (val) {
//                                         if (val == null || val.isEmpty)
//                                           return null;
//                                         final number = num.tryParse(val);
//                                         if (number == null)
//                                           return 'Must be a number';
//                                         return null;
//                                       },
//                                     ]),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                     width:
//                                         15), // Add spacing between the text fields
//                                 Expanded(
//                                   child: FormBuilderTextField(
//                                     name: 'currentPs3',
//                                     decoration: const InputDecoration(
//                                       labelText: "Phase 3",
//                                       suffixText: "A",
//                                     ),
//                                     textInputAction: TextInputAction.next,
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                     keyboardType: TextInputType.number,
//                                     onChanged: (val) {
//                                       print(
//                                           val); // Print the text value write into TextField
//                                       _onChanged(
//                                           val, upsFormData, 'currentPs3');
//                                     },
//                                     validator: FormBuilderValidators.compose([
//                                       FormBuilderValidators.required(),
//                                       FormBuilderValidators.numeric(
//                                           errorText:
//                                               "Value must be \n numeric"),
//                                       FormBuilderValidators.max(10000,
//                                           inclusive: false,
//                                           errorText:
//                                               "Value should be \n less than 10000"),
//                                       (val) {
//                                         if (val == null || val.isEmpty)
//                                           return null;
//                                         final number = num.tryParse(val);
//                                         if (number == null)
//                                           return 'Must be a number';
//                                         return null;
//                                       },
//                                     ]),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//
//                       const SizedBox(
//                         height: 15,
//                       ),
//
//                       ///capacity
//                       const Text('Capacity (%)',
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500,
//                           )),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20),
//                         child: Column(
//                           children: [
//                             FormBuilderTextField(
//                               name: 'upsCapacity',
//                               decoration: const InputDecoration(
//                                   labelText: "Capacity", suffixText: "A"),
//                               textInputAction: TextInputAction.next,
//                               keyboardType: TextInputType.number,
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction,
//                               onChanged: (val) {
//                                 print(
//                                     val); // Print the text value write into TextField
//                                 _onChanged(val, upsFormData, 'upsCapacity');
//                               },
//                               validator: FormBuilderValidators.compose([
//                                 FormBuilderValidators.required(),
//                                 FormBuilderValidators.numeric(),
//                                 FormBuilderValidators.max(100, inclusive: true),
//                                 (val) {
//                                   if (val == null || val.isEmpty) return null;
//                                   final number = num.tryParse(val);
//                                   if (number == null) return 'Must be a number';
//                                   return null;
//                                 },
//                               ]),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Divider(),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       const Text('Additional Remark :',
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500,
//                           )),
//                       Padding(
//                         padding: EdgeInsets.only(left: 20),
//                         child: Column(
//                           children: [
//                             FormBuilderTextField(
//                               name: 'addiRemark',
//                               decoration: const InputDecoration(
//                                   labelText: "Additional Remarks"),
//                               textInputAction: TextInputAction.done,
//                               onChanged: (val) {
//                                 print(
//                                     val); // Print the text value write into TextField
//                                 setState(() {
//                                   upsFormData['addiRemark'] = val;
//                                 });
//                               },
//                               validator: FormBuilderValidators.compose([]),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 30,
//                       ),
//
//                       ///////////////////////////////////////////////////////////
//                       FormBuilderCheckbox(
//                         name: 'accept_terms',
//                         initialValue: false,
//                         onChanged:  (value) => _onChanged(
//                             value, upsFormData, 'accept_terms'),
//
//                         title: RichText(
//                           text: const TextSpan(
//                             children: [
//                               TextSpan(
//                                 text: 'I Verify that submitted details are true and correct ',
//                                 style: TextStyle(color: Colors.black),
//                               ),
//                             ],
//                           ),
//                         ),
//                         validator: FormBuilderValidators.equal(
//                           true,
//                           errorText:
//                           'You must accept terms and conditions to continue',
//                         ),
//                       ),
//
//                       Row(
//                         children: <Widget>[
//                           Expanded(
//                             child: OutlinedButton(
//                               onPressed: () {
//                                 _formKey.currentState?.reset();
//                               },
//                               style: ButtonStyle(
//                                 foregroundColor: MaterialStateProperty.all<Color>(
//                                     Colors.green),
//                                 backgroundColor: MaterialStateProperty.all<Color>(
//                                     Colors.white24),
//                               ),
//                               child: const Text(
//                                 'Reset',
//                                 style: TextStyle(
//                                   color: Colors.redAccent,
//                                 ),
//                               ),
//                             ),
//                           ),
//
//                           const SizedBox(width: 20),
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 if (_formKey.currentState?.saveAndValidate() ?? false) {
//                                   _formKey.currentState!.save(); // Save form data
//                                   debugPrint(_formKey.currentState?.value.toString());
//                                   Map<String, dynamic> ? formData = _formKey
//                                       .currentState?.value;
//                                   formData = formData?.map((key, value) =>
//                                       MapEntry(key, value ?? ''));
//
//                                   // String rtom = _formKey.currentState?.value['Rtom_name'];
//                                   // debugPrint('RTOM value: $rtom');
//                                   //pass _formkey.currenState.value to a page called httpPostGen
//
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(builder: (context) =>
//                                         httpPostUPSInspection(formData: upsFormData, recId: widget.UPSUnit['upsID'], userAccess: userAccess,  )),
//                                   );
//                                 } else {
//                                   debugPrint(_formKey.currentState?.value.toString());
//                                   debugPrint('validation failed');
//                                 }
//                               },
//                               style:  ButtonStyle(
//
//                                 backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),// Set the button color here
//                                 foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set the text color here
//                               ),
//
//                               child: const Text(
//                                 'Submit',
//                                 style: TextStyle(color: Colors.greenAccent),
//                               ),
//                             ),
//                           ),
//
//                         ],
//                       ),
//
//                       SizedBox(height: 20,),
//
//
//                     ]))),
//       ),
//     ));
//   }
// }
//
// /////////////////////////////////////////////////////////////////////////////////////////
// ///custom remark widget
// class CustomRemarkWidget extends StatefulWidget {
//   final String title;
//   final String formDataKey;
//   final Map<String, dynamic> formData;
//   final GlobalKey<FormBuilderState> formKey;
//   final void Function(Map<String, dynamic>, Map<String, dynamic>)
//       onChangedRemark;
//
//   CustomRemarkWidget({
//     required this.title,
//     required this.formDataKey,
//     required this.formData,
//     required this.formKey,
//     required this.onChangedRemark,
//   });
//
//   @override
//   _CustomRemarkWidgetState createState() => _CustomRemarkWidgetState();
// }
//
// class _CustomRemarkWidgetState extends State<CustomRemarkWidget> {
//   late TextEditingController _textEditingController;
//
//   @override
//   void initState() {
//     super.initState();
//     _textEditingController = TextEditingController();
//   }
//
//   @override
//   void dispose() {
//     _textEditingController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Text(
//               '${widget.title}: ${widget.formData[widget.formDataKey] ?? ""}'),
//         ),
//         ElevatedButton.icon(
//           onPressed: () {
//             _textEditingController.text =
//                 widget.formData[widget.formDataKey] ?? "";
//             showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                   title: Text('Add ${widget.title}'),
//                   content: FormBuilderTextField(
//                     name: widget.formDataKey,
//                     controller: _textEditingController,
//                     decoration: InputDecoration(
//                       hintText: 'Enter ${widget.title}',
//                     ),
//                   ),
//                   actions: [
//                     TextButton(
//                       child: Text('OK'),
//                       onPressed: () {
//                         widget.formKey.currentState!.save(); // Save form data
//                         setState(() {
//                           widget.formData[widget.formDataKey] =
//                               _textEditingController.text;
//                         });
//                         widget.onChangedRemark(
//                             widget.formKey.currentState!.value,
//                             widget.formData);
//
//                         Navigator.pop(context);
//                       },
//                     ),
//                     TextButton(
//                       child: Text('Cancel'),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ],
//                 );
//               },
//             );
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blue,
//           ),
//           icon: Icon(Icons.add, color: Colors.black),
//           label: Text(
//             'Remarks',
//             style: TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// //custom Text
// class customText extends StatelessWidget {
//   final String title;
//   const customText({super.key, required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       title,
//       style: const TextStyle(
//           color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
//     );
//   }
// }
