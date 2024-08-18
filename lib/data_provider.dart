import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final dataProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final response = await http.get(Uri.parse(
      'https://api.data.gov.in/resource/eb8fb591-6cd4-4daf-9c7a-63bcab2c9c16?api-key=579b464db66ec23bdd000001ef380305d8b542a65919417238484719&format=json'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print(data);
    return List<Map<String, dynamic>>.from(data['records']);
  } else {
    throw Exception('Failed to load data');
  }
});
