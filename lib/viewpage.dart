import 'package:flutter/material.dart';
import 'package:newproject/sqflite_details/DbHelper.dart';
import 'package:newproject/first.dart';
import 'package:newproject/insertpage.dart';
import 'package:sqflite/sqflite.dart';

class viewpage extends StatefulWidget {
  const viewpage({Key? key}) : super(key: key);

  @override
  State<viewpage> createState() => _viewpageState();
}

class _viewpageState extends State<viewpage> {
  Database? db;

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future<List<Map<String, Object?>>> getdata() async {
    db = await DbHelper().createDataBase();
    String qry = "select * from Test";
    List<Map<String, Object?>> l1 = await db!.rawQuery(qry);
    return l1;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return insertpage();
                },
              ));
            },
            child: Icon(Icons.add),
          ),
          appBar: AppBar(
            title: Text("ViewData"),
            centerTitle: true,
          ),
          body: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<Map<String, Object?>> l =
                      snapshot.data as List<Map<String, Object?>>;
                  return l.length > 0
                      ? ListView.builder(
                          itemCount: l.length,
                          itemBuilder: (context, index) {
                            Map m = l[index];
                            return Card(
                              child: ListTile(
                                  onTap: () {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                      return insertpage(m: m);
                                    },));
                                  },
                                  trailing: IconButton(
                                      onPressed: () {
                                        showDialog(
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text("Delete"),
                                                content: Text(
                                                    "Are You Sure Want To Delete '${m['name']}'?"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Cancle",style: TextStyle(fontSize: 15),)),
                                                  TextButton(
                                                      onPressed: () async {
                                                        Navigator.pop(context);

                                                        int id =m['id'];
                                                        String qry ="delete from Test where id = $id";

                                                        await db!.rawDelete(qry);

                                                        setState(() {});


                                                      },
                                                      child: Text(
                                                        "Delete",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.red),
                                                      ))
                                                ],
                                              );
                                            },
                                            context: context);
                                      },
                                      icon: Icon(Icons.delete)),
                                  leading:
                                      CircleAvatar(child: Text("${m['id']}")),
                                  title: Text("Name : ${m['name']}"),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("email : ${m['email']}"),
                                      Text("password : ******"),
                                      Text("contact : ${m['contact']}"),
                                      Text("hobby : ${m['hobby']}"),
                                      Text("gender : ${m['gender']}"),
                                    ],
                                  )),
                            );
                          },
                        )
                      : Center(
                          child: Text("No data found"),
                        );
                }
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
            future: getdata(),
          ),
        ),
        onWillPop: back);
  }

  Future<bool> back() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return first();
      },
    ));
    return Future.value();
  }
}
