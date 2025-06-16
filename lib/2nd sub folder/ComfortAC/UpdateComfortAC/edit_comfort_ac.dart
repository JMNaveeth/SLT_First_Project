//import '../../../../../Widgets/GPSGrab/gps_location_widget.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';

import '../../../../../Widgets/LoadLocations/httpGetLocations.dart';
//import '../../../../../Widgets/LoadLocations/locationModel.dart';
import 'httpComfortACUpdatePost.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:provider/provider.dart';

class EditComfortAcPage extends StatefulWidget {
  final Map<String, dynamic> indoorData;
  final Map<String, dynamic> outdoorUnitData;
  final Map<String, dynamic> connectionData;
  final String? user;

  const EditComfortAcPage({
    super.key,
    required this.indoorData,
    required this.outdoorUnitData,
    required this.connectionData,
    required this.user,
  });

  @override
  _EditComfortAcPageState createState() => _EditComfortAcPageState();
}

class _EditComfortAcPageState extends State<EditComfortAcPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {}; // Store form data here

  // Indoor Unit Controllers
  late TextEditingController _acIndoorIdController;
  late TextEditingController _statusController;
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _capacityController;
  late TextEditingController _installationTypeController;
  late TextEditingController _refrigerantTypeController;
  late TextEditingController _powerSupplyController;
  late TextEditingController _TypeController;
  late TextEditingController _categoryController;
  late TextEditingController serial_numberController;
  late TextEditingController supplier_nameController;
  late TextEditingController po_numberController;
  late TextEditingController remote_availableController;
  late TextEditingController _notesController;

  late TextEditingController _last_updatedController;
  late TextEditingController _condition_ID_unitController;
  late TextEditingController _DoMController;
  late TextEditingController _installation_dateController;
  late TextEditingController _warranty_expiry_dateController;
  late TextEditingController _QR_InController;
  late TextEditingController _uploaded_byController;

  // Outdoor Unit Controllers
  late TextEditingController _outdoorUnitIdController;
  late TextEditingController _outdoorBrandController;
  late TextEditingController _outdoorModelController;
  late TextEditingController _outdoorCapacityController;
  late TextEditingController _outdoorFanModelController;

  late TextEditingController _outdoorstatusController;
  late TextEditingController _outdoorpower_supplyController;
  late TextEditingController _outdoorcompressor_mounted_withController;
  late TextEditingController _outdoorcompressor_capacityController;
  late TextEditingController _outdoorcompressor_brandController;
  late TextEditingController _outdoorcompressor_modelController;
  late TextEditingController _outdoorcompressor_serial_numberController;
  late TextEditingController _outdoorsupplier_nameController;
  late TextEditingController _outdoorpo_numberController;
  late TextEditingController _outdoornotesController;
  late TextEditingController _outdoorcondition_OD_unitController;
  late TextEditingController _outdoorlast_updatedController;
  late TextEditingController _outdoorDoMController;
  late TextEditingController _outdoorInstallation_DateController;
  late TextEditingController _outdoorwarranty_expiry_dateController;
  late TextEditingController _outdoorQR_OutController;
  late TextEditingController _outdooruploaded_byController;

  // Connection Controllers
  late TextEditingController _connectionlog_idController;
  late TextEditingController _connectionac_indoor_idController;
  late TextEditingController _connectionac_outdoor_idController;

  late TextEditingController _connectionNoAcPlantsController;
  late TextEditingController _connectionrtomController;
  late TextEditingController _connectionstationController;
  late TextEditingController _connectionrtom_building_idController;
  late TextEditingController _connectionfloor_numberController;
  late TextEditingController _connectionoffice_numberController;
  late TextEditingController _connectionlocationController;
  late TextEditingController _connectionQR_locController;
  late TextEditingController _connectionLongitudeController;
  late TextEditingController _connectionLatitudeController;
  late TextEditingController _connectionlast_updatedController;
  late TextEditingController _connectionuploaded_byController;
  late TextEditingController _regionController;

  @override
  void initState() {
    super.initState();

    // Initialize Indoor Unit Controllers
    _acIndoorIdController = TextEditingController(
      text: widget.indoorData['ac_indoor_id']?.toString(),
    );
    _statusController = TextEditingController(
      text: widget.indoorData['status']?.toString(),
    );
    _regionController = TextEditingController(
      text: widget.indoorData['region'] ?? '',
    );
    _brandController = TextEditingController(
      text: widget.indoorData['brand'] ?? '',
    );
    _modelController = TextEditingController(
      text: widget.indoorData['model'] ?? '',
    );
    _capacityController = TextEditingController(
      text: widget.indoorData['capacity'] ?? '',
    );
    _TypeController = TextEditingController(
      text: widget.indoorData['Type'] ?? '',
    );
    _installationTypeController = TextEditingController(
      text: widget.indoorData['installation_type'] ?? '',
    );
    _refrigerantTypeController = TextEditingController(
      text: widget.indoorData['refrigerant_type'] ?? '',
    );
    _powerSupplyController = TextEditingController(
      text: widget.indoorData['power_supply'] ?? '',
    );
    _categoryController = TextEditingController(
      text: widget.indoorData['category'] ?? '',
    );
    serial_numberController = TextEditingController(
      text: widget.indoorData['serial_number'] ?? '',
    );
    supplier_nameController = TextEditingController(
      text: widget.indoorData['supplier_name'] ?? '',
    );
    po_numberController = TextEditingController(
      text: widget.indoorData['po_number'] ?? '',
    );
    remote_availableController = TextEditingController(
      text: widget.indoorData['remote_available'] ?? '',
    );
    _notesController = TextEditingController(
      text: widget.indoorData['notes'] ?? '',
    );
    _last_updatedController = TextEditingController(
      text: widget.indoorData['last_updated'] ?? '',
    );
    _condition_ID_unitController = TextEditingController(
      text: widget.indoorData['condition_ID_unit'] ?? '',
    );
    _DoMController = TextEditingController(
      text: widget.indoorData['DoM'] ?? '',
    );
    _installation_dateController = TextEditingController(
      text: widget.indoorData['installation_date'] ?? '',
    );
    _warranty_expiry_dateController = TextEditingController(
      text: widget.indoorData['warranty_expiry_date'] ?? '',
    );
    _QR_InController = TextEditingController(
      text: widget.indoorData['QR_In'] ?? '',
    );
    _uploaded_byController = TextEditingController(
      text: widget.indoorData['uploaded_by'] ?? '',
    );

    // Initialize Outdoor Unit Controllers
    _outdoorUnitIdController = TextEditingController(
      text: widget.outdoorUnitData['ac_outdoor_id']?.toString(),
    );
    _outdoorBrandController = TextEditingController(
      text: widget.outdoorUnitData['brand'] ?? '',
    );
    _outdoorModelController = TextEditingController(
      text: widget.outdoorUnitData['model'] ?? '',
    );
    _outdoorCapacityController = TextEditingController(
      text: widget.outdoorUnitData['capacity'] ?? '',
    );
    _outdoorFanModelController = TextEditingController(
      text: widget.outdoorUnitData['outdoor_fan_model'] ?? '',
    );

    _outdoorstatusController = TextEditingController(
      text: widget.outdoorUnitData['status'] ?? '',
    );
    _outdoorpower_supplyController = TextEditingController(
      text: widget.outdoorUnitData['power_supply'] ?? '',
    );
    _outdoorcompressor_mounted_withController = TextEditingController(
      text: widget.outdoorUnitData['compressor_mounted_with'] ?? '',
    );
    _outdoorcompressor_capacityController = TextEditingController(
      text: widget.outdoorUnitData['compressor_capacity'] ?? '',
    );
    _outdoorcompressor_brandController = TextEditingController(
      text: widget.outdoorUnitData['compressor_brand'] ?? '',
    );
    _outdoorcompressor_modelController = TextEditingController(
      text: widget.outdoorUnitData['compressor_model'] ?? '',
    );
    _outdoorcompressor_serial_numberController = TextEditingController(
      text: widget.outdoorUnitData['compressor_serial_number'] ?? '',
    );
    _outdoorsupplier_nameController = TextEditingController(
      text: widget.outdoorUnitData['supplier_name'] ?? '',
    );
    _outdoorpo_numberController = TextEditingController(
      text: widget.outdoorUnitData['po_number'] ?? '',
    );
    _outdoornotesController = TextEditingController(
      text: widget.outdoorUnitData['notes'] ?? '',
    );
    _outdoorcondition_OD_unitController = TextEditingController(
      text: widget.outdoorUnitData['condition_OD_unit'] ?? '',
    );
    _outdoorlast_updatedController = TextEditingController(
      text: widget.outdoorUnitData['last_updated'] ?? '',
    );
    _outdoorDoMController = TextEditingController(
      text: widget.outdoorUnitData['DoM'] ?? '',
    );
    _outdoorInstallation_DateController = TextEditingController(
      text: widget.outdoorUnitData['Installation_Date'] ?? '',
    );
    _outdoorwarranty_expiry_dateController = TextEditingController(
      text: widget.outdoorUnitData['warranty_expiry_date'] ?? '',
    );
    _outdoorQR_OutController = TextEditingController(
      text: widget.outdoorUnitData['QR_Out'] ?? '',
    );
    _outdooruploaded_byController = TextEditingController(
      text: widget.outdoorUnitData['uploaded_by'] ?? '',
    );

    // Initialize Connection Controllers
    _connectionlog_idController = TextEditingController(
      text: widget.connectionData['log_id']?.toString(),
    );
    _connectionac_indoor_idController = TextEditingController(
      text: widget.connectionData['ac_indoor_id'] ?? '',
    );
    _connectionac_outdoor_idController = TextEditingController(
      text: widget.connectionData['ac_outdoor_id'] ?? '',
    );
    _connectionNoAcPlantsController = TextEditingController(
      text: widget.connectionData['no_AC_plants'] ?? '',
    );
    _connectionrtomController = TextEditingController(
      text: widget.connectionData['rtom'] ?? '',
    );

    _regionController = TextEditingController(
      text: widget.connectionData['region'] ?? '',
    );

    _connectionstationController = TextEditingController(
      text: widget.connectionData['station'] ?? '',
    );
    _connectionrtom_building_idController = TextEditingController(
      text: widget.connectionData['rtom_building_id'] ?? '',
    );
    _connectionfloor_numberController = TextEditingController(
      text: widget.connectionData['floor_number'] ?? '',
    );
    _connectionoffice_numberController = TextEditingController(
      text: widget.connectionData['office_number'] ?? '',
    );
    _connectionlocationController = TextEditingController(
      text: widget.connectionData['location'] ?? '',
    );
    _connectionQR_locController = TextEditingController(
      text: widget.connectionData['QR_loc'] ?? '',
    );
    _connectionLongitudeController = TextEditingController(
      text: widget.connectionData['Longitude'] ?? '',
    );
    _connectionLatitudeController = TextEditingController(
      text: widget.connectionData['Latitude'] ?? '',
    );
    _connectionlast_updatedController = TextEditingController(
      text: widget.connectionData['last_updated'] ?? '',
    );
    _connectionuploaded_byController = TextEditingController(
      text: widget.connectionData['uploaded_by'] ?? '',
    );
  }

  @override
  void dispose() {
    //indoor units dispose
    _acIndoorIdController.dispose();
    _statusController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _capacityController.dispose();
    _installationTypeController.dispose();
    _refrigerantTypeController.dispose();
    _powerSupplyController.dispose();
    _TypeController.dispose();
    _categoryController.dispose();
    serial_numberController.dispose();
    supplier_nameController.dispose();
    _notesController.dispose();
    _last_updatedController.dispose();
    _condition_ID_unitController.dispose();
    _DoMController.dispose();
    _installation_dateController.dispose();
    _warranty_expiry_dateController.dispose();
    _QR_InController.dispose();
    _uploaded_byController.dispose();

    //outdoor units dispose
    _outdoorUnitIdController.dispose();
    _outdoorBrandController.dispose();
    _outdoorModelController.dispose();
    _outdoorCapacityController.dispose();
    _outdoorFanModelController.dispose();

    _outdoorstatusController.dispose();
    _outdoorpower_supplyController.dispose();
    _outdoorcompressor_mounted_withController.dispose();
    _outdoorcompressor_capacityController.dispose();
    _outdoorcompressor_brandController.dispose();
    _outdoorcompressor_modelController.dispose();
    _outdoorcompressor_serial_numberController.dispose();
    _outdoorsupplier_nameController.dispose();
    _outdoorpo_numberController.dispose();
    _outdoornotesController.dispose();
    _outdoorcondition_OD_unitController.dispose();
    _outdoorlast_updatedController.dispose();
    _outdoorDoMController.dispose();
    _outdoorInstallation_DateController.dispose();
    _outdoorwarranty_expiry_dateController.dispose();
    _outdoorQR_OutController.dispose();
    _outdooruploaded_byController.dispose();

    //connection units dispose
    _connectionlog_idController.dispose();
    _connectionac_indoor_idController.dispose();
    _connectionac_outdoor_idController.dispose();
    _connectionNoAcPlantsController.dispose();
    _connectionrtomController.dispose();
    _connectionstationController.dispose();
    _connectionrtom_building_idController.dispose();
    _connectionfloor_numberController.dispose();
    _connectionoffice_numberController.dispose();
    _connectionlocationController.dispose();
    _connectionQR_locController.dispose();
    _connectionLongitudeController.dispose();
    _connectionLatitudeController.dispose();
    _connectionlast_updatedController.dispose();
    _connectionuploaded_byController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Comfort AC',
          style: TextStyle(color: customColors.mainTextColor),
        ),
        iconTheme: IconThemeData(color: customColors.mainTextColor),
        backgroundColor: customColors.appbarColor,
        actions: [ThemeToggleButton()],
      ),
      body: Container(
        color: customColors.mainBackgroundColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  buildIndoorUnitCard(),
                  buildOutdoorUnitCard(),
                  buildLatitudeLongitudeCard(),
                  // buildConnectionCard(LocationProvider()),
                  CupertinoButton(
                    color: Colors.blue[900], // Dark blue color
                    child: const Text(
                      'Send to Approve',
                      style: TextStyle(color: Colors.white),
                    ), // White text color
                    onPressed: () {
                      // Collect data and navigate to the post page
                      Map<String, dynamic> formDataList = {
                        'comfortAC_ID': _acIndoorIdController.text,
                        'QRIn': _QR_InController.text,
                        'Status': _statusController.text,
                        'Brand': _brandController.text,
                        'Model': _modelController.text,
                        'Capacity': _capacityController.text,
                        'InstallationType': _installationTypeController.text,
                        'RefrigerantType': _refrigerantTypeController.text,
                        'PowerSupply': _powerSupplyController.text,
                        'Type': _TypeController.text,
                        'Category': _categoryController.text,
                        'SerialNumber': serial_numberController.text,
                        'Supplier_Name': supplier_nameController.text,
                        'PONumber': po_numberController.text,
                        'RemoteAvailable': remote_availableController.text,
                        'Notes': _notesController.text,
                        'LastUpdated': _last_updatedController.text,
                        'ConditionID': _condition_ID_unitController.text,
                        'DoM': _DoMController.text,
                        'Installation_Date': _installation_dateController.text,
                        'WarrantyExpiryDate':
                            _warranty_expiry_dateController.text,
                        /////////////////////////////////////////

                        // 'IndoorBrand': formDataList['IndoorBrand'] ?? '',
                        // 'IndoorCapacity': formDataList['IndoorCapacity'] ?? '',
                        // 'Type': formDataList['type'] ?? '',
                        // 'Category': formDataList['category'] ?? '',
                        // 'InstallationType': formDataList['installationType'] ?? '',
                        // 'PowerSupply': formDataList['powerSupply'] ?? '',
                        // 'IndoorPONumber': formDataList['IndoorPONumber'] ?? '',
                        // 'RemoteAvailable': formDataList['remoteAvailable'] ?? '',
                        // 'IndoorNotes': formDataList['IndoorNotes'] ?? '',
                        // 'indoor_last_updated': formDataList['indoor_last_updated'] ?? '',
                        // 'IndoorConditionIDUnit': formDataList['IndoorConditionIDUnit'] ?? '',
                        // 'IndoorDoM': formDataList['IndoorDoM'] ?? '',

                        ///////////////////////////////////////////////////
                        'IndoorBrand': _brandController.text,
                        'IndoorCapacity': _capacityController.text,
                        'type': _TypeController.text,
                        'category': _categoryController.text,
                        'installationType': _installationTypeController.text,
                        'powerSupply': _powerSupplyController.text,
                        'IndoorPONumber': po_numberController.text,
                        'remoteAvailable': remote_availableController.text,
                        'IndoorNotes': _notesController.text,
                        'indoor_last_updated': _last_updatedController.text,
                        'IndoorConditionIDUnit':
                            _condition_ID_unitController.text,
                        'IndoorDoM': _DoMController.text,

                        ///////////////////////////////////////////////////
                        'UploadedBy': _uploaded_byController.text,
                        'OutdoorUnitID': _outdoorUnitIdController.text,
                        'OutdoorBrand': _outdoorBrandController.text,
                        'OutdoorModel': _outdoorModelController.text,
                        'OutdoorCapacity': _outdoorCapacityController.text,
                        'OutdoorFanModel': _outdoorFanModelController.text,
                        'OutdoorStatus': _outdoorstatusController.text,
                        'OutdoorPowerSupply':
                            _outdoorpower_supplyController.text,
                        'OutdoorCompressorMountedWith':
                            _outdoorcompressor_mounted_withController.text,
                        'OutdoorCompressorCapacity':
                            _outdoorcompressor_capacityController.text,
                        'OutdoorCompressorBrand':
                            _outdoorcompressor_brandController.text,
                        'OutdoorCompressorModel':
                            _outdoorcompressor_modelController.text,
                        'OutdoorCompressorSerialNumber':
                            _outdoorcompressor_serial_numberController.text,
                        'OutdoorSupplierName':
                            _outdoorsupplier_nameController.text,
                        'OutdoorPONumber': _outdoorpo_numberController.text,
                        'OutdoorNotes': _outdoornotesController.text,
                        'OutdoorConditionID':
                            _outdoorcondition_OD_unitController.text,
                        'OutdoorLastUpdated':
                            _outdoorlast_updatedController.text,
                        'OutdoorDoM': _outdoorDoMController.text,
                        'OutdoorInstallationDate':
                            _outdoorInstallation_DateController.text,
                        'OutdoorWarrantyExpiryDate':
                            _outdoorwarranty_expiry_dateController.text,
                        'OutdoorQROut': _outdoorQR_OutController.text,
                        'OutdoorUploadedBy': _outdooruploaded_byController.text,
                        'ConnectionLogID': _connectionlog_idController.text,
                        'ConnectionIndoorID':
                            _connectionac_indoor_idController.text,
                        'ConnectionOutdoorID':
                            _connectionac_outdoor_idController.text,
                        'Region': _regionController.text,
                        'RTOM': _connectionrtomController.text,
                        'Station': _connectionstationController.text,
                        'RTOMBuildingID':
                            _connectionrtom_building_idController.text,
                        'floor_number': _connectionfloor_numberController.text,
                        'Office_No': _connectionoffice_numberController.text,
                        'Location': _connectionlocationController.text,
                        'NoAcPlants': _connectionNoAcPlantsController.text,
                        'QRLoc': _connectionQR_locController.text,
                        'Longitude': _connectionLongitudeController.text,
                        'Latitude': _connectionLatitudeController.text,
                        'ConnectionLastUpdated':
                            _connectionlast_updatedController.text,
                        'ConnectionUploadedBy':
                            _connectionuploaded_byController.text,
                      };

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ComfortTestUpdatePost(
                                formDataList: formDataList,
                                user: widget.user,
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildIndoorUnitCard() {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Card(
      color: customColors.suqarBackgroundColor,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.blue, width: 2),
          // Thin blue accent border
          borderRadius: BorderRadius.circular(
            12,
          ), // Match the Card's border radius
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Indoor Units',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: _buildUneditableFormField(
                  'Indoor_Unit_Id',
                  'Indoor_Unit_Id',
                  _acIndoorIdController.text,
                ),
              ),
              ListTile(
                title: _StatusDropdown('status', 'status', _statusController),
              ),
              ListTile(
                title: _BrandDropdown('brand', 'brand', _brandController),
              ),
              ListTile(
                title: TextFormField(
                  controller: _modelController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(labelText: 'Model'),
                ),
              ),
              ListTile(
                title: _CustomCapacityDropdown(
                  'capacity',
                  'capacity',
                  _capacityController,
                ),
              ),
              ListTile(
                title: _InstallationCategoryDropdown(
                  'InstallationType',
                  'InstallationType',
                  _installationTypeController,
                ),
              ),
              ListTile(
                title: _CustomRefrigTypeDropdown(
                  'Refrigerant_type',
                  'Refrigerant_type',
                  _refrigerantTypeController,
                ),
              ),
              ListTile(
                title: _CustomPowerSupplyDropdown(
                  'power_supply',
                  'power_supply',
                  _powerSupplyController,
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _TypeController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(labelText: 'Type'),
                ),
              ),
              ListTile(
                title: _CustomCategoryDropdown(
                  'category',
                  'category',
                  _categoryController,
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: serial_numberController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(labelText: 'serial_number'),
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: supplier_nameController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(labelText: 'supplier_name'),
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: po_numberController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(labelText: 'po_number'),
                ),
              ),
              ListTile(
                title: _CustomRemoteDropdown(
                  'remote_available',
                  'remote_available',
                  remote_availableController,
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _notesController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(labelText: 'notes'),
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _last_updatedController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(labelText: 'last_updated'),
                ),
              ),
              ListTile(
                title: _CustomConditionDropdown(
                  'condition_ID_Unit',
                  'condition_ID_Unit',
                  _condition_ID_unitController,
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _DoMController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(labelText: 'DoM'),
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _installation_dateController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(
                    labelText: 'installation_date',
                  ),
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _warranty_expiry_dateController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(
                    labelText: 'warranty_expiry_date',
                  ),
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _QR_InController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(
                    labelText: 'Indoor Tag Code',
                  ),
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _uploaded_byController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(labelText: 'uploaded_by'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOutdoorUnitCard() {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Card(
      color: customColors.suqarBackgroundColor,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Color(0xFF2BDC27), width: 2),
          // Thin blue accent border
          borderRadius: BorderRadius.circular(
            12,
          ), // Match the Card's border radius
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Outdoor Units',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: _buildUneditableFormField(
                  'outdoor_unit_id',
                  'Outdoor unit id',
                  _outdoorUnitIdController.text,
                ),
              ),
              ListTile(
                title: _BrandDropdown(
                  'Brand',
                  'Brand',
                  _outdoorBrandController,
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _outdoorModelController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(labelText: 'Model'),
                ),
              ),
              ListTile(
                title: _CustomCapacityDropdown(
                  'Capacity',
                  'Capacity',
                  _outdoorCapacityController,
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _outdoorFanModelController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(
                    labelText: 'Outdoor Fan Model',
                  ),
                ),
              ),
              ListTile(
                title: _StatusDropdown('status', 'status', _statusController),
              ),
              ListTile(
                title: _CustomPowerSupplyDropdown(
                  'power_supply',
                  'power_supply',
                  _outdoorpower_supplyController,
                ),
              ),
              ListTile(
                title: _CustomCompressorMountDropdown(
                  'compressor_mounted_with',
                  'compressor_mounted_with',
                  _outdoorcompressor_mounted_withController,
                ),
              ),
              ListTile(
                title: _CustomCapacityDropdown(
                  'compressor_capacity',
                  'compressor_capacity',
                  _outdoorcompressor_capacityController,
                ),
              ),
              ListTile(
                title: _BrandDropdown(
                  'compressor_brand',
                  'compressor_brand',
                  _outdoorBrandController,
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _outdoorcompressor_modelController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(
                    labelText: 'compressor_model',
                  ),
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _outdoorcompressor_serial_numberController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(
                    labelText: 'compressor_serial_number',
                  ),
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _outdoorsupplier_nameController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(labelText: 'Supplier_Name'),
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _outdoorpo_numberController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(labelText: 'po_number'),
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _outdoornotesController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(labelText: 'notes'),
                ),
              ),
              ListTile(
                title: _CustomConditionDropdown(
                  'condition_OD_Unit',
                  'condition_OD_Unit',
                  _outdoorcondition_OD_unitController,
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _outdoorlast_updatedController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(labelText: 'last_updated'),
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _outdoorDoMController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(labelText: 'DoM'),
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _outdoorInstallation_DateController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(
                    labelText: 'Installation_Date',
                  ),
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _outdoorwarranty_expiry_dateController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(
                    labelText: 'Warranty_Expire_Date',
                  ),
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _outdoorQR_OutController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(labelText: 'QR_Out'),
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _outdooruploaded_byController,
                  style: TextStyle(color: customColors.mainTextColor),

                  decoration: const InputDecoration(labelText: 'uploaded_by'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isAutoLocationEnabled = false;

  // Dummy GPSLocationFetcher class
  // GPSLocationFetcher locationFetcher = GPSLocationFetcher();

  Future<void> fetchLocation() async {
    if (isAutoLocationEnabled) {
      //  final locationData = await locationFetcher.fetchLocation();
      setState(() {
        // _connectionLatitudeController.text = locationData['latitude']!;
        // _connectionLongitudeController.text = locationData['longitude']!;
      });
    }
  }

  Widget buildLatitudeLongitudeCard() {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Card(
      color: customColors.suqarBackgroundColor,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text(
                "Auto-Location",
                style: TextStyle(color: customColors.mainTextColor),
              ),
              value: isAutoLocationEnabled,
              onChanged: (value) async {
                setState(() {
                  isAutoLocationEnabled = value;
                });
                if (value) {
                  await fetchLocation();
                } else {
                  _connectionLatitudeController.clear();
                  _connectionLongitudeController.clear();
                }
              },
            ),
            ListTile(
              title: TextFormField(
                controller: _connectionLatitudeController,      style: TextStyle(color: customColors.mainTextColor),

                decoration: const InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,
                enabled:
                    !isAutoLocationEnabled, // Editable when auto-location is off
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: _connectionLongitudeController,      style: TextStyle(color: customColors.mainTextColor),

                decoration: const InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.number,
                enabled:
                    !isAutoLocationEnabled, // Editable when auto-location is off
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildConnectionCard(
    //LocationProvider
    locationProvider,
  ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Color(0xFF732BE0), width: 2),
          // Thin blue accent border
          borderRadius: BorderRadius.circular(
            12,
          ), // Match the Card's border radius
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Connection Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: _buildUneditableFormField(
                  'log_Id',
                  'log_Id',
                  _connectionlog_idController.text,
                ),
              ),
              ListTile(
                title: _buildUneditableFormField(
                  'ac_indoor_id',
                  'ac_indoor_id',
                  _connectionac_indoor_idController.text,
                ),
              ),
              ListTile(
                title: _buildUneditableFormField(
                  'ac_outdoor_id',
                  'ac_outdoor_id',
                  _connectionac_outdoor_idController.text,
                ),
              ),
              ListTile(
                title: _buildUneditableFormField(
                  'region',
                  'Region',
                  _regionController.text,
                ),
              ),

              ListTile(
                title: _buildUneditableFormField(
                  'RTOM',
                  'rtom',
                  _connectionrtomController.text,
                ),
              ),

              ListTile(
                title: _buildUneditableFormField(
                  'station',
                  'station',
                  _connectionstationController.text,
                ),
              ),
              ListTile(
                title: _buildUneditableFormField(
                  'rtom_building_id',
                  'rtom_building_id',
                  _connectionrtom_building_idController.text,
                ),
              ),
              ListTile(
                title: _buildUneditableFormField(
                  'floor_number',
                  'floor_number',
                  _connectionfloor_numberController.text,
                ),
              ),
              ListTile(
                title: _buildUneditableFormField(
                  'office_number',
                  'office_number',
                  _connectionoffice_numberController.text,
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _connectionlocationController,
                  decoration: const InputDecoration(labelText: 'location'),
                ),
              ),
              ListTile(
                title: _buildUneditableFormField(
                  'no_AC_plants',
                  'no_AC_plants',
                  _connectionNoAcPlantsController.text,
                ),
              ),
              ListTile(
                title: _buildUneditableFormField(
                  'QR_loc',
                  'QR_loc',
                  _connectionQR_locController.text,
                ),
              ),
              // ListTile(title: TextFormField(controller: _connectionLongitudeController, decoration: InputDecoration(labelText: 'Longitude'))),
              // ListTile(title: TextFormField(controller: _connectionLatitudeController, decoration: InputDecoration(labelText: 'Latitude'))),
              ListTile(
                title: _buildUneditableFormField(
                  'last_updated',
                  'last_updated',
                  _connectionlast_updatedController.text,
                ),
              ),
              ListTile(
                title: _buildUneditableFormField(
                  'uploaded_by',
                  'uploaded_by',
                  _connectionuploaded_byController.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //dropdowns
  Widget _RegionDropdown(
    String key,
    String label,
    //  LocationProvider
    locationProvider,
  ) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    if (locationProvider.isLoading || locationProvider.isCustomRegion) {
      return const Center(child: CircularProgressIndicator());
    }

    return FormBuilderDropdown<String>(
      name: key,
      style: TextStyle(color: customColors.mainTextColor),

      initialValue: locationProvider.selectedRegion,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items: [
        ...locationProvider.regions.map(
          (region) => DropdownMenuItem<String>(
            value: region.Region_ID,
            child: Text(region.RegionName),
          ),
        ),
        const DropdownMenuItem<String>(value: 'Other', child: Text('Other')),
      ],
      validator:
          (value) =>
              value == null || value.isEmpty ? 'Please select $label' : null,
      onChanged: (value) {
        if (value == 'Other') {
          _showAddNewValueDialog(context, key, label, locationProvider);
        } else {
          // Get the region name based on selected Region_ID
          String? selectedRegionName =
              locationProvider.regions
                  .firstWhere(
                    (region) => region.Region_ID == value,
                    // orElse: () => null,
                  )
                  .RegionName;

          setState(() {
            // Store the region name in the formData
            formData[key] = value;
            locationProvider.selectedRegion =
                value; // Update the selected region
          });
        }
      },
    );
  }

  // Modify this method to immediately update the regions list and form data
  void _showAddNewValueDialog(
    BuildContext context,
    String key,
    String label,
    //   LocationProvider
    locationProvider,
  ) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New $label'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter new $label'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Validate input and add to provider's regions
                String newValue = controller.text.trim();
                if (newValue.isNotEmpty) {
                  setState(() {
                    // Update the regions list
                    locationProvider.regions.add(
                      // Region
                      (Region_ID: newValue, RegionName: newValue),
                    ); // Adjust according to your Region model
                    // Update the form data
                    formData[key] =
                        newValue; // Update the form data immediately
                    locationProvider.selectedRegion =
                        newValue; // Set the new value as selected
                  });
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Region Dropdown Widget

  List<String> Regions = [
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

  Widget _RegionDropdown2(
    String key,
    String label,
    TextEditingController regionController,
  ) {
    // Check if the manufacturer value from widget.acUnit is not in the list
    String RegionFromAcUnit = _regionController.text;
    if (RegionFromAcUnit.isNotEmpty &&
        !Regions.contains(RegionFromAcUnit) &&
        RegionFromAcUnit != 'Other') {
      Regions.insert(
        Regions.length - 1,
        RegionFromAcUnit,
      ); // Insert it before 'Other'
    }

    return FormBuilderDropdown(
      name: key,
      initialValue:
          formData[key] ??
          RegionFromAcUnit, // Set initial value from widget.acUnit['Manufacturer']
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items:
          Regions.map(
            (Manufacturer) => DropdownMenuItem(
              value: Manufacturer,
              child: Text(Manufacturer),
            ),
          ).toList(),
      validator: (value) {
        if (value == null || value.toString().isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          formData[key] = value;
        });

        if (value == 'Other') {
          _showCustomRegionDialog(key);
        }
      },
    );
  }

  void _showCustomRegionDialog(String key) {
    TextEditingController customRegionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.green),
          ),
          child: AlertDialog(
            title: const Text("Add Region"),
            content: TextField(
              controller: customRegionController,
              decoration: const InputDecoration(hintText: "Enter Region name"),
              autofocus: true, // Automatically focus on the input field
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  String customRegion = customRegionController.text.trim();
                  if (customRegion.isNotEmpty &&
                      !Regions.contains(customRegion)) {
                    setState(() {
                      Regions.insert(Regions.length - 1, customRegion);
                      formData[key] = customRegion;
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

  //rtom dropdown

  List<String> Rtoms = [
    "Dambulla",
    "Kandy",
    "Matala",
    "Gampola",
    "Hatton",
    "Nuwara Eliya",
    "Ampara",
    "Batticaloa",
    "Kalmunai",
    "Facility Management",
    "Data Center_Pitipana",
    "SEA.ME.WE.5 Unit",
    "Anuradhapura",
    "Polonnaruwa",
    "Jaffna",
    "Kilinochichi",
    "Mannar",
    "Mullativu",
    "Trincomalee",
    "Vavuniya",
    "Kuliyapitiya",
    "Kurunegala",
    "Chilaw",
    "Puttalam",
    "Power & AC Op.SEC",
    "Empilipitiya",
    "Kegalle",
    "Ratnapura",
    "Stores Center SEC",
    "Hambantota",
    "Matara",
    "Ambalangoda",
    "Galle",
    "Telecom Training Center_Galle",
    "Telecom Training Center_Moratuwa",
    "Telecom Training Center_Peradeniya",
    "Telecom Training Center_Welisara",
    "Badulla",
    "Bandarawela",
    "Monaragala",
    "Havelock Town",
    "Maradana",
    "Kolonnawa",
    "Kotte",
    "Negombo",
    "Wattala",
    "Gampaha",
    "Kelaniya",
    "Nittabmuwa",
    "Horana",
    "Kalutara",
    "Panadura",
    "Avissawella",
    "Homagama",
    "Nugegoda",
    "Ratmalana",
    "HQ",
    "Welikada",
    "SMW5",
    "SMW6",
    "Pitipana",
    "Other",
  ];

  //brand dropdown

  Widget _RTOMDropdown(
    String key,
    String label,
    TextEditingController brandController,
  ) {
    String RtomsFromAcUnit = _connectionrtomController.text;

    if (RtomsFromAcUnit.isNotEmpty && !Rtoms.contains(RtomsFromAcUnit)) {
      Rtoms.add(
        RtomsFromAcUnit,
      ); // Add the status if it's not already in the list
    }

    return FormBuilderDropdown(
      name: key,
      initialValue: formData[key] ?? RtomsFromAcUnit,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items:
          Rtoms.map(
            (RTOM) => DropdownMenuItem(value: RTOM, child: Text(RTOM)),
          ).toList(),
      validator: (value) {
        if (value == null || value.toString().isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          formData[key] = value;
        });

        if (value == 'Other') {
          _showCustomRtomDialog(key);
        }
      },
    );
  }

  void _showCustomRtomDialog(String key) {
    TextEditingController customRtomController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.green),
          ),
          child: AlertDialog(
            title: const Text("Add Custom RTOM"),
            content: TextField(
              controller: customRtomController,
              decoration: const InputDecoration(
                hintText: "Enter your RTOM name",
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  String customRtom = customRtomController.text.trim();
                  if (customRtom.isNotEmpty) {
                    setState(() {
                      Rtoms.insert(Rtoms.length - 1, customRtom);
                      formData[key] = customRtom;
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

  //rtom dropdown

  //station dropdown

  List<String> Stations = [
    "EXCHANGE DAMBULLA",
    "EXCHANGE (GLW) GALEWELA",
    "EXCHANGE KIMBISSA",
    "SLT TOWER WALMORUWA",
    "UDUDENIYA",
    "NALANDA -MT-MOBITEL TOWER",
    "WALAWWATHTHA",
    "KANADANA",
    "BELIGAMUWA LTE SITE",
    "SIYAMBALAWEWA",
    "BELIYAKANDA",
    "GALEWELA -MT-MOBITEL TOWER 17 1/2",
    "MORAGASWEWA",
    "HABARANA -MT-MSAN ARAMA ROAD",
    "PANNAMPITIYA",
    "LELADORA",
    "DAMBULLA -MT-ETISALAT TOWER GALEWELA RD",
    "WAHAKOTTE -MT-HUTCH SITE INAMALUWA",
    "MATALE -MT-MOBITEL TOWER RANGIRI",
    "DAMBULLA -MT-MSAN KITHULHIYAWA",
    "BEKARI KADAYA",
    "MADATUGAMA MATALE MT-MOBITEL TOWER WAWALAWAWA",
    "DAMBULLA -MT-MOBITEL TOWER YAPAGAMA",
    "DAMBULLA -MT-MOBITEL TOWER NO:32",
    "KANDALAMA",
    "DAMBULLA",
    "AIRTEL TOWER 96",
    "MORAGOLLAWA DAMBULLA -MT-AIRTEL TOWER PALLANYAYA",
    "THALKIRIYA",
    "DAMBULLA -MT-AIRTEL TOWER DIGAMPATHAHA",
    "KIMBISSA",
    "LANKA BELL TOWER EDERAGALA",
    "PELWEHERA",
    "DAMBULLA -MT-AIRTEL TOWER GAMPATHI",
    "NIWASA",
    "TRINCO RD",
    "HABARANA",
    "EXCHANGE (WIIL) WILLGAMUWA",
    "EXCHANGE (BKM) BAKAMOONA",
    "EXCHANGE HABARANA",
    "MATALE",
    "RSU NAULA",
    "MATALE -MT-NL",
    "QTR RATHNAYAKE I.V",
    "IPT",
    "MATALE -MT-(REQUITRED)",
    "MANAGERTHE. L.P.T. NIWASA",
    "SRI LANKA TELECOM",
    "BAKAMUNA",
    "MSAN ELAHERA",
    "BAKAMOONA -MT-ELH",
    "MSAN KOTTAPITIYA",
    "BAKAMOONA -MT-KTP",
    "MSAN ORUBENDISIYAMBALAWA BAKAMOONA -MT-OBS",
    "MSAN POLICE JUNCTION",
    "BAKAMOONA -MT",
    "MSAN ARAWWALA SCHOOL PLY RD",
    "MSAN CLOCK TOWER",
    "DAMBULLA -MT-CKT",
    "MSAN COURT JUNCTION",
    "DAMBULLA -MT-CTJ",
    "MSAN KALUNDEWA JUNCTION",
    "DAMBULLA -MT-KDJ",
    "MSAN KITHULHITIYAWA",
    "MT",
    "MSAN ALUTHGAMA",
    "KALUNDEWA -MT",
    "MSAN KAPUWATHTHA",
    "DAMBULLA -MT-KPW",
    "MSAN SPLIT UNIT",
    "MORAGOLLEWA WATHTHA JUNCTION",
    "MATALE RD",
    "DAMBULLA -MT-MGW",
    "MSAN MIRISGONIYA",
    "DAMBULLA -MT-MSG",
    "MSAN PELWEHERA",
    "DAMBULLA -MT-PVH",
    "MSAN NEAR MAIN ENTRANCE",
    "RANGIRI DAMBULLA CRICKET GORUND",
    "DAMBULLA -MT-RSJ",
    "MSAN SISIRA WATHTHA",
    "DAMBULLA -MT",
    "MSAN CIC",
    "NEAR THE YOUHRT FARM",
    "TAHALAKIRIYAGAMA",
    "DAMBULLA -MT",
    "MSAN ERULA JUNCTION",
    "DAMBULLA",
    "MSAN BELIYANKANDA",
    "GALEWELA -MT-BKD",
    "MSAN BAMBARAGASWEWA ROAD",
    "ALUTHWEWA -MT-BMB",
    "MSAN SPLIT UNIT",
    "ETHABENDIWEWA",
    "THALAKIRIYAGAMA",
    "MATALE",
    "MSAN HOMBAWA",
    "BAMABARAGASWEWA",
    "GALEWELA -MT-HMB",
    "MSAN KANADANA",
    "GALEWELA -MT-KDN",
    "MSAN PAHALAWELA JUNCTION",
    "THALAKIRIYAGAMA -MT-TKG",
    "MSAN ALUPOTHA",
    "MADIPOLA -MT-MAP",
    "MSAN MADABEDDA",
    "WAHAKOTTE -MT-MDB",
    "MSAN MAKULGASWEWA",
    "DEWAHUWA -MT-MGW",
    "MSAN MATALE JUNCTION",
    "GALEWELA -MT",
    "MSAN TELECOM",
    "DAMBAGAHAMULA JUNCTION",
    "BELIGAMUWA",
    "GALEWELA -MT",
    "MSAN PAHALAWELA",
    "GALEWELA -MT",
    "MSAN PATTIWELA",
    "GALEWELA -MT-PTW",
    "MSAN PUWAKPITIYA",
    "GALEWELA -MT-PWP",
    "MSAN WAHAKOTTE -MT-WHK",
    "MSAN DIGAMPATAHA",
    "MATALE -MT",
    "MSAN KASYAPAGAMA",
    "HABARANA -MT-KSJ",
    "MSAN 18 MILE POST",
    "IRIGEOYA",
    "MORAGASWEWA -MT",
    "MSAN THIBIRIGASWEWA",
    "HABARANA -MT-TBG",
    "MSAN NEW LAGGALA",
    "DEGAWELA -MT-LGL",
    "MSAN AMBANA JUNCTION",
    "AMBANA -MT-ABJ",
    "MSAN RESERVOIR ROAD",
    "BOWATANNA -MT-BWT",
    "MSAN DIYANKADUWA JUNCTION",
    "MELPITIYA",
    "DIYANKADUWA -MT",
    "MSAN HUNGAWELA JUNCTION",
    "HUNGAWELA -MT-HGW",
    "MSAN HELAMBAGAHAWATTHA -MT",
    "MSAN KATAWALA JUNCTION",
    "KATAWALA",
    "MADAWALA ULPOTHA -MT-KWJ",
    "MSAN NEAR CEMETRY",
    "DAMBULLA ROAD",
    "LENADORA -MT-LND",
    "MSAN POLE MONTED UNIT",
    "MELPITIYA -MT",
    "MSAN MADAWALA ULPOTHA",
    "MATALE -MT",
    "MSAN NEAR NALANDA INDUSATIRAL ESTATE",
    "NALANDA -MT",
    "MSAN NIKULA",
    "BIBILA -MT-NKB",
    "MSAN SPLIT UNIT",
    "MURUTHOLUWA",
    "MELPITI",
    "MATALE",
    "MSAN PANNAMPITIYA",
    "LENADORA -MT",
    "MSAN UDUDENIYA",
    "NALANDA -MT",
    "MSAN KANDALAMA",
    "MATALE -MT",
    "MSAN NEAR THE PRESCO WATER VILLA",
    "EHELAGALA -MT-EHJ",
    "MSAN WIUYANAWA ELEPHANT CORRIDOR JUNCTION",
    "GALAKOTUWA -MT-EPC",
    "MSAN INAMALUWA JUNCTION",
    "INAMALUWA -MT-IML",
    "MSAN CLOSE TO GREEN PARADISE HOTEL",
    "KALUDIYAPOKUNA -MT-KDP",
    "MSAN OPPOSITE THE MOAQUE",
    "NIKAWATHENNA -MT",
    "SLT TOWER KASYAPAGAMA",
    "HABARANA -MT",
    "MSAN TELECOM TOWER",
    "MATALE ROAD",
    "GALEWELA -MT",
    "Mobitel Tower",
    "Karawilahena",
    "Naula",
    "SLT TOWER AHASPOKUNA",
    "KANDY",
    "EXCHANGE WATTEGAMA",
    "KANDY",
    "LTE SLT BTS GERADIYAGALA",
    "GALAGEDARA -KY",
    "MOBITEL TOWER UDATHALAWINNA",
    "PANVILA -KY",
    "MOBITEL TOWER PITIYAKUMBURAWATTHA",
    "NAPANA",
    "MADAWALA -KY",
    "RSU (RA) RANGALA",
    "KANDY",
    "CDMA TOWER MEEKANUWA",
    "RSU (PUDUKADUWA)",
    "EXCHANGE (LO) RANGIRI DMB",
    "Other",
  ];

  //brand dropdown

  Widget _StationDropdown(
    String key,
    String label,
    TextEditingController brandController,
  ) {
    String StationFromAcUnit = _connectionstationController.text;

    if (StationFromAcUnit.isNotEmpty && !Stations.contains(StationFromAcUnit)) {
      Stations.add(
        StationFromAcUnit,
      ); // Add the status if it's not already in the list
    }

    return FormBuilderDropdown(
      name: key,
      initialValue: formData[key] ?? StationFromAcUnit,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items:
          Stations.map(
            (Stations) =>
                DropdownMenuItem(value: Stations, child: Text(Stations)),
          ).toList(),
      validator: (value) {
        if (value == null || value.toString().isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          formData[key] = value;
        });

        if (value == 'Other') {
          _showCustomStationDialog(key);
        }
      },
    );
  }

  void _showCustomStationDialog(String key) {
    TextEditingController customStationController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.green),
          ),
          child: AlertDialog(
            title: const Text("Add Custom Station"),
            content: TextField(
              controller: customStationController,
              decoration: const InputDecoration(
                hintText: "Enter new Station name",
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  String customStation = customStationController.text.trim();
                  if (customStation.isNotEmpty) {
                    setState(() {
                      Stations.insert(Stations.length - 1, customStation);
                      formData[key] = customStation;
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

  //station dropdown

  List<String> statuses = [
    'StandBy',
    'Running',
    'Stopped',
    'Waiting to dispose',
  ];

  Widget _StatusDropdown(
    String key,
    String label,
    TextEditingController statusController,
  ) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    // Get the status value from widget.acUnit and add it to the list if not already present
    String statusFromAcUnit = _statusController.text;

    if (statusFromAcUnit.isNotEmpty && !statuses.contains(statusFromAcUnit)) {
      statuses.add(
        statusFromAcUnit,
      ); // Add the status if it's not already in the list
    }

    return FormBuilderDropdown(
      name: key,
      style: TextStyle(color: customColors.mainTextColor),

      initialValue:
          formData[key] ??
          statusFromAcUnit, // Set initial value from widget.acUnit['Status']
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      dropdownColor: customColors.suqarBackgroundColor,

      items:
          statuses
              .map(
                (status) =>
                    DropdownMenuItem(value: status, child: Text(status)),
              )
              .toList(),
      validator: (value) {
        if (value == null || value.toString().isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          formData[key] = value;
        });
      },
    );
  }

  List<String> brands = [
    'Mitsubishi',
    'Abans',
    'LG',
    'Panasonic',
    'York',
    'Hitachi',
    'Other',
  ];

  //brand dropdown

  Widget _BrandDropdown(
    String key,
    String label,
    TextEditingController brandController,
  ) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    String brandsFromAcUnit = _brandController.text;

    if (brandsFromAcUnit.isNotEmpty && !brands.contains(brandsFromAcUnit)) {
      brands.add(
        brandsFromAcUnit,
      ); // Add the status if it's not already in the list
    }

    return FormBuilderDropdown(
      name: key,
      style: TextStyle(color: customColors.mainTextColor),

      initialValue: formData[key] ?? brandsFromAcUnit,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      dropdownColor: customColors.suqarBackgroundColor,

      items:
          brands
              .map(
                (brand) => DropdownMenuItem(value: brand, child: Text(brand)),
              )
              .toList(),
      validator: (value) {
        if (value == null || value.toString().isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          formData[key] = value;
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
            colorScheme: const ColorScheme.light(primary: Colors.green),
          ),
          child: AlertDialog(
            title: const Text("Add Custom Brand"),
            content: TextField(
              controller: customBrandController,
              decoration: const InputDecoration(
                hintText: "Enter your brand name",
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
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
                      brands.insert(brands.length - 1, customBrand);
                      formData[key] = customBrand;
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
    '0.75'
        'TR',
    '1.00'
        'TR',
    '1.50'
        'TR',
    '2.00'
        'TR',
    '2.50'
        'TR',
    '3.00'
        'TR',
    'Other',
  ];

  Widget _CustomCapacityDropdown(
    String key,
    String label,
    TextEditingController capacityController,
  ) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    String CapacityFromAcUnit = _capacityController.text;

    if (CapacityFromAcUnit.isNotEmpty &&
        !Capacity.contains(CapacityFromAcUnit)) {
      Capacity.add(
        CapacityFromAcUnit,
      ); // Add the status if it's not already in the list
    }

    return FormBuilderDropdown(
      name: key,
      style: TextStyle(color: customColors.mainTextColor),

      initialValue: formData[key] ?? CapacityFromAcUnit,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      dropdownColor: customColors.suqarBackgroundColor,

      items:
          Capacity.map(
            (Capacity) =>
                DropdownMenuItem(value: Capacity, child: Text(Capacity)),
          ).toList(),
      validator: (value) {
        if (value == null || value.toString().isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          formData[key] = value;
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
            colorScheme: const ColorScheme.light(primary: Colors.green),
          ),
          child: AlertDialog(
            title: const Text("Add Custom Brand"),
            content: TextField(
              controller: customCapacityController,
              decoration: const InputDecoration(
                hintText: "Enter Capacity(4.00TR)",
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  String customCapacity = customCapacityController.text.trim();
                  if (customCapacity.isNotEmpty) {
                    setState(() {
                      Capacity.insert(Capacity.length - 1, customCapacity);
                      formData[key] = customCapacity;
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

  List<String> ITC = [
    'Wall Mount',
    'Floor Stand',
    'Ceiling Mount',
    'Ceiling Cassette',
    'Other',
  ];

  Widget _InstallationCategoryDropdown(
    String key,
    String label,
    TextEditingController installationTypeController,
  ) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    String ITCFromAcUnit = _installationTypeController.text;

    if (ITCFromAcUnit.isNotEmpty && !ITC.contains(ITCFromAcUnit)) {
      ITC.add(ITCFromAcUnit); // Add the status if it's not already in the list
    }

    return FormBuilderDropdown(
      name: key,
      style: TextStyle(color: customColors.mainTextColor),

      initialValue: formData[key] ?? ITCFromAcUnit,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      dropdownColor: customColors.suqarBackgroundColor,

      items:
          ITC
              .map(
                (InsTypeC) =>
                    DropdownMenuItem(value: InsTypeC, child: Text(InsTypeC)),
              )
              .toList(),
      validator: (value) {
        if (value == null || value.toString().isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          formData[key] = value;
        });

        if (value == 'Other') {
          _showCustomInstallationTypeDialog(key);
        }
      },
    );
  }

  void _showCustomInstallationTypeDialog(String key) {
    TextEditingController customITCController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.green),
          ),
          child: AlertDialog(
            title: const Text("Add Custom Install type"),
            content: TextField(
              controller: customITCController,
              decoration: const InputDecoration(
                hintText: "Enter Installation type",
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  String customITC = customITCController.text.trim();
                  if (customITC.isNotEmpty) {
                    setState(() {
                      ITC.insert(ITC.length - 1, customITC);
                      formData[key] = customITC;
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

  List<String> RefrigType = ['R410', 'R410A', 'R22', 'R32', 'R407C', 'Other'];

  Widget _CustomRefrigTypeDropdown(
    String key,
    String label,
    TextEditingController capacityController,
  ) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    String RefrigTypeFromAcUnit = _refrigerantTypeController.text;

    if (RefrigTypeFromAcUnit.isNotEmpty &&
        !RefrigType.contains(RefrigTypeFromAcUnit)) {
      RefrigType.add(
        RefrigTypeFromAcUnit,
      ); // Add the status if it's not already in the list
    }

    return FormBuilderDropdown(
      name: key,
      style: TextStyle(color: customColors.mainTextColor),

      initialValue: formData[key] ?? RefrigTypeFromAcUnit,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      dropdownColor: customColors.suqarBackgroundColor,

      items:
          RefrigType.map(
            (refrigType) =>
                DropdownMenuItem(value: refrigType, child: Text(refrigType)),
          ).toList(),
      validator: (value) {
        if (value == null || value.toString().isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          formData[key] = value;
        });

        if (value == 'Other') {
          _showCustomRefrigtypeDialog(key);
        }
      },
    );
  }

  void _showCustomRefrigtypeDialog(String key) {
    TextEditingController customRefrigController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.green),
          ),
          child: AlertDialog(
            title: const Text("Add Custom Refrigerant"),
            content: TextField(
              controller: customRefrigController,
              decoration: const InputDecoration(
                hintText: "Enter Refrigerant(R22)",
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  String customCapacity = customRefrigController.text.trim();
                  if (customCapacity.isNotEmpty) {
                    setState(() {
                      RefrigType.insert(RefrigType.length - 1, customCapacity);
                      formData[key] = customCapacity;
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

  List<String> PowerSupply = ['1P', '3P', 'Other'];

  Widget _CustomPowerSupplyDropdown(
    String key,
    String label,
    TextEditingController capacityController,
  ) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    String PowerSupplyFromAcUnit = _powerSupplyController.text;

    if (PowerSupplyFromAcUnit.isNotEmpty &&
        !PowerSupply.contains(PowerSupplyFromAcUnit)) {
      PowerSupply.add(
        PowerSupplyFromAcUnit,
      ); // Add the status if it's not already in the list
    }

    return FormBuilderDropdown(
      name: key,
      style: TextStyle(color: customColors.mainTextColor),

      initialValue: formData[key] ?? PowerSupplyFromAcUnit,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      dropdownColor: customColors.suqarBackgroundColor,

      items:
          PowerSupply.map(
            (powerSupply) =>
                DropdownMenuItem(value: powerSupply, child: Text(powerSupply)),
          ).toList(),
      validator: (value) {
        if (value == null || value.toString().isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          formData[key] = value;
        });

        if (value == 'Other') {
          _showCustomPowerSupplyDialog(key);
        }
      },
    );
  }

  void _showCustomPowerSupplyDialog(String key) {
    TextEditingController customPowerSupplyController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.green),
          ),
          child: AlertDialog(
            title: const Text("Add Custom Power Supply"),
            content: TextField(
              controller: customPowerSupplyController,
              decoration: const InputDecoration(hintText: "Enter Power Supply"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  String customCapacity =
                      customPowerSupplyController.text.trim();
                  if (customCapacity.isNotEmpty) {
                    setState(() {
                      PowerSupply.insert(
                        PowerSupply.length - 1,
                        customCapacity,
                      );
                      formData[key] = customCapacity;
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

  List<String> RemoteStatus = ['Yes', 'No', 'Other'];

  Widget _CustomRemoteDropdown(
    String key,
    String label,
    TextEditingController capacityController,
  ) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    String RemoteStatusFromAcUnit = remote_availableController.text;

    if (RemoteStatusFromAcUnit.isNotEmpty &&
        !RemoteStatus.contains(RemoteStatusFromAcUnit)) {
      RemoteStatus.add(
        RemoteStatusFromAcUnit,
      ); // Add the status if it's not already in the list
    }

    return FormBuilderDropdown(
      name: key,
      style: TextStyle(color: customColors.mainTextColor),

      initialValue: formData[key] ?? RemoteStatusFromAcUnit,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      dropdownColor: customColors.suqarBackgroundColor,

      items:
          RemoteStatus.map(
            (powerSupply) =>
                DropdownMenuItem(value: powerSupply, child: Text(powerSupply)),
          ).toList(),
      validator: (value) {
        if (value == null || value.toString().isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          formData[key] = value;
        });

        if (value == 'Other') {
          _showCustomRemoteStatusDialog(key);
        }
      },
    );
  }

  void _showCustomRemoteStatusDialog(String key) {
    TextEditingController customRemoteStatusController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.green),
          ),
          child: AlertDialog(
            title: const Text("Add Custom Remote status"),
            content: TextField(
              controller: customRemoteStatusController,
              decoration: const InputDecoration(
                hintText: "Enter Remote Status",
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  String customCapacity =
                      customRemoteStatusController.text.trim();
                  if (customCapacity.isNotEmpty) {
                    setState(() {
                      RemoteStatus.insert(
                        RemoteStatus.length - 1,
                        customCapacity,
                      );
                      formData[key] = customCapacity;
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

  List<String> Category = ['Inverter', 'Non Inverter', 'Other'];

  Widget _CustomCategoryDropdown(
    String key,
    String label,
    TextEditingController capacityController,
  ) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    String RemoteCategoryFromAcUnit = _categoryController.text;

    if (RemoteCategoryFromAcUnit.isNotEmpty &&
        !Category.contains(RemoteCategoryFromAcUnit)) {
      Category.add(
        RemoteCategoryFromAcUnit,
      ); // Add the status if it's not already in the list
    }

    return FormBuilderDropdown(
      name: key,
      style: TextStyle(color: customColors.mainTextColor),

      initialValue: formData[key] ?? RemoteCategoryFromAcUnit,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      dropdownColor: customColors.suqarBackgroundColor,

      items:
          Category.map(
            (category) =>
                DropdownMenuItem(value: category, child: Text(category)),
          ).toList(),
      validator: (value) {
        if (value == null || value.toString().isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          formData[key] = value;
        });

        if (value == 'Other') {
          _showCustomcategoryStatusDialog(key);
        }
      },
    );
  }

  void _showCustomcategoryStatusDialog(String key) {
    TextEditingController customCategoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.green),
          ),
          child: AlertDialog(
            title: const Text("Add Custom Category"),
            content: TextField(
              controller: customCategoryController,
              decoration: const InputDecoration(hintText: "Enter Category"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  String customCapacity = customCategoryController.text.trim();
                  if (customCapacity.isNotEmpty) {
                    setState(() {
                      Category.insert(Category.length - 1, customCapacity);
                      formData[key] = customCapacity;
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

  List<String> Condition = [
    'Good',
    'Faulty',
    'Standby',
    'Stopped',
    'Waiting to dispose',
    'Other',
  ];

  Widget _CustomConditionDropdown(
    String key,
    String label,
    TextEditingController capacityController,
  ) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    String ConditionFromAcUnit = _condition_ID_unitController.text;

    if (ConditionFromAcUnit.isNotEmpty &&
        !Condition.contains(ConditionFromAcUnit)) {
      Condition.add(
        ConditionFromAcUnit,
      ); // Add the status if it's not already in the list
    }

    return FormBuilderDropdown(
      name: key,
      style: TextStyle(color: customColors.mainTextColor),

      initialValue: formData[key] ?? ConditionFromAcUnit,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      dropdownColor: customColors.suqarBackgroundColor,

      items:
          Condition.map(
            (condition) =>
                DropdownMenuItem(value: condition, child: Text(condition)),
          ).toList(),
      validator: (value) {
        if (value == null || value.toString().isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          formData[key] = value;
        });

        if (value == 'Other') {
          _showCustomConditionDialog(key);
        }
      },
    );
  }

  void _showCustomConditionDialog(String key) {
    TextEditingController customCategoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.green),
          ),
          child: AlertDialog(
            title: const Text("Add Custom condition"),
            content: TextField(
              controller: customCategoryController,
              decoration: const InputDecoration(hintText: "Enter condition"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  String customCapacity = customCategoryController.text.trim();
                  if (customCapacity.isNotEmpty) {
                    setState(() {
                      Category.insert(Category.length - 1, customCapacity);
                      formData[key] = customCapacity;
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

  List<String> CompressorMount = ['Indoor', 'Outdoor'];

  Widget _CustomCompressorMountDropdown(
    String key,
    String label,
    TextEditingController capacityController,
  ) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    String CompressorMountFromAcUnit =
        _outdoorcompressor_mounted_withController.text;

    if (CompressorMountFromAcUnit.isNotEmpty &&
        !CompressorMount.contains(CompressorMountFromAcUnit)) {
      CompressorMount.add(
        CompressorMountFromAcUnit,
      ); // Add the status if it's not already in the list
    }

    return FormBuilderDropdown(
      name: key,
      style: TextStyle(color: customColors.mainTextColor),

      initialValue: formData[key] ?? CompressorMountFromAcUnit,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      dropdownColor: customColors.suqarBackgroundColor,

      items:
          CompressorMount.map(
            (compressorMount) => DropdownMenuItem(
              value: compressorMount,
              child: Text(compressorMount),
            ),
          ).toList(),
      validator: (value) {
        if (value == null || value.toString().isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          formData[key] = value;
        });

        if (value == 'Other') {
          _showcompressorMountDialog(key);
        }
      },
    );
  }

  void _showcompressorMountDialog(String key) {
    TextEditingController customCompressorMountController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.green),
          ),
          child: AlertDialog(
            title: const Text("Add Custom condition"),
            content: TextField(
              controller: customCompressorMountController,
              decoration: const InputDecoration(hintText: "Enter condition"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  String customCapacity =
                      customCompressorMountController.text.trim();
                  if (customCapacity.isNotEmpty) {
                    setState(() {
                      CompressorMount.insert(
                        CompressorMount.length - 1,
                        customCapacity,
                      );
                      formData[key] = customCapacity;
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

  Widget _buildUneditableFormField(
    String key,
    String label,
    String initialValue,
  ) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Column(
      children: [
        FormBuilderTextField(
          name: key,
          style: TextStyle(color: customColors.mainTextColor),

          decoration: InputDecoration(
            labelText: label,
            border: const UnderlineInputBorder(),
          ),
          initialValue: initialValue,
          readOnly: true,
          enabled: false,
          // Make the field uneditable
          onChanged: (value) {
            setState(() {
              formData[key] = value ?? '';
            });
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
