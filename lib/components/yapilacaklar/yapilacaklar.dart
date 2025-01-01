import 'dart:convert';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobil_denemetakip/constants/index.dart';
import 'package:mobil_denemetakip/services/todo-service.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class Yapilacaklar extends StatefulWidget {
  const Yapilacaklar({super.key});

  @override
  State<Yapilacaklar> createState() => _YapilacaklarState();
}

class _YapilacaklarState extends State<Yapilacaklar> {
  bool _isLoading = false;
  String view = "weekly";
  DateTime today = DateTime.now();
  String currentDateRange = "";
  late DateTime selectedDay;

  List<ListToDoElement> _userToDos = [];
  Map<String, bool> isEditingMap = {};
  Map<String, TextEditingController> textControllers = {};
  ValueNotifier<List<ToDoElements>> todayToDo =
      ValueNotifier<List<ToDoElements>>([]);
  ValueNotifier<List<ToDoElements>> selectedDayToDos =
      ValueNotifier<List<ToDoElements>>([]);

  final todoService = new TodoService();

  @override
  void initState() {
    super.initState();
    updateDateRange();
    getUserToDos(view);
  }

  void updateDateRange() {
    if (view == "weekly") {
      final start = today.subtract(Duration(days: today.weekday - 1));
      final end = start.add(Duration(days: 6));
      setState(() {
        currentDateRange =
            "${DateFormat('d MMM yyyy', 'tr').format(start)} - ${DateFormat('d MMM yyyy', 'tr').format(end)}";
      });
    } else {
      final start = DateTime(today.year, today.month, 1);
      final end = DateTime(today.year, today.month + 1, 0);
      setState(() {
        currentDateRange =
            "${DateFormat('d MMM yyyy', 'tr').format(start)} - ${DateFormat('d MMM yyyy', 'tr').format(end)}";
      });
    }
    getUserToDos(view);
  }

  void handlePreviousTimeframe() {
    DateTime newDate;
    if (view == "weekly") {
      newDate = today.subtract(Duration(days: 7));
    } else {
      newDate = DateTime(today.year, today.month - 1, today.day);
    }
    setState(() {
      today = newDate;
      updateDateRange();
    });
  }

  void handleNextTimeframe() {
    DateTime newDate;
    if (view == "weekly") {
      newDate = today.add(Duration(days: 7));
    } else {
      newDate = DateTime(today.year, today.month + 1, today.day);
    }
    setState(() {
      today = newDate;
      updateDateRange();
    });
  }

