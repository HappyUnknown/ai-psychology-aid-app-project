import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin ChatBot {
  Future<String> respond (String message);
  //void consume(message);
}

// final chatBotTestProvider = FutureProvider((ref) => ChatBotTest());
class ChatBotTest implements ChatBot {
  String? lastMessage;
  @override
  Future<String> respond(message) async {

    int randomDelay = Random().nextInt(200) + 1;
    await Future.delayed(Duration(milliseconds: randomDelay));

    String response =  "I am here to support you and help you through whatever you are going through. It's normal to have a range of emotions and feelings, especially during challenging times like being in the military. I am here to listen and provide guidance, so please feel";
    
    return response;
  }
  
  @override
  void consume(message) {
    lastMessage = message;
    // TODO: implement consume
  }
}
