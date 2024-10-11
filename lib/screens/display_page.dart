import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class DisplayPage extends StatefulWidget {
  const DisplayPage({super.key});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  Map<String, dynamic>? item;
  bool isLoading = true;
  bool hasError = false;
  String locationMessage = "";

  @override
  void initState() {
    super.initState();
    fetch();
    _checkGPSAndFetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Smart Ambulance System',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 120, 190, 247),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const Center(
                  child: Text('An error occurred, please try again later.'))
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextRow('Name:', item?['name'] ?? 'Unknown'),
                      const SizedBox(height: 15),
                      _buildTextRow('Age:', item?['age']?.toString() ?? 'N/A'),
                      const SizedBox(height: 15),
                      _buildTextRow(
                          'Phone Number:', item?['phone-number'] ?? 'N/A'),
                      const SizedBox(height: 15),
                      _buildTextRow('Emergency Contact Name:',
                          item?['emg-contact-name'] ?? 'N/A'),
                      const SizedBox(height: 15),
                      _buildTextRow(
                          'Relation:', item?['emg-contact-relation'] ?? 'N/A'),
                      const SizedBox(height: 15),
                      _buildTextRow('Emergency Contact Phone:',
                          item?['emg-contact-phno'] ?? 'N/A'),
                      const SizedBox(height: 15),
                      _buildTextRow(
                          'Blood Group:', item?['blood-grp'] ?? 'N/A'),
                      const SizedBox(height: 20),
                      const Text(
                        'Current Location:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(locationMessage.isNotEmpty
                          ? locationMessage
                          : 'Fetching location...'),
                    ],
                  ),
                ),
    );
  }

  Widget _buildTextRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> fetch() async {
    final url = 'http://172.17.99.78:3000/items';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List jsonData = jsonDecode(response.body);
        setState(() {
          item = jsonData.isNotEmpty ? jsonData[0] : null; // Get the first item
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> _checkGPSAndFetchLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if GPS is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      setState(() {
        locationMessage = "GPS is disabled. Please enable it.";
      });
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        setState(() {
          locationMessage = "Location permissions are denied.";
        });
        return;
      }
    }

    // If permissions are denied forever
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        locationMessage = "Location permissions are permanently denied.";
      });
      return;
    }

    // Permissions are granted, now get the location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      locationMessage =
          "Lat: ${position.latitude}, Long: ${position.longitude}";
    });
  }
}
