import 'package:bloc/bloc.dart';
import 'package:bloc_official_weather/widgets/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;
import './repositories/repositories.dart';
import './bloc/bloc.dart';
import './widgets/widgets.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('${bloc.toString()} $transition');
    super.onTransition(bloc, transition);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final WeatherRepository weatherRepository = WeatherRepository(
      weatherApiClient: WeatherApiClient(httpClient: http.Client()));

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ThemeBloc>(
        builder: (context) => ThemeBloc(),
      ),
      BlocProvider<SettingsBloc>(
        builder: (context) => SettingsBloc(),
      ),
    ],
    child: App(weatherRepository: weatherRepository),
  ));
}

class App extends StatelessWidget {
  final WeatherRepository weatherRepository;

  const App({Key key, @required this.weatherRepository})
      : assert(weatherRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, themeState) {
      return MaterialApp(
          theme: themeState.theme,
          title: 'Bloc Weather',
          home: BlocProvider(
            builder: (context) =>
                WeatherBloc(weatherRepository: weatherRepository),
            child: Weather(),
          ));
    });
  }
}
         