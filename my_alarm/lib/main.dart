import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
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
              onPressed: () {},
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.grey[850],
        leading: new Center(
          child: new Text('Cancel'),
        ),
        title: new Text('Add Alarm'),
        actions: <Widget>[
          new IconButton(
            color: Colors.amber[900],
            icon: new Icon(Icons.add),
            tooltip: 'Save',
            onPressed: () {},
          ),
        ],
      ),
      body: new Form(
        onWillPop: _onWillPop,
        child: new ListView(
          children: [],
        ),
      )
    );
  }
}
