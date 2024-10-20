import 'package:flutter/material.dart';

class DisplayPag extends StatelessWidget {
  final String name;
  final String age;
  final String phno;
  final String address;
  final String emgName;
  final String emgRelation;
  final String emgPhno;
  final String bloodGroup;

  const DisplayPag({
    Key? key,
    required this.name,
    required this.age,
    required this.phno,
    required this.address,
    required this.emgName,
    required this.emgRelation,
    required this.emgPhno,
    required this.bloodGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Information'),
        backgroundColor: const Color.fromARGB(255, 120, 190, 247),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Age: $age', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Phone Number: $phno', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Address: $address', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Emergency Contact Name: $emgName',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Emergency Contact Relation: $emgRelation',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Emergency Contact Phone Number: $emgPhno',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Blood Group: $bloodGroup', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to the form page
              },
              child: Text('Back to Form'),
            ),
          ],
        ),
      ),
    );
  }
}
