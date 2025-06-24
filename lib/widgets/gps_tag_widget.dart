import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ReusableGPSWidget extends StatefulWidget {
  final Function(double latitude, double longitude) onLocationFound;
  final String? customButtonText;
  final Color? customButtonColor;

  const ReusableGPSWidget({
    Key? key,
    required this.onLocationFound,
    this.customButtonText,
    this.customButtonColor,
  }) : super(key: key);

  @override
  _ReusableGPSWidgetState createState() => _ReusableGPSWidgetState();
}

class _ReusableGPSWidgetState extends State<ReusableGPSWidget> {
  bool _isLoading = false;
  String _statusMessage = '';
  bool _locationCaptured = false;
  double? _capturedLat;
  double? _capturedLng;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _getCurrentLocation,
              icon: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Icon(
                      _locationCaptured ? Icons.check_circle : Icons.location_on,
                      size: 20,
                    ),
              label: Text(
                _isLoading
                    ? 'Getting Location...'
                    : _locationCaptured
                        ? 'Location Captured ✓'
                        : widget.customButtonText ?? 'Tag Generator Location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _locationCaptured
                    ? Colors.green
                    : widget.customButtonColor ?? Colors.blue,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          if (_statusMessage.isNotEmpty)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _statusMessage.contains('Error')
                    ? Colors.red.shade50
                    : Colors.green.shade50,
                border: Border.all(
                  color: _statusMessage.contains('Error')
                      ? Colors.red.shade200
                      : Colors.green.shade200,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _statusMessage,
                style: TextStyle(
                  color: _statusMessage.contains('Error')
                      ? Colors.red.shade700
                      : Colors.green.shade700,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          if (_locationCaptured && _capturedLat != null && _capturedLng != null)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.green, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'GPS Location Captured',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Latitude: ${_capturedLat!.toStringAsFixed(6)}',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                  Text(
                    'Longitude: ${_capturedLng!.toStringAsFixed(6)}',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                  Text(
                    'Time: ${DateTime.now().toString().substring(0, 16)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '';
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoading = false;
            _statusMessage = 'Error: Location permission denied. Please allow location access.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoading = false;
        });
        _showPermissionDialog();
        return;
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
          _statusMessage = 'Error: GPS is turned off. Please turn on location services.';
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );

      setState(() {
        _capturedLat = position.latitude;
        _capturedLng = position.longitude;
        _locationCaptured = true;
        _statusMessage = 'Location captured successfully!';
        _isLoading = false;
      });

      widget.onLocationFound(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: ${e.toString()}';
        _isLoading = false;
        _locationCaptured = false;
      });
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Location Permission Needed'),
        content: Text('Location permission is permanently denied. Do you want to open settings to allow location?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close dialog
              await Geolocator.openAppSettings();
              // Try again after returning from settings
              _getCurrentLocation();
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}