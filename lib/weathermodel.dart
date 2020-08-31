class WeatherModel{
  final name;
  final feelslike;
  final visibility;
  final temp;
  final pressure;
  final humidity;
  final tempmax;
  final tempmin;
  final sunrise;
  final sunset;
  final country;
  final lon;
  final lat;
  final description;
  final icon;

  String  get getsunrise => getClockInUtcPlus3Hours(sunrise as int );
  String  get getsunset => getClockInUtcPlus3Hours(sunset as int );
  double get getfeelslike => feelslike - 272.5;
  double get getTemp => temp-272.5;
  double get getMaxTemp => tempmax-272.5;
  double get getMinTemp=> tempmin -272.5;

  WeatherModel(this.name,this.feelslike,this.visibility,this.temp, this.pressure, this.humidity, this.tempmax, this.tempmin,
       this.sunrise,this.sunset,this.country,this.lon,this.lat,this.description,this.icon);

  factory WeatherModel.fromJson(Map<String, dynamic> json){
    return WeatherModel(
      json["name"],
      json["main"]["feels_like"],
      json["visibility"],
      json["main"]["temp"],
      json["main"]["pressure"],
      json["main"]["humidity"],
      json["main"]["temp_max"],
      json["main"]["temp_min"],
      json["sys"]["sunrise"],
      json["sys"]["sunset"],
      json["sys"]["country"],
      json["coord"]["lon"],
      json["coord"]["lat"],
      json["weather"][0]["main"],
      json["weather"][0]["icon"]
    );
  }
}

String getClockInUtcPlus3Hours(int timeSinceEpochInSec) {
  final time = DateTime.fromMillisecondsSinceEpoch(timeSinceEpochInSec * 1000,
          isUtc: true)
      .add(const Duration(hours: 3));
  return '${time.hour}:${time.second}';
}