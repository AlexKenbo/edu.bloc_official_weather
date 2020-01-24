import 'package:bloc_official_weather/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WeatherState extends Equatable {
  WeatherState([List props = const <dynamic>[]]) : super(props);
}

//WeatherEmpty - наше начальное состояние, в котором не будет данных о погоде, потому что пользователь еще не выбрал город
class WeatherEmpty extends WeatherState {}

//WeatherLoading - состояние, которое будет происходить, пока мы выбираем погоду для данного города
class WeatherLoading extends WeatherState {}

//WeatherLoaded - состояние, которое возникнет, если мы сможем успешно выбрать погоду для данного города.
class WeatherLoaded extends WeatherState {
  final Weather weather;

  WeatherLoaded({@required this.weather})
    : assert(weather != null),
      super([weather]);
}

//WeatherError - состояние, которое возникнет, если мы не сможем выбрать погоду для данного города.
class WeatherError extends WeatherState {}
