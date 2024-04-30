import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
//import 'package:my_flutter_app/OTScheduleScreen.dart';
//import 'package:my_flutter_app/TimeMonitoringScreen.dart';
import 'package:my_flutter_app/OTDashboard.dart';

class Dashboard extends StatefulWidget {

  int otCount;
  Dashboard({required this.otCount});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late TextEditingController fromDateController;
  late TextEditingController toDateController;
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  String baseUrl = 'http://127.0.0.1:8000/api';
  //int otCount = 100;

  @override
  void initState() {
    fromDateController = TextEditingController(text: '');
    toDateController = TextEditingController(text: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.only(top: 16), // Add margin only to the top of the text
          child: Text('DASHBOARD'),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), // Set the height of the divider
          child: Divider(color: Colors.grey), // Divider below the app bar title
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /** From Date*/
                      Container(
                        width: 250,
                        child: TextField(
                          controller: fromDateController,
                          canRequestFocus: false,
                          decoration: InputDecoration(labelText: 'From Date', isDense: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            prefixIcon: Icon(Icons.calendar_month_rounded, size: 20),),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // Circular shape
                          color: Colors.indigoAccent, // Lavender background color
                        ),
                        child: IconButton(
                          onPressed: () => _selectFromDate(context),
                          icon: Icon(Icons.calendar_month_outlined),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 100),
                      /** To Date */
                      Container(
                        width: 250,
                        child: TextField(
                          controller: toDateController,
                          canRequestFocus: false,
                          decoration: InputDecoration(labelText: 'To Date', isDense: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            prefixIcon: Icon(Icons.calendar_month_rounded, size: 20),),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // Circular shape
                          color: Colors.indigoAccent, // Lavender background color
                        ),
                        child: IconButton(
                          onPressed: () => _selectToDate(context),
                          icon: Icon(Icons.calendar_month_outlined),
                          color: Colors.white,
                        ),
                      )
                    ],
                  )
              ),
            ],
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleButton(
                title: "${widget.otCount}",
                label: 'OT',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OTDashboard()));
                },
              ),
              CircleButton(
                title: '0',
                label: 'Doctors',
                onTap: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => TimeMonitoringScreen()));
                },
              ),
              CircleButton(
                title: '0',
                label: 'Departments',
                onTap: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
                },
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleButton(
                title: '0',
                label: 'Procedures',
                onTap: () {
                  // Implement onTap for Option 4
                },
              ),
              CircleButton(
                title: '0',
                label: 'OT Staff',
                onTap: () {
                  // Implement onTap for Option 5
                },
              ),
              CircleButton(
                title: '0',
                label: 'Patients',
                onTap: () {
                  // Implement onTap for Option 6
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectFromDate2(BuildContext context) async{
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedFromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedFromDate) {
      setState(() {
        selectedFromDate = pickedDate;
      });
    }

  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedFromDate,
      firstDate: DateTime(1947), // Adjust the first and last date according to your needs1
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedFromDate) {
      setState(() {
        selectedFromDate = picked;
        String date = "${selectedFromDate.toLocal()}".split(' ')[0];
        fromDateController?.text = date;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedToDate,
      firstDate: DateTime(1947), // Adjust the first and last date according to your needs1
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedToDate) {
      setState(() {
        selectedToDate = picked;
        String date = "${selectedToDate.toLocal()}".split(' ')[0];
        toDateController?.text = date;
      });
    }

    //_setValues(context);
  }

  // void _setValues(BuildContext context) async{
  //
  //   String apiUrl = '$baseUrl/ot-count/';
  //
  //   final response = await http.get(
  //     Uri.parse(apiUrl),
  //     headers: {'Content-Type': 'application/json'},
  //   );
  //
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     print('Data Received from the backend successfully.');
  //     // Optionally, handle the response from the backend if needed
  //     print('Response body: ${response.body}');
  //     final List<dynamic> data = json.decode(response.body);
  //     print('Response body: ${data}');
  //
  //   } else {
  //     //print('Error sending data to the backend: ${response.statusCode}');
  //     print('Response body: ${response.body}');
  //   }
  // }

}

class CircleButton extends StatelessWidget {
  final String title;
  final String label;
  final VoidCallback onTap;

  const CircleButton({Key? key, required this.title, required this.label, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 175,
            height: 175,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.shade200,
            ),
            child: Center(
              child: Text(
                title, // This text will be dynamically populated
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 10), // Adjust the spacing between circle and label as needed
          Text(
            label, // This text will be dynamically populated
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}


