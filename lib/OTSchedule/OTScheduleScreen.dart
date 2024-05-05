import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:my_flutter_app/OTSchedule/OTScheduleListScreen.dart';

class OTScheduleScreen extends StatefulWidget {
  @override
  _OTScheduleScreenState createState() => _OTScheduleScreenState();
}

class _OTScheduleScreenState extends State<OTScheduleScreen> {
  File? _file;
  Uint8List? _webFile;
  String _notificationMessage = '';
  //String baseUrl = 'https://1ca6-2409-4050-dc0-ea19-f16a-52c8-7658-58de.ngrok-free.app/api';
  //String baseUrl = 'https://5e8d-2409-40d0-101f-8161-8434-4af8-305c-2efb.ngrok-free.app/api';
  String baseUrl = 'http://127.0.0.1:8000/api';
  //String baseUrl = 'https://9c79-2409-40d0-b5-dafe-c4cf-904e-59b2-3fd4.ngrok-free.app/api';
  Map<String, dynamic> scheduledOTList = {};
  Map<String, dynamic> doctorList = {};
  // double duration = 0.0 ;
  // int patient_id = 0;
  // String doctor_id = '';
  // String user_id = '';
  // String ot_id ='';
  // String procedure_id ='';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'OT Schedule',
          style: TextStyle(fontSize: 24),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), // Set the height of the divider
          child: Divider(color: Colors.grey), // Divider below the app bar title
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _pickFile();
                },
                child: Column(
                  children: [
                    Icon(Icons.upload_file, size: 100),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _pickFile();
                      },
                      child: Text('Upload'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _file != null || _webFile != null
                  ? ElevatedButton(
                onPressed: () {
                  _handleOTScheduleButtonPress();
                },
                child: Text('OT Schedule'),
              )
                  : Container(),
              SizedBox(height: 20),
              Text(_notificationMessage),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        if (kIsWeb) {
          Uint8List fileBytes = result.files.single.bytes!;
          _webFile = fileBytes;
          setState(() {
            _notificationMessage = 'File Uploaded: ${result.files.single.name}';
          });
        } else {
          _file = File(result.files.single.path!);
          setState(() {
            _notificationMessage = 'File Uploaded: ${_file!.path}';
          });
        }
      } else {
        setState(() {
          _notificationMessage = 'No file selected';
        });
      }
    } catch (e) {
      print('Error picking file: $e');
      setState(() {
        _notificationMessage = 'Error picking file: $e';
      });
    }
  }

  void _handleOTScheduleButtonPress() async {

    setState(() {
      _notificationMessage = ' '; // Show processing message
    });

    try {
      List<int> fileBytes = _file != null ? await _file!.readAsBytes() : _webFile!;
      String base64File = base64Encode(fileBytes);
      //print(base64File);

      String apiUrl = 'https://us-central1-amrita-body-scan.cloudfunctions.net/OT_Scheduler';
      Map<String, dynamic> requestBody = {'doc': base64File};
      String requestBodyJson = jsonEncode(requestBody);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Processing...'),
              ],
            ),
          );
        },
      );

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: requestBodyJson,
      );

      Navigator.pop(context);
      //print('Response body: ${response.body}'); // Add this line

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTScheduleListScreen(scheduleData: jsonResponse),
          ),
        );

        // print('OT - ${jsonResponse['OT']}');
        // print('Department - ${jsonResponse['Department']}');
        // print('Doctor-${jsonResponse['Surgeon']}');
        print('jsonResponse-${jsonResponse}');
        print('age-${jsonResponse['Age/Sex'][0].toString().split('/')[0]}');


        // Extract the value of the "OT" key
        Map<String, dynamic> otData = jsonResponse['OT'];
        Map<String, dynamic> department = jsonResponse['Department'];
        Map<String, dynamic> doctor = jsonResponse['Surgeon'];
        Map<String, dynamic> patient = jsonResponse['Name of the Patient'];
        Map<String, dynamic> age = jsonResponse['Age/Sex'];

        Map<String, dynamic> procedure = jsonResponse['surgery'];
        Map<String, dynamic> start_time = jsonResponse['Start_time'];
        Map<String, dynamic> end_time = jsonResponse['End_time'];
        Map<String, dynamic> date = jsonResponse['Date of Surgery'];
        Map<String, dynamic> mrdNumbers = jsonResponse['MRD'];

        print(date);

        for(var key in otData.keys) {
          // scheduledOTList[otData[key].toString()] = department[key];
          sendScheduledOT(otData[key].toString(), department[key]);
          //print('${otData[key]} : ${depart[key]} | ');
        }
        print(scheduledOTList);


        //API for Doctor
        for(var key in doctor.keys){
          await Future.delayed(Duration(milliseconds: 500));
          sendDoctorList(doctor[key].toString(), department[key]);
        }

        //API call for procedure_list
        for(var key in procedure.keys){
          await Future.delayed(Duration(milliseconds: 600));

          var duration = calculateDuration(end_time[key],start_time[key]);
          //print('duration - $duration');
          // duration = parseTime(end_time[key]).
          sendProcedureList(procedure[key].toString(), department[key].toString(), duration);
        }

        //API for patient
        for(var key in patient.keys){
          //print('age-${jsonResponse['Age/Sex'][key].toString().split('/')[0].split('Y')[0]}');
          // Introduce a delay of 1000 milliseconds (1 second)
          await Future.delayed(Duration(milliseconds: 500));
          sendPatientList(patient[key].toString(), age[key].split('/')[0], age[key].split('/')[1]);
        }

        //print(patient_id);
        //API for scheduled surgeries
        //DateFormat format = DateFormat('MM/dd/yy');
        //DateFormat inputFormat = DateFormat('dd/MM/yyyy');

        for(var key in procedure.keys){
          //print('age-${jsonResponse['Age/Sex'][key].toString().split('/')[0].split('Y')[0]}');
          // Introduce a delay of 1000 milliseconds (1 second)
          // print('date: ${inputFormat.parse((date[key]))}');
          // print('Data type of date[key]: ${inputFormat.parse(date[key])}');
          await Future.delayed(Duration(milliseconds: 500));
          sendScheduleSurgery(procedure[key], department[key], doctor[key], patient[key],
              date[key], start_time[key], end_time[key], otData[key] );

        }

      } else {
        setState(() {
          _notificationMessage = 'Error: ${response.statusCode}'; // Update notification message with error
        });
        // print('Error-1: ${response.statusCode}');
        // print('Response body-1: ${response.body}');
      }

    } catch (e) {
      setState(() {
        _notificationMessage = 'Error: $e'; // Update notification message with error
      });
      print('Error-2: $e');
    }
  }

  void sendScheduledOT(String otNumber, String department) async{

    String databaseApiUrl = '$baseUrl/OT/';

    // Make HTTP POST request to the backend API
    var response = await http.post(
      Uri.parse(databaseApiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ot_number': otNumber, 'department': department}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Data sent to the backend successfully.');
      // Optionally, handle the response from the backend if needed
    } else {
      print('Error sending data to the backend: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  void sendDoctorList(String doctor_name, String department) async {
    String apiUrl = '$baseUrl/doctors/';

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'doctor_name': doctor_name, 'department': department}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Data sent to the backend successfully.');
      // Optionally, handle the response from the backend if needed
    } else {
      print('Error sending data to the backend: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

  }

  void sendPatientList(String name, String age, String gender) async{

    String apiUrl = '$baseUrl/patient/';

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'patient_name': name, 'age': int.parse(age.split('Y')[0]), 'gender':gender}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Data sent to the backend successfully.');
      // Parse the response body
      //Map<String, dynamic> responseBody = jsonDecode(response.body);

      // Retrieve the patient_id from the response body
      //var id = responseBody['patient_id'];
      //patient_id.add(id);
      // Optionally, handle the response from the backend if needed
    } else {
      print('Error sending data to the backend: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

  }

  void sendProcedureList(String procedure_name, String department, double duration) async {

    String apiUrl = '$baseUrl/procedure/';

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'procedure_name': procedure_name, 'department': department , 'estimated_duration':duration}),
    );

    print('sendProcedureList:' +response.body);


    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Data sent to the backend successfully.');
      // Parse the response body
      //Map<String, dynamic> responseBody = jsonDecode(response.body);

      // Retrieve the patient_id from the response body
      // procedure_id = responseBody['procedure_id'];
      // Optionally, handle the response from the backend if needed
    } else {
      print('Error sending data to the backend: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  double calculateDuration(dynamic end_time, dynamic start_time) {
    // Parse start time and end time strings into hours and minutes
    List<String> startTimeParts = start_time.split(':');
    List<String> endTimeParts = end_time.split(':');

    int startHours = int.parse(startTimeParts[0]);
    int startMinutes = int.parse(startTimeParts[1]);

    int endHours = int.parse(endTimeParts[0]);
    int endMinutes = int.parse(endTimeParts[1]);

    // Calculate the time difference in minutes
    int startTimeInMinutes = startHours * 60 + startMinutes;
    int endTimeInMinutes = endHours * 60 + endMinutes;

    int differenceInMinutes = endTimeInMinutes - startTimeInMinutes;

    // Calculate the time difference in hours
    double differenceInHours = differenceInMinutes / 60.0;

    //print('Difference between $end_time and $start_time is ${differenceInHours.toStringAsFixed(2)} hours.');
    return differenceInHours;
  }

  void sendScheduleSurgery(procedure, department, doctor, patient, date,
      start_time, end_time, otData) async {

    String apiUrl = '$baseUrl/schedule/';
    print(date);

    // String pattern = 'MM/dd/yyyy';
    // DateFormat formatter = DateFormat(pattern);
    // DateTime parsedDate = (12/4/2024) as DateTime ;
    //
    // try {
    //   // Parse the string into a DateTime object using the DateFormat object
    //   parsedDate = formatter.parse(date);
    //
    //   // Print the parsed date
    //   print('Parsed Date: $parsedDate');
    // } catch (e) {
    //   // Handle parsing errors
    //   print('Error parsing date: $e');
    // }

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'procedure_name': procedure, 'department': department , 'patient_name':patient,
        'doctor_name':doctor, 'surgery_start_time':start_time, 'surgery_end_time':end_time,
        'surgery_date': date, 'ot_number' :otData}),
    );

    print('sendScheduleSurgery:' +response.body);


    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Data sent to the backend successfully.');
      // Parse the response body
      //Map<String, dynamic> responseBody = jsonDecode(response.body);

      // Retrieve the patient_id from the response body
      // procedure_id = responseBody['procedure_id'];
      // Optionally, handle the response from the backend if needed
    } else {
      print('Error sending data to the backend: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }



}

