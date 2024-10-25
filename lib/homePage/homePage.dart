import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_to_do_list/bloc/to_do_bloc.dart';
import 'package:project_to_do_list/main.dart';
import 'package:project_to_do_list/screens/TaskData.dart';

class Homepage extends StatefulWidget {
  static var titlecontroller;
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  static TextEditingController titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do-List App"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                label: Text("Title"),
              ),
              controller: titleController,
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.read<ToDoBloc>().add(
                      AddData(titleController.text),
                    );
                titleController.clear();
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  Taskdata()),
          );
        },
        child: Text("ToDo"),
      ),
    );
  }
}
