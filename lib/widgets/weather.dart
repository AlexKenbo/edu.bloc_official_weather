import 'dart:async';
import 'package:bloc_official_weather/widgets/settings.dart';

import '../bloc/bloc.dart';
import './widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'gradient_container.dart';

class Weather extends StatefulWidget {
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Bloc Weather'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Settings()
                ));
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                final city = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CitySelection()));
                if (city != null) {
                  weatherBloc.dispatch(FetchWeather(city: city));
                }
              },
            ),
          ],
        ),
        body: Center(
          child: BlocListener<WeatherBloc, WeatherState>(
            listener: (context, state) {
              if (state is WeatherLoaded) {
                BlocProvider.of<ThemeBloc>(context).dispatch(
                    WeatherChanged(condition: state.weather.condition));
                _refreshCompleter?.complete();
                _refreshCompleter = Completer();
              }
            },
            child: BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                if (state is WeatherEmpty) {
                  return Center(
                    child: Text('Пожалуйста, введите город'),
                  );
                }
                if (state is WeatherLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is WeatherLoaded) {
                  final weather = state.weather;

                  return BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, themeState) {
                      return GradientContainer(
                    color: themeState.color,
                    child: RefreshIndicator(
                      onRefresh: () {
                        weatherBloc.dispatch(
                          RefreshWeather(city: state.weather.location),
                        );
                        return _refreshCompleter.future;
                      },
                      child: ListView(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 100),
                            child: Center(
                              child: Location(location: weather.location),
                            ),
                          ),
                          Center(
                            child: LastUpdated(dateTime: weather.lastUpdated),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 50),
                            child: Center(
                              child: CombinedWeatherTemperature(
                                weather: weather,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                    },
                  );
                }
                if (state is WeatherError) {
                  return Text(
                    'Что-то пошло не так!',
                    style: TextStyle(color: Colors.red),
                  );
                }
              },
            ),
          ),
        ));
  }
}
