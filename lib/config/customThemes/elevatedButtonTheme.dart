import 'package:flutter/material.dart';

class MyElevatedButtonTheme {
  static final elevatedButtonTheme1 = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.cyan[600],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2))),
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      textStyle: TextStyle(fontSize: 16),
    )
  );

  static final elevatedButtonTheme2 = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey[100],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2))),
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        textStyle: TextStyle(fontSize: 16),
      )
  );
}