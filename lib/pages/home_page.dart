import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:final_640710737/helpers/my_list_tile.dart';
import 'package:final_640710737/helpers/my_text_field.dart';
import 'package:flutter/material.dart';

import '../helpers/api_caller.dart';
import '../helpers/dialog_utils.dart';
import '../models/todo_item.dart';

var kBottomBarBackgroundColor = Colors.purple[800];
var kBottomBarForegroundActiveColor = Colors.white;
var kBottomBarForegroundInactiveColor = Colors.white60;
var kSplashColor = Colors.purple[600];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoItem> _todoItems = [];
  TextEditingController urlController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  late Dio dio;

  @override
  void initState() {
    super.initState();
    _loadTodoItems();
    dio = Dio();
  }

  Future<void> _loadTodoItems() async {
    try {
      final data = await ApiCaller().get("web_types");
      // ข้อมูลที่ได้จาก API นี้จะเป็น JSON array ดังนั้นต้องใช้ List รับค่าจาก jsonDecode()
      List list = jsonDecode(data);
      setState(() {
        _todoItems = list.map((e) => TodoItem.fromJson(e)).toList();
      });
    } on Exception catch (e) {
      // showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }

  Future<void> postData(PostData data) async {
    final apiUrl = 'YOUR_API_ENDPOINT'; // Replace this with your API endpoint

    try {
      final response = await dio.post(
        apiUrl,
        data: data.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Post successful
        print('Posted successfully');
      } else {
        // Post failed
        print('Failed to post data: ${response.data}');
      }
    } catch (error) {
      // Handle error
      print('Error posting data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 4, 113, 119),
        centerTitle: true,
        title: const Text(
          'Webby Fondue',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(12.0), // Adjust the height as needed
          child: Text(
            'ระบบรายงานเว็บเลวๆ',
            style: TextStyle(
              fontSize: 15.0, // Adjust the font size as needed
              fontWeight: FontWeight.bold, // Adjust the font weight as needed
              color: Colors.white, // Adjust the color as needed
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        // width: 600,
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  10, 0, 0, 0), // Adjust the value as needed
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 4, 113, 119), // Background color
                ),
                child: Text(
                  'ส่งข้อมูล',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 224, 251, 254),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                  child: Text('*ต้องกรอกข้อมูล', style: textTheme.titleMedium)),
              const SizedBox(height: 8.0),
              MyTextField(
                controller: TextEditingController(), // Example controller
                hintText: 'URL*',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 8.0),
              MyTextField(
                controller: TextEditingController(), // Example controller
                hintText: 'รายละอียด',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20.0),
              Text('ระบุประเภทเว็บเลว*'),
              Expanded(
                child: ListView.builder(
                  itemCount: _todoItems.length,
                  itemBuilder: (context, index) {
                    final item = _todoItems[index];
                    
                    return Card(
                      color: Colors.white,
                      child: ListTile(
                          onTap: () {},
                          leading: Image.network(item.imageUrl),
                          title: Text(item.title),
                          subtitle: Text(item.subtitle)

                          // trailing: Icon(item.completed ? Icons.check : null),
                          ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24.0),

              // ปุ่มทดสอบ POST API
              // ElevatedButton(
              //   onPressed: _handleApiPost,
              //   child: const Text('ส่งข้อมูล'),
              // ),

              const SizedBox(height: 8.0),

              // ปุ่มทดสอบ OK Dialog
              // ElevatedButton(
              //   onPressed: _handleShowDialog,
              //   child: const Text('Show OK Dialog'),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleApiPost() async {
    try {
      final data = await ApiCaller().post(
        "todos",
        params: {
          "userId": 1,
          "title": "ทดสอบๆๆๆๆๆๆๆๆๆๆๆๆๆๆ",
          "completed": true,
        },
      );
      // API นี้จะส่งข้อมูลที่เรา post ไป กลับมาเป็น JSON object ดังนั้นต้องใช้ Map รับค่าจาก jsonDecode()
      Map map = jsonDecode(data);
      String text =
          'ส่งข้อมูลสำเร็จ\n\n - id: ${map['id']} \n - userId: ${map['userId']} \n - title: ${map['title']} \n - completed: ${map['completed']}';
      showOkDialog(context: context, title: "Success", message: text);
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }

  Future<void> _handleShowDialog() async {
    await showOkDialog(
      context: context,
      title: "This is a title",
      message: "This is a message",
    );
  }
}
