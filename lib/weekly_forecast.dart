import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyForecast extends StatefulWidget {
  final Map<String, dynamic> currentValue;
  final String city;
  final List<dynamic> pastWeek;
  final List<dynamic> next7days;

  const WeeklyForecast({
    super.key,
    required this.city,
    required this.currentValue,
    required this.pastWeek,
    required this.next7days,
  });

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.grey.shade900;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.grey.shade900, Colors.grey.shade800]
                : [Colors.blue.shade200, Colors.blue.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // City info
                Center(
                  child: Column(
                    children: [
                      Text(
                        widget.city,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 36,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${widget.currentValue['temp_c']}°C",
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${widget.currentValue['condition']['text'] ?? ''}",
                        style: TextStyle(
                          fontSize: 20,
                          color: textColor.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 10),
                      widget.currentValue['condition']?['icon'] != null
                          ? Image.network(
                              "https:${widget.currentValue['condition']['icon']}",
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            )
                          : const SizedBox(height: 150),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Next 7 days
                Text(
                  "Next 7 Days Forecast",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: widget.next7days.map((day) {
                    final data = day['date'] ?? "";
                    final condition = day['day']?['condition']?['text'] ?? '';
                    final icon = day['day']?['condition']?['icon'] ?? '';
                    final maxTemp = day['day']?['maxtemp_c'] ?? '';
                    final minTemp = day['day']?['mintemp_c'] ?? '';
                    return Card(
                      color: isDark ? Colors.grey.shade800 : Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: icon.isNotEmpty
                            ? Image.network('https:$icon', width: 40)
                            : const SizedBox(width: 40),
                        title: Text(
                          formatApiData(data),
                          style: TextStyle(color: textColor),
                        ),
                        subtitle: Text(
                          "$condition | $minTemp°C - $maxTemp°C",
                          style: TextStyle(color: textColor.withOpacity(0.8)),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),
                // Previous 7 days
                Text(
                  "Previous 7 Days Forecast",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: widget.pastWeek.map((day) {
                    final forecastDay = day['forecast']?['forecastday'];
                    if (forecastDay == null || forecastDay.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    final forecast = forecastDay[0];
                    final data = forecast['date'] ?? "";
                    final condition = forecast['day']?['condition']?['text'] ?? '';
                    final icon = forecast['day']?['condition']?['icon'] ?? '';
                    final maxTemp = forecast['day']?['maxtemp_c'] ?? '';
                    final minTemp = forecast['day']?['mintemp_c'] ?? '';
                    return Card(
                      color: isDark ? Colors.grey.shade800 : Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: icon.isNotEmpty
                            ? Image.network('https:$icon', width: 40)
                            : const SizedBox(width: 40),
                        title: Text(
                          formatApiData(data),
                          style: TextStyle(color: textColor),
                        ),
                        subtitle: Text(
                          "$condition | $minTemp°C - $maxTemp°C",
                          style: TextStyle(color: textColor.withOpacity(0.8)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
