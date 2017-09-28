import 'package:flutter/material.dart';

class AlarmData {
  AlarmData(String time, int what)
    : time = time, what = what;
  final String time;
  final int what;
}

class AlarmItem extends StatelessWidget {
  AlarmItem(AlarmData alarm_data) : _alarm_data = alarm_data;
  
  AlarmData _alarm_data;

  @override
  Widget build(BuildContext context) {
    return new Container(
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
    );
  }
}

