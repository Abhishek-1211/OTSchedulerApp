import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:my_flutter_app/OTSchedule/OTScheduleListScreen.dart';
import 'package:my_flutter_app/OTSchedule/SchedulerOutput.dart';
import 'package:my_flutter_app/config/customThemes/MyAppBar.dart';
import 'package:my_flutter_app/config/customThemes/elevatedButtonTheme.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedulerInput extends StatefulWidget {
  @override
  _SchedulerInputState createState() => _SchedulerInputState();
}

class _SchedulerInputState extends State<SchedulerInput> {

  DateTime selectedDate = DateTime.now();
  bool isDateSelected = true;
  static const double leftMargin = 180;
  static const double rightMargin = 180;
  static const double gap = 15;
  String displayText1 = 'Schedule all operation';
  String displayText2 = 'Select a date and upload a Excel file to schedule the procedure.';
  String displayText3 = "Please upload a Excel file. The file should contain all the necessary information for the operation,"
      " including patient, doctor, and equipment details.";
  String uploadFileText = 'Upload your file here';

  File? _file;
  Uint8List? _webFile;
  String _notificationMessage = '';
  String _uploadedDate ='';
  String baseUrl = 'http://127.0.0.1:8000/api';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: leftMargin, right: rightMargin, top: 10,bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(displayText1, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            //SizedBox(height: 1),
            Text(displayText2,
                style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            Divider(color: Colors.blueGrey[50], thickness: 2, endIndent: 500),
            SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  Container(
                      width: 520,
                      child: _buildCalendar()),
                  // SizedBox(height: gap),
                  // _buildUploadButton(),
                  SizedBox(height: gap),
                  _buildFileDropArea(),
                  SizedBox(height: gap),
                  Text(
                    displayText3,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: isDateSelected ?() {
                      _handleOTScheduleButtonPress();
                    } : () {
                      _viewPastHistory();
                    },
                    style: MyElevatedButtonTheme.elevatedButtonTheme1.style,
                    child: isDateSelected ?
                    Text('Schedule', style: TextStyle(color: Colors.white),):
                    Text('View Past Surgeries', style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {

    DateTime currentDay = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
    DateTime nextDay = DateTime(currentDay.year,currentDay.month,currentDay.day+7);

    return Column(
      children: [
        // Text(DateFormat.yMMMM().format(selectedDate), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        // SizedBox(height: 10),
        TableCalendar(
          focusedDay: selectedDate,
          firstDay: DateTime(2024),
          lastDay: DateTime(2025),
          selectedDayPredicate: (day) => isSameDay(day, selectedDate),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              selectedDate = selectedDay;
              print('onDaySelected:selectedDate :$selectedDate');
              print('onDaySelected:selectedDay :$selectedDay');
              if (selectedDay.isBefore(DateTime(currentDay.year, currentDay.month, currentDay.day))) {
                print('Selected date is before currentDay.');
                isDateSelected = false;
              } else {
                isDateSelected = true;
              }

            });
          },
          headerStyle: HeaderStyle(
            formatButtonVisible: false, // This hides the "2 weeks" button
            titleCentered: true,
            titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)// Keep the title centered
          ),

          enabledDayPredicate: (day) {
            // Enable only dates till tomorrow
            return day.isBefore(nextDay.add(Duration(days: 1)));
          },
        ),
      ],
    );
  }

