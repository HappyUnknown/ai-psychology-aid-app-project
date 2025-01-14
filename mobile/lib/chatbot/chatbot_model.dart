import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mental_health_app/chatbot/chat_bot.dart';
import 'package:mental_health_app/chatbot/chat_gpt_bot.dart';
import 'package:mental_health_app/chatbot/conversation_model.dart';
import 'package:mental_health_app/repository/chatbot_conversation_repository.dart';
import 'package:mental_health_app/repository/firebase_repostiories.dart';
import 'package:mental_health_app/services/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chatbot_model.g.dart';

@riverpod
class ChatbotModel extends _$ChatbotModel {
  ChatBot chatBot = ChatGptBot();
  final _conversationRepo = ChatbotConversationRepository();

  @override
  Future<ConversationModel> build() async {
    return ConversationModel("Start a Conversation", [
      // Message.withDate("Hello", true),
      // Message.withDate("Hi there", false),
      // Message.withDate("Hello", true),
      // Message.withDate("Hi there", false),
      // Message.withDate("Hello", true),
      // Message.withDate("Hi there", false),
      // Message.withDate("Hello", true),
      // Message.withDate("Hi there", false),
      // Message.withDate("Helloo", true),
    ]);
  }

  Future<void> addUserMessage(String message) async {
    await _addMessage(Message.withDate(message, false));
    await addChatBotMessage(message);
  }

  Future<void> _addMessage(Message message) async {
    // add to firebase
    // final model = await future;
    // List<Message> messages = model.messages;

    late final DocRef collectionRef;
    late final String name;

    final data = await future;

    if (data.conversationRef == null) {
      collectionRef = await _conversationRepo.createConversation(
        firstMessage: message,
        uid: ref.read(currentUidProvider),
        model: "unspecifed",
      );
      name = message.message;
      // await getFromConversationRef(collectionRef);
    } else {
      name = data.name;
      collectionRef = data.conversationRef!;
    }

    List<Message> messages = data.messages;
    messages.add(message);
    state = AsyncData(data.copyWith(
      messages: messages,
      name: name,
      conversationRef: collectionRef,
    ));
    await _conversationRepo.addMessage(
      conversationRef: collectionRef,
      message: message,
    );
  }

  Future<void> getFromConversationRef(ConversationDataModel model) async {
    final collectionRef = _conversationRepo.getConversationRef(id: model.id);
    QuerySnapshot<Object?> querySnap =
        await _conversationRepo.getMessages(collectionRef);

    print(querySnap.docs.map((e) => e.data()!));

    

    final List<Message> messages = querySnap.docs
        .map((e) => Message.fromJson(e.data()! as Map<String, dynamic>))
        .toList();

    state = AsyncData(ConversationModel(
      model.name,
      messages,
      conversationRef: collectionRef,
    ));

    // if (querySnap.docs.isEmpty) {
    //   print("snapshot is empty not changing the conversation");

    // } else {

    // }
  }

  Future<void> addChatBotMessage(String answerTo) async {
    print("chat bot is initiated a reponse");
    String response = "Hello back"; // await chatBot.respond(answerTo);
    print("Response fron inside chatbotMessage: $response");
    await _addMessage(Message.withDate(response, true));
  }
}

class ConversationModel {
  final String name;
  // final DateTime created;
  final DocRef? conversationRef;
  final List<Message> messages;
  ConversationModel(this.name, this.messages, {this.conversationRef});

  ConversationModel copyWith(
      {String? name, List<Message>? messages, DocRef? conversationRef}) {
    return ConversationModel(name ?? this.name, messages ?? this.messages,
        conversationRef: conversationRef ?? this.conversationRef);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
@immutable
class Message {
  final String message;
  final DateTime timeCreated;
  final String role;
  bool get fromChatBot => role == "user";
  const Message(this.message, this.timeCreated, this.role);

  factory Message.withDate(String text, bool fromChatBot) {
    return Message(text, DateTime.now(), fromChatBot ? "user" : "model");
  }

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
