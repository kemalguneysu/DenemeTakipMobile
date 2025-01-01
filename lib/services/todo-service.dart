import 'dart:convert';

import 'package:mobil_denemetakip/constants/index.dart';
import 'package:mobil_denemetakip/constants/toast.dart';
import 'package:mobil_denemetakip/services/fetchWithAuth.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class DeleteToDoElementRequest {
  final String toDoId;

  DeleteToDoElementRequest({
    required this.toDoId,
  });
  Map<String, dynamic> toJson() {
    return {
      'toDoId': toDoId,
    };
  }
}
class UpdateToDoElementRequest {
  final String toDoId;
  final String? toDoTitle;
  final bool? isCompleted;

  UpdateToDoElementRequest({
    required this.toDoId,
    required this.toDoTitle,
    required this.isCompleted,
  });
  Map<String, dynamic> toJson() {
    return {
      'toDoId': toDoId,
      'toDoTitle': toDoTitle,
      'isCompleted': isCompleted,
    };
  }
}

class TodoService {
  final String apiBaseUrl = 'https://api.denemetakip.com/api';
  final fetchWithAuth = FetchWithAuth();

  Future<List<dynamic>> getTodayToDos({
    Function()? successCallBack,
    Function(String errorMessage)? errorCallBack,
  }) async {
    try {
      final response = await fetchWithAuth.fetchWithAuth('$apiBaseUrl/HomePage/GetTodayToDos',
          method: 'GET',
          headers: {
            'Content-Type': 'application/json',
          });

        if (successCallBack != null) {
          successCallBack();
        }  
        return jsonDecode(response.body);

    } catch (error) {
      if (errorCallBack != null) {
        errorCallBack(error.toString());
      }
      return [];
    }
  }

  Future<void> createToDo(ToDoElementCreate todo, {
  Function? successCallback,
}) async {
  try {
    final response = await fetchWithAuth.fetchWithAuth(
      '$apiBaseUrl/ToDoElement/CreateToDoElement',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: todo.toJson(),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (successCallback != null) {
        successCallback();
      }
    } else {
    }
  } catch (error) {
    throw error;
  }
}
  Future<void> deleteToDoElement(DeleteToDoElementRequest request, {Function? successCallback}) async {

    try {

      final response = await fetchWithAuth.fetchWithAuth(
        '$apiBaseUrl/ToDoElement/DeleteToDoElement',
        method: "DELETE",
        headers: {
          'Content-Type': 'application/json',
        },
        body: request.toJson(), // JSON verisini body olarak gönder
      );

      if (response.statusCode == 200) {
        // Success callback if provided
        if (successCallback != null) {
          successCallback();
        }
      } else {
        // Handle error if status code is not 200
        throw Exception('Failed to delete ToDoElement');
      }
    } catch (error) {
      rethrow;
    }
  }
  Future<void> updateToDoElement(UpdateToDoElementRequest request,{Function? successCallback}) async {
    try {
      final response = await fetchWithAuth.fetchWithAuth(
        '$apiBaseUrl/ToDoElement/UpdateToDoElement',
        headers: {
          'Content-Type': 'application/json',
        },
        method: 'POST',
        body: request.toJson(),
      );

      if (response.statusCode == 200) {
        if (successCallback != null) {
          successCallback();
        }
      } else {
        throw Exception('Yapılacak hedef güncellenirken hata oluştu.');
      }
    } catch (error) {
      throw error; 
    }
  }
  Future<Map<String, dynamic>> getToDoElements(
    DateTime toDoDateStart,
    DateTime toDoDateEnd, {
    bool? isCompleted,
    Function? successCallBack,
    Function(String)? errorCallBack,
  }) async {
    String queryString = "";

    queryString +=
        "ToDoDateStart=${Uri.encodeComponent(toDoDateStart.toIso8601String())}";
    queryString +=
        "&ToDoDateEnd=${Uri.encodeComponent(toDoDateEnd.toIso8601String())}";

    // isCompleted parametresi varsa, ekleyin
    if (isCompleted != null) {
      queryString += "&IsCompleted=$isCompleted";
    }

    try {
      final response = await fetchWithAuth.fetchWithAuth(
        '$apiBaseUrl/ToDoElement/GetToDoElement?$queryString',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (successCallBack != null) {
          successCallBack();
        }

        return {
          'totalCount': data['totalCount'],
          'toDoElements': data['toDoElements'], 
        };
      } else {
        throw Exception('Yapılacak hedefler alınırken hata oluştu.');
      }
    } catch (error) {
      if (errorCallBack != null) {
        errorCallBack(error.toString());
      }
      return {'totalCount': 0, 'toDoElements': []};
    }
  }

}