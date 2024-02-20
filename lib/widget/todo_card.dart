import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateEdit;
  final Function(String) deleteById;
  //-------------------------------
  final DateTime selectedDate;
  final TimeOfDay selectedTime;

  const TodoCard({
    super.key,
    required this.index,
    required this.item,
    required this.navigateEdit,
    required this.deleteById,
    //----------------------------
    required this.selectedDate,
    required this.selectedTime,
  
  });

  @override
  Widget build(BuildContext context) {
    final id = item['_id'] as String;
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text(item['title']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item['description']),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMd().format(selectedDate)),
                // Text(DateFormat.yMMMd().format(dateTime).toString()),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(selectedTime.format(context).toString()), 
                  // Text(timeOfDay.format(context).toString()),
                )
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(onSelected: (value) {
          if (value == 'edit') {
            //open the edit button
            navigateEdit(item);
          } else if (value == 'delete') {
            //delete and remove the item
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
            )];
        }),
      ),
    );
  }
}
