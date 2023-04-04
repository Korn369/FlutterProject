// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

class WeatherData
{
  void getWeather(double latitude, double longitude) async
  {
    // ignore: avoid_print
    print("DOES IT BUG HERE?");

    String uri = "https://api.openweathermap.org/data/2.5/weather?lat=${latitude}&lon=${longitude}&appid=${"6c58923892d0acae68b806de8279eb68"}";

    final res = await http.get(uri);

    // ignore: avoid_print
    print(res.body);
  }

}