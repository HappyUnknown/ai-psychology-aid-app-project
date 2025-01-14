import 'package:cloud_firestore/cloud_firestore.dart';

typedef DocRef = DocumentReference<Map<String, dynamic>>;

typedef DocSnapshot = DocumentSnapshot<Map<String, dynamic>>;

final firestore = FirebaseFirestore.instance;


extension Repositories on FirebaseFirestore {

  CollectionReference get chatbotConversations => firestore.collection("chatbot_conversations");
  
}