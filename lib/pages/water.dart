import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterIntakeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Water Intake Tracker'),
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: WaterIntakePage(),
      ),
    );
  }
}

class WaterIntakePage extends StatefulWidget {
  @override
  _WaterIntakePageState createState() => _WaterIntakePageState();
}

class _WaterIntakePageState extends State<WaterIntakePage> {
  double _currentIntake = 0.0;
  final double _dailyRequirement =
      2000.0; // Assume daily requirement is 2000 ml
  final TextEditingController _textController = TextEditingController();
  bool _showCongratsText = false;

  @override
  void initState() {
    super.initState();
    _loadIntake();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  _loadIntake() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentIntake = (prefs.getDouble('intake') ?? 0.0);
      if (_currentIntake >= _dailyRequirement) {
        _showCongratsText = true;
      }
    });
  }

  _updateIntake(double intake) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('intake', intake);
    setState(() {
      _currentIntake = intake;
      if (_currentIntake >= _dailyRequirement) {
        _showCongratsText = true;
      }
    });
  }

  _resetIntake() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('intake');
    _loadIntake();
  }

  Widget _buildFaceIcon() {
    final double percentage = _currentIntake / _dailyRequirement;

    if (percentage <= 0.3) {
      return Icon(Icons.sentiment_very_dissatisfied,
          size: 80, color: Colors.red);
    } else if (percentage <= 0.6) {
      return Icon(Icons.sentiment_neutral, size: 80, color: Colors.orange);
    } else {
      return Icon(Icons.sentiment_very_satisfied,
          size: 80, color: Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (_showCongratsText)
            Text(
              "You're a certified hydrohomie!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          SizedBox(height: 20),
          Text('Daily Water Intake', style: TextStyle(fontSize: 24)),
          SizedBox(height: 50),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox(
                width: 300, // Increased width of the progress bar
                height: 300, // Increased height of the progress bar
                child: CircularProgressIndicator(
                  value: _currentIntake / _dailyRequirement,
                  strokeWidth: 20,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildFaceIcon(),
                  SizedBox(height: 10),
                  Text(
                    '${(_currentIntake / _dailyRequirement * 100).toStringAsFixed(0)}%',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${_currentIntake.toStringAsFixed(1)} / $_dailyRequirement ml',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('I just drank', style: TextStyle(fontSize: 14)),
              SizedBox(width: 10),
              Container(
                width: 100,
                child: TextField(
                  controller: _textController,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 10),
              Text('amount of water.', style: TextStyle(fontSize: 14)),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    final intake = double.parse(_textController.text);
                    _updateIntake(_currentIntake + intake);
                  });
                  _textController.clear();
                },
                child: Text('Log It!', style: TextStyle(fontSize: 14)),
              ),
            ],
          ),
          SizedBox(height: 20), // Added some spacing
          ElevatedButton(
            onPressed: () {
              _resetIntake();
            },
            child: Text('Reset', style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}