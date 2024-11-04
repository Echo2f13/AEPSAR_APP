import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class EmergencyProtocolPageTemp extends StatefulWidget {
  final Map<String, String> data;
  final String location;

  const EmergencyProtocolPageTemp({
    super.key,
    required this.data,
    required this.location,
  });

  @override
  _EmergencyProtocolPageTempState createState() =>
      _EmergencyProtocolPageTempState();
}

class _EmergencyProtocolPageTempState extends State<EmergencyProtocolPageTemp> {
  List<File> _imageFiles = [];
  Timer? _timer;
  int _imageLimit = 4; // Total images to capture (2 front + 2 back)
  int _frontImageCount = 0; // Count for front camera images
  int _backImageCount = 0; // Count for back camera images
  int _captureIntervalSeconds = 3; // Time interval for captures
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  CameraLensDirection _currentCamera = CameraLensDirection.back; // Start with back camera
  bool _dataSent = false; // Flag to track if data has been sent

  @override
  void initState() {
    super.initState();
    _initializeCamera(); // Initialize the camera
  }

  // Initialize the camera
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.firstWhere(
          (camera) => camera.lensDirection == _currentCamera),
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _cameraController.initialize();
    _startTimedCapture(); // Start image capture
  }

  // Start the timer for capturing images at intervals
  void _startTimedCapture() {
    _timer = Timer.periodic(
      Duration(seconds: _captureIntervalSeconds),
      (timer) async {
        if (_imageFiles.length < _imageLimit) {
          await _captureImage();
        } else {
          _timer?.cancel();
          await _sendData(); // Send the data after reaching the image limit
        }
      },
    );
  }

  // Capture an image automatically
  Future<void> _captureImage() async {
    await _initializeControllerFuture;
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/${DateTime.now()}.png';

    try {
      // Capture the image and store it in the specified path
      XFile picture = await _cameraController.takePicture();
      await picture.saveTo(path);

      setState(() {
        _imageFiles.add(File(path));
        if (_currentCamera == CameraLensDirection.back) {
          _backImageCount++;
          if (_backImageCount == 2) {
            // Switch to front camera after capturing 2 back images
            _currentCamera = CameraLensDirection.front;
            _initializeCamera(); // Reinitialize camera for front
          }
        } else {
          _frontImageCount++;
        }
      });
    } catch (e) {
      /*ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to capture image.')),
      );*/
    }
  }

  // Send the captured data to the API
  Future<void> _sendData() async {
    if (_dataSent) {
      // Exit if data has already been sent
      return;
    }

    if (_imageFiles.length < _imageLimit) {
      // Check if the required number of images has been captured
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.41.39:3000/emergencyProtocol'),
    );

    request.fields['name'] = widget.data['name'] ?? 'Unknown';
    request.fields['phone-number'] = widget.data['phone-number'] ?? 'N/A';
    request.fields['emg-contact-phno'] =
        widget.data['emg-contact-phno'] ?? 'N/A';
    request.fields['blood-grp'] = widget.data['blood-grp'] ?? 'N/A';
    request.fields['location'] = widget.location;

    for (var imageFile in _imageFiles) {
      request.files.add(await http.MultipartFile.fromPath(
        'images',
        imageFile.path,
      ));
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        // Set the flag to true to indicate that data has been sent
        _dataSent = true;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data sent successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send data.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred.')),
      );
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _timer?.cancel();
    super.dispose();
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
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      'Sharing the following details with the nearest health center: ',
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
              const Text(
                'Captured Images:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              _buildImageGrid(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

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
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
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
