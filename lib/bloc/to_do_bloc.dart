import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project_to_do_list/homePage/homePage.dart';
import 'package:project_to_do_list/models/TodoBlocModel.dart';
import 'package:project_to_do_list/models/http_model.dart';
import 'package:project_to_do_list/homePage/homePage.dart';

import '../constants/Route_constant.dart';
import '../servises/http_services.dart';

part 'to_do_event.dart';
part 'to_do_state.dart';

class ToDoBloc extends Bloc<ToDoEvent, ToDoState> {
  List<ToDoModel> taskList = [];
  ToDoBloc() : super(ToDoInitial()) {
    on<FetchData>((event, emit) async {
      taskList = await getList();
      emit(ToDoLoaded(model: taskList));
    });
    on<AddData>((event, emit) async {
      taskList = await Addtask(title: event.title);
      emit(ToDoLoaded(model: taskList));
    });
    on<DeleteData>((event, emit) async {
      await delete(id: event.id);
      List<ToDoModel> updatedList = await getList();
      emit(
        ToDoLoaded(model: updatedList),
      );
    });
    on<EditData>((event, emit) async {
      await updateList(id: event.id, title: event.title);
      List<ToDoModel> updatedLists = await getList();
      emit(ToDoLoaded(model: updatedLists));
    });
  }
  Future<List<ToDoModel>> getList() async {
    var response = await HttpService.httpGet(RouteConstants.taskList);
    var responseJson = json.decode(response.body);
    print(responseJson.runtimeType);
    Iterable list = responseJson;
    List<ToDoModel> taskList =
        list.map((data) => ToDoModel.fromJson(data)).toList();
    return taskList;
  }

  Future<List<ToDoModel>> Addtask({required String title}) async {
    String url = "${RouteConstants.taskCreate}";
    var params = {"title": title};
    var response =
        await HttpService.httpPost(url: url, params: json.encode(params));
    var responseJson = json.decode(response.body);
    ToDoModel task = ToDoModel.fromJson(responseJson);
    taskList.add(task);
    return taskList ?? [];
  }

  Future<List<ToDoModel>> delete({required String id}) async {
    String url = "${RouteConstants.taskDelete}$id";

    var response = await HttpService.httpGet(
      url,
    );

    taskList.removeWhere((element) => element.id.toString() == id.toString());

    return taskList;
  }

  Future<List<ToDoModel>> updateList(
      {required String id, required String title}) async {
    String url = "${RouteConstants.taskUpdate}$id/";

    var params = {
      "id": id.toString(),
      "title": title,
    };
    var response =
        await HttpService.httpPost(url: url, params: json.encode(params));

    if (response.statusCode == 200) {
      for (int i = 0; i < taskList.length; i++) {
        if (taskList[i].id.toString() == id.toString()) {
          taskList[i].title = title;
          break;
        }
      }
      return taskList;
    } else {
      throw Exception();
    }
  }
}
