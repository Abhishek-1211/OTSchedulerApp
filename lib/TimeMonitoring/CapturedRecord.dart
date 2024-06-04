import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CapturedRecord extends StatefulWidget {
  // int mrd;
  String patientName;
  String doctorName;
  String procedureName;
  int surgeryId;
  String otNumber;
  String technician;
  String nurse;
  String specialEquipment;
  DateTime surgeryDate;
  // String dob;
  // String otType;
  // String surgeryName;
  // String doctorName;
  // String deptName;

  // CapturedRecord({required this.mrd, required this.patientName, required this.doctorName, required this.surgeryName, required this.otType, required this.deptName});
  CapturedRecord({required this.patientName, required this.surgeryId, required this.otNumber, required this.surgeryDate,
    required this.doctorName, required this.procedureName, required this.technician, required this.nurse,
  required this.specialEquipment});

  CapturedRecord.emergency({required this.patientName, required this.otNumber, required this.surgeryDate,
    required this.doctorName, required this.procedureName, required this.surgeryId}) : nurse ='', specialEquipment='', technician='';

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
  bool prophylaxisStartDisabled = false;
  bool wheelInStartDisabled = false;
  bool inductionStartDisabled = false;
  bool inductionEndDisabled = false;
  bool paintAndDrapStartDisabled = false;
  bool paintAndDrapEndDisabled = false;
  bool incisionStartDisabled = false;
  bool incisionEndDisabled = false;
  bool extubationStartDisabled =false;
  bool wheeledOutToTimeDisabled = false;
  bool wheeledOutFromTimeDisabled = false;



  String baseUrl = 'http://127.0.0.1:8000/api';
  //String baseUrl = 'https://9c79-2409-40d0-b5-dafe-c4cf-904e-59b2-3fd4.ngrok-free.app/api';

  String getCurrentTime() {
    // Get current time using DateTime class
    DateTime now = DateTime.now();
    // Format the time as desired
    String formattedTime = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    return formattedTime;

  }

  Color getBoxColor(int index) {
    return index % 2 == 0 ? Colors.blue[100]! : Colors.white; // Alternate colors
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.yellowAccent,
    child: Scaffold(
        appBar: AppBar(title: Text('Record Monitoring'),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0), // Set the height of the divider
            child: Divider(color: Colors.grey), // Divider below the app bar title
          ),),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Text('MRD - ${widget.patientName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Name - ${widget.patientName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Surgery ID - ${widget.surgeryId}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('OT Number - ${widget.otNumber}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Surgeon - ${widget.doctorName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey, width: 2), color: getBoxColor(0)),
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
                              //Text('$preOPStartTime', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
                                      onPressed: prophylaxisStartDisabled
                                          ? null
                                          : () {
                                        prophylaxisStartTime = getCurrentTime();
                                        setState(() {
                                          prophylaxisStartDisabled = true;
                                        });
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
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey, width: 2), color: getBoxColor(0)),
                          child: Column(
                            children: [
                              Text('Wheel-In', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: wheelInStartDisabled
                                          ? null
                                          : () {
                                        wheelInOT = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                        setState(() {
                                          wheelInStartDisabled = true;
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
                              Text('Induction', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: inductionStartDisabled
                                          ? null
                                          : () {
                                        inductionStartTime = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                        setState(() {
                                          inductionStartDisabled =true;
                                        });
                                      },
                                      child: Text('Start',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 15))),
                                  SizedBox(width: 30),
                                  ElevatedButton(
                                      onPressed: inductionEndDisabled
                                          ? null
                                          :() {
                                        inductionEndTime = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                        setState(() {
                                          inductionEndDisabled = true;
                                        });
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
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey, width: 2),color: getBoxColor(0)),
                          child: Column(
                            children: [
                              Text('Painting & Draping', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: paintAndDrapStartDisabled
                                          ? null
                                          : () {
                                        paintAndDrapStartTime = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                        setState(() {
                                          paintAndDrapStartDisabled = true;
                                        });
                                      },
                                      child: Text('Start',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 15))),
                                  SizedBox(width: 30),
                                  ElevatedButton(
                                      onPressed: paintAndDrapEndDisabled
                                          ? null
                                          : () {
                                        paintAndDrapEndTime = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                        setState(() {
                                          paintAndDrapEndDisabled = true;
                                        });
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
                                      onPressed: incisionStartDisabled
                                          ? null
                                          : () {
                                        incisionStartTime = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                        setState(() {
                                          incisionStartDisabled =true;
                                        });
                                      },
                                      child: Text('Start',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 15))),
                                  SizedBox(width: 30),
                                  ElevatedButton(
                                      onPressed: incisionEndDisabled
                                          ? null
                                          : () {
                                        incisionEndTime = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                        setState(() {
                                          incisionEndDisabled = true;
                                        });
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
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey, width: 2),color: getBoxColor(0)),
                          child: Column(
                            children: [
                              Text('Extubation Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: extubationStartDisabled
                                          ? null
                                          : () {
                                        extubationStartTime = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                        setState(() {
                                          extubationStartDisabled = true;
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
                              Text('Wheeled Out to Post-Op', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: wheeledOutToTimeDisabled
                                          ? null
                                          : () {
                                        wheeledOutToTime = getCurrentTime();
                                        print('Time - ${getCurrentTime()}');
                                        setState(() {
                                          wheeledOutToTimeDisabled = true;
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
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey, width: 2),color: getBoxColor(0)),
                          child: Column(
                            children: [
                              Text('Wheeled Out From Post-Op', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: wheeledOutFromTimeDisabled
                                          ? null
                                          : () {
                                        wheeledOutFromTime = getCurrentTime();
                                        print('wheeledOutToTime $wheeledOutToTime');
                                        print('Time - ${getCurrentTime()}');
                                        setState(() {
                                          wheeledOutFromTimeDisabled = true;
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
        )
    ));
  }

  void _submitForm() async {

    // Prepare your data for the POST request
    //String formattedDate = widget.surgeryDate.toIso8601String().split('T')[0];

    String formattedDate = DateFormat('MM/dd/yyyy').format(widget.surgeryDate);

    print(widget.doctorName);
    Map<String, dynamic> postData = {
      'scheduled_surgery_id': widget.surgeryId==0 ? null : widget.surgeryId==1? null: widget.surgeryId,
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
      //'surgery_date': '08/22/2023'
      'surgery_date': formattedDate,
      'doctor_name' : widget.doctorName,
      'procedure_name' : widget.procedureName,
      'technician_tl': widget.technician,
      'nurse_tl': widget.nurse,
      'special_equipment': widget.specialEquipment,
      'surgery_type': widget.surgeryId == 0 ?'Emergency':
                      widget.surgeryId == 1 ? 'Add-on':'Pre-planned'
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
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmation.\nYour inputs have been recorded successfully'),
            //content: const Text('Thank you!!!Your inputs have been recorded successfully'),
            actions: <Widget>[TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),],
          );
        });
        // Optionally, navigate to another screen or show a success message
      } else {
        // Handle other status codes if needed
        print('POST request failed with status: ${response.statusCode}');
        // showDialog(context: context, builder: (BuildContext context) {
        //   return AlertDialog(
        //     title: const Text('OOPS !!!.\nYour inputs have not been recorded.\nPlease check again'),
        //     //content: const Text('Thank you!!!Your inputs have been recorded successfully'),
        //     actions: <Widget>[TextButton(
        //       style: TextButton.styleFrom(
        //         textStyle: Theme.of(context).textTheme.labelLarge,
        //       ),
        //       child: const Text('Disable'),
        //       onPressed: () {
        //         Navigator.of(context).pop();
        //       },
        //     ),],
        //   );
        // });

      }
    } catch (e) {
      // Handle any exceptions or errors
      print('Error sending POST request: $e');
    }
  }
}