User
for the below code i am getting correct output
import 'package:flutter/material.dart';

class OTScheduleListScreen extends StatefulWidget {
  final Map<String, dynamic> scheduleData;

  const OTScheduleListScreen({Key? key, required this.scheduleData}) : super(key: key);

  @override
  _OTScheduleListScreenState createState() => _OTScheduleListScreenState();
}

class _OTScheduleListScreenState extends State<OTScheduleListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OT Schedule'),
      ),
      body: ListView.builder(
        itemCount: widget.scheduleData['OT'].length,
        itemBuilder: (context, index) {
          final otNumber = widget.scheduleData['OT'][index.toString()];
          print('otNumber: $otNumber');

          if (otNumber != null) {
            final String doctor = widget.scheduleData['Doctor'][index.toString()];
            final String surgery = widget.scheduleData['surgery'][index.toString()];
            final String startTime = widget.scheduleData['Start_time'][index.toString()];
            final String endTime = widget.scheduleData['End_time'][index.toString()];

            return Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                title: Text('OT $otNumber'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Doctor: $doctor'),
                    Text('Surgery: $surgery'),
                    Text('Start Time: $startTime'),
                    Text('End Time: $endTime'),
                  ],
                ),
              ),
            );
          } else {
            // Return an empty SizedBox to skip this item
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}