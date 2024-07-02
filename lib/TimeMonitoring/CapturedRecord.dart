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
  CapturedRecord(
      {required this.patientName,
      required this.surgeryId,
      required this.otNumber,
      required this.surgeryDate,
      required this.doctorName,
      required this.procedureName,
      required this.technician,
      required this.nurse,
      required this.specialEquipment});

  CapturedRecord.emergency(
      {required this.patientName,
      required this.otNumber,
      required this.surgeryDate,
      required this.doctorName,
      required this.procedureName,
      required this.surgeryId})
      : nurse = '',
        specialEquipment = '',
        technician = '';

  @override
  State<CapturedRecord> createState() => _CapturedRecordState();
}

class _CapturedRecordState extends State<CapturedRecord> {
  String preOPStartTime = '';
  String prophylaxisStartTime = '';
  String wheelInOT = '';
  String inductionStartTime = '';
  String paintAndDrapStartTime = '';
  String incisionStartTime = '';
  //String preOPEndTime = '';
  //String prophylaxisEndTime = '';
  //String wheelInEndTime = '';
  String inductionEndTime = '';
  String paintAndDrapEndTime = '';
  String incisionEndTime = '';
  String extubationStartTime = '';
  String wheeledOutToTime = '';
  String wheeledOutFromTime = '';

  //button disable once pressed
  bool preOPStartDisabled = false;
  bool prophylaxisStartEnabled = false;
  bool wheelInStartEnabled = false;
  bool inductionStartEnabled = false;
  bool inductionEndEnabled = false;
  bool paintAndDrapStartEnabled = false;
  bool paintAndDrapEndEnabled = false;
  bool incisionStartEnabled = false;
  bool incisionEndEnabled = false;
  bool extubationStartEnabled = false;
  bool wheeledOutToTimeEnabled = false;
  bool wheeledOutFromTimeEnabled = false;
  bool submitButtonEnabled = true;

  String baseUrl = 'http://127.0.0.1:8000/api';

  @override
  void initState() {
    _isSurgeryDone(widget.surgeryId);
  } //String baseUrl = 'https://9c79-2409-40d0-b5-dafe-c4cf-904e-59b2-3fd4.ngrok-free.app/api';

  String getCurrentTime() {
    // Get current time using DateTime class
    DateTime now = DateTime.now();
    // Format the time as desired
    String formattedTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    return formattedTime;
  }

