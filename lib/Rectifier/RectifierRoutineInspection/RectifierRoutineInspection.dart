import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/widgets/gps_tag_widget.dart';

//import '../../../UserAccess.dart';
import 'httpPostRectifierInspection.dart';

class InspectionRec extends StatefulWidget {
  final dynamic RectifierUnit;
  final String region;
  final String availableModule;
  final String capacity;
  final String makeType;

  const InspectionRec({
    super.key,
    this.RectifierUnit,
    required this.region,
    required this.availableModule,
    required this.capacity,
    required this.makeType,
  });

  @override
  State<InspectionRec> createState() => _InspectionRecState();
}

class _InspectionRecState extends State<InspectionRec> {
  final _formKey = GlobalKey<FormBuilderState>();
  var regions = [
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
  //defind models
  // var models = [
  //   'NEC',
  //   'BENING',
  //   'TATA',
  //   'SHINDENG',
  //   'DPC',
  //   'ZTE',
  //   'EMERSSION',
  //   'AEES',
  //   'SAFT',
  // ];
  //Define recForm Data map
  Map<String, dynamic> recFormData = {'clockTime': DateTime.now(), 'shift': ""};
  String _shift = '';
  TimeOfDay? _selectedTime;

  //save data from checklist to http file
  void _onChanged(
    dynamic val,
    Map<String, dynamic> formData,
    String fieldName,
  ) {
    debugPrint(val.toString());
    debugPrint(recFormData.toString());
    formData[fieldName] = val;
  }

  //passing data in remark
  void _onChangedRemark(dynamic val, Map<String, dynamic> formData) {
    debugPrint(val.toString());
    debugPrint(recFormData.toString());
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
  //
  //   if (_formKey.currentState!.saveAndValidate()) {
  //     // Navigate to httpMaintenancePost.dart with the form data
  //     _formKey.currentState!.save(); // Save form data
  //     debugPrint(
  //         "Form Data: ${recFormData.toString()}"); // Debug print the form data
  //
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => httpPostRectifierInspection(
  //             formData: recFormData, recId: widget.RectifierUnit['RecID'], userAccess: userAccess, ),
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
    //  UserAccess userAccess = Provider.of<UserAccess>
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
                  _onChanged(fieldState.value, recFormData, fieldKey);
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

                    //Region
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Region :",
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
                    if (widget.RectifierUnit['Region'] != 'HQ' &&
                        widget.RectifierUnit['Region'] != 'WEL')
                      ReusableGPSWidget(
                        onLocationFound: (lat, lng) {
                          setState(() {
                            recFormData['gpsLocation'] = {
                              'lat': lat,
                              'lng': lng,
                            };
                          });
                          print('Got location: $lat, $lng');
                          // Save to database, use in form, etc.
                        },
                      ),

                    const SizedBox(height: 10),

                    //Get Genaral Inspectin Date
                    const Text(
                      'Genaral Inspection',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    //Cleanliness of Room
                    const customText(title: "Cleanliness of Room"),
                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // decoration:
                      //     const InputDecoration(labelText: 'Cleanliness of Room'),
                      name: 'roomClean',
                      initialValue: '',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: 'Ok',
                          child: Text("Clean"),
                          avatar: CircleAvatar(child: Text('C')),
                        ),
                        FormBuilderChipOption(
                          value: 'Not Ok',
                          child: Text("Not Clean"),
                          avatar: CircleAvatar(child: Text('N')),
                        ),
                      ],
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        (value) {
                          if (value == 'Not Ok' &&
                              (recFormData['roomCleanRemark'] == null ||
                                  recFormData['roomCleanRemark'].isEmpty)) {
                            return 'Remark is required when the room is not clean';
                          }
                          return null;
                        },
                      ]),
                      onChanged:
                          (val) => _onChanged(val, recFormData, 'roomClean'),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "roomCleanRemark",
                      formData: recFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    ////////////////////////////////////////////////////////////////////////////////
                    //Cleanliness of Cubicles
                    const customText(title: "Cleanliness of Cubicles"),
                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // decoration: const InputDecoration(
                      //     labelText: 'Cleanliness of Cubicles(Dusting)'),
                      name: 'cubicleClean',
                      initialValue: '',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: 'Ok',
                          child: Text("Clean"),
                          avatar: CircleAvatar(child: Text('C')),
                        ),
                        FormBuilderChipOption(
                          value: 'Not Ok',
                          child: Text("Not Clean"),
                          avatar: CircleAvatar(child: Text('N')),
                        ),
                      ],
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        (value) {
                          if (value == 'Not Ok' &&
                              (recFormData['CubicleCleanRemark'] == null ||
                                  recFormData['CubicleCleanRemark'].isEmpty)) {
                            return 'Remark is required when the cubicles are not clean';
                          }
                          return null;
                        },
                      ]),
                      onChanged:
                          (val) => _onChanged(val, recFormData, 'cubicleClean'),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "CubicleCleanRemark",
                      formData: recFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    //////////////////////////////////////////////////////////////////////////////////
                    //Measure Room Temperature
                    const customText(title: "Measure Room Temperature"),
                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // decoration: const InputDecoration(
                      //     labelText: 'Measure Room Temperature'),
                      name: 'roomTemp',
                      initialValue: '',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: 'high',
                          child: Text("High"),
                          avatar: CircleAvatar(child: Text('H')),
                        ),
                        FormBuilderChipOption(
                          value: 'Normal',
                          child: Text("Normal"),
                          avatar: CircleAvatar(child: Text('N')),
                        ),
                      ],
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        (value) {
                          if (value == 'high' &&
                              (recFormData['roomTempRemark'] == null ||
                                  recFormData['roomTempRemark'].isEmpty)) {
                            return 'Remark is required when the room temperature is High';
                          }
                          return null;
                        },
                      ]),
                      onChanged:
                          (val) => _onChanged(val, recFormData, 'roomTemp'),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "roomTempRemark",
                      formData: recFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    ///////////////////////////////////////////////////////////////////////////////////////////
                    //Measure Hydrogen Gas Emmission
                    const customText(title: "Measure Hydrogen Gas Emmission"),
                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // decoration: const InputDecoration(
                      //     labelText: 'Measure Hydrogen Gas Emmission'),
                      name: 'h2gasEmission',
                      initialValue: '',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: 'yes',
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
                          if (value == 'yes' &&
                              (recFormData['h2gasEmissionRemark'] == null ||
                                  recFormData['h2gasEmissionRemark'].isEmpty)) {
                            return 'Remark is required when detect Hydrogen Emmision';
                          }
                          return null;
                        },
                      ]),
                      onChanged:
                          (val) =>
                              _onChanged(val, recFormData, 'h2gasEmission'),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "h2gasEmissionRemark",
                      formData: recFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    ////////////////////////////////////////////////////////////////////////////////////////
                    //Check Main Circuit Breakers
                    const customText(title: "Check Main Circuit Breakers"),
                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // decoration: const InputDecoration(
                      //     labelText: 'Check Main Circuit Breakers'),
                      name: 'checkMCB',
                      initialValue: '',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: 'ok',
                          child: Text("ok"),
                          avatar: CircleAvatar(child: Text('O')),
                        ),
                        FormBuilderChipOption(
                          value: 'Not ok',
                          child: Text("Not ok"),
                          avatar: CircleAvatar(child: Text('N')),
                        ),
                      ],
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        (value) {
                          if (value == 'Not ok' &&
                              (recFormData['checkMCBRemark'] == null ||
                                  recFormData['checkMCBRemark'].isEmpty)) {
                            return 'Remark is required when MCB is not ok';
                          }
                          return null;
                        },
                      ]),
                      onChanged: (val) {
                        _onChanged(val, recFormData, 'checkMCB');
                        _formKey.currentState?.validate();
                      },
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "checkMCBRemark",
                      formData: recFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    ///////////////////////////////////////////////////////////////////////////////////
                    //DC PDB
                    const customText(title: "DC PDB"),
                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // decoration: const InputDecoration(labelText: 'DC PDB'),
                      name: 'dcPDB',
                      initialValue: '',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: 'ok',
                          child: Text("ok"),
                          avatar: CircleAvatar(child: Text('O')),
                        ),
                        FormBuilderChipOption(
                          value: 'Not ok',
                          child: Text("Not ok"),
                          avatar: CircleAvatar(child: Text('N')),
                        ),
                      ],
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        (value) {
                          if (value == 'Not ok' &&
                              (recFormData['dcPDBRemark'] == null ||
                                  recFormData['dcPDBRemark'].isEmpty)) {
                            return 'Remark is required when the DC PDB is not ok';
                          }
                          return null;
                        },
                      ]),

                      onChanged: (val) => _onChanged(val, recFormData, 'dcPDB'),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "dcPDBRemark",
                      formData: recFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    ////////////////////////////////////////////////////////////////////////////////////////////
                    //Test Remort Alarm
                    const customText(title: "Test Remort Alarm"),
                    FormBuilderChoiceChips<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // decoration:
                      //     const InputDecoration(labelText: 'Test Remort Alarm'),
                      name: 'remoteAlarm',
                      initialValue: '',
                      selectedColor: Colors.lightBlueAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: 'ok',
                          child: Text("ok"),
                          avatar: CircleAvatar(child: Text('O')),
                        ),
                        FormBuilderChipOption(
                          value: 'Not ok',
                          child: Text("Not ok"),
                          avatar: CircleAvatar(child: Text('N')),
                        ),
                      ],
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        (value) {
                          if (value == 'Not ok' &&
                              (recFormData['remoteAlarmRemark'] == null ||
                                  recFormData['remoteAlarmRemark'].isEmpty)) {
                            return 'Remark is required when the Remote Alarm is not ok';
                          }
                          return null;
                        },
                      ]),
                      onChanged:
                          (val) => _onChanged(val, recFormData, 'remoteAlarm'),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "remoteAlarmRemark",
                      formData: recFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    const SizedBox(height: 10),

                    //////////////////////////////////////////////////////////////////////////////////////////
                    const Divider(thickness: 3, color: Colors.black),

                    //No. of Working Line
                    const Text(
                      'No of Working Modules',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Available Modules     :',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                widget.availableModule,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'No Working Modules at now :',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: FormBuilderTextField(
                                  name: 'noOfWorkingLine',
                                  style: TextStyle(
                                    color: customColors.mainTextColor,
                                  ),
                                  decoration: const InputDecoration(
                                    labelText: "Available modules",
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onChanged: (val) {
                                    print(
                                      val,
                                    ); // Print the text value write into TextField
                                    _onChanged(
                                      val,
                                      recFormData,
                                      'noOfWorkingLine',
                                    );
                                  },
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.max(
                                      int.parse(widget.availableModule),
                                      inclusive: false,
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    //Capacity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Capacity          :',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${widget.capacity} ${widget.makeType}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    //Make Type
                    const SizedBox(height: 15),

                    const Text(
                      'Rectifier Testing',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    //////////////////////////////////////////////////////////////////////////
                    //volatge Reading
                    const Text(
                      '1. Voltage Reading',
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
                                    _onChanged(val, recFormData, 'voltagePs1');
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
                                    _onChanged(val, recFormData, 'voltagePs2');
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
                                    _onChanged(val, recFormData, 'voltagePs3');
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

                    /////////////////////////////////////////////////////////////
                    ///Curren Reading
                    const Text(
                      '2. Current Reading',
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
                                    _onChanged(val, recFormData, 'currentPs1');
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
                                    _onChanged(val, recFormData, 'currentPs2');
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
                                    _onChanged(val, recFormData, 'currentPs3');
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

                    const SizedBox(height: 20),

                    //////////////////////////////////////////////////////////////////////////
                    ///DC Output
                    const Text(
                      '3. DC Output',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: FormBuilderTextField(
                              name: 'dcVoltage',
                              style: TextStyle(
                                color: customColors.mainTextColor,
                              ),

                              decoration: InputDecoration(
                                labelText: "Voltage",
                                suffixText: "V",
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
                                _onChanged(val, recFormData, 'dcVoltage');
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.numeric(),
                                FormBuilderValidators.max(
                                  100,
                                  inclusive: false,
                                  errorText: "Value should be \nless than 100",
                                ),
                                (val) {
                                  if (val == null || val.isEmpty) return null;
                                  final number = num.tryParse(val);
                                  if (number == null) return 'Must be a number';
                                  return null;
                                },
                              ]),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ), // Add spacing between the text fields
                          Expanded(
                            child: FormBuilderTextField(
                              name: 'dcCurrent',
                              style: TextStyle(
                                color: customColors.mainTextColor,
                              ),

                              decoration: InputDecoration(
                                labelText: "Current",
                                suffixText: "A",
                                suffixStyle: TextStyle(
                                  color: customColors.mainTextColor.withOpacity(
                                    0.7,
                                  ),
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
                                _onChanged(val, recFormData, 'dcCurrent');
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.numeric(),
                                FormBuilderValidators.max(
                                  10000,
                                  inclusive: false,
                                  errorText:
                                      "Value should be \nless than 10000",
                                ),
                                (val) {
                                  if (val == null || val.isEmpty) return null;
                                  final number = num.tryParse(val);
                                  if (number == null) return 'Must be a number';
                                  return null;
                                },
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /////////////////////////////////////////////////////////////////////
                    ///capacity
                    const Text(
                      '4. Capacity',
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
                            name: 'recCapacity',
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
                            onChanged: (val) {
                              print(
                                val,
                              ); // Print the text value write into TextField
                              _onChanged(val, recFormData, 'recCapacity');
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.numeric(),
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
                    const SizedBox(height: 20),

                    ////////////////////////////////////////////////////////////////////////////////
                    ///Alarm Status
                    const Text(
                      '5. Alarm Status',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          FormBuilderChoiceChips(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            // decoration:
                            //     const InputDecoration(labelText: 'Alarm Status'),
                            name: 'recAlarmStatus',
                            initialValue: '',
                            selectedColor: Colors.lightBlueAccent,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              (value) {
                                if (value == 'notok' &&
                                    (recFormData['recAlarmRemark'] == null ||
                                        recFormData['recAlarmRemark']
                                            .isEmpty)) {
                                  return 'Remark is required when the room temperature is High';
                                }
                                return null;
                              },
                            ]),
                            onChanged:
                                (value) => _onChanged(
                                  value,
                                  recFormData,
                                  'recAlarmStatus',
                                ),
                            options: const [
                              FormBuilderChipOption(
                                value: 'ok',
                                child: Text("ok"),
                                avatar: CircleAvatar(child: Text('O')),
                              ),
                              FormBuilderChipOption(
                                value: 'notok',
                                child: Text("Not ok"),
                                avatar: CircleAvatar(child: Text('N')),
                              ),
                            ],
                          ),
                          CustomRemarkWidget(
                            title: "Remark",
                            formDataKey: "recAlarmRemark",
                            formData: recFormData,
                            formKey: _formKey,
                            onChangedRemark: (p0, p1) {
                              _onChangedRemark(p0, p1);
                              _formKey.currentState?.validate();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    //////////////////////////////////////////////////////////////////////////////
                    ///Indicator Status
                    const Text(
                      '6. Indicator Status',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          FormBuilderChoiceChips(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            // decoration: const InputDecoration(
                            //     labelText: 'Indicator Status'),
                            name: 'recIndicatorStatus',
                            initialValue: '',
                            selectedColor: Colors.lightBlueAccent,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              (value) {
                                if (value == 'not ok' &&
                                    (recFormData['indRemark'] == null ||
                                        recFormData['indRemark'].isEmpty)) {
                                  return 'Remark is required when the room temperature is High';
                                }
                                return null;
                              },
                            ]),
                            onChanged:
                                (value) => _onChanged(
                                  value,
                                  recFormData,
                                  'recIndicatorStatus',
                                ),
                            options: const [
                              FormBuilderChipOption(
                                value: 'ok',
                                child: Text("ok"),
                                avatar: CircleAvatar(child: Text('O')),
                              ),
                              FormBuilderChipOption(
                                value: 'not ok',
                                child: Text("Not ok"),
                                avatar: CircleAvatar(child: Text('N')),
                              ),
                            ],
                          ),
                          CustomRemarkWidget(
                            title: "Remark",
                            formDataKey: "indRemark",
                            formData: recFormData,
                            formKey: _formKey,
                            onChangedRemark: (p0, p1) {
                              _onChangedRemark(p0, p1);
                              _formKey.currentState?.validate();
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    FormBuilderCheckbox(
                      name: 'accept_terms',
                      initialValue: false,
                      onChanged:
                          (value) =>
                              _onChanged(value, recFormData, 'accept_terms'),
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
                              if (widget.RectifierUnit['Region'] != 'HQ' &&
                                  recFormData['gpsLocation'] == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('GPS location is required!'),
                                  ),
                                );
                                return;
                              }
                              if (_formKey.currentState?.saveAndValidate() ??
                                  false) {
                                debugPrint(
                                  _formKey.currentState?.value.toString(),
                                );
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
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           httpPostRectifierInspection(
                                //             formData: recFormData,
                                //             recId:
                                //             widget.RectifierUnit['RecID'],
                                //            // userAccess: userAccess,
                                //             region: widget.region,
                                //           )),
                                // );
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

                    // Center(
                    //   child: ElevatedButton(
                    //     onPressed: _submitForm,
                    //     style: ElevatedButton.styleFrom(
                    //       foregroundColor: Colors.white,
                    //       backgroundColor: const Color.fromARGB(
                    //           255, 117, 175, 222), // Text color
                    //       shadowColor: Colors.blueAccent, // Shadow color
                    //       elevation: 5, // Elevation of the button
                    //       padding: const EdgeInsets.symmetric(
                    //           horizontal: 80,
                    //           vertical: 16), // Padding inside the button
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius:
                    //         BorderRadius.circular(12), // Rounded corners
                    //       ),
                    //     ),
                    //     child: const Text('Submit'),
                    //   ),
                    // ),
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
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Text(
      title,
      style: TextStyle(
        color: customColors.subTextColor,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}


//v3 10-07-2024
// import 'package:flutter/material.dart';
//
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:powerprox/Screens/Rectifier/RectifierRoutineInspection/httpPostRectifierInspection.dart';
// import 'package:provider/provider.dart';
//
// import '../../UserAccess.dart';
// import 'httpPostRectifierInspection.dart';
//
// class InspectionRec extends StatefulWidget {
//   final dynamic RectifierUnit;
//   final String region;
//
//   const InspectionRec({
//     super.key,
//     this.RectifierUnit,
//     required this.region,
//   });
//
//   @override
//   State<InspectionRec> createState() => _InspectionRecState();
// }
//
// class _InspectionRecState extends State<InspectionRec> {
//   final _formKey = GlobalKey<FormBuilderState>();
//   var regions = [
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
//   //defind models
//   // var models = [
//   //   'NEC',
//   //   'BENING',
//   //   'TATA',
//   //   'SHINDENG',
//   //   'DPC',
//   //   'ZTE',
//   //   'EMERSSION',
//   //   'AEES',
//   //   'SAFT',
//   // ];
//   //Define recForm Data map
//   Map<String, dynamic> recFormData = {
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
//     debugPrint(recFormData.toString());
//     formData[fieldName] = val;
//   }
//
//   //passing data in remark
//   void _onChangedRemark(dynamic val, Map<String, dynamic> formData) {
//     debugPrint(val.toString());
//     debugPrint(recFormData.toString());
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
//   //
//   //   if (_formKey.currentState!.saveAndValidate()) {
//   //     // Navigate to httpMaintenancePost.dart with the form data
//   //     _formKey.currentState!.save(); // Save form data
//   //     debugPrint(
//   //         "Form Data: ${recFormData.toString()}"); // Debug print the form data
//   //
//   //     Navigator.push(
//   //       context,
//   //       MaterialPageRoute(
//   //         builder: (context) => httpPostRectifierInspection(
//   //             formData: recFormData, recId: widget.RectifierUnit['RecID'], userAccess: userAccess, ),
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
//           appBar: AppBar(
//             title: const Text("Daily Routine Checklist"),
//           ),
//           body: SingleChildScrollView(
//             child: FormBuilder(
//                 key: _formKey,
//                 onChanged: () {
//                   _formKey.currentState!.save();
//                   // Loop through all the fields and call _onChanged for each field
//                   _formKey.currentState!.fields.forEach((fieldKey, fieldState) {
//                     _onChanged(fieldState.value, recFormData, fieldKey);
//                   });
//                 },
//                 child: Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 "NOW ON :",
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 15),
//                               ),
//                               SizedBox(
//                                 width: MediaQuery.of(context).size.width * 0.1,
//                               ),
//                               Container(
//                                 width: MediaQuery.of(context).size.width * 0.6,
//                                 height: 30,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: Colors.grey.shade300),
//                                 child: Center(
//                                   child: Text(
//                                     _shift,
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold, fontSize: 15),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                           const SizedBox(
//                             height: 5,
//                           ),
//
//                           //Region
//
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Text(
//                                 "Region :",
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 15),
//                               ),
//                               Spacer(),
//                               Text(
//                                 widget.region,
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 15),
//                               ),
//                             ],
//                           ),
//
//                           const SizedBox(
//                             height: 10,
//                           ),
//
//                           //Get Genaral Inspectin Date
//                           const Text('Genaral Inspection',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               )),
//
//                           //Cleanliness of Room
//                           const customText(
//                             title: "Cleanliness of Room",
//                           ),
//                           FormBuilderChoiceChips<String>(
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             // decoration:
//                             //     const InputDecoration(labelText: 'Cleanliness of Room'),
//                             name: 'roomClean',
//                             initialValue: '',
//                             selectedColor: Colors.lightBlueAccent,
//                             options: const [
//                               FormBuilderChipOption(
//                                 value: 'Ok',
//                                 child: Text("Clean"),
//                                 avatar: CircleAvatar(child: Text('C')),
//                               ),
//                               FormBuilderChipOption(
//                                 value: 'Not Ok',
//                                 child: Text("Not Clean"),
//                                 avatar: CircleAvatar(child: Text('N')),
//                               ),
//                             ],
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                                   (value) {
//                                 if (value == 'Not Ok' &&
//                                     (recFormData['RoomCleanRemark'] == null ||
//                                         recFormData['RoomCleanRemark'].isEmpty)) {
//                                   return 'Remark is required when the room is not clean';
//                                 }
//                                 return null;
//                               },
//                             ]),
//                             onChanged: (val) =>
//                                 _onChanged(val, recFormData, 'roomClean'),
//                           ),
//                           CustomRemarkWidget(
//                               title: "Remark",
//                               formDataKey: "roomCleanRemark",
//                               formData: recFormData,
//                               formKey: _formKey,
//                               onChangedRemark: (p0, p1) {
//                                 _onChangedRemark(p0, p1);
//                                 _formKey.currentState?.validate();
//                               }),
//
// ////////////////////////////////////////////////////////////////////////////////
//                           //Cleanliness of Cubicles
//                           const customText(title: "Cleanliness of Cubicles"),
//                           FormBuilderChoiceChips<String>(
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             // decoration: const InputDecoration(
//                             //     labelText: 'Cleanliness of Cubicles(Dusting)'),
//                             name: 'cubicleClean',
//                             initialValue: '',
//                             selectedColor: Colors.lightBlueAccent,
//                             options: const [
//                               FormBuilderChipOption(
//                                 value: 'Ok',
//                                 child: Text("Clean"),
//                                 avatar: CircleAvatar(child: Text('C')),
//                               ),
//                               FormBuilderChipOption(
//                                 value: 'Not Ok',
//                                 child: Text("Not Clean"),
//                                 avatar: CircleAvatar(child: Text('N')),
//                               ),
//                             ],
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                                   (value) {
//                                 if (value == 'Not Ok' &&
//                                     (recFormData['CubicleCleanRemark'] == null ||
//                                         recFormData['CubicleCleanRemark']
//                                             .isEmpty)) {
//                                   return 'Remark is required when the cubicles are not clean';
//                                 }
//                                 return null;
//                               },
//                             ]),
//                             onChanged: (val) =>
//                                 _onChanged(val, recFormData, 'cubicleClean'),
//                           ),
//                           CustomRemarkWidget(
//                               title: "Remark",
//                               formDataKey: "CubicleCleanRemark",
//                               formData: recFormData,
//                               formKey: _formKey,
//                               onChangedRemark: (p0, p1) {
//                                 _onChangedRemark(p0, p1);
//                                 _formKey.currentState?.validate();
//                               }),
//
// //////////////////////////////////////////////////////////////////////////////////
//                           //Measure Room Temperature
//                           const customText(title: "Measure Room Temperature"),
//                           FormBuilderChoiceChips<String>(
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             // decoration: const InputDecoration(
//                             //     labelText: 'Measure Room Temperature'),
//                             name: 'roomTemp',
//                             initialValue: '',
//                             selectedColor: Colors.lightBlueAccent,
//                             options: const [
//                               FormBuilderChipOption(
//                                 value: 'high',
//                                 child: Text("High"),
//                                 avatar: CircleAvatar(child: Text('H')),
//                               ),
//                               FormBuilderChipOption(
//                                 value: 'Normal',
//                                 child: Text("Normal"),
//                                 avatar: CircleAvatar(child: Text('N')),
//                               ),
//                             ],
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                                   (value) {
//                                 if (value == 'high' &&
//                                     (recFormData['roomTempRemark'] == null ||
//                                         recFormData['roomTempRemark'].isEmpty)) {
//                                   return 'Remark is required when the room temperature is High';
//                                 }
//                                 return null;
//                               },
//                             ]),
//                             onChanged: (val) =>
//                                 _onChanged(val, recFormData, 'roomTemp'),
//                           ),
//                           CustomRemarkWidget(
//                               title: "Remark",
//                               formDataKey: "roomTempRemark",
//                               formData: recFormData,
//                               formKey: _formKey,
//                               onChangedRemark: (p0, p1) {
//                                 _onChangedRemark(p0, p1);
//                                 _formKey.currentState?.validate();
//                               }),
//
// ///////////////////////////////////////////////////////////////////////////////////////////
//                           //Measure Hydrogen Gas Emmission
//                           const customText(title: "Measure Hydrogen Gas Emmission"),
//                           FormBuilderChoiceChips<String>(
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             // decoration: const InputDecoration(
//                             //     labelText: 'Measure Hydrogen Gas Emmission'),
//                             name: 'h2gasEmission',
//                             initialValue: '',
//                             selectedColor: Colors.lightBlueAccent,
//                             options: const [
//                               FormBuilderChipOption(
//                                 value: 'yes',
//                                 child: Text("Yes"),
//                                 avatar: CircleAvatar(child: Text('Y')),
//                               ),
//                               FormBuilderChipOption(
//                                 value: 'No',
//                                 child: Text("No"),
//                                 avatar: CircleAvatar(child: Text('N')),
//                               ),
//                             ],
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                                   (value) {
//                                 if (value == 'yes' &&
//                                     (recFormData['h2gasEmissionRemark'] == null ||
//                                         recFormData['h2gasEmissionRemark']
//                                             .isEmpty)) {
//                                   return 'Remark is required when detect Hydrogen Emmision';
//                                 }
//                                 return null;
//                               },
//                             ]),
//                             onChanged: (val) =>
//                                 _onChanged(val, recFormData, 'h2gasEmission'),
//                           ),
//                           CustomRemarkWidget(
//                               title: "Remark",
//                               formDataKey: "h2gasEmissionRemark",
//                               formData: recFormData,
//                               formKey: _formKey,
//                               onChangedRemark: (p0, p1) {
//                                 _onChangedRemark(p0, p1);
//                                 _formKey.currentState?.validate();
//                               }),
//
// ////////////////////////////////////////////////////////////////////////////////////////
//                           //Check Main Circuit Breakers
//                           const customText(title: "Check Main Circuit Breakers"),
//                           FormBuilderChoiceChip<String>(
//                               autovalidateMode: AutovalidateMode.onUserInteraction,
//                               // decoration: const InputDecoration(
//                               //     labelText: 'Check Main Circuit Breakers'),
//                               name: 'checkMCB',
//                               initialValue: '',
//                               selectedColor: Colors.lightBlueAccent,
//                               options: const [
//                                 FormBuilderChipOption(
//                                   value: 'ok',
//                                   child: Text("ok"),
//                                   avatar: CircleAvatar(child: Text('O')),
//                                 ),
//                                 FormBuilderChipOption(
//                                   value: 'Not ok',
//                                   child: Text("Not ok"),
//                                   avatar: CircleAvatar(child: Text('N')),
//                                 ),
//                               ],
//                               validator: FormBuilderValidators.compose([
//                                 FormBuilderValidators.required(),
//                                     (value) {
//                                   if (value == 'Not ok' &&
//                                       (recFormData['checkMCBRemark'] == null ||
//                                           recFormData['checkMCBRemark'].isEmpty)) {
//                                     return 'Remark is required when MCB is not ok';
//                                   }
//                                   return null;
//                                 },
//                               ]),
//                               onChanged: (val) {
//                                 _onChanged(val, recFormData, 'checkMCB');
//                                 _formKey.currentState?.validate();
//                               }),
//                           CustomRemarkWidget(
//                               title: "Remark",
//                               formDataKey: "checkMCBRemark",
//                               formData: recFormData,
//                               formKey: _formKey,
//                               onChangedRemark: (p0, p1) {
//                                 _onChangedRemark(p0, p1);
//                                 _formKey.currentState?.validate();
//                               }),
//
// ///////////////////////////////////////////////////////////////////////////////////
//                           //DC PDB
//                           const customText(title: "DC PDB"),
//                           FormBuilderChoiceChip<String>(
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             // decoration: const InputDecoration(labelText: 'DC PDB'),
//                             name: 'dcPDB',
//                             initialValue: '',
//                             selectedColor: Colors.lightBlueAccent,
//                             options: const [
//                               FormBuilderChipOption(
//                                 value: 'ok',
//                                 child: Text("ok"),
//                                 avatar: CircleAvatar(child: Text('O')),
//                               ),
//                               FormBuilderChipOption(
//                                 value: 'Not ok',
//                                 child: Text("Not ok"),
//                                 avatar: CircleAvatar(child: Text('N')),
//                               ),
//                             ],
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                                   (value) {
//                                 if (value == 'Not ok' &&
//                                     (recFormData['dcPDBRemark'] == null ||
//                                         recFormData['dcPDBRemark'].isEmpty)) {
//                                   return 'Remark is required when the DC PDB is not ok';
//                                 }
//                                 return null;
//                               },
//                             ]),
//
//                             onChanged: (val) =>
//                                 _onChanged(val, recFormData, 'dcPDB'),
//                           ),
//                           CustomRemarkWidget(
//                               title: "Remark",
//                               formDataKey: "dcPDBRemark",
//                               formData: recFormData,
//                               formKey: _formKey,
//                               onChangedRemark: (p0, p1) {
//                                 _onChangedRemark(p0, p1);
//                                 _formKey.currentState?.validate();
//                               }),
//
// ////////////////////////////////////////////////////////////////////////////////////////////
//                           //Test Remort Alarm
//                           const customText(title: "Test Remort Alarm"),
//                           FormBuilderChoiceChip<String>(
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             // decoration:
//                             //     const InputDecoration(labelText: 'Test Remort Alarm'),
//                             name: 'remoteAlarm',
//                             initialValue: '',
//                             selectedColor: Colors.lightBlueAccent,
//                             options: const [
//                               FormBuilderChipOption(
//                                 value: 'ok',
//                                 child: Text("ok"),
//                                 avatar: CircleAvatar(child: Text('O')),
//                               ),
//                               FormBuilderChipOption(
//                                 value: 'Not ok',
//                                 child: Text("Not ok"),
//                                 avatar: CircleAvatar(child: Text('N')),
//                               ),
//                             ],
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                                   (value) {
//                                 if (value == 'Not ok' &&
//                                     (recFormData['remoteAlarmRemark'] == null ||
//                                         recFormData['remoteAlarmRemark'].isEmpty)) {
//                                   return 'Remark is required when the Remote Alarm is not ok';
//                                 }
//                                 return null;
//                               },
//                             ]),
//                             onChanged: (val) =>
//                                 _onChanged(val, recFormData, 'remoteAlarm'),
//                           ),
//                           CustomRemarkWidget(
//                               title: "Remark",
//                               formDataKey: "remoteAlarmRemark",
//                               formData: recFormData,
//                               formKey: _formKey,
//                               onChangedRemark: (p0, p1) {
//                                 _onChangedRemark(p0, p1);
//                                 _formKey.currentState?.validate();
//                               }),
//
//                           const SizedBox(
//                             height: 10,
//                           ),
//
//                           //////////////////////////////////////////////////////////////////////////////////////////
//                           const Divider(
//                             thickness: 3,
//                             color: Colors.black,
//                           ),
//
//                           //No. of Working Line
//                           FormBuilderTextField(
//                             name: 'noOfWorkingLine',
//                             decoration: const InputDecoration(
//                               labelText: "No. of Working Line",
//                             ),
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             onChanged: (val) {
//                               print(
//                                   val); // Print the text value write into TextField
//                               _onChanged(val, recFormData, 'noOfWorkingLine');
//                             },
//                             keyboardType: TextInputType.number,
//                             textInputAction: TextInputAction.next,
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                               FormBuilderValidators.max(100, inclusive: false),
//                             ]),
//                           ),
//
//                           //Capacity
//                           FormBuilderTextField(
//                             name: 'capacity',
//                             decoration: const InputDecoration(
//                                 labelText: "Capacity", suffixText: "A"),
//                             onChanged: (val) {
//                               print(
//                                   val); // Print the text value write into TextField
//                               _onChanged(val, recFormData, 'capacity');
//                             },
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             keyboardType: TextInputType.number,
//                             textInputAction: TextInputAction.next,
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                               FormBuilderValidators.numeric(),
//                                   (val) {
//                                 if (val == null || val.isEmpty) return null;
//                                 final number = num.tryParse(val);
//                                 if (number == null) return 'Must be a number';
//                                 if (number >= 9999)
//                                   return 'Value must be less than 9999';
//                                 return null;
//                               },
//                             ]),
//                           ),
//
//                           //Make Type
//                           FormBuilderTextField(
//                             name: 'type',
//                             decoration: const InputDecoration(
//                               labelText: "Make Type",
//                             ),
//                             onChanged: (val) {
//                               print(
//                                   val); // Print the text value write into TextField
//                               _onChanged(val, recFormData, 'type');
//                             },
//                             keyboardType: TextInputType.name,
//                             textInputAction: TextInputAction.next,
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                               FormBuilderValidators.maxLength(20,
//                                   errorText:
//                                   'Input must be less than 20 characters'),
//                             ]),
//                           ),
//                           const SizedBox(
//                             height: 15,
//                           ),
//
//                           const Text('Rectifier Testing',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               )),
//
//                           //////////////////////////////////////////////////////////////////////////
//                           //volatge Reading
//                           const Text('1. Voltage Reading',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               )),
//
//                           Padding(
//                             padding: const EdgeInsets.only(left: 20),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: FormBuilderTextField(
//                                         name: 'voltagePs1',
//                                         decoration: const InputDecoration(
//                                           labelText: "Phase 1",
//                                           suffixText: "V",
//                                         ),
//                                         textInputAction: TextInputAction.next,
//                                         keyboardType: TextInputType.number,
//                                         autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                         onChanged: (val) {
//                                           print(
//                                               val); // Print the text value write into TextField
//                                           _onChanged(
//                                               val, recFormData, 'voltagePs1');
//                                         },
//                                         validator: FormBuilderValidators.compose([
//                                           FormBuilderValidators.required(),
//                                           FormBuilderValidators.numeric(
//                                               errorText:
//                                               "Value must be \n numeric"),
//                                           FormBuilderValidators.max(1000,
//                                               inclusive: false,
//                                               errorText:
//                                               "Value should be \n less than 1000"),
//                                               (val) {
//                                             if (val == null || val.isEmpty)
//                                               return null;
//                                             final number = num.tryParse(val);
//                                             if (number == null)
//                                               return 'Must be a number';
//                                             return null;
//                                           },
//                                         ]),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                         width:
//                                         15), // Add spacing between the text fields
//                                     Expanded(
//                                       child: FormBuilderTextField(
//                                         name: 'voltagePs2',
//                                         autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                         decoration: const InputDecoration(
//                                           labelText: "Phase 2",
//                                           suffixText: "V",
//                                         ),
//                                         textInputAction: TextInputAction.next,
//                                         keyboardType: TextInputType.number,
//                                         onChanged: (val) {
//                                           print(
//                                               val); // Print the text value write into TextField
//                                           _onChanged(
//                                               val, recFormData, 'voltagePs2');
//                                         },
//                                         validator: FormBuilderValidators.compose([
//                                           FormBuilderValidators.required(),
//                                           FormBuilderValidators.numeric(
//                                               errorText:
//                                               "Value must be \n numeric"),
//                                           FormBuilderValidators.max(1000,
//                                               inclusive: false,
//                                               errorText:
//                                               "Value should be \n less than 1000"),
//                                               (val) {
//                                             if (val == null || val.isEmpty)
//                                               return null;
//                                             final number = num.tryParse(val);
//                                             if (number == null)
//                                               return 'Must be a number';
//                                             return null;
//                                           },
//                                         ]),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                         width:
//                                         15), // Add spacing between the text fields
//                                     Expanded(
//                                       child: FormBuilderTextField(
//                                         name: 'voltagePs3',
//                                         autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                         decoration: const InputDecoration(
//                                           labelText: "Phase 3",
//                                           suffixText: "V",
//                                         ),
//                                         textInputAction: TextInputAction.next,
//                                         keyboardType: TextInputType.number,
//                                         onChanged: (val) {
//                                           print(
//                                               val); // Print the text value write into TextField
//                                           _onChanged(
//                                               val, recFormData, 'voltagePs3');
//                                         },
//                                         validator: FormBuilderValidators.compose([
//                                           FormBuilderValidators.required(),
//                                           FormBuilderValidators.numeric(
//                                               errorText:
//                                               "Value must be \n numeric"),
//                                           FormBuilderValidators.max(1000,
//                                               inclusive: false,
//                                               errorText:
//                                               "Value should be \n less than 1000"),
//                                               (val) {
//                                             if (val == null || val.isEmpty)
//                                               return null;
//                                             final number = num.tryParse(val);
//                                             if (number == null)
//                                               return 'Must be a number';
//                                             return null;
//                                           },
//                                         ]),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           const SizedBox(
//                             height: 20,
//                           ),
//
//                           /////////////////////////////////////////////////////////////
//                           ///Curren Reading
//                           const Text('2. Current Reading',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               )),
//
//                           Padding(
//                             padding: const EdgeInsets.only(left: 20),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: FormBuilderTextField(
//                                         name: 'currentPs1',
//                                         decoration: const InputDecoration(
//                                           labelText: "Phase 1",
//                                           suffixText: "A",
//                                         ),
//                                         textInputAction: TextInputAction.next,
//                                         keyboardType: TextInputType.number,
//                                         autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                         onChanged: (val) {
//                                           print(
//                                               val); // Print the text value write into TextField
//                                           _onChanged(
//                                               val, recFormData, 'currentPs1');
//                                         },
//                                         validator: FormBuilderValidators.compose([
//                                           FormBuilderValidators.required(),
//                                           FormBuilderValidators.numeric(
//                                               errorText:
//                                               "Value must be \n numeric"),
//                                           FormBuilderValidators.max(10000,
//                                               inclusive: false,
//                                               errorText:
//                                               "Value should be \n less than 10000"),
//                                               (val) {
//                                             if (val == null || val.isEmpty)
//                                               return null;
//                                             final number = num.tryParse(val);
//                                             if (number == null)
//                                               return 'Must be a number';
//                                             return null;
//                                           },
//                                         ]),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                         width:
//                                         15), // Add spacing between the text fields
//                                     Expanded(
//                                       child: FormBuilderTextField(
//                                         name: 'currentPs2',
//                                         decoration: const InputDecoration(
//                                           labelText: "Phase 2",
//                                           suffixText: "A",
//                                         ),
//                                         textInputAction: TextInputAction.next,
//                                         autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                         keyboardType: TextInputType.number,
//                                         onChanged: (val) {
//                                           print(
//                                               val); // Print the text value write into TextField
//                                           _onChanged(
//                                               val, recFormData, 'currentPs2');
//                                         },
//                                         validator: FormBuilderValidators.compose([
//                                           FormBuilderValidators.required(),
//                                           FormBuilderValidators.numeric(
//                                               errorText:
//                                               "Value must be \n numeric"),
//                                           FormBuilderValidators.max(10000,
//                                               inclusive: false,
//                                               errorText:
//                                               "Value should be  \n less than 10000"),
//                                               (val) {
//                                             if (val == null || val.isEmpty)
//                                               return null;
//                                             final number = num.tryParse(val);
//                                             if (number == null)
//                                               return 'Must be a number';
//                                             return null;
//                                           },
//                                         ]),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                         width:
//                                         15), // Add spacing between the text fields
//                                     Expanded(
//                                       child: FormBuilderTextField(
//                                         name: 'currentPs3',
//                                         decoration: const InputDecoration(
//                                           labelText: "Phase 3",
//                                           suffixText: "A",
//                                         ),
//                                         textInputAction: TextInputAction.next,
//                                         autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                         keyboardType: TextInputType.number,
//                                         onChanged: (val) {
//                                           print(
//                                               val); // Print the text value write into TextField
//                                           _onChanged(
//                                               val, recFormData, 'currentPs3');
//                                         },
//                                         validator: FormBuilderValidators.compose([
//                                           FormBuilderValidators.required(),
//                                           FormBuilderValidators.numeric(
//                                               errorText:
//                                               "Value must be \n numeric"),
//                                           FormBuilderValidators.max(10000,
//                                               inclusive: false,
//                                               errorText:
//                                               "Value should be \n less than 10000"),
//                                               (val) {
//                                             if (val == null || val.isEmpty)
//                                               return null;
//                                             final number = num.tryParse(val);
//                                             if (number == null)
//                                               return 'Must be a number';
//                                             return null;
//                                           },
//                                         ]),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           const SizedBox(
//                             height: 20,
//                           ),
//
//                           //////////////////////////////////////////////////////////////////////////
//                           ///DC Output
//                           const Text('3. DC Output',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               )),
//
//                           Padding(
//                             padding: const EdgeInsets.only(left: 20),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: FormBuilderTextField(
//                                     name: 'dcVoltage',
//                                     decoration: const InputDecoration(
//                                       labelText: "Voltage",
//                                       suffixText: "V",
//                                     ),
//                                     textInputAction: TextInputAction.next,
//                                     keyboardType: TextInputType.number,
//                                     autovalidateMode:
//                                     AutovalidateMode.onUserInteraction,
//                                     onChanged: (val) {
//                                       print(
//                                           val); // Print the text value write into TextField
//                                       _onChanged(val, recFormData, 'dcVoltage');
//                                     },
//                                     validator: FormBuilderValidators.compose([
//                                       FormBuilderValidators.required(),
//                                       FormBuilderValidators.numeric(),
//                                       FormBuilderValidators.max(100,
//                                           inclusive: false,
//                                           errorText:
//                                           "Value should be \nless than 100"),
//                                           (val) {
//                                         if (val == null || val.isEmpty) return null;
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
//                                     10), // Add spacing between the text fields
//                                 Expanded(
//                                   child: FormBuilderTextField(
//                                     name: 'dcCurrent',
//                                     decoration: const InputDecoration(
//                                       labelText: "Current",
//                                       suffixText: "A",
//                                     ),
//                                     textInputAction: TextInputAction.next,
//                                     autovalidateMode:
//                                     AutovalidateMode.onUserInteraction,
//                                     keyboardType: TextInputType.number,
//                                     onChanged: (val) {
//                                       print(
//                                           val); // Print the text value write into TextField
//                                       _onChanged(val, recFormData, 'dcCurrent');
//                                     },
//                                     validator: FormBuilderValidators.compose([
//                                       FormBuilderValidators.required(),
//                                       FormBuilderValidators.numeric(),
//                                       FormBuilderValidators.max(10000,
//                                           inclusive: false,
//                                           errorText:
//                                           "Value should be \nless than 10000"),
//                                           (val) {
//                                         if (val == null || val.isEmpty) return null;
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
//                           ),
//
//                           const SizedBox(
//                             height: 20,
//                           ),
//
//                           /////////////////////////////////////////////////////////////////////
//                           ///capacity
//                           const Text('4. Capacity',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               )),
//
//                           Padding(
//                             padding: const EdgeInsets.only(left: 20),
//                             child: Column(
//                               children: [
//                                 FormBuilderTextField(
//                                   name: 'recCapacity',
//                                   decoration: const InputDecoration(
//                                       labelText: "Capacity", suffixText: "A"),
//                                   textInputAction: TextInputAction.next,
//                                   keyboardType: TextInputType.number,
//                                   onChanged: (val) {
//                                     print(
//                                         val); // Print the text value write into TextField
//                                     _onChanged(val, recFormData, 'recCapacity');
//                                   },
//                                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                                   validator: FormBuilderValidators.compose([
//                                     FormBuilderValidators.required(),
//                                     FormBuilderValidators.numeric(),
//                                         (val) {
//                                       if (val == null || val.isEmpty) return null;
//                                       final number = num.tryParse(val);
//                                       if (number == null) return 'Must be a number';
//                                       return null;
//                                     },
//                                   ]),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//
//                           ////////////////////////////////////////////////////////////////////////////////
//                           ///Alarm Status
//                           const Text('5. Alarm Status',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               )),
//
//                           Padding(
//                               padding: const EdgeInsets.only(left: 20),
//                               child: Column(
//                                 children: [
//                                   FormBuilderChoiceChip(
//                                       autovalidateMode:
//                                       AutovalidateMode.onUserInteraction,
//                                       // decoration:
//                                       //     const InputDecoration(labelText: 'Alarm Status'),
//                                       name: 'recAlarmStatus',
//                                       initialValue: '',
//                                       selectedColor: Colors.lightBlueAccent,
//                                       validator: FormBuilderValidators.compose([
//                                         FormBuilderValidators.required(),
//                                             (value) {
//                                           if (value == 'notok' &&
//                                               (recFormData['roomTempRemark'] ==
//                                                   null ||
//                                                   recFormData['roomTempRemark']
//                                                       .isEmpty)) {
//                                             return 'Remark is required when the room temperature is High';
//                                           }
//                                           return null;
//                                         },
//                                       ]),
//                                       onChanged: (value) => _onChanged(
//                                           value, recFormData, 'recAlarmStatus'),
//                                       options: const [
//                                         FormBuilderChipOption(
//                                           value: 'ok',
//                                           child: Text("ok"),
//                                           avatar: CircleAvatar(child: Text('O')),
//                                         ),
//                                         FormBuilderChipOption(
//                                           value: 'notok',
//                                           child: Text("Not ok"),
//                                           avatar: CircleAvatar(child: Text('N')),
//                                         ),
//                                       ]),
//                                   CustomRemarkWidget(
//                                       title: "Remark",
//                                       formDataKey: "recAlarmRemark",
//                                       formData: recFormData,
//                                       formKey: _formKey,
//                                       onChangedRemark: (p0, p1) {
//                                         _onChangedRemark(p0, p1);
//                                         _formKey.currentState?.validate();
//                                       }),
//                                 ],
//                               )),
//                           const SizedBox(
//                             height: 20,
//                           ),
//
//                           //////////////////////////////////////////////////////////////////////////////
//                           ///Indicator Status
//                           const Text('6. Indicator Status',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               )),
//
//                           Padding(
//                             padding: const EdgeInsets.only(left: 20),
//                             child: Column(
//                               children: [
//                                 FormBuilderChoiceChip(
//                                     autovalidateMode:
//                                     AutovalidateMode.onUserInteraction,
//                                     // decoration: const InputDecoration(
//                                     //     labelText: 'Indicator Status'),
//                                     name: 'recIndicatorStatus',
//                                     initialValue: '',
//                                     selectedColor: Colors.lightBlueAccent,
//                                     validator: FormBuilderValidators.compose([
//                                       FormBuilderValidators.required(),
//                                           (value) {
//                                         if (value == 'not ok' &&
//                                             (recFormData['roomTempRemark'] ==
//                                                 null ||
//                                                 recFormData['roomTempRemark']
//                                                     .isEmpty)) {
//                                           return 'Remark is required when the room temperature is High';
//                                         }
//                                         return null;
//                                       },
//                                     ]),
//                                     onChanged: (value) => _onChanged(
//                                         value, recFormData, 'recIndicatorStatus'),
//                                     options: const [
//                                       FormBuilderChipOption(
//                                         value: 'ok',
//                                         child: Text("ok"),
//                                         avatar: CircleAvatar(child: Text('O')),
//                                       ),
//                                       FormBuilderChipOption(
//                                         value: 'not ok',
//                                         child: Text("Not ok"),
//                                         avatar: CircleAvatar(child: Text('N')),
//                                       ),
//                                     ]),
//                                 CustomRemarkWidget(
//                                     title: "Remark",
//                                     formDataKey: "indRemark",
//                                     formData: recFormData,
//                                     formKey: _formKey,
//                                     onChangedRemark: (p0, p1) {
//                                       _onChangedRemark(p0, p1);
//                                       _formKey.currentState?.validate();
//                                     }),
//                               ],
//                             ),
//                           ),
//
//                           const SizedBox(
//                             height: 20,
//                           ),
//
//                           FormBuilderCheckbox(
//                             name: 'accept_terms',
//                             initialValue: false,
//                             onChanged: (value) =>
//                                 _onChanged(value, recFormData, 'accept_terms'),
//                             title: RichText(
//                               text: const TextSpan(
//                                 children: [
//                                   TextSpan(
//                                     text:
//                                     'I Verify that submitted details are true and correct ',
//                                     style: TextStyle(color: Colors.black),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             validator: FormBuilderValidators.equal(
//                               true,
//                               errorText:
//                               'You must accept terms and conditions to continue',
//                             ),
//                           ),
//
//                           Row(
//                             children: <Widget>[
//                               Expanded(
//                                 child: OutlinedButton(
//                                   onPressed: () {
//                                     _formKey.currentState?.reset();
//                                   },
//                                   style: ButtonStyle(
//                                     foregroundColor:
//                                     MaterialStateProperty.all<Color>(
//                                         Colors.green),
//                                     backgroundColor:
//                                     MaterialStateProperty.all<Color>(
//                                         Colors.white24),
//                                   ),
//                                   child: const Text(
//                                     'Reset',
//                                     style: TextStyle(
//                                       color: Colors.redAccent,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 20),
//                               Expanded(
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     if (_formKey.currentState?.saveAndValidate() ??
//                                         false) {
//                                       debugPrint(
//                                           _formKey.currentState?.value.toString());
//                                       Map<String, dynamic>? formData =
//                                           _formKey.currentState?.value;
//                                       formData = formData?.map((key, value) =>
//                                           MapEntry(key, value ?? ''));
//
//                                       // String rtom = _formKey.currentState?.value['Rtom_name'];
//                                       // debugPrint('RTOM value: $rtom');
//                                       //pass _formkey.currenState.value to a page called httpPostGen
//
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 httpPostRectifierInspection(
//                                                   formData: recFormData,
//                                                   recId: widget.RectifierUnit['RecID'],
//                                                   userAccess: userAccess,
//                                                   region: widget.region,
//                                                 )),
//                                       );
//                                     } else {
//                                       debugPrint(
//                                           _formKey.currentState?.value.toString());
//                                       debugPrint('validation failed');
//                                     }
//                                   },
//                                   child: const Text(
//                                     'Submit',
//                                     style: TextStyle(color: Colors.greenAccent),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//
//                           // Center(
//                           //   child: ElevatedButton(
//                           //     onPressed: _submitForm,
//                           //     style: ElevatedButton.styleFrom(
//                           //       foregroundColor: Colors.white,
//                           //       backgroundColor: const Color.fromARGB(
//                           //           255, 117, 175, 222), // Text color
//                           //       shadowColor: Colors.blueAccent, // Shadow color
//                           //       elevation: 5, // Elevation of the button
//                           //       padding: const EdgeInsets.symmetric(
//                           //           horizontal: 80,
//                           //           vertical: 16), // Padding inside the button
//                           //       shape: RoundedRectangleBorder(
//                           //         borderRadius:
//                           //         BorderRadius.circular(12), // Rounded corners
//                           //       ),
//                           //     ),
//                           //     child: const Text('Submit'),
//                           //   ),
//                           // ),
//                         ]))),
//           ),
//         ));
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
//   onChangedRemark;
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
//



//v2 01/07/2024
// import 'package:flutter/material.dart';
//
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:powerprox/Screens/Rectifier/RectifierRoutineInspection/httpPostRectifierInspection.dart';
// import 'package:provider/provider.dart';
//
// import '../../UserAccess.dart';
//
// class InspectionRec extends StatefulWidget {
//   final dynamic RectifierUnit;
//
//   const InspectionRec({
//     super.key,
//     this.RectifierUnit,
//   });
//
//   @override
//   State<InspectionRec> createState() => _InspectionRecState();
// }
//
// class _InspectionRecState extends State<InspectionRec> {
//   final _formKey = GlobalKey<FormBuilderState>();
//   var regions = [
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
//   //defind models
//   // var models = [
//   //   'NEC',
//   //   'BENING',
//   //   'TATA',
//   //   'SHINDENG',
//   //   'DPC',
//   //   'ZTE',
//   //   'EMERSSION',
//   //   'AEES',
//   //   'SAFT',
//   // ];
//   //Define recForm Data map
//   Map<String, dynamic> recFormData = {
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
//     debugPrint(recFormData.toString());
//     formData[fieldName] = val;
//   }
//
//   //passing data in remark
//   void _onChangedRemark(dynamic val, Map<String, dynamic> formData) {
//     debugPrint(val.toString());
//     debugPrint(recFormData.toString());
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
//   //
//   //   if (_formKey.currentState!.saveAndValidate()) {
//   //     // Navigate to httpMaintenancePost.dart with the form data
//   //     _formKey.currentState!.save(); // Save form data
//   //     debugPrint(
//   //         "Form Data: ${recFormData.toString()}"); // Debug print the form data
//   //
//   //     Navigator.push(
//   //       context,
//   //       MaterialPageRoute(
//   //         builder: (context) => httpPostRectifierInspection(
//   //             formData: recFormData, recId: widget.RectifierUnit['RecID'], userAccess: userAccess, ),
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
//     UserAccess userAccess = Provider.of<UserAccess>(context,
//         listen:
//         true); // Use listen: true to rebuild the widget when the data changes
//
//     return SafeArea(
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text("Daily Routing Checklist"),
//           ),
//           body: SingleChildScrollView(
//             child: FormBuilder(
//                 key: _formKey,
//                 onChanged: () {
//                   _formKey.currentState!.save();
//                   // Loop through all the fields and call _onChanged for each field
//                   _formKey.currentState!.fields.forEach((fieldKey, fieldState) {
//                     _onChanged(fieldState.value, recFormData, fieldKey);
//                   });
//                 },
//                 child: Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 "NOW ON :",
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 15),
//                               ),
//                               SizedBox(
//                                 width: MediaQuery.of(context).size.width * 0.1,
//                               ),
//                               Container(
//                                 width: MediaQuery.of(context).size.width * 0.6,
//                                 height: 30,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: Colors.grey.shade300),
//                                 child: Center(
//                                   child: Text(
//                                     _shift,
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold, fontSize: 15),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//
//                           //Region
//
//                           FormBuilderDropdown(
//                             name: "region",
//                             decoration: const InputDecoration(labelText: "Region"),
//                             items: regions
//                                 .map((region) => DropdownMenuItem(
//                               alignment: AlignmentDirectional.center,
//                               value: region,
//                               child: Text(region),
//                             ))
//                                 .toList(),
//                             validator: FormBuilderValidators.required(),
//                             onChanged: (val) =>
//                                 _onChanged(val, recFormData, "region"),
//                           ),
//
//                           const SizedBox(
//                             height: 10,
//                           ),
//
//                           //Get Genaral Inspectin Date
//                           const Text('Genaral Inspection',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               )),
//
//                           //Cleanliness of Room
//                           const customText(
//                             title: "Cleanliness of Room",
//                           ),
//                           FormBuilderChoiceChip<String>(
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             // decoration:
//                             //     const InputDecoration(labelText: 'Cleanliness of Room'),
//                             name: 'roomClean',
//                             initialValue: '',
//                             selectedColor: Colors.lightBlueAccent,
//                             options: const [
//                               FormBuilderChipOption(
//                                 value: 'Ok',
//                                 child: Text("Clean"),
//                                 avatar: CircleAvatar(child: Text('C')),
//                               ),
//                               FormBuilderChipOption(
//                                 value: 'Not Ok',
//                                 child: Text("Not Clean"),
//                                 avatar: CircleAvatar(child: Text('N')),
//                               ),
//                             ],
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                                   (value) {
//                                 if (value == 'Not Ok' &&
//                                     (recFormData['RoomCleanRemark'] == null ||
//                                         recFormData['RoomCleanRemark'].isEmpty)) {
//                                   return 'Remark is required when the room is not clean';
//                                 }
//                                 return null;
//                               },
//                             ]),
//                             onChanged: (val) =>
//                                 _onChanged(val, recFormData, 'roomClean'),
//                           ),
//                           CustomRemarkWidget(
//                               title: "Remark",
//                               formDataKey: "roomCleanRemark",
//                               formData: recFormData,
//                               formKey: _formKey,
//                               onChangedRemark: (p0, p1) {
//                                 _onChangedRemark(p0, p1);
//                                 _formKey.currentState?.validate();
//                               }),
//
// ////////////////////////////////////////////////////////////////////////////////
//                           //Cleanliness of Cubicles
//                           const customText(title: "Cleanliness of Cubicles"),
//                           FormBuilderChoiceChip<String>(
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             // decoration: const InputDecoration(
//                             //     labelText: 'Cleanliness of Cubicles(Dusting)'),
//                             name: 'cubicleClean',
//                             initialValue: '',
//                             selectedColor: Colors.lightBlueAccent,
//                             options: const [
//                               FormBuilderChipOption(
//                                 value: 'Ok',
//                                 child: Text("Clean"),
//                                 avatar: CircleAvatar(child: Text('C')),
//                               ),
//                               FormBuilderChipOption(
//                                 value: 'Not Ok',
//                                 child: Text("Not Clean"),
//                                 avatar: CircleAvatar(child: Text('N')),
//                               ),
//                             ],
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                                   (value) {
//                                 if (value == 'Not Ok' &&
//                                     (recFormData['CubicleCleanRemark'] == null ||
//                                         recFormData['CubicleCleanRemark']
//                                             .isEmpty)) {
//                                   return 'Remark is required when the cubicles are not clean';
//                                 }
//                                 return null;
//                               },
//                             ]),
//                             onChanged: (val) =>
//                                 _onChanged(val, recFormData, 'cubicleClean'),
//                           ),
//                           CustomRemarkWidget(
//                               title: "Remark",
//                               formDataKey: "CubicleCleanRemark",
//                               formData: recFormData,
//                               formKey: _formKey,
//                               onChangedRemark: (p0, p1) {
//                                 _onChangedRemark(p0, p1);
//                                 _formKey.currentState?.validate();
//                               }),
//
// //////////////////////////////////////////////////////////////////////////////////
//                           //Measure Room Temperature
//                           const customText(title: "Measure Room Temperature"),
//                           FormBuilderChoiceChip<String>(
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             // decoration: const InputDecoration(
//                             //     labelText: 'Measure Room Temperature'),
//                             name: 'roomTemp',
//                             initialValue: '',
//                             selectedColor: Colors.lightBlueAccent,
//                             options: const [
//                               FormBuilderChipOption(
//                                 value: 'high',
//                                 child: Text("High"),
//                                 avatar: CircleAvatar(child: Text('H')),
//                               ),
//                               FormBuilderChipOption(
//                                 value: 'Normal',
//                                 child: Text("Normal"),
//                                 avatar: CircleAvatar(child: Text('N')),
//                               ),
//                             ],
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                                   (value) {
//                                 if (value == 'high' &&
//                                     (recFormData['roomTempRemark'] == null ||
//                                         recFormData['roomTempRemark'].isEmpty)) {
//                                   return 'Remark is required when the room temperature is High';
//                                 }
//                                 return null;
//                               },
//                             ]),
//                             onChanged: (val) =>
//                                 _onChanged(val, recFormData, 'roomTemp'),
//                           ),
//                           CustomRemarkWidget(
//                               title: "Remark",
//                               formDataKey: "roomTempRemark",
//                               formData: recFormData,
//                               formKey: _formKey,
//                               onChangedRemark: (p0, p1) {
//                                 _onChangedRemark(p0, p1);
//                                 _formKey.currentState?.validate();
//                               }),
//
// ///////////////////////////////////////////////////////////////////////////////////////////
//                           //Measure Hydrogen Gas Emmission
//                           const customText(title: "Measure Hydrogen Gas Emmission"),
//                           FormBuilderChoiceChip<String>(
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             // decoration: const InputDecoration(
//                             //     labelText: 'Measure Hydrogen Gas Emmission'),
//                             name: 'h2gasEmission',
//                             initialValue: '',
//                             selectedColor: Colors.lightBlueAccent,
//                             options: const [
//                               FormBuilderChipOption(
//                                 value: 'yes',
//                                 child: Text("Yes"),
//                                 avatar: CircleAvatar(child: Text('Y')),
//                               ),
//                               FormBuilderChipOption(
//                                 value: 'No',
//                                 child: Text("No"),
//                                 avatar: CircleAvatar(child: Text('N')),
//                               ),
//                             ],
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                                   (value) {
//                                 if (value == 'yes' &&
//                                     (recFormData['h2gasEmissionRemark'] == null ||
//                                         recFormData['h2gasEmissionRemark']
//                                             .isEmpty)) {
//                                   return 'Remark is required when detect Hydrogen Emmision';
//                                 }
//                                 return null;
//                               },
//                             ]),
//                             onChanged: (val) =>
//                                 _onChanged(val, recFormData, 'h2gasEmission'),
//                           ),
//                           CustomRemarkWidget(
//                               title: "Remark",
//                               formDataKey: "h2gasEmissionRemark",
//                               formData: recFormData,
//                               formKey: _formKey,
//                               onChangedRemark: (p0, p1) {
//                                 _onChangedRemark(p0, p1);
//                                 _formKey.currentState?.validate();
//                               }),
//
// ////////////////////////////////////////////////////////////////////////////////////////
//                           //Check Main Circuit Breakers
//                           const customText(title: "Check Main Circuit Breakers"),
//                           FormBuilderChoiceChip<String>(
//                               autovalidateMode: AutovalidateMode.onUserInteraction,
//                               // decoration: const InputDecoration(
//                               //     labelText: 'Check Main Circuit Breakers'),
//                               name: 'checkMCB',
//                               initialValue: '',
//                               selectedColor: Colors.lightBlueAccent,
//                               options: const [
//                                 FormBuilderChipOption(
//                                   value: 'ok',
//                                   child: Text("ok"),
//                                   avatar: CircleAvatar(child: Text('O')),
//                                 ),
//                                 FormBuilderChipOption(
//                                   value: 'Not ok',
//                                   child: Text("Not ok"),
//                                   avatar: CircleAvatar(child: Text('N')),
//                                 ),
//                               ],
//                               validator: FormBuilderValidators.compose([
//                                 FormBuilderValidators.required(),
//                                     (value) {
//                                   if (value == 'Not ok' &&
//                                       (recFormData['checkMCBRemark'] == null ||
//                                           recFormData['checkMCBRemark'].isEmpty)) {
//                                     return 'Remark is required when MCB is not ok';
//                                   }
//                                   return null;
//                                 },
//                               ]),
//                               onChanged: (val) {
//                                 _onChanged(val, recFormData, 'checkMCB');
//                                 _formKey.currentState?.validate();
//                               }),
//                           CustomRemarkWidget(
//                               title: "Remark",
//                               formDataKey: "checkMCBRemark",
//                               formData: recFormData,
//                               formKey: _formKey,
//                               onChangedRemark: (p0, p1) {
//                                 _onChangedRemark(p0, p1);
//                                 _formKey.currentState?.validate();
//                               }),
//
// ///////////////////////////////////////////////////////////////////////////////////
//                           //DC PDB
//                           const customText(title: "DC PDB"),
//                           FormBuilderChoiceChip<String>(
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             // decoration: const InputDecoration(labelText: 'DC PDB'),
//                             name: 'dcPDB',
//                             initialValue: '',
//                             selectedColor: Colors.lightBlueAccent,
//                             options: const [
//                               FormBuilderChipOption(
//                                 value: 'ok',
//                                 child: Text("ok"),
//                                 avatar: CircleAvatar(child: Text('O')),
//                               ),
//                               FormBuilderChipOption(
//                                 value: 'Not ok',
//                                 child: Text("Not ok"),
//                                 avatar: CircleAvatar(child: Text('N')),
//                               ),
//                             ],
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                                   (value) {
//                                 if (value == 'Not ok' &&
//                                     (recFormData['dcPDBRemark'] == null ||
//                                         recFormData['dcPDBRemark'].isEmpty)) {
//                                   return 'Remark is required when the DC PDB is not ok';
//                                 }
//                                 return null;
//                               },
//                             ]),
//
//                             onChanged: (val) =>
//                                 _onChanged(val, recFormData, 'dcPDB'),
//                           ),
//                           CustomRemarkWidget(
//                               title: "Remark",
//                               formDataKey: "dcPDBRemark",
//                               formData: recFormData,
//                               formKey: _formKey,
//                               onChangedRemark: (p0, p1) {
//                                 _onChangedRemark(p0, p1);
//                                 _formKey.currentState?.validate();
//                               }),
//
// ////////////////////////////////////////////////////////////////////////////////////////////
//                           //Test Remort Alarm
//                           const customText(title: "Test Remort Alarm"),
//                           FormBuilderChoiceChip<String>(
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             // decoration:
//                             //     const InputDecoration(labelText: 'Test Remort Alarm'),
//                             name: 'remoteAlarm',
//                             initialValue: '',
//                             selectedColor: Colors.lightBlueAccent,
//                             options: const [
//                               FormBuilderChipOption(
//                                 value: 'ok',
//                                 child: Text("ok"),
//                                 avatar: CircleAvatar(child: Text('O')),
//                               ),
//                               FormBuilderChipOption(
//                                 value: 'Not ok',
//                                 child: Text("Not ok"),
//                                 avatar: CircleAvatar(child: Text('N')),
//                               ),
//                             ],
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                                   (value) {
//                                 if (value == 'Not ok' &&
//                                     (recFormData['remoteAlarmRemark'] == null ||
//                                         recFormData['remoteAlarmRemark'].isEmpty)) {
//                                   return 'Remark is required when the Remote Alarm is not ok';
//                                 }
//                                 return null;
//                               },
//                             ]),
//                             onChanged: (val) =>
//                                 _onChanged(val, recFormData, 'remoteAlarm'),
//                           ),
//                           CustomRemarkWidget(
//                               title: "Remark",
//                               formDataKey: "remoteAlarmRemark",
//                               formData: recFormData,
//                               formKey: _formKey,
//                               onChangedRemark: (p0, p1) {
//                                 _onChangedRemark(p0, p1);
//                                 _formKey.currentState?.validate();
//                               }),
//
//                           const SizedBox(
//                             height: 10,
//                           ),
//
//                           //////////////////////////////////////////////////////////////////////////////////////////
//                           const Divider(
//                             thickness: 3,
//                             color: Colors.black,
//                           ),
//
//                           //No. of Working Line
//                           FormBuilderTextField(
//                             name: 'noOfWorkingLine',
//                             decoration: const InputDecoration(
//                               labelText: "No. of Working Line",
//                             ),
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             onChanged: (val) {
//                               print(
//                                   val); // Print the text value write into TextField
//                               _onChanged(val, recFormData, 'noOfWorkingLine');
//                             },
//                             keyboardType: TextInputType.number,
//                             textInputAction: TextInputAction.next,
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                               FormBuilderValidators.max(100, inclusive: false),
//                             ]),
//                           ),
//
//                           //Capacity
//                           FormBuilderTextField(
//                             name: 'capacity',
//                             decoration: const InputDecoration(
//                                 labelText: "Capacity", suffixText: "A"),
//                             onChanged: (val) {
//                               print(
//                                   val); // Print the text value write into TextField
//                               _onChanged(val, recFormData, 'capacity');
//                             },
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             keyboardType: TextInputType.number,
//                             textInputAction: TextInputAction.next,
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                               FormBuilderValidators.numeric(),
//                                   (val) {
//                                 if (val == null || val.isEmpty) return null;
//                                 final number = num.tryParse(val);
//                                 if (number == null) return 'Must be a number';
//                                 if (number >= 9999)
//                                   return 'Value must be less than 9999';
//                                 return null;
//                               },
//                             ]),
//                           ),
//
//                           //Make Type
//                           FormBuilderTextField(
//                             name: 'type',
//                             decoration: const InputDecoration(
//                               labelText: "Make Type",
//                             ),
//                             onChanged: (val) {
//                               print(
//                                   val); // Print the text value write into TextField
//                               _onChanged(val, recFormData, 'type');
//                             },
//                             keyboardType: TextInputType.name,
//                             textInputAction: TextInputAction.next,
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                               FormBuilderValidators.maxLength(20,
//                                   errorText:
//                                   'Input must be less than 20 characters'),
//                             ]),
//                           ),
//                           const SizedBox(
//                             height: 15,
//                           ),
//
//                           const Text('Rectifier Testing',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               )),
//
//                           //////////////////////////////////////////////////////////////////////////
//                           //volatge Reading
//                           const Text('1. Voltage Reading',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               )),
//
//                           Padding(
//                             padding: const EdgeInsets.only(left: 20),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: FormBuilderTextField(
//                                         name: 'voltagePs1',
//                                         decoration: const InputDecoration(
//                                           labelText: "Phase 1",
//                                           suffixText: "V",
//                                         ),
//                                         textInputAction: TextInputAction.next,
//                                         keyboardType: TextInputType.number,
//                                         autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                         onChanged: (val) {
//                                           print(
//                                               val); // Print the text value write into TextField
//                                           _onChanged(
//                                               val, recFormData, 'voltagePs1');
//                                         },
//                                         validator: FormBuilderValidators.compose([
//                                           FormBuilderValidators.required(),
//                                           FormBuilderValidators.numeric(
//                                               errorText:
//                                               "Value must be \n numeric"),
//                                           FormBuilderValidators.max(1000,
//                                               inclusive: false,
//                                               errorText:
//                                               "Value should be \n less than 1000"),
//                                               (val) {
//                                             if (val == null || val.isEmpty)
//                                               return null;
//                                             final number = num.tryParse(val);
//                                             if (number == null)
//                                               return 'Must be a number';
//                                             return null;
//                                           },
//                                         ]),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                         width:
//                                         15), // Add spacing between the text fields
//                                     Expanded(
//                                       child: FormBuilderTextField(
//                                         name: 'voltagePs2',
//                                         autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                         decoration: const InputDecoration(
//                                           labelText: "Phase 2",
//                                           suffixText: "V",
//                                         ),
//                                         textInputAction: TextInputAction.next,
//                                         keyboardType: TextInputType.number,
//                                         onChanged: (val) {
//                                           print(
//                                               val); // Print the text value write into TextField
//                                           _onChanged(
//                                               val, recFormData, 'voltagePs2');
//                                         },
//                                         validator: FormBuilderValidators.compose([
//                                           FormBuilderValidators.required(),
//                                           FormBuilderValidators.numeric(
//                                               errorText:
//                                               "Value must be \n numeric"),
//                                           FormBuilderValidators.max(1000,
//                                               inclusive: false,
//                                               errorText:
//                                               "Value should be \n less than 1000"),
//                                               (val) {
//                                             if (val == null || val.isEmpty)
//                                               return null;
//                                             final number = num.tryParse(val);
//                                             if (number == null)
//                                               return 'Must be a number';
//                                             return null;
//                                           },
//                                         ]),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                         width:
//                                         15), // Add spacing between the text fields
//                                     Expanded(
//                                       child: FormBuilderTextField(
//                                         name: 'voltagePs3',
//                                         autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                         decoration: const InputDecoration(
//                                           labelText: "Phase 3",
//                                           suffixText: "V",
//                                         ),
//                                         textInputAction: TextInputAction.next,
//                                         keyboardType: TextInputType.number,
//                                         onChanged: (val) {
//                                           print(
//                                               val); // Print the text value write into TextField
//                                           _onChanged(
//                                               val, recFormData, 'voltagePs3');
//                                         },
//                                         validator: FormBuilderValidators.compose([
//                                           FormBuilderValidators.required(),
//                                           FormBuilderValidators.numeric(
//                                               errorText:
//                                               "Value must be \n numeric"),
//                                           FormBuilderValidators.max(1000,
//                                               inclusive: false,
//                                               errorText:
//                                               "Value should be \n less than 1000"),
//                                               (val) {
//                                             if (val == null || val.isEmpty)
//                                               return null;
//                                             final number = num.tryParse(val);
//                                             if (number == null)
//                                               return 'Must be a number';
//                                             return null;
//                                           },
//                                         ]),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           const SizedBox(
//                             height: 20,
//                           ),
//
//                           /////////////////////////////////////////////////////////////
//                           ///Curren Reading
//                           const Text('2. Current Reading',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               )),
//
//                           Padding(
//                             padding: const EdgeInsets.only(left: 20),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: FormBuilderTextField(
//                                         name: 'currentPs1',
//                                         decoration: const InputDecoration(
//                                           labelText: "Phase 1",
//                                           suffixText: "A",
//                                         ),
//                                         textInputAction: TextInputAction.next,
//                                         keyboardType: TextInputType.number,
//                                         autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                         onChanged: (val) {
//                                           print(
//                                               val); // Print the text value write into TextField
//                                           _onChanged(
//                                               val, recFormData, 'currentPs1');
//                                         },
//                                         validator: FormBuilderValidators.compose([
//                                           FormBuilderValidators.required(),
//                                           FormBuilderValidators.numeric(
//                                               errorText:
//                                               "Value must be \n numeric"),
//                                           FormBuilderValidators.max(10000,
//                                               inclusive: false,
//                                               errorText:
//                                               "Value should be \n less than 10000"),
//                                               (val) {
//                                             if (val == null || val.isEmpty)
//                                               return null;
//                                             final number = num.tryParse(val);
//                                             if (number == null)
//                                               return 'Must be a number';
//                                             return null;
//                                           },
//                                         ]),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                         width:
//                                         15), // Add spacing between the text fields
//                                     Expanded(
//                                       child: FormBuilderTextField(
//                                         name: 'currentPs2',
//                                         decoration: const InputDecoration(
//                                           labelText: "Phase 2",
//                                           suffixText: "A",
//                                         ),
//                                         textInputAction: TextInputAction.next,
//                                         autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                         keyboardType: TextInputType.number,
//                                         onChanged: (val) {
//                                           print(
//                                               val); // Print the text value write into TextField
//                                           _onChanged(
//                                               val, recFormData, 'currentPs2');
//                                         },
//                                         validator: FormBuilderValidators.compose([
//                                           FormBuilderValidators.required(),
//                                           FormBuilderValidators.numeric(
//                                               errorText:
//                                               "Value must be \n numeric"),
//                                           FormBuilderValidators.max(10000,
//                                               inclusive: false,
//                                               errorText:
//                                               "Value should be  \n less than 10000"),
//                                               (val) {
//                                             if (val == null || val.isEmpty)
//                                               return null;
//                                             final number = num.tryParse(val);
//                                             if (number == null)
//                                               return 'Must be a number';
//                                             return null;
//                                           },
//                                         ]),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                         width:
//                                         15), // Add spacing between the text fields
//                                     Expanded(
//                                       child: FormBuilderTextField(
//                                         name: 'currentPs3',
//                                         decoration: const InputDecoration(
//                                           labelText: "Phase 3",
//                                           suffixText: "A",
//                                         ),
//                                         textInputAction: TextInputAction.next,
//                                         autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                         keyboardType: TextInputType.number,
//                                         onChanged: (val) {
//                                           print(
//                                               val); // Print the text value write into TextField
//                                           _onChanged(
//                                               val, recFormData, 'currentPs3');
//                                         },
//                                         validator: FormBuilderValidators.compose([
//                                           FormBuilderValidators.required(),
//                                           FormBuilderValidators.numeric(
//                                               errorText:
//                                               "Value must be \n numeric"),
//                                           FormBuilderValidators.max(10000,
//                                               inclusive: false,
//                                               errorText:
//                                               "Value should be \n less than 10000"),
//                                               (val) {
//                                             if (val == null || val.isEmpty)
//                                               return null;
//                                             final number = num.tryParse(val);
//                                             if (number == null)
//                                               return 'Must be a number';
//                                             return null;
//                                           },
//                                         ]),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           const SizedBox(
//                             height: 20,
//                           ),
//
//                           //////////////////////////////////////////////////////////////////////////
//                           ///DC Output
//                           const Text('3. DC Output',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               )),
//
//                           Padding(
//                             padding: const EdgeInsets.only(left: 20),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: FormBuilderTextField(
//                                     name: 'dcVoltage',
//                                     decoration: const InputDecoration(
//                                       labelText: "Voltage",
//                                       suffixText: "V",
//                                     ),
//                                     textInputAction: TextInputAction.next,
//                                     keyboardType: TextInputType.number,
//                                     autovalidateMode:
//                                     AutovalidateMode.onUserInteraction,
//                                     onChanged: (val) {
//                                       print(
//                                           val); // Print the text value write into TextField
//                                       _onChanged(val, recFormData, 'dcVoltage');
//                                     },
//                                     validator: FormBuilderValidators.compose([
//                                       FormBuilderValidators.required(),
//                                       FormBuilderValidators.numeric(),
//                                       FormBuilderValidators.max(100,
//                                           inclusive: false,
//                                           errorText:
//                                           "Value should be \nless than 100"),
//                                           (val) {
//                                         if (val == null || val.isEmpty) return null;
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
//                                     10), // Add spacing between the text fields
//                                 Expanded(
//                                   child: FormBuilderTextField(
//                                     name: 'dcCurrent',
//                                     decoration: const InputDecoration(
//                                       labelText: "Current",
//                                       suffixText: "A",
//                                     ),
//                                     textInputAction: TextInputAction.next,
//                                     autovalidateMode:
//                                     AutovalidateMode.onUserInteraction,
//                                     keyboardType: TextInputType.number,
//                                     onChanged: (val) {
//                                       print(
//                                           val); // Print the text value write into TextField
//                                       _onChanged(val, recFormData, 'dcCurrent');
//                                     },
//                                     validator: FormBuilderValidators.compose([
//                                       FormBuilderValidators.required(),
//                                       FormBuilderValidators.numeric(),
//                                       FormBuilderValidators.max(10000,
//                                           inclusive: false,
//                                           errorText:
//                                           "Value should be \nless than 10000"),
//                                           (val) {
//                                         if (val == null || val.isEmpty) return null;
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
//                           ),
//
//                           const SizedBox(
//                             height: 20,
//                           ),
//
//                           /////////////////////////////////////////////////////////////////////
//                           ///capacity
//                           const Text('4. Capacity',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               )),
//
//                           Padding(
//                             padding: const EdgeInsets.only(left: 20),
//                             child: Column(
//                               children: [
//                                 FormBuilderTextField(
//                                   name: 'recCapacity',
//                                   decoration: const InputDecoration(
//                                       labelText: "Capacity", suffixText: "A"),
//                                   textInputAction: TextInputAction.next,
//                                   keyboardType: TextInputType.number,
//                                   onChanged: (val) {
//                                     print(
//                                         val); // Print the text value write into TextField
//                                     _onChanged(val, recFormData, 'recCapacity');
//                                   },
//                                   validator: FormBuilderValidators.compose([
//                                     FormBuilderValidators.required(),
//                                     FormBuilderValidators.numeric(),
//                                         (val) {
//                                       if (val == null || val.isEmpty) return null;
//                                       final number = num.tryParse(val);
//                                       if (number == null) return 'Must be a number';
//                                       return null;
//                                     },
//                                   ]),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//
//                           ////////////////////////////////////////////////////////////////////////////////
//                           ///Alarm Status
//                           const Text('5. Alarm Status',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               )),
//
//                           Padding(
//                               padding: const EdgeInsets.only(left: 20),
//                               child: Column(
//                                 children: [
//                                   FormBuilderChoiceChip(
//                                       autovalidateMode:
//                                       AutovalidateMode.onUserInteraction,
//                                       // decoration:
//                                       //     const InputDecoration(labelText: 'Alarm Status'),
//                                       name: 'recAlarmStatus',
//                                       initialValue: '',
//                                       selectedColor: Colors.lightBlueAccent,
//                                       validator: FormBuilderValidators.compose([
//                                         FormBuilderValidators.required(),
//                                             (value) {
//                                           if (value == 'notok' &&
//                                               (recFormData['roomTempRemark'] ==
//                                                   null ||
//                                                   recFormData['roomTempRemark']
//                                                       .isEmpty)) {
//                                             return 'Remark is required when the room temperature is High';
//                                           }
//                                           return null;
//                                         },
//                                       ]),
//                                       onChanged: (value) => _onChanged(
//                                           value, recFormData, 'recAlarmStatus'),
//                                       options: const [
//                                         FormBuilderChipOption(
//                                           value: 'ok',
//                                           child: Text("ok"),
//                                           avatar: CircleAvatar(child: Text('O')),
//                                         ),
//                                         FormBuilderChipOption(
//                                           value: 'notok',
//                                           child: Text("Not ok"),
//                                           avatar: CircleAvatar(child: Text('N')),
//                                         ),
//                                       ]),
//                                   CustomRemarkWidget(
//                                       title: "Remark",
//                                       formDataKey: "recAlarmRemark",
//                                       formData: recFormData,
//                                       formKey: _formKey,
//                                       onChangedRemark: (p0, p1) {
//                                         _onChangedRemark(p0, p1);
//                                         _formKey.currentState?.validate();
//                                       }),
//                                 ],
//                               )),
//                           const SizedBox(
//                             height: 20,
//                           ),
//
//                           //////////////////////////////////////////////////////////////////////////////
//                           ///Indicator Status
//                           const Text('6. Indicator Status',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               )),
//
//                           Padding(
//                             padding: const EdgeInsets.only(left: 20),
//                             child: Column(
//                               children: [
//                                 FormBuilderChoiceChip(
//                                     autovalidateMode:
//                                     AutovalidateMode.onUserInteraction,
//                                     // decoration: const InputDecoration(
//                                     //     labelText: 'Indicator Status'),
//                                     name: 'recIndicatorStatus',
//                                     initialValue: '',
//                                     selectedColor: Colors.lightBlueAccent,
//                                     validator: FormBuilderValidators.compose([
//                                       FormBuilderValidators.required(),
//                                           (value) {
//                                         if (value == 'not ok' &&
//                                             (recFormData['roomTempRemark'] ==
//                                                 null ||
//                                                 recFormData['roomTempRemark']
//                                                     .isEmpty)) {
//                                           return 'Remark is required when the room temperature is High';
//                                         }
//                                         return null;
//                                       },
//                                     ]),
//                                     onChanged: (value) => _onChanged(
//                                         value, recFormData, 'recIndicatorStatus'),
//                                     options: const [
//                                       FormBuilderChipOption(
//                                         value: 'ok',
//                                         child: Text("ok"),
//                                         avatar: CircleAvatar(child: Text('O')),
//                                       ),
//                                       FormBuilderChipOption(
//                                         value: 'not ok',
//                                         child: Text("Not ok"),
//                                         avatar: CircleAvatar(child: Text('N')),
//                                       ),
//                                     ]),
//                                 CustomRemarkWidget(
//                                     title: "Remark",
//                                     formDataKey: "indRemark",
//                                     formData: recFormData,
//                                     formKey: _formKey,
//                                     onChangedRemark: (p0, p1) {
//                                       _onChangedRemark(p0, p1);
//                                       _formKey.currentState?.validate();
//                                     }),
//                               ],
//                             ),
//                           ),
//
//                           const SizedBox(
//                             height: 20,
//                           ),
//
//                           FormBuilderCheckbox(
//                             name: 'accept_terms',
//                             initialValue: false,
//                             onChanged: (value) =>
//                                 _onChanged(value, recFormData, 'accept_terms'),
//                             title: RichText(
//                               text: const TextSpan(
//                                 children: [
//                                   TextSpan(
//                                     text:
//                                     'I Verify that submitted details are true and correct ',
//                                     style: TextStyle(color: Colors.black),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             validator: FormBuilderValidators.equal(
//                               true,
//                               errorText:
//                               'You must accept terms and conditions to continue',
//                             ),
//                           ),
//
//                           Row(
//                             children: <Widget>[
//                               Expanded(
//                                 child: OutlinedButton(
//                                   onPressed: () {
//                                     _formKey.currentState?.reset();
//                                   },
//                                   style: ButtonStyle(
//                                     foregroundColor:
//                                     MaterialStateProperty.all<Color>(
//                                         Colors.green),
//                                     backgroundColor:
//                                     MaterialStateProperty.all<Color>(
//                                         Colors.white24),
//                                   ),
//                                   child: const Text(
//                                     'Reset',
//                                     style: TextStyle(
//                                       color: Colors.redAccent,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 20),
//                               Expanded(
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     if (_formKey.currentState?.saveAndValidate() ??
//                                         false) {
//                                       debugPrint(
//                                           _formKey.currentState?.value.toString());
//                                       Map<String, dynamic>? formData =
//                                           _formKey.currentState?.value;
//                                       formData = formData?.map((key, value) =>
//                                           MapEntry(key, value ?? ''));
//
//                                       // String rtom = _formKey.currentState?.value['Rtom_name'];
//                                       // debugPrint('RTOM value: $rtom');
//                                       //pass _formkey.currenState.value to a page called httpPostGen
//
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 httpPostRectifierInspection(formData: recFormData, recId: widget.RectifierUnit['RecID'], userAccess: userAccess,
//                                                 )),
//                                       );
//                                     } else {
//                                       debugPrint(
//                                           _formKey.currentState?.value.toString());
//                                       debugPrint('validation failed');
//                                     }
//                                   },
//                                   child: const Text(
//                                     'Submit',
//                                     style: TextStyle(color: Colors.greenAccent),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//
//                           // Center(
//                           //   child: ElevatedButton(
//                           //     onPressed: _submitForm,
//                           //     style: ElevatedButton.styleFrom(
//                           //       foregroundColor: Colors.white,
//                           //       backgroundColor: const Color.fromARGB(
//                           //           255, 117, 175, 222), // Text color
//                           //       shadowColor: Colors.blueAccent, // Shadow color
//                           //       elevation: 5, // Elevation of the button
//                           //       padding: const EdgeInsets.symmetric(
//                           //           horizontal: 80,
//                           //           vertical: 16), // Padding inside the button
//                           //       shape: RoundedRectangleBorder(
//                           //         borderRadius:
//                           //         BorderRadius.circular(12), // Rounded corners
//                           //       ),
//                           //     ),
//                           //     child: const Text('Submit'),
//                           //   ),
//                           // ),
//                         ]))),
//           ),
//         ));
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
//   onChangedRemark;
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
//


//v1 01/07/2024
// import 'package:flutter/material.dart';
//
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:powerprox/Screens/Rectifier/RectifierRoutineInspection/httpPostRectifierInspection.dart';
// import 'package:provider/provider.dart';
//
// import '../../UserAccess.dart';
//
//
//
// class InspectionRec extends StatefulWidget {
//   final dynamic RectifierUnit;
//
//   const InspectionRec({
//     super.key,
//     this.RectifierUnit,
//   }) ;
//
//   @override
//   State<InspectionRec> createState() => _InspectionRecState();
// }
//
// class _InspectionRecState extends State<InspectionRec> {
//   final _formKey = GlobalKey<FormBuilderState>();
//   var regions = [
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
//   //defind models
//   // var models = [
//   //   'NEC',
//   //   'BENING',
//   //   'TATA',
//   //   'SHINDENG',
//   //   'DPC',
//   //   'ZTE',
//   //   'EMERSSION',
//   //   'AEES',
//   //   'SAFT',
//   // ];
//   //Define recForm Data map
//   Map<String, dynamic> recFormData = {
//     'clockTime': DateTime.now(),
//     'shift': "",
//   };
//   String _shift = '';
//   TimeOfDay? _selectedTime;
//
//
//
//
//
//   //save data from checklist to http file
//   void _onChanged(
//       dynamic val, Map<String, dynamic> formData, String fieldName) {
//     debugPrint(val.toString());
//     debugPrint(recFormData.toString());
//     formData[fieldName] = val;
//   }
//
//   //passing data in remark
//   void _onChangedRemark(dynamic val, Map<String, dynamic> formData) {
//     debugPrint(val.toString());
//     debugPrint(recFormData.toString());
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
//   //
//   //   if (_formKey.currentState!.saveAndValidate()) {
//   //     // Navigate to httpMaintenancePost.dart with the form data
//   //     _formKey.currentState!.save(); // Save form data
//   //     debugPrint(
//   //         "Form Data: ${recFormData.toString()}"); // Debug print the form data
//   //
//   //     Navigator.push(
//   //       context,
//   //       MaterialPageRoute(
//   //         builder: (context) => httpPostRectifierInspection(
//   //             formData: recFormData, recId: widget.RectifierUnit['RecID'], userAccess: userAccess, ),
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
//           appBar: AppBar(
//             title: const Text("Daily Routing Checklist"),
//           ),
//           body: SingleChildScrollView(
//             child: FormBuilder(
//                 key: _formKey,
//                 onChanged: () {
//                   _formKey.currentState!.save();
//                   // Loop through all the fields and call _onChanged for each field
//                   _formKey.currentState!.fields.forEach((fieldKey, fieldState) {
//                     _onChanged(fieldState.value, recFormData, fieldKey);
//                   });
//                 },
//                 child: Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 "NOW ON :",
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 15),
//                               ),
//                               SizedBox(
//                                 width: MediaQuery.of(context).size.width * 0.1,
//                               ),
//                               Container(
//                                 width: MediaQuery.of(context).size.width * 0.6,
//                                 height: 30,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: Colors.grey.shade300),
//                                 child: Center(
//                                   child: Text(
//                                     _shift,
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold, fontSize: 15),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//
//                           //Region
//
//                           FormBuilderDropdown(
//                             name: "region",
//                             decoration: const InputDecoration(labelText: "Region"),
//                             items: regions
//                                 .map((region) => DropdownMenuItem(
//                               alignment: AlignmentDirectional.center,
//                               value: region,
//                               child: Text(region),
//                             ))
//                                 .toList(),
//                             validator: FormBuilderValidators.required(),
//                             onChanged: (val) =>
//                                 _onChanged(val, recFormData, "region"),
//                           ),
//
//                           const SizedBox(
//                             height: 10,
//                           ),
//
//                           //Get Genaral Inspectin Date
//                           const Text('Genaral Inspection',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               )),
//
//                           //Cleanliness of Room
//                           const customText(
//                             title: "Cleanliness of Room",
//                           ),
//                           FormBuilderChoiceChip<String>(
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             // decoration:
//                             //     const InputDecoration(labelText: 'Cleanliness of Room'),
//                             name: 'roomClean',
//                             initialValue: '',
//                             selectedColor: Colors.lightBlueAccent,
//                             options: const [
//                               FormBuilderChipOption(
//                                 value: 'Ok',
//                                 child: Text("Clean"),
//                                 avatar: CircleAvatar(child: Text('C')),
//                               ),
//                               FormBuilderChipOption(
//                                 value: 'Not Ok',
//                                 child: Text("Not Clean"),
//                                 avatar: CircleAvatar(child: Text('N')),
//                               ),
//                             ],
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                                   (value) {
//                                 if (value == 'Not Ok' &&
//                                     (recFormData['RoomCleanRemark'] == null ||
//                                         recFormData['RoomCleanRemark'].isEmpty)) {
//                                   return 'Remark is required when the room is not clean';
//                                 }
//                                 return null;
//                               },
//                             ]),
//                             onChanged: (val) =>
//                                 _onChanged(val, recFormData, 'roomClean'),
//                           ),
//                           CustomRemarkWidget(
//                               title: "Remark",
//                               formDataKey: "roomCleanRemark",
//                               formData: recFormData,
//                               formKey: _formKey,
//                               onChangedRemark: (p0, p1) {
//                                 _onChangedRemark(p0, p1);
//                                 _formKey.currentState?.validate();
//                               }),
//
// ////////////////////////////////////////////////////////////////////////////////
//                           //Cleanliness of Cubicles
//                           const customText(title: "Cleanliness of Cubicles"),
//                           FormBuilderChoiceChip<String>(
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             // decoration: const InputDecoration(
//                             //     labelText: 'Cleanliness of Cubicles(Dusting)'),
//                             name: 'cubicleClean',
//                             initialValue: '',
//                             selectedColor: Colors.lightBlueAccent,
//                             options: const [
//                               FormBuilderChipOption(
//                                 value: 'Ok',
//                                 child: Text("Clean"),
//                                 avatar: CircleAvatar(child: Text('C')),
//                               ),
//                               FormBuilderChipOption(
//                                 value: 'Not Ok',
//                                 child: Text("Not Clean"),
//                                 avatar: CircleAvatar(child: Text('N')),
//                               ),
//                             ],
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                                   (value) {
//                                 if (value == 'Not Ok' &&
//                                     (recFormData['CubicleCleanRemark'] == null ||
//                                         recFormData['CubicleCleanRemark']
//                                             .isEmpty)) {
//                                   return 'Remark is required when the cubicles are not clean';
//                                 }
//                                 return null;
//                               },
//                             ]),
//                             onChanged: (val) =>
//                                 _onChanged(val, recFormData, 'cubicleClean'),
//                           ),
//                           CustomRemarkWidget(
//                               title: "Remark",
//                               formDataKey: "CubicleCleanRemark",
//                               formData: recFormData,
//                               formKey: _formKey,
//                               onChangedRemark: (p0, p1) {
//                                 _onChangedRemark(p0, p1);
//                                 _formKey.currentState?.validate();
//                               }),
//
// //////////////////////////////////////////////////////////////////////////////////
//                           //Measure Room Temperature
//                           const customText(title: "Measure Room Temperature"),
//                           FormBuilderChoiceChip<String>(
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             // decoration: const InputDecoration(
//                             //     labelText: 'Measure Room Temperature'),
//                             name: 'roomTemp',
//                             initialValue: '',
//                             selectedColor: Colors.lightBlueAccent,
//                             options: const [
//                               FormBuilderChipOption(
//                                 value: 'high',
//                                 child: Text("High"),
//                                 avatar: CircleAvatar(child: Text('H')),
//                               ),
//                               FormBuilderChipOption(
//                                 value: 'Normal',
//                                 child: Text("Normal"),
//                                 avatar: CircleAvatar(child: Text('N')),
//                               ),
//                             ],
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                                   (value) {
//                                 if (value == 'high' &&
//                                     (recFormData['roomTempRemark'] == null ||
//                                         recFormData['roomTempRemark'].isEmpty)) {
//                                   return 'Remark is required when the room temperature is High';
//                                 }
//                                 return null;
//                               },
//                             ]),
//                             onChanged: (val) =>
//                                 _onChanged(val, recFormData, 'roomTemp'),
//                           ),
//                           CustomRemarkWidget(
//                               title: "Remark",
//                               formDataKey: "roomTempRemark",
//                               formData: recFormData,
//                               formKey: _formKey,
//                               onChangedRemark: (p0, p1) {
//                                 _onChangedRemark(p0, p1);
//                                 _formKey.currentState?.validate();
//                               }),
//
// ///////////////////////////////////////////////////////////////////////////////////////////
//                           //Measure Hydrogen Gas Emmission
//                           const customText(title: "Measure Hydrogen Gas Emmission"),
//                           FormBuilderChoiceChip<String>(
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             // decoration: const InputDecoration(
//                             //     labelText: 'Measure Hydrogen Gas Emmission'),
//                             name: 'h2gasEmission',
//                             initialValue: '',
//                             selectedColor: Colors.lightBlueAccent,
//                             options: const [
//                               FormBuilderChipOption(
//                                 value: 'yes',
//                                 child: Text("Yes"),
//                                 avatar: CircleAvatar(child: Text('Y')),
//                               ),
//                               FormBuilderChipOption(
//                                 value: 'No',
//                                 child: Text("No"),
//                                 avatar: CircleAvatar(child: Text('N')),
//                               ),
//                             ],
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                                   (value) {
//                                 if (value == 'yes' &&
//                                     (recFormData['h2gasEmissionRemark'] == null ||
//                                         recFormData['h2gasEmissionRemark']
//                                             .isEmpty)) {
//                                   return 'Remark is required when detect Hydrogen Emmision';
//                                 }
//                                 return null;
//                               },
//                             ]),
//                             onChanged: (val) =>
//                                 _onChanged(val, recFormData, 'h2gasEmission'),
//                           ),
//                           CustomRemarkWidget(
//                               title: "Remark",
//                               formDataKey: "h2gasEmissionRemark",
//                               formData: recFormData,
//                               formKey: _formKey,
//                               onChangedRemark: (p0, p1) {
//                                 _onChangedRemark(p0, p1);
//                                 _formKey.currentState?.validate();
//                               }),
//
// ////////////////////////////////////////////////////////////////////////////////////////
//                           //Check Main Circuit Breakers
//                           const customText(title: "Check Main Circuit Breakers"),
//                           FormBuilderChoiceChip<String>(
//                               autovalidateMode: AutovalidateMode.onUserInteraction,
//                               // decoration: const InputDecoration(
//                               //     labelText: 'Check Main Circuit Breakers'),
//                               name: 'checkMCB',
//                               initialValue: '',
//                               selectedColor: Colors.lightBlueAccent,
//                               options: const [
//                                 FormBuilderChipOption(
//                                   value: 'ok',
//                                   child: Text("ok"),
//                                   avatar: CircleAvatar(child: Text('O')),
//                                 ),
//                                 FormBuilderChipOption(
//                                   value: 'Not ok',
//                                   child: Text("Not ok"),
//                                   avatar: CircleAvatar(child: Text('N')),
//                                 ),
//                               ],
//                               validator: FormBuilderValidators.compose([
//                                 FormBuilderValidators.required(),
//                                     (value) {
//                                   if (value == 'Not ok' &&
//                                       (recFormData['checkMCBRemark'] == null ||
//                                           recFormData['checkMCBRemark'].isEmpty)) {
//                                     return 'Remark is required when MCB is not ok';
//                                   }
//                                   return null;
//                                 },
//                               ]),
//                               onChanged: (val) {
//                                 _onChanged(val, recFormData, 'checkMCB');
//                                 _formKey.currentState?.validate();
//                               }),
//                           CustomRemarkWidget(
//                               title: "Remark",
//                               formDataKey: "checkMCBRemark",
//                               formData: recFormData,
//                               formKey: _formKey,
//                               onChangedRemark: (p0, p1) {
//                                 _onChangedRemark(p0, p1);
//                                 _formKey.currentState?.validate();
//                               }),
//
// ///////////////////////////////////////////////////////////////////////////////////
//                           //DC PDB
//                           const customText(title: "DC PDB"),
//                           FormBuilderChoiceChip<String>(
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             // decoration: const InputDecoration(labelText: 'DC PDB'),
//                             name: 'dcPDB',
//                             initialValue: '',
//                             selectedColor: Colors.lightBlueAccent,
//                             options: const [
//                               FormBuilderChipOption(
//                                 value: 'ok',
//                                 child: Text("ok"),
//                                 avatar: CircleAvatar(child: Text('O')),
//                               ),
//                               FormBuilderChipOption(
//                                 value: 'Not ok',
//                                 child: Text("Not ok"),
//                                 avatar: CircleAvatar(child: Text('N')),
//                               ),
//                             ],
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                                   (value) {
//                                 if (value == 'Not ok' &&
//                                     (recFormData['dcPDBRemark'] == null ||
//                                         recFormData['dcPDBRemark'].isEmpty)) {
//                                   return 'Remark is required when the DC PDB is not ok';
//                                 }
//                                 return null;
//                               },
//                             ]),
//
//                             onChanged: (val) =>
//                                 _onChanged(val, recFormData, 'dcPDB'),
//                           ),
//                           CustomRemarkWidget(
//                               title: "Remark",
//                               formDataKey: "dcPDBRemark",
//                               formData: recFormData,
//                               formKey: _formKey,
//                               onChangedRemark: (p0, p1) {
//                                 _onChangedRemark(p0, p1);
//                                 _formKey.currentState?.validate();
//                               }),
//
// ////////////////////////////////////////////////////////////////////////////////////////////
//                           //Test Remort Alarm
//                           const customText(title: "Test Remort Alarm"),
//                           FormBuilderChoiceChip<String>(
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             // decoration:
//                             //     const InputDecoration(labelText: 'Test Remort Alarm'),
//                             name: 'remoteAlarm',
//                             initialValue: '',
//                             selectedColor: Colors.lightBlueAccent,
//                             options: const [
//                               FormBuilderChipOption(
//                                 value: 'ok',
//                                 child: Text("ok"),
//                                 avatar: CircleAvatar(child: Text('O')),
//                               ),
//                               FormBuilderChipOption(
//                                 value: 'Not ok',
//                                 child: Text("Not ok"),
//                                 avatar: CircleAvatar(child: Text('N')),
//                               ),
//                             ],
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                                   (value) {
//                                 if (value == 'Not ok' &&
//                                     (recFormData['remoteAlarmRemark'] == null ||
//                                         recFormData['remoteAlarmRemark'].isEmpty)) {
//                                   return 'Remark is required when the Remote Alarm is not ok';
//                                 }
//                                 return null;
//                               },
//                             ]),
//                             onChanged: (val) =>
//                                 _onChanged(val, recFormData, 'remoteAlarm'),
//                           ),
//                           CustomRemarkWidget(
//                               title: "Remark",
//                               formDataKey: "remoteAlarmRemark",
//                               formData: recFormData,
//                               formKey: _formKey,
//                               onChangedRemark: (p0, p1) {
//                                 _onChangedRemark(p0, p1);
//                                 _formKey.currentState?.validate();
//                               }),
//
//                           const SizedBox(
//                             height: 10,
//                           ),
//
//                           //////////////////////////////////////////////////////////////////////////////////////////
//                           const Divider(
//                             thickness: 3,
//                             color: Colors.black,
//                           ),
//
//                           //No. of Working Line
//                           FormBuilderTextField(
//                             name: 'noOfWorkingLine',
//                             decoration: const InputDecoration(
//                               labelText: "No. of Working Line",
//                             ),
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             onChanged: (val) {
//                               print(
//                                   val); // Print the text value write into TextField
//                               _onChanged(val, recFormData, 'noOfWorkingLine');
//                             },
//                             keyboardType: TextInputType.number,
//                             textInputAction: TextInputAction.next,
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                               FormBuilderValidators.max(100, inclusive: false),
//                             ]),
//                           ),
//
//                           //Capacity
//                           FormBuilderTextField(
//                             name: 'capacity',
//                             decoration: const InputDecoration(
//                                 labelText: "Capacity", suffixText: "A"),
//                             onChanged: (val) {
//                               print(
//                                   val); // Print the text value write into TextField
//                               _onChanged(val, recFormData, 'capacity');
//                             },
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             keyboardType: TextInputType.number,
//                             textInputAction: TextInputAction.next,
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                               FormBuilderValidators.numeric(),
//                                   (val) {
//                                 if (val == null || val.isEmpty) return null;
//                                 final number = num.tryParse(val);
//                                 if (number == null) return 'Must be a number';
//                                 if (number >= 9999)
//                                   return 'Value must be less than 9999';
//                                 return null;
//                               },
//                             ]),
//                           ),
//
//                           //Make Type
//                           FormBuilderTextField(
//                             name: 'type',
//                             decoration: const InputDecoration(
//                               labelText: "Make Type",
//                             ),
//                             onChanged: (val) {
//                               print(
//                                   val); // Print the text value write into TextField
//                               _onChanged(val, recFormData, 'type');
//                             },
//                             keyboardType: TextInputType.name,
//                             textInputAction: TextInputAction.next,
//                             autovalidateMode: AutovalidateMode.onUserInteraction,
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(),
//                               FormBuilderValidators.maxLength(20,
//                                   errorText:
//                                   'Input must be less than 20 characters'),
//                             ]),
//                           ),
//                           const SizedBox(
//                             height: 15,
//                           ),
//
//                           const Text('Rectifier Testing',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               )),
//
//                           //////////////////////////////////////////////////////////////////////////
//                           //volatge Reading
//                           const Text('1. Voltage Reading',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               )),
//
//                           Padding(
//                             padding: const EdgeInsets.only(left: 20),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: FormBuilderTextField(
//                                         name: 'voltagePs1',
//                                         decoration: const InputDecoration(
//                                           labelText: "Phase 1",
//                                           suffixText: "V",
//                                         ),
//                                         textInputAction: TextInputAction.next,
//                                         keyboardType: TextInputType.number,
//                                         autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                         onChanged: (val) {
//                                           print(
//                                               val); // Print the text value write into TextField
//                                           _onChanged(
//                                               val, recFormData, 'voltagePs1');
//                                         },
//                                         validator: FormBuilderValidators.compose([
//                                           FormBuilderValidators.required(),
//                                           FormBuilderValidators.numeric(
//                                               errorText:
//                                               "Value must be \n numeric"),
//                                           FormBuilderValidators.max(1000,
//                                               inclusive: false,
//                                               errorText:
//                                               "Value should be \n less than 1000"),
//                                               (val) {
//                                             if (val == null || val.isEmpty)
//                                               return null;
//                                             final number = num.tryParse(val);
//                                             if (number == null)
//                                               return 'Must be a number';
//                                             return null;
//                                           },
//                                         ]),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                         width:
//                                         15), // Add spacing between the text fields
//                                     Expanded(
//                                       child: FormBuilderTextField(
//                                         name: 'voltagePs2',
//                                         autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                         decoration: const InputDecoration(
//                                           labelText: "Phase 2",
//                                           suffixText: "V",
//                                         ),
//                                         textInputAction: TextInputAction.next,
//                                         keyboardType: TextInputType.number,
//                                         onChanged: (val) {
//                                           print(
//                                               val); // Print the text value write into TextField
//                                           _onChanged(
//                                               val, recFormData, 'voltagePs2');
//                                         },
//                                         validator: FormBuilderValidators.compose([
//                                           FormBuilderValidators.required(),
//                                           FormBuilderValidators.numeric(
//                                               errorText:
//                                               "Value must be \n numeric"),
//                                           FormBuilderValidators.max(1000,
//                                               inclusive: false,
//                                               errorText:
//                                               "Value should be \n less than 1000"),
//                                               (val) {
//                                             if (val == null || val.isEmpty)
//                                               return null;
//                                             final number = num.tryParse(val);
//                                             if (number == null)
//                                               return 'Must be a number';
//                                             return null;
//                                           },
//                                         ]),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                         width:
//                                         15), // Add spacing between the text fields
//                                     Expanded(
//                                       child: FormBuilderTextField(
//                                         name: 'voltagePs3',
//                                         autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                         decoration: const InputDecoration(
//                                           labelText: "Phase 3",
//                                           suffixText: "V",
//                                         ),
//                                         textInputAction: TextInputAction.next,
//                                         keyboardType: TextInputType.number,
//                                         onChanged: (val) {
//                                           print(
//                                               val); // Print the text value write into TextField
//                                           _onChanged(
//                                               val, recFormData, 'voltagePs3');
//                                         },
//                                         validator: FormBuilderValidators.compose([
//                                           FormBuilderValidators.required(),
//                                           FormBuilderValidators.numeric(
//                                               errorText:
//                                               "Value must be \n numeric"),
//                                           FormBuilderValidators.max(1000,
//                                               inclusive: false,
//                                               errorText:
//                                               "Value should be \n less than 1000"),
//                                               (val) {
//                                             if (val == null || val.isEmpty)
//                                               return null;
//                                             final number = num.tryParse(val);
//                                             if (number == null)
//                                               return 'Must be a number';
//                                             return null;
//                                           },
//                                         ]),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           const SizedBox(
//                             height: 20,
//                           ),
//
//                           /////////////////////////////////////////////////////////////
//                           ///Curren Reading
//                           const Text('2. Current Reading',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               )),
//
//                           Padding(
//                             padding: const EdgeInsets.only(left: 20),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: FormBuilderTextField(
//                                         name: 'currentPs1',
//                                         decoration: const InputDecoration(
//                                           labelText: "Phase 1",
//                                           suffixText: "A",
//                                         ),
//                                         textInputAction: TextInputAction.next,
//                                         keyboardType: TextInputType.number,
//                                         autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                         onChanged: (val) {
//                                           print(
//                                               val); // Print the text value write into TextField
//                                           _onChanged(
//                                               val, recFormData, 'currentPs1');
//                                         },
//                                         validator: FormBuilderValidators.compose([
//                                           FormBuilderValidators.required(),
//                                           FormBuilderValidators.numeric(
//                                               errorText:
//                                               "Value must be \n numeric"),
//                                           FormBuilderValidators.max(10000,
//                                               inclusive: false,
//                                               errorText:
//                                               "Value should be \n less than 10000"),
//                                               (val) {
//                                             if (val == null || val.isEmpty)
//                                               return null;
//                                             final number = num.tryParse(val);
//                                             if (number == null)
//                                               return 'Must be a number';
//                                             return null;
//                                           },
//                                         ]),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                         width:
//                                         15), // Add spacing between the text fields
//                                     Expanded(
//                                       child: FormBuilderTextField(
//                                         name: 'currentPs2',
//                                         decoration: const InputDecoration(
//                                           labelText: "Phase 2",
//                                           suffixText: "A",
//                                         ),
//                                         textInputAction: TextInputAction.next,
//                                         autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                         keyboardType: TextInputType.number,
//                                         onChanged: (val) {
//                                           print(
//                                               val); // Print the text value write into TextField
//                                           _onChanged(
//                                               val, recFormData, 'currentPs2');
//                                         },
//                                         validator: FormBuilderValidators.compose([
//                                           FormBuilderValidators.required(),
//                                           FormBuilderValidators.numeric(
//                                               errorText:
//                                               "Value must be \n numeric"),
//                                           FormBuilderValidators.max(10000,
//                                               inclusive: false,
//                                               errorText:
//                                               "Value should be  \n less than 10000"),
//                                               (val) {
//                                             if (val == null || val.isEmpty)
//                                               return null;
//                                             final number = num.tryParse(val);
//                                             if (number == null)
//                                               return 'Must be a number';
//                                             return null;
//                                           },
//                                         ]),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                         width:
//                                         15), // Add spacing between the text fields
//                                     Expanded(
//                                       child: FormBuilderTextField(
//                                         name: 'currentPs3',
//                                         decoration: const InputDecoration(
//                                           labelText: "Phase 3",
//                                           suffixText: "A",
//                                         ),
//                                         textInputAction: TextInputAction.next,
//                                         autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                         keyboardType: TextInputType.number,
//                                         onChanged: (val) {
//                                           print(
//                                               val); // Print the text value write into TextField
//                                           _onChanged(
//                                               val, recFormData, 'currentPs3');
//                                         },
//                                         validator: FormBuilderValidators.compose([
//                                           FormBuilderValidators.required(),
//                                           FormBuilderValidators.numeric(
//                                               errorText:
//                                               "Value must be \n numeric"),
//                                           FormBuilderValidators.max(10000,
//                                               inclusive: false,
//                                               errorText:
//                                               "Value should be \n less than 10000"),
//                                               (val) {
//                                             if (val == null || val.isEmpty)
//                                               return null;
//                                             final number = num.tryParse(val);
//                                             if (number == null)
//                                               return 'Must be a number';
//                                             return null;
//                                           },
//                                         ]),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           const SizedBox(
//                             height: 20,
//                           ),
//
//                           //////////////////////////////////////////////////////////////////////////
//                           ///DC Output
//                           const Text('3. DC Output',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               )),
//
//                           Padding(
//                             padding: const EdgeInsets.only(left: 20),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: FormBuilderTextField(
//                                     name: 'dcVoltage',
//                                     decoration: const InputDecoration(
//                                       labelText: "Voltage",
//                                       suffixText: "V",
//                                     ),
//                                     textInputAction: TextInputAction.next,
//                                     keyboardType: TextInputType.number,
//                                     autovalidateMode:
//                                     AutovalidateMode.onUserInteraction,
//                                     onChanged: (val) {
//                                       print(
//                                           val); // Print the text value write into TextField
//                                       _onChanged(val, recFormData, 'dcVoltage');
//                                     },
//                                     validator: FormBuilderValidators.compose([
//                                       FormBuilderValidators.required(),
//                                       FormBuilderValidators.numeric(),
//                                       FormBuilderValidators.max(100,
//                                           inclusive: false,
//                                           errorText:
//                                           "Value should be \nless than 100"),
//                                           (val) {
//                                         if (val == null || val.isEmpty) return null;
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
//                                     10), // Add spacing between the text fields
//                                 Expanded(
//                                   child: FormBuilderTextField(
//                                     name: 'dcCurrent',
//                                     decoration: const InputDecoration(
//                                       labelText: "Current",
//                                       suffixText: "A",
//                                     ),
//                                     textInputAction: TextInputAction.next,
//                                     autovalidateMode:
//                                     AutovalidateMode.onUserInteraction,
//                                     keyboardType: TextInputType.number,
//                                     onChanged: (val) {
//                                       print(
//                                           val); // Print the text value write into TextField
//                                       _onChanged(val, recFormData, 'dcCurrent');
//                                     },
//                                     validator: FormBuilderValidators.compose([
//                                       FormBuilderValidators.required(),
//                                       FormBuilderValidators.numeric(),
//                                       FormBuilderValidators.max(10000,
//                                           inclusive: false,
//                                           errorText:
//                                           "Value should be \nless than 10000"),
//                                           (val) {
//                                         if (val == null || val.isEmpty) return null;
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
//                           ),
//
//                           const SizedBox(
//                             height: 20,
//                           ),
//
//                           /////////////////////////////////////////////////////////////////////
//                           ///capacity
//                           const Text('4. Capacity',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               )),
//
//                           Padding(
//                             padding: const EdgeInsets.only(left: 20),
//                             child: Column(
//                               children: [
//                                 FormBuilderTextField(
//                                   name: 'recCapacity',
//                                   decoration: const InputDecoration(
//                                       labelText: "Capacity", suffixText: "A"),
//                                   textInputAction: TextInputAction.next,
//                                   keyboardType: TextInputType.number,
//                                   onChanged: (val) {
//                                     print(
//                                         val); // Print the text value write into TextField
//                                     _onChanged(val, recFormData, 'recCapacity');
//                                   },
//                                   validator: FormBuilderValidators.compose([
//                                     FormBuilderValidators.required(),
//                                     FormBuilderValidators.numeric(),
//                                         (val) {
//                                       if (val == null || val.isEmpty) return null;
//                                       final number = num.tryParse(val);
//                                       if (number == null) return 'Must be a number';
//                                       return null;
//                                     },
//                                   ]),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//
//                           ////////////////////////////////////////////////////////////////////////////////
//                           ///Alarm Status
//                           const Text('5. Alarm Status',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               )),
//
//                           Padding(
//                               padding: const EdgeInsets.only(left: 20),
//                               child: Column(
//                                 children: [
//                                   FormBuilderChoiceChip(
//                                       autovalidateMode:
//                                       AutovalidateMode.onUserInteraction,
//                                       // decoration:
//                                       //     const InputDecoration(labelText: 'Alarm Status'),
//                                       name: 'recAlarmStatus',
//                                       initialValue: '',
//                                       selectedColor: Colors.lightBlueAccent,
//                                       validator: FormBuilderValidators.compose([
//                                         FormBuilderValidators.required(),
//                                             (value) {
//                                           if (value == 'notok' &&
//                                               (recFormData['roomTempRemark'] ==
//                                                   null ||
//                                                   recFormData['roomTempRemark']
//                                                       .isEmpty)) {
//                                             return 'Remark is required when the room temperature is High';
//                                           }
//                                           return null;
//                                         },
//                                       ]),
//                                       onChanged: (value) => _onChanged(
//                                           value, recFormData, 'recAlarmStatus'),
//                                       options: const [
//                                         FormBuilderChipOption(
//                                           value: 'ok',
//                                           child: Text("ok"),
//                                           avatar: CircleAvatar(child: Text('O')),
//                                         ),
//                                         FormBuilderChipOption(
//                                           value: 'notok',
//                                           child: Text("Not ok"),
//                                           avatar: CircleAvatar(child: Text('N')),
//                                         ),
//                                       ]),
//                                   CustomRemarkWidget(
//                                       title: "Remark",
//                                       formDataKey: "recAlarmRemark",
//                                       formData: recFormData,
//                                       formKey: _formKey,
//                                       onChangedRemark: (p0, p1) {
//                                         _onChangedRemark(p0, p1);
//                                         _formKey.currentState?.validate();
//                                       }),
//                                 ],
//                               )),
//                           const SizedBox(
//                             height: 20,
//                           ),
//
//                           //////////////////////////////////////////////////////////////////////////////
//                           ///Indicator Status
//                           const Text('6. Indicator Status',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               )),
//
//                           Padding(
//                             padding: const EdgeInsets.only(left: 20),
//                             child: Column(
//                               children: [
//                                 FormBuilderChoiceChip(
//                                     autovalidateMode:
//                                     AutovalidateMode.onUserInteraction,
//                                     // decoration: const InputDecoration(
//                                     //     labelText: 'Indicator Status'),
//                                     name: 'recIndicatorStatus',
//                                     initialValue: '',
//                                     selectedColor: Colors.lightBlueAccent,
//                                     validator: FormBuilderValidators.compose([
//                                       FormBuilderValidators.required(),
//                                           (value) {
//                                         if (value == 'not ok' &&
//                                             (recFormData['roomTempRemark'] ==
//                                                 null ||
//                                                 recFormData['roomTempRemark']
//                                                     .isEmpty)) {
//                                           return 'Remark is required when the room temperature is High';
//                                         }
//                                         return null;
//                                       },
//                                     ]),
//                                     onChanged: (value) => _onChanged(
//                                         value, recFormData, 'recIndicatorStatus'),
//                                     options: const [
//                                       FormBuilderChipOption(
//                                         value: 'ok',
//                                         child: Text("ok"),
//                                         avatar: CircleAvatar(child: Text('O')),
//                                       ),
//                                       FormBuilderChipOption(
//                                         value: 'not ok',
//                                         child: Text("Not ok"),
//                                         avatar: CircleAvatar(child: Text('N')),
//                                       ),
//                                     ]),
//                                 CustomRemarkWidget(
//                                     title: "Remark",
//                                     formDataKey: "indRemark",
//                                     formData: recFormData,
//                                     formKey: _formKey,
//                                     onChangedRemark: (p0, p1) {
//                                       _onChangedRemark(p0, p1);
//                                       _formKey.currentState?.validate();
//                                     }),
//                               ],
//                             ),
//                           ),
//
//                           const SizedBox(
//                             height: 20,
//                           ),
//
//                           FormBuilderCheckbox(
//                             name: 'accept_terms',
//                             initialValue: false,
//                             onChanged:  (value) => _onChanged(
//                     value, recFormData, 'accept_terms'),
//
//                             title: RichText(
//                               text: const TextSpan(
//                                 children: [
//                                   TextSpan(
//                                     text: 'I Verify that submitted details are true and correct ',
//                                     style: TextStyle(color: Colors.black),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             validator: FormBuilderValidators.equal(
//                               true,
//                               errorText:
//                               'You must accept terms and conditions to continue',
//                             ),
//                           ),
//
//                           Row(
//                             children: <Widget>[
//                               Expanded(
//                                 child: OutlinedButton(
//                                   onPressed: () {
//                                     _formKey.currentState?.reset();
//                                   },
//                                   style: ButtonStyle(
//                                     foregroundColor: MaterialStateProperty.all<Color>(
//                                         Colors.green),
//                                     backgroundColor: MaterialStateProperty.all<Color>(
//                                         Colors.white24),
//                                   ),
//                                   child: const Text(
//                                     'Reset',
//                                     style: TextStyle(
//                                       color: Colors.redAccent,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//
//                               const SizedBox(width: 20),
//                               Expanded(
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     if (_formKey.currentState?.saveAndValidate() ?? false) {
//                                       debugPrint(_formKey.currentState?.value.toString());
//                                       Map<String, dynamic> ? formData = _formKey
//                                           .currentState?.value;
//                                       formData = formData?.map((key, value) =>
//                                           MapEntry(key, value ?? ''));
//
//                                       // String rtom = _formKey.currentState?.value['Rtom_name'];
//                                       // debugPrint('RTOM value: $rtom');
//                                       //pass _formkey.currenState.value to a page called httpPostGen
//
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(builder: (context) =>
//                                             httpPostRectifierInspection(formData: recFormData, recId: widget.RectifierUnit['RecID'], userAccess: userAccess,  )),
//                                       );
//                                     } else {
//                                       debugPrint(_formKey.currentState?.value.toString());
//                                       debugPrint('validation failed');
//                                     }
//                                   },
//
//                                   child: const Text(
//                                     'Submit',
//                                     style: TextStyle(color: Colors.greenAccent),
//                                   ),
//                                 ),
//                               ),
//
//                             ],
//                           ),
//
//                           // Center(
//                           //   child: ElevatedButton(
//                           //     onPressed: _submitForm,
//                           //     style: ElevatedButton.styleFrom(
//                           //       foregroundColor: Colors.white,
//                           //       backgroundColor: const Color.fromARGB(
//                           //           255, 117, 175, 222), // Text color
//                           //       shadowColor: Colors.blueAccent, // Shadow color
//                           //       elevation: 5, // Elevation of the button
//                           //       padding: const EdgeInsets.symmetric(
//                           //           horizontal: 80,
//                           //           vertical: 16), // Padding inside the button
//                           //       shape: RoundedRectangleBorder(
//                           //         borderRadius:
//                           //         BorderRadius.circular(12), // Rounded corners
//                           //       ),
//                           //     ),
//                           //     child: const Text('Submit'),
//                           //   ),
//                           // ),
//                         ]))),
//           ),
//         ));
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
//   onChangedRemark;
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
