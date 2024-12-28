import 'dart:math';

import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobil_denemetakip/constants/index.dart';
import 'package:mobil_denemetakip/constants/spinner.dart';
import 'package:mobil_denemetakip/services/todo-service.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class TodayToDo extends StatefulWidget {
  @override
  _TodayToDoState createState() => _TodayToDoState();
}

class _TodayToDoState extends State<TodayToDo> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<List<ToDoElements>> todayToDo =
      ValueNotifier<List<ToDoElements>>([]);
  final toDoService = TodoService();
  Map<String, bool> isEditingMap = {};
  Map<String, TextEditingController> textControllers = {};

  Future<void> fetchTodayToDo() async {
    isLoading.value = true;
    try {
      final result = await toDoService.getTodayToDos();
      todayToDo.value = (result.isNotEmpty &&
              result[0]['toDoElements'] != null &&
              (result[0]['toDoElements'] as List).isNotEmpty)
          ? (result[0]['toDoElements'] as List)
              .map(
                  (item) => ToDoElements.fromJson(item as Map<String, dynamic>))
              .toList()
          : [];
    } catch (error) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addAction() async {
    DateTime timeInTurkey = DateTime.now().toUtc();
    final todo = ToDoElementCreate(
        toDoElementTitle: "Yeni Hedef",
        toDoDate: timeInTurkey,
        isCompleted: false);
    await toDoService.createToDo(todo, successCallback: () async {
      await fetchTodayToDo();
    });
  }

  Future<void> deleteToDo(String todoId) async {
    final request = DeleteToDoElementRequest(toDoId: todoId);
    await toDoService.deleteToDoElement(request);
    fetchTodayToDo();
  }

  Future<void> updateToDo(
      String todoId, String? toDoTitle, bool? isCompleted) async {
    final request = UpdateToDoElementRequest(
        toDoId: todoId, toDoTitle: toDoTitle, isCompleted: isCompleted);
    await toDoService.updateToDoElement(request, successCallback: () async {
      await fetchTodayToDo();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTodayToDo();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: isLoading,
        builder: (BuildContext context, isLoadingInside, _) {
          if (isLoadingInside) {
            return SpinnerWidget();
          } else {
            return Container(
              margin: EdgeInsets.only(top: 24),
              width: double.infinity,
              child: Card(
                  borderColor: Theme.of(context).colorScheme.border,
                  borderWidth: 1,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text("Bugünün Hedefleri",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700)),
                              Text(
                                DateFormat('d MMMM yyyy', 'tr')
                                    .format(DateTime.now()),
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                  DateFormat('EEEE', 'tr')
                                      .format(DateTime.now()),
                                  style: TextStyle(fontSize: 14))
                            ],
                          ),
                        ),
                        Container(
                          child: ValueListenableBuilder<List<ToDoElements>>(
                            valueListenable: todayToDo,
                            builder: (context, toDoList, child) {
                              if (toDoList.length == 0) {
                                return Container(
                                  margin: EdgeInsets.only(top: 16),
                                  child: Text(
                                    "Bugünlük hedef yok.",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                );
                              } else {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: min(300, toDoList.length * 100),
                                      child: ListView.builder(
                                        itemCount: toDoList.length,
                                        itemBuilder: (context, index) {
                                          final toDoItem = toDoList[index];
                                          final isEditing =
                                              isEditingMap[toDoItem.id] ??
                                                  false;
                                          final controller =
                                              textControllers.putIfAbsent(
                                                  toDoItem.id,
                                                  () => TextEditingController(
                                                      text: toDoItem
                                                          .toDoElementTitle));
                                          return Container(
                                            margin: EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .border),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        isEditingMap[
                                                            toDoItem.id] = true;
                                                      });
                                                    },
                                                    child: isEditing
                                                        ? TextField(
                                                            autofocus: true,
                                                            initialValue:
                                                                controller.text,
                                                            controller:
                                                                controller,
                                                            onSubmitted:
                                                                (value) {
                                                              updateToDo(
                                                                  toDoItem.id,
                                                                  value,
                                                                  toDoItem
                                                                      .isCompleted);
                                                              isEditingMap[
                                                                      toDoItem
                                                                          .id] =
                                                                  !(isEditingMap[
                                                                          toDoItem
                                                                              .id] ??
                                                                      false);
                                                            },
                                                          )
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        16.0),
                                                            child: Text(
                                                              toDoItem
                                                                  .toDoElementTitle,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0),
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Checkbox(
                                                        state:
                                                            toDoItem.isCompleted
                                                                ? CheckboxState
                                                                    .checked
                                                                : CheckboxState
                                                                    .unchecked,
                                                        onChanged: (value) {
                                                          final isCompleted =
                                                              value ==
                                                                      CheckboxState
                                                                          .checked
                                                                  ? true
                                                                  : false;
                                                          updateToDo(
                                                              toDoItem.id,
                                                              toDoItem
                                                                  .toDoElementTitle,
                                                              isCompleted);
                                                        }),
                                                    GhostButton(
                                                      child: (isEditingMap[
                                                                  toDoItem
                                                                      .id] ??
                                                              false)
                                                          ? Icon(LucideIcons.save)
                                                          : Icon(LucideIcons
                                                              .pencil),
                                                      onPressed: () {
                                                        if (isEditingMap[
                                                                toDoItem.id] ==
                                                            true) {
                                                          if (toDoItem
                                                                  .toDoElementTitle !=
                                                              controller.text) {
                                                            updateToDo(
                                                                toDoItem.id,
                                                                controller.text,
                                                                toDoItem
                                                                    .isCompleted);
                                                          }
                                                        }
                                                        isEditingMap[
                                                                toDoItem.id] =
                                                            !(isEditingMap[
                                                                    toDoItem
                                                                        .id] ??
                                                                false);
                                                        todayToDo
                                                            .notifyListeners();
                                                      },
                                                    ),
                                                    GhostButton(
                                                      child: Icon(
                                                          LucideIcons.trash2),
                                                      onPressed: () {
                                                        deleteToDo(toDoItem.id);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          width: double.infinity,
                          child: PrimaryButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Hedef Ekle",
                                    style: TextStyle(fontSize: 14)),
                                SizedBox(width: 4),
                                Icon(LucideIcons.plus, size: 16),
                              ],
                            ),
                            onPressed: () {
                              addAction();
                            },
                          ),
                        )
                      ],
                    ),
                  )).intrinsic(),
            );
          }
        });
  }
}
