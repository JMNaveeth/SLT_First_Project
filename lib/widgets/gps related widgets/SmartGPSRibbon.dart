import 'package:flutter/material.dart';
import 'package:theme_update/widgets/gps%20related%20widgets/gps_location_ribbon.dart';
import 'package:theme_update/widgets/gps%20related%20widgets/gps_tag_widget.dart';

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

  // New helper method to make the logic clearer
  bool _shouldShowMapButton() {
    // Don't show map button for HQ or WEL locations
    final normalizedRegion = widget.region.trim().toUpperCase();
    return normalizedRegion != 'HQ' && normalizedRegion != 'WEL';
  }
  
  @override
  Widget build(BuildContext context) {
    final bool isHQorWEL = !_shouldShowMapButton();
    final bool hasCoordinates = _latitude != null && _longitude != null && 
                               _latitude != 0.0 && _longitude != 0.0;
    
    // If we have coordinates or we're in HQ/WEL, just show the ribbon
    if (hasCoordinates || isHQorWEL) {
      return GPSLocationRibbon(
        latitude: _latitude,
        longitude: _longitude,
        showMapButton: _shouldShowMapButton(),  // Only show button for non-HQ/WEL
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
              showMapButton: _shouldShowMapButton(),  // Only show button for non-HQ/WEL
            ),
          ),
      ],
    );
  }
}