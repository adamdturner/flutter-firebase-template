# Services

## Purpose
Service files handle external interactions including Firebase Cloud Functions and third-party APIs. They act as intermediaries between the app and the outside world.

## Key Requirements
- Very similar to repository files, except services don't do any firestore reads or writes
- Service files should be used for calling firebase cloud functions or any external API's from third party services
- Any interaction from the app to the outside world should involve a service file to act as the intermediary
- Each method in these files should also have a try-catch block with a debugPrint (only in debug mode)
- Never perform cloud function calls or API requests directly from UI or BLoC files
- Use service config file for API endpoints and URLs

## Service Structure
1. **Dependencies**: Firebase Functions or API client instances
2. **Methods**: Each method calls a specific cloud function or API endpoint
3. **Error Handling**: Try-catch with debug prints and descriptive errors
4. **Response Parsing**: Convert API responses to usable data

## Example

```dart
class AuthService {
  final _functions = FirebaseFunctions.instance;

  // Call cloud function to set user role
  Future<void> setUserRole({
    required String uid,
    required String role,
  }) async {
    try {
      final callable = _functions.httpsCallableFromUrl(
        ServiceConfig.setUserRoleURL,
      );
      
      final response = await callable.call({
        'uid': uid,
        'role': role,
      });

      final data = response.data;
      if (data['error'] == true) {
        throw Exception('Auth Service Error: ${data['message']}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Auth Service Error: failed to set user role - $e');
      }
      if (e.toString().contains('Auth Service Error')) {
        rethrow;
      }
      throw Exception('Auth Service Error: failed to set user role - ${e.toString()}');
    }
  }
}

// Example for third-party API
class WeatherService {
  final _httpClient = http.Client();

  // Fetch weather data from external API
  Future<WeatherData> fetchWeather(String location) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('${ServiceConfig.weatherApiUrl}?location=$location'),
        headers: {'Authorization': 'Bearer ${ServiceConfig.weatherApiKey}'},
      );

      if (response.statusCode != 200) {
        throw Exception('Weather Service Error: API returned ${response.statusCode}');
      }

      final data = json.decode(response.body);
      return WeatherData.fromJson(data);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Weather Service Error: failed to fetch weather - $e');
      }
      throw Exception('Weather Service Error: failed to fetch weather - ${e.toString()}');
    }
  }
}
```
