import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_flutter/provider/theme_provider.dart';
import 'package:weather_flutter/service/api_service_dart';


class WeatherAppHomeScreen extends ConsumerStatefulWidget {
  const WeatherAppHomeScreen({super.key});

  @override
  ConsumerState<WeatherAppHomeScreen> createState() =>
      _WeatherAppHomeScreenState();
}

class _WeatherAppHomeScreenState
    extends ConsumerState<WeatherAppHomeScreen> {
  final _weatherService = WeatherApiService();
  String city = "Surkhet";
  String country = '';
  Map<String, dynamic> currentValue = {};
  List<dynamic> hourly = [];
  List<dynamic> pastWeek = [];
  List<dynamic> next7days = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      isLoading = true;
    });
    try {
      final forecast = await _weatherService.getHourlyForecast(city);
      final past = await _weatherService.getOastSevenDaysweather(city) ;// ✅ fixed method name

      setState(() {
        currentValue = forecast['current'] ?? {};
        hourly = forecast['forecast']?['forecastday']?[0]?['hour'] ?? [];

        // for next 7 days
        next7days = forecast['forecast']?['forecastday'] ?? [];

        pastWeek = past;
        city = forecast['location']?['name'] ?? city;
        country = forecast['location']?['country'] ?? ''; // ✅ fixed "loaction" typo
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        currentValue = {};
        hourly = [];
        pastWeek = [];
        next7days = [];
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("City not found or invalid. Please enter a valid city name"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    final notifier = ref.read(themeNotifierProvider.notifier);
    final isDark = themeMode == ThemeMode.dark;

    String iconPath = currentValue['condition']?['icon']??'';
    String imageUrl = iconPath.isNotEmpty? "https:$iconPath":"";

    Widget imagewidgets = imageUrl.isNotEmpty?Image.network(imageUrl, height: 200, width: 200, fit: BoxFit.cover):SizedBox();

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          const SizedBox(width: 25),
          SizedBox(
            width: 320,
            height: 50,
            child: TextField(
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
              onSubmitted: (value) {
                if (value.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter a city name"),
                    ),
                  );
                  return;
                }
                setState(() {
                  city = value.trim();
                });
                _fetchWeather();
              },
              decoration: const InputDecoration(
                labelText: "Search city",
                prefixIcon: Icon(Icons.search,
                
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: notifier.toggleTheme,
            child: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.black : Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 25),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else ...[
            if (currentValue.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "$city${country.isNotEmpty ? ',$country' : ''}",
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 40,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w400, // ✅ fixed: fontWeight typo
                    ),
                  ),
                  Text(
                    "${currentValue['temp_c']}°C",
                    style: TextStyle(
                      fontSize: 50,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold, // ✅ fixed: fontWeight typo
                    ),
                  ),
                  Text("${currentValue['condition']['text']}",
                  style: TextStyle(
                    fontSize: 22,
                    color: Theme.of(context).colorScheme.onPrimary,
                    
                  ),
                  ),
                  imagewidgets,
                  Padding(padding: EdgeInsets.all(15),
                  child: Container(height: 100,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary,
                        offset: Offset(1, 1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      )
                    ],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      // Humidity
                      Column(children: [

                         Image.network("https://cdn-icons-png.freepik.com/512/9290/9290540.png", width: 30, height: 30,),
                    Text("${currentValue['humidity']}%",
                     style: TextStyle(  color: Theme.of(context).colorScheme.secondary, 
                     fontWeight: FontWeight.bold,
                     ),
                     

                     ),
                     Text("Humidity",
                     style: TextStyle(  color: Theme.of(context).colorScheme.secondary, 
                     fontWeight: FontWeight.bold,
                     ),
                     )
                      ],
                      ),


                       //  wind
                      Column(children: [

                         Image.network("https://png.pngtree.com/png-clipart/20190705/original/pngtree-vector-wind-icon-png-image_4184509.jpg", width: 30, height: 30,),
                    Text("${currentValue['wind_kph']} kph",
                     style: TextStyle(  color: Theme.of(context).colorScheme.secondary, 
                     fontWeight: FontWeight.bold,
                     ),
                     

                     ),
                     Text("wind",
                     style: TextStyle(  color: Theme.of(context).colorScheme.secondary, 
                     fontWeight: FontWeight.bold,
                     ),
                     )
                      ],
                      ),
                      
                        //  maximum temperature
                      Column(children: [

                         Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbJS4wbuG9-dwHi7BFEESu4TLLIWIUBRmacw&s", width: 30, height: 30,),
                    Text("${hourly.isNotEmpty ? hourly.map((h)=> h['temp_c']).reduce((a,b)=> a>b?a:b):"N/A"}",
                     style: TextStyle(  color: Theme.of(context).colorScheme.secondary, 
                     fontWeight: FontWeight.bold,
                     ),
                     

                     ),
                     Text("Max temp",
                     style: TextStyle(  color: Theme.of(context).colorScheme.secondary,
                     ),
                     )
                      ],
                      ),
                    
                    ],
                  ),
                  ),

                  ),
                  SizedBox(height: 15),
                  Container(height: 250, width: double.maxFinite, decoration: BoxDecoration(border: Border(
                    top: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(40),

                  )
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Today Forecast",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            GestureDetector(onTap: (){


                            },
                            child: Text(
                              "Weekly Forecast",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            ),

                            


                        ],),
                        ),

                        Divider(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        SizedBox(height: 20,),
                        SizedBox(height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: hourly.length,
                          itemBuilder: (context, index) {
                            return Padding(padding: EdgeInsets.all(8),
                            child: Container(height: 70),
                            );
                          },
                        ),
                        )
                    ],
                  ),
                  ),
                ],
              )
          ]
        ],
      ),
    );
  }
}
