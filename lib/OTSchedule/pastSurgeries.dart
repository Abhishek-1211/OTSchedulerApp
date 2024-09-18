import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:my_flutter_app/config/customThemes/MyAppBar.dart';
import 'package:my_flutter_app/config/customThemes/utilities/Utilities.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../TimeMonitoring/TimeMonitoring.dart';
import '../config/customThemes/elevatedButtonTheme.dart';

class PastSurgeries extends StatefulWidget {
  //final Map<String, dynamic> scheduleData;
  List<dynamic> pastScheduledData;
  DateTime surgeryDate;


  PastSurgeries(this.pastScheduledData,this.surgeryDate);

  @override
  _PastSurgeriesState createState() => _PastSurgeriesState();
}

class _PastSurgeriesState extends State<PastSurgeries> {
  late List<MapEntry<String, dynamic>> sortedOTEntries;

  List<dynamic> sortedData = [];

  static const double leftMargin = 180;
  static const Color headerTextColor = Colors.black87;
  static const double headerTextSize = 16.0;
  static const InputDecoration rowDecoration = InputDecoration(border: InputBorder.none,);
  String baseUrl = 'http://127.0.0.1:8000/api';
  bool isDownloadEnabled = true;
  int tapCount = 0;

  @override
  void initState() {
    super.initState();


    super.initState();

    // Sort the data by 'OT Number'
    sortedData = widget.pastScheduledData;
    sortedData.sort((a, b) => a['ot_number'].compareTo(b['ot_number']));
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    // otNumberControllers.forEach((controller) => controller.dispose());
    // surgeonControllers.forEach((controller) => controller.dispose());
    // surgeryControllers.forEach((controller) => controller.dispose());
    // startTimeControllers.forEach((controller) => controller.dispose());
    // endTimeControllers.forEach((controller) => controller.dispose());
    // dateControllers.forEach((controller) => controller.dispose());
    // mrdControllers.forEach((controller) => controller.dispose());
    // patientNameControllers.forEach((controller) => controller.dispose());
    // specialEquipmentControllers.forEach((controller) => controller.dispose());
    // departmentControllers.forEach((controller) => controller.dispose());
    // ageSexControllers.forEach((controller) => controller.dispose());
    // technicalLeadsControllers.forEach((controller) => controller.dispose());
    // nursingLeadsControllers.forEach((controller) => controller.dispose());
    super.dispose();
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



  Future<void> _exportDataToCsv() async {
    try {
      List<List<dynamic>> rows = [];
      // Add header row
      List<String> headers = [
        'Date',
        'OT Number',
        'Surgeon',
        'Department',
        'Surgery',
        'Start Time',
        'End Time',
        'MRD Number'
            'Special Equipment',
        // 'Name of Patient',
        // 'Age/Sex',
        'Nursing T/l',
        'Technician T/L'
      ];
      rows.add(headers);

      // Add data rows
      for (var entry in sortedData) {
        final String date = entry['surgery_date'] ?? '';
        final String otNumber = entry['ot_number'] ?? '';
        final String surgeon = entry['doctor_name'] ?? '';
        final String department = entry['department'] ?? '';
        final String surgery = entry['procedure_name'] ?? '';
        final String startTime = entry['surgery_start_time'] ?? '';
        final String endTime = entry['surgery_end_time'] ?? '';
        final String mrdNumber = entry['mrd'] ?? '';
        final String specialEquipment = entry['special_equipment'] ?? 'N/A';
        final String nursingTL = entry['nurse_tl'] ?? 'N/A';
        final String technicianTL = entry['technician_tl'] ?? 'N/A';

        rows.add([
          date,
          'OT $otNumber',
          surgeon,
          department,
          surgery,
          startTime,
          endTime,
          mrdNumber,
          specialEquipment,
          // patientName,
          // ageSex,
          nursingTL,
          technicianTL,
        ]);
      };

      // Generate CSV string
      String csvString = const ListToCsvConverter().convert(rows);

      if (kIsWeb) {
        // Generate download link for web
        final anchor = html.AnchorElement(
            href:
            'data:text/csv;charset=utf-8,${Uri.encodeComponent(csvString)}')
          ..setAttribute('download', 'ot_schedule.csv')
          ..click();
      } else {
        // Get the directory for saving the CSV file
        Directory? directory = await getExternalStorageDirectory();
        if (directory != null) {
          String filePath = '${directory.path}/ot_schedule.csv';

          // Write CSV string to file
          File file = File(filePath);
          await file.writeAsString(csvString);

          print('CSV file exported to: $filePath');
        } else {
          print('Error: Directory not found');
        }
      }
    } catch (e) {
      print('Error exporting data to CSV: $e');
    }

    // setState(() {
    //   isDownloadEnabled = false;
    // });

  }



  @override
  Widget build(BuildContext context) {
    // Define table columns
    final columns = [
      // DataColumn(
      //   label: Container(
      //     padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      //     color: Colors.blueAccent,
      //     child: Text('Date', style: TextStyle(color: Colors.white)),
      //   ),
      // ),
      DataColumn(

        label: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          //color: Colors.blueAccent,
          child: Text('OT Number', style: TextStyle(color: headerTextColor,fontSize: headerTextSize,fontWeight: FontWeight.bold)),
        ),
      ),
      DataColumn(
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          //color: Colors.blueAccent,
          child: Text('Surgeon', style: TextStyle(color: headerTextColor,fontSize: headerTextSize,fontWeight: FontWeight.bold)),
        ),
      ),
      DataColumn(
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          //color: Colors.greenAccent,
          child: Text('Department', style: TextStyle(color: headerTextColor,fontSize: headerTextSize,fontWeight: FontWeight.bold)),
        ),
      ),
      DataColumn(
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          //color: Colors.orangeAccent,
          child: Text('Surgery', style: TextStyle(color: headerTextColor,fontSize: headerTextSize,fontWeight: FontWeight.bold)),
        ),
      ),
      DataColumn(
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          //color: Colors.purpleAccent,
          child: Text('Start Time', style: TextStyle(color: headerTextColor,fontSize: headerTextSize,fontWeight: FontWeight.bold)),
        ),
      ),
      DataColumn(
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          //color: Colors.redAccent,
          child: Text('End Time', style: TextStyle(color: headerTextColor,fontSize: headerTextSize,fontWeight: FontWeight.bold)),
        ),
      ),
      DataColumn(
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          //color: Colors.redAccent,
          child: Text('MRD Number', style: TextStyle(color: headerTextColor,fontSize: headerTextSize,fontWeight: FontWeight.bold)),
        ),
      ),
      // DataColumn(
      //   label: Container(
      //     padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      //     //color: Colors.blueAccent,
      //     child: Text('Name of Patient', style: TextStyle(color: headerTextColor,fontSize: headerTextSize,fontWeight: FontWeight.bold)),
      //   ),
      // ),
      // DataColumn(
      //   label: Container(
      //     padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      //     //color: Colors.blueAccent,
      //     child: Text('Age/Sex', style: TextStyle(color: headerTextColor,fontSize: headerTextSize,fontWeight: FontWeight.bold)),
      //   ),
      // ),
      DataColumn(
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          //color: Colors.blueAccent,
          child:
          Text('Special Equipment', style: TextStyle(color: headerTextColor,fontSize: headerTextSize,fontWeight: FontWeight.bold)),
        ),
      ),
      DataColumn(
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          //color: Colors.blueAccent,
          child: Text('Technical T/L', style: TextStyle(color: headerTextColor,fontSize: headerTextSize,fontWeight: FontWeight.bold)),
        ),
      ),
      DataColumn(
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          //color: Colors.blueAccent,
          child: Text('Nursing T/L', style: TextStyle(color: headerTextColor,fontSize: headerTextSize,fontWeight: FontWeight.bold)),
        ),
      ),
    ];

    // Define table rows
    final rows = sortedData.map<DataRow>((surgery) {
      return DataRow(
        //onLongPress: _onRowTap(surgery),
        //selected: false,
        onSelectChanged: (bool? selected) {
          if (selected != null && selected) {
            tapCount++;
            // setState(() {
            //   tapCount;
            // });
            Future.delayed(Duration(seconds: 1), () {
              _onRowTap(surgery,tapCount); // Handle row tap after a delay
            });// Handle row tap
          }
        },
        cells: [
          DataCell(Text(surgery['ot_number'])),
          DataCell(Text(surgery['doctor_name'])),
          DataCell(Text(surgery['department'])),
          DataCell(Text(surgery['procedure_name'])),
          DataCell(Text(surgery['surgery_start_time'])),
          DataCell(Text(surgery['surgery_end_time'])),
          DataCell(Text(surgery['mrd'])),
          DataCell(Text(surgery['special_equipment'] ?? 'N/A')),
          DataCell(Text(surgery['technician_tl'] ?? 'N/A')),
          DataCell(Text(surgery['nurse_tl'] ?? 'N/A')),
        ],
      );
    }).toList();


    return Scaffold(
      appBar: MyAppBar(),
      body:
      Padding(
        padding: const EdgeInsets.only(left: leftMargin, right: 80, top: 10,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     'List of OT\'s Scheduled',
            //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //   ),
            // ),
            Text(
              'Scheduled Surgeries',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'View all scheduled surgeries across all operation theaters',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            Divider(color: Colors.blueGrey[50], thickness: 2, endIndent: 500,),
            SizedBox(height: 20),
            Text('OT NUMBER', style: TextStyle (fontSize: 16, fontWeight: FontWeight.w800,color: Colors.blueGrey),),
            SizedBox(height: 6),
            Row(
              children: [
                SizedBox(
                  width: 260,
                  height: 45,
                  child: TextField(
                    decoration: Utilities.otSearchBoxDecoration,
                  ),
                ),

                SizedBox(width: 500,),
                ElevatedButton (
                  style: MyElevatedButtonTheme.elevatedButtonTheme2.style,
                  onPressed: isDownloadEnabled ? _exportDataToCsv:null,
                  child: Text('Download',style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
            SizedBox(height:25),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: columns,
                    // columns: [
                    //   DataColumn(label: Text('OT Number')),
                    //   DataColumn(label: Text('Surgery Name')),
                    //   DataColumn(label: Text('Surgeon Name')),
                    //   DataColumn(label: Text('Start Time')),
                    //   DataColumn(label: Text('End Time')),
                    //   DataColumn(label: Text('Patient Name')),
                    //   //DataColumn(label: Text('MRD Number')),
                    // ],
                    rows: rows,
                    dividerThickness: 1.5,
                    showCheckboxColumn: false,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),

                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Center(
            //   child: ElevatedButton(
            //     style: MyElevatedButtonTheme.elevatedButtonTheme2.style,
            //     onPressed: () {
            //       //_saveChanges();
            //       setState(() {
            //         isDownloadEnabled = true;
            //       });
            //
            //     },
            //     child: Text('Update/Confirm',style: TextStyle(color: Colors.white),),
            //   ),
            // ),
            SizedBox(height: 10),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _exportDataToCsv,
      //   tooltip: 'Export CSV',
      //   child: Icon(Icons.file_download),
      // ),
    );
  }

  _onRowTap(surgery,tapCount) {
    print("onRowTap(): $tapCount");
    // if(tapCount>1){
    //   print("onRowTap(): if");
    //   tapCount = 0;
    //   // setState(() {
    //   //   tapCount;
    //   // });
    // }else {
      print("onRowTap(): else");
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) =>
                  TimeMonitoring(otNumber: surgery['ot_number'],
                    patientName: surgery['patient_name'],
                    surgeryId:
                    surgery['scheduled_surgery_id'],
                    surgeryDate:
                    widget.surgeryDate,
                    // Pass DateTime value
                    doctorName:
                    surgery['doctor_name'],
                    department:
                    surgery['department'],
                    procedureName:
                    surgery['procedure_name'],
                    technician:
                    surgery['technician_tl'],
                    nurse: surgery['nurse_tl'],
                    specialEquipment:
                    surgery['special_equipment'],
                    caller: 'pastSurgeries',
                  )));
    //}

  }
  
}
