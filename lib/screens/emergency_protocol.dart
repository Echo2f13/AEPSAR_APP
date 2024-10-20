//Emergency Protocol

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EmergencyProtocolPage extends StatefulWidget {
  final Map<String, String> data;
  final String location;

  const EmergencyProtocolPage({
    super.key,
    required this.data,
    required this.location,
  });

  @override
  _EmergencyProtocolPageState createState() => _EmergencyProtocolPageState();
}

class _EmergencyProtocolPageState extends State<EmergencyProtocolPage> {
  List<File> _imageFiles = []; // List to store captured images

  @override
  void initState() {
    super.initState();
    _captureMultipleImages(); // Automatically capture 5 images
  }

  // Function to capture 5 images sequentially
  Future<void> _captureMultipleImages() async {
    for (int i = 0; i < 4; i++) {
      await _openCamera();
    }
  }

  // Function to open the camera and capture one image
  Future<void> _openCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFiles.add(File(pickedFile.path)); // Add each image to the list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Emergency Protocol',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emergency Protocol Heading
              Center(
                child: Column(
                  children: const [
                    Text(
                      'EMERGENCY PROTOCOL',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Sharing the following details with the nearest health center:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Form Details with Icon & Style
              _buildFormDetail(
                icon: Icons.person,
                label: 'Name:',
                value: widget.data['name'] ?? 'Unknown',
              ),
              const SizedBox(height: 15),
              _buildFormDetail(
                icon: Icons.phone,
                label: 'Phone Number:',
                value: widget.data['phone-number'] ?? 'N/A',
              ),
              const SizedBox(height: 15),
              _buildFormDetail(
                icon: Icons.contact_phone,
                label: 'Emergency Contact:',
                value: widget.data['emg-contact-phno'] ?? 'N/A',
              ),
              const SizedBox(height: 15),
              _buildFormDetail(
                icon: Icons.bloodtype,
                label: 'Blood Group:',
                value: widget.data['blood-grp'] ?? 'N/A',
              ),
              const SizedBox(height: 30),

              // Location Details Section
              const Text(
                'Location Details:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.location.isNotEmpty
                    ? widget.location
                    : 'Location data unavailable',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 30),

              // Captured Images Section
              const Text(
                'Captured Images:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              _buildImageGrid(), // Show all captured images
            ],
          ),
        ),
      ),
    );
  }

  // Widget to display form detail with an icon
  Widget _buildFormDetail({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.redAccent, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Function to display the images in a grid format
  Widget _buildImageGrid() {
    if (_imageFiles.isEmpty) {
      return const Text(
        'No images captured.',
        style: TextStyle(fontSize: 16),
      );
    } else {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 images per row
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _imageFiles.length,
        itemBuilder: (context, index) {
          return Image.file(
            _imageFiles[index],
            fit: BoxFit.cover,
          );
        },
      );
    }
  }
}
