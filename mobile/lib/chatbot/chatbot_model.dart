import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_health_app/chatbot/chat_bot.dart';
import 'package:mental_health_app/chatbot/chat_gpt_bot.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chatbot_model.g.dart';

@riverpod
class ChatbotModel extends _$ChatbotModel {
  ChatBot chatBot = ChatGptBot();

  @override
  Future<List<Message>> build() async {
    return [
      Message.withDate("Hello", true),
      Message.withDate("Hi there", false),
      Message.withDate("Hello", true),
      Message.withDate("Hi there", false),
      Message.withDate("Hello", true),
      Message.withDate("Hi there", false),
      Message.withDate("Hello", true),
      Message.withDate("Hi there", false),
      Message.withDate("Helloo", true),
      // Message.withDate("Hi thereeeee", false),
    ];
  }

  Future<void> addUserMessage(String message) async {
    _addMessage(Message.withDate(message, false));
    addChatBotMessage(message);
  }

  void _addMessage(Message message) async {
    List messages = await future;
    messages.add(message);
    ref.notifyListeners();
  }

  void addChatBotMessage(String answerTo) async {
    print("chat bot is initiated a reponse");
    String response = await chatBot.respond(answerTo);
    print("Response fron inside chatbotMessage: $response");
    _addMessage(Message.withDate(response, true));
  }
}

@immutable
class Message {
  final String message;
  final DateTime creationTime;
  final bool fromChatBot;
  const Message(this.message, this.creationTime, this.fromChatBot);

  factory Message.withDate(String text, bool fromChatBot) {
    return Message(text, DateTime.now(), fromChatBot);
  }
}
