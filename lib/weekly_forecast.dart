import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyForecast extends StatefulWidget {
final   Map<String, dynamic> currentValue ;
  final String city;
   final  List<dynamic> pastWeek;
  final List<dynamic> next7days ;

   const WeeklyForecast({super.key,
    required this.city,
    required this.currentValue,
     required this.pastWeek, 
     required this.next7days});


  @override
  State<WeeklyForecast> createState() => _WeeklyForecastState();
}

class _WeeklyForecastState extends State<WeeklyForecast> {

 String formatApiData(String dataString) {
  DateTime date = DateTime.parse(dataString);
  return DateFormat('d MMM, EEEE').format(date);
 }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        bottom: false,
        
        child: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Column(children: [
                Text(
                    widget.city,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 40,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "${widget.currentValue['temp_c']}°C",
                    style: TextStyle(
                      fontSize: 50,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${widget.currentValue['condition']['text']}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  Image.network("https:${widget.currentValue['condition']?['icon'] ?? ''}",
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                  
                  )

              ],
              ),
              ),
              // Next 7 days Forecast
              SizedBox(height: 20,)
              Text(
                "Next 7 days forecast",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              SizedBox(height: 10,),
              ...widget.next7days.map((day) {
                final data = day['data'] ?? "";
                final condition = day['day']?['condition']?['text'] ?? '';
                final Icon = day['day']?['condition']?['icon'] ?? '';
                final maxtemp = day['day']?['maxtemp_c'] ?? '';
                final mintemp = day['day']?['mintemp_c'] ?? '';
                return ListTile(
                  leading: Image.network('https:$Icon',width: 40,),
                  title: Text(data),
                );
              }),




            ],
          ),
        )
        ),
      
    );
  }
}