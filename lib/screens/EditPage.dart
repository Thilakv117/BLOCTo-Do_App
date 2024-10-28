import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_to_do_list/bloc/to_do_bloc.dart';
import 'package:project_to_do_list/homePage/homePage.dart';
import 'package:project_to_do_list/screens/TaskData.dart';

class Editpage extends StatefulWidget {
  final String ids;
  
  final String title;
  const Editpage({Key? key, required this.ids, required this.title}): super(key: key);

  @override
  State<Editpage> createState() => _EditpageState();
}

class _EditpageState extends State<Editpage> {
  TextEditingController titleController = TextEditingController();
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
              controller: titleController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                label: Text(widget.title),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context
                    .read<ToDoBloc>()
                    .add(EditData(id: widget.ids, title: titleController.text));
                titleController.clear();
                Navigator.pop(context, true);
              },
              child: Text("Edit"),
            ),
          ],
        ),
      ),
    );
  }
}