  Widget _buildUploadButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            // Handle file upload
          },
          //Colors.grey[200],
          style: MyElevatedButtonTheme.elevatedButtonTheme2.style,
          child: Text('Upload', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  Widget _buildFileDropArea() {
    return DottedBorder(
      color: Colors.blueGrey[200]!,
      strokeWidth: 2,
      dashPattern: [6, 6],
      borderType: BorderType.RRect,
      radius: Radius.circular(10),
      child: Container(
        height: 120,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(uploadFileText, style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: isDateSelected ? () {
                // Handle file browsing
                _pickFile();
              }:
              null,
              //Colors.grey[200],
              style: MyElevatedButtonTheme.elevatedButtonTheme2.style,
              child: Text('Upload file', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  //
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        if (kIsWeb) {
          Uint8List fileBytes = result.files.single.bytes!;
          _webFile = fileBytes;
          setState(() {
            _notificationMessage = 'File Uploaded: ${result.files.single.name}';
            uploadFileText = _notificationMessage;
          });
          _extractDateFromFile();
        } else {
          _file = File(result.files.single.path!);
          setState(() {
            _notificationMessage = 'File Uploaded: ${_file!.path}';
            uploadFileText = _notificationMessage;
          });
        }
      } else {
        setState(() {
          _notificationMessage = 'No file selected';
          uploadFileText = _notificationMessage;
        });
      }
    } catch (e) {
      print('Error picking file: $e');
      setState(() {
        _notificationMessage = 'Error picking file: $e';

      });
    }
  }

  Future<void> _extractDateFromFile() async {

    DateTime parsedDate = DateTime.now();
    String formattedDate ='';

    try {
      var bytes = _file != null ? await _file!.readAsBytes() : _webFile!;
      var excel = Excel.decodeBytes(bytes);

      if (excel.tables.keys.isNotEmpty) {
        var table = excel.tables.values.first; // Assuming only one sheet
        var dateColumn = table.cell(CellIndex.indexByString('A2')).value; // Adjust cell index as per your file

        print('dateColumn: ${dateColumn.toString()}');

        String format = detectDateFormat(dateColumn.toString());
        print('Detected date format: $format');//Detected date format: MM/dd/yyyy
        parsedDate = DateFormat(format).parse(dateColumn.toString());
        //print('parsedDate:$parsedDate');
        formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
        //print('formattedDate:$formattedDate');
        //formattedDate:2024-05-20

        setState(() {
          _uploadedDate = formattedDate;
        });
      }
    } catch (e) {
      print('Error reading Excel file: $e');
      setState(() {
        _notificationMessage = 'Error reading Excel file: $e';
      });
    }
  }

  String detectDateFormat(String dateString) {
    List<String> dateFormats = [
      "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
      "yyyy-MM-dd'T'HH:mm:ss'Z'",
      "yyyy-MM-dd",
      "MM/dd/yyyy",
      "dd/MM/yyyy",
      "yyyy/MM/dd",
      // Add more formats as needed
    ];

    for (String format in dateFormats) {
      try {
        DateFormat dateFormat = DateFormat(format);
        dateFormat.parseStrict(dateString); // If parsing succeeds, the format is correct
        return format; // Return the format that successfully parsed the date
      } catch (e) {
        // Continue to the next format if parsing fails
      }
    }

    throw FormatException("Unknown date format: $dateString");
  }

  void _handleOTScheduleButtonPress() async {

    setState(() {
      _notificationMessage = ' '; // Show processing message
      // _webFile = null;
      // _file = null;
    });

    try {

      print('_selectedDate: $selectedDate');
      print('_uploadedDate: $_uploadedDate');
      String formattedDate = selectedDate.toString().split(' ')[0];
      print('formattedDate:$formattedDate');
      if (formattedDate != _uploadedDate) {
        // setState(() {
        //   _notificationMessage = 'Selected date does not match date in the uploaded file';
        // });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content:
            Text('Selected date does not match date in the uploaded file.PLease select correct date'),
          ),
        );
        return;
      }

      List<int> fileBytes =
      _file != null ? await _file!.readAsBytes() : _webFile!;
      String base64File = base64Encode(fileBytes);


      // Check if entries exist for the _uploadedDate
      // bool entriesExist = await _checkEntriesExist(_uploadedDate);
      // if (entriesExist) {
      //   // Delete existing entries
      //   await _deleteEntriesFromSchedule(_uploadedDate);
      //   await _deleteEntriesFromPatients(_uploadedDate);
      // }


      String apiUrl =
          'https://us-central1-amrita-body-scan.cloudfunctions.net/OT_Scheduler';
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

        setState(() {
          //_notificationMessage = ' '; // Show processing message
          _webFile = null;
          _file = null;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                //OTScheduleListScreen(scheduleData: jsonResponse),
            SchedulerOutput(scheduleData: jsonResponse),
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
        Map<String, dynamic> technicalLeads = jsonResponse['Technicial T/L'];
        Map<String, dynamic> nursingLeads = jsonResponse['Nursing T/L'];
        Map<String, dynamic> specialEquipment = jsonResponse['Special Equipment'];
        print("Date:${date['0']}");
        print("Date-runtimeType:${date['0'].runtimeType}");
        //print(mrdNumbers.values);
        //print('nursingLeads $nursingLeads');

        // for (var key in otData.keys) {
        //   // scheduledOTList[otData[key].toString()] = department[key];
        //   sendScheduledOT(otData[key].toString(), department[key]);
        //   //print('${otData[key]} : ${depart[key]} | ');
        // }
        //print(scheduledOTList);

        //API for Doctor
        // for (var key in doctor.keys) {
        //   await Future.delayed(Duration(milliseconds: 500));
        //   sendDoctorList(doctor[key].toString(), department[key]);
        // }

        //API call for procedure_list
        // for (var key in procedure.keys) {
        //   await Future.delayed(Duration(milliseconds: 600));
        //
        //   var duration = calculateDuration(end_time[key], start_time[key]);
        //   //print('duration - $duration');
        //   // duration = parseTime(end_time[key]).
        //   sendProcedureList(
        //       procedure[key].toString(), department[key].toString(), duration);
        // }

        //API for patient
        // for (var key in patient.keys) {
        //   //print('age-${jsonResponse['Age/Sex'][key].toString().split('/')[0].split('Y')[0]}');
        //   // Introduce a delay of 1000 milliseconds (1 second)
        //   await Future.delayed(Duration(milliseconds: 500));
        //   sendPatientList(patient[key].toString(), age[key].split('/')[0],
        //       age[key].split('/')[1], mrdNumbers[key], date[key]);
        // }

        //API for OT staff
        // for (var key in nursingLeads.keys) {
        //   await Future.delayed(Duration(milliseconds: 500));
        //   sendOtStafffList(nursingLeads[key], department[key], 'Nursing T/L');
        // }

        // for (var key in technicalLeads.keys) {
        //   await Future.delayed(Duration(milliseconds: 500));
        //   sendOtStafffList(technicalLeads[key], department[key], 'Technical T/L');
        // }

        //print(patient_id);
        //API for scheduled surgeries
        //DateFormat format = DateFormat('MM/dd/yy');
        //DateFormat inputFormat = DateFormat('dd/MM/yyyy');

        // for (var key in procedure.keys) {
        //   //print('age-${jsonResponse['Age/Sex'][key].toString().split('/')[0].split('Y')[0]}');
        //   // Introduce a delay of 1000 milliseconds (1 second)
        //   // print('date: ${inputFormat.parse((date[key]))}');
        //   // print('Data type of date[key]: ${inputFormat.parse(date[key])}');
        //   await Future.delayed(Duration(milliseconds: 500));
        //   //deleteEntries(date[key]);
        //   sendScheduleSurgery(
        //     procedure[key],
        //     department[key],
        //     doctor[key],
        //     patient[key],
        //     mrdNumbers[key].toString(),
        //     date[key],
        //     start_time[key],
        //     end_time[key],
        //     otData[key],
        //     technicalLeads[key],
        //     nursingLeads[key],
        //     specialEquipment[key],
        //
        //   );
        // }
      } else {
        setState(() {
          _notificationMessage =
          'Error: ${response.statusCode}'; // Update notification message with error
        });
        // print('Error-1: ${response.statusCode}');
        // print('Response body-1: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _notificationMessage =
        'Error: $e'; // Update notification message with error
      });
      print('Error-2: $e');
    }

  }

  Future<void> _deleteEntriesFromSchedule(String uploadedDate) async {
    String apiUrl = '$baseUrl/schedule/';
    String deleteUrl = apiUrl + 'delete-all-on-date/?surgery_date=$uploadedDate';
    var deleteResponse = await http.delete(
      Uri.parse(deleteUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (deleteResponse.statusCode == 200 || deleteResponse.statusCode == 204) {
      print('Entries deleted successfully.');
    } else {
      print('Error deleting entries: ${deleteResponse.statusCode}');
      print('Response body: ${deleteResponse.body}');
    }
  }

  Future<void> _deleteEntriesFromPatients(String uploadedDate) async{
    String apiUrl = '$baseUrl/patient/';
    String deleteUrl = apiUrl + 'delete-all-on-date/?registration_date=$uploadedDate';
    var deleteResponse = await http.delete(
      Uri.parse(deleteUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (deleteResponse.statusCode == 200 || deleteResponse.statusCode == 204) {
      print('Entries deleted successfully.');
    } else {
      print('Error deleting entries: ${deleteResponse.statusCode}');
      print('Response body: ${deleteResponse.body}');
    }
  }

  Future<bool> _checkEntriesExist(String uploadedDate) async {

    String apiUrl = '$baseUrl/schedule/';
    String checkUrl = apiUrl + '?surgery_date=$uploadedDate';
    print('checkUrl:$checkUrl');

    var response = await http.get(
      Uri.parse(checkUrl),
      headers: {'Content-Type': 'application/json'},
      //body: jsonEncode({'surgery_date': date}),
    );

    if(response.statusCode == 200){
      List<dynamic> data = jsonDecode(response.body);
      return data.isNotEmpty;
    }
    else{
      print('Error checking entries: ${response.statusCode}');
      return false;
    }

  }

  void sendScheduledOT(String otNumber, String department) async {
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

  void sendOtStafffList(String staff_name, String department, String designation) async {
    String apiUrl = '$baseUrl/otstaff/';

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'ot_staff_name': staff_name, 'ot_staff_department':
          department, 'ot_staff_designation': designation}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('otStafffList():Data sent to the backend successfully.');
      // Optionally, handle the response from the backend if needed
    } else {
      print('Error sending data to the backend: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  void sendPatientList(String name, String age, String gender, int mrd, String surgeryDate) async {
    String apiUrl = '$baseUrl/patient/';

    //DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(surgeryDate.toString());
    //String formattedDate = DateFormat('mm')
    print('sendPatientList_surgeryDate: $surgeryDate');

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'patient_name': name,
        'age': int.parse(age.split('Y')[0]),
        'gender': gender,
        'mrd': mrd,
        'registration_date' : surgeryDate
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('sendPatientList():Data sent to the backend successfully.');
      // Parse the response body
      //Map<String, dynamic> responseBody = jsonDecode(response.body);


      print('sendPatientList():${response.body}');
      // Retrieve the patient_id from the response body
      //var id = responseBody['patient_id'];
      //patient_id.add(id);
      // Optionally, handle the response from the backend if needed
    } else {
      print('Error sending data to the backend: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  void sendProcedureList(
      String procedure_name, String department, double duration) async {
    String apiUrl = '$baseUrl/procedure/';

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'procedure_name': procedure_name,
        'department': department,
        'estimated_duration': duration
      }),
    );

    print('sendProcedureList:' + response.body);

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

  void sendScheduleSurgery(procedure, department, doctor, patient, mrd, date,
      start_time, end_time, otData, technician_tl, nurse_tl, specialEquipment) async {
    String apiUrl = '$baseUrl/schedule/';
    print('DateFormat:${DateFormat('MM/dd/yyyy').parse(date).toString().split(' ')[0]}');

    // print('sendScheduleSurgery:$apiUrl');
    // print('sendScheduleSurgery()-date:${date.runtimeType} ${DateTime.parse(date)}');

    String formattedDate = DateFormat('MM/dd/yyyy').parse(date).toString().split(' ')[0];
    // print('formattedDate:$formattedDate');

    //String deleteUrl = apiUrl + 'delete-all-on-date/?surgery_date=$formattedDate';
    // String checkUrl = apiUrl + '?surgery_date=$formattedDate';
    // print('checkUrl:$checkUrl');
    // //
    // var getResponse = await http.get(
    //   Uri.parse(checkUrl),
    //   headers: {'Content-Type': 'application/json'},
    //   //body: jsonEncode({'surgery_date': date}),
    // );

    //print('responseGet.body::${getResponse.body}');

    // if (getResponse.statusCode == 200) {
    //   // Entries exist, proceed with deletion
    //   String deleteUrl = apiUrl + 'delete-all-on-date/?surgery_date=$formattedDate';
    //   var deleteResponse = await http.delete(
    //     Uri.parse(deleteUrl),
    //     headers: {'Content-Type': 'application/json'},
    //   );
    //
    //   if (deleteResponse.statusCode == 200 || deleteResponse.statusCode == 204) {
    //     print('Entries deleted successfully.');
    //   } else {
    //     print('Error deleting entries: ${deleteResponse.statusCode}');
    //     print('Response body: ${deleteResponse.body}');
    //   }
    // }
    //else {
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'procedure_name': procedure,
        'department': department,
        'patient_name': patient,
        'mrd': mrd,
        'doctor_name': doctor,
        'surgery_start_time': start_time,
        'surgery_end_time': end_time,
        'surgery_date': date,
        'ot_number': otData,
        'technician_tl': technician_tl,
        'nurse_tl': nurse_tl,
        'special_equipment': specialEquipment,
      }),
    );

    print('sendScheduleSurgery:' + response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('sendScheduleSurgery()-Data sent to the backend successfully.');
      print('sendScheduleSurgery() ${response.body}');
      // Parse the response body
      //Map<String, dynamic> responseBody = jsonDecode(response.body);

      // Retrieve the patient_id from the response body
      // procedure_id = responseBody['procedure_id'];
      // Optionally, handle the response from the backend if needed
    } else {
      print('Error sending data to the backend: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
    //}
  }

  _viewPastHistory() {

  }


}