  Future<void> getUserToDos(String view, {bool? isCompleted}) async {
    DateTime start;
    DateTime end;

    if (view == "weekly") {
      start = DateTime(today.year, today.month, today.day - today.weekday + 1,
          0, 0, 0, 0, 0);
      end = start.add(Duration(days: 6)).copyWith(
          hour: 23, minute: 59, second: 59, millisecond: 999, microsecond: 999);
    } else {
      start = DateTime(today.year, today.month, 1, 0, 0, 0, 0, 0);
      end = DateTime(today.year, today.month + 1, 0, 23, 59, 59, 999, 999);
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await todoService.getToDoElements(
        start,
        end,
        isCompleted: isCompleted,
        successCallBack: () {
          setState(() {
            _isLoading = false;
          });
        },
        errorCallBack: (errorMessage) {
          setState(() {
            _isLoading = false;
          });
        },
      );
      final List<ListToDoElement> userToDos = response['toDoElements']
          .map<ListToDoElement>((item) => ListToDoElement.fromJson(item))
          .toList();

      setState(() {
        _userToDos = userToDos;
      });
      if (selectedDay != null) {
        selectedDayToDos.value = _userToDos
            .where((element) =>
                element.date.year == selectedDay.year &&
                element.date.month == selectedDay.month &&
                element.date.day == selectedDay.day)
            .expand((element) => element.toDoElements)
            .toList();
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<String> getWeekDays() {
    return ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
  }

  void open(BuildContext context, DateTime selectedDay) {
    selectedDayToDos.value = _userToDos
        .where((element) =>
            element.date.year == selectedDay.year &&
            element.date.month == selectedDay.month &&
            element.date.day == selectedDay.day)
        .expand((element) => element.toDoElements)
        .toList();

    // Drawerda isEditing anlık yenilenmiyor.
    
    openDrawer(
      context: context,
      expands: true,
      builder: (context) {
        return ValueListenableBuilder<List<ToDoElements>>(
            valueListenable: selectedDayToDos,
            builder: (context, todos, child) {
              return Container(
                color: Theme.of(context).colorScheme.background,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    todos.isEmpty
                        ? Container(
                            margin: EdgeInsets.only(top: 16),
                            child: Text(
                              "Bugünlük hedef yok.",
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: 400,
                                child: ListView.builder(
                                  itemCount: todos.length,
                                  itemBuilder: (context, index) {
                                    final toDoItem = todos[index];
                                    final isEditing =
                                        isEditingMap[toDoItem.id] ?? false;
                                    final controller =
                                        textControllers.putIfAbsent(
                                            toDoItem.id,
                                            () => TextEditingController(
                                                text:
                                                    toDoItem.toDoElementTitle));
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isEditingMap[toDoItem.id] =
                                                      true;
                                                      selectedDayToDos
                                                      .notifyListeners();
                                                });
                                              },
                                              child: isEditing
                                                  ? TextField(
                                                      autofocus: true,
                                                      initialValue:
                                                          controller.text,
                                                      controller: controller,
                                                      onSubmitted: (value) {
                                                        updateToDo(
                                                            toDoItem.id,
                                                            value,
                                                            toDoItem
                                                                .isCompleted);
                                                        isEditingMap[
                                                                toDoItem.id] =
                                                            !(isEditingMap[
                                                                    toDoItem
                                                                        .id] ??
                                                                false);
                                                      },
                                                    )
                                                  : Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16.0),
                                                      child: Text(
                                                        toDoItem
                                                            .toDoElementTitle,
                                                        style: TextStyle(
                                                            fontSize: 16.0),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Checkbox(
                                                  state: toDoItem.isCompleted
                                                      ? CheckboxState.checked
                                                      : CheckboxState.unchecked,
                                                  onChanged: (value) {
                                                    final isCompleted = value ==
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
                                                            toDoItem.id] ??
                                                        false)
                                                    ? Icon(LucideIcons.save)
                                                    : Icon(LucideIcons.pencil),
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
                                                          toDoItem.isCompleted);
                                                    }
                                                  }
                                                  isEditingMap[toDoItem.id] =!(isEditingMap[toDoItem.id] ??false);
                                                  selectedDayToDos
                                                      .notifyListeners();
                                                },
                                              ),
                                              GhostButton(
                                                child: Icon(LucideIcons.trash2),
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
                          ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      width: double.infinity,
                      child: PrimaryButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Hedef Ekle", style: TextStyle(fontSize: 14)),
                            SizedBox(width: 4),
                            Icon(LucideIcons.plus, size: 16),
                          ],
                        ),
                        onPressed: () {
                          addAction(selectedDay);
                        },
                      ),
                    )
                  ],
                ),
              );
            });
      },
      position: OverlayPosition.bottom,
    );
  }

  Future<void> addAction(DateTime day) async {
    final currentDate = DateTime.now();
    final adjustedDate = DateTime(
      day.year,
      day.month,
      day.day,
      currentDate.hour,
      currentDate.minute,
      currentDate.second,
    );
    final todo = ToDoElementCreate(
        toDoElementTitle: "Yeni Hedef",
        toDoDate: adjustedDate,
        isCompleted: false);
    await todoService.createToDo(todo, successCallback: () async {
      await getUserToDos(view);
    });
  }

  Future<void> deleteToDo(String todoId) async {
    final request = DeleteToDoElementRequest(toDoId: todoId);
    await todoService.deleteToDoElement(request);
    await getUserToDos(view);
  }

  Future<void> updateToDo(
      String todoId, String? toDoTitle, bool? isCompleted) async {
    final request = UpdateToDoElementRequest(
        toDoId: todoId, toDoTitle: toDoTitle, isCompleted: isCompleted);
    await todoService.updateToDoElement(request, successCallback: () async {
      await getUserToDos(view);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(
        size: 48,
      ));
    }

    List<String> weekDays = getWeekDays();
    List<DateTime?> calendarDays = [];

    if (view == 'weekly') {
      // Haftalık görünüm
      final startOfWeek = DateTime(today.year, today.month, today.day)
          .subtract(Duration(days: today.weekday - 1));
      for (int i = 0; i < 7; i++) {
        calendarDays.add(DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + i,
        ));
      }
    } else {
      // Aylık görünüm
      final firstDayOfMonth = DateTime(today.year, today.month, 1);
      final lastDayOfMonth = DateTime(today.year, today.month + 1, 0);

      // İlk gün öncesi boşluklar (padding)
      int firstWeekday = firstDayOfMonth.weekday;
      for (int i = 1; i < firstWeekday; i++) {
        calendarDays.add(null); // Boş slotlar ekleniyor
      }

      // Ayın tüm günlerini ekle
      for (int day = 1; day <= lastDayOfMonth.day; day++) {
        calendarDays.add(DateTime(
          firstDayOfMonth.year,
          firstDayOfMonth.month,
          day,
        ));
      }

      // Grid'in tamamlanması için sona boşluklar ekle
      while (calendarDays.length % 7 != 0) {
        calendarDays.add(null);
      }
    }

    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: OutlineButton(
                onPressed: () {
                  showDropdown(
                      context: context,
                      builder: (context) {
                        return DropdownMenu(children: [
                          MenuButton(
                            onPressed: (context) {
                              setState(() {
                                view = "weekly";
                                updateDateRange();
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Haftalık Takip',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                                if (view == "weekly")
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Icon(LucideIcons.check, size: 20),
                                  ),
                              ],
                            ),
                          ),
                          MenuButton(
                              onPressed: (context) {
                                setState(() {
                                  view = "monthly";
                                  updateDateRange();
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Aylık Takip',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400)),
                                  if (view == "monthly")
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Icon(
                                        LucideIcons.check,
                                        size: 20,
                                      ),
                                    ),
                                ],
                              )),
                        ]);
                      });
                },
                child:
                    Text(view == "weekly" ? "Haftalık Takip" : "Aylık Takip")),
          ),
          Container(
            child: Row(
              children: [
                IconButton.ghost(
                  icon: Icon(LucideIcons.chevronLeft),
                  onPressed: () {
                    handlePreviousTimeframe();
                  },
                ),
                SizedBox(width: 4),
                Text("$currentDateRange"),
                SizedBox(width: 4),
                IconButton.ghost(
                  icon: Icon(LucideIcons.chevronRight),
                  onPressed: () {
                    handleNextTimeframe();
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: weekDays.map((day) => Text(day)).toList(),
                ),
                GridView.builder(
                  padding: EdgeInsets.only(top: 8),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1.2 ,
                  ),
                  itemCount: calendarDays.length,
                  itemBuilder: (context, index) {
                    final currentDay = calendarDays[index];

                    if (currentDay == null) {
                      return Container(); 
                    }

                    final currentDayToDos = _userToDos
                        .where((element) =>
                            element.date.year == currentDay.year &&
                            element.date.month == currentDay.month &&
                            element.date.day == currentDay.day)
                        .toList();

                    return GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(top: 1),
                        child: PrimaryButton(
                          shape: ButtonShape.circle,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${currentDay.day}",
                                style: TextStyle(fontSize: 14),
                              ),
                              if (currentDayToDos.isNotEmpty)
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.chart1,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          onPressed: () {
                            selectedDay = currentDay;
                            open(context, selectedDay);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
