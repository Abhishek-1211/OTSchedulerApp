import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class OTDashboard extends StatefulWidget{
  @override
  _OTDashboardState createState() => _OTDashboardState();

}

class _OTDashboardState  extends State<OTDashboard>{

  Map<String, int> surgeryCountsMap = {};
  List<SurgeryData> chartData = [];
  List<UtilisationData> utilisationData = [];
  late TextEditingController fromDateController;
  late TextEditingController toDateController;
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();

  String baseUrl = 'http://127.0.0.1:8000/api';

  @override
  void initState() {
    super.initState();
    _getSurgeryCount();
    fromDateController = TextEditingController(text: '');
    toDateController = TextEditingController(text: '');
    _otUtilization();
  }

  void _getSurgeryCount() async{

    String apiUrl = '$baseUrl/ot-surgery-count/';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Data Received from the backend successfully.-OTDashboard()');
      // Optionally, handle the response from the backend if needed
      print('Response body: ${response.body}');
      //Parse the JSON response
      Map<String, dynamic> responseData = jsonDecode(response.body);

      List<dynamic> surgeriesList = responseData['Count of surgeries per OT on all dates'];
      print('SurgeryList - $surgeriesList');
      setState(() {
        chartData.addAll(surgeriesList.map((item) => SurgeryData.fromJson(item)).toList());
      });
      // print('Chart Data - ${chartData[0].otNumber} | ${chartData[0].surgeryCount}');

    } else {
      //print('Error sending data to the backend: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  void _otUtilization() async {
    String apiUrl = '$baseUrl/percent-ot-utilization/';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Data Received from the backend successfully.-_getOtUtilization()');
      // Optionally, handle the response from the backend if needed
      print('Utilisation Response: ${response.body}');
      List<dynamic> utilisationList = jsonDecode(response.body);
      // print(utilisationList);
      // List<dynamic> utilisationList = responseData.entries.map((entry) => MapEntry(entry.key, entry.value)).toList();
      // print('utilisationList $utilisationList');
      setState(() {
        utilisationData.addAll(utilisationList.map((item) => UtilisationData.fromJson(item)).toList());
      });
    } else {
      //print('Error sending data to the backend: ${response.statusCode}');
      print('Response body: ${response.body}');
    }


  }

  Widget _buildBarChart<T>(List<T> data, String xAxisTitle, String yAxisTitle) {
    return SfCartesianChart(
      isTransposed: true,
      backgroundColor: Colors.grey[200],
      primaryXAxis: CategoryAxis(
        title: AxisTitle(text: xAxisTitle, textStyle: TextStyle(fontWeight: FontWeight.bold)),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: yAxisTitle, textStyle: TextStyle(fontWeight: FontWeight.bold)),
      ),
      legend: Legend(isVisible: true, position: LegendPosition.top),
      series: <BarSeries<T, String>>[
        BarSeries<T, String>(
          dataSource: data,
          xValueMapper: (T data, _) {
            if (data is SurgeryData) {
              return data.otNumber; // Use otNumber for SurgeryData
            } else if (data is UtilisationData) {
              return data.otNumber; // Use otNumber for UtilisationData
            }
            return ''; // Default case
          },
          yValueMapper: (T data, _) {
            if (data is SurgeryData) {
              return double.parse(data.surgeryCount); // Use surgeryCount for SurgeryData
            } else if (data is UtilisationData) {
            return data.utilisationPercentage.toDouble(); // Convert to double for UtilisationData
            }
            return 0; // Default case
          },
          width: 0.2,
          color: Colors.blueAccent,
          name: 'Data',
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            color: Colors.blue,
            textStyle: TextStyle(color: Colors.white, fontSize: 10),
          ),
          legendIconType: LegendIconType.circle,
          legendItemText: 'Data',
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OT Dashboard'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), // Set the height of the divider
          child: Divider(color: Colors.grey), // Divider below the app bar title
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              //Padding()
                Container(
                  width: 200,
                  child: TextField(
                    controller: fromDateController,
                    canRequestFocus: false,
                    decoration: InputDecoration(
                      labelText: 'From Date',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.calendar_today, size: 20),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.indigoAccent,
                  ),
                  child: IconButton(
                    onPressed: () => _selectFromDate(context),
                    icon: Icon(Icons.calendar_today_outlined),
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 50),
                Container(
                  width: 200,
                  child: TextField(
                    controller: toDateController,
                    canRequestFocus: false,
                    decoration: InputDecoration(
                      labelText: 'To Date',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.calendar_today, size: 20),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.indigoAccent,
                  ),
                  child: IconButton(
                    onPressed: () => _selectToDate(context),
                    icon: Icon(Icons.calendar_today_outlined),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  // width: 500,
                  child: _buildBarChart(chartData, 'OT Number', 'Surgery Count'),
                ),
                SizedBox(width: 30),
                Expanded(
                  // width: 500,
                  child: _buildBarChart(utilisationData, 'OT Number', 'Utilization Percentage'),
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedFromDate,
      firstDate: DateTime(1947), // Adjust the first and last date according to your needs1
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedFromDate) {
      setState(() {
        selectedFromDate = picked;
        String date = "${selectedFromDate.toLocal()}".split(' ')[0];
        fromDateController?.text = date;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedToDate,
      firstDate: DateTime(1947), // Adjust the first and last date according to your needs1
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedToDate) {
      setState(() {
        selectedToDate = picked;
        String date = "${selectedToDate.toLocal()}".split(' ')[0];
        toDateController?.text = date;
      });
    }

    //_setValues(context);
  }





}

class SurgeryData {
  final String otNumber;
  final String surgeryCount;

  SurgeryData({required this.otNumber, required this.surgeryCount});

  factory SurgeryData.fromJson(Map<String, dynamic> json) {
    return SurgeryData(
      otNumber: json.keys.first.toString(),
      surgeryCount: json.values.first.toString() ?? '',
    );
  }
}

class UtilisationData {
  final String otNumber;
  final int utilisationPercentage;

  UtilisationData({required this.otNumber, required this.utilisationPercentage});

  factory UtilisationData.fromJson(Map<String, dynamic> json) {
    return UtilisationData(
      otNumber: json.keys.first.toString(),
      utilisationPercentage: ((json.values.first as double) * 100).toInt(),
    );
  }
}