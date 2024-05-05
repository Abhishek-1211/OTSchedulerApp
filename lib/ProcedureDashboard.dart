import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProcedureDashboard extends StatefulWidget {
  @override
  _ProcedureDashboardState createState() => _ProcedureDashboardState();
}

class _ProcedureDashboardState extends State<ProcedureDashboard> {
  late TextEditingController fromDateController;
  late TextEditingController toDateController;
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  //List<SurgeryData> chartData = [];
  Map <String, double> dataMap = {};
  final colorList = <Color>[
    Colors.greenAccent,
  ];
  // List<AverageSurgeryDuration> avgSurgeryDurationData = [];

  String baseUrl = 'http://127.0.0.1:8000/api';

  @override
  void initState() {
    super.initState();
    _getSurgeryType();
    // _getAverageSurgeryDuration();
    fromDateController = TextEditingController(text: '');
    toDateController = TextEditingController(text: '');
    //_otUtilization();
  }

  void _getSurgeryType() async {
    String apiUrl = '$baseUrl/surgery-type-percentage/';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('_getSurgeryType(): Data Received from the backend successfully.');

      // Parse the JSON response
      Map<String, dynamic> responseData = jsonDecode(response.body);

      print(responseData);

      List<dynamic> surgeryTypeList = responseData['message'];
      for (var item in surgeryTypeList) {
        item.forEach((key, value) {
          dataMap[key] = value;
        });
      }
      dataMap.remove('total_surgeries');
      print(dataMap);
      setState(() {
        // Update the state to trigger a rebuild with the new dataMap
      });
      //
      // setState(() {
      //   chartData.addAll(
      //       surgeriesList.map((item) => SurgeryData.fromJson(item)).toList());
      // });
      // print('Chart Data - ${chartData[0].otNumber} | ${chartData[0].surgeryCount}');
    } else {
      //print('Error sending data to the backend: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  // Widget _buildBarChart<T>(List<T> data, String xAxisTitle, String yAxisTitle) {
  //   Color barColor = Colors.teal; // Default color
  //   String legendItemText = 'Data';
  //   Color labelColor = Colors.red;
  //
  //   if (T == SurgeryData) {
  //     barColor = Colors.teal;
  //     legendItemText = 'Surgery Count';
  //     labelColor = Colors.red;
  //   }
  //   // else if (T == AverageSurgeryDuration) {
  //   //   barColor = Colors.redAccent;
  //   //   legendItemText = 'Avg Surgery DurationData';
  //   //   labelColor = Colors.lightBlueAccent;
  //   // }
  //   return SfCartesianChart(
  //     //title: ChartTitle(text: 'Surgery Count Per Doctor'),
  //       isTransposed: true, // Change X and Y axis data
  //       backgroundColor: Colors.grey[200],
  //       primaryXAxis: CategoryAxis(
  //         title: AxisTitle(
  //             text: xAxisTitle,
  //             textStyle: TextStyle(fontWeight: FontWeight.bold)),
  //       ),
  //       primaryYAxis: NumericAxis(
  //         title: AxisTitle(
  //             text: yAxisTitle,
  //             textStyle: TextStyle(fontWeight: FontWeight.bold)),
  //       ),
  //       legend: Legend(isVisible: true, position: LegendPosition.top),
  //       series: <BarSeries<T, String>>[
  //         BarSeries<T, String>(
  //           dataSource: data,
  //           // xValueMapper: (SurgeryData surgeryData, _) => surgeryData.doctorName,
  //           xValueMapper: (T data, _) {
  //             if (data is SurgeryData) {
  //               return data.departmentName; // Use otNumber for SurgeryData
  //             }
  //             // else if (data is AverageSurgeryDuration) {
  //             //   return data.doctorName; // Use otNumber for UtilisationData
  //             // }
  //             return ''; // Default case
  //           },
  //           yValueMapper: (T data, _) {
  //             if (data is SurgeryData) {
  //               return double.parse(data.surgeryCount);
  //             }
  //             // else if (data is AverageSurgeryDuration) {
  //             //   return data.getHoursDuration() ;
  //             // }
  //             return 0; // Default case
  //           },
  //           width: 0.2,
  //           color: barColor,
  //           name: 'Total Marks',
  //           // gradient: LinearGradient(colors: Colors.primaries, tileMode: TileMode.clamp/*, transform: GradientRotation(10)*/),
  //           dataLabelSettings: DataLabelSettings(
  //               isVisible: true,
  //               color: labelColor,
  //               textStyle: TextStyle(color: Colors.white, fontSize: 10)),
  //           legendIconType: LegendIconType.circle,
  //           legendItemText: legendItemText,
  //           enableTooltip: true,
  //         ),
  //       ]);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Procedure Dashboard'),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize:
            Size.fromHeight(1.0), // Set the height of the divider
            child:
            Divider(color: Colors.grey), // Divider below the app bar title
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  Container(
                    width: 550,
                    height: 550,
                    child: dataMap.isNotEmpty
                        ? PieChart(
                      dataMap: dataMap,
                      chartType: ChartType.disc,
                      centerText: "Surgery Type Percentage",
                      baseChartColor: Colors.grey[300]!,
                    )
                        : Center(
                      child: Text(
                        'No data available',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  // SizedBox(height: 30),
                  // Row(children: [
                  //   Expanded(
                  //     //width: 500,
                  //     child: _buildBarChart(avgSurgeryDurationData, 'Doctor',
                  //         'Average Surgery Time (hours)'),
                  //   ),
                  // ]),
                ],
              )),
        ));
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedFromDate,
      firstDate: DateTime(
          1947), // Adjust the first and last date according to your needs1
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
      firstDate: DateTime(1947),
      // Adjust the first and last date according to your needs1
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedToDate) {
      setState(() {
        selectedToDate = picked;
        String date = "${selectedToDate.toLocal()}".split(' ')[0];
        toDateController?.text = date;
      });
    }
  }
}

// class SurgeryData {
//   final String departmentName;
//   final String surgeryCount;
//
//   SurgeryData({required this.departmentName, required this.surgeryCount});
//
//   factory SurgeryData.fromJson(Map<String, dynamic> json) {
//     return SurgeryData(
//       departmentName: json.keys.first.toString(),
//       surgeryCount: json.values.first.toString() ?? '',
//     );
//   }
// }


