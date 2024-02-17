import 'package:flutter/material.dart';
import 'package:todo_list_app/services/todo_service.dart';
import 'package:todo_list_app/utils/snackbar_helper.dart';
import 'package:intl/intl.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
    this.todo,
  });
  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

//create dateline and timeline variable

  // DateTime dateTime = DateTime.now();
  //TimeOfDay timeOfDay = TimeOfDay(hour: 8, minute: 30);

//show date picker method
  // void _showDatePiker() {
  //   showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2030),
  //   ).then((value) {
  //     setState(() {
  //       dateTime = value!;
  //     });
  //   });
  // }

//-------------------------------------------------

  //trail decleration

  DateTime? selectedDate;

  void _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );   if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  TimeOfDay? selectedTime;

  void _showTimePicker() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }
//-------------------------------------------------
//show date picker method
  // void _showTimePicker() {
  //   showTimePicker(context: context, initialTime: TimeOfDay.now())
  //       .then((value) {
  //     setState(() {
  //       timeOfDay = value!;
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
      // -------------------------------------
      selectedDate = todo['dueDate'];
      selectedTime = todo['dueTime'];
      //---------------------------------------
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(hintText: 'Description'),
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 8,
            ),
            const SizedBox(
              height: 20,
            ),
            //display the choosen date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Text(
                //   //_dateTime.toString(),
                //   DateFormat.yMMMd().format(context).toString(),
                //   style: TextStyle(fontSize: 15),
                // ),
                // Text(
                //   selectedTime.format(context).toString(),
                //   style: TextStyle(fontSize: 15),
                // ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: _showDatePicker,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Add a Date',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: _showTimePicker,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Pick Time',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(isEdit ? 'update' : 'Submit'),
              ),
            ),
          ],
        ));
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print('you can not call updated without todo data');
      return;
    }
    final id = todo['_id'];
    //submit updated data to the server
    final isSuccess = await TodoService.updateTodo(id, body);
    if (isSuccess) {
      showSuccessMessage(context, message: 'updation Success');
    } else {
      showErrorMessage(context, message: 'updation Failed');
    }
  }

  Future<void> submitData() async {
    //submit data to the server
    final isSuccess = await TodoService.AddTodo(body);
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message: 'creation Success');
    } else {
      showErrorMessage(context, message: 'Creation Failed');
    }
  }

  Map get body {
    //get the data from form
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
