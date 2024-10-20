import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sas_flutter/screens/display_page.dart';
import 'package:sas_flutter/screens/temp_disp.dart';
import 'dart:convert';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<FormPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phnoController = TextEditingController();
  TextEditingController emgnameController = TextEditingController();
  TextEditingController emgphnoController = TextEditingController();
  TextEditingController emgrelationController = TextEditingController();
  TextEditingController bloodgroupController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Add Your Information',
            style: TextStyle(
              fontWeight: FontWeight.bold, // Makes the text bold
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(
            255, 120, 190, 247), // Sets the AppBar color to blue
      ),
      body: ListView(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: '   Name'),
          ),
          SizedBox(height: 10), //Spacing between input boxes

          TextField(
            controller: ageController,
            decoration: InputDecoration(hintText: '   Age'),
          ),
          SizedBox(height: 10),

          TextField(
            controller: phnoController,
            decoration: InputDecoration(hintText: '   Phone Number'),
          ),
          SizedBox(height: 10),

          TextField(
            controller: addressController,
            decoration: InputDecoration(hintText: '  Address'),
            keyboardType: TextInputType.multiline,
            minLines: 2,
            maxLines: 8,
          ),
          SizedBox(height: 10),

          TextField(
            controller: emgnameController,
            decoration: InputDecoration(hintText: '   Emergency Contact Name'),
          ),
          SizedBox(height: 10),

          TextField(
            controller: emgrelationController,
            decoration:
                InputDecoration(hintText: '   Emergency Contact Relation'),
          ),
          SizedBox(height: 10),

          TextField(
            controller: emgphnoController,
            decoration: InputDecoration(hintText: '   Emergency phone number'),
          ),
          SizedBox(height: 10),

          TextField(
            controller: bloodgroupController,
            decoration: InputDecoration(hintText: '   Blood Group'),
          ),
          SizedBox(height: 10),

          ElevatedButton(
            onPressed: sumbitData,
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> sumbitData() async {
    //Get data from form
    //UNDO the comments incase we decide to use localhost server
    final id = 1;
    final name = nameController.text;
    final age = ageController.text;
    final phno = phnoController.text;
    final add = addressController.text;
    final ecn = emgnameController.text;
    final ecr = emgrelationController.text;
    final ecno = emgphnoController.text;
    final bg = bloodgroupController.text;
    final body = {
      "id": id,
      "name": name,
      "age": age,
      "phone-number": phno,
      "address": add,
      "emg-contact-name": ecn,
      "emg-contact-relation": ecr,
      "emg-contact-phno": ecno,
      "blood-grp": bg,
    };
    final formData = {
      'name': nameController.text,
      'age': ageController.text,
      'phone-number': phnoController.text,
      'address': addressController.text,
      'emg-contact-name': emgnameController.text,
      'emg-contact-relation': emgrelationController.text,
      'emg-contact-phno': emgphnoController.text,
      'blood-grp': bloodgroupController.text,
    };

    //Submit data to the server after deleting the current data
    deleteList();
    final url = 'http://192.168.197.39:3000/items';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    //Show Success or failure
    if (response.statusCode == 201) {
      print('Successfully created');
      showSuccessMessage('Successfully created');

      //Go back to home page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DisplayPage(data: formData)),
        (Route<dynamic> route) => false,
      );
    } else {
      showErrorMessage('Error-Creation Failed');
      print('Error-Creation Failed');
      print(response.body);
    }

    //Uncomment incase we dont use localhost
    /*Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplayPage(data: formData),
      ),
    );*/
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message,
          style: const TextStyle(
            fontWeight: FontWeight.bold, // Makes the text bold
            color: Colors.white,
          )),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message,
          style: const TextStyle(
            fontWeight: FontWeight.bold, // Makes the text bold
            color: Colors.white,
          )),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //To delete the list before we add this customer's details
  Future<void> deleteList() async {
    final durl = 'http://192.168.197.39:3000/alldelete';
    final duri = Uri.parse(durl);
    final response = await http.delete(duri);
    print(response.statusCode);
  }
}
