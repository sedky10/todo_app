import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/helper.dart';

import 'package:todo_app/todo.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

List<Todo> todoList = [];

class _HomeState extends State<Home> {
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff324e9b),
      appBar: AppBar(
        backgroundColor: const Color(0xff324e9b),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Tasker',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      drawer: const Drawer(
        child: Icon(
          Icons.menu,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              color: const Color(0xff324e9b),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      textBaseline: TextBaseline.ideographic,
                      children: [
                        Text(
                          DateTime.now().day.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 60,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          '${DateFormat('MMM').format(date)} ${DateTime.now().year.toString()}',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ],
                    ),
                    Text(
                      DateFormat('EEEE').format(date),
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: FutureBuilder<List<Todo>>(
              future: Helper.instance.getAllTodo(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                if (snapshot.hasData) {
                  todoList = snapshot.data!;
                  return ListView.builder(
                    itemCount: todoList.length,
                    itemBuilder: (context, index) {
                      Todo todo = todoList[index];
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff051853),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            leading: Transform.scale(
                              scale: 1.5,
                              child: Checkbox(
                                shape: const CircleBorder(),
                                fillColor: MaterialStateProperty.all(
                                    const Color(0xff324e9b)),
                                overlayColor: MaterialStateProperty.all(
                                    const Color(0xff324e9b)),
                                value: todo.isChecked,
                                onChanged: (bool? value) {
                                  setState(
                                    () {
                                      todoList[index].isChecked = value!;
                                      Helper.instance.updateTodo(todo);
                                    },
                                  );
                                },
                              ),
                            ),
                            title: Text(
                              todo.name,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            subtitle: Text(
                              DateTime.fromMillisecondsSinceEpoch(todo.date)
                                  .toString(),
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                if (todo.id != null) {
                                  Helper.instance.deleteTodo(todo.id!);
                                }
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Color(0xff324e9b),
                              ),
                              iconSize: 40,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffdf04ec),
        child: const Icon(
          Icons.add,
          size: 40,
        ),
        onPressed: () async {
          await showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            builder: (BuildContext context) {
              return const BottomSheet();
            },
          );
        },
      ),
    );
  }
}

class BottomSheet extends StatefulWidget {
  const BottomSheet({Key? key}) : super(key: key);

  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  DateTime? selecteddate;
  TextEditingController taskcontroler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Color(0xff324e9b),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: taskcontroler,
                decoration: InputDecoration(
                  hintText: 'task name',
                  hintStyle: Theme.of(context).textTheme.headline4,
                ),
                onChanged: (val) {
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        selecteddate = (await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 30),
                          ),
                        ))!;
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.date_range_outlined,
                        color: Colors.blue,
                      )),
                  Text(
                    selecteddate != null
                        ? selecteddate.toString()
                        : 'No Date Chosen',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    onPressed: () {
                      Helper.instance.insertTodo(
                        Todo(
                          name: taskcontroler.text,
                          date: selecteddate!.millisecondsSinceEpoch,
                          isChecked: false,
                        ),
                      );
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Save'.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel'.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
