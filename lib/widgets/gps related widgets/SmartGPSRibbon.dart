import 'package:flutter/material.dart';
import 'package:theme_update/widgets/gps%20related%20widgets/gps_location_ribbon.dart';
import 'package:theme_update/widgets/gps%20related%20widgets/gps_tag_widget.dart';

class SmartGPSRibbon extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final String region;
  final bool allowCapture; // New parameter to control capture behavior
  final Function(double latitude, double longitude)? onLocationUpdated;
  
  const SmartGPSRibbon({
    Key? key,
    this.latitude,
    this.longitude,
    required this.region,
    this.allowCapture = false, // Default to false (view mode)
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

  bool _isHQorWEL() {
    // Improved check for HQ/WEL using startsWith
    final normalizedRegion = widget.region.trim().toUpperCase();
    return normalizedRegion.startsWith('HQ') || normalizedRegion.startsWith('WEL');
  }
  
  @override
  Widget build(BuildContext context) {
    // If HQ or WEL, don't show anything
    if (_isHQorWEL()) {
      return SizedBox.shrink();
    }
    
    final bool hasCoordinates = _latitude != null && _longitude != null && 
                               _latitude != 0.0 && _longitude != 0.0;
    
    // If we have coordinates, just show the ribbon
    if (hasCoordinates) {
      return GPSLocationRibbon(
        latitude: _latitude,
        longitude: _longitude,
        showMapButton: true, // Always show map button for non-HQ/WEL
      );
    }
    
    // If we don't have coordinates but capture is not allowed (view mode),
    // show a message or nothing
    if (!widget.allowCapture) {
      // You could return a "No coordinates available" message here
      // Or just return nothing:
      return SizedBox.shrink();
    }
    
    // Otherwise (no coordinates but capture allowed), use the GPS tag widget
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
              showMapButton: true,
            ),
          ),
      ],
    );
  }
}