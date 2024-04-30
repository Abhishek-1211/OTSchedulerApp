import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CapturedRecord extends StatefulWidget {
  // int mrd;
  String patientName;
  int surgeryId;
  String otNumber;
  // String dob;
  // String otType;
  // String surgeryName;
  // String doctorName;
  // String deptName;

  // CapturedRecord({required this.mrd, required this.patientName, required this.doctorName, required this.surgeryName, required this.otType, required this.deptName});
  CapturedRecord({required this.patientName, required this.surgeryId, required this.otNumber});

  @override
  State<CapturedRecord> createState() => _CapturedRecordState();
}

class _CapturedRecordState extends State<CapturedRecord> {
  String preOPStartTime = '';
  String prophylaxisStartTime = '';
  String wheelInOT= '';
  String inductionStartTime = '';
  String paintAndDrapStartTime = '';
  String incisionStartTime = '';
  String preOPEndTime = '';
  String prophylaxisEndTime = '';
  String wheelInEndTime = '';
  String inductionEndTime = '';
  String paintAndDrapEndTime = '';
  String incisionEndTime = '';
  String extubationStartTime ='';
  String wheeledOutToTime ='';
  String wheeledOutFromTime = '';


  //button disable once pressed
  bool preOPStartDisabled = false;


  String baseUrl = 'http://127.0.0.1:8000/api';
  //String baseUrl = 'https://9c79-2409-40d0-b5-dafe-c4cf-904e-59b2-3fd4.ngrok-free.app/api';

  String getCurrentTime() {
    // Get current time using DateTime class
    DateTime now = DateTime.now();
    // Format the time as desired
    String formattedTime = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
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
              Text('Surgery ID - ${widget.surgeryId}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('OT Number - ${widget.otNumber}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                                      onPressed: preOPStartDisabled
                                          ? null
                                          : () {
                                        preOPStartTime = getCurrentTime();
                                        setState(() {
                                          preOPStartDisabled = true;
                                        });
                                      },
                                      child: Text('Start',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 15))),
                                  SizedBox(width: 30),
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
                                        wheelInOT = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                      },
                                      child: Text('Start',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 15))),
                                  SizedBox(width: 30),

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
                                        incisionStartTime = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                      },
                                      child: Text('Start',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 15))),
                                  SizedBox(width: 30),
                                  ElevatedButton(
                                      onPressed: () {
                                        incisionEndTime = getCurrentTime();
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
                              Text('Extubation Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        extubationStartTime = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                      },
                                      child: Text('Start',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 15))),
                                  SizedBox(width: 30),
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
                              Text('Wheeled Out to Post-Op', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        wheeledOutToTime = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                      },
                                      child: Text('Start',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 15))),
                                  SizedBox(width: 30),
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
                              Text('Wheeled Out From Post-Op', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        wheeledOutFromTime = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                      },
                                      child: Text('Start',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 15))),
                                  SizedBox(width: 30),
                                ],
                              ),
                            ],
                          )),
                      SizedBox(height: 20),

                      // Submit Button
                      ElevatedButton(
                        onPressed: () {
                          _submitForm(); // Call method to send POST request
                        },
                        child: Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void _submitForm() async {

    // Prepare your data for the POST request
    Map<String, dynamic> postData = {
      'scheduled_surgery_id': widget.surgeryId,
      'ot_number': widget.otNumber,
      'patient_received_in_pre_op_time': preOPStartTime,
      'antibiotic_prophylaxis_time': prophylaxisStartTime,
      'patient_wheel_in_OT': wheelInOT,
      'induction_start_time': inductionStartTime,
      'induction_end_time': inductionEndTime,
      'painting_and_draping_start_time': paintAndDrapStartTime,
      'painting_and_draping_end_time': paintAndDrapEndTime,
      'incision_in_time': incisionStartTime,
      'incision_close_time': incisionEndTime,
      'extubation_time_in_OT': extubationStartTime,
      'wheeled_out_time_to_Post_op_ICU': wheeledOutToTime,
      'wheeled_out_from_Post_OP': wheeledOutFromTime,
      'surgery_date': '08/22/2023'
    };

    // Send POST request using http package
    try {
      Uri url = Uri.parse('$baseUrl/monitor/');
      final headers = {'Content-Type': 'application/json'};
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(postData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle successful response
        print('POST request successful');
        // Optionally, navigate to another screen or show a success message
      } else {
        // Handle other status codes if needed
        print('POST request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions or errors
      print('Error sending POST request: $e');
    }
  }
}
