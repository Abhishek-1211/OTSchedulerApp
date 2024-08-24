import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {

  static const int myToolbarHeight = 70;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      //toolbarHeight: myToolbarHeight.toDouble(),
      title: const Text('OT Tracker',style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),),
      //centerTitle: true,
      actions: [
        IconButton(icon: Icon(Icons.dashboard), onPressed: () {}),
        TextButton(onPressed: () {}, child: Text("Dashboard", style: TextStyle(fontSize: 16, color: Colors.black))),
        IconButton(icon: Icon(Icons.list), onPressed: () {}),
        TextButton(onPressed: () {}, child: Text("Patient List", style: TextStyle(fontSize: 16, color: Colors.black))),
        IconButton(icon: Icon(Icons.schedule_outlined), onPressed: () {}),
        TextButton(onPressed: () {}, child: Text("Scheduler", style: TextStyle(fontSize: 16, color: Colors.black))),
        IconButton(icon: Icon(Icons.settings), onPressed: () {}),
        TextButton(onPressed: () {}, child: Text("Settings", style: TextStyle(fontSize: 16, color: Colors.black))),

        //IconButton(icon: Icon(Icons.info_outline), onPressed: () {}),
      ],
      backgroundColor: Colors.grey[100],
      // bottom:  PreferredSize(
      //   preferredSize: Size.fromHeight(1.0),
      //   // Set the height of the divider
      //   child: Divider(
      //     thickness: 2,
      //       color: Colors.blue.shade50), // Divider below the app bar title
      // ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(myToolbarHeight as double);

}