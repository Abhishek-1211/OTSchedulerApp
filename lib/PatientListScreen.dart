import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_flutter_app/CapturedRecord.dart';

class PatientListScreen extends StatefulWidget {
  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  DateTime? selectedDate; // Change to DateTime?
  List<String> patientList = []; // Initialize empty list
  bool isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient List'),
      ),
      // backgroundColor: Colors.lightBlueAccent,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
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

                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Show list of patients only if a date is selected
                    if (selectedDate != null) {
                      // For demonstration, populating a dummy patient list
                      patientList = ['Rahul', 'Ranjeet', 'Rinku Singh','Amma'];
                      // Navigate to patient list details screen OR Make patient list visible
                      setState(() {
                        isSubmitted = true;
                      });
                    } else {
                      // Show error message if no date is selected
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select a date first.'),
                        ),
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (selectedDate != null)
              Text(
                'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}',
              ),

            SizedBox(height: 30),
            if(isSubmitted)
              Expanded(
                child: Column(
                  children: [
                    Text('Patients', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
                    SizedBox(height: 5),
                    Divider(height: 1, color: Colors.black87,thickness: 1),

                    Expanded(
                      child: ListView.builder(
                        itemCount: patientList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(patientList[index]),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CapturedRecord(patientName: patientList[index])));
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

          ],
        ),
      ),
    );
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
    }
  }
}