import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'package:my_flutter_app/TimeMonitoring/CapturedRecord.dart';

class PatientListScreen extends StatefulWidget {
  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  DateTime? selectedDate;
  List<String> patientList = [];
  List<String> doctorList = [];
  List<String> procedureList = [];
  List<String> techniciansList = [];
  List<String> nursesList = [];
  List<String> specialEquipmentList = [];
  List<int> surgery_id = [];
  List<String> ot_numbers = [];
  List<DateTime> surgery_date = [];
  bool isSubmitted = false;

  //String baseUrl = 'https://9c79-2409-40d0-b5-dafe-c4cf-904e-59b2-3fd4.ngrok-free.app/api';
  String baseUrl = 'http://127.0.0.1:8000/api';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient List'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), // Set the height of the divider
          child: Divider(color: Colors.grey), // Divider below the app bar title
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Text('Select Date'),
                ),
                SizedBox(width: 20),
                // ElevatedButton(
                //   onPressed: () {
                //     if (selectedDate != null) {
                //       _fetchPatientList(
                //           selectedDate!); // Call function to fetch patient list
                //     } else {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(
                //           content: Text('Please select a date first.'),
                //         ),
                //       );
                //     }
                //   },
                //   child: Text('Submit'),
                // ),
              ],
            ),
            SizedBox(height: 20),
            if (selectedDate != null)
              Text(
                'Selected Date: ${DateFormat('MM-dd-yyyy').format(selectedDate!)}',
              ),
            SizedBox(height: 30),
            if (isSubmitted)
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Patients',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18),
                    ),
                    SizedBox(height: 5),
                    Divider(height: 1, color: Colors.black87, thickness: 1),
                    Expanded(
                      child: ListView.builder(
                        itemCount: patientList.length,
                        itemBuilder: (context, index) {
                          Color tileColor =
                              index.isEven ? Colors.blue[100]! : Colors.white;
                          return Container(
                              color: tileColor,
                              child: ListTile(
                                title: Text(patientList[index]),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('OT Number: ${ot_numbers[index]}'),
                                    Text('Surgery ID: ${surgery_id[index]}'),
                                    Text('Surgeon: ${doctorList[index]}'),
                                  ],
                                ),
                                onTap: () {
                                  // Handle onTap event
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CapturedRecord(
                                                patientName: patientList[index],
                                                surgeryId: surgery_id[index],
                                                otNumber: ot_numbers[index],
                                                surgeryDate:
                                                    surgery_date[index],
                                                // Pass DateTime value
                                                doctorName: doctorList[index],
                                                procedureName:
                                                    procedureList[index],
                                                technician:
                                                    techniciansList[index],
                                                nurse: nursesList[index],
                                                specialEquipment:
                                                    specialEquipmentList[index],
                                              )));
                                },
                              ));
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 50,
                          width: 180,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlueAccent,
                                  textStyle: const TextStyle(color: Colors.white),
                                  elevation: 40,
                                  shape: const RoundedRectangleBorder(
                                         borderRadius: BorderRadius.all(Radius.circular(2)))),
                              onPressed: (){
                                _showDialogForm(0);
                              },
                              child: Text('           Add\nEmergency Surgery',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),)),
                        ),
                        SizedBox(width: 40),
                        Container(
                          height: 50,
                          width: 180,
                          child: ElevatedButton(
                              //style: ElevatedButton.styleFrom( disabledForegroundColor: Colors.red.withOpacity(0.38), disabledBackgroundColor: Colors.red.withOpacity(0.12)),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlueAccent,
                                  textStyle: const TextStyle(color: Colors.white),
                                  elevation: 40,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(2)))),
                              onPressed: (){
                                _showDialogForm(1);
                              },
                              child: Text('        Add\nAdd-on Surgery',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchPatientList(DateTime date) async {
    try {
      //String formattedDate = "(${date.year},${date.month},${date.day})";
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      print('Date - $date');
      print('Formatted date - $formattedDate');
      Uri url = Uri.parse('$baseUrl/schedule/?surgery_date=$formattedDate');

      final headers = {'Accept': 'application/json'};

      print(url);
      final response = await http.get(
        url,
        headers: headers,
      );
      print('2');

      print(response.statusCode);
      //print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body);
        print("patientListScreen_fetchPatientList(): ${response.body}");
        final List<Map<String, dynamic>> patients = data
            .where((element) =>
                element['surgery_date'] ==
                DateFormat('MM/dd/yyyy').format(date))
            .map<Map<String, dynamic>>((e) => {
                  'patientName': e['patient_name'] as String,
                  'scheduledSurgeryId': e['scheduled_surgery_id'] as int,
                  'otNumber': e['ot_number'] as String,
                  'surgery_date': DateFormat('MM/dd/yyyy')
                      .parse(e['surgery_date'] as String),
                  'doctor_name': e['doctor_name'] as String,
                  'procedure_name': e['procedure_name'] as String,
                  'technician': e['technician_tl'] as String,
                  'nurse': e['nurse_tl'] as String,
                  'specialEquipment': e['special_equipment'] as String,
                })
            .toList();

        if (data.isEmpty) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content:
          //     Text('No data Available. Please select correct date.'),
          //   ),
          // );
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                      'No data available.\nPlease select correct date'),
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

        setState(() {
          patientList =
              patients.map<String>((e) => e['patientName'] as String).toList();
          surgery_id =
              patients.map<int>((e) => e['scheduledSurgeryId'] as int).toList();
          ot_numbers =
              patients.map<String>((e) => e['otNumber'] as String).toList();
          surgery_date = patients
              .map<DateTime>((e) => e['surgery_date'] as DateTime)
              .toList(); // Store as DateTime
          doctorList =
              patients.map<String>((e) => e['doctor_name'] as String).toList();
          procedureList = patients
              .map<String>((e) => e['procedure_name'] as String)
              .toList();
          techniciansList =
              patients.map<String>((e) => e['technician'] as String).toList();
          nursesList =
              patients.map<String>((e) => e['nurse'] as String).toList();
          specialEquipmentList = patients
              .map<String>((e) => e['specialEquipment'] as String)
              .toList();
          isSubmitted = true;
        });
      } else {
        throw Exception('Failed to load patient list');
      }
    } catch (e) {
      print('Error fetching patient list: $e');
      print(techniciansList);
      print(nursesList);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Failed to fetch patient list. Please try again later.'),
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
      _fetchPatientList(selectedDate!);
      //   if (selectedDate != null) {
      //      // Call function to fetch patient list
      //   // } else {
      //   //   ScaffoldMessenger.of(context).showSnackBar(
      //   //     SnackBar(
      //   //       content: Text('Please select a date first.'),
      //   //     ),
      //   //   );
      //   // }
      // } else {}
    }
  }

  void _showDialogForm(int id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          var nameController = TextEditingController();
          var mrdNumber = TextEditingController();
          var surgeonName = TextEditingController();
          var department = TextEditingController();
          var otNumber = TextEditingController();
          var surgeryName = TextEditingController();
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2.0))),
            scrollable: true,
            title: const Text(
                'Please Enter Patient Details'),
            //content: const Text('Thank you!!!Your inputs have been recorded successfully'),
            content: Padding(padding: const EdgeInsets.all(8.0),
            child: Form (
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Patient Name',
                        //icon: Icon(Icons.account_box)
                      ),
                    ),
                    TextFormField(
                      controller: mrdNumber,
                      decoration: InputDecoration(
                          labelText: 'MRD Number',
                          //icon: Icon(Icons.account_box)
                      ),
                    ),
                    TextFormField(
                      controller: surgeonName,
                      decoration: InputDecoration(
                          labelText: 'Surgeon Name',
                          //icon: Icon(Icons.account_box)
                      ),
                    ),
                    TextFormField(
                      controller: department,
                      decoration: InputDecoration(
                          labelText: 'Department',
                          //icon: Icon(Icons.account_box)
                      ),
                    ),
                    TextFormField(
                      controller: otNumber,
                      decoration: InputDecoration(
                          labelText: 'OT Number',
                          //icon: Icon(Icons.account_box)
                      ),
                    ),
                    TextFormField(
                      controller: surgeryName,
                      decoration: InputDecoration(
                          labelText: 'Surgery Name',
                          //icon: Icon(Icons.account_box)
                      ),
                    ),
                  ],
                ),
             ),
            ),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2)))
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CapturedRecord.emergency(
                              patientName: nameController.text,
                              otNumber: otNumber.text,
                              //surgeryDate: DateTime(DateTime.now().year-DateTime.now().month-DateTime.now().day),
                              surgeryDate:selectedDate!,
                              surgeryId: id,
                              doctorName: surgeonName.text,
                              procedureName: surgeryName.text,
                            )));
                  }
                  , child: Text("Submit",
                style: TextStyle(color: Colors.white),
              )
              )
              // TextButton(
              //   style: TextButton.styleFrom(
              //     textStyle: Theme.of(context).textTheme.labelLarge,
              //   ),
              //   child: const Text('OK'),
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //     //Navigator.of(context).pop();
              //     // Navigator.push(
              //     //   context,
              //     //   MaterialPageRoute(builder: (context) => Login()),
              //     // );
              //   },
              // ),
            ],
          );
        });
  }
}
