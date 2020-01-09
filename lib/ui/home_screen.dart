import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/colors.dart';
import 'package:weather_app/data/weather.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weather_app/data/weather_model.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AllWeather _allWeather;
  List<String> _timespanOptions = ['Today', 'This week'];
  String _selectedTimespan = 'Today';
  bool _waiting = true;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    try {
      _getWeatherData();
      _refreshController.refreshCompleted();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _getWeatherData();
    super.initState();
  }

  void _getWeatherData() async {
    AllWeather allWeather = await WeatherClass().getWeather();
    print(allWeather.day1);
    setState(() {
      _waiting = false;
      _allWeather = allWeather;
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
    } else {
      return _showResult();
    }
  }

  Widget _showResult() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _allWeather.city,
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
      body: SmartRefresher(
        enablePullDown: true,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        // onLoading: _onLoading,
        child: _content(),
      ),
    );
  }

  Widget _content() {
    return Column(
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
              Text(
                  _allWeather != null
                      ? _allWeather.nowWeather.temperature
                      : "...",
                  style: GoogleFonts.merriweather().copyWith(
                      color: Colors.black,
                      fontSize: 100,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.fromLTRB(30, 10, 30, 10), // TODO: same as time
          child: DropdownButton(
            underline: Container(),
            value: _selectedTimespan,
            onChanged: (newValue) {
              setState(() {
                _selectedTimespan = newValue;
              });
            },
            items: _timespanOptions.map((location) {
              return DropdownMenuItem(
                child: new Text(location),
                value: location,
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: _selectedTimespan == "Today"
              ? _todayList(
                  weatherList: _allWeather.day1.weatherList,
                )
              : _weekList(),
        )
      ],
    );
  }

  Widget _listTile(
      {@required String formattedTime,
      @required String temp,
      @required String icon}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      color: MyColors.blue,
      child: ListTile(
        leading: Text(
          formattedTime,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              temp,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              icon,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _todayList({
    @required List<Weather> weatherList,
  }) {
    return ListView.builder(
        itemCount: weatherList.length,
        itemBuilder: (context, index) {
          Weather weather = weatherList[index];
          String formattedTime = DateFormat('Hm').format(weather.time);
          return _listTile(
              formattedTime: formattedTime,
              temp: weather.temperature,
              icon: weather.weatherIcon);
        });
  }

  Widget _weekList() {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          DateFormat dayFormat = DateFormat('MMMd');
          String formattedTime = '';
          String temperature = '';
          String weatherIcon = '';
          if (index == 0) {
            formattedTime = "Today";
            temperature = _allWeather.day1.temperature;
            weatherIcon = _allWeather.day1.weatherIcon;
          } else if (index == 1) {
            formattedTime = "Tomorrow";
            temperature = _allWeather.day2.temperature;
            weatherIcon = _allWeather.day2.weatherIcon;
          } else if (index == 2) {
            formattedTime =
                dayFormat.format(_allWeather.day3.weatherList[0].time);
            temperature = _allWeather.day3.temperature;
            weatherIcon = _allWeather.day3.weatherIcon;
          } else if (index == 3) {
            formattedTime =
                dayFormat.format(_allWeather.day4.weatherList[0].time);
            temperature = _allWeather.day4.temperature;
            weatherIcon = _allWeather.day4.weatherIcon;
          } else if (index == 4) {
            formattedTime =
                dayFormat.format(_allWeather.day5.weatherList[0].time);
            temperature = _allWeather.day5.temperature;
            weatherIcon = _allWeather.day5.weatherIcon;
          }

          return _listTile(
              formattedTime: formattedTime,
              temp: temperature,
              icon: weatherIcon);
        });
  }
}
