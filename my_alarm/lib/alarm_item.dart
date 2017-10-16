import 'package:flutter/material.dart';

class AlarmData {
  AlarmData(String time, int what)
      : time = time,
        what = what;
  final String time;
  final int what;
}

class AlarmItem extends StatelessWidget {
  AlarmItem(AlarmData alarm_data) : _alarm_data = alarm_data;

  AlarmData _alarm_data;

  @override
  Widget build(BuildContext context) {
    return new Dismissible(
      key: new ObjectKey(_alarm_data),
      direction: DismissDirection.endToStart,
      onDismissed: (DismissDirection direction) {
        print("Dismissed called");
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
                      _alarm_data.time,
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
