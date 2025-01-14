import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_health_app/chatbot/chatbot_model.dart';
import 'package:mental_health_app/repository/firebase_repostiories.dart';

class ChatbotConversationRepository {
  Future<DocRef> createConversation(
      {required Message firstMessage,
      required String uid,
      required String model}) async {
    print("calling creating a convo");
    final time = DateTime.now();

    final conversationRef = await firestore.chatbotConversations.add({
      "uid": uid,
      "model": model,
      "name": firstMessage.message,
      "date_accessed": time,
      "date_created": time,
    });
    // todo failure tolerance
    final messagesRef =
        conversationRef.collection("messages").add(firstMessage.toJson());
    return conversationRef as DocRef;
  }

  Future<QuerySnapshot> getConversations({required String uid}) {
    final query = firestore.chatbotConversations
        .where("uid", isEqualTo: uid)
        .orderBy("date_accessed", descending: false);
    return query.get();
  }

  Future<QuerySnapshot> getMessages(DocRef conversationRef) {
    final query = conversationRef
        .collection("messages")
        .orderBy("time_created", descending: false)
        .limit(50);
    return query.get();
  }

  Future<DocumentReference> addMessage(
      {required DocRef conversationRef, required Message message}) {
    return conversationRef.collection("messages").add(message.toJson());
  }

  DocRef getConversationRef({required String id}) {
    return firestore.chatbotConversations.doc(id) as DocRef;
  }
}
