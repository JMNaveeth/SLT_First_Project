import 'package:flutter/material.dart';

// Dark theme colors
const Color mainBackgroundColor = Color(0xff343A40);
const Color suqarBackgroundColor = Color(0xff212529);

// Light theme colors
const Color mainBackgroundColorLight = Color(0xffF8F9FA);
const Color suqarBackgroundColorLight = Color(0xffd2cfcf); // Light gray background for better contrast
const Color appbarColorLight = Color(0xff4a4d4f); // A light gray for light theme app bar

// Text colors for dark theme
const Color mainTextColor = Color(0xffFFFFFF);
const Color subTextColor = Color(0xffD9D9D9);

// Text colors for light theme
const Color mainTextColorLight = Color(0xff212529); // Dark gray for main text
const Color subTextColorLight = Color(0xff495057); // Medium gray for secondary text
const Color hintTextColorLight = Color(0xff6C757D); // For hint text in light theme

// Additional colors
const Color qrcodeiconColor1 = Color(0xff20C997);
const Color appbarColor = Color(0xff2B3136);
const Color highlightColor = Color(0xff4FC3F7);


//v1
// import 'package:flutter/material.dart';
//
// const Color mainBackgroundColor =Color(0xff343A40);
// const Color suqarBackgroundColor = Color(0xff212529);
// const Color suqarBackgroundColorLight = Colors.black12;
// const Color mainTextColor = Color(0xffFFFFFF);
// const Color subTextColor = Color(0xffD9D9D9);
// const Color qrcodeiconColor1 =Color(0xff20C997);
// const Color appbarColor =Color(0xff2B3136);
// const Color highlightColor = Color(0xff4FC3F7);
//
  ),
              //Mode
              Card(
                color: suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const Text(
                        "Mode :",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12, color: mainTextColor),
                      ),
                      const Spacer(),
                      Expanded(
                        child: FormBuilderChoiceChips<String>(
                          backgroundColor: Color(0xFF252525),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          //decoration: const InputDecoration(labelText: 'Type'),
                          name: 'Mode',
                          initialValue: updatedValues['Mode'],
                          selectedColor: Colors.lightBlueAccent,
                          options: const [
                            FormBuilderChipOption(
                              value: 'A',
                              child: Text('Auto',style: TextStyle(color: mainTextColor,fontSize: 12),),
                              // avatar: CircleAvatar(child: Text('')),
                            ),
                            FormBuilderChipOption(
                              value: 'M',
                              child: Text('Manual',style: TextStyle(color: mainTextColor,fontSize: 12)),
                              //avatar: CircleAvatar(child: Text('')),
                            ),
                          ],
                          // onChanged: _onChanged,

                          onChanged: _areFieldsDisabled ? null : (val) { // Disable onChanged if fields are disabled
                            setState(() {
                              _onChanged(val, updatedValues, 'Mode');
                              print(updatedValues['Mode']);
                            });
                          },
                          enabled: !_areFieldsDisabled,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //Phase
              Card(
                color: suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const Text(
                        "Phase Eng :",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12, color: mainTextColor),
                      ),
                      const Spacer(),
                      Expanded(
                        child: FormBuilderChoiceChips<String>(
                          backgroundColor: Color(0xFF252525),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          //decoration: const InputDecoration(labelText: 'Type'),
                          name: 'Phase Eng',
                          initialValue: updatedValues['Phase Eng'],
                          selectedColor: Colors.lightBlueAccent,
                          options: const [
                            FormBuilderChipOption(
                              value: '1',
                              avatar: CircleAvatar(child: Text('')),
                              child: Text(
                                '1',
                                style: const TextStyle(
                                  fontSize: 12, // Adjust text size
                                  color: mainTextColor, // Adjust text color
                                ),
                              ),
                            ),
                            FormBuilderChipOption(
                              value: '3',
                              avatar: CircleAvatar(child: Text('')),
                              child: Text(
                                '3',
                                style: const TextStyle(
                                  fontSize: 12, // Adjust text size
                                  color: mainTextColor, // Adjust text color
                                ),
                              ),
                            ),
                          ],
                          // onChanged: _onChanged,

                          onChanged: _areFieldsDisabled ? null : (val) { // Disable onChanged if fields are disabled
                            setState(() {
                              _onChanged(val, updatedValues, 'Phase Eng');
                              print(updatedValues['Phase Eng']);
                            });
                          },
                          enabled: !_areFieldsDisabled,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //YOM
              CustomTextField(
                textTitle: "Year of Manufacture :",
                isWantEdit: !_areFieldsDisabled,
                onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Year of Manufacture"),
                validator: (value) {
                  if (_areFieldsDisabled) {
                    return null; // Disable validation when fields are disabled
                  }

                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }

                  // Check if the input is a valid number
                  final number = int.tryParse(value);
                  if (number == null) {
                    return 'Please enter a\n valid number';
                  }

                  // Check if the number is within the specified range
                  if (number < 1900 || number > 3000) {
                    return 'Please enter a number\n between 1900 and 3000';
                  }

                  // Check if the input length is exactly 4 digits
                  if (value.length != 4) {
                    return 'Please enter exactly\n 4 digits';
                  }

                  return null; // Valid input
                },
                keyboardType: TextInputType.number,
              ),
              //YOI
              CustomTextField(
                textTitle: "Year of Install :",
                isWantEdit: !_areFieldsDisabled,
                onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Year of Install"),
                validator: (value) {
                  if (_areFieldsDisabled) {
                    return null; // Disable validation when fields are disabled
                  }

                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }

                  // Check if the input is a valid number
                  final number = int.tryParse(value);
                  if (number == null) {
                    return 'Please enter a\n valid number';
                  }

                  // Check if the number is within the specified range
                  if (number < 1900 || number > 3000) {
                    return 'Please enter a number\n between 1900 and 3000';
                  }

                  // Check if the input length is exactly 4 digits
                  if (value.length != 4) {
                    return 'Please enter exactly\n 4 digits';
                  }

                  return null; // Valid input
                },
                keyboardType: TextInputType.number,
              ),
              //Set Capacity
              CustomTextField(
                textTitle: "Set Capacity(kVA) :",
                isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
                onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Set Cap"),
                validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                keyboardType: TextInputType.number,

              ),

              const Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
                child: Text(
                  "Generator Specifications",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: mainTextColor),
                ),
              ),

              //Brand Alt
              Card(
                color: suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Alternator Brand :",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: mainTextColor,
                        ),
                      ),
                      const SizedBox(width: 10), // Add some space between the label and the dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: brandAlt.contains(updatedValues["Brand Alt"])
                              ? updatedValues["Brand Alt"]
                              : null, // Default value
                          items: [
                            ...brandAlt.where((String value) => value != "Other").map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(fontSize: 12, color: mainTextColor),),
                              );
                            }).toList(),
                            const DropdownMenuItem<String>(
                              value: "Other",
                              child: Text("Other",style: const TextStyle(fontSize: 12, color: mainTextColor),),
                            ),
                          ],
                          onChanged: _areFieldsDisabled ? null : (val) {
                            if (val == "Other") {
                              _showCustomBrandDialog(
                                key: "Brand Alt",
                                brandList: brandAlt,
                                formData: updatedValues,
                                formKey: "Brand Alt",
                              );
                            } else {
                              _onChanged(val, updatedValues, "Brand Alt");
                            }
                          },
                          validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
                            // Uncomment or add validators as needed
                            FormBuilderValidators.required(),
                          ]),
                          dropdownColor: Colors.grey,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF252525),
                            isDense: true, // Reduce vertical padding of the field
                            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ), // Add a border around the dropdown
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //Model Alt
              CustomTextField(
                textTitle: "Alternator Model :",
                isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
                onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Model Alt"),
                validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                keyboardType: TextInputType.name,
              ),
              //Serial Alt
              CustomTextField(
                textTitle: "Alternator serial :",
                isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
                onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Serial Alt"),
                validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                keyboardType: TextInputType.number,
              ),

              //Brand Eng
              Card(
                color: suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Engine Brand :",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: mainTextColor,
                        ),
                      ),
                      const SizedBox(width:10,), // Add some space between the label and the dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: brandeng.contains(updatedValues["Brand Eng"])
                              ? updatedValues["Brand Eng"]
                              : null, // Default value
                          items: [
                            ...brandeng.where((String value) => value != "Other").map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(fontSize: 12, color: mainTextColor),),
                              );
                            }).toList(),
                            const DropdownMenuItem<String>(
                              value: "Other",
                              child: Text("Other",style: const TextStyle(fontSize: 12, color: mainTextColor),),
                            ),
                          ],
                          onChanged: _areFieldsDisabled ? null : (val){
                            if (val == "Other") {
                              _showCustomBrandDialog(
                                key: "Brand Eng",
                                brandList: brandeng,
                                formData: updatedValues,
                                formKey: "Brand Eng",
                              );
                            } else {
                              _onChanged(val, updatedValues, "Brand Eng");
                            }
                          },
                          validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                          dropdownColor: Colors.grey,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF252525),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //Model eng
              CustomTextField(
                textTitle: "Engine Model :",
                isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
                onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Model Eng"),
                validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                keyboardType: TextInputType.name,
              ),
              //Serial Eng
              CustomTextField(
                textTitle: "Engine Serial :",
                isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
                onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Serial Eng"),
                validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                keyboardType: TextInputType.number,
              ),

              //Brand Set
              Card(
                color: suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Set Brand :",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: mainTextColor,
                        ),
                      ),
                      const SizedBox(width:10,), // Add some space between the label and the dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: brandset.contains(updatedValues["Brand Set"])
                              ? updatedValues["Brand Set"]
                              : null, // Default value
                          items: [
                            ...brandset.where((String value) => value != "Other").map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(fontSize: 12, color: mainTextColor),),
                              );
                            }).toList(),
                            const DropdownMenuItem<String>(
                              value: "Other",
                              child: Text("Other",style: const TextStyle(fontSize: 12, color: mainTextColor),),
                            ),
                          ],
                          onChanged: _areFieldsDisabled ? null : (val) {
                            if (val == "Other") {
                              _showCustomBrandDialog(
                                key: "Brand Set",
                                brandList: brandset,
                                formData: updatedValues,
                                formKey: "Brand Set",
                              );
                            } else {
                              _onChanged(val, updatedValues, "Brand Set");
                            }
                          },
                          validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                          dropdownColor: Colors.grey,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF252525),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //Model Set
              CustomTextField(
                textTitle: "Set Model :",
                isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
                onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Model Set"),
                validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                keyboardType: TextInputType.name,
              ),
              //Serial Set
              CustomTextField(
                textTitle: "Set Serial :",
                isWantEdit: !_areFieldsDisabled, // Disable the field if _areFieldsDisabled is true
                onChanged: _areFieldsDisabled ? null : (val) => _onChanged(val, updatedValues, "Serial Set"),
                validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                keyboardType: TextInputType.number,
              ),

              const Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
                child: Text(
                  "Controller Details",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: mainTextColor),
                ),
              ),

              //Controller
              Card(
                color: suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Controller Brand :",
                        style: TextStyle(
                          fontSize: 12,
                          color: mainTextColor,
                        ),
                      ),
                      const SizedBox(width:10,), // Add some space between the label and the dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: contBrand.contains(updatedValues["Controller"])
                              ? updatedValues["Controller"]
                              : null, // Default value
                          items: [
                            ...contBrand.where((String value) => value != "Other").map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(fontSize: 12, color: mainTextColor),),
                              );
                            }).toList(),
                            const DropdownMenuItem<String>(
                              value: "Other",
                              child: Text("Other",style: const TextStyle(fontSize: 12, color: mainTextColor),),
                            ),
                            const DropdownMenuItem<String>(
                              value: "Not Available",
                              child: Text("Not Available",style: const TextStyle(fontSize: 12, color: mainTextColor),),
                            ),
                          ],
                          onChanged: _areFieldsDisabled ? null : (val) {
                            if (val == "Not Available") {
                              setState(() {
                                isControllerModelEnabled = false;
                              });
                              _onChanged(null, updatedValues, "Controller Model"); // Clear the model value if disabled
                            } else {
                              setState(() {
                                isControllerModelEnabled = true;
                              });
                              _onChanged(val, updatedValues, "Controller");
                            }

                            if (val == "Other") {
                              _showCustomBrandDialog(
                                key: "Controller",
                                brandList: contBrand,
                                formData: updatedValues,
                                formKey: "Controller",
                              );
                            } else {
                              _onChanged(val, updatedValues, "Controller");
                            }
                          },
                          validator: _areFieldsDisabled ? null : FormBuilderValidators.compose([
                            // Uncomment or add validators as needed
                            //FormBuilderValidators.required(),
                          ]),
                          dropdownColor: Colors.grey,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF252525),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              //Controller Model
              CustomTextField(
                textTitle: "Controller Model :",
                isWantEdit: isControllerModelEnabled,
                onChanged: (val) =>
                    _onChanged(val, updatedValues, "Controller Model"),
                validator: isControllerModelEnabled
                    ? FormBuilderValidators.compose([
                  //FormBuilderValidators.required(),
                ])
                    : null,
                keyboardType: TextInputType.name,
                enabled: isControllerModelEnabled, // This will disable the field if false
              ),


              const Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
                child: Text(
                  "Tank Details",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: mainTextColor),
                ),
              ),

              //Tank cap Prime
              CustomTextField(
                textTitle: "Day Tank Capacity(L) :",
                isWantEdit: !_areFieldsDisabled,
                onChanged: !_areFieldsDisabled
                    ? (val) => _onChanged(val, updatedValues, "Tank Prime")
                    : null,
                validator: !_areFieldsDisabled
                    ? FormBuilderValidators.compose([
                  // FormBuilderValidators.required(),
                  // Add other validators here if needed
                ])
                    : null,
                keyboardType: TextInputType.number,
                enabled: !_areFieldsDisabled, // Ensure this field respects the disabled state
              ),



              //Bulk tank Available
              Card(
                color: suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const Text(
                        "Bulk Tank Available :",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12, color: mainTextColor),
                      ),
                      const Spacer(),
                      Expanded(
                        child: FormBuilderChoiceChips<String>(
                          backgroundColor: Color(0xFF252525),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          name: 'Bulk Tank',
                          initialValue: updatedValues['Bulk Tank'],
                          selectedColor: Colors.lightBlueAccent,
                          options: const [
                            FormBuilderChipOption(
                              value: '1',
                              child: Text('Yes',style: TextStyle(fontSize: 12,color: mainTextColor),),

                            ),
                            FormBuilderChipOption(
                              value: '0',
                              child: Text('No',style: TextStyle(fontSize: 12,color: mainTextColor)),
                            ),
                          ],
                          onChanged: !_areFieldsDisabled ? (val) {
                            setState(() {
                              if (val == '0') {
                                isDayTankSizeEnabled = false;
                                _onChanged(null, updatedValues, 'Day Tank Size');
                              } else {
                                isDayTankSizeEnabled = true;
                              }
                              _onChanged(val, updatedValues, 'Day Tank');
                            });
                          } : null, // Disable onChanged if fields are disabled
                          enabled: !_areFieldsDisabled, // Disable the chip if fields are disabled
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              //Bulk Tank Size(L)
              CustomTextField(
                textTitle: "Bulk Tank Size(L) :",
                isWantEdit: !_areFieldsDisabled && isDayTankSizeEnabled,
                onChanged: (!_areFieldsDisabled && isDayTankSizeEnabled)
                    ? (val) => _onChanged(val, updatedValues, "Bulk Tank Size")
                    : null,
                validator: (!_areFieldsDisabled && isDayTankSizeEnabled)
                    ? FormBuilderValidators.compose([
                  // FormBuilderValidators.required(),
                  // Add other validators here if needed
                ])
                    : null,
                keyboardType: TextInputType.number,
                enabled: !_areFieldsDisabled && isDayTankSizeEnabled, // Ensure this field respects both states
              ),




              const Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
                child: Text(
                  "ATS and Cabling",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: mainTextColor),
                ),
              ),

              //Brand ATS
              Card(
                color: suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "ATS Brand :",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: mainTextColor,
                        ),
                      ),
                      const  SizedBox(width:10,), // Add some space between the label and the dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: brandAts.contains(updatedValues["BrandATS"])
                              ? updatedValues["BrandATS"]
                              : null, // Default value
                          items: [
                            ...brandAts.where((String value) => value != "Other").map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(fontSize: 12, color: mainTextColor),),
                              );
                            }).toList(),
                            const DropdownMenuItem<String>(
                              value: "Other",
                              child: Text("Other",style: const TextStyle(fontSize: 12, color: mainTextColor),),
                            ),
                            const DropdownMenuItem<String>(
                              value: "Not Available",
                              child: Text("Not Available",style: const TextStyle(fontSize: 12, color: mainTextColor),),
                            ),
                          ],
                          onChanged: !_areFieldsDisabled
                              ? (val) {
                            setState(() {
                              if (val == "Not Available") {
                                isAtsFieldsEnabled = false;
                                // Clear the values and validators for the disabled fields
                                _onChanged(null, updatedValues, "Rating ATS");
                                _onChanged(null, updatedValues, "Model ATS");
                              } else {
                                isAtsFieldsEnabled = true;
                              }
                              _onChanged(val, updatedValues, "BrandATS");
                            });

                            if (val == "Other") {
                              _showCustomBrandDialog(
                                key: "BrandATS",
                                brandList: brandAts,
                                formData: updatedValues,
                                formKey: "BrandATS",
                              );
                            } else {
                              _onChanged(val, updatedValues, "BrandATS");
                            }
                          }
                              : null, // Disable onChanged if _areFieldsDisabled is true
                          validator: !_areFieldsDisabled
                              ? FormBuilderValidators.compose([
                            // Uncomment or add validators as needed
                            // FormBuilderValidators.required(),
                          ])
                              : null, // Disable validators if _areFieldsDisabled is true
                          dropdownColor: Colors.grey,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF252525),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                          disabledHint: const Text(""),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Rating ATS
              CustomTextField(
                textTitle: "ATS Rating(A) :",
                isWantEdit: !_areFieldsDisabled && isAtsFieldsEnabled,
                onChanged: !_areFieldsDisabled && isAtsFieldsEnabled
                    ? (val) => _onChanged(val, updatedValues, "Rating ATS")
                    : null,
                validator: !_areFieldsDisabled && isAtsFieldsEnabled
                    ? FormBuilderValidators.compose([
                  // FormBuilderValidators.required(),
                ])
                    : null,
                keyboardType: TextInputType.number,
                enabled: !_areFieldsDisabled && isAtsFieldsEnabled,
              ),

              // Model ATS
              CustomTextField(
                textTitle: "ATS Model :",
                isWantEdit: !_areFieldsDisabled && isAtsFieldsEnabled,
                onChanged: !_areFieldsDisabled && isAtsFieldsEnabled
                    ? (val) => _onChanged(val, updatedValues, "Model ATS")
                    : null,
                validator: !_areFieldsDisabled && isAtsFieldsEnabled
                    ? FormBuilderValidators.compose([
                  // FormBuilderValidators.required(),
                ])
                    : null,
                keyboardType: TextInputType.name,
                enabled: !_areFieldsDisabled && isAtsFieldsEnabled, // Ensure this field respects the enabled state
              ),

              //Feeder Cable
              CustomTextField(
                textTitle: "Feeder Cable Size(mm^2) :",
                isWantEdit: !_areFieldsDisabled,
                onChanged: !_areFieldsDisabled
                    ? (val) => _onChanged(val, updatedValues, "Feeder Size")
                    : null,
                validator: !_areFieldsDisabled
                    ? FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ])
                    : null,
                keyboardType: TextInputType.number,
              ),

              //MCCB
              CustomTextField(
                textTitle: "MCCB Rating(A) :",
                isWantEdit: !_areFieldsDisabled,
                onChanged: !_areFieldsDisabled
                    ? (val) => _onChanged(val, updatedValues, "Rating MCCB")
                    : null,
                validator: !_areFieldsDisabled
                    ? FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ])
                    : null,
                keyboardType: TextInputType.number,
              ),


              const Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
                child: Text(
                  "Battery Details",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: mainTextColor),
                ),
              ),

              //Bat count
              CustomTextField(
                textTitle: "Battery Count :",
                isWantEdit: !_areFieldsDisabled,
                onChanged: !_areFieldsDisabled
                    ? (val) => _onChanged(val, updatedValues, "Battery Count")
                    : null,
                validator: !_areFieldsDisabled
                    ? FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ])
                    : null,
                keyboardType: TextInputType.number,
              ),

              //Bat Brand
              Card(
                color: suqarBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Battery Brand :",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: mainTextColor,
                        ),
                      ),
                      const SizedBox(width:10,), // Add some space between the label and the dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: batBrand.contains(updatedValues["Battery Brand"])
                              ? updatedValues["Battery Brand"]
                              : null, // Default value
                          items: [
                            ...batBrand.where((String value) => value != "Other").map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(fontSize: 12, color: mainTextColor),),
                              );
                            }).toList(),
                            const DropdownMenuItem<String>(
                              value: "Other",
                              child: Text("Other",style: const TextStyle(fontSize: 12, color: mainTextColor),),
                            ),
                          ],
                          onChanged: !_areFieldsDisabled
                              ? (val) {
                            if (val == "Other") {
                              _showCustomBrandDialog(
                                key: "Battery Brand",
                                brandList: batBrand,
                                formData: updatedValues,
                                formKey: "Battery Brand",
                              );
                            } else {
                              _onChanged(val, updatedValues, "Battery Brand");
                            }
                          }
                              : null, // Disable onChanged if _areFieldsDisabled is true
                          validator: !_areFieldsDisabled
                              ? FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ])
                              : null, // Disable validators if _areFieldsDisabled is true
                          dropdownColor: Colors.grey,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF252525),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                          disabledHint: const Text(""),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //Bat Capacity
              CustomTextField(
                textTitle: "Battery Capacity(Ah) :",
                isWantEdit: !_areFieldsDisabled,
                onChanged: !_areFieldsDisabled
                    ? (val) => _onChanged(val, updatedValues, "Battery Capacity")
                    : null,
                validator: !_areFieldsDisabled
                    ? FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ])
                    : null,
                keyboardType: TextInputType.number,
              ),


              const Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
                child: Text(
                  "Service Provider",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: mainTextColor),
                ),
              ),

              CustomTextField(
                textTitle: "Local Agent :",
                isWantEdit: !_areFieldsDisabled,
                onChanged: !_areFieldsDisabled
                    ? (val) => _onChanged(val, updatedValues, "Local Agent")
                    : null,
                validator: !_areFieldsDisabled
                    ? FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ])
                    : null,
                keyboardType: TextInputType.name,
              ),

              CustomTextField(
                textTitle: "Agent Address :",
                isWantEdit: !_areFieldsDisabled,
                onChanged: !_areFieldsDisabled
                    ? (val) => _onChanged(val, updatedValues, "Agent Addr")
                    : null,
                validator: !_areFieldsDisabled
                    ? FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ])
                    : null,
                keyboardType: TextInputType.name,
              ),

              CustomTextField(
                textTitle: "Agent Telephone :",
                isWantEdit: !_areFieldsDisabled,
                onChanged: !_areFieldsDisabled
                    ? (val) => _onChanged(val, updatedValues, "Agent Tel")
                    : null,
                validator: !_areFieldsDisabled
                    ? (value) {
                  if (value == null || value.isEmpty) {
                    return null; // No validation error if the field is empty
                  }
                  if (value.length < 10) {
                    return 'Please enter between\n 1 and 10 digits';
                  }
                  return null; // Valid input
                }
                    : null,
                keyboardType: TextInputType.number,
              ),



              // Center(
              //   child: Text(
              //     "Update Details",
              //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              //   ),
              // ),
              //
              // CustomTextField(
              //   textTitle: "Updated By",
              //   isWantEdit: true,
              //   onChanged: (val) =>
              //       _onChanged(val, updatedValues, "Updated By"),
              //   // validator: FormBuilderValidators.compose([
              //   //   FormBuilderValidators.required(),
              //   // ]),
              //   keyboardType: TextInputType.name,
              // ),
              // GestureDetector(
              //   onTap: () {},
              //   //_selectDate(context, "Last Updated"),
              //   child: Card(
              //     child: Padding(
              //       padding: const EdgeInsets.all(10.0),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceAround,
              //         children: [
              //           Text(
              //             "Updated",
              //             style: TextStyle(
              //                 fontWeight: FontWeight.w500, fontSize: 15),
              //           ),
              //           Spacer(),
              //           Text(
              //             updatedValues['Updated'] ?? 'Not Set',
              //             style: TextStyle(fontSize: 15),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                      WidgetStatePropertyAll(mainTextColor),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6), // Customize the radius
                        ),
                      ),


                    ),
                    onPressed: () {
                      if (_formKey.currentState!.saveAndValidate()) {
                        print(updatedValues.toString());

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => HttpGeneratorGetPostPage(
                        //       formData: updatedValues,
                        //       Updator: updator,
                        //     ),
                        //   ),
                        // );
                      }
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Color.fromARGB(255, 122, 76, 146)),
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

// Map<String, dynamic> _getEditedFields(
//     Map<String, dynamic> updatedGeneratorDetails) {
//   final editedFields = <String, dynamic>{};
//   updatedGeneratorDetails.forEach((key, value) {
//     if (originalValues[key] != value) {
//       editedFields[key] = value;
//     }
//   });
//   print(editedFields.toString());
//   return editedFields;
// }
}

