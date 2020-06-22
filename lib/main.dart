import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './TodoModel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<TodoModel>> _getTodoList() async {
    var data = await http.get("https://jsonplaceholder.typicode.com/todos");
    var jsonData = jsonDecode(data.body);
    List<TodoModel> todoList = [];

    for(var todo in jsonData){
      TodoModel todoModel = TodoModel(todo["userId"],todo["id"],todo["title"],todo["completed"]);
      todoList.add(todoModel);
    }

    return todoList;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
      ),
      body: Container(
            child: FutureBuilder(
                future: _getTodoList(),
                builder: (BuildContext context, AsyncSnapshot snapshot){

                  if(snapshot.data == null){
                    return Container(
                      child: Center(
                        child: Text("Loading..."),
                      ),
                    );
                  }
                  else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return  Card(
                          elevation: 10,
                          child: Padding(padding: EdgeInsets.only(top: 8, bottom: 8,left: 10,right: 10),
                          child:Column(
                            children: <Widget>[

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(

                                  child: Text("UserId: ${snapshot.data[index].userId.toString()}"),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(

                                  child: Text("Id: ${snapshot.data[index].id.toString()}"),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(

                                  child: Text("Title: ${snapshot.data[index].title}",maxLines: 1),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(

                                  child: Text("Completed: ${snapshot.data[index].completed.toString()}"),
                                ),
                              ),

                            ],
                          ) ),
                        );
                         // Text(snapshot.data[index].userId.toString());

                      },
                    );
                  }
                },
            ),
      ),
    );
  }
}

