import 'dart:convert';
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:my_flutter_app/OTScheduleScreen.dart';
import 'package:my_flutter_app/Dashboard.dart';
//import 'package:my_flutter_app/TimeMonitoringScreen.dart';
import 'package:http/http.dart' as http;

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  String baseUrl = 'http://127.0.0.1:8000/api';
  int otCount = 5;
  //const MenuPage({Key? key}) : super(key: key);



  @override
  void initState() {
    super.initState();
    _setValues();
    // Initialization code here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Page'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), // Set the height of the divider
          child: Divider(color: Colors.grey), // Divider below the app bar title
        ),

      ),

      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CircleButton(
              title: 'OT Schedule',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OTScheduleScreen()));
              },
            ),
            SizedBox(height: 20),
            CircleButton(
              title: 'Time Monitor',
              onTap: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => TimeMonitoringScreen()));
              },
            ),
            SizedBox(height: 20),
            CircleButton(
              title: 'Dashboard',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(otCount : otCount)));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _setValues() async{

    String apiUrl = '$baseUrl/ot-count/';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Data Received from the backend successfully.');
      // Optionally, handle the response from the backend if needed
      print('Response body: ${response.body}');
      //Parse the JSON response
      // Parse the JSON response
      Map<String, dynamic> responseData = jsonDecode(response.body);

      // Extract the count value from the message
      String message = responseData['message'];
      otCount = int.parse(message.split(':').last.trim());

    } else {
      //print('Error sending data to the backend: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

}

class CircleButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CircleButton({Key? key, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue.shade200,
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
