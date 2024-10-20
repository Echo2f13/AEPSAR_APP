import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'emergency_protocol.dart'; // Import the emergency protocol page

class DisplayPage extends StatefulWidget {
  final Map<String, String> data;

  const DisplayPage({super.key, required this.data});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  String locationMessage = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
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
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: const Color(0xFF78BEF7),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Information Container
                  _buildInfoContainer(),
                  const SizedBox(height: 20),
                  // Location Information
                  const Text(
                    'Current Location:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1F5FE),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF0288D1),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      locationMessage.isNotEmpty
                          ? locationMessage
                          : 'Fetching location...',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF007BB6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Emergency Button
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _handleEmergency();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'EMERGENCY!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Container to hold the personal information details
  Widget _buildInfoContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Change background color to white
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextRow('Name:', widget.data['name'] ?? 'Unknown'),
          const Divider(color: Colors.grey),
          const SizedBox(height: 10),
          _buildTextRow('Age:', widget.data['age'] ?? 'N/A'),
          const Divider(color: Colors.grey),
          const SizedBox(height: 10),
          _buildTextRow('Phone Number:', widget.data['phone-number'] ?? 'N/A'),
          const Divider(color: Colors.grey),
          const SizedBox(height: 10),
          _buildTextRow('Emergency Contact Name:',
              widget.data['emg-contact-name'] ?? 'N/A'),
          const Divider(color: Colors.grey),
          const SizedBox(height: 10),
          _buildTextRow(
              'Relation:', widget.data['emg-contact-relation'] ?? 'N/A'),
          const Divider(color: Colors.grey),
          const SizedBox(height: 10),
          _buildTextRow('Emergency Contact Phone:',
              widget.data['emg-contact-phno'] ?? 'N/A'),
          const Divider(color: Colors.grey),
          const SizedBox(height: 10),
          _buildTextRow('Blood Group:', widget.data['blood-grp'] ?? 'N/A'),
        ],
      ),
    );
  }

  // Function to style each row of data
  Widget _buildTextRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF1B5E20),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _checkGPSAndFetchLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if GPS is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        locationMessage = "GPS is disabled. Please enable it.";
        isLoading = false;
      });
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          locationMessage = "Location permissions are denied.";
          isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        locationMessage = "Location permissions are permanently denied.";
        isLoading = false;
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      locationMessage =
          "Lat: ${position.latitude}, Long: ${position.longitude}";
      isLoading = false;
    });
  }

  // Function to handle the emergency button press
  void _handleEmergency() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmergencyProtocolPage(
          data: widget.data,
          location: locationMessage,
        ),
      ),
    );
  }
}
