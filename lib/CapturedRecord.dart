import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CapturedRecord extends StatefulWidget {
  // int mrd;
  String patientName;
  // String dob;
  // String otType;
  // String surgeryName;
  // String doctorName;
  // String deptName;

  // CapturedRecord({required this.mrd, required this.patientName, required this.doctorName, required this.surgeryName, required this.otType, required this.deptName});
  CapturedRecord({required this.patientName});

  @override
  State<CapturedRecord> createState() => _CapturedRecordState();
}

class _CapturedRecordState extends State<CapturedRecord> {
  String preOPStartTime = '';
  String prophylaxisStartTime = '';
  String wheelInStartTime = '';
  String inductionStartTime = '';
  String paintAndDrapStartTime = '';
  String IncisionStartTime = '';
  String preOPEndTime = '';
  String prophylaxisEndTime = '';
  String wheelInEndTime = '';
  String inductionEndTime = '';
  String paintAndDrapEndTime = '';
  String IncisionEndTime = '';


  String getCurrentTime() {
    // Get current time using DateTime class
    DateTime now = DateTime.now();
    // Format the time as desired
    String formattedTime = "${now.hour}:${now.minute}:${now.second}";
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Record Monitoring')),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Text('MRD - ${widget.patientName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Name - ${widget.patientName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              // Text('Doctor Name - ${widget.patientName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              // Text('Surgery - ${widget.patientName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              // Text('OT Type - ${widget.patientName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              // Text('Department - ${widget.patientName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              SizedBox(height: 20),
              Divider(thickness: 0.5, color: Colors.black87),
              SizedBox(height: 20),

              /** Action Items */
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey, width: 2)),
                          child: Column(
                        children: [
                          Text('Pre-OP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    preOPStartTime = getCurrentTime();
                                    print('Time - ${getCurrentTime()}');
                                  },
                                  child: Text('Start',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 15))),
                              SizedBox(width: 30),
                              ElevatedButton(
                                  onPressed: () {
                                    preOPEndTime = getCurrentTime();
                                    print('Time - ${getCurrentTime()}');
                                  },
                                  child: Text('End',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 15)))
                            ],
                          ),
                        ],
                      )),
                      SizedBox(height: 20),
                
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey, width: 2)),
                          child: Column(
                            children: [
                              Text('Prophylaxis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        prophylaxisStartTime = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                      },
                                      child: Text('Start',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 15))),
                                  SizedBox(width: 30),
                                  ElevatedButton(
                                      onPressed: () {
                                        prophylaxisEndTime = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                      },
                                      child: Text('End',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 15)))
                                ],
                              ),
                            ],
                          )),
                      SizedBox(height: 20),
                
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey, width: 2)),
                          child: Column(
                            children: [
                              Text('Wheel-In', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        wheelInStartTime = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                      },
                                      child: Text('Start',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 15))),
                                  SizedBox(width: 30),
                                  ElevatedButton(
                                      onPressed: () {
                                        wheelInStartTime = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                      },
                                      child: Text('End',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 15)))
                                ],
                              ),
                            ],
                          )),
                      SizedBox(height: 20),
                
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey, width: 2)),
                          child: Column(
                            children: [
                              Text('Induction', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        inductionStartTime = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                      },
                                      child: Text('Start',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 15))),
                                  SizedBox(width: 30),
                                  ElevatedButton(
                                      onPressed: () {
                                        inductionEndTime = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                      },
                                      child: Text('End',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 15)))
                                ],
                              ),
                            ],
                          )),
                      SizedBox(height: 20),
                
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey, width: 2)),
                          child: Column(
                            children: [
                              Text('Painting & Draping', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        paintAndDrapStartTime = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                      },
                                      child: Text('Start',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 15))),
                                  SizedBox(width: 30),
                                  ElevatedButton(
                                      onPressed: () {
                                        paintAndDrapEndTime = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                      },
                                      child: Text('End',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 15)))
                                ],
                              ),
                            ],
                          )),
                      SizedBox(height: 20),
                
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey, width: 2)),
                          child: Column(
                            children: [
                              Text('Incision', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        IncisionStartTime = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                      },
                                      child: Text('Start',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 15))),
                                  SizedBox(width: 30),
                                  ElevatedButton(
                                      onPressed: () {
                                        IncisionEndTime = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                      },
                                      child: Text('End',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 15)))
                                ],
                              ),
                            ],
                          )),
                      SizedBox(height: 20),
                
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
