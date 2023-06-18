import 'package:flutter/material.dart';

class AdjustableNumberField extends StatelessWidget {
  final String title;
  final int value;
  final ValueChanged<int> onChanged;

  AdjustableNumberField({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(title),
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: value > 1
              ? () {
                  onChanged(value - 1);
                }
              : null,
        ),
        Text('$value'),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            onChanged(value + 1);
          },
        ),
      ],
    );
  }
}

class SettingsPage extends StatefulWidget {
  final int workTime;
  final int restTime;
  final int numSessions;
  final void Function(int, int, int) onSave;

  SettingsPage(
      {required this.onSave,
      required this.workTime,
      required this.restTime,
      required this.numSessions});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late int _workTime;
  late int _restTime;
  late int _numSessions;

  @override
  void initState() {
    super.initState();
    _workTime = widget.workTime;
    _restTime = widget.restTime;
    _numSessions = widget.numSessions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AdjustableNumberField(
              title: 'Work Time (min)',
              value: _workTime,
              onChanged: (value) {
                setState(() {
                  _workTime = value;
                });
              },
            ),
            AdjustableNumberField(
              title: 'Rest Time (min)',
              value: _restTime,
              onChanged: (value) {
                setState(() {
                  _restTime = value;
                });
              },
            ),
            AdjustableNumberField(
              title: 'Number of Sessions',
              value: _numSessions,
              onChanged: (value) {
                setState(() {
                  _numSessions = value;
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          widget.onSave(_workTime, _restTime, _numSessions);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
