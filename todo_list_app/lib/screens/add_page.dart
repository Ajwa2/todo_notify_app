import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:todo_list_app/services/todo_service.dart';
import 'package:todo_list_app/utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    Key? key,
    this.todo,
  }) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
     // final scheduled_for = todo['scheduled_for'];
      titleController.text = title;
      descriptionController.text = description;
      //timeController.text = scheduled_for;
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
              onChanged: (value) => enforceWordLimit(value, titleController),
            ),
            const SizedBox(height: 20),
            TextField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: 'Description'),
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: 8,
                onChanged: (value) =>
                    enforceWordLimit2(value, descriptionController)),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(hintText: "Schedule a time"),
            ),
            //display the choosen date
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Text(
            //       //_dateTime.toString(),
            //       //DateFormat.yMMMd().format(selectedDate!).toString(),
            //       created_at != null
            //           ? DateFormat.yMMMd().format(created_at!).toString()
            //           : '',
            //       style: TextStyle(fontSize: 15),
            //     ),
            //     Text(
            //       //selectedTime!.format(context).toString(),
            //       selectedTime != null
            //           ? selectedTime!.format(context).toString()
            //           : '',
            //       style: TextStyle(fontSize: 15),
            //     ),
            //   ],
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     MaterialButton(
            //       onPressed: _showDatePicker,
            //       child: const Padding(
            //         padding: EdgeInsets.all(8.0),
            //         child: Text(
            //           'Add a Date',
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 15,
            //           ),
            //         ),
            //       ),
            //     ),
            //     MaterialButton(
            //       onPressed: _showTimePicker,
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Text(
            //           'Pick Time',
            //           style: TextStyle(color: Colors.white, fontSize: 15),
            //         ),
            //       ),
            //     )
            //   ],
            // ),
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

  // void _showDatePicker() async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: created_at ?? DateTime.now(),
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(2100),
  //   );
  //   if (pickedDate != null) {
  //     setState(() {
  //       created_at = pickedDate;
  //     });
  //   }
  // }

  // void _showTimePicker() async {
  //   final TimeOfDay? pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: selectedTime ?? TimeOfDay.now(),
  //   );
  //   if (pickedTime != null && pickedTime != selectedTime) {
  //     setState(() {
  //       selectedTime = pickedTime;
  //     });
  //   }
  // }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print('you cannot call updated without todo data');
      return;
    }
    final id = todo['_id'];
    //submit updated data to the server
    final isSuccess = await TodoService.updateTodo(id, body);
    if (isSuccess) {
      showSuccessMessage(context, message: 'updation Success');
      Navigator.pop(context);
    } else {
      showErrorMessage(context, message: 'updation Failed');
    }
  }

  Future<void> submitData() async {
    print("before");
    print(body);
    //submit data to the server
    final isSuccess = await TodoService.AddTodo(body);
    print("after");
    print(body);
    if (isSuccess) {
      //after submitting the data make the textfield of the title and description none or erase what id written
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message: 'creation Success');
      Navigator.pop(context);
    } else {
      showErrorMessage(context, message: 'Creation Failed');
    }
  }

  Map<String, dynamic> get body {
    //get the data from
    final title = titleController.text;
    final description = descriptionController.text;
    final scheduled_for = DateTime.now().toIso8601String();
    return {
      "title": title,
      "description": description,
      "is_completed": false,
      "scheduled_for": scheduled_for,
    };
  }
}

void enforceWordLimit(String value, TextEditingController controller) {
  List<String> words = value.trim().split(' ');
  if (words.length > 5) {
    controller.text = words.take(5).join(' ');
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));
  }
}

void enforceWordLimit2(String value, TextEditingController controller) {
  List<String> words = value.trim().split(' ');
  if (words.length > 50) {
    controller.text = words.take(50).join(' ');
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));
  }
}
