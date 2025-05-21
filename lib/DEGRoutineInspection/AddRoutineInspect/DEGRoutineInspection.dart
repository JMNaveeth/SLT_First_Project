
import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

//import '../../../UserAccess.dart';
import 'httpPostDEGInspection.dart';

String? username = "John Doe";

class DEGRoutineInspection extends StatefulWidget {
  final dynamic DEGUnit;


  const DEGRoutineInspection({
    super.key,
    required this.DEGUnit,
  });

  @override
  State<DEGRoutineInspection> createState() => _DEGRoutineInspectionState();
}

class _DEGRoutineInspectionState extends State<DEGRoutineInspection> {
  final _formKey = GlobalKey<FormBuilderState>();

  //Define degForm Data map
  Map<String, dynamic> degFormData = {
    'clockTime': DateTime.now(),
    'shift': "",
  };
  String _shift = '';
  TimeOfDay? _selectedTime;

  //save data from checklist to http file
  void _onChanged(
      dynamic val, Map<String, dynamic> formData, String fieldName) {
    debugPrint(val.toString());
    debugPrint(degFormData.toString());
    formData[fieldName] = val;
  }

  //passing data in remark
  void _onChangedRemark(dynamic val, Map<String, dynamic> formData) {
    debugPrint(val.toString());
    debugPrint(degFormData.toString());
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


  @override
  void initState() {
    super.initState();
    _selectedTime = TimeOfDay.now();
    _shift = _determineShift(_selectedTime!);
    // recFormData['shift'] = _shift;
  }

  @override
  Widget build(BuildContext context) {
   // UserAccess userAccess = Provider.of<UserAccess>(context, listen: true); // Use listen: true to rebuild the widget when the data changes

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Daily Routine Checklist"),
          ),
          body: SingleChildScrollView(
            child: FormBuilder(
                key: _formKey,
                onChanged: () {
                  _formKey.currentState!.save();
                  // Loop through all the fields and call _onChanged for each field
                  _formKey.currentState!.fields.forEach((fieldKey, fieldState) {
                    _onChanged(fieldState.value, degFormData, fieldKey);
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
                              const Text(
                                "NOW ON :",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade300),
                                child: Center(
                                  child: Text(
                                    _shift,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),

                          //REgion
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Region :",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              ),
                              Spacer(),
                              Text(
                                widget.DEGUnit['Rtom_name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 5,
                          ),

                          //QR TAG ID
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "QR Tag ID :",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              ),
                              Spacer(),
                              Text(
                                widget.DEGUnit['station'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ],
                          ),



                          const SizedBox(
                            height: 10,
                          ),

                          //Get Genaral Inspectin Date
                          const Text('01. Genaral Inspection',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),

                          //Check Cleanliness of the DEG
                          const customText(
                            title: "Check Cleanliness of the DEG",
                          ),
                          FormBuilderChoiceChips<String>(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            name: ' degClean',
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
                                    (degFormData['degCleanRemark'] == null ||
                                        degFormData['degCleanRemark'].isEmpty)) {
                                  return 'Remark is required when DEG cleanliness not ok';
                                }
                                return null;
                              },
                            ]),
                            onChanged: (val) =>
                                _onChanged(val, degFormData, 'degClean'),
                          ),
                          CustomRemarkWidget(
                              title: "Remark",
                              formDataKey: "degCleanRemark",
                              formData: degFormData,
                              formKey: _formKey,
                              onChangedRemark: (p0, p1) {
                                _onChangedRemark(p0, p1);
                                _formKey.currentState?.validate();
                              }),

                          ////////////////////////////////////////////////////////////////////////////////
                          //Check Cleanliness surrounding the \nDesel tank/Pump
                          const customText(
                              title:
                              "Check Cleanliness surrounding the \nDesel tank/Pump"),
                          FormBuilderChoiceChips<String>(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            name: 'surroundClean',
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
                                    (degFormData['surroundCleanRemark'] == null ||
                                        degFormData['surroundCleanRemark']
                                            .isEmpty)) {
                                  return 'Remark is required when Surrounding Cleanliness Not Ok';
                                }
                                return null;
                              },
                            ]),
                            onChanged: (val) =>
                                _onChanged(val, degFormData, 'surroundClean'),
                          ),
                          CustomRemarkWidget(
                              title: "Remark",
                              formDataKey: "surroundCleanRemark",
                              formData: degFormData,
                              formKey: _formKey,
                              onChangedRemark: (p0, p1) {
                                _onChangedRemark(p0, p1);
                                _formKey.currentState?.validate();
                              }),

                          //Check Condition of V - belts
                          const customText(title: "Check Condition of V - belts"),
                          FormBuilderChoiceChips<String>(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            name: 'vbelt',
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
                                    (degFormData['vbeltRemark'] == null ||
                                        degFormData['vbeltRemark'].isEmpty)) {
                                  return 'Remark is required when V - belts are Not Ok';
                                }
                                return null;
                              },
                            ]),
                            onChanged: (val) =>
                                _onChanged(val, degFormData, 'vbelt'),
                          ),
                          CustomRemarkWidget(
                              title: "Remark",
                              formDataKey: "vbeltRemark",
                              formData: degFormData,
                              formKey: _formKey,
                              onChangedRemark: (p0, p1) {
                                _onChangedRemark(p0, p1);
                                _formKey.currentState?.validate();
                              }),

                          const SizedBox(
                            height: 10,
                          ),
                          Divider(),
                          const SizedBox(
                            height: 10,
                          ),

