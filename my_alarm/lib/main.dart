import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                  child: new Text(currentTime.format(context),
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
  static const platform =
      const MethodChannel('samples.flutter.io/userNotifications');
  Future<Null> _getBatteryLevel() async {
    try {
      await platform.invokeMethod('requestAuthorization');
    } on PlatformException catch (e) {}
    setState(() {});
  }

  AlarmDataModel _data_model = new AlarmDataModel();

  final List<AlarmItem> _alarm_items = <AlarmItem>[];

  void _deleteTaskHandler(int id) {
    print("delete task handler called $id");
    // Error here.
    _data_model.Delete(id);
    setState(() {
      _alarm_items.removeWhere((item) => item.alarm_data.id == id);
    });
  }

  Future<Null> _loadAlarmData() async {
    await _data_model.Init();
    List<AlarmItem> alarm_items = <AlarmItem>[];
    _data_model.SelectAll().then((out) {
      out.forEach((element) {
          print(element);
        _alarm_items.add(new AlarmItem(new AlarmData(
            element["id"],
            element["name"].toString(),
            element["value"]), () => _deleteTaskHandler(element["id"])));
      });
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadAlarmData();
    _getBatteryLevel();
  }

  // pass current index.
  Future<Map<String, dynamic>> _openAlarmDialog(BuildContext context) async {
    Map<String, dynamic> selected_action = await Navigator.push(
        context,
        new MaterialPageRoute<Map<String, dynamic>>(
          builder: (BuildContext context) => new AddNewAlarmDialog(),
          fullscreenDialog: true,
        ));

    try {
      print("Invoke scheduleNotification");
      Map<String, dynamic> time_for_schedule = <String, dynamic>{};
      time_for_schedule["hour"] = selected_action["time_of_day"].hour;
      time_for_schedule["minute"] = selected_action["time_of_day"].minute;
      print(time_for_schedule);
      await platform.invokeMethod('scheduleNotification', time_for_schedule);
    } on PlatformException catch (e) {}

    int new_id = await _data_model.Insert(
        selected_action["time_of_day"].format(context), selected_action["y"]);
    setState(() {
      _alarm_items.add(new AlarmItem(new AlarmData(
          new_id,
          selected_action["time_of_day"].format(context),
          selected_action["y"]), () => _deleteTaskHandler()));
    });
    return selected_action;
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
                _openAlarmDialog(context);
              },
            ),
          ],
        ),
        body: new ListView.builder(
          itemBuilder: (BuildContext context, int index) => _alarm_items[index],
          itemExtent: 120.0,
          itemCount: _alarm_items.length,
        ),
      ),
    );
  }
}
