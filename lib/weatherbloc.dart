import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weathermap/weathermodel.dart';
import 'package:weathermap/weatherrepo.dart';


class WeatherEvent extends Equatable{
  @override
  //  implement props
  List<Object> get props => [];

}

class FetchWeather extends WeatherEvent{
  final _city;

  FetchWeather(this._city);

  @override
  //  implement props
  List<Object> get props => [_city];
}

class WeatherState extends Equatable{
  @override
  //  implement props
  List<Object> get props => [];

}


class WeatherIsNotSearched extends WeatherState{

}

class WeatherIsLoading extends WeatherState{

}

class WeatherIsLoaded extends WeatherState{
  final _weather;

  WeatherIsLoaded(this._weather);

  WeatherModel get getWeather => _weather;

  @override
  //  implement props
  List<Object> get props => [_weather];
}



class WeatherBloc extends Bloc<WeatherEvent, WeatherState>{

  WeatherRepo weatherRepo;

  WeatherBloc(this.weatherRepo);

  @override
  //  implement initialState
  WeatherState get initialState => WeatherIsNotSearched();

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async*{
    //  implement mapEventToState
    if(event is FetchWeather){
      yield WeatherIsLoading();

      try{
        WeatherModel weather = await weatherRepo.getWeather(event._city);
        yield WeatherIsLoaded(weather);
      }catch(_){
        print(_);
      }
    }
  }

}