  Color getBoxColor(int index) {
    return index % 2 == 0
        ? Colors.blue[100]!
        : Colors.white; // Alternate colors
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.yellowAccent,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Record Monitoring'),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(1.0),
                // Set the height of the divider
                child: Divider(
                    color: Colors.grey), // Divider below the app bar title
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Text('MRD - ${widget.patientName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Name - ${widget.patientName}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Surgery ID - ${widget.surgeryId}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('OT Number - ${widget.otNumber}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Surgeon - ${widget.doctorName}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey, width: 2),
                                  color: getBoxColor(0)),
                              child: Column(
                                children: [
                                  Text('Pre-OP',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  Text('Start Time:$preOPStartTime',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //SizedBox(width: 200),
                                      ElevatedButton(
                                          onPressed: preOPStartDisabled
                                              ? null
                                              : () {
                                                  preOPStartTime =
                                                      getCurrentTime();
                                                  setState(() {
                                                    preOPStartDisabled = true;
                                                    prophylaxisStartEnabled =
                                                        true;
                                                  });
                                                },
                                          child: const Text('Start',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15))),
                                      SizedBox(width: 30),
                                    ],
                                  ),
                                  //Text('$preOPStartTime', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.amber)),
                                ],
                              )),
                          SizedBox(height: 20),

                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey, width: 2)),
                              child: Column(
                                children: [
                                  Text('Prophylaxis',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  Text('Start Time:$prophylaxisStartTime',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //SizedBox(width:200),
                                      ElevatedButton(
                                          onPressed: prophylaxisStartEnabled
                                              ? () {
                                                  prophylaxisStartTime =
                                                      getCurrentTime();
                                                  setState(() {
                                                    prophylaxisStartEnabled =
                                                        false;
                                                    wheelInStartEnabled = true;
                                                  });
                                                  print(
                                                      'Time - ${getCurrentTime()}');
                                                }
                                              : null,
                                          child: Text('Start',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15))),
                                      SizedBox(width: 30),
                                    ],
                                  ),
                                ],
                              )),
                          SizedBox(height: 20),

                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey, width: 2),
                                  color: getBoxColor(0)),
                              child: Column(
                                children: [
                                  Text('Wheel-In',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  Text('Start Time:$wheelInOT',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //SizedBox(width: 150),
                                      ElevatedButton(
                                          onPressed: wheelInStartEnabled
                                              ? () {
                                                  wheelInOT = getCurrentTime();
                                                  print(
                                                      'Time - ${getCurrentTime()}');
                                                  setState(() {
                                                    wheelInStartEnabled = false;
                                                    inductionStartEnabled =
                                                        true;
                                                  });
                                                }
                                              : null,
                                          child: Text('Start',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15))),
                                      //SizedBox(width: 200),
                                    ],
                                  ),
                                ],
                              )),
                          SizedBox(height: 20),

                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey, width: 2)),
                              child: Column(
                                children: [
                                  Text('Induction',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Start Time: $inductionStartTime',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                      SizedBox(width: 200),
                                      ElevatedButton(
                                          onPressed: inductionStartEnabled
                                              ? () {
                                                  inductionStartTime =
                                                      getCurrentTime();
                                                  print(
                                                      'Time - ${getCurrentTime()}');
                                                  setState(() {
                                                    inductionStartEnabled =
                                                        false;
                                                    inductionEndEnabled = true;
                                                  });
                                                }
                                              : null,
                                          child: Text('Start',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15))),
                                      SizedBox(width: 30),
                                      ElevatedButton(
                                          onPressed: inductionEndEnabled
                                              ? () {
                                                  inductionEndTime =
                                                      getCurrentTime();
                                                  print(
                                                      'Time - ${getCurrentTime()}');
                                                  setState(() {
                                                    inductionEndEnabled = false;
                                                    paintAndDrapStartEnabled =
                                                        true;
                                                  });
                                                }
                                              : null,
                                          child: Text('End',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15))),
                                      SizedBox(width: 200),
                                      Text('End Time:$inductionEndTime',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16))
                                    ],
                                  ),
                                ],
                              )),
                          SizedBox(height: 20),

                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey, width: 2),
                                  color: getBoxColor(0)),
                              child: Column(
                                children: [
                                  Text('Painting & Draping',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Start Time: $paintAndDrapStartTime',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                      SizedBox(width: 200),
                                      ElevatedButton(
                                          onPressed: paintAndDrapStartEnabled
                                              ? () {
                                                  paintAndDrapStartTime =
                                                      getCurrentTime();
                                                  print(
                                                      'Time - ${getCurrentTime()}');
                                                  setState(() {
                                                    paintAndDrapStartEnabled =
                                                        false;
                                                    paintAndDrapEndEnabled =
                                                        true;
                                                  });
                                                }
                                              : null,
                                          child: Text('Start',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15))),
                                      SizedBox(width: 30),
                                      ElevatedButton(
                                          onPressed: paintAndDrapEndEnabled
                                              ? () {
                                                  paintAndDrapEndTime =
                                                      getCurrentTime();
                                                  print(
                                                      'Time - ${getCurrentTime()}');
                                                  setState(() {
                                                    paintAndDrapEndEnabled =
                                                        false;
                                                    incisionStartEnabled = true;
                                                  });
                                                }
                                              : null,
                                          child: Text('End',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15))),
                                      SizedBox(width: 200),
                                      Text('End Time: $paintAndDrapEndTime',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                    ],
                                  ),
                                ],
                              )),
                          SizedBox(height: 20),

                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey, width: 2)),
                              child: Column(
                                children: [
                                  Text('Incision',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Start Time: $incisionStartTime',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                      SizedBox(width: 200),
                                      ElevatedButton(
                                          onPressed: incisionStartEnabled
                                              ? () {
                                                  incisionStartTime =
                                                      getCurrentTime();
                                                  print(
                                                      'Time - ${getCurrentTime()}');
                                                  setState(() {
                                                    incisionStartEnabled =
                                                        false;
                                                    incisionEndEnabled = true;
                                                  });
                                                }
                                              : null,
                                          child: Text('Start',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15))),
                                      SizedBox(width: 30),
                                      ElevatedButton(
                                          onPressed: incisionEndEnabled
                                              ? () {
                                                  incisionEndTime =
                                                      getCurrentTime();
                                                  print(
                                                      'Time - ${getCurrentTime()}');
                                                  setState(() {
                                                    incisionEndEnabled = false;
                                                    extubationStartEnabled =
                                                        true;
                                                  });
                                                }
                                              : null,
                                          child: Text('End',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15))),
                                      SizedBox(width: 200),
                                      Text('End Time: $incisionEndTime',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                    ],
                                  ),
                                ],
                              )),
                          SizedBox(height: 20),

                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey, width: 2),
                                  color: getBoxColor(0)),
                              child: Column(
                                children: [
                                  Text('Extubation Time',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  Text('Start Time:$extubationStartTime',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                          onPressed: extubationStartEnabled
                                              ? () {
                                                  extubationStartTime =
                                                      getCurrentTime();
                                                  print(
                                                      'Time - ${getCurrentTime()}');
                                                  setState(() {
                                                    extubationStartEnabled =
                                                        false;
                                                    wheeledOutToTimeEnabled =
                                                        true;
                                                  });
                                                }
                                              : null,
                                          child: Text('Start',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15))),
                                      SizedBox(width: 30),
                                    ],
                                  ),
                                ],
                              )),
                          SizedBox(height: 20),

                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey, width: 2)),
                              child: Column(
                                children: [
                                  Text('Wheeled Out to Post-Op',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  Text('Start Time:$wheeledOutToTime',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                          onPressed: wheeledOutToTimeEnabled
                                              ? () {
                                                  wheeledOutToTime =
                                                      getCurrentTime();
                                                  print(
                                                      'Time - ${getCurrentTime()}');
                                                  setState(() {
                                                    wheeledOutToTimeEnabled =
                                                        false;
                                                    wheeledOutFromTimeEnabled =
                                                        true;
                                                  });
                                                }
                                              : null,
                                          child: Text('Start',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15))),
                                      SizedBox(width: 30),
                                    ],
                                  ),
                                ],
                              )),
                          SizedBox(height: 20),

                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey, width: 2),
                                  color: getBoxColor(0)),
                              child: Column(
                                children: [
                                  Text('Wheeled Out From Post-Op',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  Text('Start Time:$wheeledOutFromTime',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                          onPressed: wheeledOutFromTimeEnabled
                                              ? () {
                                                  wheeledOutFromTime =
                                                      getCurrentTime();
                                                  print(
                                                      'wheeledOutToTime $wheeledOutToTime');
                                                  print(
                                                      'Time - ${getCurrentTime()}');
                                                  setState(() {
                                                    wheeledOutFromTimeEnabled =
                                                        false;
                                                  });
                                                }
                                              : null,
                                          child: Text('Start',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15))),
                                      SizedBox(width: 30),
                                    ],
                                  ),
                                ],
                              )),
                          SizedBox(height: 20),

                          // Submit Button
                          Container(
                            height: 50,
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlueAccent,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2)))),
                              onPressed: submitButtonEnabled
                                  ? () {
                                      _submitForm(); // Call method to send POST request
                                    }
                                  : null,
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  void _submitForm() async {
    // Prepare your data for the POST request
    //String formattedDate = widget.surgeryDate.toIso8601String().split('T')[0];

    String formattedDate = DateFormat('MM/dd/yyyy').format(widget.surgeryDate);

    print(widget.doctorName);
    Map<String, dynamic> postData = {
      'scheduled_surgery_id': widget.surgeryId == 0
          ? null
          : widget.surgeryId == 1
              ? null
              : widget.surgeryId,
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
      'doctor_name': widget.doctorName,
      'procedure_name': widget.procedureName,
      'technician_tl': widget.technician,
      'nurse_tl': widget.nurse,
      'special_equipment': widget.specialEquipment,
      'surgery_type': widget.surgeryId == 0
          ? 'Emergency'
          : widget.surgeryId == 1
              ? 'Add-on'
              : 'Pre-planned'
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
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                    'Confirmation.\nYour inputs have been recorded successfully'),
                //content: const Text('Thank you!!!Your inputs have been recorded successfully'),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      print(widget.surgeryId);
                      Navigator.of(context).pop('${widget.surgeryId} is done');
                    },
                  ),
                ],
              );
            });
        // Optionally, navigate to another screen or show a success message
      } else {
        // Handle other status codes if needed
        print('POST request failed with status: ${response.statusCode}');
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                    'OOPS !!!.\nYour inputs have not been recorded.\nPlease check again'),
                //content: const Text('Thank you!!!Your inputs have been recorded successfully'),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Disable'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      }
    } catch (e) {
      // Handle any exceptions or errors
      print('Error sending POST request: $e');
    }
  }

  void _isSurgeryDone(int surgery_id) async {
    try {
      Uri url = Uri.parse('$baseUrl/monitor/');
      final headers = {'Content-Type': 'application/json'};
      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle successful response
        print('GET request successful');
        //print(response.body);
        print(jsonDecode(response.body).runtimeType);
        List<dynamic> completedSurgeryList = jsonDecode(response.body);
        List<dynamic> currentSurgery = completedSurgeryList
            .where((object) => object['scheduled_surgery_id'] == surgery_id)
            .toList();
        print(completedSurgeryList
            .where((object) => object['scheduled_surgery_id'] == surgery_id)
            .toList());
        //for(int i =0;i<completedSurgeryList.length;i++){
        //  completedSurgeryList.where((object) => object['scheduled_surgery_id']==surgery_id).toList());
        //}

        if (currentSurgery.isNotEmpty) {
          setState(() {
            preOPStartDisabled = true;
            submitButtonEnabled = false;
            print(currentSurgery[0]['patient_received_in_pre_op_time']);
            preOPStartTime =
                currentSurgery[0]['patient_received_in_pre_op_time'];
            prophylaxisStartTime =
                currentSurgery[0]['antibiotic_prophylaxis_time'];
            wheelInOT = currentSurgery[0]['patient_wheel_in_OT'];
            inductionStartTime = currentSurgery[0]['induction_start_time'];
            inductionEndTime = currentSurgery[0]['induction_end_time'];
            paintAndDrapStartTime =
                currentSurgery[0]['painting_and_draping_start_time'];
            paintAndDrapEndTime =
                currentSurgery[0]['painting_and_draping_end_time'];
            incisionStartTime = currentSurgery[0]['incision_in_time'];
            incisionEndTime = currentSurgery[0]['incision_close_time'];
            extubationStartTime = currentSurgery[0]['extubation_time_in_OT'];
            wheeledOutToTime =
                currentSurgery[0]['wheeled_out_time_to_Post_op_ICU'];
            wheeledOutFromTime = currentSurgery[0]['wheeled_out_from_Post_OP'];
          });
        }
      } else {
        // Handle other status codes if needed
        print('GET request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions or errors
      print('Error sending GET request: $e');
    }

    //return false;
  }
}
