import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:theme_update/widgets/theme%20change%20related%20widjets/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:theme_update/theme_provider.dart';

class GPSLocationRibbon extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final bool showMapButton;
  
  const GPSLocationRibbon({
    Key? key, 
    this.latitude, 
    this.longitude,
    this.showMapButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final hasValidLocation = latitude != null && longitude != null && 
                             latitude != 0.0 && longitude != 0.0;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Icon(
              Icons.location_on,
              color: hasValidLocation ? Colors.green : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "GPS Coordinates",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: customColors.mainTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Lat: ${hasValidLocation ? latitude!.toStringAsFixed(6) : 'Not Available'}",
                    style: TextStyle(
                      color: customColors.subTextColor,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    "Long: ${hasValidLocation ? longitude!.toStringAsFixed(6) : 'Not Available'}",
                    style: TextStyle(
                      color: customColors.subTextColor,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (showMapButton)
              ElevatedButton.icon(
                onPressed: hasValidLocation ? () => _openMap(context) : null,
                icon: Icon(Icons.map, size: 18),
                label: Text("Map"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openMap(BuildContext context) async {
    if (latitude == null || longitude == null) return;
    
    final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    final uri = Uri.parse(url);
    
    try {
      if (!await launchUrl(uri)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open the map')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening map: $e')),
      );
    }
  }
}