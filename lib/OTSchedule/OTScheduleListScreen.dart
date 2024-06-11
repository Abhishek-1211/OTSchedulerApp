import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class OTScheduleListScreen extends StatefulWidget {
  final Map<String, dynamic> scheduleData;

  const OTScheduleListScreen({Key? key, required this.scheduleData})
      : super(key: key);

  @override
  _OTScheduleListScreenState createState() => _OTScheduleListScreenState();
}

class _OTScheduleListScreenState extends State<OTScheduleListScreen> {
  late List<MapEntry<String, dynamic>> sortedOTEntries;

  @override
  void initState() {
    super.initState();
    // Initialize sortedOTEntries when the widget initializes
    sortedOTEntries =
        widget.scheduleData['OT'].entries.toList();
    sortedOTEntries.sort((a, b) => a.value.compareTo(b.value));
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
        'Special Equipment',
        'Name of Patient',
        'Age/Sex',
        'Nursing T/l',
        'Technician T/L'
      ];
      rows.add(headers);

      // Add data rows
      List<MapEntry<String, dynamic>> sortedOTEntries =
      widget.scheduleData['OT'].entries.toList();
      sortedOTEntries.sort((a, b) => a.value.compareTo(b.value));
      sortedOTEntries.forEach((entry) {
        final otNumber = entry.value.toString();
        final String surgeon = widget.scheduleData['Surgeon'][entry.key];
        final String surgery = widget.scheduleData['surgery'][entry.key];
        final String startTime = widget.scheduleData['Start_time'][entry.key];
        final String endTime = widget.scheduleData['End_time'][entry.key];
        final String date = widget.scheduleData['Date of Surgery'][entry.key];
        final String patientName =
        widget.scheduleData['Name of the Patient'][entry.key];
        final String specialEquipment =
        widget.scheduleData['Special Equipment'][entry.key];
        final String department =
        widget.scheduleData['Department'][entry.key];
        final String ageSex = widget.scheduleData['Age/Sex'][entry.key];
        final String nusringTL = widget.scheduleData['Nursing T/L'][entry.key];
        final String technicianTL = widget.scheduleData['Technicial T/L'][entry.key];
        //final String mrdNumber = widget.scheduleData['MRD'][entry.key];

        rows.add([
          date,
          'OT $otNumber',
          surgeon,
          department,
          surgery,
          startTime,
          endTime,
          specialEquipment,
          patientName,
          ageSex,
          nusringTL,
          technicianTL,
        ]);
      });

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
  }
  @override
  Widget build(BuildContext context) {
    // Define table columns
    final columns = [
      DataColumn(
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          color: Colors.blueAccent,
          child: Text('Date', style: TextStyle(color: Colors.white)),
        ),
      ),
      DataColumn(
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          color: Colors.blueAccent,
          child: Text('OT Number', style: TextStyle(color: Colors.white)),
        ),
      ),
      DataColumn(
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          color: Colors.greenAccent,
          child: Text('Surgeon', style: TextStyle(color: Colors.white)),
        ),
      ),
      DataColumn(
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          color: Colors.greenAccent,
          child: Text('Department', style: TextStyle(color: Colors.white)),
        ),
      ),
      DataColumn(
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          color: Colors.orangeAccent,
          child: Text('Surgery', style: TextStyle(color: Colors.white)),
        ),
      ),
      DataColumn(
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          color: Colors.purpleAccent,
          child: Text('Start Time', style: TextStyle(color: Colors.white)),
        ),
      ),
      DataColumn(
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          color: Colors.redAccent,
          child: Text('End Time', style: TextStyle(color: Colors.white)),
        ),
      ),

      DataColumn(
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          color: Colors.blueAccent,
          child: Text('Name of Patient', style: TextStyle(color: Colors.white)),
        ),
      ),
      // DataColumn(
      //   label: Container(
      //     padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      //     color: Colors.blueAccent,
      //     child:
      //     Text('MRD Number', style: TextStyle(color: Colors.white)),
      //   ),
      // ),
      DataColumn(
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          color: Colors.blueAccent,
          child: Text('Age/Sex', style: TextStyle(color: Colors.white)),
        ),
      ),
      DataColumn(
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          color: Colors.blueAccent,
          child:
          Text('Special Equipment', style: TextStyle(color: Colors.white)),
        ),
      ),
      DataColumn(
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          color: Colors.blueAccent,
          child:
          Text('Technical T/L', style: TextStyle(color: Colors.white)),
        ),
      ),
      DataColumn(
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          color: Colors.blueAccent,
          child:
          Text('Nursing T/L', style: TextStyle(color: Colors.white)),
        ),
      ),
    ];

    // Define table rows
    final rows = sortedOTEntries.map<DataRow>((entry) {
      final otNumber = entry.value.toString();
      final String surgeon = widget.scheduleData['Surgeon'][entry.key];
      final String surgery = widget.scheduleData['surgery'][entry.key];
      final String startTime = widget.scheduleData['Start_time'][entry.key];
      final String endTime = widget.scheduleData['End_time'][entry.key];
      final String date = widget.scheduleData['Date of Surgery'][entry.key];
      final String patientName =
      widget.scheduleData['Name of the Patient'][entry.key];
      final String specialEquipment =
      widget.scheduleData['Special Equipment'][entry.key];
      final String department = widget.scheduleData['Department'][entry.key];
      final String ageSex = widget.scheduleData['Age/Sex'][entry.key];
      final String technicalLeads = widget.scheduleData['Technicial T/L'][entry.key];
      final String nursingLeads = widget.scheduleData['Nursing T/L'][entry.key];
      //final String mrdNumber = widget.scheduleData['MRD'][entry.key];

      return DataRow(
        color: MaterialStateColor.resolveWith((states) {
          // Alternate row color
          return sortedOTEntries.indexOf(entry) % 2 == 0
              ? Colors.grey[200]!
              : Colors.white;
        }),
        cells: [
          DataCell(Text(date)),
          DataCell(Text('OT $otNumber')),
          DataCell(Text(surgeon.contains('/')? '${surgeon.split('/')[0]}...':surgeon)),
          DataCell(Text(department)),
          DataCell(Text(surgery.length>20?'${surgery.substring(0, 20)}...':surgery)),
          DataCell(Text(startTime)),
          DataCell(Text(endTime)),

          DataCell(Text(patientName)),
          //DataCell(Text(mrdNumber)),
          DataCell(Text(ageSex)),
          DataCell(Text(specialEquipment)),
          DataCell(Text(technicalLeads)),
          DataCell(Text(nursingLeads)),
        ],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('OT Schedule'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize:
          Size.fromHeight(1.0), // Set the height of the divider
          child:
          Divider(color: Colors.grey), // Divider below the app bar title
        ),
      ),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'List of OT\'s Scheduled',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: columns,
                    rows: rows,
                    dividerThickness: 2.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ),

          TextButton(
            onPressed: () {
              _exportDataToCsv();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
            child: Text('Download'),
          ),
        ],
      ),
    );
  }
}
