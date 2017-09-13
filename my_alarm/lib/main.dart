import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(new MaterialApp(
    home: new MainDialog(),
    routes: <String, WidgetBuilder>{
      "/mytabs": (BuildContext context) => AddNewAlarmDialog(),
    },
  ));
}

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class AlarmItem extends StatelessWidget {
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
                    '5:03 AM',
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
                Navigator.pop(context, DismissDialogAction.cancel);
              }),
          title: new Text('Add Alarm'),
          actions: <Widget>[
            new FlatButton(
                child: const Text('Save'),
                onPressed: () {
                  Navigator.pop(context, DismissDialogAction.save);
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
  @override
  void initState() {
    super.initState();
    print("create db");
    _checkForUpdates();
  }

  Future<Null> _checkForUpdates() async {
    Directory documentsDirectory = await PathProvider.getApplicationDocumentsDirectory();
    //String path = join(documentsDirectory.path, "demo.db");
    //print(path);
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
                Navigator.push(
                    context,
                    new MaterialPageRoute<DismissDialogAction>(
                      builder: (BuildContext context) =>
                          new AddNewAlarmDialog(),
                      fullscreenDialog: true,
                    ));
              },
            ),
          ],
        ),
        body: new ListView(
          children: [
            new AlarmItem(),
          ],
        ),
      ),
    );
  }
}
