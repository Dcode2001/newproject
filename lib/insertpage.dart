import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newproject/sqflite_details/DbHelper.dart';
import 'package:newproject/viewpage.dart';
import 'package:sqflite/sqflite.dart';

class insertpage extends StatefulWidget {

Map? m;

insertpage({this.m});

  @override
  State<insertpage> createState() => _insertpageState();
}

class _insertpageState extends State<insertpage> {
  Database? db;

  String gvalue = "";
  TextEditingController tname = TextEditingController();
  TextEditingController tcontact = TextEditingController();
  TextEditingController temail = TextEditingController();
  TextEditingController tpass = TextEditingController();
  TextEditingController thobby = TextEditingController();

  @override
  void initState() {
    super.initState();
    DbHelper().createDataBase().then((value) {
      setState(() {
        db = value;
      });
    });

    if(widget.m!=null)
      {
              tname.text = widget.m!['name'];
              temail.text = widget.m!['email'];
              tpass.text = widget.m!['password'];
              tcontact.text = widget.m!['contact'];
              thobby.text = widget.m!['hobby'];
              thobby.text = widget.m!['hobby'];
              gvalue=widget.m!['gender'];
      }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
        appBar: AppBar(
          title: Text("Insert Data"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(
                    "Name",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: tname,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        label: Text("Enter Name")),
                    textCapitalization: TextCapitalization.words,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Email",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: temail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        label: Text("Enter Email")),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Password",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: tpass,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        label: Text("Enter Password")),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Contact",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: tcontact,
                    maxLength: 10,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        label: Text("Enter Contact No.")),
                  ),
                  Text(
                    "Hobby",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: thobby,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),label: Text("Enter Hobby")),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Gender:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio(
                        value: "Male",
                        groupValue: gvalue,
                        onChanged: (value) {
                          setState(() {
                            gvalue = value.toString();
                          });
                        },
                      ),
                      Text("Male",style: TextStyle(fontSize: 16),),
                      Radio(
                        value: "Female",
                        groupValue: gvalue,
                        onChanged: (value) {
                          setState(() {
                            gvalue = value.toString();
                          });
                        },
                      ),
                      Text("Female"),
                      Radio(
                        onChanged: (value) {
                          gvalue = value.toString();
                          setState(() {});
                        },
                        value: "Other",
                        groupValue: gvalue,
                      ),
                      Text("Other"),
                    ],
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                        onPressed: ()  {
                          String name = tname.text;
                          String email = temail.text;
                          String password = tpass.text;
                          String contact = tcontact.text;
                          String hobby = thobby.text;

                         if(widget.m==null)
                           {
                             String qry =
                                 "insert into Test(name,email,password,contact,hobby,gender) values ('$name','$email','$password','$contact','$hobby','$gvalue')";
                             db!.rawInsert(qry);
                             Navigator.pushReplacement(context, MaterialPageRoute(
                               builder: (context) {
                                 return viewpage();
                               },
                             ));
                             Fluttertoast.showToast(
                                 msg: "Save Sucessfully...",
                                 toastLength: Toast.LENGTH_SHORT,
                                 gravity: ToastGravity.CENTER,
                                 timeInSecForIosWeb: 1,
                                 backgroundColor: Colors.black,
                                 textColor: Colors.white,
                                 fontSize: 16.0
                             );
                           }
                         else
                           {
                             int id = widget.m!['id'];
                             String qry =
                                 "update Test set name='$name',email='$email',password='$password',contact='$contact',hobby='$hobby',gender='$gvalue' where id ='$id'";
                             db!.rawUpdate(qry);
                             Navigator.pushReplacement(context, MaterialPageRoute(
                               builder: (context) {
                                 return viewpage();
                               },
                             ));
                             Fluttertoast.showToast(
                                 msg: "Update Sucessfully...",
                                 toastLength: Toast.LENGTH_SHORT,
                                 gravity: ToastGravity.CENTER,
                                 timeInSecForIosWeb: 1,
                                 backgroundColor: Colors.black,
                                 textColor: Colors.white,
                                 fontSize: 16.0
                             );
                           }
                        },
                        child: widget.m==null ? Text("Submit") : Text("Update")),
                  )
                ],
              ),
            ),
          ),
        )), onWillPop: back);
  }
  Future<bool> back()
  {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return viewpage();
      },));
      return Future.value();
  }
}
