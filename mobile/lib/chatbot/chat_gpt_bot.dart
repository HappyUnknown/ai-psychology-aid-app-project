import 'package:mental_health_app/chatbot/chat_bot.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatGptBot implements ChatBot {

  final String apiKey = "apiKey";//

  final messageLog = [];

  @override
  void consume(message) {
    // TODO: implement consume
  }

  @override
  Future<String> respond(String userMessage) async {
    print("actual service");
    const apiUrl = 'https://ec2-16-171-53-67.eu-north-1.compute.amazonaws.com:8080/v1/chat/completions';

    messageLog.add({"role" : "user", "content" : userMessage});


    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer demo',
      },
      body: jsonEncode({
        "model": "gemma2:2b",
        'messages': [
          {
            "role": "user",
            "content":
                "You are a psychological assitant, for current soldiers, please comfort them and provide guidance. Respond to the last message with care and attention"
          },
          ...messageLog
        ],
        'max_tokens': 50,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> choices = data['choices'] as List<dynamic>;

      if (choices.isNotEmpty) {
        final Map<String, dynamic> choice = choices[0] as Map<String, dynamic>;
        final Map<String, dynamic> message =
            choice["message"] as Map<String, dynamic>;
        print(message.runtimeType);
        print(message['content']);

        print("content ${message['content']}");
        messageLog.add({"role" : "assistant", "content" : message['content'] as String});

        return message['content'] as String;
      } else {
        throw Exception('No choices found in the response');
      }
    } else {
      throw Exception('Failed to fetch response: ${response.statusCode}');
    }
  }
}



class LLama implements ChatBot {

  final String llamaUrl = "http://10.0.2.2:8003/api/chat";

  final messageLog = [];

  @override
  void consume(message) {
    // TODO: implement consume
  }

  @override
  Future<String> respond(String userMessage) async {
    print("response has been added");

    messageLog.add({"role" : "user", "content" : userMessage});

    print(messageLog);


    final response = await http.post(
      Uri.parse(llamaUrl),
      body: jsonEncode({
        "model": "llama3.1:8b",
        'messages': [
          {
            "role": "user",
            // TODO make sure this language is language dependent
            "content":
                "You are a psychological assitant, for current soldiers, please comfort them and provide guidance. Respond to the last message with care and attention"
          },
          ...messageLog
        ],
        "stream": false
      },
      ),
    );

    print("response has status {${response.statusCode}}");

    if (response.statusCode == 200) {
      print("body ${response.body}");

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      // final List<dynamic> choices = data['choices'] as List<dynamic>;
      // final message = data['message']['content']

      print("new response is from {${data}}");


      final Map<String, dynamic> message = data['message'];

      messageLog.add(message);

      return message['content'] as String;
      
    } else {
      throw Exception('Failed to fetch response: ${response.statusCode}');
    }
  }
}
