import 'package:flutter/material.dart';
import 'package:sas_flutter/screens/add_form_page.dart';

class OpeningPage extends StatefulWidget {
  const OpeningPage({super.key});

  @override
  State<OpeningPage> createState() => _OpeningPageState();
}

class _OpeningPageState extends State<OpeningPage> {
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
        onPressed: navigateToAddFormPage,
        label: Text('Add Data'),
      ),
    );
  }

  void navigateToAddFormPage() {
    final route = MaterialPageRoute(
      //Routing
      builder: (context) => FormPage(),
    );
    Navigator.push(context, route);
  }
}
