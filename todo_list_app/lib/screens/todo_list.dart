import 'package:flutter/material.dart';
import 'package:todo_list_app/screens/add_page.dart';
import 'package:todo_list_app/services/todo_service.dart';
import 'package:todo_list_app/utils/snackbar_helper.dart';
import 'package:todo_list_app/widget/todo_card.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(onPressed: navigateToAddPage, icon: Icon(Icons.add))
        ],
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'No Todo Item',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            child: ListView.builder(
                itemCount: items.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  return TodoCard(
                      index: index,
                      item: item,
                      navigateEdit: navigateToEditPage,
                      deleteById: deleteById,
                      selectedDate: selectedDate,
                      selectedTime: selectedTime);
                }),
          ),
        ),
      ),
    );
  }

  Future<void> navigateToEditPage(Map item) async {
    // final route = MaterialPageRoute(
    //   builder: (context) => AddTodoPage(todo: item),
    // );
    // await Navigator.push(context, route);
    // setState(() {
    //   isLoading = true;
    // });

    //..............................
    final result = await Navigator.push(context, 
    MaterialPageRoute(builder: (context) => AddTodoPage(todo: item)));

    if(result!= null && result is Map){
      setState(() {
        selectedDate = result['selectedDate'];
        selectedTime = result['selectedTime'];
        isLoading = true;
      });
    }
    //..............................
    fetchTodo();
  }

  Future<void> navigateToAddPage() async {
    // final route = MaterialPageRoute(builder: (context) => const AddTodoPage());
    // await Navigator.push(context, route);
    // setState(() {
    //   isLoading = true;
    // });
    //..............................
    final result = await Navigator.push(context, 
    MaterialPageRoute(builder: (context) => AddTodoPage()));

    if(result!= null && result is Map){
      setState(() {
        selectedDate = result['selectedDate'];
        selectedTime = result['selectedTime'];
        isLoading = true;
      });
    }
    //..............................
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    final isSuccess = await TodoService.deleteById(id);
    if (isSuccess) {
      //remove item from the list
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
      // fetchTodo();
    } else {
      showErrorMessage(context, message: 'deletion failed');
    }
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodos();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showErrorMessage(context, message: 'something went wrong');
    }
    setState(() {
      isLoading = false;
    });
  }
}
