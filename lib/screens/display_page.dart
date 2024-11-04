import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'emergency_protocol.dart'; // Import the emergency protocol page
import 'temp_emg.dart';
import 'add_form_page.dart'; // Import your FormPage here

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
    _savePageState(); // Save the state when the page is opened
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
      body: Stack(
        children: [
          isLoading
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
          // Edit Button
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                // Navigate to FormPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormPage()),
                );
              },
              child: const Icon(Icons.edit),
              mini: true, // Make the button smaller
              backgroundColor: const Color(0xFF78BEF7), // Background color
            ),
          ),
        ],
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
    // Check GPS and permissions
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
        builder: (context) => EmergencyProtocolPageTemp(
          data: widget.data,
          location: locationMessage,
        ),
      ),
    );
  }

  // Save page state in SharedPreferences
  Future<void> _savePageState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Save that the app was on DisplayPage and save the data
    await prefs.setString('lastPage', 'DisplayPage');
    await prefs.setString('name', widget.data['name'] ?? '');
    await prefs.setString('age', widget.data['age'] ?? '');
    await prefs.setString('phone-number', widget.data['phone-number'] ?? '');
    await prefs.setString(
        'emg-contact-name', widget.data['emg-contact-name'] ?? '');
    await prefs.setString(
        'emg-contact-relation', widget.data['emg-contact-relation'] ?? '');
    await prefs.setString(
        'emg-contact-phno', widget.data['emg-contact-phno'] ?? '');
    await prefs.setString('blood-grp', widget.data['blood-grp'] ?? '');
  }
}