////////////////////////////////////////////////////////////////////////////////

                          const SizedBox(
                            height: 10,
                          ),

                          //Genarator Controller
                          const Text('02. Genarator Controller',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),

                          //Alrams
                          const customText(
                            title: "Alarms",
                          ),
                          FormBuilderChoiceChips<String>(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            name: 'alarm',
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
                                    (degFormData['alarmRemark'] == null ||
                                        degFormData['alarmRemark'].isEmpty)) {
                                  return 'Remark is required when Alarm is available';
                                }
                                return null;
                              },
                            ]),
                            onChanged: (val) =>
                                _onChanged(val, degFormData, 'alarm'),
                          ),
                          CustomRemarkWidget(
                              title: "Remark",
                              formDataKey: "alarmRemark",
                              formData: degFormData,
                              formKey: _formKey,
                              onChangedRemark: (p0, p1) {
                                _onChangedRemark(p0, p1);
                                _formKey.currentState?.validate();
                              }),

                          ////////////////////////////////////////////////////////////////////////////////
                          //Warning
                          const customText(title: "Warnings"),
                          FormBuilderChoiceChips<String>(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            name: 'warning',
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
                                    (degFormData['warningRemark'] == null ||
                                        degFormData['warningRemark'].isEmpty)) {
                                  return 'Remark is required when Warning is available';
                                }
                                return null;
                              },
                            ]),
                            onChanged: (val) =>
                                _onChanged(val, degFormData, 'warning'),
                          ),
                          CustomRemarkWidget(
                              title: "Remark",
                              formDataKey: "warningRemark",
                              formData: degFormData,
                              formKey: _formKey,
                              onChangedRemark: (p0, p1) {
                                _onChangedRemark(p0, p1);
                                _formKey.currentState?.validate();
                              }),

                          //Visible Issues / Damages
                          const customText(title: "Visible Issues / Damages"),
                          FormBuilderChoiceChips<String>(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            name: 'issue',
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
                                    (degFormData['issueRemark'] == null ||
                                        degFormData['issueRemark'].isEmpty)) {
                                  return 'Remark is required when visible isses or damages are avalable';
                                }
                                return null;
                              },
                            ]),
                            onChanged: (val) =>
                                _onChanged(val, degFormData, 'issue'),
                          ),
                          CustomRemarkWidget(
                              title: "Remark",
                              formDataKey: "issueRemark",
                              formData: degFormData,
                              formKey: _formKey,
                              onChangedRemark: (p0, p1) {
                                _onChangedRemark(p0, p1);
                                _formKey.currentState?.validate();
                              }),

                          const SizedBox(
                            height: 10,
                          ),
                          Divider(),
                          const SizedBox(
                            height: 10,
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          //Cooling System Check
                          const Text('03. Cooling System Check',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),

                          //Check coolant / water leak from radiator,engine,hoses and connections
                          const customText(
                            title:
                            "Check Water leak from radiator,engine,hoses and connections",
                          ),
                          FormBuilderChoiceChips<String>(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                    (degFormData['leakRemark'] == null ||
                                        degFormData['leakRemark'].isEmpty)) {
                                  return 'Remark is required when any leakage is available';
                                }
                                return null;
                              },
                            ]),
                            onChanged: (val) =>
                                _onChanged(val, degFormData, 'leak'),
                          ),
                          CustomRemarkWidget(
                              title: "Remark",
                              formDataKey: "leakRemark",
                              formData: degFormData,
                              formKey: _formKey,
                              onChangedRemark: (p0, p1) {
                                _onChangedRemark(p0, p1);
                                _formKey.currentState?.validate();
                              }),

                          ////////////////////////////////////////////////////////////////////////////////
                          //Check coolant /  Water Level
                          const customText(title: "Check coolant /  Water Level"),
                          FormBuilderChoiceChips<String>(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            name: 'waterLevel',
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
                                    (degFormData['waterLevelRemark'] == null ||
                                        degFormData['waterLevelRemark'].isEmpty)) {
                                  return 'Remark is required when coolant or water level not ok ';
                                }
                                return null;
                              },
                            ]),
                            onChanged: (val) =>
                                _onChanged(val, degFormData, 'waterLevel'),
                          ),
                          CustomRemarkWidget(
                              title: "Remark",
                              formDataKey: "waterLevelRemark",
                              formData: degFormData,
                              formKey: _formKey,
                              onChangedRemark: (p0, p1) {
                                _onChangedRemark(p0, p1);
                                _formKey.currentState?.validate();
                              }),

                          SizedBox(
                            height: 10,
                          ),

                          //Inspect the exterior of the radiator for obstructions
                          const customText(
                              title:
                              "Inspect the exterior of the radiator for obstructions"),
                          FormBuilderChoiceChips<String>(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            name: 'exterior',
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
                                    (degFormData['exteriorRemark'] == null ||
                                        degFormData['exteriorRemark'].isEmpty)) {
                                  return 'Remark is required when exterior of the radiator \nfor obstructions is not ok';
                                }
                                return null;
                              },
                            ]),
                            onChanged: (val) =>
                                _onChanged(val, degFormData, 'exterior'),
                          ),
                          CustomRemarkWidget(
                              title: "Remark",
                              formDataKey: "exteriorRemark",
                              formData: degFormData,
                              formKey: _formKey,
                              onChangedRemark: (p0, p1) {
                                _onChangedRemark(p0, p1);
                                _formKey.currentState?.validate();
                              }),

                          const SizedBox(
                            height: 10,
                          ),
                          Divider(),
                          const SizedBox(
                            height: 10,
                          ),

                          ////////////////////////////////////////////////////////

                          //Fuel System Check
                          const Text('04. Fuel System Check',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),

                          //Check for any fuel leak
                          const customText(
                            title: "Check for any fuel leak",
                          ),
                          FormBuilderChoiceChips<String>(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            name: 'fuelLeak',
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
                                    (degFormData['fuelLeakRemark'] == null ||
                                        degFormData['fuelLeakRemark'].isEmpty)) {
                                  return 'Remark is required when detect any fuel leak';
                                }
                                return null;
                              },
                            ]),
                            onChanged: (val) =>
                                _onChanged(val, degFormData, 'fuelLeak'),
                          ),
                          CustomRemarkWidget(
                              title: "Remark",
                              formDataKey: "fuelLeakRemark",
                              formData: degFormData,
                              formKey: _formKey,
                              onChangedRemark: (p0, p1) {
                                _onChangedRemark(p0, p1);
                                _formKey.currentState?.validate();
                              }),

                          const SizedBox(
                            height: 10,
                          ),
                          Divider(),
                          const SizedBox(
                            height: 10,
                          ),

                          //Air Filter Status
                          const Text('05. Air Filter Status',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),

                          //Check for any fuel leak
                          const customText(
                            title: "Check air Filter Cleanliness",
                          ),
                          FormBuilderChoiceChips<String>(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            name: 'airFilter',
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
                                if (value == 'No' &&
                                    (degFormData['airFilterRemark'] == null ||
                                        degFormData['airFilterRemark'].isEmpty)) {
                                  return 'Remark is required when not clanliness of air filter';
                                }
                                return null;
                              },
                            ]),
                            onChanged: (val) =>
                                _onChanged(val, degFormData, 'airFilter'),
                          ),
                          CustomRemarkWidget(
                              title: "Remark",
                              formDataKey: "airFilterRemark",
                              formData: degFormData,
                              formKey: _formKey,
                              onChangedRemark: (p0, p1) {
                                _onChangedRemark(p0, p1);
                                _formKey.currentState?.validate();
                              }),

                          const SizedBox(
                            height: 10,
                          ),
                          Divider(),
                          const SizedBox(
                            height: 10,
                          ),
                          //Gas Emmission
                          const Text('06. Gas Emmissions',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),

                          //Measure Hydrogen gas emmission
                          const customText(
                            title: "Measure Hydrogen gas emmission",
                          ),
                          FormBuilderChoiceChips<String>(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            name: 'gasEmission',
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
                                    (degFormData['gasEmissionRemark'] == null ||
                                        degFormData['gasEmissionRemark'].isEmpty)) {
                                  return 'Remark is required when detect any gas emmission';
                                }
                                return null;
                              },
                            ]),
                            onChanged: (val) =>
                                _onChanged(val, degFormData, 'gasEmmission'),
                          ),
                          CustomRemarkWidget(
                              title: "Remark",
                              formDataKey: "gasEmissionRemark",
                              formData: degFormData,
                              formKey: _formKey,
                              onChangedRemark: (p0, p1) {
                                _onChangedRemark(p0, p1);
                                _formKey.currentState?.validate();
                              }),

                          const SizedBox(
                            height: 10,
                          ),
                          Divider(),
                          const SizedBox(
                            height: 10,
                          ),
                          //Lubrication
                          const Text('07. Lubrication',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),

                          //Check for any oil leak
                          const customText(
                            title: "Check for any oil leak",
                          ),
                          FormBuilderChoiceChips<String>(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            name: 'oilLeak',
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
                                    (degFormData['oilLeakRemark'] == null ||
                                        degFormData['oilLeakRemark'].isEmpty)) {
                                  return 'Remark is required when detect any oil leak';
                                }
                                return null;
                              },
                            ]),
                            onChanged: (val) =>
                                _onChanged(val, degFormData, 'oilLeak'),
                          ),
                          CustomRemarkWidget(
                              title: "Remark",
                              formDataKey: "oilLeakRemark",
                              formData: degFormData,
                              formKey: _formKey,
                              onChangedRemark: (p0, p1) {
                                _onChangedRemark(p0, p1);
                                _formKey.currentState?.validate();
                              }),

                          const SizedBox(
                            height: 10,
                          ),
                          Divider(),
                          const SizedBox(
                            height: 10,
                          ),

                          //Starter Batteies
                          const Text('08. Starter Batteies',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),

                          //Battery Cleanliness
                          const customText(
                            title: "Battery Cleanliness",
                          ),
                          FormBuilderChoiceChips<String>(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            name: 'batClean',
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
                                if (value == 'No' &&
                                    (degFormData['batCleanRemark'] == null ||
                                        degFormData['batCleanRemark'].isEmpty)) {
                                  return 'Remark is required when Battery is not clean';
                                }
                                return null;
                              },
                            ]),
                            onChanged: (val) =>
                                _onChanged(val, degFormData, 'batClean'),
                          ),
                          CustomRemarkWidget(
                              title: "Remark",
                              formDataKey: "batCleanRemark",
                              formData: degFormData,
                              formKey: _formKey,
                              onChangedRemark: (p0, p1) {
                                _onChangedRemark(p0, p1);
                                _formKey.currentState?.validate();
                              }),

                          ////////////////////////////////////////////////////////////////////////////////
                          //Check Battery Terminal Voltage
                          const customText(title: "Check Battery Terminal Voltage"),
                          FormBuilderChoiceChips<String>(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            name: 'batVoltage',
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
                                    (degFormData['batVoltageRemark'] == null ||
                                        degFormData['batVoltageRemark'].isEmpty)) {
                                  return 'Remark is required when battery Voltage is not ok ';
                                }
                                return null;
                              },
                            ]),
                            onChanged: (val) =>
                                _onChanged(val, degFormData, 'batVoltage'),
                          ),
                          CustomRemarkWidget(
                              title: "Remark",
                              formDataKey: "batVoltageRemark",
                              formData: degFormData,
                              formKey: _formKey,
                              onChangedRemark: (p0, p1) {
                                _onChangedRemark(p0, p1);
                                _formKey.currentState?.validate();
                              }),

                          //Check battery Charger
                          const customText(title: "Check battery Charger"),
                          FormBuilderChoiceChips<String>(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            name: 'batCharger',
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
                                    (degFormData['batChargerRemark'] == null ||
                                        degFormData['batChargerRemark'].isEmpty)) {
                                  return 'Remark is required when battery charger is not ok';
                                }
                                return null;
                              },
                            ]),
                            onChanged: (val) =>
                                _onChanged(val, degFormData, 'batCharger'),
                          ),
                          CustomRemarkWidget(
                              title: "Remark",
                              formDataKey: "batChargerRemark",
                              formData: degFormData,
                              formKey: _formKey,
                              onChangedRemark: (p0, p1) {
                                _onChangedRemark(p0, p1);
                                _formKey.currentState?.validate();
                              }),

                          const SizedBox(
                            height: 10,
                          ),
                          Divider(),
                          const SizedBox(
                            height: 10,
                          ),


                          const customText(title: "Battery Voltage"),

                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: FormBuilderTextField(
                                        name: 'bat1',
                                        decoration: const InputDecoration(
                                          labelText: "Battery 1",
                                          suffixText: "V",
                                        ),
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,
                                        autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                        onChanged: (val) {
                                          print(
                                              val); // Print the text value write into TextField
                                          _onChanged(val, degFormData, 'bat1');
                                        },
                                        validator: FormBuilderValidators.compose([
                                          FormBuilderValidators.required(),
                                          FormBuilderValidators.numeric(
                                              errorText:
                                              "Value must be \n numeric"),
                                          FormBuilderValidators.max(100,
                                              inclusive: false,
                                              errorText:
                                              "Value should be \n less than 100"),
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
                                        width:
                                        15), // Add spacing between the text fields
                                    Expanded(
                                      child: FormBuilderTextField(
                                        name: 'bat2',
                                        autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                        decoration: const InputDecoration(
                                          labelText: "Battery 2",
                                          suffixText: "V",
                                        ),
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,
                                        onChanged: (val) {
                                          print(
                                              val); // Print the text value write into TextField
                                          _onChanged(val, degFormData, 'bat2');
                                        },
                                        validator: FormBuilderValidators.compose([
                                          // FormBuilderValidators.required(),
                                          FormBuilderValidators.numeric(
                                              errorText:
                                              "Value must be \n numeric"),
                                          FormBuilderValidators.max(100,
                                              inclusive: false,
                                              errorText:
                                              "Value should be \n less than 100"),
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
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: FormBuilderTextField(
                                        name: 'bat3',
                                        decoration: const InputDecoration(
                                          labelText: "Battery 3 ",
                                          suffixText: "V",
                                        ),
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,
                                        autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                        onChanged: (val) {
                                          print(
                                              val); // Print the text value write into TextField
                                          _onChanged(val, degFormData, 'bat3');
                                        },
                                        validator: FormBuilderValidators.compose([
                                          // FormBuilderValidators.required(),
                                          FormBuilderValidators.numeric(
                                              errorText:
                                              "Value must be \n numeric"),
                                          FormBuilderValidators.max(100,
                                              inclusive: false,
                                              errorText:
                                              "Value should be \n less than 100"),
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
                                        width:
                                        15), // Add spacing between the text fields
                                    Expanded(
                                      child: FormBuilderTextField(
                                        name: 'bat4',
                                        autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                        decoration: const InputDecoration(
                                          labelText: "Battery 4",
                                          suffixText: "V",
                                        ),
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,
                                        onChanged: (val) {
                                          print(
                                              val); // Print the text value write into TextField
                                          _onChanged(val, degFormData, 'bat4');
                                        },
                                        validator: FormBuilderValidators.compose([
                                          // FormBuilderValidators.required(),
                                          FormBuilderValidators.numeric(
                                              errorText:
                                              "Value must be \n numeric"),
                                          FormBuilderValidators.max(100,
                                              inclusive: false,
                                              errorText:
                                              "Value should be \n less than 100"),
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

                          const SizedBox(
                            height: 20,
                          ),
                          const Text('Additional Remark :',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              )),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Column(
                              children: [
                                FormBuilderTextField(
                                  name: 'addiRemark',
                                  decoration: const InputDecoration(
                                      labelText: "Additional Remarks"),
                                  textInputAction: TextInputAction.done,
                                  onChanged: (val) {
                                    print(
                                        val); // Print the text value write into TextField
                                    setState(() {
                                      degFormData['addiRemark'] = val;
                                    });
                                  },
                                  validator: FormBuilderValidators.compose([]),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          /////////////////////////////////////////////////////////////

                          FormBuilderCheckbox(
                            name: 'accept_terms',
                            initialValue: false,
                            onChanged: (value) =>
                                _onChanged(value, degFormData, 'accept_terms'),
                            title: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                    'I Verify that submitted details are true and correct ',
                                    style: TextStyle(color: Colors.black),
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
                                    foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green),
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white24),
                                  ),
                                  child: const Text(
                                    'Reset',
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState?.saveAndValidate() ??
                                        false) {
                                      _formKey.currentState!
                                          .save(); // Save form data
                                      debugPrint(
                                          _formKey.currentState?.value.toString());
                                      Map<String, dynamic>? formData =
                                          _formKey.currentState?.value;
                                      formData = formData?.map((key, value) =>
                                          MapEntry(key, value ?? ''));

                                      // String rtom = _formKey.currentState?.value['Rtom_name'];
                                      // debugPrint('RTOM value: $rtom');
                                      //pass _formkey.currenState.value to a page called httpPostGen

                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         httpPostDEGInspection(
                                      //           formData: degFormData,
                                      //           degId:  widget.DEGUnit['ID'],
                                      //           userAccess: userAccess,
                                      //           region: widget.DEGUnit['station'],
                                      //         ),
                                      //   ),
                                      // );
                                    } 
                                    else {
                                      debugPrint(
                                          _formKey.currentState?.value.toString());
                                      debugPrint('validation failed');
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(Colors
                                        .blue), // Set the button color here
                                    foregroundColor:
                                    MaterialStateProperty.all<Color>(Colors
                                        .white), // Set the text color here
                                  ),
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.greenAccent),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 20,
                          ),
                        ]))),
          ),
        ));
  }
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
              '${widget.title}: ${widget.formData[widget.formDataKey] ?? ""}'),
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
                            widget.formData);

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
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          icon: Icon(Icons.add, color: Colors.black),
          label: Text(
            'Remarks',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
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
    return Text(
      title,
      style: const TextStyle(
          color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
    );
  }
}
