import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:intl/intl.dart';

class TodoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateEdit;
  final Function(String) deleteById;
  // final DateTime? selectedDate;
  // final TimeOfDay? selectedTime;

  const TodoCard({
    Key? key,
    required this.index,
    required this.item,
    required this.navigateEdit,
    required this.deleteById,
    // required this.selectedDate,
    // required this.selectedTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = item['_id'] as String;
    //print(item);
    //print(item['created_at']);
    String createdAt = item["created_at"];
    DateTime dateTime = DateTime.parse(createdAt);
    String formattedDate =  DateFormat.yMMMd().format(dateTime);
    return Card(
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
              radius: 15.0,
              child: Text('${index + 1}'),
              backgroundColor: Colors.black38,
            ),
            const SizedBox(width: 10,),
            Text(item['title']),
              ],
            ),

            PopupMenuButton(onSelected: (value) {
                  if (value == 'edit') {
                    navigateEdit(item);
                  } else if (value == 'delete') {
                    deleteById(id);
                  }
                }, itemBuilder: (context) {
              return const [
            PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            )
          ];
        }
        ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.black12,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(item['description']),
              ),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 178.0,top: 10.0),
              child: Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 12
                ),
                ),
            )
          ],
        ), 
        
        //
        // trailing: PopupMenuButton(onSelected: (value) {
        //   if (value == 'edit') {
        //     navigateEdit(item);
        //   } else if (value == 'delete') {
        //     deleteById(id);
        //   }
        // }, itemBuilder: (context) {
        //   return const [
        //     PopupMenuItem(
        //       value: 'edit',
        //       child: Text('Edit'),
        //     ),
        //     PopupMenuItem(
        //       value: 'delete',
        //       child: Text('Delete'),
        //     )
        //   ];
        // }
        // ),
      ),
    );
  }
}
