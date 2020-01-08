import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/colors.dart';
import 'package:weather_app/data/weather.dart';

// TODO: update by swipe
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _waiting = true;
  dynamic _weatherData;

  @override
  void initState() {
    _getWeatherData();
    super.initState();
  }

  void _getWeatherData() async {
    var weatherData = await WeatherModel().getLocationWeather();
    setState(() {
      _waiting = false;
      _weatherData = weatherData;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_waiting) {
      return Scaffold(
        body: Center(
          child: SpinKitDoubleBounce(
            color: MyColors.blue,
            size: 100,
          ),
        ),
      );
    } else if (_weatherData == null || _weatherData['cod'] != 200) {
      return Scaffold(
        body: Center(
          child: Text("Error"),
        ),
      );
    } else {
      return _showResult();
    }
  }

  Widget _showResult() {
    String cityName = _weatherData['name'];
    double temperature = _weatherData['main']['temp'];
    String finalTmperature = "${temperature.toInt().toString()} °C";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          cityName,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: MyColors.grey,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Currently",
                  style: TextStyle(
                      color: MyColors.lightGrey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text(finalTmperature,
                    style: GoogleFonts.merriweather().copyWith(
                        color: Colors.black,
                        fontSize: 100,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(30, 10, 30, 10), // TODO: same as time
            child: FlatButton(
              onPressed: () {
                //TODO: change to week view
              },
              child: Row(
                children: <Widget>[
                  Text(
                    "Today",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: MyColors.grey,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 9,
              itemBuilder: (context, index) {
                //TODO: with datetime
                String time = 0.toString();
                if (index != null) {
                  time = (index * 3).toString();
                }
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  color: MyColors.blue,
                  child: ListTile(
                    leading: Text(
                      time.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "25°C",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.wb_sunny,
                          color: Colors.white,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
