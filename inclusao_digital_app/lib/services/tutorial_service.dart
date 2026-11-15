import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tutorial_model.dart';

class TutorialService {
  final String apiUrl = 'https://legendary-space-eureka-pxxpgvq7jwv26wq6-8080.app.github.dev/api/tutorials';

  Future<List<Tutorial>> fetchTutorials() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List body = json.decode(response.body);
        return body.map((item) => Tutorial.fromJson(item)).toList();
      } else {
        throw Exception('Falha ao carregar os tutoriais');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
