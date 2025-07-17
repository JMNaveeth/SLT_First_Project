import 'package:flutter/material.dart';
import 'package:theme_update/widgets/gps_tag_widget.dart';
import 'package:theme_update/widgets/gps_location_ribbon.dart';

class SmartGPSRibbon extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final String region;
  final Function(double latitude, double longitude)? onLocationUpdated;
  
  const SmartGPSRibbon({
    Key? key,
    this.latitude,
    this.longitude,
    required this.region,
    this.onLocationUpdated,
  }) : super(key: key);

  @override
  _SmartGPSRibbonState createState() => _SmartGPSRibbonState();
}

class _SmartGPSRibbonState extends State<SmartGPSRibbon> {
  double? _latitude;
  double? _longitude;
  
  @override
  void initState() {
    super.initState();
    _latitude = widget.latitude;
    _longitude = widget.longitude;
  }
  
  void _onLocationFound(double lat, double lng) {
    setState(() {
      _latitude = lat;
      _longitude = lng;
    });
    
    if (widget.onLocationUpdated != null) {
      widget.onLocationUpdated!(lat, lng);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final bool isHQorWEL = widget.region.trim().toUpperCase() == 'HQ' || 
                           widget.region.trim().toUpperCase() == 'WEL';
    
    // If we have coordinates or we're in HQ/WEL, just show the ribbon
    if ((_latitude != null && _longitude != null) || isHQorWEL) {
      return GPSLocationRibbon(
        latitude: _latitude,
        longitude: _longitude,
        showMapButton: !isHQorWEL,
      );
    }
    
    // Otherwise, use the GPS tag widget to capture location
    return Column(
      children: [
        ReusableGPSWidget(
          onLocationFound: _onLocationFound,
          region: widget.region,
          customButtonColor: Colors.blue,
        ),
        if (_latitude != null && _longitude != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: GPSLocationRibbon(
              latitude: _latitude,
              longitude: _longitude,
            ),
          ),
      ],
    );
  }
}