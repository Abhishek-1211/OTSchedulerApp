import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/MenuPage.dart';
import 'package:my_flutter_app/TimeMonitoring/PatientListScreen.dart';
import 'package:my_flutter_app/OTSchedule/OTScheduleScreen.dart';
import 'package:my_flutter_app/register.dart';
import 'package:http/http.dart' as http;


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String baseUrl = 'http://127.0.0.1:8000/api';
  bool _passwordVisible = false;


  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[

            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(150, 10, 150, 0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.jpeg', // Path to your logo image asset
                    width: 180, // Adjust the width as needed
                    height: 180, // Adjust the height as needed
                  ),
                  const SizedBox(height: 10), // Add spacing between logo and text
                  const Text(
                    'AMRITA  OT-SCHEDULER',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(150, 10, 150, 0),
                child: const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.fromLTRB(150, 60, 150, 0),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'email',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(150, 30, 150, 0),
              child: TextField(
                obscureText: !_passwordVisible,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(150, 10, 150, 10),
              child: TextButton(
                onPressed: () {
                  //forgot password screen
                },
                child: const Text('Forgot Password',
                  style: TextStyle(
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

            Container(
                height: 50,
                //width: 25,
                padding: const EdgeInsets.fromLTRB(150, 0, 150, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlueAccent,
                  textStyle: TextStyle(color: Colors.white)),
                  child: const Text('Login',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),),
                  onPressed: () async {

                    String user_type = await _validateuser(nameController.text, passwordController.text);
                    // String username = nameController.text.trim();
                    //
                    // // Check for specific usernames
                    print(user_type);
                    if (user_type == 'Nurse' || user_type == 'Technician') {
                      // Navigate to OTScheduleScreen if the username matches
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PatientListScreen()),
                      );

                    } else if (user_type == 'Scheduler' || user_type == 'Administration') {
                      // Navigate to PatientListScreen for other usernames
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MenuPage()),
                      );
                    }

                  },
                )
            ),
            Row(
              children: <Widget>[
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 20,decoration: TextDecoration.underline),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Register(),
                      ),
                    );
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ));
  }

  Future<String> _validateuser(String email, String password) async {
    String apiUrl = '$baseUrl/login/';
    String user_type ='';

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'password': password,
          'email': email,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('login successful!');
        print('response_login(): ${response.body}');
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print('jsonResponse(): ${jsonResponse}');
        if(jsonResponse.containsKey('user')){
          print(jsonResponse['user'].runtimeType);
          user_type = jsonResponse['user']['user_type'];
        }
      }
      else{
        print('login failed. Status code: ${response.statusCode}');
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Please enter valid credentials'),
            //content: const Text('Thank you!!!Your inputs have been recorded successfully'),
            actions: <Widget>[TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Disable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),],
          );
        });
      }
      //return user_type;
    }
    catch (e){
      print('Error sending request: $e');
    }
    return user_type;
  }
}
