import 'package:flutter/material.dart';
import 'package:sas_flutter/screens/edit_form_page.dart';

class DisplayPage extends StatefulWidget {
  const DisplayPage({super.key});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Smart Ambulance System',
            style: TextStyle(
              fontWeight: FontWeight.bold, // Makes the text bold
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 120, 190, 247),
      ),
      body: const Center(
        child: Text('Please add your information'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToEditFormPage,
        label: Text('Edit'),
      ),
    );
  }

  void navigateToEditFormPage() {
    final route = MaterialPageRoute(
      //Routing
      builder: (context) => EditFormPage(),
    );
    Navigator.push(context, route);
  }
}
