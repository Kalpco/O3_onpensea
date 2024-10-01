import 'dart:convert';
import 'package:http/http.dart' as http;

class MetalRatesController {
  final String apiKey = 'BPDRZCZQLNHZESB9IWNZ879B9IWNZ';
  final String baseUrl = 'https://api.metals.dev/v1/latest';


  Future<Map<String, dynamic>?> fetchMetalRates({String currency = 'INR', String unit = 'g'}) async {
    final url = Uri.parse('$baseUrl?api_key=$apiKey&currency=$currency&unit=$unit');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }
}
