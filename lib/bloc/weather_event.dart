import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WeatherEvent extends Equatable {
  WeatherEvent([List props = const <dynamic>[]]) : super(props);
}

// Всякий раз , когда пользователь вводит город, мы событие с данным городом
class FetchWeather extends WeatherEvent {
  final String city;

  FetchWeather({@required this.city})
    : assert(city != null),
      super([city]);
}


class RefreshWeather extends WeatherEvent {
  final String city;

  RefreshWeather({@required this.city})
      : assert(city != null),
        super([city]);
}