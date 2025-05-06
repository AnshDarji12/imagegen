import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/generation_result.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000'; // For Android Emulator
  // Use 'http://localhost:5000' for iOS simulator
  // Use your actual server IP for physical devices

  Future<GenerationResult> generateImage(
    String prompt,
    String modelName,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/generate_image'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'prompt': prompt,
          'model_name': modelName,
          'width': 512,
          'height': 512,
        }),
      );

      if (response.statusCode == 200) {
        return GenerationResult.fromJson(jsonDecode(response.body));
      } else {
        return GenerationResult.error('Server error: ${response.statusCode}');
      }
    } catch (e) {
      return GenerationResult.error('Network error: $e');
    }
  }

  Future<List<String>> getAvailableModels() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/available_models'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data['models']);
      } else {
        throw Exception('Failed to load models');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
