import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_to_do_list/bloc/to_do_bloc.dart';
import 'package:project_to_do_list/homePage/homePage.dart';
import 'package:project_to_do_list/models/http_model.dart';
import 'package:project_to_do_list/screens/EditPage.dart';

class Taskdata extends StatefulWidget {
   Taskdata({Key? key}) : super(key: key);

  @override
  State<Taskdata> createState() => _TaskdataState();
}

class _TaskdataState extends State<Taskdata> {
  List<ToDoModel> lists = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task List"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: BlocBuilder<ToDoBloc, ToDoState>(
          builder: (context, state) {
            if (state is ToDoLoaded) {
              lists = state.model;
              return ListView.builder(
                itemCount: lists.length,
                itemBuilder: (context, index) {
                  final list = lists[index];
                  var id = list.id;

                  return ListTile(
                    leading: Text("${index + 1}"),
                    title: Text(list.title.toString()),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text("Edit"),
                          value: "Edit",
                        ),
                        PopupMenuItem(
                          child: Text("Delete"),
                          value: "Delete",
                        ),
                      ],
                      onSelected: (value) {
                        if (value == "Edit") {
                          //Edit task
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Editpage(
                                ids: list.id.toString(),
                              ),
                            ),
                          );
                          ;
                        } else if (value == "Delete") {
                          context
                              .read<ToDoBloc>()
                              .add(DeleteData(id: id.toString()));
                        }
                      },
                    ),
                  );
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ToDoBloc>()..add(FetchData());
        },
        child: Text("Show"),
      ),
    );
  }
}
