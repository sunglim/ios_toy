import 'package:flutter/material.dart';

class AlarmData {
  AlarmData(int id, String time, int what)
      : id = id,
        time = time,
        what = what;
  final int id;
  final String time;
  final int what;
}

class AlarmItem extends StatelessWidget {
   AlarmData alarm_data;
   VoidCallback onDelete;

  AlarmItem(AlarmData alarm_data, VoidCallback onDelete) {
    this.alarm_data = alarm_data;
    this.onDelete = onDelete;
  }

  @override
  Widget build(BuildContext context) {
    return new Dismissible(
      key: new ObjectKey(alarm_data.id),
      direction: DismissDirection.endToStart,
      onDismissed: (DismissDirection direction) {
        onDelete();
      },
      background: new Container(
        child: const Text('dummy'),
      ),
      secondaryBackground: new Container(
          color: Colors.red[400],
          child: const ListTile(
            trailing: const Text(
              'Delete',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          )),
      child: new Container(
        color: Colors.grey[850],
        padding: const EdgeInsets.all(32.0),
        child: new Row(
          children: [
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Container(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: new Text(
                      alarm_data.time,
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  new Text(
                    'Alarm. Fri Sat',
                    style: new TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            // TODO(sungguk): Use CurpertinoSwitch instead.
            new Icon(
              Icons.star,
              color: Colors.red[500],
            ),
            new Text('33'),
          ],
        ),
      ),
    );
  }
}
