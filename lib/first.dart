import 'package:flutter/material.dart';
import 'package:newproject/api_product/loadimage.dart';
import 'package:newproject/viewpage.dart';

class first extends StatefulWidget {
  const first({Key? key}) : super(key: key);

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Button"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            ElevatedButton(onPressed: () {

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return viewpage();
              },));
            }, child: Text("Sqflite")),

            SizedBox(height: 20),

            ElevatedButton(onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return loadimage();
              },));
            }, child: Text("API")),

          ],
        ),
      ),
    );
  }
}
