import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/animationPageRoute.dart';
import 'dart:async';
import 'dart:convert';
import 'package:myapp/tips.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(home: HomePage()));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _haveStarted3Times = '';

  Future<int> _getIntFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final startUpNumber = prefs.getInt('startUpNumber');
    if (startUpNumber == null) {
      return 0;
    }
    return startUpNumber;
  }

  Future<void> _resetCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('startUpNumber', 0);
  }

  Future<void> _incrementStartUp() async {
    final prefs = await SharedPreferences.getInstance();

    int lastStartUpNumber = await _getIntFromSharedPref();

    int currentStartUpNumber = ++lastStartUpNumber;

    await prefs.setInt('startUpNumber', currentStartUpNumber);

    if (currentStartUpNumber == 3) {
      setState(
          () => _haveStarted3Times = '$currentStartUpNumber Times Completed');

      await _resetCounter();
    } else {
      setState(() =>
          _haveStarted3Times = '$currentStartUpNumber Times started the app');
    }
  }

  Map data;
  int confirmed;
  int newConfirmed;
  int recovered;
  int newRecovered;
  int hospitalized;
  int newHospitalized;
  int deaths;
  int newDeaths;

  Future getData() async {
    http.Response response =
        await http.get("https://covid19.th-stat.com/api/open/today");
    debugPrint(response.body);
    data = json.decode(response.body);
    setState(() {
      confirmed = data["Confirmed"];
      newConfirmed = data["NewConfirmed"];
      recovered = data["Recovered"];
      newRecovered = data["NewRecovered"];
      hospitalized = data["Hospitalized"];
      newHospitalized = data["NewHospitalized"];
      deaths = data["Deaths"];
      newDeaths = data["NewDeaths"];
    });
  }

  @override
  void initState() {
    super.initState();
    _incrementStartUp();
    getData();
  }

  List assessment = [
    'No 1 : Temperature greater or equal than 37.5 degrees or had a fever before.',
    'No 2 : Either illness with respiratory symptoms or following ”cough, sore throat, shortness on breathing or a difficulty on breathing”',
    'No 3 : Travelled to / from or living in the COVID-19 risky area during 14 days before started illness.',
    'No 4 : Contacted / Stay closed to COVID-19 patient (keep distance less than 1 meter fo 5 minutes) within 14 days.',
    'No 5 : Travelled to community area or crowded place such as local market, shopping mall, hospital or public transport.',
    'No 6 : Patient who contacted with foreigner, crowded place or community area.',
    'No 7 : Are you a medical staff ?',
    'No 8 : Been in close contact with 5 or more people who have had flu at the same time in the last 14 days',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        ],
        title: Text(
          'COVIDNOW',
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/main.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 25,
            right: 20,
            left: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Container(
                padding: EdgeInsets.fromLTRB(120, 5, 120, 5),
                color: Colors.red[900],
                child: Text(
                  'Cases\n$confirmed\n[Increase $newConfirmed]',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                color: Colors.green[700],
                child: Text(
                  'Recovered\n$recovered\n[Increase $newRecovered]',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                color: Colors.grey[500],
                child: Text(
                  'Deaths\n$deaths\n[Increase $newDeaths]',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            right: 133,
            left: 133,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                color: Colors.blue[600],
                child: Text(
                  'Hospitalized\n$hospitalized\n[Changes $newHospitalized]',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                height: 295,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: assessment.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.transparent,
                      child: ListTile(
                        onTap: () {},
                        title: Text(
                          assessment[index],
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, AnimationPageRoute(widget: TipsPage()));
        },
        child: Text(
          'TIPS',
          style: TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: Colors.brown[300],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.brown,
        child: Container(
          height: 50.0,
          child: Text(
            _haveStarted3Times,
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      backgroundColor: Colors.brown[400],
    );
  }
}
