import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weathermap/weatherbloc.dart';
import 'package:weathermap/weathermodel.dart';
import 'package:weathermap/weatherrepo.dart';


double height;
double width;

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blue[900],
        body: BlocProvider(
          create: (BuildContext context) { return WeatherBloc(WeatherRepo());  },
          child: HomeScreen(),
        ),
      );
  }
}



class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cityController = TextEditingController();
    return Container(
      height: height,
      child: ListView(
        children: <Widget>[
          SizedBox(height:15),
          Container(
            height: 60,
            width: width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            margin: EdgeInsets.symmetric(horizontal:10),
             child: TextFormField(
                    controller: cityController,
                    decoration: InputDecoration(
                      suffixIcon:IconButton(
                         icon: Icon(Icons.search, color: Colors.black,),
                         onPressed: (){
                           BlocProvider.of<WeatherBloc>(context).add(FetchWeather(cityController.text));
                           cityController.clear();
                           FocusScope.of(context).requestFocus(FocusNode());
                         }
                       ) ,
                       enabledBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.all(Radius.circular(10)),
                         borderSide: BorderSide(
                            color: Colors.white,
                            style: BorderStyle.solid
                           )
                       ),
                       fillColor: Colors.white,
                       focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Colors.white,
                            style: BorderStyle.solid
                           )
                       ),
                       hintText: "Enter City ",
                       contentPadding: EdgeInsets.symmetric(vertical:20,horizontal:10),
                       hintStyle: TextStyle(color: Colors.black,),
                     ),
                     style: TextStyle(color: Colors.black),
                ),
          ),
          BlocBuilder<WeatherBloc, WeatherState>(
             builder: (context, state){
               if(state is WeatherIsNotSearched){
                 return Container(
                   height: height - 80,
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       mainAxisSize: MainAxisSize.max,
                       children: <Widget>[
                         Text('SERACH NOW',style: TextStyle(color:Colors.white,fontSize:30),),
                         SizedBox(height:5),
                         Text('IN',style: TextStyle(color:Colors.white,fontSize:30),),
                         SizedBox(height:5),
                         Text('WEATHER.',style: TextStyle(color:Colors.grey[900],fontSize:50),)
                       ],
                     ),
                 );
               }else if(state is WeatherIsLoading) {
                  return Container(
                    height: height-80,
                    child : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CircularProgressIndicator(backgroundColor: Colors.grey[900],),
                        SizedBox(height:20),
                        Text('Fetching Data',style: TextStyle(color:Colors.white,fontSize:30),)
                      ],
                    )
                  );
               }else if(state is WeatherIsLoaded) {
                 return ShowWeather(state.getWeather, cityController.text); 
               }else{
                 return Container(
                   height: height-80,
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       mainAxisSize: MainAxisSize.min,
                       children: <Widget>[
                         Text('Error Loading Data',style: TextStyle(color:Colors.grey[900],fontSize:30,fontWeight: FontWeight.bold)),
                         SizedBox(height:20),
                         Text('Try Again',style: TextStyle(color:Colors.white,fontSize:30)),
                         SizedBox(height:5),
                         Text('By Typing a',style: TextStyle(color:Colors.white,fontSize:30)),
                         SizedBox(height:5),
                         Text('City Name',style: TextStyle(color:Colors.grey[900],fontSize:30)),
                       ],
                     ),
                 );
               } 
             }
          )
        ],
      ),
    );
  }
}



class ShowWeather extends StatelessWidget {
  final WeatherModel weather;
  final city;

  ShowWeather(this.weather, this.city);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 170,
            margin: EdgeInsets.symmetric(horizontal:10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
             // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Image.network(
                    "http://openweathermap.org/img/w/" + weather.icon + ".png",
                    width: 100 ,
                    height: 100,
                    fit: BoxFit.fill,
                  )
                ),
                SizedBox(width:30),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(weather.getTemp.round().toString() + '\u2103',style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.bold),),
                    SizedBox(height:5),
                    Text(weather.description ,style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                  ],
                )
              ],
            ),
          ),
          Container(
            width: width,
            height: height-255,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
              color: Colors.white
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height:20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(weather.name ,style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),
                    Text(((weather.country != null)?(','+weather.country):'') ,style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),
                    Icon(Icons.location_city,color: Colors.grey,),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.location_on,color:Colors.red),
                    Text(weather.lon.toString() + ',' ,style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                    Text(weather.lat.toString() ,style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(height:20),
                GridView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5
                    ),
                    
                    children: <Widget>[
                      GridPanel(
                        color: Colors.blue[500],
                        name: 'Feels Like:',
                        value: weather.getfeelslike.round().toString() +'\u2103', 
                      ),
                      GridPanel(
                        color: Colors.black,
                        name: 'Visibility:',
                        value: weather.visibility.toString(), 
                      ),
                      GridPanel(
                        color: Colors.black,
                        name: 'Pressure:',
                        value: weather.pressure.toString() + ' hPa', 
                      ),
                      GridPanel(
                        color: Colors.black,
                        name: 'Humidity:',
                        value: weather.humidity.toString() + '%' 
                      ), 
                    ],
                  ),
                  SizedBox(height:5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GridPanel(
                      color: Colors.blue[500],
                               name: 'Min Temp:',
                               value: weather.getMinTemp.round().toString() +'\u2103', 
                             ),
                             SizedBox(width:10),
                             GridPanel(
                               color: Colors.blue[500],
                                name: 'Max Temp:',
                                value: weather.getMaxTemp.round().toString() +'\u2103', 
                              ) 
                  ],
                ),
                SizedBox(height:10),
                Container(
                  padding: EdgeInsets.only(left:5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('Sunrise and Sunset :',style: TextStyle(color: Colors.black,fontSize:20,fontWeight: FontWeight.bold)),
                    ],
                  )
                ),
                SizedBox(height:10),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                     SunPanel(
                       value: weather.getsunrise + ' AM',
                       icon: 'sunrise',
                     ),
                     SizedBox(width:5),
                     SunPanel(
                       value: weather.getsunset + ' PM',
                       icon: 'sunset',
                     )
                       
                    ],
                  ),
                )
              ],
            ),
          ),
          
        ],
      ),
    );
  }

}


  class GridPanel extends StatelessWidget {
    final name;
    final value;
    final color;

    GridPanel({Key key, this.name, this.value,this.color}):super(key: key);
    @override
    Widget build(BuildContext context) {
       return  Container(
               height: 80,
               width: width/4.3,
               margin: EdgeInsets.all(5),
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(10),
                 color: Colors.white,
                 boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(0.0, 1.0),
                    )
                  ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(name ,style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                    Text(value,style: TextStyle(color: color,fontSize: 20,fontWeight: FontWeight.bold),)
                 ],
                ),
           );
    }
  }


  class SunPanel extends StatelessWidget {
    final value;
    final icon;

    SunPanel({Key key, this.value,this.icon}):super(key: key);
    @override
    Widget build(BuildContext context) {
       return  Container(
               height: 100,
               width: width/3,
               margin: EdgeInsets.all(5),
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(10),
                 color: Colors.white,
                 boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(0.0, 1.0),
                    )
                  ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 40,
                      child: Image.asset('assets/$icon.jpg',fit: BoxFit.fill,)),
                    Text(value + ' IST',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
                 ],
                ),
           );
    }
  }