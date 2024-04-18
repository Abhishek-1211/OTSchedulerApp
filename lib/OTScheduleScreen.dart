import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/OTScheduleListScreen.dart';

class OTScheduleScreen extends StatefulWidget {
  @override
  _OTScheduleScreenState createState() => _OTScheduleScreenState();
}

class _OTScheduleScreenState extends State<OTScheduleScreen> {
  File? _file;
  Uint8List? _webFile;
  String _notificationMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'OT Schedule',
          style: TextStyle(fontSize: 24),
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
                    Icon(Icons.upload_file, size: 50),
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
    try {
      List<int> fileBytes = _file != null ? await _file!.readAsBytes() : _webFile!;
      String base64File = base64Encode(fileBytes);
      print(base64File);

      String apiUrl = 'https://us-central1-amrita-body-scan.cloudfunctions.net/OT_Scheduler';
      Map<String, dynamic> requestBody = {'doc': base64File};
      String requestBodyJson = jsonEncode(requestBody);

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: requestBodyJson,
      );

      //print('Response body: ${response.body}'); // Add this line

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTScheduleListScreen(scheduleData: jsonResponse),
          ),
        );
        print(jsonResponse);
      } else {
        print('Error-1: ${response.statusCode}');
        print('Response body-1: ${response.body}');
      }
    } catch (e) {
      print('Error-2: $e');
    }
  }

}
