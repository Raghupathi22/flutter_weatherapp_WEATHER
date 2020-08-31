import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weathermap/weathermodel.dart';



bool load = false;

class WeatherRepo {
  Future<WeatherModel> getWeather(String city) async{
    final result = await http.Client().get("https://api.openweathermap.org/data/2.5/weather?q=$city&APPID=d4b272a08e95791fc6eb5cb1ee44dbf5");
    
    if(result.statusCode != 200){
      print('failed');
      
    }
      assert(load= true);
      print('success');
      return parsedJson(result.body);
    
  }
  
  WeatherModel parsedJson(final response){
    final jsonDecoded = json.decode(response);

    return WeatherModel.fromJson(jsonDecoded);
  }



}




