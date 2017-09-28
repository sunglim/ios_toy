import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'alarm_data_model.dart';
import 'alarm_item.dart';

void main() {
  runApp(new MaterialApp(
    home: new MainDialog(),
    routes: <String, WidgetBuilder>{
      "/mytabs": (BuildContext context) => AddNewAlarmDialog(),
    },
  ));
}

class AddNewAlarmDialog extends StatefulWidget {
  @override
  AddNewAlarmDialogState createState() => new AddNewAlarmDialogState();
}

class AddNewAlarmDialogState extends State<AddNewAlarmDialog> {
  bool _repeat = false;
  String _label = 'Alarm';
  String _sound = 'Radar';
  bool _snooze = false;
  TimeOfDay currentTime = new TimeOfDay.now();
  ValueChanged<TimeOfDay> selectTime;

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: new TimeOfDay(
            hour: currentTime.hour, minute: currentTime.minute + 1));
    if (picked != null) {
      setState(() {
        currentTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.grey[850],
          leading: new FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, null);
              }),
          title: new Text('Add Alarm'),
          actions: <Widget>[
            new FlatButton(
                child: const Text('Save'),
                onPressed: () {
                  Map<String, dynamic> currentData = <String, dynamic>{};
                  currentData["time_of_day"] = currentTime;
                  currentData["y"] = 10;
                  Navigator.pop(context, currentData);
                })
          ],
        ),
        body: new Form(
          child: new ListView(
            children: [
              new RaisedButton(
                  child: new Text(currentTime.toString(),
                      style:
                          new TextStyle(color: Colors.white, fontSize: 30.5)),
                  color: Colors.grey[850],
                  onPressed: () {
                    _selectTime(context);
                  }),
              new RaisedButton(
                  child: new Row(
                    children: [
                      new Text(
                        'Repeat',
                        style: new TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                      new Expanded(
                        child: new Text('Never >',
                            style: new TextStyle(
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.right),
                      ),
                    ],
                  ),
                  color: Colors.grey[850],
                  onPressed: () {}),
              new RaisedButton(
                  child: new Row(
                    children: [
                      new Text(
                        'Lable',
                        style: new TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                      new Expanded(
                        child: new Text('Alarm >',
                            style: new TextStyle(
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.right),
                      ),
                    ],
                  ),
                  color: Colors.grey[850],
                  onPressed: () {}),
              new RaisedButton(
                  child: new Row(
                    children: [
                      new Text(
                        'Sound',
                        style: new TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                      new Expanded(
                        child: new Text('Never >',
                            style: new TextStyle(
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.right),
                      ),
                    ],
                  ),
                  color: Colors.grey[850],
                  onPressed: () {}),
              new RaisedButton(
                  child: new Row(
                    children: [
                      new Text(
                        'Snooze',
                        style: new TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                      new Expanded(
                        child: new Text('Never >',
                            style: new TextStyle(
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.right),
                      ),
                    ],
                  ),
                  color: Colors.grey[850],
                  onPressed: () {}),
            ],
          ),
        ));
  }
}

class MainDialog extends StatefulWidget {
  @override
  MainDialogState createState() => new MainDialogState();
}

class MainDialogState extends State<MainDialog> {
  AlarmDataModel _data_model = new AlarmDataModel();

  List<AlarmItem> alarm_items = <AlarmItem>[];

  @override
  void initState() {
    super.initState();
    _data_model.Init().then((_) {
      _data_model.SelectAll().then((out) {
        print(out);
      });
    });
  }

  Future<Map<String, dynamic>> _openAlarmDialog() async {
    Map<String, dynamic> selected_action = await Navigator.push(
        context,
        new MaterialPageRoute<Map<String, dynamic>>(
          builder: (BuildContext context) => new AddNewAlarmDialog(),
          fullscreenDialog: true,
        ));

    _data_model.Insert(
        selected_action["time_of_day"].toString(), selected_action["y"]);
    setState(() {
      print("set state claled");
      alarm_items = [
        new AlarmItem(new AlarmData("14:00 AM", 10)),
        new AlarmItem(new AlarmData("09:00 PM", 20))
      ];
    });
    return selected_action;
  }

  List<AlarmItem> _getAllItemFromData() {
    final List<AlarmItem> alarm_items = [
      new AlarmItem(new AlarmData("14:00 AM", 10)),
      new AlarmItem(new AlarmData("09:00 PM", 20))
    ];
    return alarm_items;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      home: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.grey[850],
          leading: new Center(
            child: new Text('Edit'),
          ),
          title: new Text('Alarm'),
          actions: <Widget>[
            new IconButton(
              color: Colors.amber[900],
              icon: new Icon(Icons.add),
              tooltip: 'Add new alarm',
              onPressed: () {
                _openAlarmDialog();
              },
            ),
          ],
        ),
        body: new ListView(
          children: alarm_items,
        ),
      ),
    );
  }
}
