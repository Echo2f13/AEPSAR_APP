import 'package:flutter/material.dart';
import 'package:sas_flutter/screens/opening_page.dart';
import 'package:sas_flutter/screens/display_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final lastPage = prefs.getString('lastPage'); // Retrieve the last opened page

  runApp(MyApp(lastPage: lastPage));
}

class MyApp extends StatelessWidget {
  final String? lastPage;

  const MyApp({super.key, this.lastPage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: _getInitialPage(),
    );
  }

  // Determine which page to show based on the saved state
  Widget _getInitialPage() {
    if (lastPage == 'DisplayPage') {
      // Restore the saved data from SharedPreferences for DisplayPage
      return FutureBuilder<Map<String, String>>(
        future: _restorePageState(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            // If saved data is available, navigate to DisplayPage with the data
            return DisplayPage(data: snapshot.data!);
          } else {
            return OpeningPage(); // Default to OpeningPage if no data is found
          }
        },
      );
    } else {
      // Default to the OpeningPage if no saved page was found
      return OpeningPage();
    }
  }

  // Retrieve the data from SharedPreferences for the DisplayPage
  Future<Map<String, String>> _restorePageState() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name') ?? 'N/A',
      'age': prefs.getString('age') ?? 'N/A',
      'phone-number': prefs.getString('phone-number') ?? 'N/A',
      'emg-contact-name': prefs.getString('emg-contact-name') ?? 'N/A',
      'emg-contact-relation': prefs.getString('emg-contact-relation') ?? 'N/A',
      'emg-contact-phno': prefs.getString('emg-contact-phno') ?? 'N/A',
      'blood-grp': prefs.getString('blood-grp') ?? 'N/A',
    };
  }
}