class CustomTextField extends StatelessWidget {
  final String textTitle;
  final bool isWantEdit;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool enabled;

  const CustomTextField({
    Key? key,
    required this.textTitle,
    required this.isWantEdit,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: suqarBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              textTitle,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12,color: mainTextColor),
            ),
            SizedBox(width:10,),
            Expanded(
              child: FormBuilderTextField(
                name: textTitle, style: TextStyle(fontSize: 12,color: mainTextColor),
                enabled: isWantEdit,
                decoration: const InputDecoration(
                  filled: true, // Enables background color
                  fillColor: Color(0xFF252525), // Background color of the input field
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none, // Removes the border
                    borderRadius: BorderRadius.all(Radius.circular(5)), // Optional: Rounded corners
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  // Adjust padding if needed
                ),
                onChanged: onChanged,
                validator: validator,
                keyboardType: keyboardType,

                autovalidateMode: AutovalidateMode.onUserInteraction,

              ),
            ),
          ],
        ),
      ),
    );
  }
}



//v3
// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:provider/provider.dart';
//
// import '../../../Widgets/GPSGrab/gps_location_widget.dart';
// import '../../HomePage/utils/colors.dart';
// import '../../UserAccess.dart';
// import 'httpPostGen.dart';
//
//
//
// class GeneratorDetailAddPage  extends StatefulWidget {
//
//
//
//   GeneratorDetailAddPage({Key? key}) : super(key: key);
//
//
//   @override
//   _GeneratorDetailAddPageState createState() => _GeneratorDetailAddPageState();
//
// }
//
// class _GeneratorDetailAddPageState extends State<GeneratorDetailAddPage> {
//   final _formKey = GlobalKey<FormBuilderState>();
//   String updator="";
//   //late Map<String, dynamic> originalValues;
//   Map<String, dynamic> updatedValues = {};
//   bool _isLoading = false;
//   bool _isManual = false;
//   bool _isAuto = false;
//
//   String _latitude = '';
//   String _longitude = '';
//   String _error = '';
//   bool isControllerModelEnabled = true;
//   bool isAtsFieldsEnabled = true;
//   bool isDayTankSizeEnabled = true;
//   bool _areFieldsDisabled = false;
//
//
//   var Regions = [
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
//     'UVA',
//     'Other'
//   ];
//
//   List<String> brandeng = ['Caterpillar', 'Chana', 'Cummins', 'Deutz', 'Detroit', 'Denyo', 'Greaves', 'Honda', 'Hyundai', 'Isuzu', 'John Deere', 'Komatsu', 'Kohler', 'Kubota', 'Lester', 'Mitsubishi', 'Onan', 'Perkins', 'Rusten', 'Unknown', 'Valmet', 'Volvo', 'Yanmar','Other'];
//   List<String> contBrand = ['DSE', 'HMI', 'Unknown','Other'];
//   List<String> brandset = ['Caterpillar', 'Cummins', 'Dale', 'Denyo', 'F.G.Wilson', 'Foracity', 'Greaves', 'John Deere', 'Jubilee', 'Kohler', 'Mitsui - Deutz', 'Mosa', 'Olympian', 'Onan', 'Pramac', 'Sanyo Denki', 'Siemens', 'Tempest', 'Unknown', 'Wega', 'Welland Power','Other'];
//   List<String> brandAlt=['Alsthom', 'Aulturdyne', 'Bosch', 'Caterpillar', 'Denyo', 'Greaves', 'Iskra', 'Kohler', 'Leroy Somer', 'Marelli', 'Mecc Alte', 'Mitsubishi', 'Perkins', 'Sanyo Denki', 'Siemens', 'Stamford', 'Taiyo', 'Tempest', 'Unknown', 'Wega','Other'];
//   List<String> brandAts=['Schnider', 'Cummins', 'Socomec','Unknown','Other'];
//   List<String> batBrand=['Amaron', 'Exide', 'Luminous','Volta','Okaya','LivGuard','Su-Kam','Shield','Other'];
//
//
//   void _fetchLocation() async {
//     setState(() {
//       _isLoading = true;
//       _error = ''; // Reset error message when starting to fetch location
//     });
//
//     try {
//       GPSLocationFetcher locationFetcher = GPSLocationFetcher();
//       Map<String, String> location = await locationFetcher.fetchLocation();
//
//       // Debug print to check the location map
//       debugPrint("Fetched location data: $location");
//
//       if (location.containsKey('latitude') && location.containsKey('longitude')) {
//         setState(() {
//           _latitude = location['latitude'] ?? '';
//           _longitude = location['longitude'] ?? '';
//           updatedValues['Latitude'] = _latitude; // Ensure you use 'Latitude' if it needs to be uppercase
//           updatedValues['Longitude'] = _longitude; // Ensure you use 'Longitude' if it needs to be uppercase
//           _isLoading = false;
//           debugPrint("Location $_latitude, $_longitude");
//         });
//       } else {
//         throw Exception('Location data is missing');
//       }
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//         debugPrint("Error: $_error");
//         _isLoading = false;
//       });
//     }
//   }
//
//
//
//   @override
//   void initState() {
//     super.initState();
//
//     updatedValues.addAll({"clockTime": ""});
//   }
//
//   void _onChanged(
//       dynamic val, Map<String, dynamic> formData, String fieldName) {
//     setState(() {
//       formData[fieldName] = val;
//
//       //updatedValues[fieldName] = val;
//     });
//   }
//
//   // void _selectDate(BuildContext context) async {
//   //   final DateTime? pickedDate = await showDatePicker(
//   //     context: context,
//   //     //initialDate: _selectedDate ?? DateTime.now(),
//   //     firstDate: DateTime(2000),
//   //     lastDate: DateTime(2101),
//   //   );
//   //
//   //   if (pickedDate != null && pickedDate != _selectedDate) {
//   //     setState(() {
//   //       _selectedDate = pickedDate;
//   //       _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
//   //       updatedValues['Installed Date'] =
//   //           DateFormat('yyyy-MM-dd').format(pickedDate);
//   //     });
//   //   }
//   // }
//
//   void _showCustomBrandDialog({
//     required String key,
//     required List<String?> brandList,
//     required Map<String, dynamic> formData,
//     required String formKey, // A unique key for the form
//   }) {
//     TextEditingController customBrandController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: const ColorScheme.light(primary: Colors.green),
//           ),
//           child: AlertDialog(
//             title: const Text("Add Custom Brand"),
//             content: TextField(
//               controller: customBrandController,
//               decoration: const InputDecoration(
//                 hintText: "Enter your brand name",
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text("Cancel"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               TextButton(
//                 child: const Text("OK"),
//                 onPressed: () {
//                   String customBrand = customBrandController.text.trim();
//                   if (customBrand.isNotEmpty) {
//                     setState(() {
//                       if (!brandList.contains(customBrand)) {
//                         brandList.add(customBrand);
//                       }
//                       formData[formKey] = customBrand;
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
//   @override
//   Widget build(BuildContext context) {
//     UserAccess userAccess = Provider.of<UserAccess>(context, listen: true); // Use listen: true to rebuild the widget when the data changes
//     updator=userAccess.username!;
//
//     return Scaffold(
//       backgroundColor: mainBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: mainBackgroundColor,
//         title: const Center(child: Text('Add DEG Details',style: TextStyle(color: mainTextColor, fontSize: 20),)),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 8.0),
//         child: FormBuilder(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   "Location",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: mainTextColor),
//                 ),
//               ),
//
//               //Province
//               Card(
//                 color: suqarBackgroundColor,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const Text(
//                         "Province :",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12,
//                           color: mainTextColor,
//                         ),
//                       ),
//                       SizedBox(width:10,),// Add some space between the label and the dropdown
//                       Expanded(