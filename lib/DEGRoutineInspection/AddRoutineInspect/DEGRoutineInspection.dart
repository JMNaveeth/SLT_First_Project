import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
// import 'package:theme_update/theme_provider.dart';
// import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/widgets/gps%20related%20widgets/gps_tag_widget.dart';
// import 'package:theme_update/widgets/gps_tag_widget.dart';
import 'package:theme_update/widgets/theme%20change%20related%20widjets/theme_provider.dart';
import 'package:theme_update/widgets/theme%20change%20related%20widjets/theme_toggle_button.dart';

//import '../../../UserAccess.dart';
import 'httpPostDEGInspection.dart';

String? username = "John Doe";

class DEGRoutineInspection extends StatefulWidget {
  final dynamic DEGUnit;

  const DEGRoutineInspection({super.key, required this.DEGUnit});

  @override
  State<DEGRoutineInspection> createState() => _DEGRoutineInspectionState();
}

class _DEGRoutineInspectionState extends State<DEGRoutineInspection> {
  final _formKey = GlobalKey<FormBuilderState>();

  //Define degForm Data map
  Map<String, dynamic> degFormData = {'clockTime': DateTime.now(), 'shift': ""};
  String _shift = '';
  TimeOfDay? _selectedTime;

  //save data from checklist to http file
  void _onChanged(
    dynamic val,
    Map<String, dynamic> formData,
    String fieldName,
  ) {
    debugPrint(val.toString());
    debugPrint(degFormData.toString());
    formData[fieldName] = val;

    // Trigger re-validation for all battery fields when one changes
    if (fieldName.startsWith('bat')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _formKey.currentState != null) {
          _formKey.currentState!.fields['bat1']?.validate();
          _formKey.currentState!.fields['bat2']?.validate();
          _formKey.currentState!.fields['bat3']?.validate();
          _formKey.currentState!.fields['bat4']?.validate();
        }
      });
    }
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

  // Validation method: Checks if at least one battery field is filled
  String? _validateAtLeastOneBattery(String? _) {
    // Parameter not used, but validator expects one
    final fields = _formKey.currentState?.fields;
    if (fields == null) return null;

    final bat1Value = fields['bat1']?.value?.toString().trim() ?? '';
    final bat2Value = fields['bat2']?.value?.toString().trim() ?? '';
    final bat3Value = fields['bat3']?.value?.toString().trim() ?? '';
    final bat4Value = fields['bat4']?.value?.toString().trim() ?? '';

    if (bat1Value.isEmpty &&
        bat2Value.isEmpty &&
        bat3Value.isEmpty &&
        bat4Value.isEmpty) {
      return 'At least one battery voltage \n is required';
    }
    return null;
  }

  // Validation method: Checks individual battery field rules (numeric, max)
  String? _validateIndividualBatteryField(String? val) {
    if (val == null || val.isEmpty) {
      return null; // Field is empty, so these specific rules don't apply to it.
    }
    // If not empty, then check numeric and max.
    final numericValidator = FormBuilderValidators.numeric(
      errorText: "Value must be \n numeric",
    );
    String? error = numericValidator(val);
    if (error != null) {
      return error;
    }

    final maxValidator = FormBuilderValidators.max(
      100,
      inclusive: false,
      errorText: "Value should be \n less than 100",
    );
    error = maxValidator(val);
    if (error != null) {
      return error;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // UserAccess userAccess = Provider.of<UserAccess>(context, listen: true); // Use listen: true to rebuild the widget when the data changes
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
                    SizedBox(height: 5),

                    //REgion
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
                          widget.DEGUnit['Rtom_name'],
                          style: TextStyle(
                            color: customColors.mainTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 5),

                    //QR TAG ID
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "QR Tag ID :",
                          style: TextStyle(
                            color: customColors.mainTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        Spacer(),
                        Text(
                          widget.DEGUnit['station'],
                          style: TextStyle(
                            color: customColors.mainTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),

                    // Only show GPS widget if not HQ
                    ReusableGPSWidget(
                      region: widget.DEGUnit['province'],
                      onLocationFound: (lat, lng) {
                        setState(() {
                          degFormData['gpsLocation'] = {'lat': lat, 'lng': lng};
                        });
                        print('Got location: $lat, $lng');
                      },
                    ),

                    const SizedBox(height: 10),

                    //Get Genaral Inspectin Date
                    const Text(
                      '01. Genaral Inspection',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    //Check Cleanliness of the DEG
                    const customText(title: "Check Cleanliness of the DEG"),
                    Container(
                      // 1. Wrap in a Container with fixed height
                      // height:
                      //     52, // Adjust this height as needed for your layout
                      // Optional: Add a consistent background/border if you had one before
                      // decoration: BoxDecoration(
                      //   color: customColors.suqarBackgroundColor,
                      //   borderRadius: BorderRadius.circular(10),
                      //   border: Border.all(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     width: 1,
                      //   ),
                      // ),
                      child: FormBuilderChoiceChips<String>(
                        decoration: const InputDecoration(
                          // Remove FormBuilder's default variable padding
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorMaxLines: 2,
                        ),
                        // backgroundColor:
                        //     Colors
                        //         .transparent, // Let the Container handle background
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'degClean',
                        initialValue: '',
                        selectedColor: Colors.lightBlueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 8.0,
                        ), // Consistent padding for chips
                        spacing:
                            8.0, // Consistent horizontal space between chips
                        runSpacing: 0,
                        options: [
                          FormBuilderChipOption(
                            value: 'Ok',
                            child: const Text("Ok"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'O',
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
                          ),
                          FormBuilderChipOption(
                            value: 'Not Ok',
                            child: Text("Not Ok"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'N', // Or 'M' if you prefer for "Not Ok"
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
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
                        onChanged:
                            (val) => _onChanged(val, degFormData, 'degClean'),
                      ),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "degCleanRemark",
                      formData: degFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    ////////////////////////////////////////////////////////////////////////////////
                    //Check Cleanliness surrounding the \nDesel tank/Pump
                    const customText(
                      title:
                          "Check Cleanliness surrounding the \nDesel tank/Pump",
                    ),
                    Container(
                      // 1. Wrap in a Container with fixed height
                      // height:
                      //     52, // Adjust this height as needed for your layout
                      // Optional: Add a consistent background/border if you had one before
                      // decoration: BoxDecoration(
                      //   color: customColors.suqarBackgroundColor,
                      //   borderRadius: BorderRadius.circular(10),
                      //   border: Border.all(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     width: 1,
                      //   ),
                      // ),
                      child: FormBuilderChoiceChips<String>(
                        decoration: const InputDecoration(
                          // Remove FormBuilder's default variable padding
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorMaxLines: 2,
                        ),
                        // backgroundColor:
                        //     Colors
                        //         .transparent, // Let the Container handle background
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'surroundClean',
                        initialValue: '',
                        selectedColor: Colors.lightBlueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 8.0,
                        ), // Consistent padding for chips
                        spacing:
                            8.0, // Consistent horizontal space between chips
                        runSpacing: 0,
                        options: [
                          FormBuilderChipOption(
                            value: 'Ok',
                            child: const Text("Ok"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'O',
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
                          ),
                          FormBuilderChipOption(
                            value: 'Not Ok',
                            child: Text("Not Ok"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'N', // Or 'M' if you prefer for "Not Ok"
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
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
                        onChanged:
                            (val) =>
                                _onChanged(val, degFormData, 'surroundClean'),
                      ),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "surroundCleanRemark",
                      formData: degFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    //Check Condition of V - belts
                    const customText(title: "Check Condition of V - belts"),
                    Container(
                      // 1. Wrap in a Container with fixed height
                      // height:
                      //     52, // Adjust this height as needed for your layout
                      // Optional: Add a consistent background/border if you had one before
                      // decoration: BoxDecoration(
                      //   color: customColors.suqarBackgroundColor,
                      //   borderRadius: BorderRadius.circular(10),
                      //   border: Border.all(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     width: 1,
                      //   ),
                      // ),
                      child: FormBuilderChoiceChips<String>(
                        decoration: const InputDecoration(
                          // Remove FormBuilder's default variable padding
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorMaxLines: 2,
                        ),
                        // backgroundColor:
                        //     Colors
                        //         .transparent, // Let the Container handle background
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'vbelt',
                        initialValue: '',
                        selectedColor: Colors.lightBlueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 8.0,
                        ), // Consistent padding for chips
                        spacing:
                            8.0, // Consistent horizontal space between chips
                        runSpacing: 0,
                        options: [
                          FormBuilderChipOption(
                            value: 'Ok',
                            child: const Text("Ok"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'O',
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
                          ),
                          FormBuilderChipOption(
                            value: 'Not Ok',
                            child: Text("Not Ok"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'N', // Or 'M' if you prefer for "Not Ok"
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
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
                        onChanged:
                            (val) => _onChanged(val, degFormData, 'vbelt'),
                      ),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "vbeltRemark",
                      formData: degFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    const SizedBox(height: 10),
                    Divider(),
                    const SizedBox(height: 10),

                    ////////////////////////////////////////////////////////////////////////////////
                    const SizedBox(height: 10),

                    //Genarator Controller
                    const Text(
                      '02. Genarator Controller',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    //Alrams
                    const customText(title: "Alarms"),
                    Container(
                      // 1. Wrap in a Container with fixed height
                      // height:
                      //     52, // Adjust this height as needed for your layout
                      // Optional: Add a consistent background/border if you had one before
                      // decoration: BoxDecoration(
                      //   color: customColors.suqarBackgroundColor,
                      //   borderRadius: BorderRadius.circular(10),
                      //   border: Border.all(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     width: 1,
                      //   ),
                      // ),
                      child: FormBuilderChoiceChips<String>(
                        decoration: const InputDecoration(
                          // Remove FormBuilder's default variable padding
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorMaxLines: 2,
                        ),
                        // backgroundColor:
                        //     Colors
                        //         .transparent, // Let the Container handle background
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'alarm',
                        initialValue: '',
                        selectedColor: Colors.lightBlueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 8.0,
                        ), // Consistent padding for chips
                        spacing:
                            8.0, // Consistent horizontal space between chips
                        runSpacing: 0,
                        options: [
                          FormBuilderChipOption(
                            value: 'Yes',
                            child: const Text("Yes"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'Y',
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
                          ),
                          FormBuilderChipOption(
                            value: 'No',
                            child: Text("No"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'N', // Or 'M' if you prefer for "Not Ok"
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
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
                        onChanged:
                            (val) => _onChanged(val, degFormData, 'alarm'),
                      ),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "alarmRemark",
                      formData: degFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    ////////////////////////////////////////////////////////////////////////////////
                    //Warning
                    const customText(title: "Warnings"),
                    Container(
                      // 1. Wrap in a Container with fixed height
                      // height:
                      //     52, // Adjust this height as needed for your layout
                      // Optional: Add a consistent background/border if you had one before
                      // decoration: BoxDecoration(
                      //   color: customColors.suqarBackgroundColor,
                      //   borderRadius: BorderRadius.circular(10),
                      //   border: Border.all(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     width: 1,
                      //   ),
                      // ),
                      child: FormBuilderChoiceChips<String>(
                        decoration: const InputDecoration(
                          // Remove FormBuilder's default variable padding
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorMaxLines: 2,
                        ),
                        // backgroundColor:
                        //     Colors
                        //         .transparent, // Let the Container handle background
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'warning',
                        initialValue: '',
                        selectedColor: Colors.lightBlueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 8.0,
                        ), // Consistent padding for chips
                        spacing:
                            8.0, // Consistent horizontal space between chips
                        runSpacing: 0,
                        options: [
                          FormBuilderChipOption(
                            value: 'Yes',
                            child: const Text("Yes"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'Y',
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
                          ),
                          FormBuilderChipOption(
                            value: 'No',
                            child: Text("No"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'N', // Or 'M' if you prefer for "Not Ok"
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
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
                        onChanged:
                            (val) => _onChanged(val, degFormData, 'warning'),
                      ),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "warningRemark",
                      formData: degFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    //Visible Issues / Damages
                    const customText(title: "Visible Issues / Damages"),
                    Container(
                      // 1. Wrap in a Container with fixed height
                      // height:
                      //     52, // Adjust this height as needed for your layout
                      // Optional: Add a consistent background/border if you had one before
                      // decoration: BoxDecoration(
                      //   color: customColors.suqarBackgroundColor,
                      //   borderRadius: BorderRadius.circular(10),
                      //   border: Border.all(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     width: 1,
                      //   ),
                      // ),
                      child: FormBuilderChoiceChips<String>(
                        decoration: const InputDecoration(
                          // Remove FormBuilder's default variable padding
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorMaxLines: 2,
                        ),
                        // backgroundColor:
                        //     Colors
                        //         .transparent, // Let the Container handle background
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'issue',
                        initialValue: '',
                        selectedColor: Colors.lightBlueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 8.0,
                        ), // Consistent padding for chips
                        spacing:
                            8.0, // Consistent horizontal space between chips
                        runSpacing: 0,
                        options: [
                          FormBuilderChipOption(
                            value: 'Yes',
                            child: const Text("Yes"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'Y',
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
                          ),
                          FormBuilderChipOption(
                            value: 'No',
                            child: Text("No"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'N', // Or 'M' if you prefer for "Not Ok"
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
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
                        onChanged:
                            (val) => _onChanged(val, degFormData, 'issue'),
                      ),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "issueRemark",
                      formData: degFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    const SizedBox(height: 10),
                    Divider(),
                    const SizedBox(height: 10),

                    const SizedBox(height: 10),

                    //Cooling System Check
                    const Text(
                      '03. Cooling System Check',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    //Check coolant / water leak from radiator,engine,hoses and connections
                    const customText(
                      title:
                          "Check Water leak from radiator,engine,hoses and connections",
                    ),
                    Container(
                      // 1. Wrap in a Container with fixed height
                      // height:
                      //     52, // Adjust this height as needed for your layout
                      // Optional: Add a consistent background/border if you had one before
                      // decoration: BoxDecoration(
                      //   color: customColors.suqarBackgroundColor,
                      //   borderRadius: BorderRadius.circular(10),
                      //   border: Border.all(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     width: 1,
                      //   ),
                      // ),
                      child: FormBuilderChoiceChips<String>(
                        decoration: const InputDecoration(
                          // Remove FormBuilder's default variable padding
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorMaxLines: 2,
                        ),
                        // backgroundColor:
                        //     Colors
                        //         .transparent, // Let the Container handle background
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'leak',
                        initialValue: '',
                        selectedColor: Colors.lightBlueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 8.0,
                        ), // Consistent padding for chips
                        spacing:
                            8.0, // Consistent horizontal space between chips
                        runSpacing: 0,
                        options: [
                          FormBuilderChipOption(
                            value: 'Yes',
                            child: const Text("Yes"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'Y',
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
                          ),
                          FormBuilderChipOption(
                            value: 'No',
                            child: Text("No"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'N', // Or 'M' if you prefer for "Not Ok"
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
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
                        onChanged:
                            (val) => _onChanged(val, degFormData, 'leak'),
                      ),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "leakRemark",
                      formData: degFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    ////////////////////////////////////////////////////////////////////////////////
                    //Check coolant /  Water Level
                    const customText(title: "Check coolant /  Water Level"),
                    Container(
                      // 1. Wrap in a Container with fixed height
                      // height:
                      //     52, // Adjust this height as needed for your layout
                      // Optional: Add a consistent background/border if you had one before
                      // decoration: BoxDecoration(
                      //   color: customColors.suqarBackgroundColor,
                      //   borderRadius: BorderRadius.circular(10),
                      //   border: Border.all(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     width: 1,
                      //   ),
                      // ),
                      child: FormBuilderChoiceChips<String>(
                        decoration: const InputDecoration(
                          // Remove FormBuilder's default variable padding
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorMaxLines: 2,
                        ),
                        // backgroundColor:
                        //     Colors
                        //         .transparent, // Let the Container handle background
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'waterLevel',
                        initialValue: '',
                        selectedColor: Colors.lightBlueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 8.0,
                        ), // Consistent padding for chips
                        spacing:
                            8.0, // Consistent horizontal space between chips
                        runSpacing: 0,
                        options: [
                          FormBuilderChipOption(
                            value: 'Ok',
                            child: const Text("Ok"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'O',
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
                          ),
                          FormBuilderChipOption(
                            value: 'Not Ok',
                            child: Text("Not Ok"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'N', // Or 'M' if you prefer for "Not Ok"
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
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
                        onChanged:
                            (val) => _onChanged(val, degFormData, 'waterLevel'),
                      ),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "waterLevelRemark",
                      formData: degFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    SizedBox(height: 10),

                    //Inspect the exterior of the radiator for obstructions
                    const customText(
                      title:
                          "Inspect the exterior of the radiator for obstructions",
                    ),
                    Container(
                      // 1. Wrap in a Container with fixed height
                      // height:
                      //     52, // Adjust this height as needed for your layout
                      // Optional: Add a consistent background/border if you had one before
                      // decoration: BoxDecoration(
                      //   color: customColors.suqarBackgroundColor,
                      //   borderRadius: BorderRadius.circular(10),
                      //   border: Border.all(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     width: 1,
                      //   ),
                      // ),
                      child: FormBuilderChoiceChips<String>(
                        decoration: const InputDecoration(
                          // Remove FormBuilder's default variable padding
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorMaxLines: 2,
                        ),
                        // backgroundColor:
                        //     Colors
                        //         .transparent, // Let the Container handle background
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'exterior',
                        initialValue: '',
                        selectedColor: Colors.lightBlueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 8.0,
                        ), // Consistent padding for chips
                        spacing:
                            8.0, // Consistent horizontal space between chips
                        runSpacing: 0,
                        options: [
                          FormBuilderChipOption(
                            value: 'Ok',
                            child: const Text("Ok"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'O',
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
                          ),
                          FormBuilderChipOption(
                            value: 'Not Ok',
                            child: Text("Not Ok"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'N', // Or 'M' if you prefer for "Not Ok"
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
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
                        onChanged:
                            (val) => _onChanged(val, degFormData, 'exterior'),
                      ),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "exteriorRemark",
                      formData: degFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    const SizedBox(height: 10),
                    Divider(),
                    const SizedBox(height: 10),

                    ////////////////////////////////////////////////////////

                    //Fuel System Check
                    const Text(
                      '04. Fuel System Check',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    //Check for any fuel leak
                    const customText(title: "Check for any fuel leak"),
                    Container(
                      // 1. Wrap in a Container with fixed height
                      // height:
                      //     52, // Adjust this height as needed for your layout
                      // Optional: Add a consistent background/border if you had one before
                      // decoration: BoxDecoration(
                      //   color: customColors.suqarBackgroundColor,
                      //   borderRadius: BorderRadius.circular(10),
                      //   border: Border.all(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     width: 1,
                      //   ),
                      // ),
                      child: FormBuilderChoiceChips<String>(
                        decoration: const InputDecoration(
                          // Remove FormBuilder's default variable padding
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorMaxLines: 2,
                        ),
                        // backgroundColor:
                        //     Colors
                        //         .transparent, // Let the Container handle background
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'fuelLeak',
                        initialValue: '',
                        selectedColor: Colors.lightBlueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 8.0,
                        ), // Consistent padding for chips
                        spacing:
                            8.0, // Consistent horizontal space between chips
                        runSpacing: 0,
                        options: [
                          FormBuilderChipOption(
                            value: 'Yes',
                            child: const Text("Yes"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'Y',
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
                          ),
                          FormBuilderChipOption(
                            value: 'No',
                            child: Text("No"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'N', // Or 'M' if you prefer for "Not Ok"
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
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
                        onChanged:
                            (val) => _onChanged(val, degFormData, 'fuelLeak'),
                      ),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "fuelLeakRemark",
                      formData: degFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    const SizedBox(height: 10),
                    Divider(),
                    const SizedBox(height: 10),

                    //Air Filter Status
                    const Text(
                      '05. Air Filter Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    //Check for any fuel leak
                    const customText(title: "Check air Filter Cleanliness"),
                    Container(
                      // 1. Wrap in a Container with fixed height
                      // height:
                      //     52, // Adjust this height as needed for your layout
                      // Optional: Add a consistent background/border if you had one before
                      // decoration: BoxDecoration(
                      //   color: customColors.suqarBackgroundColor,
                      //   borderRadius: BorderRadius.circular(10),
                      //   border: Border.all(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     width: 1,
                      //   ),
                      // ),
                      child: FormBuilderChoiceChips<String>(
                        decoration: const InputDecoration(
                          // Remove FormBuilder's default variable padding
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorMaxLines: 2,
                        ),
                        // backgroundColor:
                        //     Colors
                        //         .transparent, // Let the Container handle background
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'airFilter',
                        initialValue: '',
                        selectedColor: Colors.lightBlueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 8.0,
                        ), // Consistent padding for chips
                        spacing:
                            8.0, // Consistent horizontal space between chips
                        runSpacing: 0,
                        options: [
                          FormBuilderChipOption(
                            value: 'Yes',
                            child: const Text("Yes"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'Y',
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
                          ),
                          FormBuilderChipOption(
                            value: 'No',
                            child: Text("No"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'N', // Or 'M' if you prefer for "Not Ok"
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
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
                        onChanged:
                            (val) => _onChanged(val, degFormData, 'airFilter'),
                      ),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "airFilterRemark",
                      formData: degFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    const SizedBox(height: 10),
                    Divider(),
                    const SizedBox(height: 10),
                    //Gas Emmission
                    const Text(
                      '06. Gas Emmissions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    //Measure Hydrogen gas emmission
                    const customText(title: "Measure Hydrogen gas emmission"),
                    Container(
                      // // 1. Wrap in a Container with fixed height
                      // height:
                      //     52, // Adjust this height as needed for your layout
                      // Optional: Add a consistent background/border if you had one before
                      // decoration: BoxDecoration(
                      //   color: customColors.suqarBackgroundColor,
                      //   borderRadius: BorderRadius.circular(10),
                      //   border: Border.all(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     width: 1,
                      //   ),
                      // ),
                      child: FormBuilderChoiceChips<String>(
                        decoration: const InputDecoration(
                          // Remove FormBuilder's default variable padding
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorMaxLines: 2,
                        ),
                        // backgroundColor:
                        //     Colors
                        //         .transparent, // Let the Container handle background
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'gasEmission',
                        initialValue: '',
                        selectedColor: Colors.lightBlueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 8.0,
                        ), // Consistent padding for chips
                        spacing:
                            8.0, // Consistent horizontal space between chips
                        runSpacing: 0,
                        options: [
                          FormBuilderChipOption(
                            value: 'Yes',
                            child: const Text("Yes"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'Y',
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
                          ),
                          FormBuilderChipOption(
                            value: 'No',
                            child: Text("No"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'N', // Or 'M' if you prefer for "Not Ok"
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
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
                        onChanged:
                            (val) =>
                                _onChanged(val, degFormData, 'gasEmmission'),
                      ),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "gasEmissionRemark",
                      formData: degFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    const SizedBox(height: 10),
                    Divider(),
                    const SizedBox(height: 10),
                    //Lubrication
                    const Text(
                      '07. Lubrication',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    //Check for any oil leak
                    const customText(title: "Check for any oil leak"),
                    Container(
                      // 1. Wrap in a Container with fixed height
                      // height:
                      //     52, // Adjust this height as needed for your layout
                      // Optional: Add a consistent background/border if you had one before
                      // decoration: BoxDecoration(
                      //   color: customColors.suqarBackgroundColor,
                      //   borderRadius: BorderRadius.circular(10),
                      //   border: Border.all(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     width: 1,
                      //   ),
                      // ),
                      child: FormBuilderChoiceChips<String>(
                        decoration: const InputDecoration(
                          // Remove FormBuilder's default variable padding
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorMaxLines: 2,
                        ),
                        // backgroundColor:
                        //     Colors
                        //         .transparent, // Let the Container handle background
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'oilLeak',
                        initialValue: '',
                        selectedColor: Colors.lightBlueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 8.0,
                        ), // Consistent padding for chips
                        spacing:
                            8.0, // Consistent horizontal space between chips
                        runSpacing: 0,
                        options: [
                          FormBuilderChipOption(
                            value: 'Yes',
                            child: const Text("Yes"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'Y',
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
                          ),
                          FormBuilderChipOption(
                            value: 'No',
                            child: Text("No"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'N', // Or 'M' if you prefer for "Not Ok"
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
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
                        onChanged:
                            (val) => _onChanged(val, degFormData, 'oilLeak'),
                      ),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "oilLeakRemark",
                      formData: degFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    const SizedBox(height: 10),
                    Divider(),
                    const SizedBox(height: 10),

                    //Starter Batteies
                    const Text(
                      '08. Starter Batteies',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    //Battery Cleanliness
                    const customText(title: "Battery Cleanliness"),
                    Container(
                      // 1. Wrap in a Container with fixed height
                      // height:
                      //     52, // Adjust this height as needed for your layout
                      // Optional: Add a consistent background/border if you had one before
                      // decoration: BoxDecoration(
                      //   color: customColors.suqarBackgroundColor,
                      //   borderRadius: BorderRadius.circular(10),
                      //   border: Border.all(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     width: 1,
                      //   ),
                      // ),
                      child: FormBuilderChoiceChips<String>(
                        decoration: const InputDecoration(
                          // Remove FormBuilder's default variable padding
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorMaxLines: 2,
                        ),
                        // backgroundColor:
                        //     Colors
                        //         .transparent, // Let the Container handle background
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'batClean',
                        initialValue: '',
                        selectedColor: Colors.lightBlueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 8.0,
                        ), // Consistent padding for chips
                        spacing:
                            8.0, // Consistent horizontal space between chips
                        runSpacing: 0,
                        options: [
                          FormBuilderChipOption(
                            value: 'Yes',
                            child: const Text("Yes"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'Y',
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
                          ),
                          FormBuilderChipOption(
                            value: 'No',
                            child: Text("No"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'N', // Or 'M' if you prefer for "Not Ok"
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
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
                        onChanged:
                            (val) => _onChanged(val, degFormData, 'batClean'),
                      ),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "batCleanRemark",
                      formData: degFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    ////////////////////////////////////////////////////////////////////////////////
                    //Check Battery Terminal Voltage
                    const customText(title: "Check Battery Terminal Voltage"),
                    Container(
                      // 1. Wrap in a Container with fixed height
                      // height:
                      //     52, // Adjust this height as needed for your layout
                      // Optional: Add a consistent background/border if you had one before
                      // decoration: BoxDecoration(
                      //   color: customColors.suqarBackgroundColor,
                      //   borderRadius: BorderRadius.circular(10),
                      //   border: Border.all(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     width: 1,
                      //   ),
                      // ),
                      child: FormBuilderChoiceChips<String>(
                        decoration: const InputDecoration(
                          // Remove FormBuilder's default variable padding
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorMaxLines: 2,
                        ),
                        // backgroundColor:
                        //     Colors
                        //         .transparent, // Let the Container handle background
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'batVoltage',
                        initialValue: '',
                        selectedColor: Colors.lightBlueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 8.0,
                        ), // Consistent padding for chips
                        spacing:
                            8.0, // Consistent horizontal space between chips
                        runSpacing: 0,
                        options: [
                          FormBuilderChipOption(
                            value: 'Ok',
                            child: const Text("Ok"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'O',
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
                          ),
                          FormBuilderChipOption(
                            value: 'Not Ok',
                            child: Text("Not Ok"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'N', // Or 'M' if you prefer for "Not Ok"
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
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
                        onChanged:
                            (val) => _onChanged(val, degFormData, 'batVoltage'),
                      ),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "batVoltageRemark",
                      formData: degFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    //Check battery Charger
                    const customText(title: "Check battery Charger"),
                    Container(
                      // 1. Wrap in a Container with fixed height
                      // height:
                      //    52, // Adjust this height as needed for your layout
                      // Optional: Add a consistent background/border if you had one before
                      // decoration: BoxDecoration(
                      //   color: customColors.suqarBackgroundColor,
                      //   borderRadius: BorderRadius.circular(10),
                      //   border: Border.all(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     width: 1,
                      //   ),
                      // ),
                      child: FormBuilderChoiceChips<String>(
                        decoration: const InputDecoration(
                          // Remove FormBuilder's default variable padding
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorMaxLines: 2,
                        ),
                        // backgroundColor:
                        //     Colors
                        //         .transparent, // Let the Container handle background
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'batCharger',
                        initialValue: '',
                        selectedColor: Colors.lightBlueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 8.0,
                        ), // Consistent padding for chips
                        spacing:
                            8.0, // Consistent horizontal space between chips
                        runSpacing: 0,
                        options: [
                          FormBuilderChipOption(
                            value: 'Ok',
                            child: Text("Ok"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'O',
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
                          ),
                          FormBuilderChipOption(
                            value: 'Not Ok',
                            child: Text("Not Ok"),
                            avatar: CircleAvatar(
                              radius: 12, // Nice small size
                              backgroundColor:
                                  Colors.blue[700], // A good blue color
                              child: const Text(
                                // Added const here
                                'N', // Or 'M' if you prefer for "Not Ok"
                                style: TextStyle(
                                  fontSize: 15, // Text size fits the circle
                                  color: Colors.white, // White letter
                                ),
                              ),
                            ),
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
                        onChanged:
                            (val) => _onChanged(val, degFormData, 'batCharger'),
                      ),
                    ),
                    CustomRemarkWidget(
                      title: "Remark",
                      formDataKey: "batChargerRemark",
                      formData: degFormData,
                      formKey: _formKey,
                      onChangedRemark: (p0, p1) {
                        _onChangedRemark(p0, p1);
                        _formKey.currentState?.validate();
                      },
                    ),

                    const SizedBox(height: 10),
                    Divider(),
                    const SizedBox(height: 10),

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
                                  style: TextStyle(
                                    color: customColors.mainTextColor,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Battery 1",
                                    labelStyle: TextStyle(
                                      color: customColors.mainTextColor
                                          .withOpacity(0.7),
                                    ), // For the label text
                                    suffixText: "V",
                                    suffixStyle: TextStyle(
                                      color: customColors.mainTextColor
                                          .withOpacity(0.7),
                                    ), // For the suffix text
                                  ),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onChanged: (val) {
                                    // The _onChanged method now handles re-validation
                                    _onChanged(val, degFormData, 'bat1');
                                  },
                                  validator: FormBuilderValidators.compose([
                                    _validateAtLeastOneBattery,
                                    _validateIndividualBatteryField,
                                    // FormBuilderValidators.numeric(
                                    //   errorText: "Value must be \n numeric",
                                    // ),
                                    // FormBuilderValidators.max(
                                    //   100,
                                    //   inclusive: false,
                                    //   errorText:
                                    //       "Value should be \n less than 100",
                                    // ),
                                    // (val) {
                                    //   if (val == null || val.isEmpty)
                                    //     return null;
                                    //   final number = num.tryParse(val);
                                    //   if (number == null)
                                    //     return 'Must be a number';
                                    //   return null;
                                    // },
                                  ]),
                                ),
                              ),

                              const SizedBox(
                                width: 15,
                              ), // Add spacing between the text fields
                              Expanded(
                                child: FormBuilderTextField(
                                  name: 'bat2',
                                  style: TextStyle(
                                    color: customColors.mainTextColor,
                                  ), // For the actual input text

                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    labelText: "Battery 2",
                                    labelStyle: TextStyle(
                                      color: customColors.mainTextColor
                                          .withOpacity(0.7),
                                    ), // For the label text
                                    suffixText: "V",
                                    suffixStyle: TextStyle(
                                      color: customColors.mainTextColor
                                          .withOpacity(0.7),
                                    ), // For the suffix text
                                  ),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    // print(
                                    //   val,
                                    // ); // Print the text value write into TextField
                                    _onChanged(val, degFormData, 'bat2');
                                  },
                                  validator: FormBuilderValidators.compose([
                                    // FormBuilderValidators.required(),
                                    _validateAtLeastOneBattery,
                                    _validateIndividualBatteryField,
                                    // FormBuilderValidators.numeric(
                                    //   errorText: "Value must be \n numeric",
                                    // ),
                                    // FormBuilderValidators.max(
                                    //   100,
                                    //   inclusive: false,
                                    //   errorText:
                                    //       "Value should be \n less than 100",
                                    // ),
                                    // (val) {
                                    //   if (val == null || val.isEmpty)
                                    //     return null;
                                    //   final number = num.tryParse(val);
                                    //   if (number == null)
                                    //     return 'Must be a number';
                                    //   return null;
                                    // },
                                  ]),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: FormBuilderTextField(
                                  name: 'bat3',
                                  style: TextStyle(
                                    color: customColors.mainTextColor,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Battery 3 ",
                                    labelStyle: TextStyle(
                                      color: customColors.mainTextColor
                                          .withOpacity(0.7),
                                    ), // For the label text
                                    suffixText: "V",
                                    suffixStyle: TextStyle(
                                      color: customColors.mainTextColor
                                          .withOpacity(0.7),
                                    ), // For the suffix text
                                  ),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onChanged: (val) {
                                    // print(
                                    //   val,
                                    // ); // Print the text value write into TextField
                                    _onChanged(val, degFormData, 'bat3');
                                  },
                                  validator: FormBuilderValidators.compose([
                                    // FormBuilderValidators.required(),
                                    _validateAtLeastOneBattery,
                                    _validateIndividualBatteryField,
                                    // FormBuilderValidators.numeric(
                                    //   errorText: "Value must be \n numeric",
                                    // ),
                                    // FormBuilderValidators.max(
                                    //   100,
                                    //   inclusive: false,
                                    //   errorText:
                                    //       "Value should be \n less than 100",
                                    // ),
                                    // (val) {
                                    //   if (val == null || val.isEmpty)
                                    //     return null;
                                    //   final number = num.tryParse(val);
                                    //   if (number == null)
                                    //     return 'Must be a number';
                                    //   return null;
                                    // },
                                  ]),
                                ),
                              ),

                              const SizedBox(
                                width: 15,
                              ), // Add spacing between the text fields
                              Expanded(
                                child: FormBuilderTextField(
                                  name: 'bat4',
                                  style: TextStyle(
                                    color: customColors.mainTextColor,
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    labelText: "Battery 4",
                                    labelStyle: TextStyle(
                                      color: customColors.mainTextColor
                                          .withOpacity(0.7),
                                    ), // For the label text
                                    suffixText: "V",
                                    suffixStyle: TextStyle(
                                      color: customColors.mainTextColor
                                          .withOpacity(0.7),
                                    ), // For the suffix text
                                  ),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    // print(
                                    //   val,
                                    // ); // Print the text value write into TextField
                                    _onChanged(val, degFormData, 'bat4');
                                  },
                                  validator: FormBuilderValidators.compose([
                                    // FormBuilderValidators.required(),
                                    _validateAtLeastOneBattery,
                                    _validateIndividualBatteryField,
                                    // FormBuilderValidators.numeric(
                                    //   errorText: "Value must be \n numeric",
                                    // ),
                                    // FormBuilderValidators.max(
                                    //   100,
                                    //   inclusive: false,
                                    //   errorText:
                                    //       "Value should be \n less than 100",
                                    // ),
                                    // (val) {
                                    //   if (val == null || val.isEmpty)
                                    //     return null;
                                    //   final number = num.tryParse(val);
                                    //   if (number == null)
                                    //     return 'Must be a number';
                                    //   return null;
                                    // },
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
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
                              labelStyle: TextStyle(
                                color: customColors.mainTextColor.withOpacity(
                                  0.7,
                                ),
                              ),
                            ),
                            textInputAction: TextInputAction.done,
                            onChanged: (val) {
                              print(
                                val,
                              ); // Print the text value write into TextField
                              setState(() {
                                degFormData['addiRemark'] = val;
                              });
                            },
                            validator: FormBuilderValidators.compose([]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    /////////////////////////////////////////////////////////////
                    FormBuilderCheckbox(
                      name: 'accept_terms',
                      initialValue: false,
                      onChanged:
                          (value) =>
                              _onChanged(value, degFormData, 'accept_terms'),
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
                              if (ReusableGPSWidget.isGPSRequiredAndMissing(
                                context: context,
                                region: widget.DEGUnit['province'],
                                formData: degFormData,
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

                                // String rtom = _formKey.currentState?.value['Rtom_name'];
                                // debugPrint('RTOM value: $rtom');
                                //pass _formkey.currenState.value to a page called httpPostGen

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        httpPostDEGInspection(
                                          formData: degFormData,
                                          degId:  widget.DEGUnit['ID'],
                                        //  userAccess: userAccess,
                                          region: widget.DEGUnit['station'],
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
        Theme.of(context).extension<CustomColors>()!; // Get theme colors
    return Text(
      title,
      style: TextStyle(
        color: customColors.mainTextColor, // Use theme color
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
