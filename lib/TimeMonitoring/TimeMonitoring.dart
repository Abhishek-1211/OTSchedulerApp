import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/config/customThemes/elevatedButtonTheme.dart';

class TimeMonitoring extends StatefulWidget {
  final String otNumber;
  final String patientName;

  TimeMonitoring({required this.otNumber, required this.patientName}) ;

  @override
  _TimeMonitoringState createState() => _TimeMonitoringState();
}

class _TimeMonitoringState extends State<TimeMonitoring> {
  List<Map<String, dynamic>> surgicalSteps = [
    {'step': 'Pre-OP', 'time': '07:00AM'},
    {'step': 'Prophylaxis', 'time': '07:15AM'},
    {'step': 'Wheel-In', 'time': '07:30AM'},
    {'step': 'Induction', 'time': '09:00AM'},
    {'step': 'Painting & Draping', 'time': '01:00PM'},
    {'step': 'Incision', 'time': '01:15PM'},
    {'step': 'Extubation', 'time': '01:30PM'},
    {'step': 'Wheeled Out to Post-Op', 'time': '01:30PM'},
    {'step': 'Wheeled Out From Post-Op', 'time': '01:30PM'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        title: const Text('OT tracker',style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),),
        //centerTitle: true,
        actions: [
          TextButton(onPressed: () {}, child: Text("Dashboard", style: TextStyle(fontSize: 16, color: Colors.black))),
          TextButton(onPressed: () {}, child: Text("Patient List", style: TextStyle(fontSize: 16, color: Colors.black))),
          TextButton(onPressed: () {}, child: Text("Surgery List", style: TextStyle(fontSize: 16, color: Colors.black))),
          TextButton(onPressed: () {}, child: Text("Settings", style: TextStyle(fontSize: 16, color: Colors.black))),
          IconButton(icon: Icon(Icons.settings), onPressed: () {}),
        ],
        bottom:  PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          // Set the height of the divider
          child: Divider(
              color: Colors.blue.shade50), // Divider below the app bar title
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(150, 10, 20, 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Operational Theatre #${widget.otNumber}', style: TextStyle (fontSize: 25, fontWeight: FontWeight.bold),),
            Text('Patient: ${widget.patientName}', style: Theme.of(context).textTheme.subtitle1),
            Divider(color: Colors.blueGrey[50], thickness: 2, endIndent: 1000),
            SizedBox(height: 15),
            //Text('Surgical Steps', style: Theme.of(context).textTheme.headline6),
            ...surgicalSteps.map((step) => Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        //flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(step['step'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            Text(step['time'], style: TextStyle(fontSize: 14, color: Colors.grey)),
                          ],
                        ),
                      ),
                      SizedBox(width: 300,),
                      Container(
                        //flex: 1,
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: MyElevatedButtonTheme.elevatedButtonTheme2.style,
                              child: Text('Start Timer',style: TextStyle(color: Colors.white),),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        //flex: 1,
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: MyElevatedButtonTheme.elevatedButtonTheme2.style,
                              child: Text('End Timer',style: TextStyle(color: Colors.white),),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.blueGrey[50], thickness: 2, endIndent: 300),
                ],
              ),
            )).toList(),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Save & Exit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
